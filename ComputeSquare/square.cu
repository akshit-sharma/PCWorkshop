
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>

#define THREADS 128

__global__ void square(float * d_arr)
{

	float value;
	size_t index;
	
	index = threadIdx.x;
	value = d_arr[index];

	d_arr[index] = value * value;

}

int main(int argc, char ** argv)
{

	float * h_array;
	float * d_array;

	size_t totalArraySize;

	totalArraySize = sizeof(float) * THREADS;

	h_array = (float *) malloc(totalArraySize);

	for (size_t i = 0; i < THREADS; i++)
		h_array[i] = i;

	cudaMalloc((void **)&d_array, totalArraySize);

	cudaMemcpy(d_array, h_array, totalArraySize, cudaMemcpyHostToDevice);

	square << <1, THREADS >> > (d_output, d_input);

	cudaMemcpy(h_array, d_array, totalArraySize, cudaMemcpyDeviceToHost);

	cudaFree(d_array);

	for (size_t i = 0; i < THREADS; i++) {
		printf("%8.3f", h_array[i]);
		printf(((i%7)!=6)?"\t":"\n");
	}
	printf("\n");

	free(h_array);

	return 0;

}


