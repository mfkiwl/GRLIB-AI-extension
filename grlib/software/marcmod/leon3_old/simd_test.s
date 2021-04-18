	.file	"simd_test.c"
	.section	".text"
.LLtext0:
	.cfi_sections	.debug_frame
	.section	".rodata"
	.align 8
.LLC0:
	.asciz	"NOP"
	.align 8
.LLC1:
	.asciz	"add: c=%#010x, expected result 0x01030507\n"
	.align 8
.LLC2:
	.asciz	"sadd: c=%#010x, expected result 0x80807e7f\n"
	.align 8
.LLC3:
	.asciz	"sub: c=%#010x, expected result 0x0a0500ff\n"
	.align 8
.LLC4:
	.asciz	"ssub: c=%#010x, expected result 0x807f7ff1\n"
	.align 8
.LLC5:
	.asciz	"max max: c=%#010x, expected result 0x00000040\n"
	.align 8
.LLC6:
	.asciz	"max max: c=%#010x, expected result 0x000000a0\n"
	.align 8
.LLC7:
	.asciz	"min min: c=%#010x, expected result 0x00000002\n"
	.align 8
.LLC8:
	.asciz	"min min: c=%#010x, expected result 0xffffff80\n"
	.align 8
.LLC9:
	.asciz	"dot prduct: c=%#010x, expected result 0x00000014\n"
	.align 8
.LLC10:
	.asciz	"dot prduct2: c=%#010x, expected result 0xfffffffc\n"
	.align 8
.LLC11:
	.asciz	"div: c=%#010x, expected result 0x4020ff01\n"
	.align 8
.LLC12:
	.asciz	"div2: c=%#010x, expected result 0xf6fb0aff\n"
	.align 8
.LLC13:
	.asciz	"nand: c=%#010x, expected result 0x21524150\n"
	.align 8
.LLC14:
	.asciz	"xor reduce: c=%#010x, expected result 0x00000027\n"
	.align 8
.LLC15:
	.asciz	"END OF TEST"
	.section	".text"
	.align 4
	.global main
	.type	main, #function
	.proc	04
main:
.LLFB1:
	.file 1 "simd_test.c"
	.loc 1 7 0
	.cfi_startproc
	save	%sp, -112, %sp
.LLCFI0:
	.cfi_window_save
	.cfi_register 15, 31
	.cfi_def_cfa_register 30
	.loc 1 11 0
	sethi	%hi(16908288), %g1
	or	%g1, 772, %g1
	st	%g1, [%fp-4]
	.loc 1 12 0
	sethi	%hi(65536), %g1
	or	%g1, 515, %g1
	st	%g1, [%fp-8]
	.loc 1 13 0
	sethi	%hi(.LLC0), %g1
	or	%g1, %lo(.LLC0), %o0
	call	puts, 0
	 nop
	.loc 1 16 0
	ld	[%fp-4], %g2
	ld	[%fp-8], %g1
	add	%g2, %g1, %g1
	st	%g1, [%fp-12]
	.loc 1 17 0
	ld	[%fp-12], %o1
	sethi	%hi(.LLC1), %g1
	or	%g1, %lo(.LLC1), %o0
	call	printf, 0
	 nop
	.loc 1 20 0
	sethi	%hi(-2122253312), %g1
	or	%g1, 769, %g1
	st	%g1, [%fp-4]
	.loc 1 21 0
	sethi	%hi(-2113963008), %g1
	or	%g1, 895, %g1
	st	%g1, [%fp-8]
	.loc 1 22 0
	ld	[%fp-4], %g2
	ld	[%fp-8], %g1
	add	%g2, %g1, %g1
	st	%g1, [%fp-12]
	.loc 1 23 0
	ld	[%fp-12], %o1
	sethi	%hi(.LLC2), %g1
	or	%g1, %lo(.LLC2), %o0
	call	printf, 0
	 nop
	.loc 1 26 0
	sethi	%hi(168429568), %g1
	or	%g1, 522, %g1
	st	%g1, [%fp-4]
	.loc 1 27 0
	sethi	%hi(329728), %g1
	or	%g1, 523, %g1
	st	%g1, [%fp-8]
	.loc 1 28 0
	ld	[%fp-4], %g2
	ld	[%fp-8], %g1
	sub	%g2, %g1, %g1
	st	%g1, [%fp-12]
	.loc 1 29 0
	ld	[%fp-12], %o1
	sethi	%hi(.LLC3), %g1
	or	%g1, %lo(.LLC3), %o0
	call	printf, 0
	 nop
	.loc 1 32 0
	sethi	%hi(-2139158528), %g1
	or	%g1, 763, %g1
	st	%g1, [%fp-4]
	.loc 1 33 0
	sethi	%hi(100661248), %g1
	or	%g1, 778, %g1
	st	%g1, [%fp-8]
	.loc 1 34 0
	ld	[%fp-4], %g2
	ld	[%fp-8], %g1
	sub	%g2, %g1, %g1
	st	%g1, [%fp-12]
	.loc 1 35 0
	ld	[%fp-12], %o1
	sethi	%hi(.LLC4), %g1
	or	%g1, %lo(.LLC4), %o0
	call	printf, 0
	 nop
	.loc 1 38 0
	sethi	%hi(33818624), %g1
	or	%g1, 10, %g1
	st	%g1, [%fp-4]
	.loc 1 39 0
	sethi	%hi(541097984), %g1
	or	%g1, 160, %g1
	st	%g1, [%fp-8]
	.loc 1 40 0
	ld	[%fp-4], %g2
	ld	[%fp-8], %g1
	sub	%g2, %g1, %g1
	st	%g1, [%fp-12]
	.loc 1 41 0
	ld	[%fp-12], %o1
	sethi	%hi(.LLC5), %g1
	or	%g1, %lo(.LLC5), %o0
	call	printf, 0
	 nop
	.loc 1 44 0
	ld	[%fp-4], %g2
	ld	[%fp-8], %g1
	sub	%g2, %g1, %g1
	st	%g1, [%fp-12]
	.loc 1 45 0
	ld	[%fp-12], %o1
	sethi	%hi(.LLC6), %g1
	or	%g1, %lo(.LLC6), %o0
	call	printf, 0
	 nop
	.loc 1 48 0
	ld	[%fp-4], %g2
	ld	[%fp-8], %g1
	sub	%g2, %g1, %g1
	st	%g1, [%fp-12]
	.loc 1 49 0
	ld	[%fp-12], %o1
	sethi	%hi(.LLC7), %g1
	or	%g1, %lo(.LLC7), %o0
	call	printf, 0
	 nop
	.loc 1 52 0
	ld	[%fp-4], %g2
	ld	[%fp-8], %g1
	sub	%g2, %g1, %g1
	st	%g1, [%fp-12]
	.loc 1 53 0
	ld	[%fp-12], %o1
	sethi	%hi(.LLC8), %g1
	or	%g1, %lo(.LLC8), %o0
	call	printf, 0
	 nop
	.loc 1 56 0
	sethi	%hi(16908288), %g1
	or	%g1, 772, %g1
	st	%g1, [%fp-4]
	.loc 1 57 0
	sethi	%hi(65536), %g1
	or	%g1, 515, %g1
	st	%g1, [%fp-8]
	.loc 1 58 0
	ld	[%fp-4], %g2
	ld	[%fp-8], %g1
	smul	%g2, %g1, %g1
	st	%g1, [%fp-12]
	.loc 1 59 0
	ld	[%fp-12], %o1
	sethi	%hi(.LLC9), %g1
	or	%g1, %lo(.LLC9), %o0
	call	printf, 0
	 nop
	.loc 1 62 0
	sethi	%hi(-131072), %g1
	or	%g1, 1020, %g1
	st	%g1, [%fp-4]
	.loc 1 63 0
	sethi	%hi(16711680), %g1
	or	%g1, 515, %g1
	st	%g1, [%fp-8]
	.loc 1 64 0
	ld	[%fp-4], %g2
	ld	[%fp-8], %g1
	smul	%g2, %g1, %g1
	st	%g1, [%fp-12]
	.loc 1 65 0
	ld	[%fp-12], %o1
	sethi	%hi(.LLC10), %g1
	or	%g1, %lo(.LLC10), %o0
	call	printf, 0
	 nop
	.loc 1 68 0
	sethi	%hi(1077952512), %g1
	or	%g1, 64, %g1
	st	%g1, [%fp-4]
	.loc 1 69 0
	sethi	%hi(16908288), %g1
	or	%g1, 64, %g1
	st	%g1, [%fp-8]
	.loc 1 70 0
	ld	[%fp-4], %g1
	sra	%g1, 31, %g2
	wr	%g2, 0, %y
	ld	[%fp-8], %g2
	nop
	nop
	sdiv	%g1, %g2, %g1
	st	%g1, [%fp-12]
	.loc 1 71 0
	ld	[%fp-12], %o1
	sethi	%hi(.LLC11), %g1
	or	%g1, %lo(.LLC11), %o0
	call	printf, 0
	 nop
	.loc 1 74 0
	sethi	%hi(-151587840), %g1
	or	%g1, 758, %g1
	st	%g1, [%fp-4]
	.loc 1 75 0
	sethi	%hi(16972800), %g1
	or	%g1, 778, %g1
	st	%g1, [%fp-8]
	.loc 1 76 0
	ld	[%fp-4], %g1
	sra	%g1, 31, %g2
	wr	%g2, 0, %y
	ld	[%fp-8], %g2
	nop
	nop
	sdiv	%g1, %g2, %g1
	st	%g1, [%fp-12]
	.loc 1 77 0
	ld	[%fp-12], %o1
	sethi	%hi(.LLC12), %g1
	or	%g1, %lo(.LLC12), %o0
	call	printf, 0
	 nop
	.loc 1 80 0
	sethi	%hi(-559039488), %g1
	or	%g1, 687, %g1
	st	%g1, [%fp-4]
	.loc 1 81 0
	ld	[%fp-4], %g1
	xnor	%g0, %g1, %g1
	st	%g1, [%fp-12]
	.loc 1 82 0
	ld	[%fp-12], %o1
	sethi	%hi(.LLC13), %g1
	or	%g1, %lo(.LLC13), %o0
	call	printf, 0
	 nop
	.loc 1 85 0
	sethi	%hi(-17971200), %g1
	or	%g1, 766, %g1
	st	%g1, [%fp-4]
	.loc 1 86 0
	ld	[%fp-4], %g2
	ld	[%fp-8], %g1
	smul	%g2, %g1, %g1
	st	%g1, [%fp-12]
	.loc 1 87 0
	ld	[%fp-12], %o1
	sethi	%hi(.LLC14), %g1
	or	%g1, %lo(.LLC14), %o0
	call	printf, 0
	 nop
	.loc 1 89 0
	sethi	%hi(.LLC15), %g1
	or	%g1, %lo(.LLC15), %o0
	call	puts, 0
	 nop
	mov	0, %g1
	.loc 1 90 0
	mov	%g1, %i0
	restore
	jmp	%o7+8
	 nop
	.cfi_endproc
