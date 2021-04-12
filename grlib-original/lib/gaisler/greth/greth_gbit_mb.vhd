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
-----------------------------------------------------------------------------
-- Entity: 	greth_gbit_mb
-- File:	greth_gbit_mb.vhd
-- Author:	Marko Isomaki 
-- Description:	Gigabit Ethernet Media Access Controller with Ethernet Debug
--              Communication Link and dual AHB master interfaces
------------------------------------------------------------------------------
library ieee;
library grlib;
library gaisler; 
use ieee.std_logic_1164.all;
use grlib.stdlib.all;
use grlib.amba.all;
use grlib.devices.all;
library techmap;
use techmap.gencomp.all;
use gaisler.net.all;
use gaisler.ethernet_mac.all;
library eth;
use eth.ethcomp.all;

entity greth_gbit_mb is
  generic(
    hindex         : integer := 0;
    ehindex        : integer := 0;
    pindex         : integer := 0;
    paddr          : integer := 0;
    pmask          : integer := 16#FFF#;
    pirq           : integer := 0;
    memtech        : integer := 0;
    ifg_gap        : integer := 24; 
    attempt_limit  : integer := 16;
    backoff_limit  : integer := 10;
    slot_time      : integer := 128;
    mdcscaler      : integer range 0 to 255 := 25; 
    nsync          : integer range 1 to 2 := 2;
    edcl           : integer range 0 to 3 := 0;
    edclbufsz      : integer range 1 to 64 := 1;
    burstlength    : integer range 4 to 128 := 32;
    macaddrh       : integer := 16#00005E#;
    macaddrl       : integer := 16#000000#;
    ipaddrh        : integer := 16#c0a8#;
    ipaddrl        : integer := 16#0035#;
    phyrstadr      : integer range 0 to 32 := 0;
    sim            : integer range 0 to 1 := 0;
    oepol          : integer range 0 to 1 := 0;
    scanen         : integer range 0 to 1 := 0;
    ft             : integer range 0 to 2 := 0;
    edclft         : integer range 0 to 2 := 0;
    mdint_pol      : integer range 0 to 1 := 0;
    enable_mdint   : integer range 0 to 1 := 0;
    multicast      : integer range 0 to 1 := 0;
    edclsepahb     : integer range 0 to 1 := 0;
    ramdebug       : integer range 0 to 2 := 0;
    mdiohold       : integer := 1;
    gmiimode       : integer range 0 to 1 := 0;
    mdiochain      : integer range 0 to 1 := 0;  -- Not supported: Leave at zero
    iotest         : integer range 0 to 1 := 0
    );
  port(
    rst            : in  std_ulogic;
    clk            : in  std_ulogic;
    ahbmi          : in  ahb_mst_in_type;
    ahbmo          : out ahb_mst_out_type;
    ahbmi2         : in  ahb_mst_in_type;
    ahbmo2         : out ahb_mst_out_type;
    apbi           : in  apb_slv_in_type;
    apbo           : out apb_slv_out_type;
    ethi           : in  eth_in_type;
    etho           : out eth_out_type;
    mdchain_ui     : in  greth_mdiochain_down_type;  -- Set to greth_mdiochain_down_first
    mdchain_uo     : out greth_mdiochain_up_type;    -- Leave open
    mdchain_di     : out greth_mdiochain_down_type;  -- Leave open
    mdchain_do     : in  greth_mdiochain_up_type     -- Assign to greth_mdiochain_up_last
    -- Debug Interface
    ; debug_rx      : out std_logic_vector(63 downto 0);
    debug_tx        : out std_logic_vector(63 downto 0);
    debug_gtx       : out std_logic_vector(63 downto 0)
  );
end entity;
  
