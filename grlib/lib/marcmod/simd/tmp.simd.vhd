library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library grlib;
use grlib.stdlib.all;

library marcmod;
use marcmod.simdmod.all;

entity simd is 
    generic(
            XLEN : integer := 32;
            VLEN : integer range 0 to 32 := 8;
            RSIZE: integer := 5;
            LOGSZ: integer := 2 --integer(ceil(log2(real(XLEN/VLEN))))
           );
    port(
            -- general inputs
            clk   : in  std_ulogic;
            rstn  : in  std_ulogic;
            holdn : in  std_ulogic;
            
            -- signals for debug 
            inst  : in  std_logic_vector(31 downto 0);
            rc_we_i   : in std_logic;
            rc_addr_i : in std_logic_vector (RSIZE-1 downto 0);

            -- vector operations inputs
            ra_i  : in  std_logic_vector (XLEN-1 downto 0);
            rb_i  : in  std_logic_vector (XLEN-1 downto 0);
            op_i  : in  std_logic_vector (7 downto 0);

            -- memory bypass input
            ldbpa_i : in std_logic;
            ldbpb_i : in std_logic;
            lddata_i: in  std_logic_vector (XLEN-1 downto 0);

            -- mask modification inputs
            ctrl_reg_we_i : in std_logic;
            mask_value_i  : in std_logic_vector((XLEN/VLEN)-1 downto 0);
            res_byte_en_i : in std_logic_vector((XLEN/VLEN)-1 downto 0);
            swiz_veca_i   : in std_logic_vector(XLEN/VLEN*LOGSZ-1 downto 0);
            swiz_vecb_i   : in std_logic_vector(XLEN/VLEN*LOGSZ-1 downto 0);

            -- outputs
            rc_data_o : out std_logic_vector (XLEN-1 downto 0);
            s1bp_o : out std_logic_vector (XLEN-1 downto 0); -- data from stage 1 to bypass if needed
            s2bp_o : out std_logic_vector (XLEN-1 downto 0) -- data from stage 2 to bypass if needed
            --exceptions out 
        );
end;

architecture rtl of simd is

    constant VSIZE : integer := XLEN/VLEN;

