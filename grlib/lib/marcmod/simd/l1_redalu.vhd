library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library marcmod;
use marcmod.simdmod.all;

library grlib;
use grlib.stdlib.all;

entity l1_redalu is
    generic(
            VLEN : integer range 0 to 32 := 8
           );
    port(
            op   : in std_logic_vector(4 downto 0);
            sr1  : in std_logic_vector(VLEN-1 downto 0);
            sr2  : in std_logic_vector(VLEN-1 downto 0);
            res  : out std_logic_vector(VLEN-1 downto 0)
        );
end;
