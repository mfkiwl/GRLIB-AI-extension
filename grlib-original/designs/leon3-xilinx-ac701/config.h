/*
 * Automatically generated C config: don't edit
 */
#define AUTOCONF_INCLUDED
#define CONFIG_LEON3FT_PRESENT 1
#define CONFIG_HAS_SHARED_GRFPU 1
/*
 * Synthesis      
 */
#undef  CONFIG_SYN_INFERRED
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
#define CONFIG_SYN_ARTIX7 1
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
#undef  CONFIG_SYN_INFER_RAM
#undef  CONFIG_SYN_INFER_PADS
#undef  CONFIG_SYN_NO_ASYNC
#undef  CONFIG_SYN_SCAN
/*
 * Clock generation
 */
#undef  CONFIG_CLK_INFERRED
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
#define CONFIG_CLK_DCM 1
#define CONFIG_CLK_MUL (4)
#define CONFIG_CLK_DIV (8)
#undef  CONFIG_PCI_CLKDLL
#undef  CONFIG_CLK_NOFB
#undef  CONFIG_PCI_SYSCLK
/*
 * Processor            
 */
#define CONFIG_LEON3 1
#undef  CONFIG_LEON4
#define CONFIG_PROC_NUM (1)
#undef  CONFIG_LEON_MIN
#undef  CONFIG_LEON_GP
#undef  CONFIG_LEON_HP
#define CONFIG_LEON_CUSTOM 1
/*
 * Integer unit                                           
 */
#define CONFIG_IU_NWINDOWS (8)
#undef  CONFIG_IU_RFINF
#define CONFIG_IU_V8MULDIV 1
#define CONFIG_IU_MUL_LATENCY_2 1
#undef  CONFIG_IU_MUL_LATENCY_4
#undef  CONFIG_IU_MUL_LATENCY_5
#define CONFIG_IU_MUL_INFERRED 1
#undef  CONFIG_IU_MUL_MODGEN
#undef  CONFIG_IU_MUL_TECHSPEC
#undef  CONFIG_IU_MUL_DW
#define CONFIG_IU_SVT 1
#define CONFIG_IU_LDELAY (1)
#define CONFIG_IU_WATCHPOINTS (2)
#define CONFIG_PWD 1
#define CONFIG_IU_RSTADDR 00000
#define CONFIG_NP_ASI 1
#define CONFIG_WRPSR 1
#undef  CONFIG_ALTWIN
#undef  CONFIG_REX
/*
 * Floating-point unit
 */
#undef  CONFIG_FPU_ENABLE
/*
 * Cache system
 */
#define CONFIG_ICACHE_ENABLE 1
#define CONFIG_ICACHE_ASSO1 1
#undef  CONFIG_ICACHE_ASSO2
#undef  CONFIG_ICACHE_ASSO3
#undef  CONFIG_ICACHE_ASSO4
#undef  CONFIG_ICACHE_SZ1
#undef  CONFIG_ICACHE_SZ2
#define CONFIG_ICACHE_SZ4 1
#undef  CONFIG_ICACHE_SZ8
#undef  CONFIG_ICACHE_SZ16
#undef  CONFIG_ICACHE_SZ32
#undef  CONFIG_ICACHE_SZ64
#undef  CONFIG_ICACHE_SZ128
#undef  CONFIG_ICACHE_SZ256
#define CONFIG_ICACHE_LZ16 1
#undef  CONFIG_ICACHE_LZ32
#undef  CONFIG_ICACHE_LRAM
#define CONFIG_DCACHE_ENABLE 1
#define CONFIG_DCACHE_ASSO1 1
#undef  CONFIG_DCACHE_ASSO2
#undef  CONFIG_DCACHE_ASSO3
#undef  CONFIG_DCACHE_ASSO4
#undef  CONFIG_DCACHE_SZ1
#undef  CONFIG_DCACHE_SZ2
#define CONFIG_DCACHE_SZ4 1
#undef  CONFIG_DCACHE_SZ8
#undef  CONFIG_DCACHE_SZ16
#undef  CONFIG_DCACHE_SZ32
#undef  CONFIG_DCACHE_SZ64
#undef  CONFIG_DCACHE_SZ128
#undef  CONFIG_DCACHE_SZ256
#define CONFIG_DCACHE_LZ16 1
#undef  CONFIG_DCACHE_LZ32
#define CONFIG_DCACHE_SNOOP 1
#define CONFIG_DCACHE_SNOOP_SEPTAG 1
#undef  CONFIG_DCACHE_SNOOP_SP
#define CONFIG_CACHE_FIXED 0
#define CONFIG_BWMASK 0000
#define CONFIG_CACHE_64BIT 1
#undef  CONFIG_CACHE_128BIT
#undef  CONFIG_DCACHE_LRAM
/*
 * MMU
 */
