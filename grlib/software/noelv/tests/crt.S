# See LICENSE for license details.

#include "encoding.h"

#if __riscv_xlen == 64
# define LREG ld
# define SREG sd
# define REGBYTES 8
#else
# define LREG lw
# define SREG sw
# define REGBYTES 4
#endif

  .section ".text.init"
  .globl _start
_start:
  li  x1, 0
  li  x2, 0
  li  x3, 0
  li  x4, 0
  li  x5, 0
  li  x6, 0
  li  x7, 0
  li  x8, 0
  li  x9, 0
  li  x10,0
  li  x11,0
  li  x12,0
  li  x13,0
  li  x14,0
  li  x15,0
  li  x16,0
  li  x17,0
  li  x18,0
  li  x19,0
  li  x20,0
  li  x21,0
  li  x22,0
  li  x23,0
  li  x24,0
  li  x25,0
  li  x26,0
  li  x27,0
  li  x28,0
  li  x29,0
  li  x30,0
  li  x31,0

  # enable FPU and accelerator if present
  li t0, MSTATUS_FS | MSTATUS_XS
  csrs mstatus, t0

  la sp, end_stack
  csrw mscratch, sp

  # make sure XLEN agrees with compilation choice
  li t0, 1
  slli t0, t0, 31
#if __riscv_xlen == 64
  bgez t0, 1f
#else
  bltz t0, 1f
#endif
2:
  li a0, 1
  sw a0, tohost, t0
  j 2b
1:

#ifdef __riscv_flen
  # initialize FPU if we have one
  la t0, 1f
  csrw mtvec, t0

  fssr    x0
  fmv.s.x f0, x0
  fmv.s.x f1, x0
  fmv.s.x f2, x0
  fmv.s.x f3, x0
  fmv.s.x f4, x0
  fmv.s.x f5, x0
  fmv.s.x f6, x0
  fmv.s.x f7, x0
  fmv.s.x f8, x0
  fmv.s.x f9, x0
  fmv.s.x f10,x0
  fmv.s.x f11,x0
  fmv.s.x f12,x0
  fmv.s.x f13,x0
  fmv.s.x f14,x0
  fmv.s.x f15,x0
  fmv.s.x f16,x0
  fmv.s.x f17,x0
  fmv.s.x f18,x0
  fmv.s.x f19,x0
  fmv.s.x f20,x0
  fmv.s.x f21,x0
  fmv.s.x f22,x0
  fmv.s.x f23,x0
  fmv.s.x f24,x0
  fmv.s.x f25,x0
  fmv.s.x f26,x0
  fmv.s.x f27,x0
  fmv.s.x f28,x0
  fmv.s.x f29,x0
  fmv.s.x f30,x0
  fmv.s.x f31,x0
1:
#endif

  # initialize trap vector
  la t0, trap_entry
  csrw mtvec, t0

  # initialize global pointer
.option push
.option norelax
  la gp, __global_pointer$
.option pop

  la  tp, _end + 63
  and tp, tp, -64

  # get core id
  csrr a0, mhartid
  # for now, assume only 1 core
  li a1, 1
1:bgeu a0, a1, 1b

  # give each core 128KB of stack + TLS
#define STKSHIFT 17
  sll a2, a0, STKSHIFT
  add tp, tp, a2
  add sp, a0, 1
  sll sp, sp, STKSHIFT
  add sp, sp, tp

  j _init

  .align 2
trap_entry:
  csrrw sp,mscratch,sp
  addi sp, sp, -272

  SREG x1, 1*REGBYTES(sp)
  SREG x2, 2*REGBYTES(sp)
  SREG x3, 3*REGBYTES(sp)
  SREG x4, 4*REGBYTES(sp)
  SREG x5, 5*REGBYTES(sp)
  SREG x6, 6*REGBYTES(sp)
  SREG x7, 7*REGBYTES(sp)
  SREG x8, 8*REGBYTES(sp)
  SREG x9, 9*REGBYTES(sp)
  SREG x10, 10*REGBYTES(sp)
  SREG x11, 11*REGBYTES(sp)
  SREG x12, 12*REGBYTES(sp)
  SREG x13, 13*REGBYTES(sp)
  SREG x14, 14*REGBYTES(sp)
  SREG x15, 15*REGBYTES(sp)
  SREG x16, 16*REGBYTES(sp)
  SREG x17, 17*REGBYTES(sp)
  SREG x18, 18*REGBYTES(sp)
  SREG x19, 19*REGBYTES(sp)
  SREG x20, 20*REGBYTES(sp)
  SREG x21, 21*REGBYTES(sp)
  SREG x22, 22*REGBYTES(sp)
  SREG x23, 23*REGBYTES(sp)
  SREG x24, 24*REGBYTES(sp)
  SREG x25, 25*REGBYTES(sp)
  SREG x26, 26*REGBYTES(sp)
  SREG x27, 27*REGBYTES(sp)
  SREG x28, 28*REGBYTES(sp)
  SREG x29, 29*REGBYTES(sp)
  SREG x30, 30*REGBYTES(sp)
  SREG x31, 31*REGBYTES(sp)

  csrr a0, mcause
  csrr a1, mepc
  mv a2, sp
  jal handle_trap
  csrw mepc, a0

