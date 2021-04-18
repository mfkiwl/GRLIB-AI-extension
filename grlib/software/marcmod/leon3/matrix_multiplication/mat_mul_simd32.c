#include <stdio.h>
#include <time.h>
#include <string.h>
#include <stdlib.h>

#define N 32
int computeCell(int a, int b){

    int r;
    //usmul usum a b
    asm("smul %1, %0, %0" 
            : "=r"(r) 
            : "r"(a), "0"(b));

   // printf("cell\na: %#010x\nb: %#010x\nr: %#010x\n",a,b,r);
    return r;
}

int computeCell2(unsigned char A[N][N], unsigned char B[N][N], int i, int j, int base){
    int r;
    //set ac_be = 0001
    asm("sdiv %g1, %g1, %g2");
    for(int k=0; k<4; k++)
        r = computeCell(*((int *) &A[i][base+k*4]),*((int *) &B[j][base+k*4]));
//    printf("r: %#010x\n",r);
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
	unsigned char A[N][N], B[N][N], C[N][N];
	srand(N);


	for(int i=0; i<N; i++)
	    for(int j=0; j<N; j++) {
	        A[i][j] = rand()%10;
	        B[j][i] = rand()%10; 
        }

    int sum1 = 0;
    int sum2 = 0;
    int aux;
	puts("TEST BEGIN");
    asm("nop");
    asm("srl %i0, %o1, %g2");
    asm("nop");
    for(int i=0; i<N; i++)
        for(int j=0; j<N; j++){
            sum1 = computeCell2(A, B, i, j, 0);
            sum2 = computeCell2(A, B, i, j, 4);
            aux = computeSum(sum1, sum2);
            //printf("sum: %#010x\n",aux);
            C[i][j] = aux;
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
