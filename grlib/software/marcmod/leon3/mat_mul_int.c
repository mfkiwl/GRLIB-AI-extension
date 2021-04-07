#include <stdio.h>
#include <time.h>
#include <string.h>
#include <stdlib.h>

#ifndef N
#define N 4
#endif

int computeCell(int a, int b){

    int r;
    asm("smul %1, %0, %0" 
            : "=r"(r) 
            : "r"(a), "0"(b));

    //printf("a: %d\nb: %d\nr: %d\n",a,b,r);
    return r;
}
int computeSum(int a, int b) {
    int r;
    //sum sum a b
    asm("add %1, %0, %0" 
            : "=r"(r) 
            : "r"(a), "0"(b));
    return r;
}

int main()
{
    char string[3*(3+(6*N*N+N))];
    int pos = 0;
	unsigned int A[N][N], B[N][N], C[N][N];
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
	puts("TEST END");

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
    puts("END OF SIMULATION");
}
