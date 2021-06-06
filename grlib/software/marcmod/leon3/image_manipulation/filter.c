#include <stdio.h>
#include <stdlib.h>
#include "arrays.h"

#ifndef N
#define N 256
#endif

#define min(a,b) a < b ? a : b
#define max(a,b) a > b ? a : b

unsigned char f[3][3] = {1, 1, 1,
                         1,-8, 1,
                         1, 1, 1};

void filter(unsigned char src[N][N], unsigned char dst[N][N]){
    asm("nop");
    asm("srl %i0, %o1, %g2");
    asm("nop");
    for (int i = 0; i<N; i++)
        for (int j = 0; j<N; j++){
            int ret = 0;
            int imageX,imageY;
            for (int k = 0; k<3; k++)
                for(int l=0; l<3; l++){
                    imageY = i-1+k;
                    imageX = j-1+l;
                    if (k==1 && l==1) ret += src[imageY][imageX] * (-8);
                    else if (imageY < 0 || imageY >= N) ret += 0;
                    else if (imageX < 0 || imageX >= N) ret += 0;
                    else ret += src[imageY][imageX];
                }
            dst[i][j] = min(max(ret,0),255);
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
    unsigned char source[N][N] = {GRAY_ARRAY};
    unsigned char dest[N][N];
    //init(source);
    filter(source, dest);
    //print(dest);
}