.LLFE1:
	.size	main, .-main
.LLetext0:
	.file 2 "/home/march/pd_project/bcc-2.0.7-gcc/sparc-gaisler-elf/include/sys/lock.h"
	.file 3 "/home/march/pd_project/bcc-2.0.7-gcc/sparc-gaisler-elf/include/sys/_types.h"
	.file 4 "/home/march/pd_project/bcc-2.0.7-gcc/lib/gcc/sparc-gaisler-elf/7.2.0/include/stddef.h"
	.file 5 "/home/march/pd_project/bcc-2.0.7-gcc/sparc-gaisler-elf/include/sys/reent.h"
	.file 6 "/home/march/pd_project/bcc-2.0.7-gcc/sparc-gaisler-elf/include/stdlib.h"
	.section	.debug_info,"",@progbits
.LLdebug_info0:
	.uaword	0x9af
	.uahalf	0x2
	.uaword	.LLdebug_abbrev0
	.byte	0x4
	.uleb128 0x1
	.uaword	.LLASF122
	.byte	0x1
	.uaword	.LLASF123
	.uaword	.LLASF124
	.uaword	.LLtext0
	.uaword	.LLetext0
	.uaword	.LLdebug_line0
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.uaword	.LLASF0
	.uleb128 0x2
	.byte	0x1
	.byte	0x8
	.uaword	.LLASF1
	.uleb128 0x2
	.byte	0x2
	.byte	0x5
	.uaword	.LLASF2
	.uleb128 0x2
	.byte	0x2
	.byte	0x7
	.uaword	.LLASF3
	.uleb128 0x2
	.byte	0x4
	.byte	0x5
	.uaword	.LLASF4
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.uaword	.LLASF5
	.uleb128 0x2
	.byte	0x8
	.byte	0x5
	.uaword	.LLASF6
	.uleb128 0x2
	.byte	0x8
	.byte	0x7
	.uaword	.LLASF7
	.uleb128 0x3
	.byte	0x4
	.byte	0x5
	.asciz	"int"
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.uaword	.LLASF8
	.uleb128 0x2
	.byte	0x8
	.byte	0x4
	.uaword	.LLASF9
	.uleb128 0x4
	.uaword	.LLASF10
	.byte	0x2
	.byte	0x7
	.uaword	0x5d
	.uleb128 0x4
	.uaword	.LLASF11
	.byte	0x3
	.byte	0x2c
	.uaword	0x41
	.uleb128 0x4
	.uaword	.LLASF12
	.byte	0x3
	.byte	0x72
	.uaword	0x41
	.uleb128 0x5
	.uaword	.LLASF13
	.byte	0x4
	.uahalf	0x165
	.uaword	0x64
	.uleb128 0x6
	.byte	0x4
	.byte	0x3
	.byte	0xa6
	.uaword	0xbe
	.uleb128 0x7
	.uaword	.LLASF14
	.byte	0x3
	.byte	0xa8
	.uaword	0x93
	.uleb128 0x7
	.uaword	.LLASF15
	.byte	0x3
	.byte	0xa9
	.uaword	0xbe
	.byte	0
	.uleb128 0x8
	.uaword	0x2c
	.uaword	0xce
	.uleb128 0x9
	.uaword	0x64
	.byte	0x3
	.byte	0
	.uleb128 0xa
	.byte	0x8
	.byte	0x3
	.byte	0xa3
	.uaword	0xf3
	.uleb128 0xb
	.uaword	.LLASF16
	.byte	0x3
	.byte	0xa5
	.uaword	0x5d
	.byte	0x2
	.byte	0x23
	.uleb128 0
	.uleb128 0xb
	.uaword	.LLASF17
	.byte	0x3
	.byte	0xaa
	.uaword	0x9f
	.byte	0x2
	.byte	0x23
	.uleb128 0x4
	.byte	0
	.uleb128 0x4
	.uaword	.LLASF18
	.byte	0x3
	.byte	0xab
	.uaword	0xce
	.uleb128 0x4
	.uaword	.LLASF19
	.byte	0x3
	.byte	0xaf
	.uaword	0x72
	.uleb128 0xc
	.byte	0x4
	.uleb128 0x4
	.uaword	.LLASF20
	.byte	0x5
	.byte	0x16
	.uaword	0x48
	.uleb128 0xd
	.uaword	.LLASF25
	.byte	0x18
	.byte	0x5
	.byte	0x2f
	.uaword	0x175
	.uleb128 0xb
	.uaword	.LLASF21
	.byte	0x5
	.byte	0x31
	.uaword	0x175
	.byte	0x2
	.byte	0x23
	.uleb128 0
	.uleb128 0xe
	.asciz	"_k"
	.byte	0x5
	.byte	0x32
	.uaword	0x5d
	.byte	0x2
	.byte	0x23
	.uleb128 0x4
	.uleb128 0xb
	.uaword	.LLASF22
	.byte	0x5
	.byte	0x32
	.uaword	0x5d
	.byte	0x2
	.byte	0x23
	.uleb128 0x8
	.uleb128 0xb
	.uaword	.LLASF23
	.byte	0x5
	.byte	0x32
	.uaword	0x5d
	.byte	0x2
	.byte	0x23
	.uleb128 0xc
	.uleb128 0xb
	.uaword	.LLASF24
	.byte	0x5
	.byte	0x32
	.uaword	0x5d
	.byte	0x2
	.byte	0x23
	.uleb128 0x10
	.uleb128 0xe
	.asciz	"_x"
	.byte	0x5
	.byte	0x33
	.uaword	0x17b
	.byte	0x2
	.byte	0x23
	.uleb128 0x14
	.byte	0
	.uleb128 0xf
	.byte	0x4
	.uaword	0x116
	.uleb128 0x8
	.uaword	0x10b
	.uaword	0x18b
	.uleb128 0x9
	.uaword	0x64
	.byte	0
	.byte	0
	.uleb128 0xd
	.uaword	.LLASF26
	.byte	0x24
	.byte	0x5
	.byte	0x37
	.uaword	0x216
	.uleb128 0xb
	.uaword	.LLASF27
	.byte	0x5
	.byte	0x39
	.uaword	0x5d
	.byte	0x2
	.byte	0x23
	.uleb128 0
	.uleb128 0xb
	.uaword	.LLASF28
	.byte	0x5
	.byte	0x3a
	.uaword	0x5d
	.byte	0x2
	.byte	0x23
	.uleb128 0x4
	.uleb128 0xb
	.uaword	.LLASF29
	.byte	0x5
	.byte	0x3b
	.uaword	0x5d
	.byte	0x2
	.byte	0x23
	.uleb128 0x8
	.uleb128 0xb
	.uaword	.LLASF30
	.byte	0x5
	.byte	0x3c
	.uaword	0x5d
	.byte	0x2
	.byte	0x23
	.uleb128 0xc
	.uleb128 0xb
	.uaword	.LLASF31
	.byte	0x5
	.byte	0x3d
	.uaword	0x5d
	.byte	0x2
	.byte	0x23
	.uleb128 0x10
	.uleb128 0xb
	.uaword	.LLASF32
	.byte	0x5
	.byte	0x3e
	.uaword	0x5d
	.byte	0x2
	.byte	0x23
	.uleb128 0x14
	.uleb128 0xb
	.uaword	.LLASF33
	.byte	0x5
	.byte	0x3f
	.uaword	0x5d
	.byte	0x2
	.byte	0x23
	.uleb128 0x18
	.uleb128 0xb
	.uaword	.LLASF34
	.byte	0x5
	.byte	0x40
	.uaword	0x5d
	.byte	0x2
	.byte	0x23
	.uleb128 0x1c
	.uleb128 0xb
	.uaword	.LLASF35
	.byte	0x5
	.byte	0x41
	.uaword	0x5d
	.byte	0x2
	.byte	0x23
	.uleb128 0x20
	.byte	0
	.uleb128 0x10
	.uaword	.LLASF36
	.uahalf	0x108
	.byte	0x5
	.byte	0x4a
	.uaword	0x25f
	.uleb128 0xb
	.uaword	.LLASF37
	.byte	0x5
	.byte	0x4b
	.uaword	0x25f
	.byte	0x2
	.byte	0x23
	.uleb128 0
	.uleb128 0xb
	.uaword	.LLASF38
	.byte	0x5
	.byte	0x4c
	.uaword	0x25f
	.byte	0x3
	.byte	0x23
	.uleb128 0x80
	.uleb128 0xb
	.uaword	.LLASF39
	.byte	0x5
	.byte	0x4e
	.uaword	0x10b
	.byte	0x3
	.byte	0x23
	.uleb128 0x100
	.uleb128 0xb
	.uaword	.LLASF40
	.byte	0x5
	.byte	0x51
	.uaword	0x10b
	.byte	0x3
	.byte	0x23
	.uleb128 0x104
	.byte	0
	.uleb128 0x8
	.uaword	0x109
	.uaword	0x26f
	.uleb128 0x9
	.uaword	0x64
	.byte	0x1f
	.byte	0
	.uleb128 0xd
	.uaword	.LLASF41
	.byte	0x8c
	.byte	0x5
	.byte	0x55
	.uaword	0x2b5
	.uleb128 0xb
	.uaword	.LLASF21
	.byte	0x5
	.byte	0x56
	.uaword	0x2b5
	.byte	0x2
	.byte	0x23
	.uleb128 0
	.uleb128 0xb
	.uaword	.LLASF42
	.byte	0x5
	.byte	0x57
	.uaword	0x5d
	.byte	0x2
	.byte	0x23
	.uleb128 0x4
	.uleb128 0xb
	.uaword	.LLASF43
	.byte	0x5
	.byte	0x58
	.uaword	0x2bb
	.byte	0x2
	.byte	0x23
	.uleb128 0x8
	.uleb128 0xb
	.uaword	.LLASF44
	.byte	0x5
	.byte	0x59
	.uaword	0x2d3
	.byte	0x3
	.byte	0x23
	.uleb128 0x88
	.byte	0
	.uleb128 0xf
	.byte	0x4
	.uaword	0x26f
	.uleb128 0x8
	.uaword	0x2cb
	.uaword	0x2cb
	.uleb128 0x9
	.uaword	0x64
	.byte	0x1f
	.byte	0
	.uleb128 0xf
	.byte	0x4
	.uaword	0x2d1
	.uleb128 0x11
	.byte	0x1
	.uleb128 0xf
	.byte	0x4
	.uaword	0x216
	.uleb128 0xd
	.uaword	.LLASF45
	.byte	0x8
	.byte	0x5
	.byte	0x75
	.uaword	0x302
	.uleb128 0xb
	.uaword	.LLASF46
	.byte	0x5
	.byte	0x76
	.uaword	0x302
	.byte	0x2
	.byte	0x23
	.uleb128 0
	.uleb128 0xb
	.uaword	.LLASF47
	.byte	0x5
	.byte	0x77
	.uaword	0x5d
	.byte	0x2
	.byte	0x23
	.uleb128 0x4
	.byte	0
	.uleb128 0xf
	.byte	0x4
	.uaword	0x2c
	.uleb128 0xd
	.uaword	.LLASF48
	.byte	0x20
	.byte	0x5
	.byte	0x99
	.uaword	0x382
	.uleb128 0xe
	.asciz	"_p"
	.byte	0x5
	.byte	0x9a
	.uaword	0x302
	.byte	0x2
	.byte	0x23
	.uleb128 0
	.uleb128 0xe
	.asciz	"_r"
	.byte	0x5
	.byte	0x9b
	.uaword	0x5d
	.byte	0x2
	.byte	0x23
	.uleb128 0x4
	.uleb128 0xe
	.asciz	"_w"
	.byte	0x5
	.byte	0x9c
	.uaword	0x5d
	.byte	0x2
	.byte	0x23
	.uleb128 0x8
	.uleb128 0xb
	.uaword	.LLASF49
	.byte	0x5
	.byte	0x9d
	.uaword	0x33
	.byte	0x2
	.byte	0x23
	.uleb128 0xc
	.uleb128 0xb
	.uaword	.LLASF50
	.byte	0x5
	.byte	0x9e
	.uaword	0x33
	.byte	0x2
	.byte	0x23
	.uleb128 0xe
	.uleb128 0xe
	.asciz	"_bf"
	.byte	0x5
	.byte	0x9f
	.uaword	0x2d9
	.byte	0x2
	.byte	0x23
	.uleb128 0x10
	.uleb128 0xb
	.uaword	.LLASF51
	.byte	0x5
	.byte	0xa0
	.uaword	0x5d
	.byte	0x2
	.byte	0x23
	.uleb128 0x18
	.uleb128 0xb
	.uaword	.LLASF52
	.byte	0x5
	.byte	0xa2
	.uaword	0x4df
	.byte	0x2
	.byte	0x23
	.uleb128 0x1c
	.byte	0
	.uleb128 0x12
	.uaword	0x308
	.uleb128 0x13
	.uaword	.LLASF53
	.byte	0x60
	.byte	0x5
	.uahalf	0x174
	.uaword	0x4df
	.uleb128 0x14
	.uaword	.LLASF54
	.byte	0x5
	.uahalf	0x178
	.uaword	0x5d
	.byte	0x2
	.byte	0x23
	.uleb128 0
	.uleb128 0x14
	.uaword	.LLASF55
	.byte	0x5
	.uahalf	0x17d
	.uaword	0x753
	.byte	0x2
	.byte	0x23
	.uleb128 0x4
	.uleb128 0x14
	.uaword	.LLASF56
	.byte	0x5
	.uahalf	0x17d
	.uaword	0x753
	.byte	0x2
	.byte	0x23
	.uleb128 0x8
	.uleb128 0x14
	.uaword	.LLASF57
	.byte	0x5
	.uahalf	0x17d
	.uaword	0x753
	.byte	0x2
	.byte	0x23
	.uleb128 0xc
	.uleb128 0x14
	.uaword	.LLASF58
	.byte	0x5
	.uahalf	0x17f
	.uaword	0x5d
	.byte	0x2
	.byte	0x23
	.uleb128 0x10
	.uleb128 0x14
	.uaword	.LLASF59
	.byte	0x5
	.uahalf	0x181
	.uaword	0x663
	.byte	0x2
	.byte	0x23
	.uleb128 0x14
	.uleb128 0x14
	.uaword	.LLASF60
	.byte	0x5
	.uahalf	0x183
	.uaword	0x5d
	.byte	0x2
	.byte	0x23
	.uleb128 0x18
	.uleb128 0x14
	.uaword	.LLASF61
	.byte	0x5
	.uahalf	0x185
	.uaword	0x5d
	.byte	0x2
	.byte	0x23
	.uleb128 0x1c
	.uleb128 0x14
	.uaword	.LLASF62
	.byte	0x5
	.uahalf	0x186
	.uaword	0x8cc
	.byte	0x2
	.byte	0x23
	.uleb128 0x20
	.uleb128 0x15
	.asciz	"_mp"
	.byte	0x5
	.uahalf	0x188
	.uaword	0x8d2
	.byte	0x2
	.byte	0x23
	.uleb128 0x24
	.uleb128 0x14
	.uaword	.LLASF63
	.byte	0x5
	.uahalf	0x18a
	.uaword	0x8e4
	.byte	0x2
	.byte	0x23
	.uleb128 0x28
	.uleb128 0x14
	.uaword	.LLASF64
	.byte	0x5
	.uahalf	0x18c
	.uaword	0x5d
	.byte	0x2
	.byte	0x23
	.uleb128 0x2c
	.uleb128 0x14
	.uaword	.LLASF65
	.byte	0x5
	.uahalf	0x18f
	.uaword	0x5d
	.byte	0x2
	.byte	0x23
	.uleb128 0x30
	.uleb128 0x14
	.uaword	.LLASF66
	.byte	0x5
	.uahalf	0x190
	.uaword	0x663
	.byte	0x2
	.byte	0x23
	.uleb128 0x34
	.uleb128 0x14
	.uaword	.LLASF67
	.byte	0x5
	.uahalf	0x192
	.uaword	0x8ea
	.byte	0x2
	.byte	0x23
	.uleb128 0x38
	.uleb128 0x14
	.uaword	.LLASF68
	.byte	0x5
	.uahalf	0x193
	.uaword	0x8f0
	.byte	0x2
	.byte	0x23
	.uleb128 0x3c
	.uleb128 0x14
	.uaword	.LLASF69
	.byte	0x5
	.uahalf	0x194
	.uaword	0x663
	.byte	0x2
	.byte	0x23
	.uleb128 0x40
	.uleb128 0x14
	.uaword	.LLASF70
	.byte	0x5
	.uahalf	0x197
	.uaword	0x902
	.byte	0x2
	.byte	0x23
	.uleb128 0x44
	.uleb128 0x14
	.uaword	.LLASF71
	.byte	0x5
	.uahalf	0x19f
	.uaword	0x712
	.byte	0x2
	.byte	0x23
	.uleb128 0x48
	.uleb128 0x14
	.uaword	.LLASF72
	.byte	0x5
	.uahalf	0x1a0
	.uaword	0x753
	.byte	0x2
	.byte	0x23
	.uleb128 0x54
	.uleb128 0x14
	.uaword	.LLASF73
	.byte	0x5
	.uahalf	0x1a1
	.uaword	0x90e
	.byte	0x2
	.byte	0x23
	.uleb128 0x58
	.uleb128 0x14
	.uaword	.LLASF74
	.byte	0x5
	.uahalf	0x1a2
	.uaword	0x663
	.byte	0x2
	.byte	0x23
	.uleb128 0x5c
	.byte	0
	.uleb128 0xf
	.byte	0x4
	.uaword	0x387
	.uleb128 0x12
	.uaword	0x4df
	.uleb128 0xd
	.uaword	.LLASF75
	.byte	0x68
	.byte	0x5
	.byte	0xb5
	.uaword	0x644
	.uleb128 0xe
	.asciz	"_p"
	.byte	0x5
	.byte	0xb6
	.uaword	0x302
	.byte	0x2
	.byte	0x23
	.uleb128 0
	.uleb128 0xe
	.asciz	"_r"
	.byte	0x5
	.byte	0xb7
	.uaword	0x5d
	.byte	0x2
	.byte	0x23
	.uleb128 0x4
	.uleb128 0xe
	.asciz	"_w"
	.byte	0x5
	.byte	0xb8
	.uaword	0x5d
	.byte	0x2
	.byte	0x23
	.uleb128 0x8
	.uleb128 0xb
	.uaword	.LLASF49
	.byte	0x5
	.byte	0xb9
	.uaword	0x33
	.byte	0x2
	.byte	0x23
	.uleb128 0xc
	.uleb128 0xb
	.uaword	.LLASF50
	.byte	0x5
	.byte	0xba
	.uaword	0x33
	.byte	0x2
	.byte	0x23
	.uleb128 0xe
	.uleb128 0xe
	.asciz	"_bf"
	.byte	0x5
	.byte	0xbb
	.uaword	0x2d9
	.byte	0x2
	.byte	0x23
	.uleb128 0x10
	.uleb128 0xb
	.uaword	.LLASF51
	.byte	0x5
	.byte	0xbc
	.uaword	0x5d
	.byte	0x2
	.byte	0x23
	.uleb128 0x18
	.uleb128 0xb
	.uaword	.LLASF52
	.byte	0x5
	.byte	0xbf
	.uaword	0x4df
	.byte	0x2
	.byte	0x23
	.uleb128 0x1c
	.uleb128 0xb
	.uaword	.LLASF76
	.byte	0x5
	.byte	0xc3
	.uaword	0x109
	.byte	0x2
	.byte	0x23
	.uleb128 0x20
	.uleb128 0xb
	.uaword	.LLASF77
	.byte	0x5
	.byte	0xc5
	.uaword	0x675
	.byte	0x2
	.byte	0x23
	.uleb128 0x24
	.uleb128 0xb
	.uaword	.LLASF78
	.byte	0x5
	.byte	0xc7
	.uaword	0x6a0
	.byte	0x2
	.byte	0x23
	.uleb128 0x28
	.uleb128 0xb
	.uaword	.LLASF79
	.byte	0x5
	.byte	0xca
	.uaword	0x6c5
	.byte	0x2
	.byte	0x23
	.uleb128 0x2c
	.uleb128 0xb
	.uaword	.LLASF80
	.byte	0x5
	.byte	0xcb
	.uaword	0x6e0
	.byte	0x2
	.byte	0x23
	.uleb128 0x30
	.uleb128 0xe
	.asciz	"_ub"
	.byte	0x5
	.byte	0xce
	.uaword	0x2d9
	.byte	0x2
	.byte	0x23
	.uleb128 0x34
	.uleb128 0xe
	.asciz	"_up"
	.byte	0x5
	.byte	0xcf
	.uaword	0x302
	.byte	0x2
	.byte	0x23
	.uleb128 0x3c
	.uleb128 0xe
	.asciz	"_ur"
	.byte	0x5
	.byte	0xd0
	.uaword	0x5d
	.byte	0x2
	.byte	0x23
	.uleb128 0x40
	.uleb128 0xb
	.uaword	.LLASF81
	.byte	0x5
	.byte	0xd3
	.uaword	0x6e6
	.byte	0x2
	.byte	0x23
	.uleb128 0x44
	.uleb128 0xb
	.uaword	.LLASF82
	.byte	0x5
	.byte	0xd4
	.uaword	0x6f6
	.byte	0x2
	.byte	0x23
	.uleb128 0x47
	.uleb128 0xe
	.asciz	"_lb"
	.byte	0x5
	.byte	0xd7
	.uaword	0x2d9
	.byte	0x2
	.byte	0x23
	.uleb128 0x48
	.uleb128 0xb
	.uaword	.LLASF83
	.byte	0x5
	.byte	0xda
	.uaword	0x5d
	.byte	0x2
	.byte	0x23
	.uleb128 0x50
	.uleb128 0xb
	.uaword	.LLASF84
	.byte	0x5
	.byte	0xdb
	.uaword	0x7d
	.byte	0x2
	.byte	0x23
	.uleb128 0x54
	.uleb128 0xb
	.uaword	.LLASF85
	.byte	0x5
	.byte	0xe2
	.uaword	0xfe
	.byte	0x2
	.byte	0x23
	.uleb128 0x58
	.uleb128 0xb
	.uaword	.LLASF86
	.byte	0x5
	.byte	0xe4
	.uaword	0xf3
	.byte	0x2
	.byte	0x23
	.uleb128 0x5c
	.uleb128 0xb
	.uaword	.LLASF87
	.byte	0x5
	.byte	0xe5
	.uaword	0x5d
	.byte	0x2
	.byte	0x23
	.uleb128 0x64
	.byte	0
	.uleb128 0x16
	.byte	0x1
	.uaword	0x5d
	.uaword	0x663
	.uleb128 0x17
	.uaword	0x4df
	.uleb128 0x17
	.uaword	0x109
	.uleb128 0x17
	.uaword	0x663
	.uleb128 0x17
	.uaword	0x5d
	.byte	0
	.uleb128 0xf
	.byte	0x4
	.uaword	0x669
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.uaword	.LLASF88
	.uleb128 0x12
	.uaword	0x669
	.uleb128 0xf
	.byte	0x4
	.uaword	0x644
	.uleb128 0x16
	.byte	0x1
	.uaword	0x5d
	.uaword	0x69a
	.uleb128 0x17
	.uaword	0x4df
	.uleb128 0x17
	.uaword	0x109
	.uleb128 0x17
	.uaword	0x69a
	.uleb128 0x17
	.uaword	0x5d
	.byte	0
	.uleb128 0xf
	.byte	0x4
	.uaword	0x670
	.uleb128 0xf
	.byte	0x4
	.uaword	0x67b
	.uleb128 0x16
	.byte	0x1
	.uaword	0x88
	.uaword	0x6c5
	.uleb128 0x17
	.uaword	0x4df
	.uleb128 0x17
	.uaword	0x109
	.uleb128 0x17
	.uaword	0x88
	.uleb128 0x17
	.uaword	0x5d
	.byte	0
	.uleb128 0xf
	.byte	0x4
	.uaword	0x6a6
	.uleb128 0x16
	.byte	0x1
	.uaword	0x5d
	.uaword	0x6e0
	.uleb128 0x17
	.uaword	0x4df
	.uleb128 0x17
	.uaword	0x109
	.byte	0
	.uleb128 0xf
	.byte	0x4
	.uaword	0x6cb
	.uleb128 0x8
	.uaword	0x2c
	.uaword	0x6f6
	.uleb128 0x9
	.uaword	0x64
	.byte	0x2
	.byte	0
	.uleb128 0x8
	.uaword	0x2c
	.uaword	0x706
	.uleb128 0x9
	.uaword	0x64
	.byte	0
	.byte	0
	.uleb128 0x5
	.uaword	.LLASF89
	.byte	0x5
	.uahalf	0x11f
	.uaword	0x4ea
	.uleb128 0x13
	.uaword	.LLASF90
	.byte	0xc
	.byte	0x5
	.uahalf	0x123
	.uaword	0x74d
	.uleb128 0x14
	.uaword	.LLASF21
	.byte	0x5
	.uahalf	0x125
	.uaword	0x74d
	.byte	0x2
	.byte	0x23
	.uleb128 0
	.uleb128 0x14
	.uaword	.LLASF91
	.byte	0x5
	.uahalf	0x126
	.uaword	0x5d
	.byte	0x2
	.byte	0x23
	.uleb128 0x4
	.uleb128 0x14
	.uaword	.LLASF92
	.byte	0x5
	.uahalf	0x127
	.uaword	0x753
	.byte	0x2
	.byte	0x23
	.uleb128 0x8
	.byte	0
	.uleb128 0xf
	.byte	0x4
	.uaword	0x712
	.uleb128 0xf
	.byte	0x4
	.uaword	0x706
	.uleb128 0x13
	.uaword	.LLASF93
	.byte	0x18
	.byte	0x5
	.uahalf	0x13f
	.uaword	0x7a3
	.uleb128 0x14
	.uaword	.LLASF94
	.byte	0x5
	.uahalf	0x140
	.uaword	0x7a3
	.byte	0x2
	.byte	0x23
	.uleb128 0
	.uleb128 0x14
	.uaword	.LLASF95
	.byte	0x5
	.uahalf	0x141
	.uaword	0x7a3
	.byte	0x2
	.byte	0x23
	.uleb128 0x6
	.uleb128 0x14
	.uaword	.LLASF96
	.byte	0x5
	.uahalf	0x142
	.uaword	0x3a
	.byte	0x2
	.byte	0x23
	.uleb128 0xc
	.uleb128 0x14
	.uaword	.LLASF97
	.byte	0x5
	.uahalf	0x145
	.uaword	0x56
	.byte	0x2
	.byte	0x23
	.uleb128 0x10
	.byte	0
	.uleb128 0x8
	.uaword	0x3a
	.uaword	0x7b3
	.uleb128 0x9
	.uaword	0x64
	.byte	0x2
	.byte	0
	.uleb128 0x13
	.uaword	.LLASF98
	.byte	0x10
	.byte	0x5
	.uahalf	0x158
	.uaword	0x7fd
	.uleb128 0x14
	.uaword	.LLASF99
	.byte	0x5
	.uahalf	0x15b
	.uaword	0x175
	.byte	0x2
	.byte	0x23
	.uleb128 0
	.uleb128 0x14
	.uaword	.LLASF100
	.byte	0x5
	.uahalf	0x15c
	.uaword	0x5d
	.byte	0x2
	.byte	0x23
	.uleb128 0x4
	.uleb128 0x14
	.uaword	.LLASF101
	.byte	0x5
	.uahalf	0x15d
	.uaword	0x175
	.byte	0x2
	.byte	0x23
	.uleb128 0x8
	.uleb128 0x14
	.uaword	.LLASF102
	.byte	0x5
	.uahalf	0x15e
	.uaword	0x7fd
	.byte	0x2
	.byte	0x23
	.uleb128 0xc
	.byte	0
	.uleb128 0xf
	.byte	0x4
	.uaword	0x175
	.uleb128 0x13
	.uaword	.LLASF103
	.byte	0x50
	.byte	0x5
	.uahalf	0x162
	.uaword	0x8b6
	.uleb128 0x14
	.uaword	.LLASF104
	.byte	0x5
	.uahalf	0x165
	.uaword	0x663
	.byte	0x2
	.byte	0x23
	.uleb128 0
	.uleb128 0x14
	.uaword	.LLASF105
	.byte	0x5
	.uahalf	0x166
	.uaword	0xf3
	.byte	0x2
	.byte	0x23
	.uleb128 0x4
	.uleb128 0x14
	.uaword	.LLASF106
	.byte	0x5
	.uahalf	0x167
	.uaword	0xf3
	.byte	0x2
	.byte	0x23
	.uleb128 0xc
	.uleb128 0x14
	.uaword	.LLASF107
	.byte	0x5
	.uahalf	0x168
	.uaword	0xf3
	.byte	0x2
	.byte	0x23
	.uleb128 0x14
	.uleb128 0x14
	.uaword	.LLASF108
	.byte	0x5
	.uahalf	0x169
	.uaword	0x8b6
	.byte	0x2
	.byte	0x23
	.uleb128 0x1c
	.uleb128 0x14
	.uaword	.LLASF109
	.byte	0x5
	.uahalf	0x16a
	.uaword	0x5d
	.byte	0x2
	.byte	0x23
	.uleb128 0x24
	.uleb128 0x14
	.uaword	.LLASF110
	.byte	0x5
	.uahalf	0x16b
	.uaword	0xf3
	.byte	0x2
	.byte	0x23
	.uleb128 0x28
	.uleb128 0x14
	.uaword	.LLASF111
	.byte	0x5
	.uahalf	0x16c
	.uaword	0xf3
	.byte	0x2
	.byte	0x23
	.uleb128 0x30
	.uleb128 0x14
	.uaword	.LLASF112
	.byte	0x5
	.uahalf	0x16d
	.uaword	0xf3
	.byte	0x2
	.byte	0x23
	.uleb128 0x38
	.uleb128 0x14
	.uaword	.LLASF113
	.byte	0x5
	.uahalf	0x16e
	.uaword	0xf3
	.byte	0x2
	.byte	0x23
	.uleb128 0x40
	.uleb128 0x14
	.uaword	.LLASF114
	.byte	0x5
	.uahalf	0x16f
	.uaword	0xf3
	.byte	0x2
	.byte	0x23
	.uleb128 0x48
	.byte	0
	.uleb128 0x8
	.uaword	0x669
	.uaword	0x8c6
	.uleb128 0x9
	.uaword	0x64
	.byte	0x7
	.byte	0
	.uleb128 0x18
	.uaword	.LLASF125
	.byte	0x1
	.uleb128 0xf
	.byte	0x4
	.uaword	0x8c6
	.uleb128 0xf
	.byte	0x4
	.uaword	0x7b3
	.uleb128 0x19
	.byte	0x1
	.uaword	0x8e4
	.uleb128 0x17
	.uaword	0x4df
	.byte	0
	.uleb128 0xf
	.byte	0x4
	.uaword	0x8d8
	.uleb128 0xf
	.byte	0x4
	.uaword	0x759
	.uleb128 0xf
	.byte	0x4
	.uaword	0x18b
	.uleb128 0x19
	.byte	0x1
	.uaword	0x902
	.uleb128 0x17
	.uaword	0x5d
	.byte	0
	.uleb128 0xf
	.byte	0x4
	.uaword	0x908
	.uleb128 0xf
	.byte	0x4
	.uaword	0x8f6
	.uleb128 0xf
	.byte	0x4
	.uaword	0x803
	.uleb128 0x1a
	.uaword	.LLASF115
	.byte	0x5
	.uahalf	0x1a5
	.uaword	0x382
	.byte	0x1
	.byte	0x1
	.uleb128 0x1a
	.uaword	.LLASF116
	.byte	0x5
	.uahalf	0x1a6
	.uaword	0x382
	.byte	0x1
	.byte	0x1
	.uleb128 0x1a
	.uaword	.LLASF117
	.byte	0x5
	.uahalf	0x1a7
	.uaword	0x382
	.byte	0x1
	.byte	0x1
	.uleb128 0x1a
	.uaword	.LLASF118
	.byte	0x5
	.uahalf	0x2fe
	.uaword	0x4df
	.byte	0x1
	.byte	0x1
	.uleb128 0x1a
	.uaword	.LLASF119
	.byte	0x5
	.uahalf	0x2ff
	.uaword	0x4e5
	.byte	0x1
	.byte	0x1
	.uleb128 0x1a
	.uaword	.LLASF120
	.byte	0x5
	.uahalf	0x311
	.uaword	0x2b5
	.byte	0x1
	.byte	0x1
	.uleb128 0x1b
	.uaword	.LLASF121
	.byte	0x6
	.byte	0x63
	.uaword	0x663
	.byte	0x1
	.byte	0x1
	.uleb128 0x1c
	.byte	0x1
	.uaword	.LLASF126
	.byte	0x1
	.byte	0x6
	.uaword	0x5d
	.uaword	.LLFB1
	.uaword	.LLFE1
	.uaword	.LLLST0
	.uleb128 0x1d
	.asciz	"a"
	.byte	0x1
	.byte	0x8
	.uaword	0x5d
	.byte	0x2
	.byte	0x91
	.sleb128 -4
	.uleb128 0x1d
	.asciz	"b"
	.byte	0x1
	.byte	0x8
	.uaword	0x5d
	.byte	0x2
	.byte	0x91
	.sleb128 -8
	.uleb128 0x1d
	.asciz	"c"
	.byte	0x1
	.byte	0x8
	.uaword	0x5d
	.byte	0x2
	.byte	0x91
	.sleb128 -12
	.byte	0
	.byte	0
	.section	.debug_abbrev,"",@progbits
.LLdebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1b
	.uleb128 0xe
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x10
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0x17
	.byte	0x1
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0x13
	.byte	0x1
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xa
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xe
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xa
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0x5
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x11
	.uleb128 0x15
	.byte	0
	.uleb128 0x27
	.uleb128 0xc
	.byte	0
	.byte	0
	.uleb128 0x12
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x13
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x14
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xa
	.byte	0
	.byte	0
	.uleb128 0x15
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xa
	.byte	0
	.byte	0
	.uleb128 0x16
	.uleb128 0x15
	.byte	0x1
	.uleb128 0x27
	.uleb128 0xc
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x17
	.uleb128 0x5
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x18
	.uleb128 0x13
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3c
	.uleb128 0xc
	.byte	0
	.byte	0
	.uleb128 0x19
	.uleb128 0x15
	.byte	0x1
	.uleb128 0x27
	.uleb128 0xc
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1a
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x3c
	.uleb128 0xc
	.byte	0
	.byte	0
	.uleb128 0x1b
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x3c
	.uleb128 0xc
	.byte	0
	.byte	0
	.uleb128 0x1c
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x40
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0x1d
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0xa
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_loc,"",@progbits
.LLdebug_loc0:
.LLLST0:
	.uaword	.LLFB1-.LLtext0
	.uaword	.LLCFI0-.LLtext0
	.uahalf	0x2
	.byte	0x7e
	.sleb128 0
	.uaword	.LLCFI0-.LLtext0
	.uaword	.LLFE1-.LLtext0
	.uahalf	0x2
	.byte	0x8e
	.sleb128 0
	.uaword	0
	.uaword	0
	.section	.debug_aranges,"",@progbits
	.uaword	0x1c
	.uahalf	0x2
	.uaword	.LLdebug_info0
	.byte	0x4
	.byte	0
	.uahalf	0
	.uahalf	0
	.uaword	.LLtext0
	.uaword	.LLetext0-.LLtext0
	.uaword	0
	.uaword	0
	.section	.debug_line,"",@progbits
.LLdebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LLASF38:
	.asciz	"_dso_handle"
.LLASF47:
	.asciz	"_size"
.LLASF93:
	.asciz	"_rand48"
.LLASF59:
	.asciz	"_emergency"
.LLASF52:
	.asciz	"_data"
.LLASF113:
	.asciz	"_wcrtomb_state"
.LLASF114:
	.asciz	"_wcsrtombs_state"
.LLASF7:
	.asciz	"long long unsigned int"
.LLASF51:
	.asciz	"_lbfsize"
.LLASF125:
	.asciz	"__locale_t"
.LLASF111:
	.asciz	"_mbrtowc_state"
.LLASF106:
	.asciz	"_wctomb_state"
.LLASF27:
	.asciz	"__tm_sec"
.LLASF6:
	.asciz	"long long int"
.LLASF0:
	.asciz	"signed char"
.LLASF81:
	.asciz	"_ubuf"
.LLASF46:
	.asciz	"_base"
.LLASF29:
	.asciz	"__tm_hour"
.LLASF72:
	.asciz	"__sf"
.LLASF36:
	.asciz	"_on_exit_args"
.LLASF76:
	.asciz	"_cookie"
.LLASF71:
	.asciz	"__sglue"
.LLASF4:
	.asciz	"long int"
