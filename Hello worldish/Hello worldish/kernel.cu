
#include "cuda_runtime.h"

#include <iostream>

__global__ void VectorAdd(int *a, int *b, int *c, int n)
{
	for (int i = blockIdx.x * blockDim.x + threadIdx.x;
		i < n;
		i += blockDim.x * gridDim.x)
	{
		c[i] = a[i] + b[i];
	}
}

int main(void)
{
	static const uint16_t SIZE = 1024;

	int a[SIZE], b[SIZE], c[SIZE];
	int *d_a, *d_b, *d_c;

	cudaError_t err_a = cudaMalloc(&d_a, SIZE * sizeof(int));
	cudaError_t err_b = cudaMalloc(&d_b, SIZE * sizeof(int));
	cudaError_t err_c = cudaMalloc(&d_c, SIZE * sizeof(int));
	// Need to check errors, not now 'tho

	for (int i = 0; i < SIZE; ++i) {
		a[i] = i;
		b[i] = i + 1;
	}

	cudaMemcpy(d_a, &a, SIZE * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, &b, SIZE * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(d_c, &c, SIZE * sizeof(int), cudaMemcpyHostToDevice);

	VectorAdd<<<1, SIZE>>>(d_a, d_b, d_c, SIZE);

	cudaMemcpy(&c, d_c, SIZE * sizeof(int), cudaMemcpyDeviceToHost);

	for (int i = 0; i < SIZE; ++i)
		std::cout << c[i] << std::endl;

	cudaFree(&d_a);
	cudaFree(&d_b);
	cudaFree(&d_c);


	return 1;
}