#include <stdio.h>
#include <time.h>
#include <stdlib.h>

#define min(a,b) \
   ({ __typeof__ (a) _a = (a); \
       __typeof__ (b) _b = (b); \
     _a < _b ? _a : _b; })

#define max(a,b) \
   ({ __typeof__ (a) _a = (a); \
       __typeof__ (b) _b = (b); \
     _a > _b ? _a : _b; })

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
        int x = X[i];
        int ax;
        asm("smul %1, %2, %0" : "=r"(ax) :"r"(x), "I"(A));
        ax = min(max(-128,ax), 127);
        asm("add  %1, %2, %0" : "=r"(ax) :"r"(ax), "I"(B));
        ax = min(max(-128,ax), 127);
        asm("smul %1, %2, %0" : "=r"(ax) :"r"(ax), "r"(x));
        ax = min(max(-128,ax), 127);
        ax = min(max(-128,ax+C), 127);
        Y[i] = ax;
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
