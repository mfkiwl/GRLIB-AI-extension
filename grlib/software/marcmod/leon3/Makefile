#XINC=-I../../../software/leon3 -I../../../software/l2c
XCC=sparc-gaisler-elf-gcc #$(XINC)
XCFLAGS=-O2 -g -msoft-float -mcpu=v8 -fno-inline
XCFLAGS0=-O0 -g -msoft-float -mcpu=v8

%.o: %.c
	$(XCC) $(XCFLAGS) -c $<

%.o: %.S
	$(XCC) $(XCFLAGS) -c $<

bin_change:
	g++ -o bin_change bin_change.cc
make.x:
	g++ -o make.x make_simd_op.cc
systest: 
	cp systest.srec $(CURRENT_DIR)/test.srec

hello: hello.o
	$(XCC) $(XCFLAGS) hello.o -o hello.exe
	sparc-gaisler-elf-objcopy -O srec --gap-fill 0 hello.exe hello.srec
	cp hello.srec $(CURRENT_DIR)/test.srec
	sparc-gaisler-elf-objdump -d hello.o > hello.dump

simd_test: simd_test.c bin_change
	$(XCC) $(XCFLAGS0) -c simd_test.c
	$(XCC) $(XCFLAGS0) simd_test.o -o simd_test.exe
	sparc-gaisler-elf-objcopy -O srec --gap-fill 0 simd_test.exe tmp.simd_test.srec
	./bin_change tmp.simd_test.srec simd_test.list simd_test.srec 83288001
	cp simd_test.srec $(CURRENT_DIR)/test.srec
	sparc-gaisler-elf-objdump -d simd_test.o > simd_test.dump

simd_swizling: simd_swizling.c bin_change
	$(XCC) $(XCFLAGS0) -c simd_swizling.c
	$(XCC) $(XCFLAGS0) simd_swizling.o -o simd_swizling.exe
	sparc-gaisler-elf-objcopy -O srec --gap-fill 0 simd_swizling.exe tmp.simd_swizling.srec
	./bin_change tmp.simd_swizling.srec simd_swizling.list simd_swizling.srec 83288001
	cp simd_swizling.srec $(CURRENT_DIR)/test.srec
	sparc-gaisler-elf-objdump -d simd_swizling.o > simd_swizling.dump

simd_imm: simd_imm.c bin_change
	$(XCC) $(XCFLAGS0) -c simd_imm.c
	$(XCC) $(XCFLAGS0) simd_imm.o -o simd_imm.exe
	sparc-gaisler-elf-objcopy -O srec --gap-fill 0 simd_imm.exe tmp.simd_imm.srec
	./bin_change tmp.simd_imm.srec simd_imm.list simd_imm.srec 83288001
	cp simd_imm.srec $(CURRENT_DIR)/test.srec
	sparc-gaisler-elf-objdump -d simd_imm.o > simd_imm.dump

simd_mask: simd_mask_test.c bin_change
	$(XCC) $(XCFLAGS0) -c simd_mask_test.c
	$(XCC) $(XCFLAGS0) simd_mask_test.o -o simd_mask_test.exe
	sparc-gaisler-elf-objcopy -O srec --gap-fill 0 simd_mask_test.exe tmp.simd_mask_test.srec
	./bin_change tmp.simd_mask_test.srec simd_mask_test.list simd_mask_test.srec 83288001
	cp simd_mask_test.srec $(CURRENT_DIR)/test.srec
	sparc-gaisler-elf-objdump -d simd_mask_test.o > simd_mask_test.dump
	

mat_mul: mat_mul.c
	$(XCC) $(XCFLAGS) -D N=$(par1) -c $<
	$(XCC) $(XCFLAGS) mat_mul.o -o mat_mul.exe 
	sparc-gaisler-elf-objcopy -O srec --gap-fill 0 mat_mul.exe mat_mul.srec
	cp mat_mul.srec $(CURRENT_DIR)/test.srec
	sparc-gaisler-elf-objdump -d mat_mul.o > mat_mul.dump

