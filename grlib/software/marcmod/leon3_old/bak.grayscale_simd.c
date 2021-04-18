#include <stdio.h>
#include <stdlib.h>
#include "arrays.h"
#include "grayscale_simd.s"

#ifndef N
#define N 2
#endif


//int shift_and_add(int a);
//asm("shift_and_add:");
//asm("retl"); 
//asm("srl %o0, %g1, %g1"); 


extern void grayscale(unsigned char src[4][N][N], unsigned char dst[N][N]);

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
    unsigned char source[4][N][N] = {IMAGE_ARRAY};
    unsigned char dest[N][N];
    //init(source);
    grayscale(source, dest);
    print(dest);
}