architecture rtl of greth_gbit_mb is
  --host constants
  constant fifosize        : integer := 512;
  constant fabits          : integer := log2(fifosize);
  constant fsize           : std_logic_vector(fabits downto 0) :=
    conv_std_logic_vector(fifosize, fabits+1);
  
  constant REVISION : amba_version_type := 0;

  constant pconfig : apb_config_type := (
  0 => ahb_device_reg ( VENDOR_GAISLER, GAISLER_ETHMAC, 0, REVISION, pirq),
  1 => apb_iobar(paddr, pmask));

  constant hconfig : ahb_config_type := (
    0 => ahb_device_reg ( VENDOR_GAISLER, GAISLER_ETHMAC, 0, REVISION, 0),
  others => zero32);

  constant ehconfig : ahb_config_type := (
    0 => ahb_device_reg ( VENDOR_GAISLER, GAISLER_EDCLMST, 0, REVISION, 0),
  others => zero32);
 
  --edcl constants
  type szvct is array (0 to 6) of integer;
  constant ebuf : szvct := (64, 128, 128, 256, 256, 256, 256);
  constant eabits: integer := log2(edclbufsz) + 8;
  constant ebufsize : integer := ebuf(log2(edclbufsz));

  signal irq : std_ulogic;
  
  --rx ahb fifo
  signal rxrenable      : std_ulogic;
  signal rxraddress     : std_logic_vector(8 downto 0);
  signal rxwrite        : std_ulogic;
  signal rxwdata        : std_logic_vector(31 downto 0);
  signal rxwaddress     : std_logic_vector(8 downto 0);
  signal rxrdata        : std_logic_vector(31 downto 0);    
  --tx ahb fifo  
  signal txrenable      : std_ulogic;
  signal txraddress     : std_logic_vector(8 downto 0);
  signal txwrite        : std_ulogic;
  signal txwdata        : std_logic_vector(31 downto 0);
  signal txwaddress     : std_logic_vector(8 downto 0);
  signal txrdata        : std_logic_vector(31 downto 0);    
  --edcl buf     
  signal erenable       : std_ulogic;
  signal eraddress      : std_logic_vector(15 downto 0);
  signal ewritem        : std_ulogic;
  signal ewritel        : std_ulogic;
  signal ewaddressm     : std_logic_vector(15 downto 0);
  signal ewaddressl     : std_logic_vector(15 downto 0);
  signal ewdata         : std_logic_vector(31 downto 0);
  signal erdata         : std_logic_vector(31 downto 0);
  -- Fix for wider bus
  signal hwdata         : std_logic_vector(31 downto 0);
  signal hrdata         : std_logic_vector(31 downto 0);
  signal ehwdata        : std_logic_vector(31 downto 0);
  signal ehrdata        : std_logic_vector(31 downto 0);

  signal mdio_o,mdio_oe : std_ulogic;

  
