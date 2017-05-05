
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>

#define SIZE 128
#define THREADS 32


__global__ void squareWithForLoop(float * d_arr, size_t maxLoop, size_t increment)
{

	float value;
	size_t index;
	size_t i;

	index = threadIdx.x;

	for (i = 0; i < maxLoop; i++) {
		value = d_arr[index];
		d_arr[index] = value * value;
		index += increment;
	}

}

int main(int argc, char ** argv) 
{

	float * h_array;
	float * d_array;

	size_t totalArraySize;

	totalArraySize = sizeof(float) * SIZE;

	h_array = (float *)malloc(totalArraySize);

	for (size_t i = 0; i < SIZE; i++)
		h_array[i] = i;

	cudaMalloc((void **)&d_array, totalArraySize);

	cudaMemcpy(d_array, h_array, totalArraySize, cudaMemcpyHostToDevice);

	squareWithForLoop<<<1, THREADS >>> (d_array, SIZE/THREADS, THREADS);

	cudaMemcpy(h_array, d_array, totalArraySize, cudaMemcpyDeviceToHost);

	cudaFree(d_array);

	for (size_t i = 0; i < SIZE; i++) {
		printf("%8.3f", h_array[i]);
		printf(((i % 7) != 6) ? "\t" : "\n");
	}
	printf("\n");

	free(h_array);

	return 0;

}

