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
	$(XCC) $(XCFLAGS) -D N=$(par1) -ffixed-l0 -c $< 
	$(XCC) $(XCFLAGS) grayscale_simd.o -o grayscale_simd.exe 
	sparc-gaisler-elf-objcopy -O srec --gap-fill 0 grayscale_simd.exe grayscale_simd.srec
	cp grayscale_simd.srec $(CURRENT_DIR)/test.srec
	sparc-gaisler-elf-objdump -d grayscale_simd.o > grayscale_simd.dump

filter: filter.c arrays.h image256gray.h
	$(XCC) $(XCFLAGS) -D N=$(par1) -c $<
	$(XCC) $(XCFLAGS) filter.o -o filter.exe 
	sparc-gaisler-elf-objcopy -O srec --gap-fill 0 filter.exe filter.srec
	cp filter.srec $(CURRENT_DIR)/test.srec
	sparc-gaisler-elf-objdump -d filter.o > filter.dump

filter_simd: filter_simd.c arrays.h image256gray.h
	$(XCC) $(XCFLAGS) -D N=$(par1) -c $<
	$(XCC) $(XCFLAGS) filter_simd.o -o filter_simd.exe 
	sparc-gaisler-elf-objcopy -O srec --gap-fill 0 filter_simd.exe filter_simd.srec
	cp filter_simd.srec $(CURRENT_DIR)/test.srec
	sparc-gaisler-elf-objdump -d filter_simd.o > filter_simd.dump

clean:
	rm -f *.exe *.o *.dump *.srec
