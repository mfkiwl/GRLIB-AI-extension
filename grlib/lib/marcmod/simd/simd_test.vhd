library ieee;
use ieee.std_logic_1164.all;

entity simd_test is 
end;

architecture tests of simd_test is 
    component simd
    generic(
            XLEN : integer := 32;
            VLEN : integer range 0 to 32 := 8;
            RSIZE: integer := 5
        );
    port(
            clk   : in  std_ulogic;
            rstn  : in  std_ulogic;
            holdn : in  std_ulogic;
            ra_i  : in  std_logic_vector (XLEN-1 downto 0);
            rb_i  : in  std_logic_vector (XLEN-1 downto 0);
            op_s1_i : in  std_logic_vector (3 downto 0);
            op_s2_i : in  std_logic_vector (2 downto 0);
            sign_i  : in  std_logic;
            rc_we_i   : in std_logic;
            rc_addr_i : in std_logic_vector (RSIZE-1 downto 0);
            
            rc_data_o : out std_logic_vector (XLEN-1 downto 0);           
            rc_we_o   : out std_logic;
            rc_addr_o : out std_logic_vector (RSIZE-1 downto 0)
        --exceptions out 
        );
    end component;
    signal clk, rstn, holdn : std_ulogic := '1';
    signal sign_i, rc_we_i, rc_we_o : std_logic;
    signal ra_i, rb_i, rc_data_o : std_logic_vector(31 downto 0);
    signal rc_addr_i, rc_addr_o : std_logic_vector(4 downto 0) := "00000";
    signal op_s1_i : std_logic_vector(3 downto 0);
    signal op_s2_i : std_logic_vector(2 downto 0);

begin
    simd_module : simd port map (   clk   => clk,
                                    rstn  => rstn,
                                    holdn => holdn,
                                    ra_i  => ra_i,
                                    rb_i  => rb_i,
                                    op_s1_i => op_s1_i,
                                    op_s2_i => op_s2_i,
                                    sign_i  => sign_i,
                                    rc_we_i   => rc_we_i,
                                    rc_addr_i => rc_addr_i,

                                    rc_data_o => rc_data_o,
                                    rc_we_o   => rc_we_o,
                                    rc_addr_o => rc_addr_o
                                );

    clk <= not clk after 5 ps;
    process begin
        --Test nop
        holdn <= '1';
        ra_i <= x"01020304";
        rb_i <= x"00010203";
        --rc = ra;
        op_s1_i <= "0000";
        op_s2_i <= "000";
        sign_i <= '1';
        rc_we_i <= '0';
        rc_addr_i <= (others => '0');
        wait for 10 ps;

        --Test ADD
        op_s1_i <= "0001";
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
        op_s1_i <= "1101";
        op_s2_i <= "000";
        rc_we_i <= '1';
        wait for 10 ps;

        --Test SUB
        ra_i <= x"0A0A0A0A";
        rb_i <= x"00050A0B";
        --rc =   x0A0500FF
        op_s1_i <= "0010";
        op_s2_i <= "000";
        wait for 10 ps;

        --Test SSUB
        ra_i <= x"807F0AFB";
        rb_i <= x"05FFFB0A";
        --rc =   x807F0FF1
        op_s1_i <= "1110";
        op_s2_i <= "000";
        wait for 10 ps;

        --Test Max i MAX signed
        ra_i <= x"0204080A";
        rb_i <= x"204080A0";
        --rc = x00000040
        op_s1_i <= "0101";
        op_s2_i <= "010";
        wait for 10 ps;

        --Test Max i MAX unsigned
        --rc = x000000A0
        sign_i <= '0';
        wait for 10 ps;

        --Test Min i MIN unsigned
        --rc = x00000002
        op_s1_i <= "0110";
        op_s2_i <= "011";
        wait for 10 ps;

        --Test Min i MIN signed
        --rc = xFFFFFF80
        sign_i <= '1';
        wait for 10 ps;

        --Test dot product (MUL i SUM) pos
        ra_i <= x"01020304";
        rb_i <= x"00010203";
        --rc =   x00000014
        op_s1_i <= "0011";
        op_s2_i <= "001";
        wait for 10 ps;

        --Test dot product (MUL i SUM) neg
        ra_i <= x"FFFE03FC";
        rb_i <= x"00FF0203";
        --rc =   xFFFFFFFC
        op_s1_i <= "0011";
        op_s2_i <= "001";
        wait for 10 ps;

        --Test DIV pos 
        ra_i <= x"40404040";
        rb_i <= x"01020040";
        --rc_0  x"4020FF01"
        op_s1_i <= "0100";
        op_s2_i <= "000";
        wait for 10 ps;

        --Test DIV neg 
        ra_i <= x"F6F6F6F6";
        rb_i <= x"0102FF0A";
        --rc =  x"F6FB0AFF"
        op_s1_i <= "0100";
        op_s2_i <= "000";
        wait for 10 ps;

        --Test NAND (a nand a = !a)
        ra_i <= x"DEADBEAF";
        rb_i <= x"DEADBEAF";
        --rc =   x21524150
        op_s1_i <= "1010";
        op_s2_i <= "000";
        wait for 10 ps;

        --Test XOR reduction
        ra_i <= x"FEEDCAFE";
        --rc = x00000027
        op_s1_i <= "0000";
        op_s2_i <= "100";
        wait for 45 ps;

        
        -- End
        assert false report "End of test";
        wait;
    end process;

end tests;
