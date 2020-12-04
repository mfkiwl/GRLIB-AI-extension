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
    printf("NOP\n");

    //test add
    c=a+b;
    printf("add: c=%#010x, expected result 0x01030507\n", c);

    //test sadd
    a=0x8180ff01;
    b=0x81ff7f7f;
    c=a+b;
    printf("sadd: c=%#010x, expected result 0x80807e7f\n", c);

    //test sub
    a=0x0a0a0a0a;
    b=0x00050a0b;
    c=a-b;
    printf("sub: c=%#010x, expected result 0x0a0500ff\n", c);
    
    //test ssub
    a=0x807f0afb;
    b=0x05fffb0a;
    c=a-b;
    printf("ssub: c=%#010x, expected result 0x807f7ff1\n", c);

    //test Max MAX signed
    a=0x0204080a;
    b=0x204080a0;
    c=a-b;
    printf("max max: c=%#010x, expected result 0x00000040\n", c);

    //test Max MAX unsigned
    c=a-b;
    printf("max max: c=%#010x, expected result 0x000000a0\n", c);

    //test Min MIN unsigned
    c=a-b;
    printf("min min: c=%#010x, expected result 0x00000002\n", c);

    //test Min MIN signed
    c=a-b;
    printf("min min: c=%#010x, expected result 0xffffff80\n", c);

    //test dot product
    a=0x01020304;
    b=0x00010203;
    c=a*b;
    printf("dot prduct: c=%#010x, expected result 0x00000014\n", c);
   
    //test dot product2
    a=0xfffe03fc;
    b=0x00ff0203;
    c=a*b;
    printf("dot prduct2: c=%#010x, expected result 0xfffffffc\n", c);
    
    //test div
    a=0x40404040;
    b=0x01020040;
    c=a/b;
    printf("div: c=%#010x, expected result 0x4020ff01\n", c);

    //test div2
    a=0xF6F6F6F6;
    b=0x0102ff0a;
    c=a/b;
    printf("div2: c=%#010x, expected result 0xf6fb0aff\n", c);

    //test nand as not (a nand a = !a)
    a=0xdeadbeaf;
    c=~(a & a);
    printf("nand: c=%#010x, expected result 0x21524150\n", c);

    //test xor reduction
    a=0xfeedcafe;
    c=a*b;
    printf("xor reduce: c=%#010x, expected result 0x00000027\n", c);

    puts("END OF TEST");
}
