#XINC=-I../../../software/leon3 -I../../../software/l2c
XCC=sparc-gaisler-elf-gcc #$(XINC)
XCFLAGS=-O2 -g -msoft-float -mcpu=v8
XCFLAGS0=-O0 -g -msoft-float -mcpu=v8
#XLDFLAGS=-L./lib3tests.a -qnoambapp

%.o: %.c
	$(XCC) $(XCFLAGS) -c $<

%.o: %.S
	$(XCC) $(XCFLAGS) -c $<

systest: 
	cp systest.srec test.srec

hello: hello.o
	$(XCC) $(XCFLAGS) hello.o $(XLDFLAGS) -o hello.exe
	sparc-gaisler-elf-objcopy -O srec --gap-fill 0 hello.exe hello.srec
	cp hello.srec test.srec

simd_test: simd_test.c
	$(XCC) $(XCFLAGS0) -c simd_test.c
	$(XCC) $(XCFLAGS0) simd_test.o $(XLDFLAGS) -o simd_test.exe
	sparc-gaisler-elf-objcopy -O srec --gap-fill 0 simd_test.exe simd_test.srec
	cp simd_test.srec test.srec

mat_mul: mat_mul.o
	$(XCC) $(XCFLAGS) mat_mul.o $(XLDFLAGS)-o mat_mul.exe
	sparc-gaisler-elf-objcopy -O srec --gap-fill 0 mat_mul.exe mat_mul.srec
	cp mat_mul.srec test.srec

clean:
	rm -f *.exe *.o
