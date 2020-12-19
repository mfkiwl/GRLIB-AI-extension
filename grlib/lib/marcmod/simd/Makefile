default: build sim 

build:
	mkdir -p gnu
	mkdir -p gnu/grlib
	ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../grlib/stdlib/version.vhd
	ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../grlib/stdlib/config_types.vhd 
	ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../grlib/stdlib/config.vhd 
	ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../grlib/stdlib/stdlib.vhd 
	ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../grlib/stdlib/stdio.vhd 
	ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../grlib/stdlib/testlib.vhd 
	mkdir -p gnu/marcmod
	ghdl -i --mb-comments --workdir=gnu/marcmod --work=marcmod -Pgnu -Pgnu/grlib -Pgnu/marcmod ../../marcmod/simd/simdmod.vhd 
	ghdl -i --mb-comments --workdir=gnu/marcmod --work=marcmod -Pgnu -Pgnu/grlib -Pgnu/marcmod ../../marcmod/simd/simd.vhd 
	mkdir -p gnu/work
	ghdl -i --mb-comments --workdir=gnu/work --work=work -Pgnu -Pgnu/grlib -Pgnu/marcmod -Pgnu/work simd_test.vhd
	ghdl -m -fexplicit --ieee=synopsys --mb-comments -O2 --workdir=gnu/work --work=work -Pgnu -Pgnu/grlib -Pgnu/marcmod -Pgnu/work simd_test

sim:
	./simd_test --wave=simd.ghw --assert-level=error


view:
	gtkwave simd.ghw &

clean:
	rm -f *.o *.ghw *.cf 
	rm -rf gnu/
    
