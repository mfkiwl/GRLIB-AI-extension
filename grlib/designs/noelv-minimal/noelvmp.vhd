------------------------------------------------------------------------------
--  LEON3 Demonstration design
--  Copyright (C) 2013 Aeroflex Gaisler
------------------------------------------------------------------------------
--  This file is a part of the GRLIB VHDL IP LIBRARY
--  Copyright (C) 2003 - 2008, Gaisler Research
--  Copyright (C) 2008 - 2014, Aeroflex Gaisler
--  Copyright (C) 2015 - 2020, Cobham Gaisler
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library techmap;
use techmap.gencomp.all;
use techmap.allclkgen.all;
library gaisler;
use gaisler.memctrl.all;
--use gaisler.leon3.all;
use gaisler.noelvint.all;
use gaisler.noelv.all;
use gaisler.plic.all;
use gaisler.riscv.all;
use gaisler.uart.all;
use gaisler.misc.all;
use gaisler.jtag.all;
--pragma translate_off
use gaisler.sim.all;
--pragma translate_on
library esa;
use esa.memoryctrl.all;
use work.config.all;

entity noelvmp is
  generic (
    fabtech  : integer := CFG_FABTECH;
    memtech  : integer := CFG_MEMTECH;
    padtech  : integer := CFG_PADTECH;
    clktech  : integer := CFG_CLKTECH
    );
  port (
    clk             : in    std_ulogic; -- FPGA main clock input
   
   -- Buttons & LEDs
    btnCpuResetn    : in    std_ulogic; -- Reset button
    led             : out   std_logic_vector(15 downto 0);
    
    -- Onboard Cellular RAM
    RamOE           : out   std_ulogic;
    RamWE           : out   std_ulogic;
    RamAdv          : out   std_ulogic;
    RamCE           : out   std_ulogic;
    RamClk          : out   std_ulogic;
    RamCRE          : out   std_ulogic;
    RamLB           : out   std_ulogic;
    RamUB           : out   std_ulogic;

    address         : out   std_logic_vector(22 downto 0);
    data            : inout std_logic_vector(31 downto 0);
    
    -- USB-RS232 interface
    RsRx            : in    std_logic;
    RsTx            : out   std_logic
  );
end;

architecture rtl of noelvmp is
  signal vcc : std_logic;
  signal gnd : std_logic;
  constant disas : integer := 1;
  constant nextmst  : integer := 0;
  constant ndbgmst  : integer := 2;
  constant nextapb  : integer := 2;
  constant nextslv  : integer := 3;

  -- Memory controler signals
  signal memi : memory_in_type;
  signal memo : memory_out_type;
  signal wpo  : wprot_out_type;
  
  -- AMBA bus signals
  signal apbi  : apb_slv_in_vector;
  signal apbo  : apb_slv_out_vector := (others => apb_none);
  signal ahbsi : ahb_slv_in_type;
  signal ahbso : ahb_slv_out_vector := (others => ahbs_none);
  signal ahbmi : ahb_mst_in_type;
  signal ahbmo : ahb_mst_out_vector := (others => ahbm_none);
  signal dbgsi : ahb_slv_in_vector;
  signal dbgso : ahb_slv_out_vector := (others => ahbs_none);
  signal dbgmi : ahb_mst_in_vector_type(ndbgmst-1 downto 0);
  signal dbgmo : ahb_mst_out_vector_type(ndbgmst-1 downto 0);

  signal cgi : clkgen_in_type;
  signal cgo : clkgen_out_type;

  signal u1i, dui : uart_in_type;
  signal u1o, duo : uart_out_type;

  signal dbgi : nv_debug_in_vector(0 to 0);
  signal dbgo : nv_debug_out_vector(0 to 0);

  signal dsui : nv_dm_in_type;
  signal dsuo : nv_dm_out_type;
  signal ndsuact : std_ulogic;

  signal gpti : gptimer_in_type;

  signal clkm, rstn         : std_ulogic;
  signal tck, tms, tdi, tdo : std_ulogic;
  signal rstraw             : std_logic;
  signal lock               : std_logic;
  signal errorn : std_logic;
  
  constant ncpu : integer := 1;

  signal eip    : std_logic_vector(ncpu*4-1 downto 0);
  signal fpui    : grfpu5_in_vector(0 to ncpu-1);
  signal fpuo    : grfpu5_out_vector(0 to ncpu-1);

  -- RS232 APB Uart (unconnected)
  signal rxd1 : std_logic;
  signal txd1 : std_logic;
  
  attribute keep                     : boolean;
  attribute keep of lock             : signal is true;
  attribute keep of clkm             : signal is true;



  constant clock_mult : integer := 10;      -- Clock multiplier
  constant clock_div  : integer := 20;      -- Clock divider
  constant BOARD_FREQ : integer := 100000;  -- CLK input frequency in KHz
  constant CPU_FREQ   : integer := BOARD_FREQ * clock_mult / clock_div;  -- CPU freq in KHz
begin

