library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library marcmod;
use marcmod.simdmod.all;

library grlib;
use grlib.stdlib.all;

entity redalu is
    generic(
            SIZE : integer range 0 to 32 := 8
           );
    port(
            op   : in std_logic_vector(2 downto 0);
            sat  : in std_logic;
            sr1  : in std_logic_vector(SIZE-1 downto 0);
            sr2  : in std_logic_vector(SIZE-1 downto 0);
            res  : out std_logic_vector(SIZE downto 0)
        );
end;

architecture rtl of redalu is
    subtype data is std_logic_vector(SIZE-1 downto 0);
    subtype result is std_logic_vector(SIZE downto 0);
    signal sign : std_logic;
    signal ssum, sum, max, min, sxor : result;
    signal smax, smin, umax, umin : data;

begin
    sign <= not op(2);
    sxor <= '0' & (sr1 xor sr2);
    sum <= ssum when sat = '1' else
           ((sign and sr1(sr1'left)) & sr1) + ((sign and sr2(sr2'left)) & sr2);

    umax <= sr1 when sr1 > sr2 else
            sr2;
    smax <= sr1 when signed(sr1) > signed(sr2) else
            sr2;
    umin <= sr2 when sr1 > sr2 else
            sr1;
    smin <= sr2 when signed(sr1) > signed(sr2) else
            sr1;

    max <= (sign and smax(smax'left)) & smax when sign = '1' else 
           '0' & umax;
    min <= (sign and smin(smin'left)) & smin when sign = '1' else 
           '0' & umin;

    adder : process(sr1, sr2, sign)
        variable z : std_logic_vector(SIZE downto 0);
        constant S_MAX : data := '0'&(SIZE-2 downto 0 => '1');
        constant S_MIN : data := '1'&(SIZE-2 downto 0 => '0');
    begin
        z := ((sign and sr1(sr1'left)) & sr1) + ((sign and sr2(sr2'left)) & sr2);
        if sign = '0' then 
            if z(z'left) = '1' then 
                z := (others => '1');
            end if;
        else 
            if sr1(sr1'left) = sr2(sr2'left) and sr1(sr1'left) /= z(z'left-1) then
                if z(z'left-1) = '1' then
                    z:= '0'&S_MAX;
                else z:= '1'&S_MIN;
                end if;
            end if;
        end if;
        ssum<=z;
    end process;

    mux : process (sum, max, min, sxor)
        variable alu_res : result;
    begin
        case op is 
            when S2_SUM | S2_USUM => alu_res := sum;
            when S2_MAX | S2_UMAX => alu_res := max;
            when S2_MIN | S2_UMIN => alu_res := min;
            when S2_XOR => alu_res := sxor;
            when others => alu_res := (others => '0');
        end case;
        res <= alu_res;
    end process;
end;
