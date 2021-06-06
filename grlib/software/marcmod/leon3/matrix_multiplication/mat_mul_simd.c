#include <stdio.h>
#include <time.h>
#include <string.h>
#include <stdlib.h>

#ifndef N
#define N 8
#endif

void print(char c, unsigned char src[N][N]) {
    printf("%c:\n", c);
    for (int i = 0; i<N; i++){
        for (int j = 0; j<N; j++){
            if (c=='B') printf("%d ", src[j][i]);
            else printf("%d ", src[i][j]);
        }
        printf("\n");
    }
}

void product(unsigned char A[N][N], unsigned char B[N][N], unsigned char C[N][N]){
    int sum = 0;
    int aux;
    int matA, matB;
    asm("nop");
    asm("srl %i0, %o1, %g2");
    asm("nop");
    for(int i=0; i<N; i++)
        for(int j=0; j<N; j++){
            for(int k=0; k<N/4; k++){
                matA = *((int *) &A[i][k*4]);
                matB = *((int *) &B[j][k*4]);
                asm("usdot %1, %2, %0":"=r"(matA):"r"(matA), "r"(matB));
                asm("usadd_ %1, %2, %0" :"=r"(sum):"r"(sum), "r"(matA));
            }
            C[i][j] = sum;
            sum = 0;
        }
    asm("nop");
    asm("srl %i0, %o1, %g2");
    asm("nop");
}

void init(unsigned char A[N][N], unsigned char B[N][N]){
	for(int i=0; i<N; i++)
	    for(int j=0; j<N; j++) {
	        A[i][j] = rand()%10;
	        B[j][i] = rand()%10;
        }
}

int main()
{
	unsigned char A[N][N], B[N][N], C[N][N];
	srand(N);
	init(A,B);
	puts("TEST BEGIN");
	product(A,B,C);
	puts("TEST END");
    #ifdef P_INPUT
	print('A',A);
	print('B',B);
    #endif
    #ifdef P_OUTPUT
	print('C',C);
    #endif
}