begin
  gtxc0: greth_gbitc
    generic map(
      ifg_gap        => ifg_gap, 
      attempt_limit  => attempt_limit,
      backoff_limit  => backoff_limit,
      slot_time      => slot_time,
      mdcscaler      => mdcscaler,
      nsync          => nsync,
      edcl           => edcl,
      edclbufsz      => edclbufsz,
      burstlength    => burstlength,
      macaddrh       => macaddrh,
      macaddrl       => macaddrl,
      ipaddrh        => ipaddrh,
      ipaddrl        => ipaddrl,
      phyrstadr      => phyrstadr,
      sim            => sim,
      oepol          => oepol,
      scanen         => scanen,
      mdint_pol      => mdint_pol,
      enable_mdint   => enable_mdint,
      multicast      => multicast,
      edclsepahbg    => edclsepahb,
      ramdebug       => ramdebug,
      mdiohold       => mdiohold,
      rgmiimode      => 0,
      gmiimode       => gmiimode,
      mdiochain      => mdiochain,
      iotest         => iotest
      )
    port map(
      rst            => rst,
      clk            => clk,
      --ahb mst in   
      hgrant         => ahbmi.hgrant(hindex),
      hready         => ahbmi.hready,
      hresp          => ahbmi.hresp,
      hrdata         => hrdata,
      --ahb mst out  
      hbusreq        => ahbmo.hbusreq,
      hlock          => ahbmo.hlock,
      htrans         => ahbmo.htrans,
      haddr          => ahbmo.haddr,
      hwrite         => ahbmo.hwrite,
      hsize          => ahbmo.hsize,
      hburst         => ahbmo.hburst,
      hprot          => ahbmo.hprot,
      hwdata         => hwdata,
      --edcl ahb mst in   
      ehgrant        => ahbmi2.hgrant(ehindex),
      ehready        => ahbmi2.hready,
      ehresp         => ahbmi2.hresp,
      ehrdata        => ehrdata,
      --edcl ahb mst out  
      ehbusreq       => ahbmo2.hbusreq,
      ehlock         => ahbmo2.hlock,
      ehtrans        => ahbmo2.htrans,
      ehaddr         => ahbmo2.haddr,
      ehwrite        => ahbmo2.hwrite,
      ehsize         => ahbmo2.hsize,
      ehburst        => ahbmo2.hburst,
      ehprot         => ahbmo2.hprot,
      ehwdata        => ehwdata,
      --apb slv in 
      psel	     => apbi.psel(pindex),
      penable	     => apbi.penable,
      paddr	     => apbi.paddr,
      pwrite	     => apbi.pwrite,
      pwdata	     => apbi.pwdata,
      --apb slv out
      prdata	     => apbo.prdata,
      --irq
      irq            => irq,
      --rx ahb fifo
      rxrenable      => rxrenable,
      rxraddress     => rxraddress,
      rxwrite        => rxwrite,
      rxwdata        => rxwdata,
      rxwaddress     => rxwaddress,
      rxrdata        => rxrdata,
      --tx ahb fifo  
      txrenable      => txrenable,
      txraddress     => txraddress,
      txwrite        => txwrite,
      txwdata        => txwdata,
      txwaddress     => txwaddress,
      txrdata        => txrdata,   
      --edcl buf
      erenable       => erenable,
      eraddress      => eraddress,
      ewritem        => ewritem,
      ewritel        => ewritel,
      ewaddressm     => ewaddressm,
      ewaddressl     => ewaddressl,
      ewdata         => ewdata,
      erdata         => erdata,
      --ethernet input signals
      gtx_clk        => ethi.gtx_clk,  
      tx_clk         => ethi.tx_clk,
      tx_dv          => ethi.tx_dv,
      rx_clk         => ethi.rx_clk,
      rxd            => ethi.rxd,  
      rx_dv          => ethi.rx_dv,
      rx_er          => ethi.rx_er,
      rx_col         => ethi.rx_col,
      rx_crs         => ethi.rx_crs,
      rx_en          => ethi.rx_en,
      mdio_i         => ethi.mdio_i,
      phyrstaddr     => ethi.phyrstaddr,
      mdint          => ethi.mdint,
      --ethernet output signals
      reset          => etho.reset,
      txd            => etho.txd,
      tx_en          => etho.tx_en,
      tx_er          => etho.tx_er,
      mdc            => etho.mdc,
      mdio_o         => mdio_o,
      mdio_oe        => mdio_oe,
      --scantest     
      testrst        => ahbmi.testrst,
      testen         => ahbmi.testen,
      testoen        => ahbmi.testoen,
      --cfg
      edcladdr       => ethi.edcladdr,
      edclsepahb     => ethi.edclsepahb,
      edcldisable    => ethi.edcldisable,
      speed          => etho.speed,
      gbit           => etho.gbit,
      -- mdio sharing
      mdiochain_first => mdchain_ui.first,
      mdiochain_ticki => mdchain_ui.tick,
      mdiochain_datai => mdchain_ui.mdio_i,
      mdiochain_locko => mdchain_uo.lock,
      mdiochain_ticko => mdchain_di.tick,
      mdiochain_i     => mdchain_di.mdio_i,
      mdiochain_locki => mdchain_do.lock,
      mdiochain_o     => mdchain_do.mdio_o,
      mdiochain_oe    => mdchain_do.mdio_oe,
      -- Debug
      debug_rx        => debug_rx,
      debug_tx        => debug_tx,
      debug_gtx       => debug_gtx
      );

  etho.tx_clk <= '0';                   -- driven in rgmii component
  
  irqdrv : process(irq)
  begin
    apbo.pirq       <= (others => '0');
    apbo.pirq(pirq) <= irq;
  end process;

  hrdata <= ahbreadword(ahbmi.hrdata);
    
  ahbmo.hwdata  <= ahbdrivedata(hwdata);
  ahbmo.hconfig <= hconfig;
  ahbmo.hindex  <= hindex;
  ahbmo.hirq    <= (others => '0');

  ehrdata <= ahbreadword(ahbmi2.hrdata);

  ahbmo2.hwdata  <= ahbdrivedata(ehwdata);
  ahbmo2.hconfig <= ehconfig;
  ahbmo2.hindex  <= ehindex;
  ahbmo2.hirq    <= (others => '0');
  
  apbo.pconfig  <= pconfig;
  apbo.pindex   <= pindex;

  etho.mdio_o <= mdio_o;
  etho.mdio_oe <= mdio_oe;
  mdchain_di.first <= '0';
  mdchain_uo.mdio_o <= mdio_o;
  mdchain_uo.mdio_oe <= mdio_oe;

