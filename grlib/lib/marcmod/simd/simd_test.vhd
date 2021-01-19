library ieee;
use ieee.std_logic_1164.all;

library marcmod;
use marcmod.simdmod.all;

entity simd_test is 
end;

architecture tests of simd_test is 
    signal clk, rstn, holdn : std_ulogic := '1';
    signal rc_we_i, rc_we_o : std_logic;
    signal ra_i, rb_i, rc_data_o : std_logic_vector(31 downto 0);
    signal rc_addr_i, rc_addr_o : std_logic_vector(4 downto 0) := "00000";
    signal op_s1_i : std_logic_vector(4 downto 0);
    signal op_s2_i : std_logic_vector(2 downto 0);
    signal op_i : std_logic_vector(7 downto 0);
    signal mask_we_i : std_logic;
    signal mask_value_i : std_logic_vector (3 downto 0);

begin
    simd_module : simd port map (   clk   => clk,
                                    rstn  => rstn,
                                    holdn => holdn,
                                    inst => (others => '0'),
                                    ra_i  => ra_i,
                                    rb_i  => rb_i,
                                    op_i => op_i,
                                    rc_we_i   => rc_we_i,
                                    rc_addr_i => rc_addr_i,
                                    mask_we_i => mask_we_i,
                                    mask_value_i => mask_value_i,
                                    rc_data_o => rc_data_o,
                                    rc_we_o   => rc_we_o,
                                    rc_addr_o => rc_addr_o
                                );

    op_i <= op_s2_i & op_s1_i;
    clk <= not clk after 5 ps;
    process begin
        rstn<='0';
        wait for 10 ps;
        rstn<='1';
        --Test nop
        mask_we_i <= '0';
        holdn <= '1';
        ra_i <= x"01020304";
        rb_i <= x"00010203";
        --rc = ra;
        op_s1_i <= "00000";
        op_s2_i <= "000";
        rc_we_i <= '0';
        rc_addr_i <= (others => '0');
        wait for 10 ps;

        --Test ADD
        op_s1_i <= "00001";
        op_s2_i <= "000";
        ra_i <= x"01020304";
        rb_i <= x"00010203";
        --rc =   x01030507
        rc_we_i <= '1';
        wait for 10 ps;

        --Test SADD 
        ra_i <= x"8180FF01";
        rb_i <= x"81FF7F7F";
        --rc =   x80807E7F
        op_s1_i <= "01101";
        op_s2_i <= "000";
        rc_we_i <= '1';
        wait for 10 ps;

        --Test SUB
        ra_i <= x"0A0A0A0A";
        rb_i <= x"00050A0B";
        --rc =   x0A0500FF
        op_s1_i <= "00010";
        op_s2_i <= "000";
        wait for 10 ps;

        --Test SSUB
        ra_i <= x"807F0AFB";
        rb_i <= x"05FFFB0A";
        --rc =   x807F0FF1
        op_s1_i <= "01110";
        op_s2_i <= "000";
        wait for 10 ps;

        --Test Max i MAX signed
        ra_i <= x"0204080A";
        rb_i <= x"204080A0";
        --rc = x00000040
        op_s1_i <= "00101";
        op_s2_i <= "010";
        wait for 10 ps;

        --Test Max i MAX unsigned
        --rc = x000000A0
        op_s1_i <= "10101";
        op_s2_i <= "110";
        wait for 10 ps;

        --Test Min i MIN unsigned
        --rc = x00000002
        op_s1_i <= "10110";
        op_s2_i <= "111";
        wait for 10 ps;

        --Test Min i MIN signed
        --rc = xFFFFFF80
        op_s1_i <= "00110";
        op_s2_i <= "011";
        wait for 10 ps;

        --Test dot product (MUL i SUM) pos
        ra_i <= x"01020304";
        rb_i <= x"00010203";
        --rc =   x00000014
        op_s1_i <= "00011";
        op_s2_i <= "001";
        wait for 10 ps;

        --Test dot product (MUL i SUM) neg
        ra_i <= x"FFFE03FC";
        rb_i <= x"00FF0203";
        --rc =   xFFFFFFFC
        op_s1_i <= "00011";
        op_s2_i <= "001";
        wait for 10 ps;

        --Test DIV pos 
        ra_i <= x"40404040";
        rb_i <= x"01020040";
        --rc_0  x"4020FF01"
        op_s1_i <= "00100";
        op_s2_i <= "000";
        wait for 10 ps;

        --Test DIV neg 
        ra_i <= x"F6F6F6F6";
        rb_i <= x"0102FF0A";
        --rc =  x"F6FB0AFF"
        op_s1_i <= "00100";
        op_s2_i <= "000";
        wait for 10 ps;

        --Test NAND (a nand a = !a)
        ra_i <= x"DEADBEAF";
        rb_i <= x"DEADBEAF";
        --rc =   x21524150
        op_s1_i <= "01010";
        op_s2_i <= "000";
        wait for 10 ps;

        --Test XOR reduction
        ra_i <= x"FEEDCAFE";
        --rc = x00000027
        op_s1_i <= "00000";
        op_s2_i <= "100";
        wait for 10 ps;

        --change vector mask and repeat same operations
        rc_we_i <= '0';
        mask_we_i <= '1';
        mask_value_i <= "1010"; 
        wait for 10 ps;
        
        
        --Test nop
        mask_we_i <= '0';
        holdn <= '1';
        ra_i <= x"01020304";
        rb_i <= x"00010203";
        --rc = ra;
        op_s1_i <= "00000";
        op_s2_i <= "000";
        rc_we_i <= '0';
        rc_addr_i <= (others => '0');
        wait for 10 ps;

        --Test ADD
        op_s1_i <= "00001";
        op_s2_i <= "000";
        ra_i <= x"01020304";
        rb_i <= x"00010203";
        --rc =   x01020504
        rc_we_i <= '1';
        wait for 10 ps;

        --Test SADD 
        ra_i <= x"8180FF01";
        rb_i <= x"81FF7F7F";
        --rc =   x80807E01
        op_s1_i <= "01101";
        op_s2_i <= "000";
        rc_we_i <= '1';
        wait for 10 ps;

        --Test SUB
        ra_i <= x"0A0A0A0A";
        rb_i <= x"00050A0B";
        --rc =   x0A0A000A
        op_s1_i <= "00010";
        op_s2_i <= "000";
        wait for 10 ps;

        --Test SSUB
        ra_i <= x"807F0AFB";
        rb_i <= x"05FFFB0A";
        --rc =   x807F0FFB
        op_s1_i <= "01110";
        op_s2_i <= "000";
        wait for 10 ps;

        --Test Max i MAX signed
        ra_i <= x"0204080A";
        rb_i <= x"204080A0";
        --rc = x00000020
        op_s1_i <= "00101";
        op_s2_i <= "010";
        wait for 10 ps;

        --Test Max i MAX unsigned
        --rc = x00000080
        op_s1_i <= "10101";
        op_s2_i <= "110";
        wait for 10 ps;

        --Test Min i MIN unsigned
        --rc = x00000002
        op_s1_i <= "10110";
        op_s2_i <= "111";
        wait for 10 ps;

        --Test Min i MIN signed
        --rc = xFFFFFF80
        op_s1_i <= "00110";
        op_s2_i <= "011";
        wait for 10 ps;

        --Test dot product (MUL i SUM) pos
        ra_i <= x"01020304";
        rb_i <= x"00010203";
        --rc =   x0000000C
        op_s1_i <= "00011";
        op_s2_i <= "001";
        wait for 10 ps;

        --Test dot product (MUL i SUM) neg
        ra_i <= x"FFFE03FC";
        rb_i <= x"00FF0203";
        --rc =   x00000000
        op_s1_i <= "00011";
        op_s2_i <= "001";
        wait for 10 ps;

        --Test DIV pos 
        ra_i <= x"40404040";
        rb_i <= x"01020040";
        --rc_0  x"4040FF40"
        op_s1_i <= "00100";
        op_s2_i <= "000";
        wait for 10 ps;

        --Test DIV neg 
        ra_i <= x"F6F6F6F6";
        rb_i <= x"0102FF0A";
        --rc =  x"F6F60AF6"
        op_s1_i <= "00100";
        op_s2_i <= "000";
        wait for 10 ps;

        --Test NAND (a nand a = !a)
        ra_i <= x"DEADBEAF";
        rb_i <= x"DEADBEAF";
        --rc =   x21AD41AF
        op_s1_i <= "01010";
        op_s2_i <= "000";
        wait for 10 ps;

        --Test XOR reduction
        ra_i <= x"FEEDCAFE";
        --rc = x00000027
        op_s1_i <= "00000";
        op_s2_i <= "100";
        wait for 45 ps;
        -- End
        assert false report "End of test";
        wait;
    end process;

end tests;