grayscale: grayscale.c arrays.h image256.h
	$(XCC) $(XCFLAGS) -D N=$(par1) -c $<
	$(XCC) $(XCFLAGS) grayscale.o -o grayscale.exe 
	sparc-gaisler-elf-objcopy -O srec --gap-fill 0 grayscale.exe grayscale.srec
	cp grayscale.srec $(CURRENT_DIR)/test.srec
	sparc-gaisler-elf-objdump -d grayscale.o > grayscale.dump

grayscale_simd: grayscale_simd.c arrays.h image256.h
	$(XCC) $(XCFLAGS) -D N=$(par1) -c $<
	$(XCC) $(XCFLAGS) grayscale_simd.o -o grayscale_simd.exe 
	sparc-gaisler-elf-objcopy -O srec --gap-fill 0 grayscale_simd.exe tmp.grayscale_simd.srec
	./bin_change tmp.grayscale_simd.srec grayscale_simd.list grayscale_simd.srec 83320001
	cp grayscale_simd.srec $(CURRENT_DIR)/test.srec
	sparc-gaisler-elf-objdump -d grayscale_simd.o > grayscale_simd.dump

mat_mul_int: mat_mul_int.c
	$(XCC) $(XCFLAGS) -D N=$(par1) -c $<
	$(XCC) $(XCFLAGS) mat_mul_int.o -o mat_mul_int.exe 
	sparc-gaisler-elf-objcopy -O srec --gap-fill 0 mat_mul_int.exe mat_mul_int.srec
	cp mat_mul_int.srec $(CURRENT_DIR)/test.srec
	sparc-gaisler-elf-objdump -d mat_mul_int.o > mat_mul_int.dump

mat_mul_simd: mat_mul_simd.c bin_change
	$(XCC) $(XCFLAGS) -D N=$(par1) -c mat_mul_simd.c
	$(XCC) $(XCFLAGS) mat_mul_simd.o -o mat_mul_simd.exe
	sparc-gaisler-elf-objcopy -O srec --gap-fill 0 mat_mul_simd.exe tmp.mat_mul_simd.srec
	./bin_change tmp.mat_mul_simd.srec mat_mul_simd.list tmp2.mat_mul_simd.srec 925A0009
	./bin_change tmp2.mat_mul_simd.srec mat_mul_simd32.list3 mat_mul_simd.srec 92020009
	cp mat_mul_simd.srec $(CURRENT_DIR)/test.srec
	sparc-gaisler-elf-objdump -d mat_mul_simd.o > mat_mul_simd.dump
	
mat_mul_simd4: mat_mul_simd4.o bin_change
	$(XCC) $(XCFLAGS) mat_mul_simd4.o -o mat_mul_simd4.exe
	sparc-gaisler-elf-objcopy -O srec --gap-fill 0 mat_mul_simd4.exe tmp.mat_mul_simd4.srec
	./bin_change tmp.mat_mul_simd4.srec mat_mul_simd4.list mat_mul_simd4.srec 925A0009
	cp mat_mul_simd4.srec $(CURRENT_DIR)/test.srec
	sparc-gaisler-elf-objdump -d mat_mul_simd4.o > mat_mul_simd4.dump

mat_mul_simd32: mat_mul_simd32.o bin_change
	$(XCC) $(XCFLAGS) mat_mul_simd32.o -o mat_mul_simd32.exe
	sparc-gaisler-elf-objcopy -O srec --gap-fill 0 mat_mul_simd32.exe tmp.mat_mul_simd32.srec
	./bin_change tmp.mat_mul_simd32.srec mat_mul_simd32.list tmp2.mat_mul_simd32.srec 925A0009
	./bin_change tmp2.mat_mul_simd32.srec mat_mul_simd32.list2 tmp3.mat_mul_simd32.srec 84784001
	./bin_change tmp3.mat_mul_simd32.srec mat_mul_simd32.list3 mat_mul_simd32.srec 92020009
	cp mat_mul_simd32.srec $(CURRENT_DIR)/test.srec
	sparc-gaisler-elf-objdump -d mat_mul_simd32.o > mat_mul_simd32.dump

clean:
	rm -f *.exe *.o *.dump bin_change make.x tmp*.*
