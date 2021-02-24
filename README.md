# GRLIB AI extension

## Project description 
In this project, wich corresponds to my master's thesis I will modify the LEON3 and NOEL-V processors to have additional AI processing. The first modification implemented is the addition of a SIMD module with support for extra instructions such as saturated ones. The module is currently implemented in the LEON3 and soon will be in the NOEL-V.

The SIMD module, operates over the integer unit registers (SIMD within a register, aka SWAR) and has two stages. In the first stage both input operands are operated against each other at byte granularity, the result is passed to the second stage where reduction operations are implemented. Additionally a mask vector can restrict the bytes to be computed in the first stage. 

## File organization
In the current repository only a subset of the provided designs in the GRLIB are included, the only one which has been tested is the **leon3mp** (GRLIB/designs/leon3mp). Under this design a tests directory includes different tests for the validation of the module plus some programs to generate the output.

The SIMD module and all future additions is found under GRLIB/libs/marcmod, although some modifications, identified in the file with *marcmod* are also found in GRLIB/libs/gaisler/leon3v3, specially the iu3.vhd file.

## Licence
The work is released under GPL license according to original files which can be found in: https://www.gaisler.com/index.php/downloads/leongrlib
