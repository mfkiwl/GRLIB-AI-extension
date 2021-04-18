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
    //test add
    __asm__("ld [%fp + -4], %g1");
    __asm__("add_ %g1, 1, %g1");
    __asm__("st %g1, [ %fp + -8 ]");
    //add a b 
    printf("add +1: c=%#010x, expected result 0x02030405\n", c);

    //test sadd
    a=0x7f7e8000;
    __asm__("ld [%fp + -4], %g1");
    __asm__("sadd_ %g1, 1, %g1");
    __asm__("st %g1, [ %fp + -8 ]");
    printf("sadd+1: c=%#010x, expected result 0x7f7f8101\n", c);

    //test sub
    a=0x01020304;
    __asm__("ld [%fp + -4], %g1");
    __asm__("sub_ %g1, 1, %g1");
    __asm__("st %g1, [ %fp + -8 ]");
    printf("sub-1: c=%#010x, expected result 0x00010203\n", c);
    
    //test ssub
    a=0x80817f00;
    __asm__("ld [%fp + -4], %g1");
    __asm__("ssub_ %g1, 1, %g1");
    __asm__("st %g1, [ %fp + -8 ]");
    printf("ssub-1: c=%#010x, expected result 0x80807eff\n", c);


    puts("END OF TEST");
}