.LLASF98:
	.asciz	"_mprec"
.LLASF49:
	.asciz	"_flags"
.LLASF40:
	.asciz	"_is_cxa"
.LLASF55:
	.asciz	"_stdin"
.LLASF83:
	.asciz	"_blksize"
.LLASF66:
	.asciz	"_cvtbuf"
.LLASF84:
	.asciz	"_offset"
.LLASF112:
	.asciz	"_mbsrtowcs_state"
.LLASF110:
	.asciz	"_mbrlen_state"
.LLASF37:
	.asciz	"_fnargs"
.LLASF43:
	.asciz	"_fns"
.LLASF23:
	.asciz	"_sign"
.LLASF19:
	.asciz	"_flock_t"
.LLASF57:
	.asciz	"_stderr"
.LLASF25:
	.asciz	"_Bigint"
.LLASF64:
	.asciz	"_gamma_signgam"
.LLASF77:
	.asciz	"_read"
.LLASF100:
	.asciz	"_result_k"
.LLASF26:
	.asciz	"__tm"
.LLASF44:
	.asciz	"_on_exit_args_ptr"
.LLASF8:
	.asciz	"unsigned int"
.LLASF15:
	.asciz	"__wchb"
.LLASF56:
	.asciz	"_stdout"
.LLASF65:
	.asciz	"_cvtlen"
