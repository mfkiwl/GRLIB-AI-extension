library ieee;
use ieee.std_logic_1164.all;
library grlib;
use grlib.stdlib.all;


package simdmod is

    component simd is 
    generic(
            XLEN : integer := 32;
            VLEN : integer range 0 to 32 := 8;
            RSIZE: integer := 5;
            LOGSZ: integer := 2 --integer(ceil(ieee.math_real.log2(real(XLEN/VLEN))))
           );
    port(
            -- general inputs
            clk   : in  std_ulogic;
            rstn  : in  std_ulogic;
            holdn : in  std_ulogic;
            
            -- inst for debug 
            inst  : in  std_logic_vector(31 downto 0);
            rc_we_i   : in std_logic;
            rc_addr_i : in std_logic_vector (RSIZE-1 downto 0);

            -- vector operations inputs
            ra_i  : in  std_logic_vector (XLEN-1 downto 0);
            rb_i  : in  std_logic_vector (XLEN-1 downto 0);
            op_i  : in  std_logic_vector (7 downto 0);

            -- memory bypass input
            ldbpa_i : in std_logic;
            ldra_i  : in  std_logic_vector (XLEN-1 downto 0);
            ldbpb_i : in std_logic;
            ldrb_i  : in  std_logic_vector (XLEN-1 downto 0);

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
    end component;
end package;