----------------------------------------------------------------------
---  Reset and Clock generation  -------------------------------------
----------------------------------------------------------------------

  vcc <= '1';
  gnd <= '0';

  cgi.pllctrl <= "00";
  cgi.pllrst <= rstraw;

  rst0 : rstgen generic map (acthigh => 0)
    port map (btnCpuResetn, clkm, lock, rstn, rstraw);
  lock <= cgo.clklock;

  -- clock generator
  clkgen0 : clkgen
    generic map (fabtech, clock_mult, clock_div, 0, 0, 0, 0, 0, BOARD_FREQ, 0)
    port map (clk, gnd, clkm, open, open, open, open, cgi, cgo, open, open, open);
  
-----------------------------------------------------------------------
--  NOEL-V SUBSYSTEM generation  --------------------------------------
-----------------------------------------------------------------------

  sys0 : noelvsys
    generic map(fabtech, memtech, 0, 1, nextmst, nextslv, nextapb, ndbgmst, 0, 16#40FF#,
                32, 0, 0, disas, 0, CFG_CFG, 0, 3, 0, 1)
    port map (clk, rstn, ahbmi, ahbmo(ncpu+nextmst-1 downto ncpu), ahbsi, 
              ahbso(nextslv-1 downto 0), dbgmi(ndbgmst-1 downto 0), 
              dbgmo(ndbgmst-1 downto 0), apbi, apbo, '1', '0', errorn, u1i, u1o);

    led(3) <= errorn;


-----------------------------------------------------------------------
--  Debug bus connections  --------------------------------------------
-----------------------------------------------------------------------

  dcom0 : ahbuart generic map (hindex => 0, pindex => 1, paddr => 7)
    port map (rstn, clkm, dui, duo, apbi(1), apbo(1), dbgmi(0), dbgmo(0));
  dsurx_pad : inpad generic map (tech  => padtech) port map (RsRx, dui.rxd);
  dsutx_pad : outpad generic map (tech => padtech) port map (RsTx, duo.txd);

  ahbjtag0 : ahbjtag generic map(tech => fabtech, hindex => 1)
    port map(rstn, clkm, tck, tms, tdi, tdo, dbgmi(1), dbgmo(1),
             open, open, open, open, open, open, open, gnd);

-----------------------------------------------------------------------
--  Memory controllers  -----------------------------------------------
-----------------------------------------------------------------------
  -- LEON2 memory controller
  sr1 : mctrl generic map (hindex => 0, pindex => 0, paddr => 0, rommask => 0,
      iomask => 0, ram8 => 0, ram16 => 0, srbanks=>1)
    port map (rstn, clkm, memi, memo, ahbsi, ahbso(0), apbi(0), apbo(0), wpo, open);

  memi.brdyn  <= '1';
  memi.bexcn  <= '1';
  memi.writen <= '1';
  memi.wrn    <= "1111";
  memi.bwidth <= "01";   -- Sets data bus width for PROM accesses.
  
  -- Bidirectional data bus
  bdr  : iopadv generic map (tech => padtech, width => 16)
    port map (data(15 downto 0), memo.data(15 downto 0),
              memo.bdrive(1), memi.data(15 downto 0));
  bdr2 : iopadv generic map (tech => padtech, width => 16)
    port map (data(31 downto 16), memo.data(31 downto 16),
              memo.bdrive(0), memi.data(31 downto 16));
  
  -- Out signals to memory
  addr_pad : outpadv generic map (tech => padtech, width => 23) -- Address bus
    port map (address, memo.address(23 downto 1));
  oen_pad : outpad generic map (tech => padtech)  -- Output Enable
    port map (RamOE, memo.oen);
  cs_pad : outpad generic map (tech => padtech)   -- SRAM Chip select
    port map (RamCE, memo.ramsn(0));
  lb_pad : outpad generic map (tech => padtech)
    port map (RamLB, memo.mben(0));
  ub_pad : outpad generic map (tech => padtech)
    port map (RamUB, memo.mben(1));
  wri_pad : outpad generic map (tech => padtech)  -- Write enable
    port map (RamWE, memo.writen);

  RamCRE <= '0';  -- Special SRAM signals specific
  RamClk <= '0';  -- to Nexys4 board
  RamAdv <= '0';

-----------------------------------------------------------------------
---  AHB ROM ----------------------------------------------------------
-----------------------------------------------------------------------

  brom : entity work.ahbrom
    generic map (hindex => 1, haddr => CFG_AHBRODDR, pipe => CFG_AHBROPIP)
    port map ( rstn, clkm, ahbsi, ahbso(1));
  

-----------------------------------------------------------------------
--  Test report module, only used for simulation ----------------------
-----------------------------------------------------------------------

--pragma translate_off
  test0 : ahbrep generic map (hindex => 2, haddr => 16#200#)
    port map (rstn, clkm, ahbsi, ahbso(2));
--pragma translate_on


-----------------------------------------------------------------------
---  Boot message  ----------------------------------------------------
-----------------------------------------------------------------------

-- pragma translate_off
  x : report_design
    generic map (
      msg1 => "NOEL-V Demonstration design",
      fabtech => tech_table(fabtech), memtech => tech_table(memtech),
      mdel => 1
      );
-- pragma translate_on

end rtl;

