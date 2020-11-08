GRLIB=../..
TOP=leon3mp
#BOARD=gr-cpci-xc4v
BOARD=xilinx-ac701-xc7a200t
DESIGN=leon3mp
include $(GRLIB)/boards/$(BOARD)/Makefile.inc
#DEVICE=$(PART)-$(PACKAGE)$(SPEED)
DEVICE=$(PART)$(PACKAGE)-$(SPEED)
UCF=$(GRLIB)/boards/$(BOARD)/$(TOP).ucf
QSF=$(GRLIB)/boards/$(BOARD)/$(TOP).qsf
EFFORT=std
#XSTOPT=
SYNPOPT="set_option -pipe 0; set_option -retiming 0; set_option -write_apr_constraint 0"
VHDLSYNFILES=config.vhd ahbrom.vhd leon3mp.vhd
VHDLSIMFILES=testbench.vhd
SIMTOP=testbench
GRLIB_SIMULATOR=Xilinx
VCOMOPT=-explicit -O0
SDCFILE=$(GRLIB)/boards/$(BOARD)/default.sdc
BITGEN=$(GRLIB)/boards/$(BOARD)/default.ut
CLEAN=soft-clean


#TECHLIBS = unisim
TECHLIBS = inferred
#DIRSKIP = leon4v0
LIBSKIP = core1553bbc core1553brm core1553brt gr1553 corePCIF \
	tmtc openchip ihp usbhc gsi cypress hynix \
	spansion leon4v0 spw
DIRSKIP = b1553 leon2 leon2ft crypto satcan ambatest \
	usb grusbhc ascs slink spi hcan \
	leon4v0 l2cache pwm gr1553b iommu ac97 secureip
FILESKIP = grcan.vhd ddr2.v mobile_ddr.v
include $(GRLIB)/bin/Makefile
include $(GRLIB)/software/leon3/Makefile


##################  project specific targets ##########################

