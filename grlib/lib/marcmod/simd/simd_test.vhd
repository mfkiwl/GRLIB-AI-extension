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
            op_s1_i : in  std_logic_vector (2 downto 0);
            op_s2_i : in  std_logic_vector (1 downto 0);
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
    signal op_s1_i : std_logic_vector(2 downto 0);
    signal op_s2_i : std_logic_vector(1 downto 0);

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

    clk <= not clk after 5 ns;
    process begin
        holdn <= '1';
        ra_i <= x"01020304";
        rb_i <= x"00010203";
        op_s1_i <= "000";
        op_s2_i <= "00";
        sign_i <= '1';
        rc_we_i <= '1';
        rc_addr_i <= (others => '0');
        wait for 10 ns;
        op_s1_i <= "001";
        op_s2_i <= "00";
        wait for 10 ns;
        op_s1_i <= "000";
        op_s2_i <= "10";
        wait for 10 ns;
        op_s1_i <= "011";
        op_s2_i <= "01";
        wait for 10 ns;

        wait for 40 ns;
        assert false report "End of test";
        wait;
    end process;

end tests;
