XCC=sparc-gaisler-elf-gcc #$(XINC)
XCFLAGS=-O2 -g -msoft-float -mcpu=v8 -fno-inline

systest: 
	cp systest.srec $(CURRENT_DIR)/test.srec

hello: hello.c
	$(XCC) $(XCFLAGS) hello.c -o hello.exe
	sparc-gaisler-elf-objcopy -O srec --gap-fill 0 hello.exe hello.srec
	cp hello.srec $(CURRENT_DIR)/test.srec

clean:
	rm -f *.exe *.o *.dump hello.srec
