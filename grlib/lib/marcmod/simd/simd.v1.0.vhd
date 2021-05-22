library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library grlib;
use grlib.stdlib.all;

library marcmod;
use marcmod.simdmod.all;

entity simd_module is 
    port(
            clk   : in  std_ulogic;
            rstn  : in  std_ulogic;
            holdn : in  std_ulogic;
            sdi   : in  simd_in_type;
            sdo   : out simd_out_type
        );
end;

architecture rtl of simd_module is
    ---------------------------------------------------------------
    -- REGISTER TYPES DEFINITION --
    --------------------------------------------------------------

    --vector register type
    subtype vector_component is std_logic_vector(VLEN-1 downto 0);
    type vector_reg_type is array (0 to VSIZE-1) of vector_component;

    type lpmul_in_array is array (0 to VSIZE-1) of lpmul_in_type;
    type lpmul_out_array is array (0 to VSIZE-1) of lpmul_out_type;

    type l1_sum_array is array (0 to VSIZE/2) of std_logic_vector(VLEN downto 0);
    type l2_sum_array is array (0 to VSIZE/4) of std_logic_vector(VLEN+1 downto 0);

    subtype word is std_logic_vector(XLEN-1 downto 0);

    -- mask registers (predicate)
    subtype mask_reg_type is std_logic_vector((XLEN/VLEN)-1 downto 0);

    -- stage 2 byte enable (result in byte x)
    subtype s2byteen_reg_type is std_logic_vector((XLEN/VLEN)-1 downto 0);

    -- swizzling registers (reordering)
    subtype log_length is integer range 0 to (XLEN/VLEN)-1;
    type swizzling_reg_type is array (0 to (XLEN/VLEN)-1) of log_length;

    type ctrl_reg_type is record
        mk : mask_reg_type;
        sa : swizzling_reg_type;
        sb : swizzling_reg_type;
        be : s2byteen_reg_type;
        ac : vector_reg_type;
    end record;

    -- Stage1 entry register
    type s1_reg_type is record
        ra : vector_reg_type;
        rb : vector_reg_type;
        op1: std_logic_vector(4 downto 0);
        op2: std_logic_vector(2 downto 0);
        en : std_logic;
    end record; 
    
    -- Stage2 entry register
    type s2_reg_type is record
        ra : vector_reg_type;
        op2: std_logic_vector(2 downto 0);
        sat: std_logic;
        en : std_logic;
    end record;

    -- Stage3 entry register
    type s3_reg_type is record
        rc : word;
    end record;


    -- Group of pipeline registers
    type registers is record
        s1 : s1_reg_type;
        s2 : s2_reg_type;
        s3 : s3_reg_type;
        ctr: ctrl_reg_type;
    end record;



    ---------------------------------------------------------------
    -- CONSTANTS FOR PIPELINE REGISTERS RESET --
    --------------------------------------------------------------
    constant vector_reg_res : vector_reg_type := (others => (others => '0'));

    -- set the 1st stage registers reset
    constant s1_reg_res : s1_reg_type := (
        ra => vector_reg_res,
        rb => vector_reg_res,
        op1 => (others => '0'),
        op2 => (others => '0'),
        en => '0'
    );

    -- set the 2nd stage registers reset
    constant s2_reg_res : s2_reg_type := (
        ra => vector_reg_res,
        op2 => (others => '0'),
        sat => '0',
        en => '0'
    );

    -- set the 3rd stage registers reset
    constant s3_reg_res : s3_reg_type := (
        rc => (others => '0')
    );

    function swizzling_init return swizzling_reg_type is
        variable res_val : swizzling_reg_type;
    begin
        for i in 0 to (XLEN/VLEN)-1 loop
            res_val(i) := i;
        end loop;
        return res_val;
    end function swizzling_init;

    function swizzling_set(sz_i : std_logic_vector(VSIZE*LOGSZ-1 downto 0)) return swizzling_reg_type is
        variable res_val : swizzling_reg_type;
    begin
        for i in 0 to (XLEN/VLEN)-1 loop
            res_val(i) := to_integer(unsigned(sz_i(i*LOGSZ+LOGSZ-1 downto i*LOGSZ)));
        end loop;
        return res_val;
    end function swizzling_set;

    function swizzling(data : vector_reg_type; sz : swizzling_reg_type) return vector_reg_type is
        variable result : vector_reg_type;
    begin
        for i in result'range loop
            result(i) := data(sz(i)); 
        end loop;
        return result;
    end function swizzling;

    constant ctrl_reg_res : ctrl_reg_type := (
        mk => (others => '1'),
        sa => swizzling_init,
        sb => swizzling_init,
        be =>(others => '0'),
        ac => vector_reg_res
    );

    -- reset all registers
    constant RRES : registers := (
        s1 => s1_reg_res,
        s2 => s2_reg_res,
        s3 => s3_reg_res,
        ctr=> ctrl_reg_res
    );

    ---------------------------------------------------------------
    -- FUNCTIONS
    --------------------------------------------------------------
    function to_vector(data : word) return vector_reg_type is
        variable vec : vector_reg_type;
    begin
        for i in vec'range loop
            vec(i) := data(VLEN*i+VLEN-1 downto VLEN*i);
        end loop;
        return vec;
    end;

    function to_word(vec : vector_reg_type) return word is
        variable data : word;
    begin
        for i in vec'range loop
            data(VLEN*i+VLEN-1 downto VLEN*i) := vec(i);
        end loop;
        return data;
    end;



    ---------------------------------------------------------------
    -- SIGNALS DEFINITIONS
    --------------------------------------------------------------
    --signals for the registers r -> current, rin -> next
    signal r, rin: registers;
    signal n_be : s2byteen_reg_type;
    signal n_ac : vector_reg_type;

    signal lpmuli : lpmul_in_array;
    signal lpmulo : lpmul_out_array;

    ---------------------------------------------------------------
    -- TWO OPERANDS OPERATIONS (S1) --
    --------------------------------------------------------------

    -- s1 result multiplexor
    procedure s1_mux(op : in std_logic_vector(4 downto 0);
                     sel: out std_logic_vector(3 downto 0)) is
    begin
        sel := '0' & op(2 downto 0);
        case op is
            when S1_SADD | S1_USADD => sel := "0001";
            when S1_SSUB | S1_USSUB => sel := "0010";
            when S1_SMUL | S1_USMUL => sel := "0011";
            when S1_AND | S1_OR | S1_XOR | S1_NAND | S1_NOR | S1_XNOR => 
                sel := "0111";
            when S1_MOVB => sel := "0100";
            when S1_SHFT | S1_SSHFT => sel := "1000";
            when others =>
        end case;
    end s1_mux;

    procedure s1_select(sel: in std_logic_vector(3 downto 0); 
                        ra, rs2, add_res, sub_res, max_res, min_res, logic_res, shift_res,  mul_res : in vector_reg_type;
                        s1_res : out vector_reg_type) is
    begin
        case sel is
            when "0000" => s1_res := ra;
            when "0001" => s1_res := add_res;
            when "0010" => s1_res := sub_res;
            when "0011" => s1_res := mul_res;
            when "0100" => s1_res := rs2;
            when "0101" => s1_res := max_res;
            when "0110" => s1_res := min_res;
            when "0111" => s1_res := logic_res;
            when "1000" => s1_res := shift_res;
            when others => s1_res := (others => (others => '0'));
        end case;
    end s1_select;
    
    procedure s2_select(sel : in std_logic_vector(2 downto 0);
                        ra, sum_res, max_res, min_res, xor_res : in word;
                        rc : out word) is 
    begin
        case sel is
            when "000" => rc := ra;
            when "001" | "101" => rc := sum_res;
            when "010" | "110" => rc := max_res;
            when "011" | "111" => rc := min_res;
            when "100" => rc := xor_res;
            when others =>rc := ra;
        end case;
    end s2_select;

    function sat_mux (asign, bsign, sign, sat, ovf : std_logic) return std_logic_vector is
        variable sel : std_logic_vector(1 downto 0);
    begin 
        sel := "00";     -- result as it is, no saturation
        if sat = '1' and ovf = '1' then 
            if sign = '1' then 
                if asign = '0' then
                    sel := "01";  -- result is 7f signed max
                else 
                    sel := "10";  -- result is 80 signed min
                end if;
            else
                sel := "11";  --  result is ff unsigned max
            end if;
        end if;
        return sel;
    end sat_mux;

    procedure sat_sel (sel : in std_logic_vector(1 downto 0);
                       r : in std_logic_vector;
                       res : out std_logic_vector) is
    begin
        case sel is
            when "00" => res := r;
            when "01" => res := '0' & (res'left-1 downto 0 => '1');
            when "10" => res := '1' & (res'left-1 downto 0 => '0');
            when "11" => res := (others => '1');
            when others => res := (others => '0');
        end case;
    end sat_sel;


    function add(a, b : vector_component;
                 sign, sat : std_logic) return vector_component is
        variable z : std_logic_vector(VLEN downto 0);
        variable mux : std_logic_vector(1 downto 0);
        variable res : vector_component;
        variable ovf : std_logic;
    begin
        z := ('0'&a) + ('0'&b);
        if sign = '1' then 
            ovf := (a(a'left) xnor b(b'left)) and (a(a'left) xor z(a'left));
        else ovf := z(z'left);
        end if;
        mux := sat_mux(a(a'left), b(b'left), sign, sat, ovf);
        sat_sel(mux, z(vector_component'range), res);
        return res;
    end add;

    function sum(a : vector_reg_type; sign, sat : std_logic) return word is 
        variable acc, res : std_logic_vector(VLEN+1 downto 0);
        variable tmp : l1_sum_array;
        variable mux : std_logic_vector(1 downto 0);
        variable ovf : std_logic;
        variable z : word;
    begin 
        z:= (others => '0');
        for i in 0 to VSIZE/2-1 loop 
            tmp(i) := ('0' & a(i*2)) + ('0' & a(i*2+1));
        end loop;
        acc :=  ('0' & tmp(0)) + ('0' & tmp(1));
        ovf := acc(acc'left) or acc(acc'left-1);
        if sign = '1' then
            if acc(acc'left-2) = '1' then
                ovf := acc(acc'left) nand acc(acc'left-1);
            end if;
        end if;
        mux := sat_mux(tmp(0)(tmp(0)'left), tmp(1)(tmp(1)'left), sign, sat, ovf);
        sat_sel(mux, acc, res);
        if(sign = '1') then
            if (sat = '1') then
                z := std_logic_vector(resize(signed(res), word'length));
            else 
                z := std_logic_vector(resize(signed(res(vector_component'range)), word'length));
            end if;
        else 
            z := std_logic_vector(resize(unsigned(res), word'length));
        end if;
        return z;
    end sum;

    function sub(a, b : vector_component;
                 sign, sat : std_logic) return vector_component is
        variable z : std_logic_vector(VLEN downto 0);
    begin
        z := ((sign and a(a'left))&a) - ((sign and b(b'left))&b);
        if sign = '1' and sat = '1' then
            if a(a'left) /= b(b'left) and a(a'left) /= z(a'left) then 
                if a(a'left) = '1' then 
                    z(vector_component'range) := '1'&(VLEN-2 downto 0 => '0');
                else 
                    z(vector_component'range) := '0'&(VLEN-2 downto 0 => '1');
                end if;
            end if;
        elsif sign = '0' and sat = '1' then
            if z(z'left) = '1' then 
                z(vector_component'range) := (others => '0');
            end if;
        end if;
        return z(vector_component'range);
    end sub;

    -- max function
    function max(a, b : vector_component;
                 sign : std_logic) return vector_component is 
        variable z : vector_component;
    begin
        if sign = '1' then 
            if signed(a) > signed(b) then z := a;
            else z := b;
            end if;
        else 
            if a > b then z := a;
            else z := b;
            end if;
        end if;
        return z;
    end max;

    --max recursive function
    function max_red(a : vector_reg_type; sign : std_logic) return word is
        variable acc : vector_component;
        variable z : word;
    begin
        acc := a(0);
        for i in 1 to VSIZE-1 loop
            acc := max(acc, a(i), sign);
        end loop;
        z := (others => (sign and acc(acc'left)));
        z(acc'range) := acc;
        return z;
    end max_red;
        

    -- min function
    function min(a, b : vector_component;
                 sign : std_logic) return vector_component is 
        variable z : vector_component;
    begin
        if sign = '1' then 
            if signed(a) > signed(b) then z := b;
            else z := a;
            end if;
        else 
            if a > b then z := b;
            else z := a;
            end if;
        end if;
        return z;
    end min;

    --min recursive function
    function min_red(a : vector_reg_type; sign : std_logic) return word is
        variable acc : vector_component;
        variable z : word;
    begin
        acc := a(0);
        for i in 1 to VSIZE-1 loop
            acc := min(acc, a(i), sign);
        end loop;
        z := (others => (sign and acc(acc'left)));
        z(acc'range) := acc;
        return z;
    end min_red;

    --logic operations
    function logic_op(a, b : vector_component;
                      op : std_logic_vector(2 downto 0)) return vector_component is
        variable z : vector_component;
    begin
        case op is 
            when "111" => z := a and b;
            when "000" => z := a or b;
            when "001" => z := a xor b;
            when "010" => z := a nand b;
            when "011" => z := a nor b;
            when "100" => z := a xnor b;
            when others => z := (others => '0');
        end case;
        return z;
    end logic_op;

    function shift(a, b : vector_component; sat : std_logic) return vector_component is
        variable z : vector_component;
        variable i : integer;
    begin
        i := to_integer(signed(b(b'left downto 1)));
        if b(b'left) = '1' then -- shift right
            if b(0) = '1' then -- arithmetic
                z := std_logic_vector(shift_right(signed(a), -i));
            else 
                z := std_logic_vector(shift_right(unsigned(a), -i));
            end if;
        else 
            z := std_logic_vector(shift_left(unsigned(a), i));
        end if;
        return z;
    end shift;

    function xor_red(a : vector_reg_type) return word is
        variable acc : vector_component;
    begin
        acc := a(0);
        for i in 1 to VSIZE-1 loop
            acc := a(i) xor acc;
        end loop;
        return std_logic_vector(resize(unsigned(acc), word'length));
    end xor_red;


    --apply mask to vector
    procedure mask(vector, original : in vector_reg_type;
                   msk : in std_logic_vector(VSIZE-1 downto 0);
                   msk_res : out vector_reg_type) is
    begin 
        msk_res := original;
        for i in msk'range loop
            if msk(i) = '1' then
                msk_res(i) := vector(i);
            end if;
        end loop;
    end mask;

    --apply shift and accumulate
    procedure shift_and_acc(be : in s2byteen_reg_type;
                           acc : in vector_reg_type;
                           data: in vector_reg_type;
                           res : out vector_reg_type;
                           nxt_be : out s2byteen_reg_type) is
        variable new_acc : vector_reg_type;
    begin
        new_acc := acc;
        for i in be'range loop
            if be(i) = '1' then
                new_acc(i) := data(0);
            end if;
        end loop;
        res := new_acc; nxt_be := be(be'left-1 downto 0) & '0';
    end shift_and_acc;


    ---------------------------------------------------------------
    -- REDUCTION OPERATIONS (S2) --
    --------------------------------------------------------------

begin
    ---------------------------------------------------------------
    -- MAIN BODY --
    --------------------------------------------------------------
    genmul : for i in 0 to XLEN/VLEN-1 generate
        mul : lpmul
            port map(lpmuli(i), lpmulo(i));
        end generate genmul;


    comb: process(r, sdi, lpmulo)
        variable v : registers;
        variable rs1, rs2 : vector_reg_type;
        variable s1_res : vector_reg_type;
        variable add_res, sub_res, mul_res, max_res, min_res, logic_res, shift_res: vector_reg_type;
        variable s1_alusel : std_logic_vector(3 downto 0);
        variable s2sum_res, s2max_res, s2min_res, s2xor_res : word;

        variable s2_res : word;
        variable nxt_acc : vector_reg_type;
        variable nxt_be : s2byteen_reg_type;
    begin
        v := r;

        -- INPUT TO CTRL
        if sdi.ctrl_reg_we = '1' then
            v.ctr.mk := sdi.mask_value;
            v.ctr.be := sdi.res_byte_en;
            v.ctr.sa := swizzling_set(sdi.swiz_veca); 
            v.ctr.sb := swizzling_set(sdi.swiz_vecb);
            v.ctr.ac := vector_reg_res;
        end if;

        -- INPUT TO S1 --
        v.s1.ra := to_vector(sdi.ra); --swizzling(to_vector(sdi.ra),r.ctr.sa);
        v.s1.rb := to_vector(sdi.rb); --swizzling(to_vector(sdi.rb),r.ctr.sb);
        v.s1.en := sdi.rc_we; v.s1.op1 := sdi.op1; v.s1.op2 := sdi.op2;


        --Swizzling
        rs1 := swizzling(r.s1.ra, r.ctr.sa);
        rs2 := swizzling(r.s1.rb, r.ctr.sb);

        for i in vector_reg_type'range loop
            lpmuli(i).opA <= rs1(i);
            lpmuli(i).opB <= rs2(i);
            lpmuli(i).sign <= not r.s1.op1(4);
            lpmuli(i).sat <= r.s1.op1(3);
        end loop;

        s1_mux(r.s1.op1, s1_alusel);
        -- S1 TO S2 --
        for i in vector_reg_type'range loop
            add_res(i) := add(rs1(i), rs2(i), not r.s1.op1(4), r.s1.op1(3));
            sub_res(i) := sub(rs1(i), rs2(i), not r.s1.op1(4), r.s1.op1(3));
            mul_res(i) := lpmulo(i).mul_res;
            max_res(i) := max(rs1(i), rs2(i), not r.s1.op1(4));
            min_res(i) := min(rs1(i), rs2(i), not r.s1.op1(4));
            logic_res(i) := logic_op(rs1(i), rs2(i), r.s1.op1(2 downto 0));
            shift_res(i) := shift(rs1(i), rs2(i), r.s1.op1(3));
        end loop;
        s1_select(s1_alusel, r.s1.ra, rs2, add_res, sub_res, max_res,
                  min_res, logic_res, shift_res, mul_res, s1_res);
        mask(s1_res, r.s1.ra, r.ctr.mk, v.s2.ra);

        v.s2.op2 := r.s1.op2; v.s2.sat := r.s1.op1(3); v.s2.en := r.s1.en;

        -- S2 TO S3 --
        s2sum_res := sum(r.s2.ra, not r.s2.op2(2), r.s2.sat);
        s2max_res := max_red(r.s2.ra, not r.s2.op2(2));
        s2min_res := min_red(r.s2.ra, not r.s2.op2(2));
        s2xor_res := xor_red(r.s2.ra);

        s2_select(r.s2.op2, to_word(r.s2.ra), s2sum_res, s2max_res, s2min_res, s2xor_res, s2_res);
        shift_and_acc(r.ctr.be, r.ctr.ac, to_vector(s2_res), nxt_acc, nxt_be);

        if r.s2.op2 /= S2_NOP and r.s2.en = '1' and r.ctr.be /= (s2byteen_reg_type'range => '0') then 
            v.s3.rc := to_word(nxt_acc);
            v.ctr.ac := nxt_acc;
            v.ctr.be := nxt_be;
        else 
            v.s3.rc := s2_res;
            if r.ctr.be = (s2byteen_reg_type'range => '0') then
                v.ctr.ac := vector_reg_res;
            end if;
        end if;

        -- S3 TO OUTPUT --
        sdo.simd_res <= r.s3.rc;
        sdo.s1bp <= to_word(v.s2.ra);
        sdo.s2bp <= v.s3.rc;

        -- Outputs
        rin <= v;
    end process;


    ---------------------------------------------------------------
    -- REGISTER UPDATING --
    --------------------------------------------------------------
    reg : process (clk) 
    begin
        if rising_edge(clk) then
            if (holdn = '1') then
                r <= rin;
            --else 
            end if;
            if (rstn = '0') then 
                r <= RRES;
            end if;
        end if;
    end process;

end; 


