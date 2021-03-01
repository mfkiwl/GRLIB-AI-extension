GRLIB=../..
TOP=noelvmp
#BOARD=gr-cpci-xc4v
BOARD=xilinx-ac701-xc7a200t
DESIGN=noelvmp
include $(GRLIB)/boards/$(BOARD)/Makefile.inc
#DEVICE=$(PART)-$(PACKAGE)$(SPEED)
DEVICE=$(PART)$(PACKAGE)-$(SPEED)
UCF=$(GRLIB)/boards/$(BOARD)/$(TOP).ucf
QSF=$(GRLIB)/boards/$(BOARD)/$(TOP).qsf
EFFORT=std
#XSTOPT=
SYNPOPT="set_option -pipe 0; set_option -retiming 0; set_option -write_apr_constraint 0"
VHDLSYNFILES=config.vhd ahbrom.vhd noelvmp.vhd
VHDLSIMFILES=testbench.vhd
SIMTOP=testbench
GRLIB_SIMULATOR=ghdl
VCOMOPT=-explicit -O0
SDCFILE=$(GRLIB)/boards/$(BOARD)/default.sdc
BITGEN=$(GRLIB)/boards/$(BOARD)/default.ut
CLEAN=soft-clean


TECHLIBS = inferred

LIBSKIP = pci pci/pcif core1553bbc core1553brm srio core1553brt idt gr1553 corePCIF \
	tmtc openchip ihp spw gsi cypress hynix ge_1000baseX \
	spansion secureip usb ddr grdmac mmuconfig fmf esa spfi
DIRSKIP = b1553 pci gr1553b/core pci/pcif leon2 leon2ft leon5 leon5v0 srio idt crypto satcan pci ambatest \
	spacewire ascs slink irqmp grdmac grrm nand \
	pwm gr1553b iommu ac97 secureip mmuiface clk2x canfd leon4v0 spacefibre

FILESKIP = grcan.vhd ddr2.v mobile_ddr.v adapters/sgmii.vhd iu4.vhd sparc/cpu_disas.vhd

include $(GRLIB)/bin/Makefile
include $(GRLIB)/software/noelv/Makefile

### Software ###
XLEN = 64
#EXTRA_PROM = --reverse-bytes=8
UART = 1

##################  project specific targets ##########################
