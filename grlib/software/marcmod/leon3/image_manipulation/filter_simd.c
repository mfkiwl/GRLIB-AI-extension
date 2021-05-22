#include <stdio.h>
#include <stdlib.h>
#include "arrays.h"

#ifndef N
#define N 256
#endif

#define min(a,b) a < b ? a : b
#define max(a,b) a > b ? a : b



register int topval asm("%o1");
register int midval asm("%o2");
register int botval asm("%o3");
register int top asm("%g1");
register int mid asm("%g2");
register int bot asm("%g3");
register int tmp asm("%g4");
register int result asm("%g5");
void filter(unsigned char src[N][N], unsigned char dst[N][N]){
    asm("nop");
    asm("srl %i0, %o1, %g2");
    asm("nop");
    for (int i = 0; i<N; i++)
        for (int j = 0; j<N; j++){
            int ret = 0;
            //top row  %o1
            if (i == 0) asm("mov %g0, %o1"); //if out of bounds is 0
            else { //else get data
                //case 1: top byte in low rest in upper half |XXX0| |00XX|
                top = &src[i-1][j];
                if(j%4 == 0) {
                    if (j == 0) { //top byte is 0 because out of bounds 
                        asm("lduh [%g1], %o1");
                    }
                    else {
                        //asm("ldub, [%g1 -1], %o1");
                        topval = (char) src[i-1][j-1];
                        asm("sll %o1, 16, %o1");
                        asm("lduh [%g1], %g4");
                        asm("add %o1, %g4, %o1");
                    }
                }
                //case 2: data in top 3 bytes |000X|
                else if (j%4 == 1){
                    asm("ld [%g1 -1], %o1 ");
                    asm("srl %o1, 8, %o1");
                }
                //case 3: data in low 3 bytes |X000|
                else if (j%4 == 2){
                    asm("ld [%g1 -2], %o1 ");
                    asm("sll %o1, 8, %o1");
                }
                //case 4: top half in lower bytes, rest in higher byte |XX00| |0XXX|
                else {
                    asm("lduh [%g1 -1], %o1");
                    if( j < N-1) {
                        asm("sll %o1, 8, %o1");
                        asm("ldub [%g1 +1], %g4");
                        asm("add %o1, %g4, %o1");
                    }

                }
            }
            //bottom row
            if (i == N-1) asm("mov %g0, %o3"); //if out of bounds is 0
            else { //else get data
                //case 1: top byte in low rest in upper half |XXX0| |00XX|
                bot = &src[i+1][j];
                if(j%4 == 0) {
                    if (j == 0) { //top byte is 0 because out of bounds 
                        asm("lduh [%g3], %o3");
                    }
                    else {
                        //asm("ldub, [%g3 -1], %o3");
                        botval = (char) src[i+1][j-1];
                        asm("sll %o3, 16, %o3");
                        asm("lduh [%g3], %g4");
                        asm("add %o3, %g4, %o3");
                    }
                }
                //case 2: data in top 3 bytes |000X|
                else if (j%4 == 1){
                    asm("ld [%g3 -1], %o3 ");
                    asm("srl %o3, 8, %o3");
                }
                //case 3: data in low 3 bytes |X000|
                else if (j%4 == 2){
                    asm("ld [%g3 -2], %o3 ");
                    asm("sll %o3, 8, %o3");
                }
                //case 4: top half in lower bytes, rest in higher byte |XX00| |0XXX|
                else {
                    asm("lduh [%g3 -1], %o3");
                    if( j < N-1) {
                        asm("sll %o3, 8, %o3");
                        asm("ldub [%g3 +1], %g4");
                        asm("add %o3, %g4, %o3");
                    }

                }
            }

            //middle row
            //case 1: top byte in low rest in upper half |XXX0| |00XX|
            mid = &src[i][j];
            if(j%4 == 0) {
                if (j == 0) { //top byte is 0 because out of bounds 
                    asm("lduh [%g2], %o2");
                }
                else {
                    midval = (char) src[i][j-1];
                    //asm("ldub, [%g2 -1], %o2");
                    asm("sll %o2, 16, %o2");
                    asm("lduh [%g2], %g4");
                    asm("add %o2, %g4, %o2");
                }
            }
            //case 2: data in top 3 bytes |000X|
            else if (j%4 == 1){
                asm("ld [%g2 -1], %o2 ");
                asm("srl %o2, 8, %o2");
            }
            //case 3: data in low 3 bytes |X000|
            else if (j%4 == 2){
                asm("ld [%g2 -2], %o2 ");
                asm("set 0xffffff, %g4");
                asm("and %o2, %g4, %o2");
            }
            //case 4: top half in lower bytes, rest in higher byte |XX00| |0XXX|
            else {
                asm("lduh [%g2 -1], %o2");
                asm("sll %o2, 8, %o2");
                if( j < N-1) {
                    asm("ldub [%g2 +1], %g4");
                    asm("add %o2, %g4, %o2");
                }
            }
            asm("set 0x00010001, %g4");
            asm("add_usum %o1, %o3, %g5");
            asm("umul_usum %o2, %g4, %g4");
            asm("add %g4, %g5, %g5");
            asm("srl %o2, 8, %g4");
            asm("and %g4, 0x0ff, %g4");
            asm("sll %g4, 3, %g4");
            asm("sub %g5, %g4, %g5");
            dst[i][j] = min(max(result,0),255);
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
//    print(dest);
}
