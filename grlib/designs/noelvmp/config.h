/*
 * Automatically generated C config: don't edit
 */
#define AUTOCONF_INCLUDED
#define CONFIG_HAS_SHARED_GRFPU 1
/*
 * Synthesis      
 */
#define CONFIG_SYN_INFERRED 1
#undef  CONFIG_SYN_AXCEL
#undef  CONFIG_SYN_AXDSP
#undef  CONFIG_SYN_FUSION
#undef  CONFIG_SYN_PROASIC
#undef  CONFIG_SYN_PROASICPLUS
#undef  CONFIG_SYN_PROASIC3
#undef  CONFIG_SYN_PROASIC3E
#undef  CONFIG_SYN_PROASIC3L
#undef  CONFIG_SYN_IGLOO
#undef  CONFIG_SYN_IGLOO2
#undef  CONFIG_SYN_SF2
#undef  CONFIG_SYN_RTG4
#undef  CONFIG_SYN_POLARFIRE
#undef  CONFIG_SYN_UT025CRH
#undef  CONFIG_SYN_UT130HBD
#undef  CONFIG_SYN_UT90NHBD
#undef  CONFIG_SYN_CYCLONEIII
#undef  CONFIG_SYN_STRATIX
#undef  CONFIG_SYN_STRATIXII
#undef  CONFIG_SYN_STRATIXIII
#undef  CONFIG_SYN_STRATIXIV
#undef  CONFIG_SYN_STRATIXV
#undef  CONFIG_SYN_ALTERA
#undef  CONFIG_SYN_ATC18
#undef  CONFIG_SYN_ATC18RHA
#undef  CONFIG_SYN_CUSTOM1
#undef  CONFIG_SYN_DARE
#undef  CONFIG_SYN_CMOS9SF
#undef  CONFIG_SYN_BRAVEMED
#undef  CONFIG_SYN_ECLIPSE
#undef  CONFIG_SYN_RH_LIB18T
#undef  CONFIG_SYN_RHUMC
#undef  CONFIG_SYN_RHS65
#undef  CONFIG_SYN_SAED32
#undef  CONFIG_SYN_SMIC13
#undef  CONFIG_SYN_TM65GPLUS
#undef  CONFIG_SYN_TSMC90
#undef  CONFIG_SYN_UMC
#undef  CONFIG_SYN_ARTIX7
#undef  CONFIG_SYN_KINTEX7
#undef  CONFIG_SYN_KINTEXU
#undef  CONFIG_SYN_SPARTAN3
#undef  CONFIG_SYN_SPARTAN3E
#undef  CONFIG_SYN_SPARTAN6
#undef  CONFIG_SYN_VIRTEX2
#undef  CONFIG_SYN_VIRTEX4
#undef  CONFIG_SYN_VIRTEX5
#undef  CONFIG_SYN_VIRTEX6
#undef  CONFIG_SYN_VIRTEX7
#undef  CONFIG_SYN_ZYNQ7000
#define CONFIG_MEM_INFERRED 1
#undef  CONFIG_MEM_UMC
#undef  CONFIG_MEM_RHUMC
#undef  CONFIG_MEM_SAED32
#undef  CONFIG_MEM_DARE
#undef  CONFIG_MEM_RHS65
#undef  CONFIG_MEM_ARTISAN
#undef  CONFIG_MEM_CUSTOM1
#undef  CONFIG_MEM_VIRAGE
#undef  CONFIG_MEM_VIRAGE90
#undef  CONFIG_SYN_NO_ASYNC
#undef  CONFIG_SYN_SCAN
/*
 * Clock generation
 */
#define CONFIG_CLK_INFERRED 1
#undef  CONFIG_CLK_HCLKBUF
#undef  CONFIG_CLK_UT130HBD
#undef  CONFIG_CLK_ALTDLL
#undef  CONFIG_CLK_BRAVEMED
#undef  CONFIG_CLK_PRO3PLL
#undef  CONFIG_CLK_PRO3EPLL
#undef  CONFIG_CLK_PRO3LPLL
#undef  CONFIG_CLK_FUSPLL
#undef  CONFIG_CLK_LIB18T
#undef  CONFIG_CLK_RHUMC
#undef  CONFIG_CLK_DARE
#undef  CONFIG_CLK_SAED32
#undef  CONFIG_CLK_EASIC45
#undef  CONFIG_CLK_RHS65
#undef  CONFIG_CLK_CLKPLLE2
#undef  CONFIG_CLK_CLKDLL
#undef  CONFIG_CLK_DCM
#undef  CONFIG_PCI_SYSCLK
/*
 * Processor            
 */
#define CONFIG_NOELV 1
#define CONFIG_PROC_NUM (1)
#define CONFIG_NOELV_HP 1
#define CONFIG_PROC_CFG (0)
/*
 * VHDL debug settings       
 */
#undef  CONFIG_IU_DISAS
/*
 * NOEL-V subsystem GPL settings       
 */
#define CONFIG_PROC_NODBUS 1
/*
 * L2 Cache
 */
