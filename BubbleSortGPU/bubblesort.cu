
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>

#include <time.h>
#include <stdlib.h>

#define ARR_SIZE 102400
#define THREADS 512

#define ARR_BYTE sizeof(int) * ARR_SIZE


__global__ void gpuSort(int * d_arr, size_t maxSize);


int main(int argv, char ** argc)
{
	int * h_arr;
	int * d_arr;
	int temp;
	int blockSize;
	size_t i;
	cudaEvent_t start, stop;
	float milliseconds;

	cudaEventCreate(&start);
	cudaEventCreate(&stop);

	h_arr = (int *)malloc(ARR_BYTE);

	cudaMalloc((void **)&d_arr, ARR_BYTE);

	for (i = 0; i < ARR_SIZE; i++)
		h_arr[i] = rand() % 1024;

	cudaMemcpy(d_arr, h_arr, ARR_BYTE, cudaMemcpyHostToDevice);

	blockSize = ARR_SIZE / THREADS;
	blockSize += (ARR_SIZE%THREADS ? 1 : 0);
	blockSize += (blockSize / 2) + (blockSize % 2);

	cudaEventRecord(start);
	for (i = 0; i < ARR_SIZE/2+1; i++) {
		gpuSort <<< blockSize, THREADS >>> (d_arr, ARR_SIZE);
	}
	cudaEventRecord(stop);

	cudaMemcpy(h_arr, d_arr, ARR_BYTE, cudaMemcpyDeviceToHost);

	cudaEventSynchronize(stop);

	for (i = 1; i < ARR_SIZE; i++) {
		if (h_arr[i - 1] > h_arr[i]) {
			printf("\nNot sorted\n\n");
			break;
		}
	}

	if (i == ARR_SIZE) {
		printf("\nSorted\n");
		cudaEventElapsedTime(&milliseconds, start, stop);
		printf("Time taken : %llf\n", milliseconds / 1000);
	}

	cudaFree(d_arr);

	free(h_arr);

}

__global__ void gpuSort(int * d_arr, size_t maxSize)
{
	int temp;
	size_t threadIndex = threadIdx.x + blockDim.x*blockIdx.x;

	threadIndex *= 2;

	if (threadIndex + 1 < maxSize) {
		if (d_arr[threadIndex] > d_arr[threadIndex + 1]) {
			temp = d_arr[threadIndex];
			d_arr[threadIndex] = d_arr[threadIndex + 1];
			d_arr[threadIndex + 1] = temp;
		}
	}
	threadIndex++;
	if (threadIndex + 1 < maxSize) {
		if (d_arr[threadIndex] > d_arr[threadIndex + 1]) {
			temp = d_arr[threadIndex];
			d_arr[threadIndex] = d_arr[threadIndex + 1];
			d_arr[threadIndex + 1] = temp;
		}
	}
	threadIndex--;
	if (threadIndex + 1 < maxSize) {
		if (d_arr[threadIndex] > d_arr[threadIndex + 1]) {
			temp = d_arr[threadIndex];
			d_arr[threadIndex] = d_arr[threadIndex + 1];
			d_arr[threadIndex + 1] = temp;
		}
	}


}

