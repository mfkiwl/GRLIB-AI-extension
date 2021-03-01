#include <stdio.h>
#include <time.h>
#include <string.h>
#include <stdlib.h>

#define N 4
int computeCell(int a, int b){

    int r;
    asm("smul %1, %0, %0" 
            : "=r"(r) 
            : "r"(a), "0"(b));

    //printf("a: %#010x\nb: %#010x\nr: %#010x\n",a,b,r);
    return r;
}

int main()
{
    char string[3*(3+(6*N*N+N))];
    int pos = 0;
	unsigned char A[N][N], B[N][N], C[N][N];
	srand(N);

	puts("TEST BEGIN");

	for(int i=0; i<N; i++)
	    for(int j=0; j<N; j++) {
	        A[i][j] = rand()%10;
	        B[j][i] = rand()%10;
        }

    int sum = 0;
    for(int i=0; i<N; i++)
        for(int j=0; j<N; j++){
            sum += computeCell(*((int *) &A[i][0]),*((int *) &B[j][0]));
            C[i][j] = sum;
            sum = 0;
        }

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
    puts("END OF TEST");
}
