library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library marcmod;
use marcmod.simdmod.all;

library grlib;
use grlib.stdlib.all;

entity alu8b is
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

architecture rtl of alu8b is
    subtype data is std_logic_vector(VLEN-1 downto 0);
    signal sign, saturate : std_logic;
    signal  nop, movb,  add,  sadd,  sub,  ssub : data;
    signal  max,  min, umax,  smax, umin,  smin : data;
    signal sand,  sor, sxor, snand, snor, sxnor : data;
    signal mul : data;
begin
    sign <= not op(4);
    saturate <= op(3);
    nop <= sr1; movb <= sr2;
    add <= sadd when saturate = '1' else
           sr1+sr2;
    sub <= ssub when saturate = '1' else
           sr1-sr2;

    umax <= sr1 when sr1 > sr2 else
            sr2;
    smax <= sr1 when signed(sr1) > signed(sr2) else
            sr2;
    umin <= sr2 when sr1 > sr2 else
            sr1;
    smin <= sr2 when signed(sr1) > signed(sr2) else
            sr1;

    max <= smax when sign = '1' else 
           umax;
    min <= smin when sign = '1' else 
           umin;


    sand <= sr1 and sr2;
    sor  <= sr1 or sr2;
    sxor <= sr1 xor sr2;
    snand <= sr1 nand sr2;
    snor  <= sr1 nor sr2;
    sxnor <= sr1 xnor sr2;

    mult : lpmul
        generic map (VLEN)
        port map(sign, saturate, sr1, sr2, mul);


    adder : process(sr1, sr2, sign)
        variable z : std_logic_vector(VLEN downto 0);
        constant S_MAX : data := '0'&(VLEN-2 downto 0 => '1');
        constant S_MIN : data := '1'&(VLEN-2 downto 0 => '0');
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
        sadd<=z(data'range);
    end process;

    subtractor : process (sr1, sr2, sign)
        variable z : std_logic_vector(VLEN downto 0);
        constant S_MAX : data := '0'&(VLEN-2 downto 0 => '1');
        constant S_MIN : data := '1'&(VLEN-2 downto 0 => '0');
    begin
        z := ((sign and sr1(sr1'left)) & sr1) - ((sign and sr2(sr2'left)) & sr2);
        if sign = '0' then 
            if z(z'left) = '1' then 
                z := (others => '0');
            end if;
        else 
            if sr1(sr1'left) /= sr2(sr2'left) and sr2(sr2'left) = z(z'left-1) then
                if z(z'left-1) = '1' then
                    z:= '0'&S_MAX;
                else z:= '0'&S_MIN;
                end if;
            end if;
        end if;
        ssub<=z(data'range);
    end process;

    mux : process (op, nop, movb, add, sub, max, min, sand, sor, sxor, snand, snor, sxnor, mul)
        variable alu_res : data;
    begin
        case op is 
            when S1_NOP => alu_res := nop;
            when S1_MOVB => alu_res := movb;
            when S1_ADD | S1_SADD | S1_USADD =>
                alu_res := add;
            when S1_SUB | S1_SSUB | S1_USSUB =>
                alu_res := sub;
            when S1_MUL | S1_UMUL | S1_SMUL | S1_USMUL =>
                alu_res := mul;
            when S1_MAX | S1_UMAX => 
                alu_res := max;
            when S1_MIN | S1_UMIN =>
                alu_res := min;
            when S1_AND => alu_res := sand;
            when S1_OR =>  alu_res := sor;
            when S1_XOR => alu_res := sxor;
            when S1_NAND => alu_res := snand;
            when S1_NOR =>  alu_res := snor;
            when S1_XNOR => alu_res := sxnor;
            when others => 
                alu_res := (others => '0');
        end case;
        res <= alu_res;
    end process;

end;
