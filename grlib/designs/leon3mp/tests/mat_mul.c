#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define N 5
main()
{
//	puts("Matrix Multiplication");
	int A[N][N], B[N][N], C[N][N];
	srand(N);
	for(int i=0; i<N; i++)
	    for(int j=0; j<N; j++) {
	        A[i][j] = rand()%10;
	        B[i][j] = rand()%10;
        }

    int sum = 0;
    for(int i=0; i<N; i++)
        for(int j=0; j<N; j++){
            for(int k=0; k<N; k++)
                sum=sum+A[i][k]*B[k][j];
            C[i][j] = sum;
            sum = 0;
        }

	//printf("A:\n");
	//for(int i=0; i<N; i++){
	//   for(int j=0; j<N; j++);
	//      printf("%d ", A[i][j]);
	//    printf("\n");
    //}
	//printf("B:\n");
	//for(int i=0; i<N; i++){
	//    for(int j=0; j<N; j++);
	//      printf("%d ", B[i][j]);
	//    printf("\n");
    //}

	//printf("Result:\n");
	//for(int i=0; i<N; i++){
	//    for(int j=0; j<N; j++);
	//      printf("%d ", C[i][j]);
	//    printf("\n");
    //}
}
