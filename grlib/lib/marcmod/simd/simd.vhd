library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity simd is 
    generic(
            XLEN : integer := 32;
            VLEN : integer range 0 to 32 := 8;
            RSIZE: integer := 32;
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
end;

architecture rtl of simd is
    --define constants 
    --constants function operations stage1
    constant S1_NOP : std_logic_vector (2 downto 0) := "000";
    constant S1_ADD : std_logic_vector (2 downto 0) := "001";
    constant S1_SUB : std_logic_vector (2 downto 0) := "010";
    constant S1_MUL : std_logic_vector (2 downto 0) := "011";
    constant S1_DIV : std_logic_vector (2 downto 0) := "100";
    constant S1_MAX : std_logic_vector (2 downto 0) := "101";
    constant S1_MIN : std_logic_vector (2 downto 0) := "110";
    --constant S1_FREE : std_logic_vector (2 downto 0) := "111";

    --constants function operations stage2
    constant S2_NOP : std_logic_vector (1 downto 0) := "00";
    constant S2_SUM : std_logic_vector (1 downto 0) := "01";
    constant S2_MAX : std_logic_vector (1 downto 0) := "10";
    constant S2_MIN : std_logic_vector (1 downto 0) := "11";


    --define types
    type result_reg_type is record
        data : std_logic_vector (XLEN-1 downto 0);
        we   : std_logic;
		--error
    end record;

    type operand_reg_type is record
        data : std_logic_vector (XLEN-1 downto 0);
    end record;

    type s1_reg_type is record
        ra : operand_reg_type;
        rb : operand_reg_type;
        op1: std_logic_vector(2 downto 0);
        op2: std_logic_vector(1 downto 0);
        sg : std_logic;
    end record; 
    type s2_reg_type is record
        ra : result_reg_type;
        op2: std_logic_vector(2 downto 0);
        sg : std_logic;
    end record;


    
    --define functions
    procedure stage1_ops(op : in std_logic_vector (2 downto 0);
						 sg : in std_logic;
                         ra : in operand_reg_type;
                         rb : in operand_reg_type;
						 --exceptions or errors
                         rc : out result_reg_type) is
    variable i : integer range 0 to (XLEN/VLEN)-1;    
    begin
        case op(2 downto 0) is
            when S1_NOP =>
                rc.data := ra.data;
                rc.we := '0';
            when S1_ADD => 
                for i in 0 to (XLEN/VLEN)-1 loop
					case sg is
						when '0' => 
							rc.data(VLEN*i+VLEN-1 downto VLEN*i) := std_logic_vector(unsigned(ra.data(VLEN*i+VLEN-1 downto VLEN*i)) 
																                   + unsigned(rb.data(VLEN*i+VLEN-1 downto VLEN*i)));
						when '1' => 
							rc.data(VLEN*i+VLEN-1 downto VLEN*i) := std_logic_vector(signed(ra.data(VLEN*i+VLEN-1 downto VLEN*i)) 
																                   + signed(rb.data(VLEN*i+VLEN-1 downto VLEN*i)));
					end case;
                end loop;  
				rc.we := '1';
            when S1_SUB => 
                for i in 0 to (XLEN/VLEN)-1 loop
					case sg is
						when '0' => 
							rc.data(VLEN*i+VLEN-1 downto VLEN*i) := std_logic_vector(unsigned(ra.data(VLEN*i+VLEN-1 downto VLEN*i)) 
																                   - unsigned(rb.data(VLEN*i+VLEN-1 downto VLEN*i)));
						when '1' => 
							rc.data(VLEN*i+VLEN-1 downto VLEN*i) := std_logic_vector(signed(ra.data(VLEN*i+VLEN-1 downto VLEN*i)) 
																                   - signed(rb.data(VLEN*i+VLEN-1 downto VLEN*i)));
					end case;
                end loop;  
				rc.we := '1';
            when S1_MUL => --TODO error handling and exception
                for i in 0 to (XLEN/VLEN)-1 loop
					case sg is
						when '0' => 
							rc.data(VLEN*i+VLEN-1 downto VLEN*i) := std_logic_vector(unsigned(ra.data(VLEN*i+VLEN-1 downto VLEN*i)) 
																                   * unsigned(rb.data(VLEN*i+VLEN-1 downto VLEN*i)));
						when '1' => 
							rc.data(VLEN*i+VLEN-1 downto VLEN*i) := std_logic_vector(signed(ra.data(VLEN*i+VLEN-1 downto VLEN*i)) 
																				   * signed(rb.data(VLEN*i+VLEN-1 downto VLEN*i)));
					end case;
                end loop;  
				rc.we := '1';
            when S1_DIV => --TODO error handling and exception
                for i in 0 to (XLEN/VLEN)-1 loop
					case sg is
						when '0' => 
							rc.data(VLEN*i+VLEN-1 downto VLEN*i) := std_logic_vector(unsigned(ra.data(VLEN*i+VLEN-1 downto VLEN*i)) 
																                   / unsigned(rb.data(VLEN*i+VLEN-1 downto VLEN*i)));
						when '1' => 
							rc.data(VLEN*i+VLEN-1 downto VLEN*i) := std_logic_vector(signed(ra.data(VLEN*i+VLEN-1 downto VLEN*i)) 
																                   / signed(rb.data(VLEN*i+VLEN-1 downto VLEN*i)));
					end case;
                end loop;  
				rc.we := '1';
            when S1_MAX => 
                for i in 0 to (XLEN/VLEN)-1 loop
					case sg is
						when '0' => 
							rc.data(VLEN*i+VLEN-1 downto VLEN*i) := std_logic_vector(MAX(unsigned(ra.data(VLEN*i+VLEN-1 downto VLEN*i)),
																						 unsigned(rb.data(VLEN*i+VLEN-1 downto VLEN*i))));
						when '1' => 
							rc.data(VLEN*i+VLEN-1 downto VLEN*i) := std_logic_vector(MAX(signed(ra.data(VLEN*i+VLEN-1 downto VLEN*i)),
																						 signed(rb.data(VLEN*i+VLEN-1 downto VLEN*i))));
					end case;
                end loop;  
				rc.we := '1';
            when S1_MIN => 
                for i in 0 to (XLEN/VLEN)-1 loop
					case sg is
						when '0' => 
							rc.data(VLEN*i+VLEN-1 downto VLEN*i) := std_logic_vector(MIN(unsigned(ra.data(VLEN*i+VLEN-1 downto VLEN*i)),
																						 unsigned(rb.data(VLEN*i+VLEN-1 downto VLEN*i))));
						when '1' => 
							rc.data(VLEN*i+VLEN-1 downto VLEN*i) := std_logic_vector(MIN(signed(ra.data(VLEN*i+VLEN-1 downto VLEN*i)),
																						 signed(rb.data(VLEN*i+VLEN-1 downto VLEN*i))));
					end case;
                end loop;  
				rc.we := '1';
			when others =>
        end case;
    end procedure stage1_ops;

    procedure stage2_ops(op : in std_logic_vector (1 downto 0);
						 ra : in result_reg_type; 
						 rc : out result_reg_type) is 
	variable acc : std_logic_vector (XLEN-1 downto 0);
    variable i : integer range 0 to (XLEN/VLEN)-1;    
    begin
		acc:=(others => '0');
		case op is 
			when S2_NOP => 
				rc := ra;
			when S2_SUM =>
				for i in 0 to (XLEN/VLEN)-1 loop
					case sg is 
						when '0' =>
							acc := std_logic_vector(unsigned(acc) + unsigned(ra.data(VLEN*i+VLEN-1 downto VLEN*i)));
						when '1' =>
							acc := std_logic_vector(signed(acc) + signed(ra.data(VLEN*i+VLEN-1 downto VLEN*i)));
					end case;
				end loop;
				rc.we := ra.we;
			when S2_MAX =>
				for i in 0 to (XLEN/VLEN)-1 loop
					case sg is 
						when '0' =>
							acc := std_logic_vector(MAX(unsigned(acc), unsigned(ra.data(VLEN*i+VLEN-1 downto VLEN*i))));
						when '1' =>
							acc := std_logic_vector(MAX(signed(acc), signed(ra.data(VLEN*i+VLEN-1 downto VLEN*i))));
					end case;
				end loop;
				rc.we := ra.we;
			when S2_MIN =>
				for i in 0 to (XLEN/VLEN)-1 loop
					case sg is 
						when '0' =>
							acc := std_logic_vector(MIN(unsigned(acc), unsigned(ra.data(VLEN*i+VLEN-1 downto VLEN*i))));
						when '1' =>
							acc := std_logic_vector(MIN(signed(acc), signed(ra.data(VLEN*i+VLEN-1 downto VLEN*i))));
					end case;
				end loop;
				rc.we := ra.we;
			when others =>
		end case;
    end procedure stage2_ops;

begin
    --process definition with steps
    --assignments, process etc

end; 


