library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library grlib;
use grlib.stdlib.all;

library marcmod;
use marcmod.simdmod.all;

entity simd_module is 
    port(
            -- general inputs
            clk   : in  std_ulogic;
            rstn  : in  std_ulogic;
            holdn : in  std_ulogic;
            sdi   : in  simd_in_type;
            sdo   : out  simd_out_type
        );
end;

architecture rtl of simd_module is
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
        ac : result_reg_type;
    end record;

    -- Stage1 entry register
    type s1_reg_type is record
        ra : operand_reg_type;
        rb : operand_reg_type;
        op1: std_logic_vector(4 downto 0);
        sg : std_logic;
        sat: std_logic;
        op2: std_logic_vector(2 downto 0);
        en : std_logic;
        inst : std_logic_vector(31 downto 0);
    end record; 
    
    -- Stage2 entry register
    type s2_reg_type is record
        ra : result_reg_type;
        op2: std_logic_vector(2 downto 0);
        sg : std_logic;
        sat: std_logic;
        en : std_logic;
        inst : std_logic_vector(31 downto 0);
    end record;

    -- Stage3 entry register
    type s3_reg_type is record
        rc : result_reg_type;
        inst : std_logic_vector(31 downto 0);
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
        sg => '0',
        sat => '0',
        op2 => (others => '0'),
        inst => (others => '0'),
        en => '0'
    );

    -- set the 2nd stage registers reset
    constant s2_reg_res : s2_reg_type := (
        ra => res_reg_res,
        op2 => (others => '0'),
        sg => '0',
        sat => '0',
        inst => (others => '0'),
        en => '0'
    );

    -- set the 3rd stage registers reset
    constant s3_reg_res : s3_reg_type := (
        inst => (others => '0'),
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

    function swizling_set(sz_i : std_logic_vector(XLEN/VLEN*LOGSZ-1 downto 0)) return swizling_reg_type is
        variable res_val : swizling_reg_type;
    begin
        for i in 0 to (XLEN/VLEN)-1 loop
            res_val(i) := to_integer(unsigned(sz_i(i*LOGSZ+LOGSZ-1 downto i*LOGSZ)));
        end loop;
        return res_val;
    end function swizling_set;

    function swizling_apply(data : std_logic_vector(XLEN-1 downto 0); sz : swizling_reg_type) return operand_reg_type is
        variable result : operand_reg_type;
    begin
        for i in 0 to (XLEN/VLEN)-1 loop
            result.data(VLEN*i+VLEN-1 downto VLEN*i) := data(VLEN*sz(i)+VLEN-1 downto VLEN*sz(i)); 
        end loop;
        return result;
    end function swizling_apply;

    constant ctrl_reg_res : ctrl_reg_type := (
        p => (others => '1'),
        sa => swizling_init,
        sb => swizling_init,
        be =>(others => '0'),
        ac => res_reg_res
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
    signal n_be : s2byteen_reg_type;
    signal n_ac : result_reg_type;
    type lpmul_in_array is array (0 to VSIZE-1) of lpmul_in_type;
    type lpmul_out_array is array (0 to VSIZE-1) of lpmul_out_type;
    signal muli : lpmul_in_array;
    signal mulo : lpmul_out_array;


    ---------------------------------------------------------------
    -- TWO OPERANDS OPERATIONS (S1) --
    --------------------------------------------------------------
    procedure stage1_ops(op : in std_logic_vector (4 downto 0);
                         ra : in operand_reg_type;
                         rb : in operand_reg_type;
                         mul: in std_logic_vector(XLEN-1 downto 0);
                         p  : in pred_reg_type;
						 --exceptions or errors
                         rc : out result_reg_type) is
    begin
        rc.sat := '0';
        case op is
            when S1_NOP =>
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) := ra.data(VLEN*i+VLEN-1 downto VLEN*i); 
                                                            
                end loop;  

            when S1_MOVB =>
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) := rb.data(VLEN*i+VLEN-1 downto VLEN*i); 
                                                            
                end loop;  

            --addition and saturated addition
            when S1_ADD => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) := add(ra.data(VLEN*i+VLEN-1 downto VLEN*i), 
                                                                rb.data(VLEN*i+VLEN-1 downto VLEN*i));
                end loop;  
            when S1_SADD => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) := saturate_add(ra.data(VLEN*i+VLEN-1 downto VLEN*i),
                                                                         rb.data(VLEN*i+VLEN-1 downto VLEN*i),'1');
                end loop;  
                rc.sat := '1';
            when S1_USADD => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) := saturate_add(ra.data(VLEN*i+VLEN-1 downto VLEN*i),
                                                                         rb.data(VLEN*i+VLEN-1 downto VLEN*i),'0');
                end loop;  
                rc.sat := '1';

            --subtraction and saturated subtraction
            when S1_SUB => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) := sub(ra.data(VLEN*i+VLEN-1 downto VLEN*i),
                                                                rb.data(VLEN*i+VLEN-1 downto VLEN*i));
                end loop;  
            when S1_SSUB => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) := saturate_sub(ra.data(VLEN*i+VLEN-1 downto VLEN*i),
                                                                         rb.data(VLEN*i+VLEN-1 downto VLEN*i),'1');
                end loop;  
                rc.sat := '1';
            when S1_USSUB => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) := saturate_sub(ra.data(VLEN*i+VLEN-1 downto VLEN*i),
                                                                         rb.data(VLEN*i+VLEN-1 downto VLEN*i),'0');
                end loop;  
                rc.sat := '1';

            --multiplication and saturated multiplication
            when S1_MUL |  S1_UMUL  => 
                rc.data := mul;
            when S1_SMUL | S1_USMUL =>
                rc.data := mul;
                rc.sat := '1';

          --  -- division
          --  when S1_DIV => 
          --      for i in 0 to (XLEN/VLEN)-1 loop
          --          if rb.data(VLEN*i+VLEN-1 downto VLEN*i) = (VLEN => '0') then
          --              rc.data(VLEN*i+VLEN-1 downto VLEN*i) := (VLEN => '1');
          --                  -- Error of some kind?
          --          else 
          --              rc.data(VLEN*i+VLEN-1 downto VLEN*i) := sub(ra.data(VLEN*i+VLEN-1 downto VLEN*i), --signed_div(ra.data(VLEN*i+VLEN-1 downto VLEN*i),
          --                                                                 rb.data(VLEN*i+VLEN-1 downto VLEN*i))(VLEN-1 downto 0);
          --          end if;
          --      end loop;  
          --  when S1_UDIV => 
          --      for i in 0 to (XLEN/VLEN)-1 loop
          --          if rb.data(VLEN*i+VLEN-1 downto VLEN*i) = (VLEN => '0') then
          --              rc.data(VLEN*i+VLEN-1 downto VLEN*i) := (VLEN => '1');
          --                  -- Error of some kind?
          --          else 
          --              rc.data(VLEN*i+VLEN-1 downto VLEN*i) := sub(ra.data(VLEN*i+VLEN-1 downto VLEN*i), --unsigned_div(ra.data(VLEN*i+VLEN-1 downto VLEN*i),
          --                                                                   rb.data(VLEN*i+VLEN-1 downto VLEN*i))(VLEN-1 downto 0);
          --          end if;
          --      end loop;  

            -- Maximum and minimum 
            when S1_MAX => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) := signed_max(ra.data(VLEN*i+VLEN-1 downto VLEN*i),
                                                                       rb.data(VLEN*i+VLEN-1 downto VLEN*i));
                end loop;  
            when S1_MIN => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) := signed_min(ra.data(VLEN*i+VLEN-1 downto VLEN*i),
                                                                       rb.data(VLEN*i+VLEN-1 downto VLEN*i));
                end loop;  
            when S1_UMAX => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) := unsigned_max(ra.data(VLEN*i+VLEN-1 downto VLEN*i),
                                                                         rb.data(VLEN*i+VLEN-1 downto VLEN*i));
                end loop;  
            when S1_UMIN => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) := unsigned_min(ra.data(VLEN*i+VLEN-1 downto VLEN*i),
                                                                         rb.data(VLEN*i+VLEN-1 downto VLEN*i));
                end loop;  

            --bitwise operations have no carry so no need to loop
            when S1_AND => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) := ra.data(VLEN*i+VLEN-1 downto VLEN*i) and
                                                            rb.data(VLEN*i+VLEN-1 downto VLEN*i);
                end loop;  
            when S1_OR  => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) := ra.data(VLEN*i+VLEN-1 downto VLEN*i) or
                                                            rb.data(VLEN*i+VLEN-1 downto VLEN*i);
                end loop;  
            when S1_XOR  => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) := ra.data(VLEN*i+VLEN-1 downto VLEN*i) xor
                                                            rb.data(VLEN*i+VLEN-1 downto VLEN*i);
                end loop;  
            when S1_NAND => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) := ra.data(VLEN*i+VLEN-1 downto VLEN*i) nand
                                                            rb.data(VLEN*i+VLEN-1 downto VLEN*i);
                end loop;  
            when S1_NOR  => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) := ra.data(VLEN*i+VLEN-1 downto VLEN*i) nor
                                                            rb.data(VLEN*i+VLEN-1 downto VLEN*i);
                end loop;  
            when S1_XNOR  => 
                for i in 0 to (XLEN/VLEN)-1 loop
                    rc.data(VLEN*i+VLEN-1 downto VLEN*i) := ra.data(VLEN*i+VLEN-1 downto VLEN*i) xnor
                                                            rb.data(VLEN*i+VLEN-1 downto VLEN*i);
                end loop;  

            when others => -- only error case
                rc.data := ra.data;
        end case;

        for i in 0 to (XLEN/VLEN)-1 loop
            if p(i)='0' then
                rc.data(VLEN*i+VLEN-1 downto VLEN*i) := ra.data(VLEN*i+VLEN-1 downto VLEN*i);
            end if;
        end loop;

    end procedure stage1_ops;

    ---------------------------------------------------------------
    -- REDUCTION OPERATIONS (S2) --
    --------------------------------------------------------------
    procedure stage2_ops(op : in std_logic_vector (2 downto 0);
    					 ra : in result_reg_type; 
    					 rc : out result_reg_type) is 
    variable acc : std_logic_vector (XLEN-1 downto 0);
    begin
    	rc.sat := ra.sat;
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
        rc.data := acc;
    end procedure stage2_ops;

    ---------------------------------------------------------------
    -- S2 EXTRA RESULT MANIPULATION --
    --------------------------------------------------------------
    procedure stage2_ext(be : in s2byteen_reg_type;
                         ac : in result_reg_type;
                         en : in std_logic;
                         s2_rc : in result_reg_type;
                         nbe: out s2byteen_reg_type;
                         nac: out result_reg_type;
                         rc : out result_reg_type) is 
    variable new_ac : result_reg_type;
    variable new_be : s2byteen_reg_type;
    variable new_rc : result_reg_type;
    begin 
        new_ac := ac; new_be := be; new_rc := s2_rc;
        
        if en = '1' then 
            if unsigned(be) = 0 then 
                new_ac.data := (others => '0');
            else
				for i in 0 to (XLEN/VLEN)-1 loop
                    if be(i)='1' then
                        new_ac.data(VLEN*i+VLEN-1 downto VLEN*i) := s2_rc.data(VLEN-1 downto 0);
                    end if;
				end loop;
				new_rc := new_ac;
            end if;
            new_be := be(be'left-1 downto 0) & '0';
        end if;
        nac := new_ac; nbe := new_be; rc := new_rc;
    end procedure stage2_ext;


begin
    ---------------------------------------------------------------
    -- MAIN BODY --
    --------------------------------------------------------------
    genmul : for i in 0 to XLEN/VLEN-1 generate
        mul : lpmul
            port map(muli(i), mulo(i));
        end generate genmul;


    -- CONTROL REGISTERS --
    control: process(sdi)
        variable v : registers;
    begin
        v := r;
        --v.ctr.be := n_be; v.ctr.ac := n_ac;
        if sdi.ctrl_reg_we = '1' then
            v.ctr.p := sdi.mask_value;
            v.ctr.be := sdi.res_byte_en;
            v.ctr.sa := swizling_set(sdi.swiz_veca); 
            v.ctr.sb := swizling_set(sdi.swiz_vecb);
            v.ctr.ac := res_reg_res;
        end if;
        rin.ctr <= v.ctr;
    end process;

    -- SIMD STAGES --
    comb: process(r, sdi, mulo)
        variable v : registers;
        variable rs1, rs2 : operand_reg_type;
        variable rc : result_reg_type;
        variable mulres : std_logic_vector(XLEN-1 downto 0);
        variable use_s2_ext : std_logic;
    begin
        v := r;

        -- INPUT TO S1 --
        v.s1.ra.data := sdi.ra; v.s1.rb.data := sdi.rb; v.s1.en := sdi.rc_we;
        v.s1.op1 := sdi.op1; v.s1.op2 := sdi.op2;
        v.s1.sg := not sdi.op1(4); v.s1.sat := sdi.op1(3);

        --mux data from bypasses
        rs1 := swizling_apply(r.s1.ra.data, r.ctr.sa);
        rs2 := swizling_apply(r.s1.rb.data, r.ctr.sb);

        for i in 0 to VSIZE-1 loop
            muli(i).opA <= rs1.data(VLEN*i+VLEN-1 downto VLEN*i);
            muli(i).opB <= rs2.data(VLEN*i+VLEN-1 downto VLEN*i);
            muli(i).sign <= r.s1.sg;
            muli(i).sat <= r.s1.sat;
        end loop;
        mulres := mulo(3).mul_res & mulo(2).mul_res & mulo(1).mul_res & mulo(0).mul_res;
        -- S1 TO S2 --
        stage1_ops(r.s1.op1, rs1, rs2, mulres, r.ctr.p, v.s2.ra);

        v.s2.op2 := r.s1.op2; v.s2.sg:=r.s1.op2(2);
        v.s2.sat := r.s1.sat; v.s2.en := r.s1.en;

        -- S2 TO S3 --
        stage2_ops(r.s2.op2, r.s2.ra, rc);

        use_s2_ext := '0';
        if r.s2.op2 /= S2_NOP then 
            use_s2_ext := r.s2.en;
        end if;
        stage2_ext(r.ctr.be, r.ctr.ac, use_s2_ext, rc, v.ctr.be, v.ctr.ac, v.s3.rc);

        -- S3 TO OUTPUT --
        sdo.simd_res <= r.s3.rc.data;
        sdo.s1bp <= v.s2.ra.data;
        sdo.s2bp <= v.s3.rc.data;

        -- Outputs
        rin.s1 <= v.s1; rin.s2 <= v.s2; rin.s3 <= v.s3;
        n_be <= v.ctr.be; n_ac <= v.ctr.ac;
    end process;


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