#if !defined(RANDOM_TEST) && !defined(CUSTOM_TEST)
  # Remain in M-mode after eret
  li t0, MSTATUS_MPP
  csrs mstatus, t0
#endif ##RANDOM_TEST

  LREG x1, 1*REGBYTES(sp)
  LREG x2, 2*REGBYTES(sp)
  LREG x3, 3*REGBYTES(sp)
  LREG x4, 4*REGBYTES(sp)
  LREG x5, 5*REGBYTES(sp)
  LREG x6, 6*REGBYTES(sp)
  LREG x7, 7*REGBYTES(sp)
  LREG x8, 8*REGBYTES(sp)
  LREG x9, 9*REGBYTES(sp)
  LREG x10, 10*REGBYTES(sp)
  LREG x11, 11*REGBYTES(sp)
  LREG x12, 12*REGBYTES(sp)
  LREG x13, 13*REGBYTES(sp)
  LREG x14, 14*REGBYTES(sp)
  LREG x15, 15*REGBYTES(sp)
  LREG x16, 16*REGBYTES(sp)
  LREG x17, 17*REGBYTES(sp)
  LREG x18, 18*REGBYTES(sp)
  LREG x19, 19*REGBYTES(sp)
  LREG x20, 20*REGBYTES(sp)
  LREG x21, 21*REGBYTES(sp)
  LREG x22, 22*REGBYTES(sp)
  LREG x23, 23*REGBYTES(sp)
  LREG x24, 24*REGBYTES(sp)
  LREG x25, 25*REGBYTES(sp)
  LREG x26, 26*REGBYTES(sp)
  LREG x27, 27*REGBYTES(sp)
  LREG x28, 28*REGBYTES(sp)
  LREG x29, 29*REGBYTES(sp)
  LREG x30, 30*REGBYTES(sp)
  LREG x31, 31*REGBYTES(sp)

  addi sp, sp, 272
  csrrw sp,mscratch,sp
  mret

  nop
  .align 4

##This trap handling routine will be used only in random tests with enabled MMU
.global mmu_trap_entry
mmu_trap_entry:
  nop
  csrw mscratch, x31
  lui x31, 0x4000c
  SREG a0, 0(x31)
  SREG a1, 8(x31)
  SREG a2, 16(x31)
  SREG a3, 24(x31)	
  ##take different actions depending on the trap cause
  csrr a0, mcause
  ##for illegal instruction trap, return to machine mode
  li a1, 2
  beq a1, a0, return_m_mode
  ##For EBREAK, go to a special routine
  li a1, 3
  beq a1, a0, ebreak_routine
  #for access fault traps, go to page_fault_routine	
  li a1, 1
  beq a0, a1, access_fault_routine
  li a1, 5
  beq a0, a1, access_fault_routine
  li a1, 7
  beq a0, a1, access_fault_routine
  #for page fault traps, go to access_fault_routine	
  li a1, 12
  bgeu a0, a1, page_fault_routine
  nop
  nop
  #Other trap kinds are unexpected: end the test with an error
  jal endtest_mmu

  ###Switch to machine mode upon mret
return_m_mode:	
  csrr a0, mstatus
  li a1, 0x1800
  or a0,a0,a1
  csrw mstatus, a0
  LREG a0, 0(x31)
  LREG a1, 8(x31)
  LREG a2, 16(x31)
  LREG a3, 24(x31)
  csrr x31, mscratch
  mret

##This routine investigates and fixes the cause of a page fault
##by setting the appropriate bits in the PTE
page_fault_routine:
  csrr a2, mcause
  li a1, 12
  csrr a0, mtval
fix_pte:
  ##Only access level 0 table @ 0x40018000 and modify the leaf pte
  li a1, 0x40018000
  srl a0, a0, 12
  li a2, 0x1FF
  and a0, a0, a2
  sll a0, a0,3
  ##PTE address in a0
  add a0, a0, a1
  ##Load the PTE in a1
  LREG a1, (a0)
  ##Determine if the page fault was caused by user/supervisor access privilege
  csrr a2, mstatus
  li  a3, 0x800
  and a2, a2, a3
  ##If the 11th bit of mstatus is set then the privilege is supervisor	
  srl a2, a2, 11
  ##if the 4th bit of the PTW is set then the page can only be accessed by user	
  and a3, a1, 0x10
  srl a3, a3, 4
  ##if the privileges are the same then the access was not allowed because of xwr bits
  bne a3, a2, fix_pte_xwr
  ##otherwise switch the privilege mode of the PTE
  xori a1, a1, 0x10
  SREG a1, (a0)
