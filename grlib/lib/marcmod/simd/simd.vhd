library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library grlib;
use grlib.stdlib.all;
library marcmod;
use marcmod.simdmod.all;

entity simd is 
    generic(
            XLEN : integer := 32;
            VLEN : integer range 0 to 32 := 8;
            RSIZE: integer := 5;
            LOGSZ: integer := 2 --integer(ceil(log2(real(XLEN/VLEN))))
           );
    port(
            -- general inputs
            clk   : in  std_ulogic;
            rstn  : in  std_ulogic;
            holdn : in  std_ulogic;
            
            -- signals for debug 
            inst  : in  std_logic_vector(31 downto 0);
            rc_we_i   : in std_logic;
            rc_addr_i : in std_logic_vector (RSIZE-1 downto 0);

            -- vector operations inputs
            ra_i  : in  std_logic_vector (XLEN-1 downto 0);
            rb_i  : in  std_logic_vector (XLEN-1 downto 0);
            op_i  : in  std_logic_vector (7 downto 0);

            -- memory bypass input
            ldbpa_i : in std_logic;
            ldra_i  : in  std_logic_vector (XLEN-1 downto 0);
            ldbpb_i : in std_logic;
            ldrb_i  : in  std_logic_vector (XLEN-1 downto 0);

            -- mask modification inputs
            ctrl_reg_we_i : in std_logic;
            mask_value_i  : in std_logic_vector((XLEN/VLEN)-1 downto 0);
            res_byte_en_i : in std_logic_vector((XLEN/VLEN)-1 downto 0);
            swiz_veca_i   : in std_logic_vector(XLEN/VLEN*LOGSZ-1 downto 0);
            swiz_vecb_i   : in std_logic_vector(XLEN/VLEN*LOGSZ-1 downto 0);

            -- outputs
            rc_data_o : out std_logic_vector (XLEN-1 downto 0);
            s1bp_o : out std_logic_vector (XLEN-1 downto 0); -- data from stage 1 to bypass if needed
            s2bp_o : out std_logic_vector (XLEN-1 downto 0) -- data from stage 2 to bypass if needed
            --exceptions out 
        );
end;

