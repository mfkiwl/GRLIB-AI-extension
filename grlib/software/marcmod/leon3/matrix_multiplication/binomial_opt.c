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

#define A 3
#define B 5
#define C -15

void equation(char X[N], char Y[N]){
    asm("nop");
    asm("srl %i0, %o1, %g2");
    asm("nop");
    for (int i = 0; i<N; i++){
        char x = X[i];
        char ax;
        asm("smul %1, %2, %0" : "=r"(ax) :"r"(x), "I"(A));
        asm("add  %1, %2, %0" : "=r"(ax) :"r"(ax), "I"(B));
        asm("smul %1, %2, %0" : "=r"(ax) :"r"(ax), "r"(x));
        Y[i] = ax+C;
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
