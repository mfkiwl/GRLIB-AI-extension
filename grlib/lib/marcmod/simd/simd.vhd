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


    type lpmul_in_array is array (0 to VSIZE-1) of lpmul_in_type;
    type lpmul_out_array is array (0 to VSIZE-1) of lpmul_out_type;

    type l1_sum_array is array (0 to VSIZE/2) of std_logic_vector(VLEN downto 0);
    type l2_sum_array is array (0 to VSIZE/4) of std_logic_vector(VLEN+1 downto 0);



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
        ra : inter_reg_type;
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
        rdh: vector_reg_type;
    end record;



    ---------------------------------------------------------------
    -- CONSTANTS FOR PIPELINE REGISTERS RESET --
    --------------------------------------------------------------
    constant vector_reg_res : vector_reg_type := (others => (others => '0'));
    constant inter_reg_res : inter_reg_type := (others => (others => '0'));

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
        ra => inter_reg_res,
        op2 => (others => '0'),
        sat => '0',
        en => '0'
    );

    -- set the 3rd stage registers reset
    constant s3_reg_res : s3_reg_type := (
        rc => (others => '0')
    );


    -- reset all registers
    constant RRES : registers := (
        s1 => s1_reg_res,
        s2 => s2_reg_res,
        s3 => s3_reg_res,
        rdh=> vector_reg_res
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
    function to_vector(data : inter_reg_type; high : boolean) return vector_reg_type is
        variable vec : vector_reg_type;
    begin
        for i in vec'range loop
            if high then 
                vec(i) := data(i)(data(i)'left downto vec(i)'length);
            else 
                vec(i) := data(i)(vec(i)'range);
            end if;
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

    function to_word(vec : inter_reg_type) return word is
        variable data : word;
    begin
        for i in vec'range loop
            data(VLEN*i+VLEN-1 downto VLEN*i) := vec(i)(vector_component'range);
        end loop;
        return data;
    end;

    function swizzling(data : vector_reg_type; sz : swizzling_reg_type) return vector_reg_type is
        variable result : vector_reg_type;
    begin
        for i in result'range loop
            result(i) := data(sz(i)); 
        end loop;
        return result;
    end function swizzling;

    ---------------------------------------------------------------
    -- SATURATION FUNCTIONS
    --------------------------------------------------------------
    function clipping (value, max_val, min_val : integer) return integer is
    begin
        if value > max_val then return max_val;
        elsif value < min_val then return min_val;
        else return value;
        end if;
    end clipping;

    function extend(value : std_logic_vector; sign : std_logic; size : integer) return std_logic_vector is 
    begin
        if sign = '1' then 
            return std_logic_vector(resize(signed(value), size));
        else 
            return std_logic_vector(resize(unsigned(value), size));
        end if;
    end extend;

    function signed_sat(a, leng : integer; sat : std_logic) return std_logic_vector is
    begin
        if sat = '1' then
            return std_logic_vector(to_signed(clipping(a, 127, -128), leng));
        else return std_logic_vector(to_signed(a, leng));
        end if;
    end signed_sat;

    function unsigned_sat(a, leng : integer; sat : std_logic) return std_logic_vector is
    begin
        if sat = '1' then
            return std_logic_vector(to_unsigned(clipping(a, 255, 0), leng));
        else return std_logic_vector(to_signed(a, leng));
        end if;
    end unsigned_sat;

    ---------------------------------------------------------------
    -- SIGNALS DEFINITIONS
    --------------------------------------------------------------
    --signals for the registers r -> current, rin -> next
    signal r, rin: registers;

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
                        ra, rs2, add_res, sub_res, max_res, min_res, logic_res, shift_res,  mul_res : in inter_reg_type;
                        s1_res : out inter_reg_type) is
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

    function add(a, b : vector_component;
                 sign, sat : std_logic) return std_logic_vector is
        variable z : integer;
    begin
        if sign = '1' then 
            z := to_integer(signed(a)) + to_integer(signed(b));
            return signed_sat(z, high_prec_component'length, sat);
        else 
            z := to_integer(unsigned(a)) + to_integer(unsigned(b));
            return unsigned_sat(z, high_prec_component'length, sat);
        end if;
    end add;


    function sub(a, b : vector_component;
                 sign, sat : std_logic) return std_logic_vector is
        variable z : integer range -512 to 512;
    begin
        if sign = '1' then 
            z := to_integer(signed(a)) - to_integer(signed(b));
            return signed_sat(z, high_prec_component'length, sat);
        else 
            z := to_integer(signed(a)) - to_integer(signed(b));
            return unsigned_sat(z, high_prec_component'length, sat);
        end if;
    end sub;

    -- max function
    function max(a, b : vector_component;
                 sign : std_logic) return high_prec_component is 
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
        return extend(z, sign, high_prec_component'length);
    end max;
        

    -- min function
    function min(a, b : vector_component;
                 sign : std_logic) return high_prec_component is 
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
        return extend(z, sign, high_prec_component'length);
    end min;

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


    function shift_lp(a, b : vector_component; sat : std_logic) return high_prec_component is
        variable z : high_prec_component;
        variable i : integer;
        variable c : high_prec_component;
    begin
        i := to_integer(signed(b(b'left downto 1)));
        c := extend(a, b(0), high_prec_component'length);
        if b(b'left) = '1' then -- shift right
            if b(0) = '1' then -- arithmetic
                z := std_logic_vector(shift_right(signed(c), -i));
            else 
                z := std_logic_vector(shift_right(unsigned(c), -i));
            end if;
        else 
            z := std_logic_vector(shift_left(unsigned(c), i));
        end if;
        return z;
    end shift_lp;

    function shift_hp(a, b, rdh : vector_component; sat : std_logic) return high_prec_component is
        variable z : high_prec_component;
        variable i : integer;
        variable c : high_prec_component;
    begin
        i := to_integer(signed(b(b'left downto 1)));
        c := rdh & a;
        if b(b'left) = '1' then -- shift right
            if b(0) = '1' then -- arithmetic
                z := std_logic_vector(shift_right(signed(c), -i));
            else 
                z := std_logic_vector(shift_right(unsigned(c), -i));
            end if;
        else 
            z := std_logic_vector(shift_left(unsigned(c), i));
        end if;
        return z;
    end shift_hp;

    function shift(a, b, rdh : vector_component; sat, hp : std_logic) return high_prec_component is
        variable z : high_prec_component;
    begin
        if hp = '1' then 
            z := shift_hp(a,b,rdh,sat);
        else 
            z := shift_lp(a,b,sat);
        end if;
        return z;
    end shift;



    --apply mask to vector
    procedure mask(vector, original : in inter_reg_type;
                   msk : in std_logic_vector(VSIZE-1 downto 0);
                   pas_ra : in std_logic;
                   msk_res : out inter_reg_type) is
    begin 
        if pas_ra = '1' then 
            msk_res := original;
        else 
            msk_res := (others => (others => '0'));
        end if;
        for i in msk'range loop
            if msk(i) = '1' then
                msk_res(i) := vector(i);
            end if;
        end loop;
    end mask;

    --apply shift and accumulate
    --procedure shift_and_acc(be : in s2byteen_reg_type;
    --                       acc : in vector_reg_type;
    --                       data: in vector_reg_type;
    --                       res : out vector_reg_type;
    --                       nxt_be : out s2byteen_reg_type) is
    --    variable new_acc : vector_reg_type;
    --begin
    --    new_acc := acc;
    --    for i in be'range loop
    --        if be(i) = '1' then
    --            new_acc(i) := data(0);
    --        end if;
    --    end loop;
    --    res := new_acc; nxt_be := be(be'left-1 downto 0) & '0';
    --end shift_and_acc;


    ---------------------------------------------------------------
    -- REDUCTION OPERATIONS (S2) --
    --------------------------------------------------------------
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

    function sum(a : inter_reg_type; sign, sat : std_logic) return word is 
        variable acc : integer := 0;
    begin 
        if sign = '1' then 
            for i in 0 to VSIZE-1 loop
                acc := acc + to_integer(signed(a(i)));
            end loop;
            return signed_sat(acc, word'length, sat);
        else 
            for i in 0 to VSIZE-1 loop
                acc := acc + to_integer(unsigned(a(i)));
            end loop;
            return unsigned_sat(acc, word'length, sat);
        end if;
    end sum;

    --max recursive function
    function max_red(a : inter_reg_type; sign : std_logic) return word is
        variable acc : integer;
    begin
        if sign = '1' then 
            acc := to_integer(signed(a(0)));
            for i in 1 to VSIZE-1 loop
                if to_integer(signed(a(i))) > acc then 
                    acc := to_integer(signed(a(i)));
                end if;
            end loop;
        else 
            acc := to_integer(unsigned(a(0)));
            for i in 1 to VSIZE-1 loop
                if to_integer(unsigned(a(i))) > acc then 
                    acc := to_integer(unsigned(a(i)));
                end if;
            end loop;
        end if;
        return unsigned_sat(acc, word'length, '0');
    end max_red;

    --min recursive function
    function min_red(a : inter_reg_type; sign : std_logic) return word is
        variable acc : integer;
    begin
        if sign = '1' then 
            acc := to_integer(signed(a(0)));
            for i in 1 to VSIZE-1 loop
                if to_integer(signed(a(i))) < acc then 
                    acc := to_integer(signed(a(i)));
                end if;
            end loop;
        else 
            acc := to_integer(unsigned(a(0)));
            for i in 1 to VSIZE-1 loop
                if to_integer(unsigned(a(i))) < acc then 
                    acc := to_integer(unsigned(a(i)));
                end if;
            end loop;
        end if;
        return unsigned_sat(acc, word'length, '0');
    end min_red;

    function xor_red(a : inter_reg_type) return word is
        variable acc : vector_component;
    begin
        acc := a(0)(vector_component'range);
        for i in 1 to VSIZE-1 loop
            acc := a(i)(vector_component'range) xor acc;
        end loop;
        return std_logic_vector(resize(unsigned(acc), word'length));
    end xor_red;

    function sign_ext(op1 : std_logic_vector(4 downto 0); op2 : std_logic_vector(2 downto 0)) return std_logic is
        variable sign : std_logic;
    begin
        sign := not op1(4);
        case op1 is 
            when S1_ADD | S1_NOP | S1_MOVB => 
                sign := not op2(2) and (op2(1) or op2(0));
            when others =>
        end case;
        return sign;
    end sign_ext;

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
        variable s1_res : inter_reg_type;
        variable s1_ra, s1_r2, add_res, sub_res, mul_res, max_res, min_res, logic_res, shift_res: inter_reg_type;
        variable s1_alusel : std_logic_vector(3 downto 0);
        variable s2sum_res, s2max_res, s2min_res, s2xor_res : word;

        variable sign : std_logic;
        variable s2_res : word;
        --variable nxt_acc : vector_reg_type;
        --variable nxt_be : s2byteen_reg_type;
    begin
        v := r;

        -- INPUT TO S1 --
        v.s1.ra := to_vector(sdi.ra); --swizzling(to_vector(sdi.ra),r.ctr.sa);
        v.s1.rb := to_vector(sdi.rb); --swizzling(to_vector(sdi.rb),r.ctr.sb);
        v.s1.en := sdi.rc_we; v.s1.op1 := sdi.op1; v.s1.op2 := sdi.op2;


        --Swizzling
        rs1 := swizzling(r.s1.ra, sdi.ctrl.sa);
        rs2 := swizzling(r.s1.rb, sdi.ctrl.sb);

        for i in vector_reg_type'range loop
            lpmuli(i).opA <= rs1(i);
            lpmuli(i).opB <= rs2(i);
            lpmuli(i).sign <= not r.s1.op1(4);
            lpmuli(i).sat <= r.s1.op1(3);
        end loop;

        sign := sign_ext(r.s1.op1, r.s1.op2);
        s1_mux(r.s1.op1, s1_alusel);
        -- S1 TO S2 --
        for i in vector_reg_type'range loop
            add_res(i) := add(rs1(i), rs2(i), sign, r.s1.op1(3));
            sub_res(i) := sub(rs1(i), rs2(i), sign, r.s1.op1(3));
            mul_res(i) := lpmulo(i).mul_res;
            max_res(i) := max(rs1(i), rs2(i), sign);
            min_res(i) := min(rs1(i), rs2(i), sign);
            shift_res(i) := shift(rs1(i), rs2(i), r.rdh(i), r.s1.op1(3), sdi.ctrl.hp);
            logic_res(i) := extend(logic_op(rs1(i), rs2(i), r.s1.op1(2 downto 0)), '0', high_prec_component'length);
            s1_ra(i)     := extend(r.s1.ra(i), sign, high_prec_component'length);
            s1_r2(i)     := extend(rs2(i), sign, high_prec_component'length);
        end loop;
        s1_select(s1_alusel, s1_ra, s1_r2, add_res, sub_res, max_res,
                  min_res, logic_res, shift_res, mul_res, s1_res);
        mask(s1_res, s1_ra, sdi.ctrl.mk, sdi.ctrl.ms, v.s2.ra);

        v.s2.op2 := r.s1.op2; v.s2.sat := r.s1.op1(3); v.s2.en := r.s1.en;
        v.rdh := to_vector(v.s2.ra, true);

        -- S2 TO S3 --
        s2sum_res := sum(r.s2.ra, not r.s2.op2(2), r.s2.sat);
        s2max_res := max_red(r.s2.ra, not r.s2.op2(2));
        s2min_res := min_red(r.s2.ra, not r.s2.op2(2));
        s2xor_res := xor_red(r.s2.ra);

        s2_select(r.s2.op2, to_word(r.s2.ra), s2sum_res, s2max_res, s2min_res, s2xor_res, s2_res);
        --shift_and_acc(sdi.ctrl.be, sdi.ctrl.ac, to_vector(s2_res), nxt_acc, nxt_be);
        v.s3.rc := s2_res;

       -- if r.s2.op2 /= S2_NOP and r.s2.en = '1' and sdi.ctrl.be /= (s2byteen_reg_type'range => '0') then 
       --     v.s3.rc := to_word(nxt_acc);
       --     sdi.ctrl.ac := nxt_acc;
       --     v.ctr.be := nxt_be;
       -- else 
       --     v.s3.rc := s2_res;
       --     if r.ctr.be = (s2byteen_reg_type'range => '0') then
       --         v.ctr.ac := vector_reg_res;
       --     end if;
       -- end if;

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

    ---------------------------------------------------------------
    -- PRINT SIMD VERSION --
    --------------------------------------------------------------
    x : process
    begin
        wait for 5 * 1 ns;
        print("AI SIMD version: " & simd_version);
        wait;
    end process;

end; 