architecture rtl of simd is
    ---------------------------------------------------------------
    -- CONSTANTS FOR OPERATIONS --
    --------------------------------------------------------------
    --constants function operations stage1 (simd_code 4-0)
    constant S1_NOP : std_logic_vector (4 downto 0) := "00000";
    constant S1_ADD : std_logic_vector (4 downto 0) := "00001";
    constant S1_SUB : std_logic_vector (4 downto 0) := "00010";
    constant S1_MUL : std_logic_vector (4 downto 0) := "00011";
    constant S1_DIV : std_logic_vector (4 downto 0) := "00100";
    constant S1_MAX : std_logic_vector (4 downto 0) := "00101";
    constant S1_MIN : std_logic_vector (4 downto 0) := "00110";
    constant S1_AND : std_logic_vector (4 downto 0) := "00111";
    constant S1_OR  : std_logic_vector (4 downto 0) := "01000";
    constant S1_XOR : std_logic_vector (4 downto 0) := "01001";
    constant S1_NAND: std_logic_vector (4 downto 0) := "01010";
    constant S1_NOR : std_logic_vector (4 downto 0) := "01011";
    constant S1_XNOR: std_logic_vector (4 downto 0) := "01100";
    constant S1_SADD : std_logic_vector (4 downto 0) :="01101";
    constant S1_SSUB : std_logic_vector (4 downto 0) :="01110";
    constant S1_SMUL : std_logic_vector (4 downto 0) :="01111";
    constant S1_MOVB : std_logic_vector (4 downto 0) :="10000";

    constant S1_UMUL : std_logic_vector (4 downto 0) :="10011";
    constant S1_UDIV : std_logic_vector (4 downto 0) :="10100";
    constant S1_UMAX : std_logic_vector (4 downto 0) :="10101";
    constant S1_UMIN : std_logic_vector (4 downto 0) :="10110";
    constant S1_USADD : std_logic_vector (4 downto 0):="11101";
    constant S1_USSUB : std_logic_vector (4 downto 0):="11110";
    constant S1_USMUL : std_logic_vector (4 downto 0):="11111"; 

    --constants function operations stage2 (simd_code 7-5)
    constant S2_NOP : std_logic_vector (2 downto 0) := "000";
    constant S2_SUM : std_logic_vector (2 downto 0) := "001";
    constant S2_MAX : std_logic_vector (2 downto 0) := "010";
    constant S2_MIN : std_logic_vector (2 downto 0) := "011";
    constant S2_XOR : std_logic_vector (2 downto 0) := "100";

    constant S2_USUM: std_logic_vector (2 downto 0) := "101";
    constant S2_UMAX: std_logic_vector (2 downto 0) := "110";
    constant S2_UMIN: std_logic_vector (2 downto 0) := "111";


    ---------------------------------------------------------------
    -- REGISTER TYPES DEFINITION --
    --------------------------------------------------------------

    -- Result register type 
    type result_reg_type is record
        data : std_logic_vector (XLEN-1 downto 0);
        sat: std_logic; -- is the result saturated
		--error
    end record;

    --Operand register type
    type operand_reg_type is record
        data : std_logic_vector (XLEN-1 downto 0);
    end record;

    -- mask registers (predicate)
    subtype pred_reg_type is std_logic_vector((XLEN/VLEN)-1 downto 0);

    -- stage 2 byte enable (result in byte x)
    subtype s2byteen_reg_type is std_logic_vector((XLEN/VLEN)-1 downto 0);

    -- swizling registers (reordering)
    subtype log_length is integer range 0 to (XLEN/VLEN)-1;
    type swizling_reg_type is array (0 to (XLEN/VLEN)-1) of log_length;

    type ctrl_reg_type is record
        p  : pred_reg_type;
        sa : swizling_reg_type;
        sb : swizling_reg_type;
        be : s2byteen_reg_type;
    end record;

    -- Stage1 entry register
    type s1_reg_type is record
        ra : operand_reg_type;
        rb : operand_reg_type;
        op1: std_logic_vector(4 downto 0);
        op2: std_logic_vector(2 downto 0);
    end record; 
    
    -- Stage2 entry register
    type s2_reg_type is record
        ra : result_reg_type;
        op2: std_logic_vector(2 downto 0);
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
        ctr: ctrl_reg_type;
    end record;



    ---------------------------------------------------------------
    -- CONSTANTS FOR PIPELINE REGISTERS RESET --
    --------------------------------------------------------------
    constant op_reg_res : operand_reg_type := (
        data => (others => '0')
    );

    constant res_reg_res : result_reg_type := (
        data => (others => '0'),
        sat => '0'
    );

    -- set the 1st stage registers reset
    constant s1_reg_res : s1_reg_type := (
        ra => op_reg_res,
        rb => op_reg_res,
        op1 => (others => '0'),
        op2 => (others => '0')
    );

    -- set the 2nd stage registers reset
    constant s2_reg_res : s2_reg_type := (
        ra => res_reg_res,
        op2 => (others => '0')
    );

    -- set the 3rd stage registers reset
    constant s3_reg_res : s3_reg_type := (
        rc => res_reg_res
    );

    function swizling_init return swizling_reg_type is
        variable res_val : swizling_reg_type;
    begin
        for i in 0 to (XLEN/VLEN)-1 loop
            res_val(i) := i;
        end loop;
        return res_val;
    end function swizling_init;

    function swizling_set(signal sz_i : std_logic_vector(XLEN/VLEN*LOGSZ-1 downto 0)) return swizling_reg_type is
        variable res_val : swizling_reg_type;
    begin
        for i in 0 to (XLEN/VLEN)-1 loop
            res_val(i) := to_integer(unsigned(sz_i(i*LOGSZ+LOGSZ-1 downto i*LOGSZ)));
        end loop;
        return res_val;
    end function swizling_set;

    constant ctrl_reg_res : ctrl_reg_type := (
        p => (others => '1'),
        sa => swizling_init,
        sb => swizling_init,
        be =>(others => '0')
    );


    -- reset all registers
    constant RRES : registers := (
        s1 => s1_reg_res,
        s2 => s2_reg_res,
        s3 => s3_reg_res,
        ctr=> ctrl_reg_res
    );

    ---------------------------------------------------------------
    -- SIGNALS DEFINITIONS
    --------------------------------------------------------------
    --signals for the registers r -> current, rin -> next
    signal r, rin: registers;
    signal rs1, rs2 : operand_reg_type;


    
    --define functions
    ---------------------------------------------------------------
    -- TWO OPERANDS OPERATIONS (S1) --
    --------------------------------------------------------------
    procedure stage1_ops(signal op : in std_logic_vector (4 downto 0);
                         signal ra : in operand_reg_type;
                         signal rb : in operand_reg_type;
                         signal ctr: in ctrl_reg_type;
						 --exceptions or errors
                         signal rc : out result_reg_type) is
    begin
        rc.sat <= '0';
        case op is
            when S1_NOP =>
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= ra.data(VLEN*ctr.sa(i)+VLEN-1 downto VLEN*ctr.sa(i)); 
                                                            
                end loop;  

            when S1_MOVB =>
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= rb.data(VLEN*ctr.sb(i)+VLEN-1 downto VLEN*ctr.sb(i)); 
                                                            
                end loop;  

            --addition and saturated addition
            when S1_ADD => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= add(ra.data(VLEN*ctr.sa(i)+VLEN-1 downto VLEN*ctr.sa(i)), 
                                                                rb.data(VLEN*ctr.sb(i)+VLEN-1 downto VLEN*ctr.sb(i)));
                end loop;  
            when S1_SADD => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= saturate_add(ra.data(VLEN*ctr.sa(i)+VLEN-1 downto VLEN*ctr.sa(i)),
                                                                         rb.data(VLEN*ctr.sb(i)+VLEN-1 downto VLEN*ctr.sb(i)),'1');
                end loop;  
                rc.sat <= '1';
            when S1_USADD => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= saturate_add(ra.data(VLEN*ctr.sa(i)+VLEN-1 downto VLEN*ctr.sa(i)),
                                                                         rb.data(VLEN*ctr.sb(i)+VLEN-1 downto VLEN*ctr.sb(i)),'0');
                end loop;  
                rc.sat <= '1';

            --subtraction and saturated subtraction
            when S1_SUB => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= sub(ra.data(VLEN*ctr.sa(i)+VLEN-1 downto VLEN*ctr.sa(i)),
                                                                rb.data(VLEN*ctr.sb(i)+VLEN-1 downto VLEN*ctr.sb(i)));
                end loop;  
            when S1_SSUB => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= saturate_sub(ra.data(VLEN*ctr.sa(i)+VLEN-1 downto VLEN*ctr.sa(i)),
                                                                         rb.data(VLEN*ctr.sb(i)+VLEN-1 downto VLEN*ctr.sb(i)),'1');
                end loop;  
                rc.sat <= '1';
            when S1_USSUB => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= saturate_sub(ra.data(VLEN*ctr.sa(i)+VLEN-1 downto VLEN*ctr.sa(i)),
                                                                         rb.data(VLEN*ctr.sb(i)+VLEN-1 downto VLEN*ctr.sb(i)),'0');
                end loop;  
                rc.sat <= '1';

            --multiplication and saturated multiplication
            when S1_MUL =>
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= signed_mul(ra.data(VLEN*ctr.sa(i)+VLEN-1 downto VLEN*ctr.sa(i)),
                                                                       rb.data(VLEN*ctr.sb(i)+VLEN-1 downto VLEN*ctr.sb(i)))(VLEN-1 downto 0);
                end loop;  
            when S1_SMUL =>
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= saturate_mul(ra.data(VLEN*ctr.sa(i)+VLEN-1 downto VLEN*ctr.sa(i)),
                                                                         rb.data(VLEN*ctr.sb(i)+VLEN-1 downto VLEN*ctr.sb(i)),'1')(VLEN-1 downto 0);
                end loop;  
                rc.sat <= '1';
            when S1_USMUL =>
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= saturate_mul(ra.data(VLEN*ctr.sa(i)+VLEN-1 downto VLEN*ctr.sa(i)),
                                                                         rb.data(VLEN*ctr.sb(i)+VLEN-1 downto VLEN*ctr.sb(i)),'0')(VLEN-1 downto 0);
                end loop;  
                rc.sat <= '1';
            when S1_UMUL =>
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= unsigned_mul(ra.data(VLEN*ctr.sa(i)+VLEN-1 downto VLEN*ctr.sa(i)),
                                                                         rb.data(VLEN*ctr.sb(i)+VLEN-1 downto VLEN*ctr.sb(i)))(VLEN-1 downto 0);
                end loop;  

            -- division
            when S1_DIV => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    if rb.data(VLEN*i+VLEN-1 downto VLEN*i) = (VLEN => '0') then
                        rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= (VLEN => '1');
                            -- Error of some kind?
                    else 
                        rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= signed_div(ra.data(VLEN*ctr.sa(i)+VLEN-1 downto VLEN*ctr.sa(i)),
                                                                           rb.data(VLEN*ctr.sb(i)+VLEN-1 downto VLEN*ctr.sb(i)))(VLEN-1 downto 0);
                    end if;
                end loop;  
            when S1_UDIV => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    if rb.data(VLEN*i+VLEN-1 downto VLEN*i) = (VLEN => '0') then
                        rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= (VLEN => '1');
                            -- Error of some kind?
                    else 
                        rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= unsigned_div(ra.data(VLEN*ctr.sa(i)+VLEN-1 downto VLEN*ctr.sa(i)),
                                                                             rb.data(VLEN*ctr.sb(i)+VLEN-1 downto VLEN*ctr.sb(i)))(VLEN-1 downto 0);
                    end if;
                end loop;  

            -- Maximum and minimum 
            when S1_MAX => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= signed_max(ra.data(VLEN*ctr.sa(i)+VLEN-1 downto VLEN*ctr.sa(i)),
                                                                       rb.data(VLEN*ctr.sb(i)+VLEN-1 downto VLEN*ctr.sb(i)));
                end loop;  
            when S1_MIN => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= signed_min(ra.data(VLEN*ctr.sa(i)+VLEN-1 downto VLEN*ctr.sa(i)),
                                                                       rb.data(VLEN*ctr.sb(i)+VLEN-1 downto VLEN*ctr.sb(i)));
                end loop;  
            when S1_UMAX => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= unsigned_max(ra.data(VLEN*ctr.sa(i)+VLEN-1 downto VLEN*ctr.sa(i)),
                                                                         rb.data(VLEN*ctr.sb(i)+VLEN-1 downto VLEN*ctr.sb(i)));
                end loop;  
            when S1_UMIN => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= unsigned_min(ra.data(VLEN*ctr.sa(i)+VLEN-1 downto VLEN*ctr.sa(i)),
                                                                         rb.data(VLEN*ctr.sb(i)+VLEN-1 downto VLEN*ctr.sb(i)));
                end loop;  

            --bitwise operations have no carry so no need to loop
            when S1_AND => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= ra.data(VLEN*ctr.sa(i)+VLEN-1 downto VLEN*ctr.sa(i)) and
                                                            rb.data(VLEN*ctr.sb(i)+VLEN-1 downto VLEN*ctr.sb(i));
                end loop;  
            when S1_OR  => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= ra.data(VLEN*ctr.sa(i)+VLEN-1 downto VLEN*ctr.sa(i)) or
                                                            rb.data(VLEN*ctr.sb(i)+VLEN-1 downto VLEN*ctr.sb(i));
                end loop;  
            when S1_XOR  => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= ra.data(VLEN*ctr.sa(i)+VLEN-1 downto VLEN*ctr.sa(i)) xor
                                                            rb.data(VLEN*ctr.sb(i)+VLEN-1 downto VLEN*ctr.sb(i));
                end loop;  
            when S1_NAND => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= ra.data(VLEN*ctr.sa(i)+VLEN-1 downto VLEN*ctr.sa(i)) nand
                                                            rb.data(VLEN*ctr.sb(i)+VLEN-1 downto VLEN*ctr.sb(i));
                end loop;  
            when S1_NOR  => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= ra.data(VLEN*ctr.sa(i)+VLEN-1 downto VLEN*ctr.sa(i)) nor
                                                            rb.data(VLEN*ctr.sb(i)+VLEN-1 downto VLEN*ctr.sb(i));
                end loop;  
            when S1_XNOR  => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= ra.data(VLEN*ctr.sa(i)+VLEN-1 downto VLEN*ctr.sa(i)) xnor
                                                            rb.data(VLEN*ctr.sb(i)+VLEN-1 downto VLEN*ctr.sb(i));
                end loop;  

            when others => -- only error case
                rc.data <= ra.data;
        end case;

        for i in 0 to (XLEN/VLEN)-1 loop
            if ctr.p(i)='0' then
                rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= ra.data(VLEN*i+VLEN-1 downto VLEN*i);
            end if;
        end loop;

    end procedure stage1_ops;

    ---------------------------------------------------------------
    -- REDUCTION OPERATIONS (S2) --
    --------------------------------------------------------------
    procedure stage2_ops(signal op : in std_logic_vector (2 downto 0);
						 signal ra : in result_reg_type; 
	                     signal be : in s2byteen_reg_type;
						 signal rc : out result_reg_type) is 
	variable acc : std_logic_vector (XLEN-1 downto 0);
    begin
		rc.sat <= ra.sat;
		case op is 
			when S2_NOP => 
				acc := ra.data;
			when S2_SUM =>
                acc(XLEN-1 downto VLEN) := (others => (ra.data(VLEN-1)));
                acc(VLEN-1 downto 0) := ra.data(VLEN-1 downto 0);
				for i in 1 to (XLEN/VLEN)-1 loop
                    if ra.sat = '1' then
					    acc(VLEN-1 downto 0) := saturate_add(acc(VLEN-1 downto 0), ra.data(VLEN*i+VLEN-1 downto VLEN*i), '1');
                        acc(XLEN-1 downto VLEN) := (others => (acc(VLEN-1)));
                    else 
					    acc := add(acc, (XLEN-1 downto VLEN => (ra.data(VLEN*i+VLEN-1))) & ra.data(VLEN*i+VLEN-1 downto VLEN*i));
                    end if;
				end loop;
			when S2_USUM =>
                acc(XLEN-1 downto VLEN) := (others => '0');
                acc(VLEN-1 downto 0) := ra.data(VLEN-1 downto 0);
				for i in 1 to (XLEN/VLEN)-1 loop
                    if ra.sat = '1' then
                        acc(VLEN-1 downto 0) := saturate_add(acc(VLEN-1 downto 0), ra.data(VLEN*i+VLEN-1 downto VLEN*i), '0');
                    else 
					    acc := add(acc, ra.data(VLEN*i+VLEN-1 downto VLEN*i));
                    end if;
				end loop;
			when S2_MAX =>
                acc(VLEN-1 downto 0) := ra.data(VLEN-1 downto 0);
				for i in 1 to (XLEN/VLEN)-1 loop
                    acc(VLEN-1 downto 0) :=   signed_max(acc(VLEN-1 downto 0),
                                                         ra.data(VLEN*i+VLEN-1 downto VLEN*i));
				end loop;
                acc(XLEN-1 downto VLEN) := (others => (acc(VLEN-1)));
			when S2_MIN =>
                acc(VLEN-1 downto 0) := ra.data(VLEN-1 downto 0);
				for i in 1 to (XLEN/VLEN)-1 loop
                    acc(VLEN-1 downto 0) :=   signed_min(acc(VLEN-1 downto 0),
                                                         ra.data(VLEN*i+VLEN-1 downto VLEN*i));
				end loop;
                acc(XLEN-1 downto VLEN) := (others => (acc(VLEN-1)));
			when S2_UMAX =>
                acc(VLEN-1 downto 0) := ra.data(VLEN-1 downto 0);
				for i in 1 to (XLEN/VLEN)-1 loop
                    acc(VLEN-1 downto 0) :=   unsigned_max(acc(VLEN-1 downto 0),
                                                           ra.data(VLEN*i+VLEN-1 downto VLEN*i));
				end loop;
                acc(XLEN-1 downto VLEN) := (others => '0');
			when S2_UMIN =>
                acc(VLEN-1 downto 0) := ra.data(VLEN-1 downto 0);
				for i in 1 to (XLEN/VLEN)-1 loop
                    acc(VLEN-1 downto 0) :=   unsigned_min(acc(VLEN-1 downto 0),
                                                           ra.data(VLEN*i+VLEN-1 downto VLEN*i));
				end loop;
                acc(XLEN-1 downto VLEN) := (others => '0');
			when S2_XOR =>
                acc(XLEN-1 downto VLEN) := (others => '0');
                acc(VLEN-1 downto 0) := ra.data(VLEN-1 downto 0);
				for i in 1 to (XLEN/VLEN)-1 loop
				    acc(VLEN-1 downto 0) := acc(VLEN-1 downto 0) xor ra.data(VLEN*i+VLEN-1 downto VLEN*i);
				end loop;
			when others =>
		end case;
        rc.data <= (others => '0');
        if op = S2_NOP or unsigned(be)=0 then 
            rc.data <= acc;
        else 
            for i in 0 to (XLEN/VLEN)-1 loop
                if be(i)='1' then
                    --OPTION
                    --have an inner register that holds the value
                    --output all values in  this register
                    --register clears when be=0
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) <= acc(VLEN-1 downto 0);
                end if;
            end loop;
            -- OPTION
            -- if necessary then
            --     be<=be(be'left downto 1) & '0'
            -- end if;
        end if;

        
    end procedure stage2_ops;

    ---------------------------------------------------------------
    -- STAGE TO STAGE PROCEDURES --
    --------------------------------------------------------------
    procedure stage1_to_2(signal r_s1 : in s1_reg_type;
                          signal rs1, rs2 : in operand_reg_type;
                          signal r_ctr: in ctrl_reg_type;
                          signal r_s2 : out s2_reg_type) is
    begin
        --operation stage1 
        stage1_ops(r_s1.op1, rs1, rs2, r_ctr, r_s2.ra);
        r_s2.op2 <= r_s1.op2;
    end procedure stage1_to_2;

    procedure stage2_to_3(signal r_s2 : in s2_reg_type;
                          signal r_be : in s2byteen_reg_type;
                          signal r_s3 : out s3_reg_type) is
    begin
        --operation stage2 
        stage2_ops(r_s2.op2, r_s2.ra, r_be, r_s3.rc);
    end procedure stage2_to_3;

    procedure input_to_stage1( signal ra  : in  std_logic_vector (XLEN-1 downto 0);
                               signal rb  : in  std_logic_vector (XLEN-1 downto 0);
                               signal op  : in  std_logic_vector (7 downto 0);
                               signal r_s1 : out s1_reg_type) is
    begin
        r_s1.ra.data <= ra;
        r_s1.rb.data <= rb;
        
        r_s1.op1 <= op(4 downto 0);
        r_s1.op2 <= op(7 downto 5);

    end procedure input_to_stage1;

    procedure stage3_to_output(signal r_s3 : in s3_reg_type;
                               signal rc_data : out std_logic_vector (XLEN-1 downto 0)) is 
    begin
        rc_data <= r_s3.rc.data;
    end procedure stage3_to_output;

    -- END OF PROCEDURES --
begin
    ---------------------------------------------------------------
    -- MAIN BODY --
    --------------------------------------------------------------
    --fill stage1 register with input
    input_to_stage1(ra_i, rb_i, op_i, rin.s1);
    --stage 1 to stage 2
    -- mux 
    rs1.data <= r.s1.ra.data when ldbpa_i = '0' else ldra_i;
    rs2.data <= r.s1.rb.data when ldbpb_i = '0' else ldrb_i;

    stage1_to_2(r.s1, rs1, rs2, r.ctr, rin.s2);

    --stage 2 to stage 3
    stage2_to_3(r.s2, r.ctr.be, rin.s3);
    --fill output signals
    stage3_to_output(r.s3, rc_data_o);
    s1bp_o <= rin.s2.ra.data;
    s2bp_o <= rin.s3.rc.data;


    -- update mask
    rin.ctr.p <= mask_value_i when ctrl_reg_we_i = '1' else
                 r.ctr.p;

    rin.ctr.be <= res_byte_en_i when ctrl_reg_we_i = '1' else 
                  r.ctr.be;

    rin.ctr.sa <= swizling_set(swiz_veca_i) when ctrl_reg_we_i = '1' else
                  r.ctr.sa;

    rin.ctr.sb <= swizling_set(swiz_vecb_i) when ctrl_reg_we_i = '1' else
                  r.ctr.sb;




    ---------------------------------------------------------------
    -- REGISTER UPDATING --
    --------------------------------------------------------------
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


