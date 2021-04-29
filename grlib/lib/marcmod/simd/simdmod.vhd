library ieee;
use ieee.std_logic_1164.all;
library grlib;
use grlib.stdlib.all;

package simdmod is

    constant XLEN : integer :=  32; --CFG_XLEN;
    constant VLEN : integer :=  8; --CFG_VLEN;
    constant LOGSZ : integer := 2; -- CFG_LOGSZ;
    constant VSIZE : integer := XLEN/VLEN;

    subtype word is std_logic_vector(XLEN-1 downto 0);

    --vector register type
    subtype vector_component is std_logic_vector(VLEN-1 downto 0);
    type vector_reg_type is array (0 to VSIZE-1) of vector_component;

    --interstage vector register type (high precision);
    subtype high_prec_component is std_logic_vector(VLEN downto 0);
    type inter_reg_type is array (0 to VSIZE-1) of high_prec_component;

    ------------------------------------------------------------
    -- SIMD CONTROL REGISTER --
    ------------------------------------------------------------
    -- mask registers (predicate)
    subtype mask_reg_type is std_logic_vector((XLEN/VLEN)-1 downto 0);

    -- output type selection
    subtype output_length_type is std_logic_vector(1 downto 0);

    -- duplicate output
    subtype output_dup_select is std_logic_vector((XLEN/VLEN)-1 downto 0);


    -- swizzling registers (reordering)
    subtype log_length is integer range 0 to (XLEN/VLEN)-1;
    type swizzling_reg_type is array (0 to (XLEN/VLEN)-1) of log_length;


    type simd_ctrl_reg_type is record
        mk : mask_reg_type;      -- mask value
        ms : std_logic;          -- mask selection (ra or 0)
        sa : swizzling_reg_type; -- swizzling ra
        sb : swizzling_reg_type; -- swizzling rb
        ol : output_length_type; -- output type (word/half/byte)
        od : output_dup_select;  -- output duplication
        --ac : vector_reg_type;
    end record;


    type simd_in_type is record
        ra          : std_logic_vector (XLEN-1 downto 0);         -- operand 1 data
        rb          : std_logic_vector (XLEN-1 downto 0);         -- operand 2 data
        op1         : std_logic_vector (4 downto 0);              -- operation code stage1
        op2         : std_logic_vector (2 downto 0);              -- operation code stage2
        rc_we       : std_logic;                                  -- we on destination (work)
        ctrl        : simd_ctrl_reg_type;                         -- special register to control the module behaviour
    end record;
    
    type simd_out_type is record
        simd_res    : std_logic_vector(XLEN-1 downto 0); -- output data
        s1bp        : std_logic_vector(XLEN-1 downto 0); -- s1 bypass output data
        s2bp        : std_logic_vector(XLEN-1 downto 0); -- s2 bp output data
    end record;

    type lpmul_in_type is record
        opA  : std_logic_vector(VLEN-1 downto 0);
        opB  : std_logic_vector(VLEN-1 downto 0);
        sign : std_logic;
        sat  : std_logic;
    end record;

    type lpmul_out_type is record
        mul_res : std_logic_vector(VLEN-1 downto 0);
    end record;

    ---------------------------------------------------------------
    -- CONSTANTS FOR OPERATIONS --
    --------------------------------------------------------------
    --constants function operations stage1 (simd_code 4-0)
    constant S1_NOP  : std_logic_vector (4 downto 0) := "00000";
    constant S1_ADD  : std_logic_vector (4 downto 0) := "00001";
    constant S1_SUB  : std_logic_vector (4 downto 0) := "00010";
    constant S1_MUL  : std_logic_vector (4 downto 0) := "00011";
    constant S1_DIV  : std_logic_vector (4 downto 0) := "00100";
    constant S1_MAX  : std_logic_vector (4 downto 0) := "00101";
    constant S1_MIN  : std_logic_vector (4 downto 0) := "00110";
    constant S1_AND  : std_logic_vector (4 downto 0) := "00111";
    constant S1_OR   : std_logic_vector (4 downto 0) := "01000";
    constant S1_XOR  : std_logic_vector (4 downto 0) := "01001";
    constant S1_NAND : std_logic_vector (4 downto 0) := "01010";
    constant S1_NOR  : std_logic_vector (4 downto 0) := "01011";
    constant S1_XNOR : std_logic_vector (4 downto 0) := "01100";
    constant S1_SADD : std_logic_vector (4 downto 0) := "01101";
    constant S1_SSUB : std_logic_vector (4 downto 0) := "01110";
    constant S1_SMUL : std_logic_vector (4 downto 0) := "01111";
    constant S1_MOVB : std_logic_vector (4 downto 0) := "10000";
    constant S1_SHFT : std_logic_vector (4 downto 0) := "10001";

    constant S1_UMUL : std_logic_vector (4 downto 0) := "10011";
    constant S1_UDIV : std_logic_vector (4 downto 0) := "10100";
    constant S1_UMAX : std_logic_vector (4 downto 0) := "10101";
    constant S1_UMIN : std_logic_vector (4 downto 0) := "10110";
    constant S1_SSHFT : std_logic_vector (4 downto 0):= "11001";
    constant S1_USADD : std_logic_vector (4 downto 0):= "11101";
    constant S1_USSUB : std_logic_vector (4 downto 0):= "11110";
    constant S1_USMUL : std_logic_vector (4 downto 0):= "11111"; 

    --constants function operations stage2 (simd_code 7-5)
    constant S2_NOP : std_logic_vector (2 downto 0) := "000";
    constant S2_SUM : std_logic_vector (2 downto 0) := "001";
    constant S2_MAX : std_logic_vector (2 downto 0) := "010";
    constant S2_MIN : std_logic_vector (2 downto 0) := "011";
    constant S2_XOR : std_logic_vector (2 downto 0) := "100";

    constant S2_USUM: std_logic_vector (2 downto 0) := "101";
    constant S2_UMAX: std_logic_vector (2 downto 0) := "110";
    constant S2_UMIN: std_logic_vector (2 downto 0) := "111";

    --SIMD COMPONENTS 

    component simd_module is 
    port(
            clk   : in  std_ulogic;
            rstn  : in  std_ulogic;
            holdn : in  std_ulogic;
            sdi   : in  simd_in_type;
            sdo   : out simd_out_type
        );
    end component;
    
    component lpmul is 
    port(
            muli : in lpmul_in_type;
            mulo : out lpmul_out_type
        );
    end component;
end package;