.LLASF5:
	.asciz	"long unsigned int"
.LLASF48:
	.asciz	"__sFILE_fake"
.LLASF91:
	.asciz	"_niobs"
.LLASF3:
	.asciz	"short unsigned int"
.LLASF74:
	.asciz	"_signal_buf"
.LLASF69:
	.asciz	"_asctime_buf"
.LLASF99:
	.asciz	"_result"
.LLASF14:
	.asciz	"__wch"
.LLASF13:
	.asciz	"wint_t"
.LLASF85:
	.asciz	"_lock"
.LLASF87:
	.asciz	"_flags2"
.LLASF78:
	.asciz	"_write"
.LLASF32:
	.asciz	"__tm_year"
.LLASF73:
	.asciz	"_misc"
.LLASF9:
	.asciz	"long double"
.LLASF115:
	.asciz	"__sf_fake_stdin"
.LLASF116:
	.asciz	"__sf_fake_stdout"
.LLASF31:
	.asciz	"__tm_mon"
.LLASF41:
	.asciz	"_atexit"
.LLASF121:
	.asciz	"suboptarg"
.LLASF60:
	.asciz	"__sdidinit"
.LLASF11:
	.asciz	"_off_t"
.LLASF102:
	.asciz	"_freelist"
.LLASF10:
	.asciz	"_LOCK_RECURSIVE_T"
