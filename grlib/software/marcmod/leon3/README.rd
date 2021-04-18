Directory containing the testing utilities for the leon3 design
The executed program, must be found in test.srec file in the .srec format
A makefile is provided with the commands to generate this srec file
execute "make _test_name" to generate all the necessary files

All tests are grouped in directories with similar testing goals:

module_tests/ -> Contains tests to verify the correct behaviour of the 
                 module.
matrix_multiplication/ -> contains tests with different aproaches for
                          matrix multiplication, both including the 
                          use of the AI module and not.

image_manipulation/ -> Tests regarding the manipulation of image files 
                       also included tests with no use of the module for
                       performance comparison.