-------------------------------------------------------------------------------
-- FIFOS ----------------------------------------------------------------------
-------------------------------------------------------------------------------
  nft : if ft = 0 generate
    tx_fifo0 : syncram_2p generic map(tech => memtech, abits => fabits,
      dbits => 32, sepclk => 0, testen => scanen, custombits => memtest_vlen)
      port map(clk, txrenable, txraddress(fabits-1 downto 0), txrdata, clk,
      txwrite, txwaddress(fabits-1 downto 0), txwdata, ahbmi.testin
               );

    rx_fifo0 : syncram_2p generic map(tech => memtech, abits => fabits,
      dbits => 32, sepclk => 0, testen => scanen, custombits => memtest_vlen)
      port map(clk, rxrenable, rxraddress(fabits-1 downto 0), rxrdata, clk,
      rxwrite, rxwaddress(fabits-1 downto 0), rxwdata, ahbmi.testin
               );

  end generate;

-------------------------------------------------------------------------------
-- EDCL buffer ram ------------------------------------------------------------
-------------------------------------------------------------------------------
  edclramnft : if (edcl /= 0) and (edclft = 0) generate
    r0 : syncram_2p generic map (memtech, eabits, 16, 0, 0, scanen, 0, memtest_vlen) port map (
      clk, erenable, eraddress(eabits-1 downto 0), erdata(31 downto 16), clk,
      ewritem, ewaddressm(eabits-1 downto 0), ewdata(31 downto 16), ahbmi.testin
      );
    r1 : syncram_2p generic map (memtech, eabits, 16, 0, 0, scanen, 0, memtest_vlen) port map (
      clk, erenable, eraddress(eabits-1 downto 0), erdata(15 downto 0), clk,
      ewritel, ewaddressl(eabits-1 downto 0), ewdata(15 downto 0), ahbmi.testin
      );
  end generate;

-- pragma translate_off
  bootmsg : report_version 
  generic map (
    "greth" & tost(hindex) & ": 10/100/1000 Mbit Ethernet MAC rev " &
    tost(REVISION) & tost(hindex) & ", EDCL " & tost(edcl) & ", buffer " & 
    tost(edclbufsz*edcl) & " kbyte " & tost(fifosize) & " txfifo, " &
    " irq " & tost(pirq) 
  );
-- pragma translate_on

end architecture;

