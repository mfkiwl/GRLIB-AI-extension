library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library marcmod;
use marcmod.simdmod.all;

library grlib;
use grlib.stdlib.all;

entity lpmul is
    port(
            muli : in lpmul_in_type;
            mulo : out lpmul_out_type
        );
end;

architecture rtl of lpmul is
    constant SMAX : std_logic_vector(VLEN-1 downto 0) := "0" & (VLEN-2 downto 0 => '1');
    constant SMIN : std_logic_vector(VLEN-1 downto 0) := "1" & (VLEN-2 downto 0 => '0');
    constant UMAX : std_logic_vector(VLEN-1 downto 0) := (others => '1');

    function sign_invert(a : std_logic_vector) return std_logic_vector is
    begin
        return std_logic_vector(-signed(a));
    end sign_invert;

    function product (a, b : std_logic_vector) return std_logic_vector is
        variable aux : std_logic_vector(a'range);
        variable z : std_logic_vector(a'length*2-1 downto 0);
    begin
        z := (others => '0'); aux := a;
        for i in 0 to VLEN-1 loop 
            if b(i) = '1' then
                z := std_logic_vector(unsigned(aux)+unsigned(z));
            end if;
            aux := aux(aux'left-1 downto 0) & '0';
        end loop;
        return z;
    end product;

    function sat_mux (asign, bsign, rsign, sign, sat : std_logic; 
    z2 : std_logic_vector) return std_logic_vector is
        variable sel : std_logic_vector(2 downto 0);
    begin 
        sel := "000";     -- result as it is, no saturation
        if sat = '1' then 
            if sign = '1' then 
                if asign = bsign then -- positive result
                    if z2&rsign /= (z2'range => '0')&'0' then 
                        sel := "011";  -- result is 7f signed max
                    end if;
                else 
                    if z2 /= (z2'range => '0') then 
                        sel := "100";  -- result is 80 signed min
                    else sel := "001";  -- result is ca2 negative
                    end if;
                end if;
            else
                if z2 /= (z2'range => '0') then 
                    sel := "111";  --  result is ff unsigned max
                end if;
            end if;
        end if;
        return sel;
    end sat_mux;

    procedure sat_sel (sel : in std_logic_vector(2 downto 0);
                       r, nr : in std_logic_vector(VLEN-1 downto 0);
                       mulres : out std_logic_vector(VLEN-1 downto 0)) is
    begin
        case sel is
            when "000" => mulres := r;
            when "001" => mulres := nr;
            when "011" => mulres := SMAX;
            when "100" => mulres := SMIN;
            when "111" => mulres := UMAX;
            when others => mulres := (others => '0');
        end case;
    end sat_sel;

begin

    comb : process( muli)
        variable z : std_logic_vector(VLEN*2-1 downto 0);
        variable r : std_logic_vector(VLEN-1 downto 0);
        variable a, b : std_logic_vector(VLEN-1 downto 0);
        variable signA, signB : std_logic;
        variable mux : std_logic_vector(2 downto 0);
    begin
        a := muli.opA; b := muli.opB;
        signA := muli.opA(muli.opA'left);
        signB := muli.opB(muli.opB'left);

        if (muli.sign and signA and muli.sat) = '1' then 
            a := sign_invert(muli.opA);
        end if;
        if (muli.sign and signB and muli.sat) = '1' then 
            b := sign_invert(muli.opB);
        end if;
        z := product(a, b);
        mux := sat_mux(signA, signB, z(r'left), muli.sign, muli.sat, z(z'left downto r'length));
        sat_sel(mux, z(r'range), sign_invert(z(r'range)), r);
        mulo.mul_res <= r;
    end process;
end;

