#include <stdio.h>
#include <time.h>
#include <string.h>
#include <stdlib.h>

#ifndef N
#define N 8
#endif
int computeCell(int a, int b);
int computeSum(int a, int b);


asm("computeCell:");
asm("retl");
asm("usdot %o0, %o1, %o0");

asm("computeSum:");
asm("retl");
asm("usadd_usum %o0, %o1, %o0");

void print(char c, unsigned char src[N][N]) {
    printf("%c:\n", c);
    for (int i = 0; i<N; i++){
        for (int j = 0; j<N; j++){
            printf("%d ", src[i][j]);
        }
        printf("\n");
    }
}
void printB(unsigned char src[N][N]) {
    printf("B:\n");
    for (int j = 0; j<N; j++){
        for (int i = 0; i<N; i++){
            printf("%d ", src[i][j]);
        }
        printf("\n");
    }
}

void product(unsigned char A[N][N], unsigned char B[N][N], unsigned char C[N][N]){
    int sum = 0;
    int aux;
    asm("nop");
    asm("srl %i0, %o1, %g2");
    asm("nop");
    for(int i=0; i<N; i++)
        for(int j=0; j<N; j++){
            for(int k=0; k<N/4; k++){
                aux = computeCell(*((int *) &A[i][k*4]),*((int *) &B[j][k*4]));
                sum = computeSum(aux, sum);
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
	//print('A',A);
	//printB(B);
	//print('C',C);
}
