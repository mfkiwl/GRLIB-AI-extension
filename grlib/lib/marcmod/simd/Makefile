default: 
	./ghdl.txt

build:
	ghdl -a simd_test.vhd simd.vhd
	ghdl -e simd_test

sim:
	ghdl -r simd_test --vcd=simd.vcd --assert-level=note


view:
	gtkwave simd.vcd &

clean:
	rm -f *.o *.vcd *.cf
    
