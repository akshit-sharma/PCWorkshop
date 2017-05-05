
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>

#define NUM_BLOCKS 16
#define THREADS 1

__global__ void helloWorld()
{
	printf("Hello Worlds! I'm a thread in block %d \n", blockIdx.x);
}

int main(int argc, char ** argv)
{

	helloWorld <<< NUM_BLOCKS, THREADS >>> ();
	
	cudaDeviceSynchronize();

	printf("That's all\n");

	return 0;

}


