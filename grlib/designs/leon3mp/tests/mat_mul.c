#include <stdio.h>
#include <time.h>
#include <string.h>
#include <stdlib.h>

#define N 4
int main()
{
    char string[3*(3+(6*N*N+N))];
    int pos = 0;
//	puts("Matrix Multiplication");
	int A[4][4] = {{1,2,3,4},{1,2,3,4},{1,2,3,4},{1,2,3,4}};
	int D[N][N], B[N][N], C[N][N];
	printf("a: %p\n",&A);
	printf("b: %p\n",&B);
	printf("c: %p\n",&C);
	srand(N);

	for(int i=0; i<N; i++)
	    for(int j=0; j<N; j++) {
	        A[i][j] = i;
	        B[i][j] = j;
        }

    int sum = 0;
    __asm__("nop");
    __asm__("nop");
    __asm__("nop");
    __asm__("nop");
    __asm__("nop");
    __asm__("nop");
    __asm__("nop");
    __asm__("nop");
    __asm__("nop");
    for(int i=0; i<N; i++)
        for(int j=0; j<N; j++){
            for(int k=0; k<N; k++){
                __asm__("nop");
                __asm__("nop");
                sum=sum+A[i][k]*B[k][j];
                __asm__("nop");
                __asm__("nop");
            }
            C[i][j] = sum;
            sum = 0;
        }
    __asm__("nop");
    __asm__("nop");
    __asm__("nop");
    __asm__("nop");
    __asm__("nop");
    __asm__("nop");
    __asm__("nop");
    __asm__("nop");
    __asm__("nop");
    __asm__("nop");
    __asm__("nop");
    __asm__("nop");
    __asm__("nop");
    __asm__("nop");
    __asm__("nop");

	pos += sprintf(&string[pos],"A:\n");
	for(int i=0; i<N; i++){
	    for(int j=0; j<N; j++)
            pos+=sprintf(&string[pos],"%d ", A[i][j]);
	    pos+=sprintf(&string[pos],"\n");
    }

	pos += sprintf(&string[pos],"B:\n");
	for(int i=0; i<N; i++){
	    for(int j=0; j<N; j++)
            pos+=sprintf(&string[pos],"%d ", B[i][j]);
	    pos+=sprintf(&string[pos],"\n");
    }

	pos += sprintf(&string[pos],"C:\n");
	for(int i=0; i<N; i++){
	    for(int j=0; j<N; j++)
            pos+=sprintf(&string[pos],"%d ", C[i][j]);
	    pos+=sprintf(&string[pos],"\n");
    }
    
    puts(string);
    puts("END OF TEST");
}
