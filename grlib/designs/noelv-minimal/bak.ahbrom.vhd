
----------------------------------------------------------------------------
--  This file is a part of the GRLIB VHDL IP LIBRARY
--  Copyright (C) 2010 Aeroflex Gaisler
----------------------------------------------------------------------------
-- Entity: 	ahbrom
-- File:	ahbrom.vhd
-- Author:	Jiri Gaisler - Gaisler Research
-- Description:	AHB rom. 0/1-waitstate read
----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;

entity ahbrom is
  generic (
    hindex  : integer := 0;
    haddr   : integer := 0;
    hmask   : integer := 16#fff#;
    pipe    : integer := 0;
    tech    : integer := 0;
    kbytes  : integer := 1);
  port (
    rst     : in  std_ulogic;
    clk     : in  std_ulogic;
    ahbsi   : in  ahb_slv_in_type;
    ahbso   : out ahb_slv_out_type
  );
end;

architecture rtl of ahbrom is
constant abits : integer := 10;
constant bytes : integer := 560;


constant hconfig : ahb_config_type := (
  0 => ahb_device_reg ( VENDOR_GAISLER, GAISLER_AHBROM, 0, 0, 0),
  4 => ahb_membar(haddr, '1', '1', hmask), others => zero32);

signal romdata : std_logic_vector(127 downto 0);
signal addr : std_logic_vector(abits-1 downto 2);
signal hsel, hready : std_ulogic;
signal full_addr : std_logic_vector(31 downto 0);

begin

  ahbso.hresp   <= "00"; 
  ahbso.hsplit  <= (others => '0'); 
  ahbso.hirq    <= (others => '0');
  ahbso.hconfig <= hconfig;
  ahbso.hindex  <= hindex;

  reg : process (clk)
  begin
    if rising_edge(clk) then 
      addr <= ahbsi.haddr(abits-1 downto 2);
      full_addr <= ahbsi.haddr;
    end if;
  end process;

  p0 : if pipe = 0 generate
    ahbso.hrdata  <= ahbdrivedata(romdata);
    ahbso.hready  <= '1';
  end generate;

  p1 : if pipe = 1 generate
    reg2 : process (clk)
    begin
      if rising_edge(clk) then
	hsel <= ahbsi.hsel(hindex) and ahbsi.htrans(1);
	hready <= ahbsi.hready;
	ahbso.hready <=  (not rst) or (hsel and hready) or
	  (ahbsi.hsel(hindex) and not ahbsi.htrans(1) and ahbsi.hready);
	ahbso.hrdata  <= ahbdrivedata(romdata);
      end if;
    end process;
  end generate;

  comb : process (addr)
  begin
    case conv_integer(addr(abits-1 downto 4) is
    when 16#00000# => romdata <= X"00000013";
    when 16#00001# => romdata <= X"00000113"; 
    when 16#00004# => romdata <= X"00000213";
    when 16#00003# => romdata <= X"00000313";
    when 16#00002# => romdata <= X"00000213";

    when 16#00006# => romdata <= X"00000413";
    when 16#00005# => romdata <= X"00000513";
    when 16#00008# => romdata <= X"00000613";
    when 16#00007# => romdata <= X"00000713";

    when 16#0000A# => romdata <= X"00000813";
    when 16#00009# => romdata <= X"00000913";
    when 16#0000C# => romdata <= X"00000A13";
    when 16#0000B# => romdata <= X"00000B13";

    when 16#0000E# => romdata <= X"00000C13";
    when 16#0000D# => romdata <= X"00000D13";
    when 16#00010# => romdata <= X"00000E13";
    when 16#0000F# => romdata <= X"00000F13";

    when 16#00012# => romdata <= X"00001013";
    when 16#00011# => romdata <= X"00001113";
    when 16#00014# => romdata <= X"00001213";
    when 16#00013# => romdata <= X"00001313";

    when 16#00016# => romdata <= X"00001413";
    when 16#00015# => romdata <= X"00001513";
    when 16#00018# => romdata <= X"00001613";
    when 16#00017# => romdata <= X"00001713";

    when others => romdata <= (others => '-');
    end case;
  end process;
  -- pragma translate_off
  bootmsg : report_version 
  generic map ("ahbrom" & tost(hindex) &
  ": 32-bit AHB ROM Module,  " & tost(bytes/4) & " words, " & tost(abits-2) & " address bits" );
  -- pragma translate_on
  end;