#undef  CONFIG_L2_ENABLE
#define CONFIG_L2_ASSO1 1
#undef  CONFIG_L2_ASSO2
#undef  CONFIG_L2_ASSO3
#undef  CONFIG_L2_ASSO4
#undef  CONFIG_L2_SZ1
#undef  CONFIG_L2_SZ2
#undef  CONFIG_L2_SZ4
#undef  CONFIG_L2_SZ8
#undef  CONFIG_L2_SZ16
#undef  CONFIG_L2_SZ32
#define CONFIG_L2_SZ64 1
#undef  CONFIG_L2_SZ128
#undef  CONFIG_L2_SZ256
#undef  CONFIG_L2_SZ512
#define CONFIG_L2_LINE32 1
#undef  CONFIG_L2_LINE64
#undef  CONFIG_L2_HPROT
#undef  CONFIG_L2_PEN
#undef  CONFIG_L2_WT
#undef  CONFIG_L2_RAN
#define CONFIG_L2_MAP 00F0
#define CONFIG_L2_MTRR (0)
#define CONFIG_L2_EDAC_NONE 1
#undef  CONFIG_L2_EDAC_YES
#undef  CONFIG_L2_EDAC_TECHSPEC
#define CONFIG_L2_AXI 1
/*
 * AMBA configuration
 */
#define CONFIG_AHB_DEFMST (0)
#define CONFIG_AHB_RROBIN 1
#define CONFIG_AHB_SPLIT 1
#define CONFIG_AHB_FPNPEN 1
#define CONFIG_AHB_IOADDR FFF
#define CONFIG_APB_HADDR 800
#define CONFIG_AHB_MON 1
#define CONFIG_AHB_MONERR 1
#define CONFIG_AHB_MONWAR 1
#undef  CONFIG_AHB_DTRACE
/*
 * Debug Link           
 */
#undef  CONFIG_DSU_UART
#undef  CONFIG_DSU_JTAG
#undef  CONFIG_GRUSB_DCL
#undef  CONFIG_DSU_ETH
/*
 * Peripherals             
 */
/*
 * Memory controller             
 */
/*
 * Leon2 memory controller        
 */
#define CONFIG_MCTRL_LEON2 1
#undef  CONFIG_MCTRL_8BIT
#define CONFIG_MCTRL_16BIT 1
#undef  CONFIG_MCTRL_5CS
#define CONFIG_MCTRL_SDRAM 1
#define CONFIG_MCTRL_SDRAM_SEPBUS 1
#define CONFIG_MCTRL_SDRAM_BUS64 1
#undef  CONFIG_MCTRL_SDRAM_INVCLK
#undef  CONFIG_MCTRL_PAGE
/*
 * MIG 7-Series memory controller   
 */
#undef  CONFIG_MIG_7SERIES
#undef  CONFIG_MIG_7SERIES_MODEL
#undef  CONFIG_AHBSTAT_ENABLE
/*
 * On-chip RAM/ROM                 
 */
#define CONFIG_AHBROM_ENABLE 1
#define CONFIG_AHBROM_START 000
#define CONFIG_AHBROM_PIPE 1
#define CONFIG_AHBRAM_ENABLE 1
#undef  CONFIG_AHBRAM_SZ1
#undef  CONFIG_AHBRAM_SZ2
#define CONFIG_AHBRAM_SZ4 1
#undef  CONFIG_AHBRAM_SZ8
#undef  CONFIG_AHBRAM_SZ16
#undef  CONFIG_AHBRAM_SZ32
#undef  CONFIG_AHBRAM_SZ64
#undef  CONFIG_AHBRAM_SZ128
#undef  CONFIG_AHBRAM_SZ256
#undef  CONFIG_AHBRAM_SZ512
#undef  CONFIG_AHBRAM_SZ1024
#undef  CONFIG_AHBRAM_SZ2048
#undef  CONFIG_AHBRAM_SZ4096
#define CONFIG_AHBRAM_START A00
#undef  CONFIG_AHBRAM_PIPE
/*
 * Ethernet             
 */
#define CONFIG_GRETH_ENABLE 1
#undef  CONFIG_GRETH_GIGA
#undef  CONFIG_GRETH_FIFO4
#define CONFIG_GRETH_FIFO8 1
#undef  CONFIG_GRETH_FIFO16
#undef  CONFIG_GRETH_FIFO32
#undef  CONFIG_GRETH_FIFO64
#undef  CONFIG_GRETH_FMC_MODE
/*
 * UARTs, timers and irq control         
 */
#define CONFIG_UART1_ENABLE 1
#define CONFIG_UA1_FIFO1 1
#undef  CONFIG_UA1_FIFO2
#undef  CONFIG_UA1_FIFO4
#undef  CONFIG_UA1_FIFO8
#undef  CONFIG_UA1_FIFO16
#undef  CONFIG_UA1_FIFO32
#define CONFIG_GPT_ENABLE 1
#define CONFIG_GPT_NTIM (2)
#define CONFIG_GPT_SW (8)
#define CONFIG_GPT_TW (32)
#define CONFIG_GPT_IRQ (8)
#undef  CONFIG_GPT_SEPIRQ
#undef  CONFIG_GPT_WDOGEN
#define CONFIG_GRGPIO_ENABLE 1
#define CONFIG_GRGPIO_WIDTH (20)
#define CONFIG_GRGPIO_IMASK FFFE
#undef  CONFIG_I2C_ENABLE
/*
 * SPI
 */
/*
 * SPI controller(s) 
 */
#undef  CONFIG_SPICTRL_ENABLE
/*
 * VHDL Debugging        
 */
#define CONFIG_DEBUG_UART 1
