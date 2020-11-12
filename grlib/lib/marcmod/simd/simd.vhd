library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity simd is 
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
end;

architecture rtl of simd is
    ---------------------------------------------------------------
    -- AUXILIAR FUNCTIONS --
    --------------------------------------------------------------
	function max_u(left, right: unsigned) return unsigned is
	begin
		if left > right then return left;
		else return right;
		end if;
	end;
	function max_s(left, right: signed) return signed is
	begin
		if left > right then return left;
		else return right;
		end if;
	end;
	function min_u(left, right: unsigned) return unsigned is
	begin
		if left < right then return left;
		else return right;
		end if;
	end;
	function min_s(left, right: signed) return signed is
	begin
		if left < right then return left;
		else return right;
		end if;
	end;

    ---------------------------------------------------------------
    -- CONSTANTS FOR OPERATIONS --
    --------------------------------------------------------------
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


    ---------------------------------------------------------------
    -- REGISTER TYPES DEFINITION --
    --------------------------------------------------------------
    -- Result register type 
    type result_reg_type is record
        data : std_logic_vector (XLEN-1 downto 0);
        we   : std_logic;
        addr : std_logic_vector (RSIZE-1 downto 0);
		--error
    end record;

    --Operand register type
    type operand_reg_type is record
        data : std_logic_vector (XLEN-1 downto 0);
    end record;

    -- Stage1 entry register
    type s1_reg_type is record
        ra : operand_reg_type;
        rb : operand_reg_type;
        op1: std_logic_vector(2 downto 0);
        op2: std_logic_vector(1 downto 0);
        rc_addr : std_logic_vector (RSIZE-1 downto 0);
        sg : std_logic;
        we : std_logic;
    end record; 
    
    -- Stage2 entry register
    type s2_reg_type is record
        ra : result_reg_type;
        op2: std_logic_vector(1 downto 0);
        sg : std_logic;
    end record;

    -- Stage3 entry register
    type s3_reg_type is record
        rc : result_reg_type;
    end record;

    -- Group of pipeline registers
    type registers is record
        s1 : s1_reg_type;
        s2 : s2_reg_type;
        s3 : s3_reg_type;
    end record;


    ---------------------------------------------------------------
    -- CONSTANTS FOR PIPELINE REGISTERS RESET --
    --------------------------------------------------------------
    constant op_reg_res : operand_reg_type := (
        data => (others => '0')
    );

    constant res_reg_res : result_reg_type := (
        data => (others => '0'),
        we => '0',
        addr => (others => '0')
    );

    -- set the 1st stage registers reset
    constant s1_reg_res : s1_reg_type := (
        ra => op_reg_res,
        rb => op_reg_res,
        op1 => (others => '0'),
        op2 => (others => '0'),
        rc_addr => (others => '0'),
        sg => '0',
        we => '0'
    );

    -- set the 2nd stage registers reset
    constant s2_reg_res : s2_reg_type := (
        ra => res_reg_res,
        op2 => (others => '0'),
        sg => '0'
    );

    -- set the 3rd stage registers reset
    constant s3_reg_res : s3_reg_type := (
        rc => res_reg_res
    );

    -- reset all registers
    constant RRES : registers := (
        s1 => s1_reg_res,
        s2 => s2_reg_res,
        s3 => s3_reg_res
    );

    ---------------------------------------------------------------
    -- SIGNALS DEFINITIONS
    --------------------------------------------------------------
    --signals for the registers r -> current, rin -> next
    signal r, rin : registers;


    
    --define functions
    ---------------------------------------------------------------
    -- TWO OPERANDS OPERATIONS (S1) --
    --------------------------------------------------------------
    procedure stage1_ops(signal op : in std_logic_vector (2 downto 0);
						 signal sg : in std_logic;
                         signal ra : in operand_reg_type;
                         signal rb : in operand_reg_type;
						 --exceptions or errors
                         signal rc : out result_reg_type) is
    begin
        case op(2 downto 0) is
            when S1_NOP =>
                rc.data <= ra.data;
            when S1_ADD => 
                for i in 0 to (XLEN/VLEN)-1 loop
					case sg is
						when '0' => 
							rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= std_logic_vector(resize(unsigned(ra.data(VLEN*i+VLEN-1 downto VLEN*i)) 
																                          + unsigned(rb.data(VLEN*i+VLEN-1 downto VLEN*i)),VLEN));
						when '1' => 
							rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= std_logic_vector(resize(signed(ra.data(VLEN*i+VLEN-1 downto VLEN*i)) 
																                          + signed(rb.data(VLEN*i+VLEN-1 downto VLEN*i)),VLEN));
                        when others => 
                            rc.data <= ra.data;
					end case;
                end loop;  
            when S1_SUB => 
                for i in 0 to (XLEN/VLEN)-1 loop
					case sg is
						when '0' => 
							rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= std_logic_vector(resize(unsigned(ra.data(VLEN*i+VLEN-1 downto VLEN*i)) 
																                          - unsigned(rb.data(VLEN*i+VLEN-1 downto VLEN*i)),VLEN));
						when '1' => 
							rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= std_logic_vector(resize(signed(ra.data(VLEN*i+VLEN-1 downto VLEN*i)) 
																                          - signed(rb.data(VLEN*i+VLEN-1 downto VLEN*i)),VLEN));
                        when others => 
                            rc.data <= ra.data;
					end case;
                end loop;  
            when S1_MUL => --TODO error handling and exception
                for i in 0 to (XLEN/VLEN)-1 loop
					case sg is
						when '0' => 
							rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= std_logic_vector(resize(unsigned(ra.data(VLEN*i+VLEN-1 downto VLEN*i)) 
																                          * unsigned(rb.data(VLEN*i+VLEN-1 downto VLEN*i)),VLEN));
						when '1' => 
							rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= std_logic_vector(resize(signed(ra.data(VLEN*i+VLEN-1 downto VLEN*i)) 
																                          * signed(rb.data(VLEN*i+VLEN-1 downto VLEN*i)),VLEN));
                        when others => 
                            rc.data <= ra.data;
					end case;
                end loop;  
            when S1_DIV => --TODO error handling and exception
                for i in 0 to (XLEN/VLEN)-1 loop
					case sg is
						when '0' => 
							rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= std_logic_vector(unsigned(ra.data(VLEN*i+VLEN-1 downto VLEN*i)) 
																                   / unsigned(rb.data(VLEN*i+VLEN-1 downto VLEN*i)));
						when '1' => 
							rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= std_logic_vector(signed(ra.data(VLEN*i+VLEN-1 downto VLEN*i)) 
																                   / signed(rb.data(VLEN*i+VLEN-1 downto VLEN*i)));
                        when others => 
                            rc.data <= ra.data;
					end case;
                end loop;  
            when S1_MAX => 
                for i in 0 to (XLEN/VLEN)-1 loop
					case sg is
						when '0' => 
							rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= std_logic_vector(max_u(unsigned(ra.data(VLEN*i+VLEN-1 downto VLEN*i)),
																						   unsigned(rb.data(VLEN*i+VLEN-1 downto VLEN*i))));
						when '1' => 
							rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= std_logic_vector(max_s(signed(ra.data(VLEN*i+VLEN-1 downto VLEN*i)),
										   												   signed(rb.data(VLEN*i+VLEN-1 downto VLEN*i))));
                        when others => 
                            rc.data <= ra.data;
					end case;
                end loop;  
            when S1_MIN => 
                for i in 0 to (XLEN/VLEN)-1 loop
					case sg is
						when '0' => 
							rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= std_logic_vector(min_u(unsigned(ra.data(VLEN*i+VLEN-1 downto VLEN*i)),
																						 unsigned(rb.data(VLEN*i+VLEN-1 downto VLEN*i))));
						when '1' => 
							rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= std_logic_vector(min_s(signed(ra.data(VLEN*i+VLEN-1 downto VLEN*i)),
																						 signed(rb.data(VLEN*i+VLEN-1 downto VLEN*i))));
                        when others => 
                            rc.data <= ra.data;
					end case;
                end loop;  
			when others =>
        end case;
    end procedure stage1_ops;

    ---------------------------------------------------------------
    -- REDUCTION OPERATIONS (S2) --
    --------------------------------------------------------------
    procedure stage2_ops(signal op : in std_logic_vector (1 downto 0);
						 signal ra : in result_reg_type; 
	                     signal sg : in std_logic;
						 signal rc : out result_reg_type) is 
	variable acc : std_logic_vector (XLEN-1 downto 0);
    begin
		acc:=(others => '0');
		case op is 
			when S2_NOP => 
				acc := ra.data;
			when S2_SUM =>
				for i in 0 to (XLEN/VLEN)-1 loop
					case sg is 
						when '0' =>
							acc := std_logic_vector(resize(unsigned(acc) + unsigned(ra.data(VLEN*i+VLEN-1 downto VLEN*i)), acc'length));
						when '1' =>
							acc := std_logic_vector(resize(signed(acc) + signed(ra.data(VLEN*i+VLEN-1 downto VLEN*i)), acc'length));
                        when others => 
                            acc := ra.data;
					end case;
				end loop;
			when S2_MAX =>
				for i in 0 to (XLEN/VLEN)-1 loop
					case sg is 
						when '0' =>
							acc := std_logic_vector(resize(max_u(unsigned(acc(VLEN-1 downto 0)), unsigned(ra.data(VLEN*i+VLEN-1 downto VLEN*i))), acc'length));
						when '1' =>
							acc := std_logic_vector(resize(max_s(signed(acc(VLEN-1 downto 0)), signed(ra.data(VLEN*i+VLEN-1 downto VLEN*i))), acc'length));
                        when others => 
                            acc := ra.data;
					end case;
				end loop;
			when S2_MIN =>
				for i in 0 to (XLEN/VLEN)-1 loop
					case sg is 
						when '0' =>
							acc := std_logic_vector(resize(min_u(unsigned(acc(VLEN-1 downto 0)), unsigned(ra.data(VLEN*i+VLEN-1 downto VLEN*i))), acc'length));
						when '1' =>
							acc := std_logic_vector(resize(min_s(signed(acc(VLEN-1 downto 0)), signed(ra.data(VLEN*i+VLEN-1 downto VLEN*i))), acc'length));
                        when others => 
                            acc := ra.data;
					end case;
				end loop;
			when others =>
		end case;
        rc.data <= acc;
        rc.we <= ra.we;
    end procedure stage2_ops;

    ---------------------------------------------------------------
    -- STAGE TO STAGE PROCEDURES --
    --------------------------------------------------------------
    procedure stage1_to_2(signal r_s1 : in s1_reg_type;
                          signal r_s2 : out s2_reg_type) is
    begin
        --operation stage1 
        stage1_ops(r_s1.op1,r_s1.sg, r_s1.ra, r_s1.rb, r_s2.ra);
        r_s2.op2 <= r_s1.op2;
        r_s2.sg <= r_s1.sg;
        r_s2.ra.we <= r_s1.we;
        r_s2.ra.addr <= r_s1.rc_addr;
    end procedure stage1_to_2;

    procedure stage2_to_3(signal r_s2 : in s2_reg_type;
                          signal r_s3 : out s3_reg_type) is
    begin
        --operation stage2 
        stage2_ops(r_s2.op2, r_s2.ra, r_s2.sg, r_s3.rc);
        r_s3.rc.addr <= r_s2.ra.addr;
    end procedure stage2_to_3;

    procedure input_to_stage1( signal ra  : in  std_logic_vector (XLEN-1 downto 0);
                               signal rb  : in  std_logic_vector (XLEN-1 downto 0);
                               signal op_s1 : in  std_logic_vector (2 downto 0);
                               signal op_s2 : in  std_logic_vector (1 downto 0);
                               signal sign  : in  std_logic;
                               signal rc_we   : in std_logic;
                               signal rc_addr : in std_logic_vector (RSIZE-1 downto 0);
                               signal r_s1 : out s1_reg_type) is
    begin
        r_s1.ra.data <= ra;
        r_s1.rb.data <= rb;
        r_s1.op1 <= op_s1;
        r_s1.op2 <= op_s2;
        r_s1.rc_addr <= rc_addr;
        r_s1.sg <= sign;
        r_s1.we <= rc_we;
    end procedure input_to_stage1;

    procedure stage3_to_output(signal r_s3 : in s3_reg_type;
                               signal rc_data : out std_logic_vector (XLEN-1 downto 0);           
                               signal rc_we   : out std_logic;
                               signal rc_addr : out std_logic_vector (RSIZE-1 downto 0)) is 
    begin
        rc_data <= r_s3.rc.data;
        rc_we   <= r_s3.rc.we;
        rc_addr <= r_s3.rc.addr;
    end procedure stage3_to_output;
begin
    --fill stage1 register with input
    input_to_stage1(ra_i, rb_i, op_s1_i, op_s2_i, sign_i, rc_we_i, rc_addr_i, rin.s1);
    --stage 1 to stage 2
    stage1_to_2(r.s1, rin.s2);
    --stage 2 to stage 3
    stage2_to_3(r.s2, rin.s3);
    --fill output signals
    stage3_to_output(r.s3, rc_data_o, rc_we_o, rc_addr_o);

    reg : process (clk) 
    begin
        if rising_edge(clk) then
            if (holdn = '1') then
                r <= rin;
            --else 
            end if;
            if (rstn = '0') then 
                r <= RRES;
            end if;
        end if;
    end process;

end; 


