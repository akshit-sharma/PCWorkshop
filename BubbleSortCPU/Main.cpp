#include <stdio.h>
#include <stdlib.h>
#include <time.h>  

#define ARR_SIZE 102400

#define ARR_BYTE sizeof(int) * ARR_SIZE

int main(int argv, char ** argc)
{
	int * arr;
	int temp;
	size_t i, j;
	clock_t start, end;

	arr = (int *)malloc(ARR_BYTE);

	for (i = 0; i < ARR_SIZE; i++)
		arr[i] = rand() % 1024;


	start = clock();
	for (i = ARR_SIZE; i > 0; i--) 
	{
		for (j = 0; j < i; j++) {
			if (arr[j] > arr[j+1]) {
				temp = arr[j+1];
				arr[j+1] = arr[j];
				arr[j] = temp;
			}
		}
	}
	end = clock();


	for (i = 1; i < ARR_SIZE; i++) {
		if (arr[i - 1] > arr[i]) {
			printf("\nNot sorted\n\n");
			break;
		}
	}

	if (i == ARR_SIZE) {
		printf("\nSorted\n");
		printf("Time taken : %lf\n", (double) (end - start) / CLOCKS_PER_SEC);
	}
	
	free(arr);

}

