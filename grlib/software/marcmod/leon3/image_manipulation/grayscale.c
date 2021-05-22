#include <stdio.h>
#include <stdlib.h>
#include "arrays.h"

#ifndef N
#define N 2
#endif

  
unsigned char shift_and_add(unsigned char r, unsigned char g, unsigned char b){
    unsigned char ret;
    ret = (r>>2) + (g>>2) + (b>>2);
    return ret;
}

void grayscale(unsigned char src[N][4][N], unsigned char dst[N][N]){
    unsigned char color;
    asm("nop");
    asm("srl %i0, %o1, %g2");
    asm("nop");
    for (int i = 0; i<N; i++)
        for (int j = 0; j<N; j++){
            dst[i][j] = (src[i][0][j]>>2) + (src[i][1][j]>>2) + (src[i][2][j]>>2);
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
    unsigned char source[N][4][N] = {IMAGE_ARRAY};
    unsigned char dest[N][N];
    //init(source);
    grayscale(source, dest);
//    print(dest);
}
