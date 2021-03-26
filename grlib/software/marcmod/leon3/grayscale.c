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

unsigned char shift_and_add(unsigned char r, unsigned char g, unsigned char b){
    unsigned char ret;
    ret = (r>>2) + (g>>2) + (b>>2);
    return ret;
}

void grayscale(unsigned char src[N][N][4], unsigned char dst[N][N][3]){
    unsigned char color;
    for (int i = 0; i<N; i++)
        for (int j = 0; j<N; j++){
            color = shift_and_add(src[i][j][0], src[i][j][1], src[i][j][2]);
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
