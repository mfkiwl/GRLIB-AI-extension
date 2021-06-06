XCC=sparc-gaisler-elf-gcc #$(XINC)
XCFLAGS0=-O0 -g -msoft-float -mcpu=v8
XCFLAGS=-O2 -g -msoft-float -mcpu=v8 -fno-inline

%:
	$(XCC) $(XCFLAGS) -c $@.c
	$(XCC) $(XCFLAGS) $@.o -o $@.exe 
	sparc-gaisler-elf-objcopy -O srec --gap-fill 0 $@.exe $@.srec
	cp $@.srec $(CURRENT_DIR)/test.srec
	sparc-gaisler-elf-objdump -d $@.o > $@.dump

clean:
	rm -f *.exe *.o *.dump *.srec
