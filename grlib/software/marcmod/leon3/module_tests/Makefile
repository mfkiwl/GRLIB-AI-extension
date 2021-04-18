XCC=sparc-gaisler-elf-gcc #$(XINC)
XCFLAGS0=-O0 -g -msoft-float -mcpu=v8
XCFLAGS=-O2 -g -msoft-float -mcpu=v8 -fno-inline

simd_test: simd_test.c 
	$(XCC) $(XCFLAGS0) -c simd_test.c
	$(XCC) $(XCFLAGS0) simd_test.o -o simd_test.exe
	sparc-gaisler-elf-objcopy -O srec --gap-fill 0 simd_test.exe simd_test.srec
	cp simd_test.srec $(CURRENT_DIR)/test.srec
	sparc-gaisler-elf-objdump -d simd_test.o > simd_test.dump

simd_swizling: simd_swizling.c 
	$(XCC) $(XCFLAGS0) -c simd_swizling.c
	$(XCC) $(XCFLAGS0) simd_swizling.o -o simd_swizling.exe
	sparc-gaisler-elf-objcopy -O srec --gap-fill 0 simd_swizling.exe simd_swizling.srec
	cp simd_swizling.srec $(CURRENT_DIR)/test.srec
	sparc-gaisler-elf-objdump -d simd_swizling.o > simd_swizling.dump

simd_mask: simd_mask_test.c
	$(XCC) $(XCFLAGS0) -c simd_mask_test.c
	$(XCC) $(XCFLAGS0) simd_mask_test.o -o simd_mask_test.exe
	sparc-gaisler-elf-objcopy -O srec --gap-fill 0 simd_mask_test.exe simd_mask_test.srec
	cp simd_mask_test.srec $(CURRENT_DIR)/test.srec
	sparc-gaisler-elf-objdump -d simd_mask_test.o > simd_mask_test.dump

simd_imm: simd_imm.c
	$(XCC) $(XCFLAGS0) -c simd_imm.c
	$(XCC) $(XCFLAGS0) simd_imm.o -o simd_imm.exe
	sparc-gaisler-elf-objcopy -O srec --gap-fill 0 simd_imm.exe simd_imm.srec
	cp simd_imm.srec $(CURRENT_DIR)/test.srec
	sparc-gaisler-elf-objdump -d simd_imm.o > simd_imm.dump

clean:
	rm -f *.exe *.o *.dump *.srec