#undef  CONFIG_MMU_ENABLE
/*
 * Debug Support Unit        
 */
#define CONFIG_DSU_ENABLE 1
#define CONFIG_DSU_ITRACE 1
#undef  CONFIG_DSU_ITRACESZ1
#undef  CONFIG_DSU_ITRACESZ2
#define CONFIG_DSU_ITRACESZ4 1
#undef  CONFIG_DSU_ITRACESZ8
#undef  CONFIG_DSU_ITRACESZ16
#define CONFIG_DSU_ITRACE_2P 1
#define CONFIG_DSU_ATRACE 1
#undef  CONFIG_DSU_ATRACESZ1
#undef  CONFIG_DSU_ATRACESZ2
#define CONFIG_DSU_ATRACESZ4 1
#undef  CONFIG_DSU_ATRACESZ8
#undef  CONFIG_DSU_ATRACESZ16
#define CONFIG_STAT_ENABLE 1
#define CONFIG_STAT_CNT (4)
#define CONFIG_STAT_NMAX (0)
/*
 * Fault-tolerance  
 */
#define CONFIG_IUFT_NONE 1
#undef  CONFIG_IUFT_PAR
#undef  CONFIG_IUFT_DMR
#undef  CONFIG_IUFT_BCH
#undef  CONFIG_IUFT_BCHOTF
#undef  CONFIG_IUFT_TECHSPEC
#undef  CONFIG_IUFT_TMR
#undef  CONFIG_RF_ERRINJ
#define CONFIG_CACHE_FT_NONE 1
#undef  CONFIG_CACHE_FT_EN
#undef  CONFIG_CACHE_FT_TECH
#define CONFIG_CACHE_ERRINJ (0)
/*
 * VHDL debug settings       
 */
#undef  CONFIG_IU_DISAS
#undef  CONFIG_DEBUG_PC32
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
#undef  CONFIG_L2_SHARE
#define CONFIG_L2_MAP 00F0
#define CONFIG_L2_MTRR (0)
#define CONFIG_L2_EDAC_NONE 1
#undef  CONFIG_L2_EDAC_YES
#undef  CONFIG_L2_EDAC_TECHSPEC
#undef  CONFIG_L2_AXI
/*
 * AMBA configuration
 */
#define CONFIG_AHB_DEFMST (0)
#define CONFIG_AHB_RROBIN 1
#undef  CONFIG_AHB_SPLIT
#define CONFIG_AHB_FPNPEN 1
#define CONFIG_AHB_IOADDR FFF
#define CONFIG_APB_HADDR 800
#undef  CONFIG_AHB_MON
#undef  CONFIG_AHB_MONERR
#undef  CONFIG_AHB_MONWAR
#undef  CONFIG_AHB_DTRACE
/*
 * Debug Link           
 */
