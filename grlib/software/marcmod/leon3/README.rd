Directory containing the testing utilities for the leon3mp design
The executed program, must be found in test.srec file in the .srec format
A makefile is provided with the commands to generate this srec file
execute "make _test_name" to generate all the necessary files

To use instructions not included in the compiler the bin_change and make_simd_op 
programs are included. Use make_sim_op (whose executable is make.x) to 
generate the hex codification for the simd instructions.
--TODO-- allow input to be operation name

Include a list of all the new instructions, just the ones not included in the 
compiler, in the corresponding order. This list must be in _test_name.list

When calling bin_change pass this list together with the output file, usually
test.srec, and the dummy instruction used in the C code to compile.

For existing test all this mechanisms are included when executing "make _test_name"

