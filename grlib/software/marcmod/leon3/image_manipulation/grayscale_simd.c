#include <stdio.h>
#include <stdlib.h>
#include "arrays.h"

#ifndef N
#define N 2
#endif

//void grayscale(unsigned char src[N][4][N], unsigned int dst[N][N/4], int n);

void printval(int d){
    printf("%d\n",d);
}

//asm("grayscale:");
//asm("set 0xfcfcfcfc, %o5");
//asm("nop");
//asm("srl %i0, %o1, %g2");
//asm("nop");
//// i0 -> i
//// i1 -> j
//// i2 -> base + 4N*i
//// g1 = @red -> j++(red+1) -> i++ (i2)
//// g2 = @green = (red+N) -> j++(green+N)
//// g3 = @blue  = (red+2N)-> j++(blue+2N)
//// g4 = @gray
//// l0 = red value
//// l1 = green value
//// l2 = blue value
//// l3 = gray value
//asm("mov %o0, %i2"); //i2=base (i=0)
//asm("sll %o2, 2, %g5"); //g5=4N
//asm("clr %i0"); //i=0
//asm("nxt_i:");
//asm("clr %i1"); // j=0
//asm("mov %i2, %g1"); //@red = 4N*i
//asm("add %g1, %o2, %g2"); //@green = @red+N
//asm("add %g2, %o2, %g3"); //@blue = @green+N
//asm("nxt_j:");
//asm("ld [ %g1 ], %l0"); //l0 = red
//asm("ld [ %g2 ], %l1"); //l1 = green
//asm("ld [ %g3 ], %l2"); //l2 = blue
//asm("shft_ %l0, %o5, %l0"); //red << 2
//asm("shft_ %l1, %o5, %l1"); //green << 2
//asm("shft_ %l2, %o5, %l2"); //blue << 2
//asm("add_ %l0, %l1, %l3");
//asm("add_ %l3, %l2, %l3"); //compute gray
//asm("st %l3, [ %o1 ]"); //store gray
//asm("add %i1, 4, %i1"); //j+=4
//asm("add %g1, 4, %g1"); //red+4
//asm("add %g2, 4, %g2"); //green+4
//asm("add %g3, 4, %g3"); //blue+4
//asm("add %o1, 4, %o1"); //gray+4
////if j < N branch next j
//asm("cmp %o2, %i1"); //N-j = cc
//asm("bne nxt_j"); //if N!=j jump
//asm("add %i0, 1, %i0"); //i+=4
////if i < N branch next i 
//asm("cmp %o2, %i0"); //N-i = cc
//asm("bne nxt_i"); //if N!=i jump
//asm("add %i2, %g5, %i2"); //src[i]+4N
//asm("nop");
//asm("srl %i0, %o1, %g2");
//asm("nop");
//asm("mov %i2, %o0");
//asm("call printval");
//asm("nop");
//asm("ret");
//asm("restore");

void grayscale( unsigned char src[N][4][N], unsigned int dst[N][N/4]){
    asm("set 0xfcfcfcfc, %o5");
    asm("nop");
    asm("srl %i0, %o1, %g2");
    asm("nop");
    register int r asm("%l0");
    register int g asm("%l1");
    register int b asm("%l2");
    volatile register int gray asm("%l3");
    for (int i = 0; i<N; i++)
        for (int j = 0; j<N; j+=4){
            r = *((int *) &src[i][0][j]);//*((volatile int *) &src[i][0][j]);
            g = *((int *) &src[i][1][j]);//*((volatile int *) &src[i][1][j]);
            b = *((int *) &src[i][2][j]);//*((volatile int *) &src[i][2][j]);
            asm("shft_ %l0, %o5, %l0");
            asm("shft_ %l1, %o5, %l1");
            asm("shft_ %l2, %o5, %l2");
            //asm("add_ %l0, %l1, %l3");
            //asm("add_ %l3, %l2, %l3");
            gray = r+g+b;
            dst[i][j/4]=gray;
            
        }
    asm("nop");
    asm("srl %i0, %o1, %g2");
    asm("nop");
}

void print(unsigned int src[N][N/4]) {
    printf("P3\n%d %d\n255\n",N,N);
    for (int i = 0; i<N; i++){
        for (int j = 0; j<N/4; j++){
            printf("%d %d %d ", src[i][j]>>24, src[i][j]>>24, src[i][j]>>24);
            printf("%d %d %d ", 0xff & src[i][j]>>16, 0xff & src[i][j]>>16, 0xff & src[i][j]>>16);
            printf("%d %d %d ", 0xff & src[i][j]>>8,  0xff & src[i][j]>>8,  0xff & src[i][j]>>8);
            printf("%d %d %d ", 0xff & src[i][j],     0xff & src[i][j],     0xff & src[i][j]);
        }
        printf("\n");
    }
}
    

int main(){
    unsigned char source[N][4][N] = {IMAGE_ARRAY};
    unsigned int dest[N][N/4];
    //init(source);
    grayscale(source, dest);
    print(dest);
}