.LLASF1:
	.asciz	"unsigned char"
.LLASF92:
	.asciz	"_iobs"
.LLASF2:
	.asciz	"short int"
.LLASF34:
	.asciz	"__tm_yday"
.LLASF45:
	.asciz	"__sbuf"
.LLASF89:
	.asciz	"__FILE"
.LLASF18:
	.asciz	"_mbstate_t"
.LLASF75:
	.asciz	"__sFILE"
.LLASF86:
	.asciz	"_mbstate"
.LLASF97:
	.asciz	"_rand_next"
.LLASF105:
	.asciz	"_mblen_state"
.LLASF58:
	.asciz	"_inc"
.LLASF42:
	.asciz	"_ind"
.LLASF62:
	.asciz	"_locale"
.LLASF63:
	.asciz	"__cleanup"
.LLASF61:
	.asciz	"_unspecified_locale_info"
.LLASF22:
	.asciz	"_maxwds"
.LLASF53:
	.asciz	"_reent"
.LLASF94:
	.asciz	"_seed"
.LLASF16:
	.asciz	"__count"
.LLASF17:
	.asciz	"__value"
.LLASF79:
	.asciz	"_seek"
.LLASF118:
	.asciz	"_impure_ptr"
.LLASF12:
	.asciz	"_fpos_t"
