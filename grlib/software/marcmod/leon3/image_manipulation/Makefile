XCC=sparc-gaisler-elf-gcc #$(XINC)
XCFLAGS=-O2 -g -msoft-float -mcpu=v8 -fno-inline
XCFLAGS0=-O0 -g -msoft-float -mcpu=v8

grayscale: grayscale.c arrays.h image256.h image32.h
	$(XCC) $(XCFLAGS) -D N=$(par1) -c $<
	$(XCC) $(XCFLAGS) grayscale.o -o grayscale.exe 
	sparc-gaisler-elf-objcopy -O srec --gap-fill 0 grayscale.exe grayscale.srec
	cp grayscale.srec $(CURRENT_DIR)/test.srec
	sparc-gaisler-elf-objdump -d grayscale.o > grayscale.dump

grayscale_simd: grayscale_simd.c arrays.h image256.h image32.h
	$(XCC) $(XCFLAGS) -D N=$(par1) -c $<
	$(XCC) $(XCFLAGS) grayscale_simd.o -o grayscale_simd.exe 
	sparc-gaisler-elf-objcopy -O srec --gap-fill 0 grayscale_simd.exe grayscale_simd.srec
	cp grayscale_simd.srec $(CURRENT_DIR)/test.srec
	sparc-gaisler-elf-objdump -d grayscale_simd.o > grayscale_simd.dump

clean:
	rm -f *.exe *.o *.dump *.srec
