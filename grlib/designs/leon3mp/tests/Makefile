#XINC=-I../../../software/leon3 -I../../../software/l2c
XCC=sparc-gaisler-elf-gcc #$(XINC)
XCFLAGS=-O2 -g -msoft-float -mcpu=v8
XCFLAGS0=-O0 -g -msoft-float -mcpu=v8
#XLDFLAGS=-L./lib3tests.a -qnoambapp

%.o: %.c
	$(XCC) $(XCFLAGS) -c $<

%.o: %.S
	$(XCC) $(XCFLAGS) -c $<

bin_change:
	g++ -o bin_change bin_change.cc
make.x:
	g++ -o make.x make_simd_op.cc
systest: 
	cp systest.srec test.srec

hello: hello.o
	$(XCC) $(XCFLAGS) hello.o $(XLDFLAGS) -o hello.exe
	sparc-gaisler-elf-objcopy -O srec --gap-fill 0 hello.exe hello.srec
	cp hello.srec test.srec

simd_test: simd_test.c bin_change
	$(XCC) $(XCFLAGS0) -c simd_test.c
	$(XCC) $(XCFLAGS0) simd_test.o $(XLDFLAGS) -o simd_test.exe
	sparc-gaisler-elf-objcopy -O srec --gap-fill 0 simd_test.exe tmp.simd_test.srec
	./bin_change tmp.simd_test.srec simd_test.list simd_test.srec 83288001
	cp simd_test.srec test.srec
	sparc-gaisler-elf-objdump -d simd_test.o > simd_test.dump
	

mat_mul: mat_mul.o
	$(XCC) $(XCFLAGS) mat_mul.o $(XLDFLAGS)-o mat_mul.exe
	sparc-gaisler-elf-objcopy -O srec --gap-fill 0 mat_mul.exe mat_mul.srec
	cp mat_mul.srec test.srec

clean:
	rm -f *.exe *.o *.dump bin_change make.x