---------------------------------------------------------------
-- REGISTER TYPES DEFINITION --
--------------------------------------------------------------

    --vector register type
    subtype vector_component is std_logic_vector(VLEN-1 downto 0);
    type vector_reg_type is array (0 to VSIZE-1) of vector_component;
    type s2l1 is array (0 to VSIZE/2-1) of std_logic_vector(VLEN downto 0);

    subtype word is std_logic_vector(XLEN-1 downto 0);

    -- mask registers (predicate)
    subtype mask_reg_type is std_logic_vector(VSIZE-1 downto 0);

    -- stage 2 byte enable (result in byte x)
    subtype s2byteen_reg_type is std_logic_vector(VSIZE-1 downto 0);

    -- swizling registers (reordering)
    subtype log_length is integer range 0 to VSIZE-1;
    type swizling_reg_type is array (0 to VSIZE-1) of log_length;

    -- Control registers for extra functions
    type ctrl_reg_type is record
        mk : mask_reg_type;
        sa : swizling_reg_type;
        sb : swizling_reg_type;
        be : s2byteen_reg_type;
        ac : vector_reg_type;
    end record;

    -- First stage register
    type s1_reg_type is record
        ra : vector_reg_type;
        rb : vector_reg_type;
        op1: std_logic_vector(4 downto 0);
        op2: std_logic_vector(2 downto 0);
        en : std_logic;
    end record;

    -- Second stage register
    type s2_reg_type is record
        ra : vector_reg_type;
        op2: std_logic_vector(2 downto 0);
        sat: std_logic;
        en : std_logic;
    end record;

    -- Third (return) stage register
    type s3_reg_type is record
        rc : vector_reg_type;
    end record;

    -- Set of pipeline registers
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

    constant s1_reg_res : s1_reg_type := (
        ra => vector_reg_res,
        rb => vector_reg_res,
        op1 => (others => '0'),
        op2 => (others => '0'),
        en => '0'
    );

    constant s2_reg_res : s2_reg_type := (
        ra => vector_reg_res,
        op2 => (others => '0'),
        sat => '0',
        en => '0'
    );

    constant s3_reg_res : s3_reg_type := (
        rc => vector_reg_res
    );

    function swizling_init return swizling_reg_type is
        variable res_val : swizling_reg_type;
    begin
        for i in 0 to VSIZE-1 loop
            res_val(i) := i;
        end loop;
        return res_val;
    end function swizling_init;

    function swizling_set(sz_i : std_logic_vector(VSIZE*LOGSZ-1 downto 0)) return swizling_reg_type is
        variable res_val : swizling_reg_type;
    begin
        for i in 0 to (VSIZE)-1 loop
            res_val(i) := to_integer(unsigned(sz_i(i*LOGSZ+LOGSZ-1 downto i*LOGSZ)));
        end loop;
        return res_val;
    end function swizling_set;

    constant ctrl_reg_res : ctrl_reg_type := (
        mk => (others => '1'),
        sa => swizling_init,
        sb => swizling_init,
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
    -- signals for the autoupdate of the control registers
    signal n_be : s2byteen_reg_type;
    signal n_ac : vector_reg_type;

    --Connexions from s1_reg to s2_reg
    signal rs1, rs2, bpdata, rd, rd_mask : vector_reg_type;

    --Connexions from s2_reg to s3_reg
    signal rd_l1 : s2l1;
    signal rd_l2 : std_logic_vector(VLEN+1 downto 0);
    signal s2res : vector_reg_type;
    


begin
    ---------------------------------------------------------------
    -- MAIN BODY --
    --------------------------------------------------------------
    -- CONTROL REGISTERS --
    control: process(ctrl_reg_we_i, mask_value_i, res_byte_en_i, swiz_veca_i, 
                     swiz_vecb_i, n_be, n_ac)
        variable vctr : ctrl_reg_type;
    begin
        vctr := r.ctr;
        vctr.be := n_be; vctr.ac := n_ac;
        if ctrl_reg_we_i = '1' then
            vctr.mk := mask_value_i;
            vctr.be := res_byte_en_i;
            vctr.sa := swizling_set(swiz_veca_i); 
            vctr.sb := swizling_set(swiz_vecb_i);
            vctr.ac := vector_reg_res;
        end if;
        rin.ctr <= vctr;
    end process;

    -- STAGE 1 REGISTERS --
    stage1 : process(inst, ra_i, rb_i, op_i, rc_we_i)
        variable vs1 : s1_reg_type;
    begin
        vs1 := r.s1;
        vs1.ra := to_vector(ra_i); vs1.en := rc_we_i;
        vs1.rb := to_vector(rb_i);
        vs1.op1:= op_i(4 downto 0); vs1.op2 := op_i(7 downto 5);

        rin.s1 <= vs1;
    end process;

    -- STAGE 1 OPERATIONS
    --bypass
    --bpdata <= to_vector(lddata_i);

    swizzling : for i in 0 to VSIZE-1 generate 
        rs1(i) <= --bpdata(r.ctr.sa(i)) when ldbpa_i = '1' else 
                  r.s1.ra(r.ctr.sa(i));
        rs2(i) <= --bpdata(r.ctr.sb(i)) when ldbpb_i = '1' else 
                  r.s1.rb(r.ctr.sb(i));
    end generate swizzling;

    alu : for i in 0 to VSIZE-1 generate
        alu8 : alu8b
            generic map (VLEN)
            port map(r.s1.op1, rs1(i), rs2(i), rd(i));
        end generate alu;

    mask : for i in 0 to VSIZE-1 generate
        rd_mask(i) <= rd(i) when r.ctr.mk(i)='1' else
                   r.s1.ra(i);
    end generate mask;

    -- STAGE 2 REGISTERS 
    stage2 : process(r.s1, rd_mask)
        variable vs2 : s2_reg_type;
    begin
        vs2 := r.s2;
        vs2.ra := rd_mask;
        vs2.op2 := r.s1.op2; vs2.en := r.s1.en;
        vs2.sat := r.s1.op1(3);

        rin.s2 <= vs2;
    end process;

    -- STAGE 2 OPERATIONS

    l1alu: for i in 0 to VSIZE/2 -1 generate 
        alu : redalu
            generic map(VLEN)
            port map(r.s2.op2, r.s2.sat, r.s2.ra(2*i), r.s2.ra(2*i+1), rd_l1(i));
        end generate l1alu;
    
    l2alu : redalu
        generic map (VLEN+1)
        port map(r.s2.op2, r.s2.sat, rd_l1(0), rd_l1(1), rd_l2);

    s2res <= r.s2.ra when r.s2.op2 = S2_NOP else
             to_vector((word'left downto rd_l2'length => (rd_l2(rd_l2'left) and not r.s2.op2(2))) & rd_l2);

    --STAGE 3 REGISTERS
    stage3 : process(s2res)
        variable vs3 : s3_reg_type;
    begin
        vs3 := r.s3;
        vs3.rc := s2res;
        rin.s3 <= vs3;
    end process;

    rc_data_o <= to_word(r.s3.rc);
    s1bp_o <= to_word(rin.s2.ra);
    s2bp_o <= to_word(rin.s3.rc);


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
