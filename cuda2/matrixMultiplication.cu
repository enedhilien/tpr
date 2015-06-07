// Matrix multiplication by parts
// Elements stored in row-major order

using namespace std;

#include <stdio.h>
#include <iostream>
#include <fstream>
#include "helper_timer.h"

typedef struct {
    int width;
    int height;
    float *elements;
} Matrix;

// Forward declaration of matrix mult
__global__ void MatMulKernel(const Matrix, const Matrix, Matrix);

StopWatchInterface *startTimer();

float stopTimer(StopWatchInterface *timer);

// Host code
void MatMul(const Matrix A, const Matrix B, Matrix C, const int tries, int block_size) {
    // Load matrices A and B to device memory
    Matrix d_A;
    d_A.width = A.width;
    d_A.height = A.height;
    size_t size = A.width * A.height * sizeof(float);
    cudaMalloc((void **) &d_A.elements, size);
    cudaMemcpy(d_A.elements, A.elements, size, cudaMemcpyHostToDevice);

    Matrix d_B;
    d_B.width = B.width;
    d_B.height = B.height;
    size = B.width * B.height * sizeof(float);
    cudaMalloc((void **) &d_B.elements, size);
    cudaMemcpy(d_B.elements, B.elements, size, cudaMemcpyHostToDevice);

    // allocate C in device
    Matrix d_C;
    d_C.width = C.width;
    d_C.height = C.height;
    size = d_C.width * d_C.height * sizeof(float);
    cudaMalloc((void **) &d_C.elements, size);

    // call kernel
    dim3 dimBlock(block_size, block_size, 1); // threads per block?
    dim3 dimGrid((B.width - 1) / block_size + 1, (A.height - 1) / block_size + 1); // number of blocks?


    StopWatchInterface *timer = startTimer();

    for (int trie = 0; trie < tries; trie++) {
        MatMulKernel << < dimGrid, dimBlock >> > (d_A, d_B, d_C);
    }
    float time = stopTimer(timer) / tries;

    //size; width; height; block_size; tries; time
    printf("%d; %d; %d; %d; %d; %f\n", C.width * C.height, C.width, C.height, block_size, tries, time);
    // copy C to host
    cudaMemcpy(C.elements, d_C.elements, size, cudaMemcpyDeviceToHost);

    // free device memory
    cudaFree(d_A.elements);
    cudaFree(d_B.elements);
    cudaFree(d_C.elements);
}

float stopTimer(StopWatchInterface *timer) {
    cudaThreadSynchronize();
    sdkStopTimer(&timer);
    float time = sdkGetTimerValue(&timer);
    sdkDeleteTimer(&timer);
    return time;
}

StopWatchInterface *startTimer() {
    StopWatchInterface *timer = NULL;
    sdkCreateTimer(&timer);
    sdkResetTimer(&timer);
    sdkStartTimer(&timer);
    return timer;
}

//matrix multiplication kernel
__global__ void MatMulKernel(Matrix A, Matrix B, Matrix C) {
    // each thread computes one element of C and acumulates results to
    float Cvalue = 0;
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    if ((row >= A.height) || (col >= B.width)) {
        return;
    }
    for (int e = 0; e < A.width; e++) {
        Cvalue += A.elements[row * A.width + e] *
                  B.elements[e * B.width + col];
    }
    C.elements[row * C.width + col] = Cvalue;

}

int main(int argc, char *const argv[]) {
    if (argc < 7) {
        printf("usage: %s <matrixA> <matrixB> <outputC> <Width> <block_size> <tires> \n", argv[0]);
        exit(0);
    }
    char *A_filename = argv[1];
    char *B_filename = argv[2];
    char *C_filename = argv[3];
    int Width = atoi(argv[4]);
    int block_size = atoi(argv[5]);
    int tries = atoi(argv[6]);


    Matrix A;
    Matrix B;
    Matrix C;

    A.width = Width;
    B.width = Width;
    C.width = Width;

    A.height = Width;
    B.height = Width;
    C.height = Width;

    A.elements = new float[Width * Width];
    B.elements = new float[Width * Width];
    C.elements = new float[Width * Width];

    //fill matrices
    std::ifstream A_input;
    std::ifstream B_input;
    A_input.open(A_filename);
    B_input.open(B_filename);

    float a, b;
    A_input >> a;
    B_input >> b;
    int i = 0;
    while (!A_input.eof()) {
        A.elements[i] = a;
        B.elements[i] = b;
        A_input >> a;
        B_input >> b;
        i += 1;
    }
    A_input.close();
    B_input.close();

    MatMul(A, B, C, tries, block_size);
    std::ofstream C_output;
    C_output.open(C_filename);
    for (int i = 0; i < Width; i++) {
        for (int j = 0; j < Width; j++)
            C_output << C.elements[i * Width + j] << "\t";
        C_output << endl;
    }

}
	
