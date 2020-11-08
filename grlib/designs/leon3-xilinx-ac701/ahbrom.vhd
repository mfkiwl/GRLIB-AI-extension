
----------------------------------------------------------------------------
--  This file is a part of the GRLIB VHDL IP LIBRARY
--  Copyright (C) 2009 Aeroflex Gaisler
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

signal romdata : std_logic_vector(31 downto 0);
signal addr : std_logic_vector(abits-1 downto 2);
signal hsel, hready : std_ulogic;

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
    case conv_integer(addr) is
    when 16#00000# => romdata <= X"00000000";
    when 16#00001# => romdata <= X"00000000";
    when 16#00002# => romdata <= X"00000000";
    when 16#00003# => romdata <= X"00000000";
    when 16#00004# => romdata <= X"00000000";
    when 16#00005# => romdata <= X"00000000";
    when 16#00006# => romdata <= X"00000000";
    when 16#00007# => romdata <= X"00000000";
    when 16#00008# => romdata <= X"00000000";
    when 16#00009# => romdata <= X"00000000";
    when 16#0000A# => romdata <= X"00000000";
    when 16#0000B# => romdata <= X"00000000";
    when 16#0000C# => romdata <= X"00000000";
    when 16#0000D# => romdata <= X"00000000";
    when 16#0000E# => romdata <= X"00000000";
    when 16#0000F# => romdata <= X"00000000";
    when 16#00010# => romdata <= X"00000000";
    when 16#00011# => romdata <= X"00000000";
    when 16#00012# => romdata <= X"00000000";
    when 16#00013# => romdata <= X"00000000";
    when 16#00014# => romdata <= X"00000000";
    when 16#00015# => romdata <= X"00000000";
    when 16#00016# => romdata <= X"00000000";
    when 16#00017# => romdata <= X"00000000";
    when 16#00018# => romdata <= X"00000000";
    when 16#00019# => romdata <= X"00000000";
    when 16#0001A# => romdata <= X"00000000";
    when 16#0001B# => romdata <= X"00000000";
    when 16#0001C# => romdata <= X"00000000";
    when 16#0001D# => romdata <= X"00000000";
    when 16#0001E# => romdata <= X"00000000";
    when 16#0001F# => romdata <= X"00000000";
    when 16#00020# => romdata <= X"00000000";
    when 16#00021# => romdata <= X"00000000";
    when 16#00022# => romdata <= X"00000000";
    when 16#00023# => romdata <= X"00000000";
    when 16#00024# => romdata <= X"00000000";
    when 16#00025# => romdata <= X"00000000";
    when 16#00026# => romdata <= X"00000000";
    when 16#00027# => romdata <= X"00000000";
    when 16#00028# => romdata <= X"00000000";
    when 16#00029# => romdata <= X"00000000";
    when 16#0002A# => romdata <= X"00000000";
    when 16#0002B# => romdata <= X"00000000";
    when 16#0002C# => romdata <= X"00000000";
    when 16#0002D# => romdata <= X"00000000";
    when 16#0002E# => romdata <= X"00000000";
    when 16#0002F# => romdata <= X"00000000";
    when 16#00030# => romdata <= X"00000000";
    when 16#00031# => romdata <= X"00000000";
    when 16#00032# => romdata <= X"00000000";
    when 16#00033# => romdata <= X"00000000";
    when 16#00034# => romdata <= X"00000000";
    when 16#00035# => romdata <= X"00000000";
    when 16#00036# => romdata <= X"00000000";
    when 16#00037# => romdata <= X"00000000";
    when 16#00038# => romdata <= X"00000000";
    when 16#00039# => romdata <= X"00000000";
    when 16#0003A# => romdata <= X"00000000";
    when 16#0003B# => romdata <= X"00000000";
    when 16#0003C# => romdata <= X"00000000";
    when 16#0003D# => romdata <= X"00000000";
    when 16#0003E# => romdata <= X"00000000";
    when 16#0003F# => romdata <= X"00000000";
    when 16#00040# => romdata <= X"00000000";
    when 16#00041# => romdata <= X"00000000";
    when 16#00042# => romdata <= X"00000000";
    when 16#00043# => romdata <= X"00000000";
    when 16#00044# => romdata <= X"00000000";
    when 16#00045# => romdata <= X"00000000";
    when 16#00046# => romdata <= X"00000000";
    when 16#00047# => romdata <= X"00000000";
    when 16#00048# => romdata <= X"00000000";
    when 16#00049# => romdata <= X"00000000";
    when 16#0004A# => romdata <= X"00000000";
    when 16#0004B# => romdata <= X"00000000";
    when 16#0004C# => romdata <= X"00000000";
    when 16#0004D# => romdata <= X"00000000";
    when 16#0004E# => romdata <= X"00000000";
    when 16#0004F# => romdata <= X"00000000";
    when 16#00050# => romdata <= X"00000000";
    when 16#00051# => romdata <= X"00000000";
    when 16#00052# => romdata <= X"00000000";
    when 16#00053# => romdata <= X"00000000";
    when 16#00054# => romdata <= X"00000000";
    when 16#00055# => romdata <= X"00000000";
    when 16#00056# => romdata <= X"00000000";
    when 16#00057# => romdata <= X"00000000";
    when 16#00058# => romdata <= X"00000000";
    when 16#00059# => romdata <= X"00000000";
    when 16#0005A# => romdata <= X"00000000";
    when 16#0005B# => romdata <= X"00000000";
    when 16#0005C# => romdata <= X"00000000";
    when 16#0005D# => romdata <= X"00000000";
    when 16#0005E# => romdata <= X"00000000";
    when 16#0005F# => romdata <= X"00000000";
    when 16#00060# => romdata <= X"00000000";
    when 16#00061# => romdata <= X"00000000";
    when 16#00062# => romdata <= X"00000000";
    when 16#00063# => romdata <= X"00000000";
    when 16#00064# => romdata <= X"00000000";
    when 16#00065# => romdata <= X"00000000";
    when 16#00066# => romdata <= X"00000000";
    when 16#00067# => romdata <= X"00000000";
    when 16#00068# => romdata <= X"00000000";
    when 16#00069# => romdata <= X"00000000";
    when 16#0006A# => romdata <= X"00000000";
    when 16#0006B# => romdata <= X"00000000";
    when 16#0006C# => romdata <= X"00000000";
    when 16#0006D# => romdata <= X"00000000";
    when 16#0006E# => romdata <= X"00000000";
    when 16#0006F# => romdata <= X"00000000";
    when 16#00070# => romdata <= X"00000000";
    when 16#00071# => romdata <= X"00000000";
    when 16#00072# => romdata <= X"00000000";
    when 16#00073# => romdata <= X"00000000";
    when 16#00074# => romdata <= X"00000000";
    when 16#00075# => romdata <= X"00000000";
    when 16#00076# => romdata <= X"00000000";
    when 16#00077# => romdata <= X"00000000";
    when 16#00078# => romdata <= X"00000000";
    when 16#00079# => romdata <= X"00000000";
    when 16#0007A# => romdata <= X"00000000";
    when 16#0007B# => romdata <= X"00000000";
    when 16#0007C# => romdata <= X"00000000";
    when 16#0007D# => romdata <= X"00000000";
    when 16#0007E# => romdata <= X"00000000";
    when 16#0007F# => romdata <= X"00000000";
    when 16#00080# => romdata <= X"00000000";
    when 16#00081# => romdata <= X"00000000";
    when 16#00082# => romdata <= X"00000000";
    when 16#00083# => romdata <= X"00000000";
    when 16#00084# => romdata <= X"00000000";
    when 16#00085# => romdata <= X"00000000";
    when 16#00086# => romdata <= X"00000000";
    when 16#00087# => romdata <= X"00000000";
    when 16#00088# => romdata <= X"00000000";
    when 16#00089# => romdata <= X"00000000";
    when 16#0008A# => romdata <= X"00000000";
    when 16#0008B# => romdata <= X"00000000";
    when 16#0008C# => romdata <= X"00000000";
    when others => romdata <= (others => '-');
    end case;
  end process;
  -- pragma translate_off
  bootmsg : report_version 
  generic map ("ahbrom" & tost(hindex) &
  ": 32-bit AHB ROM Module,  " & tost(bytes/4) & " words, " & tost(abits-2) & " address bits" );
  -- pragma translate_on
  end;

