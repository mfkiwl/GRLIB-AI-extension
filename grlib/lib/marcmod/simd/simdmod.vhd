library ieee;
use ieee.std_logic_1164.all;
library grlib;
use grlib.stdlib.all;


package simdmod is

    component simd is 
    generic(
            XLEN : integer := 32;
            VLEN : integer range 0 to 32 := 8;
            RSIZE: integer := 5
           );
    port(
            -- general inputs
            clk   : in  std_ulogic;
            rstn  : in  std_ulogic;
            holdn : in  std_ulogic;
            
            -- inst for debug 
            inst  : in  std_logic_vector(31 downto 0);

            -- vector operations inputs
            ra_i  : in  std_logic_vector (XLEN-1 downto 0);
            rb_i  : in  std_logic_vector (XLEN-1 downto 0);
            op_i  : in  std_logic_vector (7 downto 0);
            rc_we_i   : in std_logic;
            rc_addr_i : in std_logic_vector (RSIZE-1 downto 0);

            -- mask modification inputs
            mask_we_i : in std_logic;
            mask_value_i : in std_logic_vector ((XLEN/VLEN)-1 downto 0);

            -- outputs
            rc_data_o : out std_logic_vector (XLEN-1 downto 0);           
            rc_we_o   : out std_logic;
            rc_addr_o : out std_logic_vector (RSIZE-1 downto 0)
            --exceptions out 
        );
    end component;
end package;
