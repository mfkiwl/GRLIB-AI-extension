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

#define A 1 //3 imm -> 0b00001 imm = imm(4)(-) 2^(1+imm(3-1))+imm(0) = 2^1+1 = 3
#define B 5 
#define C 15 //-15 use sub instead

void equation(char X[N], char Y[N]){
    int x, y;
    asm("nop");
    asm("srl %i0, %o1, %g2");
    asm("nop");
    for (int i = 0; i<N; i+=4){
        x = *((int *) &X[i]);
        asm("smul_ %1, %2, %0" : "=r"(y) : "r"(x), "I"(A));  //a*x
        asm("sadd_ %1, %2, %0" : "=r"(y) : "r"(y), "I"(B)); //a*x + b
        asm("smul_ %1, %2, %0" : "=r"(y) : "r"(y), "r"(x)); //(a*x + b)*x
        asm("ssub_ %1, %2, %0" : "=r"(y) : "r"(y), "I"(C)); //(a*x + b)*x + c

        int *intpointer = ((int *) &Y[i]);
        *intpointer = y;

    }
    asm("nop");
    asm("srl %i0, %o1, %g2");
    asm("nop");
}

void init(char array[N]){
    for (int i = 0; i<N; i++) 
        array[i] = rand()%20 - 10;
}

void print(char array[N]){
    for (int i = 0; i<N; i++) 
        printf("%d ",array[i]);
    printf("\n");
}

int main()
{
    char X[N], Y[N];
    srand(N);
    init(X);
    equation(X,Y);
    #ifdef P_INPUT
    print(X);
    #endif
    #ifdef P_OUTPUT
    print(Y);
    #endif
}
