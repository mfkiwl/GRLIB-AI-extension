#include <stdio.h>
#include <time.h>
#include <string.h>
#include <stdlib.h>

#define N 4
int main()
{
    char string[3*(3+(6*N*N+N))];
    int pos = 0;
	unsigned char A[N][N], B[N][N], C[N][N];
	srand(N);

	for(int i=0; i<N; i++)
	    for(int j=0; j<N; j++) {
	        A[i][j] = 4*i+j;//rand()%10;
	        B[j][i] = 4*i+j;//rand()%10;
        }

    __asm__("nop");
    __asm__("nop");
    __asm__("nop");
    __asm__("nop");
    __asm__("nop");
    int sum =0;
    for(int i = 0; i<N; i++)
        for(int j=0; j<N; j++){
            for(int k=0; k<N; k+=4){
                char a = A[i][k];
                char b = B[j][k];
                sum += a*b;
                a = A[i][k+1];
                b = B[j][k+1];
                sum += a*b;
                a = A[i][k+2];
                b = B[j][k+2];
                sum += a*b;
                a = A[i][k+3];
                b = B[j][k+3];
                sum += a*b;
            }
            C[i][j] = sum;
            sum =0;
        }
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
            pos+=sprintf(&string[pos],"%d ", B[j][i]);
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
