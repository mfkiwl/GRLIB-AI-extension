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

int main()
{
    char string[3*(3+(6*N*N+N))];
    int pos = 0;
	unsigned char A[N][N], B[N][N], C[N][N];
	srand(N);


	for(int i=0; i<N; i++)
	    for(int j=0; j<N; j++) {
	        A[i][j] = rand()%10;
	        B[j][i] = rand()%10;
        }

    int sum = 0;
    int aux; 

	puts("TEST BEGIN");
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
	puts("TEST END");

	pos += sprintf(&string[pos],"A:\n");
	for(int i=0; i<N; i++){
	    for(int j=0; j<N; j++)
            pos+=sprintf(&string[pos],"%d ", A[i][j]);
	    pos+=sprintf(&string[pos],"\n");
    }

	pos += sprintf(&string[pos],"B:\n");
    for(int j=0; j<N; j++){
        for(int i=0; i<N; i++)
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
    puts("END OF SIMULATION");
}
