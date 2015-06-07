#include <stdio.h>
#include <cuda.h>
#include <stdlib.h>
#include "helper_timer.h"

__global__ void add(int *a, int *b, int *c, int N) {
    int tid = blockIdx.x * blockDim.x + threadIdx.x;
    if (tid < N) {
        c[tid] = a[tid] + b[tid];
    }
}

void add_with_cpu(int *a, int *b, int *c, int N) {
    for (int i = 0; i < N; i++) {
        c[i] = a[i] + b[i];
    }
}

float count(int, int, int *, int, int, int);

int main(int argc, char **argv) {
    if (argc < 4) {
        printf("usage: %s <vector_size> <blocksize> <tries>\n", argv[0]);
        exit(-1);
    }
    int N = atoi(argv[1]);
    int blocksize = atoi(argv[2]);
    int tries = atoi(argv[3]);
    int nblocks = (N - 1) / blocksize + 1;

    int *c = (int *) malloc(N * sizeof(int));
    int *ccpu = (int *) malloc(N * sizeof(int));

    printf("%d; %d; %d; ", N, nblocks, blocksize);

    float time = count(N, 1, c, nblocks, blocksize, tries);
    time = time / tries;

    printf("%f; ", time);

    time = count(N, 0, ccpu, nblocks, blocksize, 1);
    printf("%f; ", time);

    int i;
    int errors = 0;

    for (i = 0; i < N; i++) {
        if (ccpu[i] != c[i]) {
            errors++;
        }
    }
    printf("%d\n", errors);


}

float count(int N, int use_gpu, int *c, int nblocks, int blocksize, int tries) {


    int *a = (int *) malloc(N * sizeof(int));
    int *b = (int *) malloc(N * sizeof(int));
//	int *c = (int *) malloc(N * sizeof(int));
    int *dev_a, *dev_b, *dev_c;

    if (use_gpu) {
        cudaMalloc((void **) &dev_a, N * sizeof(int));
        cudaMalloc((void **) &dev_b, N * sizeof(int));
        cudaMalloc((void **) &dev_c, N * sizeof(int));
    }

    for (int i = 0; i < N; i++) {
        a[i] = i;
        b[i] = i * 2;
    }
    cudaMemcpy(dev_a, a, N * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b, b, N * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(dev_c, c, N * sizeof(int), cudaMemcpyHostToDevice);

    StopWatchInterface *timer = NULL;
    sdkCreateTimer(&timer);
    sdkResetTimer(&timer);
    sdkStartTimer(&timer);

    for (int trie = 0; trie < tries; trie++) {
        if (use_gpu)
            add << < nblocks, blocksize >> > (dev_a, dev_b, dev_c, N);
        else
            add_with_cpu(a, b, c, N);
    }

    cudaThreadSynchronize();
    sdkStopTimer(&timer);
    float time = sdkGetTimerValue(&timer);
    sdkDeleteTimer(&timer);
//	printf ("Time for the kernel: %f ms\n", time);	

    if (use_gpu) {
        cudaMemcpy(c, dev_c, N * sizeof(int), cudaMemcpyDeviceToHost);
        cudaFree(dev_a);
        cudaFree(dev_b);
        cudaFree(dev_c);
    }
    free(a);
    free(b);

    return time;
}
