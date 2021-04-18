#include <stdio.h>
#include <stdlib.h>
#include "arrays.h"

#ifndef N
#define N 2
#endif

//void init(unsigned char a[N][N][4]){
//    for (int i = 0; i<N; i++)
//        for (int j = 0; j<N; j++){
//            a[i][j][0] = rand()%255;
//            a[i][j][1] = rand()%255;
//            a[i][j][2] = rand()%255;
//            a[i][j][3] = 255;
//        }
//}

int b = 0xfcfcfc7f;

//int shift_and_add(int a){
   //int r;
   //asm("srl %1, %0, %0" 
   //        : "=r"(r) 
   //        : "r"(a), "0"(b));
   //return r;
//}

int shift_and_add(int a);
asm("shift_and_add:");
asm("retl"); 
asm("shft_sum %o0, %g4, %o0"); 



//__attribute__((optimize("unroll-loops")))
void grayscale(unsigned char src[N][N][4], unsigned char dst[N][N]){
    asm("set 0xfcfcfc00, %o5");
    asm("nop");
    asm("srl %i0, %o1, %g2");
    asm("nop");
    register int c0 asm("%o0");
    register int c1 asm("%o1");
    register int c2 asm("%o2");
    register int c3 asm("%o3");
    for (int i = 0; i<N; i++)
        for (int j = 0; j<N; j+=4){
            c0 = *((int *) &src[i][j][0]);
            c1 = *((int *) &src[i][j+1][0]);
            c2 = *((int *) &src[i][j+2][0]);
            c3 = *((int *) &src[i][j+3][0]);
            asm("shft_sum %o0, %o5, %o0");
            asm("shft_sum %o1, %o5, %o1");
            asm("shft_sum %o2, %o5, %o2");
            asm("shft_sum %o3, %o5, %o3");
            dst[i][j]= c0;
            dst[i][j+1]= c1;
            dst[i][j+2]= c2;
            dst[i][j+3]= c3;
        }
    asm("nop");
    asm("srl %i0, %o1, %g2");
    asm("nop");
}

void print(unsigned char src[N][N]) {
    printf("P3\n%d %d\n255\n",N,N);
    for (int i = 0; i<N; i++){
        for (int j = 0; j<N; j++){
            printf("%d %d %d ", src[i][j], src[i][j], src[i][j]);
        }
        printf("\n");
    }
}
    

int main(){
    unsigned char source[N][N][4] = {IMAGE_ARRAY};
    unsigned char dest[N][N];
    //init(source);
    grayscale(source, dest);
    print(dest);
}
