XCC=sparc-gaisler-elf-gcc #$(XINC)
XCFLAGS=-O2 -g -msoft-float -mcpu=v8 -fno-inline

mat_mul: mat_mul.c
	$(XCC) $(XCFLAGS) -D N=$(par1) -c $<
	$(XCC) $(XCFLAGS) mat_mul.o -o mat_mul.exe 
	sparc-gaisler-elf-objcopy -O srec --gap-fill 0 mat_mul.exe mat_mul.srec
	cp mat_mul.srec $(CURRENT_DIR)/test.srec
	sparc-gaisler-elf-objdump -d mat_mul.o > mat_mul.dump

mat_mul_int: mat_mul_int.c
	$(XCC) $(XCFLAGS) -D N=$(par1) -c $<
	$(XCC) $(XCFLAGS) mat_mul_int.o -o mat_mul_int.exe 
	sparc-gaisler-elf-objcopy -O srec --gap-fill 0 mat_mul_int.exe mat_mul_int.srec
	cp mat_mul_int.srec $(CURRENT_DIR)/test.srec
	sparc-gaisler-elf-objdump -d mat_mul_int.o > mat_mul_int.dump

mat_mul_simd: mat_mul_simd.c 
	$(XCC) $(XCFLAGS) -D N=$(par1) -c mat_mul_simd.c
	$(XCC) $(XCFLAGS) mat_mul_simd.o -o mat_mul_simd.exe
	sparc-gaisler-elf-objcopy -O srec --gap-fill 0 mat_mul_simd.exe mat_mul_simd.srec
	cp mat_mul_simd.srec $(CURRENT_DIR)/test.srec
	sparc-gaisler-elf-objdump -d mat_mul_simd.o > mat_mul_simd.dump
	
mat_mul_simd4: mat_mul_simd4.c 
	$(XCC) $(XCFLAGS) -c mat_mul_simd4.c
	$(XCC) $(XCFLAGS) mat_mul_simd4.o -o mat_mul_simd4.exe
	sparc-gaisler-elf-objcopy -O srec --gap-fill 0 mat_mul_simd4.exe mat_mul_simd4.srec
	cp mat_mul_simd4.srec $(CURRENT_DIR)/test.srec
	sparc-gaisler-elf-objdump -d mat_mul_simd4.o > mat_mul_simd4.dump

mat_mul_simd32: mat_mul_simd32.c 
	$(XCC) $(XCFLAGS) -c mat_mul_simd32.c
	$(XCC) $(XCFLAGS) mat_mul_simd32.o -o mat_mul_simd32.exe
	sparc-gaisler-elf-objcopy -O srec --gap-fill 0 mat_mul_simd32.exe mat_mul_simd32.srec
	cp mat_mul_simd32.srec $(CURRENT_DIR)/test.srec
	sparc-gaisler-elf-objdump -d mat_mul_simd32.o > mat_mul_simd32.dump

clean:
	rm -f *.exe *.o *.dump *.srec
