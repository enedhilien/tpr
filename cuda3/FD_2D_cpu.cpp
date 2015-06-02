/*** Calculating a derivative with CD ***/
#include <iostream>
#include <fstream>
#include <cmath>
#include <sys/time.h>
#include <stdlib.h>

double get_time() {
    struct timeval tim;
    gettimeofday(&tim, NULL);
    return (double) tim.tv_sec + (tim.tv_usec / 1000000.0);
}

void copy_array(float *u, float *u_prev, int N, int BSZ) {
    for (int I = 0; I < N * N; I++) {
        u_prev[I] = u[I];
    }
}

// GPU kernel
void update(float *u, float *u_prev, int N, float h, float dt, float alpha, int BSZ) {
    // Setting up indices

    // if not boundary do
    for (int I = 0; I < N * N; I++) {
        if ((I > N) && (I < N * N - 1 - N) && (I % N != 0) && (I % N != N - 1)) {
            u[I] = u_prev[I] +
                   alpha * dt / (h * h) *
                   (u_prev[I + 1] + u_prev[I - 1] + u_prev[I + N] + u_prev[I - N] - 4 * u_prev[I]);
        }
    }
    // Boundary conditions are automatically imposed
    // as we don't touch boundaries
}

int main() {
    // Allocate in CPU
    int N = 128;
    int BLOCKSIZE = 16;

    float xmin = 0.0f;
    float xmax = 3.5f;
    float ymin = 0.0f;
    //float ymax 	= 2.0f;
    float h = (xmax - xmin) / (N - 1);
    float dt = 0.00001f;
    float alpha = 0.645f;
    float time = 0.4f;

    int steps = ceil(time / dt);
    int I;

    float *x = new float[N * N];
    float *y = new float[N * N];
    float *u_d = new float[N * N];
    float *u_prev = new float[N * N];
    float *u_prev_d = new float[N * N];


    // Generate mesh and intial condition
    for (int j = 0; j < N; j++) {
        for (int i = 0; i < N; i++) {
            I = N * j + i;
            x[I] = xmin + h * i;
            y[I] = ymin + h * j;
            u_d[I] = 0.0f;
            if ((i == 0) || (j == 0)) { u_d[I] = 200.0f; }
        }
    }

    // Loop
    double start = get_time();
    for (int t = 0; t < steps; t++) {
        copy_array(u_d, u_prev_d, N, BLOCKSIZE);
        update(u_d, u_prev_d, N, h, dt, alpha, BLOCKSIZE);
    }


    double stop = get_time();

    double elapsed = stop - start;
    std::cout << "time = " << elapsed <<
    std::endl;
    std::ofstream temperature("temperature_cpu.txt");
    for (int j = 0; j < N; j++) {
        for (int i = 0; i < N; i++) {
            I = N * j + i;
            temperature << x[I] << "\t" << y[I] << "\t" << u_d[I] <<
            std::endl;
        }
        temperature << "\n";
    }

    temperature.close();

}
