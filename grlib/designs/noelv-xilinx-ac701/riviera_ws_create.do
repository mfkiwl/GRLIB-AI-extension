workspace.create riviera_ws .
workspace.design.create grlib . 
workspace.design.setactive grlib 
amap grlib grlib/grlib/grlib.lib 
design.file.add /home/march/tfm/grlib/lib/grlib/stdlib/version.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/stdlib/config_types.vhd
design.file.add /home/march/tfm/grlib/designs/noelv-xilinx-ac701/grlib_config.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/stdlib/stdlib.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/stdlib/stdio.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/stdlib/testlib.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/util/util.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/sparc/sparc.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/sparc/sparc_disas.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/sparc/cpu_disas.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/riscv/riscv.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/riscv/riscv_disas.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/riscv/cpu_disas.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/modgen/multlib.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/modgen/leaves.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/amba/amba.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/amba/devices.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/amba/defmst.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/amba/apbctrl.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/amba/apbctrlx.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/amba/apbctrldp.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/amba/apbctrlsp.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/amba/ahbctrl.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/amba/dma2ahb_pkg.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/amba/dma2ahb.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/amba/ahbmst.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/amba/ahblitm2ahbm.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/amba/dma2ahb_tp.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/amba/amba_tp.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/dftlib/dftlib.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/dftlib/synciotest.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/generic_bm/generic_bm_pkg.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/generic_bm/ahb_be.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/generic_bm/axi4_be.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/generic_bm/bmahbmst.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/generic_bm/bm_fre.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/generic_bm/bm_me_rc.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/generic_bm/bm_me_wc.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/generic_bm/fifo_control_rc.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/generic_bm/fifo_control_wc.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/generic_bm/generic_bm_ahb.vhd
design.file.add /home/march/tfm/grlib/lib/grlib/generic_bm/generic_bm_axi.vhd
workspace.design.create techmap . 
workspace.design.setactive techmap 
workspace.dependencies.add techmap grlib 
amap grlib grlib/grlib/grlib.lib 
amap techmap techmap/techmap/techmap.lib 
design.file.add /home/march/tfm/grlib/lib/techmap/gencomp/gencomp.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/gencomp/netcomp.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/inferred/memory_inferred.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/inferred/ddr_inferred.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/inferred/mul_inferred.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/inferred/ddr_phy_inferred.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/inferred/ddrphy_datapath.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/inferred/fifo_inferred.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/inferred/sim_pll.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/inferred/lpddr2_phy_inferred.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/unisim/memory_kintex7.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/unisim/memory_ultrascale.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/unisim/memory_unisim.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/unisim/buffer_unisim.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/unisim/pads_unisim.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/unisim/clkgen_unisim.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/unisim/tap_unisim.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/unisim/ddr_unisim.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/unisim/ddr_phy_unisim.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/unisim/sysmon_unisim.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/unisim/mul_unisim.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/unisim/spictrl_unisim.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/allclkgen.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/techbuf.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/allddr.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/allmem.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/allmul.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/allpads.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/alltap.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/clkgen.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/clkmux.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/clkinv.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/clkand.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/grgates.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/ddr_ireg.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/ddr_oreg.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/clkpad.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/clkpad_ds.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/inpad.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/inpad_ds.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/iodpad.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/iopad.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/iopad_ds.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/lvds_combo.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/odpad.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/outpad.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/outpad_ds.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/toutpad.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/toutpad_ds.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/skew_outpad.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/ddrphy.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/syncram.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/syncram64.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/syncram_2p.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/syncram_dp.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/syncfifo_2p.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/regfile_3p.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/tap.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/nandtree.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/grlfpw_net.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/grfpw_net.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/leon3_net.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/leon4_net.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/mul_61x61.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/cpu_disas_net.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/ringosc.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/grpci2_phy_net.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/system_monitor.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/inpad_ddr.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/outpad_ddr.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/iopad_ddr.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/syncram128bw.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/syncram256bw.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/syncram128.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/syncram156bw.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/techmult.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/spictrl_net.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/scanreg.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/syncrambw.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/syncram_2pbw.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/sdram_phy.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/syncreg.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/serdes.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/iopad_tm.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/toutpad_tm.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/memrwcol.vhd
design.file.add /home/march/tfm/grlib/lib/techmap/maps/cdcbus.vhd
workspace.design.create eth . 
workspace.design.setactive eth 
workspace.dependencies.add eth grlib 
workspace.dependencies.add eth techmap 
amap grlib grlib/grlib/grlib.lib 
amap techmap techmap/techmap/techmap.lib 
amap eth eth/eth/eth.lib 
design.file.add /home/march/tfm/grlib/lib/eth/comp/ethcomp.vhd
design.file.add /home/march/tfm/grlib/lib/eth/core/greth_pkg.vhd
design.file.add /home/march/tfm/grlib/lib/eth/core/eth_rstgen.vhd
design.file.add /home/march/tfm/grlib/lib/eth/core/eth_edcl_ahb_mst.vhd
design.file.add /home/march/tfm/grlib/lib/eth/core/eth_ahb_mst.vhd
design.file.add /home/march/tfm/grlib/lib/eth/core/greth_tx.vhd
design.file.add /home/march/tfm/grlib/lib/eth/core/greth_rx.vhd
design.file.add /home/march/tfm/grlib/lib/eth/core/grethc.vhd
design.file.add /home/march/tfm/grlib/lib/eth/wrapper/greth_gen.vhd
workspace.design.create opencores . 
workspace.design.setactive opencores 
workspace.dependencies.add opencores grlib 
workspace.dependencies.add opencores techmap 
workspace.dependencies.add opencores eth 
amap grlib grlib/grlib/grlib.lib 
amap techmap techmap/techmap/techmap.lib 
amap eth eth/eth/eth.lib 
amap opencores opencores/opencores/opencores.lib 
design.file.add /home/march/tfm/grlib/lib/opencores/can/cancomp.vhd
design.file.add /home/march/tfm/grlib/lib/opencores/can/can_top.vhd
design.file.add /home/march/tfm/grlib/lib/opencores/i2c/i2c_master_bit_ctrl.vhd
design.file.add /home/march/tfm/grlib/lib/opencores/i2c/i2c_master_byte_ctrl.vhd
design.file.add /home/march/tfm/grlib/lib/opencores/i2c/i2coc.vhd
workspace.design.create gaisler . 
workspace.design.setactive gaisler 
workspace.dependencies.add gaisler grlib 
workspace.dependencies.add gaisler techmap 
workspace.dependencies.add gaisler eth 
workspace.dependencies.add gaisler opencores 
amap grlib grlib/grlib/grlib.lib 
amap techmap techmap/techmap/techmap.lib 
amap eth eth/eth/eth.lib 
amap opencores opencores/opencores/opencores.lib 
amap gaisler gaisler/gaisler/gaisler.lib 
design.file.add /home/march/tfm/grlib/lib/gaisler/arith/arith.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/arith/mul32.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/arith/div32.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/memctrl/memctrl.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/memctrl/sdctrl.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/memctrl/sdctrl64.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/memctrl/sdmctrl.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/memctrl/srctrl.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/srmmu/mmuconfig.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/srmmu/mmuiface.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/srmmu/libmmu.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/srmmu/mmutlbcam.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/srmmu/mmulrue.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/srmmu/mmulru.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/srmmu/mmutlb.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/srmmu/mmutw.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/srmmu/mmu.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/leon3/leon3.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/leon3/grfpushwx.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/leon3v3/tbufmem.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/leon3v3/tbufmem_2p.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/leon3v3/dsu3x.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/leon3v3/dsu3.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/leon3v3/dsu3_mb.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/leon3v3/libfpu.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/leon3v3/libiu.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/leon3v3/libcache.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/leon3v3/libleon3.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/leon3v3/regfile_3p_l3.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/leon3v3/mmu_acache.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/leon3v3/mmu_icache.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/leon3v3/mmu_dcache.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/leon3v3/cachemem.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/leon3v3/mmu_cache.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/leon3v3/grfpwx.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/leon3v3/grlfpwx.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/leon3v3/iu3.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/leon3v3/proc3.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/leon3v3/grfpwxsh.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/leon3v3/leon3x.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/leon3v3/leon3cg.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/leon3v3/leon3s.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/leon3v3/leon3sh.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/leon3v3/l3stat.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/leon3v3/cmvalidbits.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/leon4/leon4.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/l2cache/pkg/l2cache.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/can/can.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/can/can_mod.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/can/can_oc.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/can/can_mc.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/can/canmux.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/can/can_rd.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/axi/axi.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/axi/ahbm2axi.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/axi/ahbm2axi3.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/axi/ahbm2axi4.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/axi/axinullslv.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/axi/ahb2axib.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/axi/ahb2axi3b.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/axi/ahb2axi4b.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/misc/misc.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/misc/rstgen.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/misc/gptimer.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/misc/ahbram.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/misc/ahbdpram.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/misc/ahbtrace_mmb.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/misc/ahbtrace_mb.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/misc/ahbtrace.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/misc/grgpio.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/misc/ahbstat.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/misc/logan.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/misc/apbps2.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/misc/charrom_package.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/misc/charrom.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/misc/apbvga.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/misc/svgactrl.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/misc/grsysmon.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/misc/gracectrl.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/misc/grgpreg.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/misc/ahb_mst_iface.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/misc/grgprbank.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/misc/grversion.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/misc/apb3cdc.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/misc/ahbsmux.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/misc/ahbmmux.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/misc/grtachom.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/net/net.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/uart/uart.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/uart/libdcom.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/uart/apbuart.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/uart/dcom.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/uart/dcom_uart.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/uart/ahbuart.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/sim/sim.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/sim/sram.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/sim/sram16.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/sim/phy.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/sim/ser_phy.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/sim/ahbrep.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/sim/delay_wire.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/sim/pwm_check.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/sim/slavecheck_slv.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/sim/ddrram.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/sim/ddr2ram.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/sim/ddr3ram.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/sim/sdrtestmod.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/sim/ahbram_sim.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/sim/aximem.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/sim/axirep.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/sim/axixmem.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/sim/sramtestmod.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/sim/uartprint.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/jtag/jtag.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/jtag/libjtagcom.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/jtag/jtagcom.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/jtag/bscanregs.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/jtag/bscanregsbd.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/jtag/jtagcom2.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/jtag/ahbjtag.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/jtag/ahbjtag_bsd.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/jtag/jtagcomrv.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/jtag/ahbjtagrv.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/jtag/jtagtst.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/jtag/jtag_rv.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/greth/ethernet_mac.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/greth/greth.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/greth/greth_mb.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/greth/greth_gbit.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/greth/greths.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/greth/greth_gbit_mb.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/greth/greths_mb.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/greth/grethm.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/greth/grethm_mb.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/greth/adapters/rgmii.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/greth/adapters/rgmii_kc705.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/greth/adapters/rgmii_series7.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/greth/adapters/rgmii_series6.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/greth/adapters/comma_detect.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/greth/adapters/elastic_buffer.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/greth/adapters/gmii_to_mii.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/greth/adapters/word_aligner.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/i2c/i2c.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/i2c/i2cmst.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/i2c/i2cmst_gen.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/i2c/i2cslv.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/i2c/i2c2ahbx.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/i2c/i2c2ahb.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/i2c/i2c2ahb_apb.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/i2c/i2c2ahb_gen.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/i2c/i2c2ahb_apb_gen.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/i2c/i2c_slave_model.v
design.file.add /home/march/tfm/grlib/lib/gaisler/spi/spi.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/spi/spimctrl.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/spi/spictrlx.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/spi/spictrl.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/spi/spi2ahbx.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/spi/spi2ahb.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/spi/spi2ahb_apb.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/spi/spi_flash.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/grdmac2/grdmac2_pkg.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/grdmac2/grdmac2_apb.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/grdmac2/mem2buf.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/grdmac2/buf2mem.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/grdmac2/grdmac2_ctrl.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/grdmac2/grdmac2.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/grdmac2/grdmac2_ahb.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/subsys/subsys.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/subsys/leon_dsu_stat_base.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/noelv/pkg/noelv.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/noelv/pkg/util.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/noelv/core/mmuconfig.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/noelv/core/noelvint.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/noelv/core/bhtnv.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/noelv/core/btbnv.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/noelv/core/rasnv.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/noelv/core/tbufmemnv.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/noelv/core/cachememnv.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/noelv/core/mul64.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/noelv/core/div64.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/noelv/core/regfile64nv.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/noelv/core/progbuf.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/noelv/core/iunv.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/noelv/core/cpucorenv.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/noelv/core/rvdmx.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/noelv/core/rvdm.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/noelv/core/cctrlnv.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/noelv/core/noelvcpu.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/noelv/core/fakefpunv.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/noelv/core/nanofpunv.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/riscv/riscv.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/riscv/clint.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/riscv/clint_ahb.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/plic/plic.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/plic/grplic.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/plic/plic_encoder.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/plic/plic_gateway.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/plic/plic_target.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/plic/grplic_ahb.vhd
design.file.add /home/march/tfm/grlib/lib/gaisler/noelv/subsys/noelvsys.vhd
workspace.design.create work . 
workspace.design.setactive work 
workspace.dependencies.add work grlib 
workspace.dependencies.add work techmap 
workspace.dependencies.add work eth 
workspace.dependencies.add work opencores 
workspace.dependencies.add work gaisler 
amap grlib grlib/grlib/grlib.lib 
amap techmap techmap/techmap/techmap.lib 
amap eth eth/eth/eth.lib 
amap opencores opencores/opencores/opencores.lib 
amap gaisler gaisler/gaisler/gaisler.lib 
amap work work/work/work.lib 
design.file.add /home/march/tfm/grlib/lib/work/debug/debug.vhd
design.file.add /home/march/tfm/grlib/lib/work/debug/grtestmod.vhd
design.file.add /home/march/tfm/grlib/lib/work/debug/cpu_disas.vhd
design.file.add ../rtl/ddr4ram.vhd
design.file.add ../config.vhd
design.file.add ../ahbrom.vhd
design.file.add ../noelvmp.vhd
design.file.add ../testbench.vhd