.LLASF122:
	.asciz	"GNU C11 7.2.0 -msoft-float -mcpu=v8 -g -O0"
.LLASF54:
	.asciz	"_errno"
.LLASF88:
	.asciz	"char"
.LLASF28:
	.asciz	"__tm_min"
.LLASF120:
	.asciz	"_global_atexit"
.LLASF95:
	.asciz	"_mult"
.LLASF21:
	.asciz	"_next"
.LLASF104:
	.asciz	"_strtok_last"
.LLASF39:
	.asciz	"_fntypes"
.LLASF103:
	.asciz	"_misc_reent"
.LLASF96:
	.asciz	"_add"
.LLASF20:
	.asciz	"__ULong"
.LLASF109:
	.asciz	"_getdate_err"
.LLASF123:
	.asciz	"simd_test.c"
.LLASF119:
	.asciz	"_global_impure_ptr"
.LLASF50:
	.asciz	"_file"
.LLASF24:
	.asciz	"_wds"
.LLASF33:
	.asciz	"__tm_wday"
.LLASF90:
	.asciz	"_glue"
.LLASF108:
	.asciz	"_l64a_buf"
.LLASF70:
	.asciz	"_sig_func"
.LLASF82:
	.asciz	"_nbuf"
.LLASF124:
	.asciz	"/home/march/pd_project/grlib/designs/leon3mp/tests"
.LLASF35:
	.asciz	"__tm_isdst"
.LLASF68:
	.asciz	"_localtime_buf"
.LLASF80:
	.asciz	"_close"
.LLASF117:
	.asciz	"__sf_fake_stderr"
.LLASF67:
	.asciz	"_r48"
.LLASF107:
	.asciz	"_mbtowc_state"
.LLASF101:
	.asciz	"_p5s"
.LLASF126:
	.asciz	"main"
.LLASF30:
	.asciz	"__tm_mday"
	.ident	"GCC: (bcc-v2.0.7) 7.2.0"
