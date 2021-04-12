#include <stdio.h>
#include <stdlib.h>
#include "arrays.h"

#ifndef N
#define N 2
#endif

void init(unsigned char a[N][N][4]){
    for (int i = 0; i<N; i++)
        for (int j = 0; j<N; j++){
            a[i][j][0] = rand()%255;
            a[i][j][1] = rand()%255;
            a[i][j][2] = rand()%255;
            a[i][j][3] = 255;
        }
}

int b = 0xfcfcfc7f;

int shift_and_add(int a){
    int r;
    asm("srl %1, %0, %0" 
            : "=r"(r) 
            : "r"(a), "0"(b));
    return r;
}

void grayscale(unsigned char src[N][N][4], unsigned char dst[N][N][3]){
    unsigned char color;
    for (int i = 0; i<N; i++)
        for (int j = 0; j<N; j++){
            color = shift_and_add(*((int *) &src[i][j][0]));
            dst[i][j][0] = color;
            dst[i][j][1] = color;
            dst[i][j][2] = color;
        }
}

void print(unsigned char src[N][N][3]) {
    printf("P3\n%d %d\n255\n",N,N);
    for (int i = 0; i<N; i++){
        for (int j = 0; j<N; j++){
            printf("%d %d %d ", src[i][j][0], src[i][j][1], src[i][j][2]);
        }
        printf("\n");
    }
}
    

int main(){
    unsigned char source[N][N][4] = {IMAGE_ARRAY};
    unsigned char dest[N][N][3];
    //init(source);
    grayscale(source, dest);
    print(dest);
}
