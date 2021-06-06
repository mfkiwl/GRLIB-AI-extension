#include <stdio.h>
#include <stdlib.h>
#include "arrays.h"

#ifndef N
#define N 2
#endif

void grayscale( unsigned char src[N][4][N], unsigned int dst[N][N/4]){
    int shift = 0xfcfcfcfc;
    asm("nop");
    asm("srl %i0, %o1, %g2");
    asm("nop");
    int r, g, b, gray;
    for (int i = 0; i<N; i++)
        for (int j = 0; j<N; j+=4){
            r = *((int *) &src[i][0][j]);
            g = *((int *) &src[i][1][j]);
            b = *((int *) &src[i][2][j]);
            asm("shft_ %1, %2, %0" : "=r"(r) : "r"(r), "r"(shift));
            asm("shft_ %1, %2, %0" : "=r"(g) : "r"(g), "r"(shift));
            asm("shft_ %1, %2, %0" : "=r"(b) : "r"(b), "r"(shift));
            asm("usadd_ %1, %2, %0" : "=r"(gray) : "r"(r), "r"(g));
            asm("usadd_ %1, %2, %0" : "=r"(gray) : "r"(gray), "r"(b));
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
    #ifdef P_OUTPUT
    print(dest);
    #endif
}
