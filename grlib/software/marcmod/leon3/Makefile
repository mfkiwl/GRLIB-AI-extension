#XINC=-I../../../software/leon3 -I../../../software/l2c
XCC=sparc-gaisler-elf-gcc #$(XINC)
XCFLAGS=-O2 -g -msoft-float -mcpu=v8 -fno-inline
XCFLAGS0=-O0 -g -msoft-float -mcpu=v8

#include leon3_tests/Makefile
systest hello:
	$(MAKE) -C leon3_tests $@

simd_%:
	$(MAKE) -C module_tests $@

mat_mu% binomi%:
	$(MAKE) -C matrix_multiplication $@

gray% filt%:
	$(MAKE) -C image_manipulation $@

clean:
	$(MAKE) -C leon3_tests $@
	$(MAKE) -C module_tests $@
	$(MAKE) -C matrix_multiplication $@
	$(MAKE) -C image_manipulation $@




