#include <stdio.h>
#include <time.h>
#include <stdlib.h>

#define min(a,b) \
   ({ __typeof__ (a) _a = (a); \
       __typeof__ (b) _b = (b); \
     _a < _b ? _a : _b; })

#ifndef N
#define N 4
#endif

int computeCell(int a, int b){

    int r;
    asm("smul %1, %0, %0" 
            : "=r"(r) 
            : "r"(a), "0"(b));

    //printf("a: %d\nb: %d\nr: %d\n",a,b,r);
    return min(r, 255);
}

int computeSum(int a, int b) {
    int r;
    //sum sum a b
    asm("add %1, %0, %0" 
            : "=r"(r) 
            : "r"(a), "0"(b));
    return min(r, 255);
}

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
            for(int k=0; k<N; k++){
                aux = computeCell(A[i][k],B[j][k]);
                sum = computeSum(sum, aux);
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
