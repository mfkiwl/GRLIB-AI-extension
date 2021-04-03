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

//int b = 0xfcfcfc7f;

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
asm("srl %o0, %g1, %g1"); 


__attribute__((optimize("unroll-loops")))
void grayscale(unsigned char src[N][N][4], unsigned char dst[N][N]){
    unsigned char color;
    asm("nop");
    asm("srl %i0, %o1, %g2");
    asm("nop");
    for (int i = 0; i<N; i++)
        for (int j = 0; j<N; j++){
            dst[i][j]= *((int *) &src[i][j][0]) >> 2; //shift_and_add(*((int *) &src[i][j][0]));
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
