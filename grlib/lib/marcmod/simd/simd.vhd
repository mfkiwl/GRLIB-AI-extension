library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library marcmod;
use marcmod.simdmod.all;

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
            op_i  : in  std_logic_vector (7 downto 0);
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
    function max(left, right : std_logic_vector; sign :std_logic) return std_logic_vector is
    begin
        if sign='1' and left(left'left)>right(right'left) then return right;
        elsif sign='1' and left(left'left)<right(right'left) then return left;
        end if;
        if left > right then return left;
        else return right;
        end if;
    end;

    function min(left, right : std_logic_vector; sign :std_logic) return std_logic_vector is
    begin
        if sign='1' and left(left'left)<right(right'left) then return right;
        elsif sign='1' and left(left'left)>right(right'left) then return left;
        end if;
        if left < right then return left;
        else return right;
        end if;
    end;

    function add(left, right : std_logic_vector; sign :std_logic; sat :std_logic) return std_logic_vector is
        variable left1 : std_logic_vector(left'length downto 0) := (sign and left(left'left)) & left;
        variable right1: std_logic_vector(right'length downto 0):= (sign and right(right'left)) & right;
        constant U_MAX : std_logic_vector(left'length-1 downto 0) := (others => '1');
        constant S_MAX : std_logic_vector(left'length downto 0) :=  "00" & (left1'left-2 downto 0 => '1');
        constant S_MIN : std_logic_vector(left'length downto 0) :=  "11" & (left1'left-2 downto 0 => '0');
    begin
        left1 := std_logic_vector(unsigned(left1) + unsigned(right1));
        if sat = '0' or (sign = '0' and left1(left1'left) = '0') then return left1(left1'left-1 downto 0);
        end if;
        if sign = '0' then 
            return U_MAX;
        else 
            return max(min(S_MAX, left1,'1'), S_MIN, '1')(left'length-1 downto 0);
        end if;
    end;

    function sub(left, right : std_logic_vector; sign :std_logic; sat :std_logic) return std_logic_vector is
        variable left1 : std_logic_vector(left'length downto 0) := (sign and left(left'left)) & left;
        variable right1: std_logic_vector(right'length downto 0):= (sign and right(right'left)) & right;
        constant U_MIN : std_logic_vector(left'length-1 downto 0) := (others => '0');
        constant S_MAX : std_logic_vector(left'length downto 0) :=  "00" & (left1'left-2 downto 0 => '1');
        constant S_MIN : std_logic_vector(left'length downto 0) :=  "11" & (left1'left-2 downto 0 => '0');
    begin
        left1 := std_logic_vector(unsigned(left1) - unsigned(right1));
        if sat = '0' or (sign = '0' and left1(left1'left) = '0') then return left1(left1'left-1 downto 0);
        end if;
        if sign = '0' then 
            return U_MIN;
        else 
            return max(min(S_MAX, left1,'1'), S_MIN, '1')(left'length-1 downto 0);
        end if;
    end;

--    function mult(left, right : std_logic_vector; sign : std_logic; sat: std_logic) return std_logic_vector is 
--        constant U_MAX : std_logic_vector(left'length-1 downto 0) := (others => '1');
--        constant S_MAX : std_logic_vector(left'length-1 downto 0) := (left1'left-2 downto 0 => '1');
--        constant S_MIN : std_logic_vector(left'length-1 downto 0) := (left1'left-2 downto 0 => '0');
--        variable res   : std_logic_vector(2*left'length-1 downto 0) := (others => '1');
--        variable aux   : std_logic_vector(2*left'length-1 downto 0) := (others => '0');
--    begin
--        aux(right'left downto '0') := left;
--        for i in 0 to left'length loop
--            if right(i) = '1' then 
--                res:= std_logic_vector(unsigned(res)+unsigned(aux));
--            end if;
--            aux:=aux(aux'left-1 downto 0) & '0';
--        end loop;
--        if sat = '0' then 
--            if sign = '0' then 
--                return res;
--            else
--                --negar result;
--            end if;
--        elsif sign = '0' then 
--            if res(res'left downto left'left+1)=((res'left downto left'left+1) => '0') then 
--                return res;
--            else 
--                return U_MAX;
--            end if;
--        else 
--            --negar result o retorn max min;
--
--        end if;
--        
--    end;


    --https://vhdlguru.blogspot.com/2010/03/vhdl-function-for-division-two-signed.html
    function div(divident, divisor : std_logic_vector; sign : std_logic) return std_logic_vector is
        variable a1 : unsigned(divident'length-1 downto 0);
        variable b1 : unsigned(divisor'length-1 downto 0);
        variable p1 : unsigned(divident'length downto 0) := (others => '0');
    begin
        a1 := unsigned(abs(signed(divident)));
        b1 := unsigned(abs(signed(divisor)));
        for i in 0 to divident'length-1 loop
            p1(divident'length-1 downto 1) := p1(divident'length-2 downto 0);
            p1(0) := a1(divident'length-1);
            a1(divident'length-1 downto 1) := a1(divident'length-2 downto 0);
            p1 := p1-b1;
            if p1(divident'length) = '1' then
                a1(0) := '0';
                p1 := p1 + b1;
            else 
                a1(0) := '1';
            end if;
        end loop;
        if sign = '0' then return std_logic_vector(a1);
        else 
            if ((divisor(divisor'left) = '0') and (divident(divident'left) = '1')) or ((divisor(divisor'left) = '1') and (divident(divident'left) = '0')) then
                return std_logic_vector(not(a1)+1);
            else return std_logic_vector(a1);
            end if;
        end if;
    end;

    ---------------------------------------------------------------
    -- CONSTANTS FOR OPERATIONS --
    --------------------------------------------------------------
    --constants function operations stage1 (simd_code 3-0)
    constant S1_NOP : std_logic_vector (3 downto 0) := "0000";
    constant S1_ADD : std_logic_vector (3 downto 0) := "0001";
    constant S1_SUB : std_logic_vector (3 downto 0) := "0010";
    constant S1_MUL : std_logic_vector (3 downto 0) := "0011";
    constant S1_DIV : std_logic_vector (3 downto 0) := "0100";
    constant S1_MAX : std_logic_vector (3 downto 0) := "0101";
    constant S1_MIN : std_logic_vector (3 downto 0) := "0110";
    constant S1_AND : std_logic_vector (3 downto 0) := "0111";
    constant S1_OR  : std_logic_vector (3 downto 0) := "1000";
    constant S1_XOR : std_logic_vector (3 downto 0) := "1001";
    constant S1_NAND: std_logic_vector (3 downto 0) := "1010";
    constant S1_NOR : std_logic_vector (3 downto 0) := "1011";
    constant S1_XNOR: std_logic_vector (3 downto 0) := "1100";
    constant S1_SADD : std_logic_vector (3 downto 0) :="1101";
    constant S1_SSUB : std_logic_vector (3 downto 0) :="1110";
    constant S1_SMUL : std_logic_vector (3 downto 0) :="1111"; --TODO

    --constants function operations stage2 (simd_code 6-4)
    constant S2_NOP : std_logic_vector (2 downto 0) := "000";
    constant S2_SUM : std_logic_vector (2 downto 0) := "001";
    constant S2_MAX : std_logic_vector (2 downto 0) := "010";
    constant S2_MIN : std_logic_vector (2 downto 0) := "011";
    constant S2_XOR : std_logic_vector (2 downto 0) := "100";


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
        op1: std_logic_vector(3 downto 0);
        op2: std_logic_vector(2 downto 0);
        rc_addr : std_logic_vector (RSIZE-1 downto 0);
        sg : std_logic;
        we : std_logic;
    end record; 
    
    -- Stage2 entry register
    type s2_reg_type is record
        ra : result_reg_type;
        op2: std_logic_vector(2 downto 0);
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
    procedure stage1_ops(signal op : in std_logic_vector (3 downto 0);
						 signal sg : in std_logic;
                         signal ra : in operand_reg_type;
                         signal rb : in operand_reg_type;
						 --exceptions or errors
                         signal rc : out result_reg_type) is
    begin
        case op is
            when S1_NOP =>
                rc.data <= ra.data;
            when S1_ADD => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= add(ra.data(VLEN*i+VLEN-1 downto VLEN*i), 
                                                                rb.data(VLEN*i+VLEN-1 downto VLEN*i),sg,'0');
                end loop;  
            when S1_SADD => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= add(ra.data(VLEN*i+VLEN-1 downto VLEN*i), 
                                                                rb.data(VLEN*i+VLEN-1 downto VLEN*i),sg,'1');
                end loop;  
            when S1_SUB => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= sub(ra.data(VLEN*i+VLEN-1 downto VLEN*i), 
                                                                rb.data(VLEN*i+VLEN-1 downto VLEN*i),sg,'0');
                end loop;  
            when S1_SSUB => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= sub(ra.data(VLEN*i+VLEN-1 downto VLEN*i), 
                                                                rb.data(VLEN*i+VLEN-1 downto VLEN*i),sg,'1');
                end loop;  
            when S1_MUL =>
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
            when S1_DIV => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    if rb.data(VLEN*i+VLEN-1 downto VLEN*i) = (VLEN => '0') then
                        rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= (VLEN => '1');
                            -- Error of some kind?
                    else 
                        rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= div(ra.data(VLEN*i+VLEN-1 downto VLEN*i),
                                                                    rb.data(VLEN*i+VLEN-1 downto VLEN*i), sg);
                    end if;
                end loop;  
            when S1_MAX => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= max(ra.data(VLEN*i+VLEN-1 downto VLEN*i),
                                                                rb.data(VLEN*i+VLEN-1 downto VLEN*i),sg);
                end loop;  
            when S1_MIN => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= min(ra.data(VLEN*i+VLEN-1 downto VLEN*i),
                                                                rb.data(VLEN*i+VLEN-1 downto VLEN*i),sg);
                end loop;  
            when S1_AND => 
				rc.data <= ra.data and rb.data;
            when S1_OR  => 
				rc.data <= ra.data or rb.data;
            when S1_XOR  => 
				rc.data <= ra.data xor rb.data;
            when S1_NAND => 
				rc.data <= ra.data nand rb.data;
            when S1_NOR  => 
				rc.data <= ra.data nor rb.data;
            when S1_XNOR  => 
				rc.data <= ra.data xnor rb.data;
			when others =>
        end case;
    end procedure stage1_ops;

    ---------------------------------------------------------------
    -- REDUCTION OPERATIONS (S2) --
    --------------------------------------------------------------
    procedure stage2_ops(signal op : in std_logic_vector (2 downto 0);
						 signal ra : in result_reg_type; 
	                     signal sg : in std_logic;
						 signal rc : out result_reg_type) is 
	variable acc : std_logic_vector (XLEN-1 downto 0);
    begin
		case op is 
			when S2_NOP => 
				acc := ra.data;
			when S2_SUM =>
                acc(XLEN-1 downto VLEN) := (others => (sg and ra.data(VLEN-1)));
                acc(VLEN-1 downto 0) := ra.data(VLEN-1 downto 0);
				for i in 1 to (XLEN/VLEN)-1 loop
					acc := add(acc, (XLEN-1 downto VLEN => (sg and ra.data(VLEN*i+VLEN-1))) & ra.data(VLEN*i+VLEN-1 downto VLEN*i), sg, '0');
				end loop;
			when S2_MAX =>
                acc(VLEN-1 downto 0) := ra.data(VLEN-1 downto 0);
				for i in 1 to (XLEN/VLEN)-1 loop
                    acc(VLEN-1 downto 0) :=   max(acc(VLEN-1 downto 0),
                                                  ra.data(VLEN*i+VLEN-1 downto VLEN*i),sg);
				end loop;
                acc(XLEN-1 downto VLEN) := (others => (sg and acc(VLEN-1)));
			when S2_MIN =>
                acc(VLEN-1 downto 0) := ra.data(VLEN-1 downto 0);
				for i in 1 to (XLEN/VLEN)-1 loop
                    acc(VLEN-1 downto 0) :=   min(acc(VLEN-1 downto 0),
                                                  ra.data(VLEN*i+VLEN-1 downto VLEN*i),sg);
				end loop;
                acc(XLEN-1 downto VLEN) := (others => (sg and acc(VLEN-1)));
			when S2_XOR =>
                acc(XLEN-1 downto VLEN) := (others => '0');
                acc(VLEN-1 downto 0) := ra.data(VLEN-1 downto 0);
				for i in 1 to (XLEN/VLEN)-1 loop
				    acc(VLEN-1 downto 0) := acc(VLEN-1 downto 0) xor ra.data(VLEN*i+VLEN-1 downto VLEN*i);
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
                               signal op  : in  std_logic_vector (7 downto 0);
                               signal sign  : in  std_logic;
                               signal rc_we   : in std_logic;
                               signal rc_addr : in std_logic_vector (RSIZE-1 downto 0);
                               signal r_s1 : out s1_reg_type) is
    begin
        r_s1.ra.data <= ra;
        r_s1.rb.data <= rb;
        r_s1.op1 <= op(3 downto 0);
        r_s1.op2 <= op(6 downto 4);
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
    input_to_stage1(ra_i, rb_i, op_i, sign_i, rc_we_i, rc_addr_i, rin.s1);
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


