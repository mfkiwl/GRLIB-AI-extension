#include <stdio.h>
#include <string.h>
#include <stdlib.h>
//This is a simple test, since the compiler support is not provided 
//It is necessary to modify the srec file by hand
int main()
{
    int a,b,c;
    
    //test nop
    a = 0x01020304;
    b = 0x00010203;

    //test add
    __asm__("ld [%fp + -4], %g2");
    __asm__("ld [%fp + -8], %g1");
    __asm__("sll %g2, %g1, %g1");
    __asm__("sll %g2, %g1, %g1");
    __asm__("st %g1, [ %fp + -12 ]");
    //add a b 
    printf("add Awzwz Bxyyx: c=%#010x, expected result 0x04040305 mask 1111\n", c);

    puts("END OF TEST");
}