#undef  CONFIG_DSU_UART
#define CONFIG_DSU_JTAG 1
#define CONFIG_DSU_ETH 1
#undef  CONFIG_DSU_ETHSZ1
#define CONFIG_DSU_ETHSZ2 1
#undef  CONFIG_DSU_ETHSZ4
#undef  CONFIG_DSU_ETHSZ8
#undef  CONFIG_DSU_ETHSZ16
#define CONFIG_DSU_IPMSB C0A8
#define CONFIG_DSU_IPLSB 0033
#define CONFIG_DSU_ETHMSB 020000
#define CONFIG_DSU_ETHLSB 000000
#undef  CONFIG_DSU_ETH_PROG
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
#define CONFIG_MCTRL_8BIT 1
#define CONFIG_MCTRL_16BIT 1
#undef  CONFIG_MCTRL_5CS
#undef  CONFIG_MCTRL_SDRAM
/*
 * MIG 7-Series memory controller   
 */
#define CONFIG_MIG_7SERIES 1
#define CONFIG_MIG_7SERIES_MODEL 1
#undef  CONFIG_AHBSTAT_ENABLE
#define CONFIG_AHBSTAT_NFTSLV (1)
/*
 * On-chip RAM/ROM                 
 */
#define CONFIG_AHBROM_ENABLE 1
#define CONFIG_AHBROM_START 000
#undef  CONFIG_AHBROM_PIPE
#undef  CONFIG_AHBRAM_ENABLE
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
#undef  CONFIG_GRETH_FT
/*
 * UARTs, timers and irq control         
 */
#define CONFIG_UART1_ENABLE 1
#undef  CONFIG_UA1_FIFO1
#undef  CONFIG_UA1_FIFO2
#undef  CONFIG_UA1_FIFO4
#undef  CONFIG_UA1_FIFO8
#undef  CONFIG_UA1_FIFO16
#define CONFIG_UA1_FIFO32 1
#define CONFIG_IRQ3_ENABLE 1
#undef  CONFIG_IRQ3_SEC
#define CONFIG_GPT_ENABLE 1
#define CONFIG_GPT_NTIM (2)
#define CONFIG_GPT_SW (8)
#define CONFIG_GPT_TW (32)
#define CONFIG_GPT_IRQ (8)
#define CONFIG_GPT_SEPIRQ 1
#undef  CONFIG_GPT_WDOGEN
#define CONFIG_GRGPIO_ENABLE 1
#define CONFIG_GRGPIO_WIDTH (7)
#define CONFIG_GRGPIO_IMASK 0000
#define CONFIG_I2C_ENABLE 1
/*
 * Keybord and VGA interface
 */
#undef  CONFIG_KBD_ENABLE
#undef  CONFIG_VGA_ENABLE
#undef  CONFIG_SVGA_ENABLE
/*
 * SPI
 */
/*
 * SPI memory controller 
 */
#undef  CONFIG_SPIMCTRL
#define CONFIG_SPIMCTRL_READCMD 0B
#undef  CONFIG_SPIMCTRL_DUMMYBYTE
#undef  CONFIG_SPIMCTRL_DUALOUTPUT
#define CONFIG_SPIMCTRL_OFFSET 0
#define CONFIG_SPIMCTRL_SCALER (8)
#define CONFIG_SPIMCTRL_ASCALER (8)
/*
 * SPI controller(s) 
 */
#undef  CONFIG_SPICTRL_ENABLE
#define CONFIG_SPICTRL_NUM (1)
#define CONFIG_SPICTRL_SLVS (1)
#define CONFIG_SPICTRL_FIFO (1)
#define CONFIG_SPICTRL_SLVREG 1
#undef  CONFIG_SPICTRL_ASEL
#undef  CONFIG_SPICTRL_AM
#undef  CONFIG_SPICTRL_ODMODE
#undef  CONFIG_SPICTRL_TWEN
#define CONFIG_SPICTRL_MAXWLEN (0)
#undef  CONFIG_SPICTRL_SYNCRAM
#define CONFIG_SPICTRL_PROT0 1
#undef  CONFIG_SPICTRL_PROT1
#undef  CONFIG_SPICTRL_PROT2
/*
 * VHDL Debugging        
 */
#undef  CONFIG_DEBUG_UART