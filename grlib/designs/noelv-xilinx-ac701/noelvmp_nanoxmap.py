#Project File for Nanoxmap/Nanoxpython
import os
import sys
from os import path
from nxmap import *
dir = os.path.dirname(os.path.realpath(__file__))
sys.path.append(dir)
project = createProject(dir)
project.setVariantName('xc7a200t-fbg676-2')
project.setTopCellName('work', 'noelvmp')


# Add files for synthesis
project.addFile('grlib','../../lib/grlib/stdlib/version.vhd')
project.addFile('grlib','../../lib/grlib/stdlib/config_types.vhd')
project.addFile('grlib','grlib_config.vhd')
project.addFile('grlib','../../lib/grlib/stdlib/stdlib.vhd')
project.addFile('grlib','../../lib/grlib/sparc/sparc.vhd')
project.addFile('grlib','../../lib/grlib/riscv/riscv.vhd')
project.addFile('grlib','../../lib/grlib/modgen/multlib.vhd')
project.addFile('grlib','../../lib/grlib/modgen/leaves.vhd')
project.addFile('grlib','../../lib/grlib/amba/amba.vhd')
project.addFile('grlib','../../lib/grlib/amba/devices.vhd')
project.addFile('grlib','../../lib/grlib/amba/defmst.vhd')
project.addFile('grlib','../../lib/grlib/amba/apbctrl.vhd')
project.addFile('grlib','../../lib/grlib/amba/apbctrlx.vhd')
project.addFile('grlib','../../lib/grlib/amba/apbctrldp.vhd')
project.addFile('grlib','../../lib/grlib/amba/apbctrlsp.vhd')
project.addFile('grlib','../../lib/grlib/amba/ahbctrl.vhd')
project.addFile('grlib','../../lib/grlib/amba/dma2ahb_pkg.vhd')
project.addFile('grlib','../../lib/grlib/amba/dma2ahb.vhd')
project.addFile('grlib','../../lib/grlib/amba/ahbmst.vhd')
project.addFile('grlib','../../lib/grlib/amba/ahblitm2ahbm.vhd')
project.addFile('grlib','../../lib/grlib/dftlib/dftlib.vhd')
project.addFile('grlib','../../lib/grlib/dftlib/synciotest.vhd')
project.addFile('grlib','../../lib/grlib/generic_bm/generic_bm_pkg.vhd')
project.addFile('grlib','../../lib/grlib/generic_bm/ahb_be.vhd')
project.addFile('grlib','../../lib/grlib/generic_bm/axi4_be.vhd')
project.addFile('grlib','../../lib/grlib/generic_bm/bmahbmst.vhd')
project.addFile('grlib','../../lib/grlib/generic_bm/bm_fre.vhd')
project.addFile('grlib','../../lib/grlib/generic_bm/bm_me_rc.vhd')
project.addFile('grlib','../../lib/grlib/generic_bm/bm_me_wc.vhd')
project.addFile('grlib','../../lib/grlib/generic_bm/fifo_control_rc.vhd')
project.addFile('grlib','../../lib/grlib/generic_bm/fifo_control_wc.vhd')
project.addFile('grlib','../../lib/grlib/generic_bm/generic_bm_ahb.vhd')
project.addFile('grlib','../../lib/grlib/generic_bm/generic_bm_axi.vhd')
project.addFile('techmap','../../lib/techmap/gencomp/gencomp.vhd')
project.addFile('techmap','../../lib/techmap/gencomp/netcomp.vhd')
project.addFile('techmap','../../lib/techmap/inferred/memory_inferred.vhd')
project.addFile('techmap','../../lib/techmap/inferred/ddr_inferred.vhd')
project.addFile('techmap','../../lib/techmap/inferred/mul_inferred.vhd')
project.addFile('techmap','../../lib/techmap/inferred/ddr_phy_inferred.vhd')
project.addFile('techmap','../../lib/techmap/inferred/ddrphy_datapath.vhd')
project.addFile('techmap','../../lib/techmap/inferred/fifo_inferred.vhd')
project.addFile('techmap','../../lib/techmap/unisim/memory_kintex7.vhd')
project.addFile('techmap','../../lib/techmap/unisim/memory_ultrascale.vhd')
project.addFile('techmap','../../lib/techmap/unisim/memory_unisim.vhd')
project.addFile('techmap','../../lib/techmap/unisim/buffer_unisim.vhd')
project.addFile('techmap','../../lib/techmap/unisim/pads_unisim.vhd')
project.addFile('techmap','../../lib/techmap/unisim/clkgen_unisim.vhd')
project.addFile('techmap','../../lib/techmap/unisim/tap_unisim.vhd')
project.addFile('techmap','../../lib/techmap/unisim/ddr_unisim.vhd')
project.addFile('techmap','../../lib/techmap/unisim/ddr_phy_unisim.vhd')
project.addFile('techmap','../../lib/techmap/unisim/sysmon_unisim.vhd')
project.addFile('techmap','../../lib/techmap/unisim/mul_unisim.vhd')
project.addFile('techmap','../../lib/techmap/unisim/spictrl_unisim.vhd')
project.addFile('techmap','../../lib/techmap/maps/allclkgen.vhd')
project.addFile('techmap','../../lib/techmap/maps/techbuf.vhd')
project.addFile('techmap','../../lib/techmap/maps/allddr.vhd')
project.addFile('techmap','../../lib/techmap/maps/allmem.vhd')
project.addFile('techmap','../../lib/techmap/maps/allmul.vhd')
project.addFile('techmap','../../lib/techmap/maps/allpads.vhd')
project.addFile('techmap','../../lib/techmap/maps/alltap.vhd')
project.addFile('techmap','../../lib/techmap/maps/clkgen.vhd')
project.addFile('techmap','../../lib/techmap/maps/clkmux.vhd')
project.addFile('techmap','../../lib/techmap/maps/clkinv.vhd')
project.addFile('techmap','../../lib/techmap/maps/clkand.vhd')
project.addFile('techmap','../../lib/techmap/maps/grgates.vhd')
project.addFile('techmap','../../lib/techmap/maps/ddr_ireg.vhd')
project.addFile('techmap','../../lib/techmap/maps/ddr_oreg.vhd')
project.addFile('techmap','../../lib/techmap/maps/clkpad.vhd')
project.addFile('techmap','../../lib/techmap/maps/clkpad_ds.vhd')
project.addFile('techmap','../../lib/techmap/maps/inpad.vhd')
project.addFile('techmap','../../lib/techmap/maps/inpad_ds.vhd')
project.addFile('techmap','../../lib/techmap/maps/iodpad.vhd')
project.addFile('techmap','../../lib/techmap/maps/iopad.vhd')
project.addFile('techmap','../../lib/techmap/maps/iopad_ds.vhd')
project.addFile('techmap','../../lib/techmap/maps/lvds_combo.vhd')
project.addFile('techmap','../../lib/techmap/maps/odpad.vhd')
project.addFile('techmap','../../lib/techmap/maps/outpad.vhd')
project.addFile('techmap','../../lib/techmap/maps/outpad_ds.vhd')
project.addFile('techmap','../../lib/techmap/maps/toutpad.vhd')
project.addFile('techmap','../../lib/techmap/maps/toutpad_ds.vhd')
project.addFile('techmap','../../lib/techmap/maps/skew_outpad.vhd')
project.addFile('techmap','../../lib/techmap/maps/ddrphy.vhd')
project.addFile('techmap','../../lib/techmap/maps/syncram.vhd')
project.addFile('techmap','../../lib/techmap/maps/syncram64.vhd')
project.addFile('techmap','../../lib/techmap/maps/syncram_2p.vhd')
project.addFile('techmap','../../lib/techmap/maps/syncram_dp.vhd')
project.addFile('techmap','../../lib/techmap/maps/syncfifo_2p.vhd')
project.addFile('techmap','../../lib/techmap/maps/regfile_3p.vhd')
project.addFile('techmap','../../lib/techmap/maps/tap.vhd')
project.addFile('techmap','../../lib/techmap/maps/nandtree.vhd')
project.addFile('techmap','../../lib/techmap/maps/grlfpw_net.vhd')
project.addFile('techmap','../../lib/techmap/maps/grfpw_net.vhd')
project.addFile('techmap','../../lib/techmap/maps/leon3_net.vhd')
project.addFile('techmap','../../lib/techmap/maps/leon4_net.vhd')
project.addFile('techmap','../../lib/techmap/maps/mul_61x61.vhd')
project.addFile('techmap','../../lib/techmap/maps/cpu_disas_net.vhd')
project.addFile('techmap','../../lib/techmap/maps/ringosc.vhd')
project.addFile('techmap','../../lib/techmap/maps/grpci2_phy_net.vhd')
project.addFile('techmap','../../lib/techmap/maps/system_monitor.vhd')
project.addFile('techmap','../../lib/techmap/maps/inpad_ddr.vhd')
project.addFile('techmap','../../lib/techmap/maps/outpad_ddr.vhd')
project.addFile('techmap','../../lib/techmap/maps/iopad_ddr.vhd')
project.addFile('techmap','../../lib/techmap/maps/syncram128bw.vhd')
project.addFile('techmap','../../lib/techmap/maps/syncram256bw.vhd')
project.addFile('techmap','../../lib/techmap/maps/syncram128.vhd')
project.addFile('techmap','../../lib/techmap/maps/syncram156bw.vhd')
project.addFile('techmap','../../lib/techmap/maps/techmult.vhd')
project.addFile('techmap','../../lib/techmap/maps/spictrl_net.vhd')
project.addFile('techmap','../../lib/techmap/maps/scanreg.vhd')
project.addFile('techmap','../../lib/techmap/maps/syncrambw.vhd')
project.addFile('techmap','../../lib/techmap/maps/syncram_2pbw.vhd')
project.addFile('techmap','../../lib/techmap/maps/sdram_phy.vhd')
project.addFile('techmap','../../lib/techmap/maps/syncreg.vhd')
project.addFile('techmap','../../lib/techmap/maps/serdes.vhd')
project.addFile('techmap','../../lib/techmap/maps/iopad_tm.vhd')
project.addFile('techmap','../../lib/techmap/maps/toutpad_tm.vhd')
project.addFile('techmap','../../lib/techmap/maps/memrwcol.vhd')
project.addFile('techmap','../../lib/techmap/maps/cdcbus.vhd')
project.addFile('eth','../../lib/eth/comp/ethcomp.vhd')
project.addFile('eth','../../lib/eth/core/greth_pkg.vhd')
project.addFile('eth','../../lib/eth/core/eth_rstgen.vhd')
project.addFile('eth','../../lib/eth/core/eth_edcl_ahb_mst.vhd')
project.addFile('eth','../../lib/eth/core/eth_ahb_mst.vhd')
project.addFile('eth','../../lib/eth/core/greth_tx.vhd')
project.addFile('eth','../../lib/eth/core/greth_rx.vhd')
project.addFile('eth','../../lib/eth/core/grethc.vhd')
project.addFile('eth','../../lib/eth/wrapper/greth_gen.vhd')
project.addFile('opencores','../../lib/opencores/can/cancomp.vhd')
project.addFile('opencores','../../lib/opencores/can/can_top.vhd')
project.addFile('opencores','../../lib/opencores/i2c/i2c_master_bit_ctrl.vhd')
project.addFile('opencores','../../lib/opencores/i2c/i2c_master_byte_ctrl.vhd')
project.addFile('opencores','../../lib/opencores/i2c/i2coc.vhd')
project.addFile('gaisler','../../lib/gaisler/arith/arith.vhd')
project.addFile('gaisler','../../lib/gaisler/arith/mul32.vhd')
project.addFile('gaisler','../../lib/gaisler/arith/div32.vhd')
project.addFile('gaisler','../../lib/gaisler/memctrl/memctrl.vhd')
project.addFile('gaisler','../../lib/gaisler/memctrl/sdctrl.vhd')
project.addFile('gaisler','../../lib/gaisler/memctrl/sdctrl64.vhd')
project.addFile('gaisler','../../lib/gaisler/memctrl/sdmctrl.vhd')
project.addFile('gaisler','../../lib/gaisler/memctrl/srctrl.vhd')
project.addFile('gaisler','../../lib/gaisler/srmmu/mmuconfig.vhd')
project.addFile('gaisler','../../lib/gaisler/srmmu/mmuiface.vhd')
project.addFile('gaisler','../../lib/gaisler/srmmu/libmmu.vhd')
project.addFile('gaisler','../../lib/gaisler/srmmu/mmutlbcam.vhd')
project.addFile('gaisler','../../lib/gaisler/srmmu/mmulrue.vhd')
project.addFile('gaisler','../../lib/gaisler/srmmu/mmulru.vhd')
project.addFile('gaisler','../../lib/gaisler/srmmu/mmutlb.vhd')
project.addFile('gaisler','../../lib/gaisler/srmmu/mmutw.vhd')
project.addFile('gaisler','../../lib/gaisler/srmmu/mmu.vhd')
project.addFile('gaisler','../../lib/gaisler/leon3/leon3.vhd')
project.addFile('gaisler','../../lib/gaisler/leon3/grfpushwx.vhd')
project.addFile('gaisler','../../lib/gaisler/leon3v3/tbufmem.vhd')
project.addFile('gaisler','../../lib/gaisler/leon3v3/tbufmem_2p.vhd')
project.addFile('gaisler','../../lib/gaisler/leon3v3/dsu3x.vhd')
project.addFile('gaisler','../../lib/gaisler/leon3v3/dsu3.vhd')
project.addFile('gaisler','../../lib/gaisler/leon3v3/dsu3_mb.vhd')
project.addFile('gaisler','../../lib/gaisler/leon3v3/libfpu.vhd')
project.addFile('gaisler','../../lib/gaisler/leon3v3/libiu.vhd')
project.addFile('gaisler','../../lib/gaisler/leon3v3/libcache.vhd')
project.addFile('gaisler','../../lib/gaisler/leon3v3/libleon3.vhd')
project.addFile('gaisler','../../lib/gaisler/leon3v3/regfile_3p_l3.vhd')
project.addFile('gaisler','../../lib/gaisler/leon3v3/mmu_acache.vhd')
project.addFile('gaisler','../../lib/gaisler/leon3v3/mmu_icache.vhd')
project.addFile('gaisler','../../lib/gaisler/leon3v3/mmu_dcache.vhd')
project.addFile('gaisler','../../lib/gaisler/leon3v3/cachemem.vhd')
project.addFile('gaisler','../../lib/gaisler/leon3v3/mmu_cache.vhd')
project.addFile('gaisler','../../lib/gaisler/leon3v3/grfpwx.vhd')
project.addFile('gaisler','../../lib/gaisler/leon3v3/grlfpwx.vhd')
project.addFile('gaisler','../../lib/gaisler/leon3v3/iu3.vhd')
project.addFile('gaisler','../../lib/gaisler/leon3v3/proc3.vhd')
project.addFile('gaisler','../../lib/gaisler/leon3v3/grfpwxsh.vhd')
project.addFile('gaisler','../../lib/gaisler/leon3v3/leon3x.vhd')
project.addFile('gaisler','../../lib/gaisler/leon3v3/leon3cg.vhd')
project.addFile('gaisler','../../lib/gaisler/leon3v3/leon3s.vhd')
project.addFile('gaisler','../../lib/gaisler/leon3v3/leon3sh.vhd')
project.addFile('gaisler','../../lib/gaisler/leon3v3/l3stat.vhd')
project.addFile('gaisler','../../lib/gaisler/leon3v3/cmvalidbits.vhd')
project.addFile('gaisler','../../lib/gaisler/leon4/leon4.vhd')
project.addFile('gaisler','../../lib/gaisler/l2cache/pkg/l2cache.vhd')
project.addFile('gaisler','../../lib/gaisler/can/can.vhd')
project.addFile('gaisler','../../lib/gaisler/can/can_mod.vhd')
project.addFile('gaisler','../../lib/gaisler/can/can_oc.vhd')
project.addFile('gaisler','../../lib/gaisler/can/can_mc.vhd')
project.addFile('gaisler','../../lib/gaisler/can/canmux.vhd')
project.addFile('gaisler','../../lib/gaisler/can/can_rd.vhd')
project.addFile('gaisler','../../lib/gaisler/axi/axi.vhd')
project.addFile('gaisler','../../lib/gaisler/axi/ahbm2axi.vhd')
project.addFile('gaisler','../../lib/gaisler/axi/ahbm2axi3.vhd')
project.addFile('gaisler','../../lib/gaisler/axi/ahbm2axi4.vhd')
project.addFile('gaisler','../../lib/gaisler/axi/axinullslv.vhd')
project.addFile('gaisler','../../lib/gaisler/axi/ahb2axib.vhd')
project.addFile('gaisler','../../lib/gaisler/axi/ahb2axi3b.vhd')
project.addFile('gaisler','../../lib/gaisler/axi/ahb2axi4b.vhd')
project.addFile('gaisler','../../lib/gaisler/misc/misc.vhd')
project.addFile('gaisler','../../lib/gaisler/misc/rstgen.vhd')
project.addFile('gaisler','../../lib/gaisler/misc/gptimer.vhd')
project.addFile('gaisler','../../lib/gaisler/misc/ahbram.vhd')
project.addFile('gaisler','../../lib/gaisler/misc/ahbdpram.vhd')
project.addFile('gaisler','../../lib/gaisler/misc/ahbtrace_mmb.vhd')
project.addFile('gaisler','../../lib/gaisler/misc/ahbtrace_mb.vhd')
project.addFile('gaisler','../../lib/gaisler/misc/ahbtrace.vhd')
project.addFile('gaisler','../../lib/gaisler/misc/grgpio.vhd')
project.addFile('gaisler','../../lib/gaisler/misc/ahbstat.vhd')
project.addFile('gaisler','../../lib/gaisler/misc/logan.vhd')
project.addFile('gaisler','../../lib/gaisler/misc/apbps2.vhd')
project.addFile('gaisler','../../lib/gaisler/misc/charrom_package.vhd')
project.addFile('gaisler','../../lib/gaisler/misc/charrom.vhd')
project.addFile('gaisler','../../lib/gaisler/misc/apbvga.vhd')
project.addFile('gaisler','../../lib/gaisler/misc/svgactrl.vhd')
project.addFile('gaisler','../../lib/gaisler/misc/grsysmon.vhd')
project.addFile('gaisler','../../lib/gaisler/misc/gracectrl.vhd')
project.addFile('gaisler','../../lib/gaisler/misc/grgpreg.vhd')
project.addFile('gaisler','../../lib/gaisler/misc/ahb_mst_iface.vhd')
project.addFile('gaisler','../../lib/gaisler/misc/grgprbank.vhd')
project.addFile('gaisler','../../lib/gaisler/misc/grversion.vhd')
project.addFile('gaisler','../../lib/gaisler/misc/apb3cdc.vhd')
project.addFile('gaisler','../../lib/gaisler/misc/ahbsmux.vhd')
project.addFile('gaisler','../../lib/gaisler/misc/ahbmmux.vhd')
project.addFile('gaisler','../../lib/gaisler/misc/grtachom.vhd')
project.addFile('gaisler','../../lib/gaisler/net/net.vhd')
project.addFile('gaisler','../../lib/gaisler/uart/uart.vhd')
project.addFile('gaisler','../../lib/gaisler/uart/libdcom.vhd')
project.addFile('gaisler','../../lib/gaisler/uart/apbuart.vhd')
project.addFile('gaisler','../../lib/gaisler/uart/dcom.vhd')
project.addFile('gaisler','../../lib/gaisler/uart/dcom_uart.vhd')
project.addFile('gaisler','../../lib/gaisler/uart/ahbuart.vhd')
project.addFile('gaisler','../../lib/gaisler/jtag/jtag.vhd')
project.addFile('gaisler','../../lib/gaisler/jtag/libjtagcom.vhd')
project.addFile('gaisler','../../lib/gaisler/jtag/jtagcom.vhd')
project.addFile('gaisler','../../lib/gaisler/jtag/bscanregs.vhd')
project.addFile('gaisler','../../lib/gaisler/jtag/bscanregsbd.vhd')
project.addFile('gaisler','../../lib/gaisler/jtag/jtagcom2.vhd')
project.addFile('gaisler','../../lib/gaisler/jtag/ahbjtag.vhd')
project.addFile('gaisler','../../lib/gaisler/jtag/ahbjtag_bsd.vhd')
project.addFile('gaisler','../../lib/gaisler/jtag/jtagcomrv.vhd')
project.addFile('gaisler','../../lib/gaisler/jtag/ahbjtagrv.vhd')
project.addFile('gaisler','../../lib/gaisler/greth/ethernet_mac.vhd')
project.addFile('gaisler','../../lib/gaisler/greth/greth.vhd')
project.addFile('gaisler','../../lib/gaisler/greth/greth_mb.vhd')
project.addFile('gaisler','../../lib/gaisler/greth/greth_gbit.vhd')
project.addFile('gaisler','../../lib/gaisler/greth/greths.vhd')
project.addFile('gaisler','../../lib/gaisler/greth/greth_gbit_mb.vhd')
project.addFile('gaisler','../../lib/gaisler/greth/greths_mb.vhd')
project.addFile('gaisler','../../lib/gaisler/greth/grethm.vhd')
project.addFile('gaisler','../../lib/gaisler/greth/grethm_mb.vhd')
project.addFile('gaisler','../../lib/gaisler/greth/adapters/rgmii.vhd')
project.addFile('gaisler','../../lib/gaisler/greth/adapters/rgmii_kc705.vhd')
project.addFile('gaisler','../../lib/gaisler/greth/adapters/rgmii_series7.vhd')
project.addFile('gaisler','../../lib/gaisler/greth/adapters/rgmii_series6.vhd')
project.addFile('gaisler','../../lib/gaisler/greth/adapters/comma_detect.vhd')
project.addFile('gaisler','../../lib/gaisler/greth/adapters/elastic_buffer.vhd')
project.addFile('gaisler','../../lib/gaisler/greth/adapters/gmii_to_mii.vhd')
project.addFile('gaisler','../../lib/gaisler/greth/adapters/word_aligner.vhd')
project.addFile('gaisler','../../lib/gaisler/i2c/i2c.vhd')
project.addFile('gaisler','../../lib/gaisler/i2c/i2cmst.vhd')
project.addFile('gaisler','../../lib/gaisler/i2c/i2cmst_gen.vhd')
project.addFile('gaisler','../../lib/gaisler/i2c/i2cslv.vhd')
project.addFile('gaisler','../../lib/gaisler/i2c/i2c2ahbx.vhd')
project.addFile('gaisler','../../lib/gaisler/i2c/i2c2ahb.vhd')
project.addFile('gaisler','../../lib/gaisler/i2c/i2c2ahb_apb.vhd')
project.addFile('gaisler','../../lib/gaisler/i2c/i2c2ahb_gen.vhd')
project.addFile('gaisler','../../lib/gaisler/i2c/i2c2ahb_apb_gen.vhd')
project.addFile('gaisler','../../lib/gaisler/spi/spi.vhd')
project.addFile('gaisler','../../lib/gaisler/spi/spimctrl.vhd')
project.addFile('gaisler','../../lib/gaisler/spi/spictrlx.vhd')
project.addFile('gaisler','../../lib/gaisler/spi/spictrl.vhd')
project.addFile('gaisler','../../lib/gaisler/spi/spi2ahbx.vhd')
project.addFile('gaisler','../../lib/gaisler/spi/spi2ahb.vhd')
project.addFile('gaisler','../../lib/gaisler/spi/spi2ahb_apb.vhd')
project.addFile('gaisler','../../lib/gaisler/grdmac2/grdmac2_pkg.vhd')
project.addFile('gaisler','../../lib/gaisler/grdmac2/grdmac2_apb.vhd')
project.addFile('gaisler','../../lib/gaisler/grdmac2/mem2buf.vhd')
project.addFile('gaisler','../../lib/gaisler/grdmac2/buf2mem.vhd')
project.addFile('gaisler','../../lib/gaisler/grdmac2/grdmac2_ctrl.vhd')
project.addFile('gaisler','../../lib/gaisler/grdmac2/grdmac2.vhd')
project.addFile('gaisler','../../lib/gaisler/grdmac2/grdmac2_ahb.vhd')
project.addFile('gaisler','../../lib/gaisler/subsys/subsys.vhd')
project.addFile('gaisler','../../lib/gaisler/subsys/leon_dsu_stat_base.vhd')
project.addFile('gaisler','../../lib/gaisler/noelv/pkg/noelv.vhd')
project.addFile('gaisler','../../lib/gaisler/noelv/pkg/util.vhd')
project.addFile('gaisler','../../lib/gaisler/noelv/core/mmuconfig.vhd')
project.addFile('gaisler','../../lib/gaisler/noelv/core/noelvint.vhd')
project.addFile('gaisler','../../lib/gaisler/noelv/core/bhtnv.vhd')
project.addFile('gaisler','../../lib/gaisler/noelv/core/btbnv.vhd')
project.addFile('gaisler','../../lib/gaisler/noelv/core/rasnv.vhd')
project.addFile('gaisler','../../lib/gaisler/noelv/core/tbufmemnv.vhd')
project.addFile('gaisler','../../lib/gaisler/noelv/core/cachememnv.vhd')
project.addFile('gaisler','../../lib/gaisler/noelv/core/mul64.vhd')
project.addFile('gaisler','../../lib/gaisler/noelv/core/div64.vhd')
project.addFile('gaisler','../../lib/gaisler/noelv/core/regfile64nv.vhd')
project.addFile('gaisler','../../lib/gaisler/noelv/core/progbuf.vhd')
project.addFile('gaisler','../../lib/gaisler/noelv/core/iunv.vhd')
project.addFile('gaisler','../../lib/gaisler/noelv/core/cpucorenv.vhd')
project.addFile('gaisler','../../lib/gaisler/noelv/core/rvdmx.vhd')
project.addFile('gaisler','../../lib/gaisler/noelv/core/rvdm.vhd')
project.addFile('gaisler','../../lib/gaisler/noelv/core/cctrlnv.vhd')
project.addFile('gaisler','../../lib/gaisler/noelv/core/noelvcpu.vhd')
project.addFile('gaisler','../../lib/gaisler/noelv/core/fakefpunv.vhd')
project.addFile('gaisler','../../lib/gaisler/noelv/core/nanofpunv.vhd')
project.addFile('gaisler','../../lib/gaisler/riscv/riscv.vhd')
project.addFile('gaisler','../../lib/gaisler/riscv/clint.vhd')
project.addFile('gaisler','../../lib/gaisler/riscv/clint_ahb.vhd')
project.addFile('gaisler','../../lib/gaisler/plic/plic.vhd')
project.addFile('gaisler','../../lib/gaisler/plic/grplic.vhd')
project.addFile('gaisler','../../lib/gaisler/plic/plic_encoder.vhd')
project.addFile('gaisler','../../lib/gaisler/plic/plic_gateway.vhd')
project.addFile('gaisler','../../lib/gaisler/plic/plic_target.vhd')
project.addFile('gaisler','../../lib/gaisler/plic/grplic_ahb.vhd')
project.addFile('gaisler','../../lib/gaisler/noelv/subsys/noelvsys.vhd')
project.addFile('work','rtl/ddr4ram.vhd')
project.addFile('work','config.vhd')
project.addFile('work','ahbrom.vhd')
project.addFile('work','noelvmp.vhd')

#Set project options
project.setOption('ManageUnconnectedOutputs', 'Ground')
project.setOption('ManageUnconnectedSignals', 'Ground')
project.setOption('DefaultRAMMapping', 'RAM')
project.setOption('DefaultROMMapping', 'LUT')
project.setOption('DisableROMFullLutRecognition', 'Yes')
project.setOption('MappingEffort', 'High') 
project.setOption('ManageAsynchronousReadPort', 'Yes')


# No user defined constraint file in variable NXCONSTRAINTS


# Read pin map
if path.exists(dir + '/noelvmp_pads.py'):
   from noelvmp_pads import pads
   project.addPads(pads)
#Generate Project file
project.save('noelvmp_native.nym')