fix_pte_xwr:
  ##take different actions depending on the trap cause
  csrr a2, mcause
  #instruction page fault. Set X bit to 1
  li a3, 12
  beq a2,a3, set_x
  #load page fault. Set R bit to 1
  li a3, 13
  beq a2,a3, set_r
  #Othewise store_amo page fault. Set WR bits to 1
set_wr:	
  ori a1,a1, 0x7
  SREG a1, (a0)
  jal x0, return_pf 	
set_x:	
  ori a1,a1, 0x9
  SREG a1, (a0)
  jal x0, return_pf 	
set_r:
  ori a1,a1, 0x3
  SREG a1, (a0) 
return_pf:
  sfence.vma
  LREG a0, 0(x31)
  LREG a1, 8(x31)
  LREG a2, 16(x31)
  LREG a3, 24(x31)
  csrr x31, mscratch
  nop
  mret

ebreak_routine:
  ##Switch privilege mode between user(MPP=00) and supervisor(MPP=01).
  csrr a0, mstatus
  li   a1, 0x800
  xor  a0, a0, a1
  csrw mstatus, a0
  ##TODO? update corresponding PTE to avoid trap
  nop
  ##Return to the instruction following EBREAK
  csrr a0, mepc
  # multiply with 0x3 withe instruction
  lb t1,0(a0)
  andi t1,t1,3
  #xor with 0x3
  xori t1,t1,3
  # compressed instruction needs only two bytes. So next PC will be PC+2
  addi a0, a0, 2
  # not equal to 0, then compressed.
  bnez t1,cont_trap_handle
  # Else increment PC to PC+4 by adding by two again
  addi a0, a0, 2
  cont_trap_handle:
  csrw mepc, a0
  LREG a0, 0(x31)
  LREG a1, 8(x31)
  LREG a2, 16(x31)
  LREG a3, 24(x31)
  csrr x31, mscratch	
  mret

access_fault_routine:
  csrr a2, mcause
  #instruction access fault. Set X bit to 1
  li a3, 1
  beq a2,a3, set_xa
  #load access fault. Set R bit to 1
  li a3, 5
  beq a2,a3, set_ra
  #Othewise store_amo access fault. Set WR bits to 1
ser_wra:
  li a2, 3
  jal x0, fix_access_fault 
set_xa:
  li a2, 4
  jal x0, fix_access_fault
set_ra:	
  li a2, 1
	
fix_access_fault:
  csrr a0, mtval
  li a1, 0x40000000
  bgeu a1,a0, write_pmpcfg0	
  srli a0,a0, 12	
  andi a0,a0, 0xFF	
  li a1, 7
  bge a0, a1, use_pmpcfg2
##shift to affect the correct pmpXcfg
  sll a2, a2, 8		
  li a1, 1
shift_0:
  bge x0, a0, write_pmpcfg0	
  sll a2, a2, 8	
  sub a0,a0, a1
  jal x0, shift_0
write_pmpcfg0:	
  csrr a3, pmpcfg0
  or a3, a3,a2
  csrw pmpcfg0, a3
  jal x0, return_pf
use_pmpcfg2:
  sub a0, a0, a1
  li a1, 1
shift_1:
  bge x0, a0, write_pmpcfg2	
  sll a2, a2, 8	
  sub a0,a0, a1
  jal x0, shift_1
write_pmpcfg2:	
  csrr a3, pmpcfg2
  or a3, a3,a2
  csrw pmpcfg2, a3
  jal x0, return_pf


	
endtest_mmu:
  fence
  mv a5,x0
  ori a5,a5,1
  sw a5, tohost, t5 # 40001000 <tohost>
  nop
  nop
  mv a5,x0
  lui a5,0x20000
  sw zero,20(a5) # 20000014
  ebreak
  j endtest_mmu
	


  nop
  .align 4

  ## My stack defined during RANDOM verification; 6 kB (data-stack) + 8 B (safety interval) + 272 B (trap-stack)
  .comm mystack,6424,6424
  .comm end_stack,256,256

.section ".tdata.begin"
.globl _tdata_begin
_tdata_begin:

.section ".tdata.end"
.globl _tdata_end
_tdata_end:

.section ".tbss.end"
.globl _tbss_end
_tbss_end:

.section ".tohost","aw",@progbits
.align 6
.globl tohost
tohost: .dword 0
.align 6
.globl fromhost
fromhost: .dword 0
