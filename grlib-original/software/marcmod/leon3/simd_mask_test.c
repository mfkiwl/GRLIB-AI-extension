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
    __asm__("ld [%fp + -4], %g2");
    __asm__("ld [%fp + -8], %g1");
    __asm__("sll %g2, %g1, %g1");
    __asm__("st %g1, [ %fp + -12 ]");
    //nop 82488001
    printf("NOP (move) c=%#010x, expected 0x01020304 mask 1111\n", c);

    //test add
    __asm__("ld [%fp + -4], %g2");
    __asm__("ld [%fp + -8], %g1");
    __asm__("sll %g2, %g1, %g1");
    __asm__("st %g1, [ %fp + -12 ]");
    //add a b 
    printf("add: c=%#010x, expected result 0x01030507 mask 1111\n", c);

    //test sadd
    a=0x8180ff01;
    b=0x81ff7f7f;
    __asm__("ld [%fp + -4], %g2");
    __asm__("ld [%fp + -8], %g1");
    //mask 0000
    __asm__("sll %g2, %g1, %g1");
    __asm__("sll %g2, %g1, %g1");
    __asm__("st %g1, [ %fp + -12 ]");
    printf("sadd: c=%#010x, expected result 0x8180ff01 mask 0000\n", c);

    //test sub
    a=0x0a0a0a0a;
    b=0x00050a0b;
    __asm__("ld [%fp + -4], %g2");
    __asm__("ld [%fp + -8], %g1");
    __asm__("sll %g2, %g1, %g1");
    __asm__("st %g1, [ %fp + -12 ]");
    printf("sub: c=%#010x, expected result 0x0a0a0a0a mask 0000\n", c);
    
    //test ssub
    a=0x807f0afb;
    b=0x05fffb0a;
    __asm__("ld [%fp + -4], %g2");
    __asm__("ld [%fp + -8], %g1");
    //mask 0001
    __asm__("sll %g2, %g1, %g1");
    __asm__("sll %g2, %g1, %g1");
    __asm__("st %g1, [ %fp + -12 ]");
    printf("ssub: c=%#010x, expected result 0x807f0af1 mask 0001\n", c);

    //test Max MAX signed
    a=0x0204080a;
    b=0x204080a0;
    __asm__("ld [%fp + -4], %g2");
    __asm__("ld [%fp + -8], %g1");
    //mask 1011
    __asm__("sll %g2, %g1, %g1");
    __asm__("sll %g2, %g1, %g1");
    __asm__("st %g1, [ %fp + -12 ]");
    printf("signed max max: c=%#010x, expected result 0x00000020 mask 1011\n", c);

    //test Max MAX unsigned
    __asm__("ld [%fp + -4], %g2");
    __asm__("ld [%fp + -8], %g1");
    //mask 1110
    __asm__("sll %g2, %g1, %g1");
    __asm__("sll %g2, %g1, %g1");
    __asm__("st %g1, [ %fp + -12 ]");
    printf("unsigned max max: c=%#010x, expected result 0x00000080 mask 1110\n", c);

    //test Min MIN unsigned
    __asm__("ld [%fp + -4], %g2");
    __asm__("ld [%fp + -8], %g1");
    //mask 1111
    __asm__("sll %g2, %g1, %g1");
    __asm__("sll %g2, %g1, %g1");
    __asm__("st %g1, [ %fp + -12 ]");
    printf("unsigned min min: c=%#010x, expected result 0x00000002 mask 1111\n", c);

    //test Min MIN signed
    __asm__("ld [%fp + -4], %g2");
    __asm__("ld [%fp + -8], %g1");
    //mask 1100
    __asm__("sll %g2, %g1, %g1");
    __asm__("sll %g2, %g1, %g1");
    __asm__("st %g1, [ %fp + -12 ]");
    printf("signed min min: c=%#010x, expected result 0x00000002 mask 1100\n", c);

    //test dot product
    a=0x01020304;
    b=0x00010203;
    __asm__("ld [%fp + -4], %g2");
    __asm__("ld [%fp + -8], %g1");
    //1010
    __asm__("sll %g2, %g1, %g1");
    __asm__("sll %g2, %g1, %g1");
    __asm__("st %g1, [ %fp + -12 ]");
    printf("dot product: c=%#010x, expected result 0x0000000C mask 1010\n", c);
   
    //test dot product2
    a=0xfffe03fc;
    b=0x00ff0203;
    __asm__("ld [%fp + -4], %g2");
    __asm__("ld [%fp + -8], %g1");
    __asm__("sll %g2, %g1, %g1");
    __asm__("st %g1, [ %fp + -12 ]");
    printf("dot product2: c=%#010x, expected result 0x00000000 mask 1010\n", c);
    
    //test saturated mul
    a=0x7f7ffdff;
    b=0x7fff7f80;
  //c=0x7f81807f
    __asm__("ld [%fp + -4], %g2");
    __asm__("ld [%fp + -8], %g1");
    __asm__("sll %g2, %g1, %g1");
    __asm__("st %g1, [ %fp + -12 ]");
    printf("saturate mul: c=%#010x, expected result 0x7f7f80ff mask 1010\n",c);
    
    //test div
    a=0x40404040;
    b=0x01020040;
    __asm__("ld [%fp + -4], %g2");
    __asm__("ld [%fp + -8], %g1");
    //mask 1111
    __asm__("sll %g2, %g1, %g1");
    __asm__("sll %g2, %g1, %g1");
    __asm__("st %g1, [ %fp + -12 ]");
    printf("div: c=%#010x, expected result 0x4020ff01 mask 1111\n", c);

    //test div2
    a=0xF6F6F6F6;
    b=0x0102ff0a;
    __asm__("ld [%fp + -4], %g2");
    __asm__("ld [%fp + -8], %g1");
    __asm__("sll %g2, %g1, %g1");
    __asm__("st %g1, [ %fp + -12 ]");
    printf("div2: c=%#010x, expected result 0xf6fb0aff mask 1111\n", c);

    //test nand as not (a nand a = !a)
    a=0xdeadbeaf;
    __asm__("ld [%fp + -4], %g2");
    __asm__("ld [%fp + -8], %g1");
    //mask 0011
    __asm__("sll %g2, %g1, %g1");
    __asm__("sll %g2, %g1, %g1");
    __asm__("st %g1, [ %fp + -12 ]");
    printf("nand: c=%#010x, expected result 0xDEAD4150 mask 0011\n", c);

    //test xor reduction
    a=0xfeedcafe;

    __asm__("ld [%fp + -4], %g2");
    __asm__("ld [%fp + -8], %g1");
    __asm__("sll %g2, %g1, %g1");
    __asm__("st %g1, [ %fp + -12 ]");
    printf("xor reduce: c=%#010x, expected result 0x00000027 mask 0011\n", c);

    puts("END OF TEST");
}
