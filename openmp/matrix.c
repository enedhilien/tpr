#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

double vectors_dot_prod2(const double *x, const double *y, int n)
{
    double res = 0.0;
    int i = 0;
    for (; i <= n-4; i+=4)
    {
        res += (x[i] * y[i] +
                x[i+1] * y[i+1] +
                x[i+2] * y[i+2] +
                x[i+3] * y[i+3]);
    }
    for (; i < n; i++)
    {
        res += x[i] * y[i];
    }
    return res;
}

int main(int argc, char *argv[])
{
    double **A;
    double *u, *v;
    long MATRIX_SIZE = atoll(argv[1]);
    int LOOPS = atoi(argv[2]);
    struct timeval tval_before, tval_after, tval_result;
    long i, j, k;

    u = (double*)malloc(MATRIX_SIZE * sizeof(double));
    v = (double*)malloc(MATRIX_SIZE * sizeof(double));

    A = (double**)malloc(MATRIX_SIZE * sizeof(double*));

    for (i = 0; i < MATRIX_SIZE; i++)
        A[i] = (double*)malloc(MATRIX_SIZE * sizeof(double));

    for (i = 0; i < MATRIX_SIZE; i++) {
        u[i] = (double)(rand());
        for ( j = 0; j < MATRIX_SIZE; j++ )
            A[j][i] = (double)(rand() * rand());
    }

    gettimeofday(&tval_before, NULL);

    for (k = 0; k < LOOPS; k++) {
        //#pragma omp parallel for shared(A, v, u, MATRIX_SIZE) private(i, j)
        for (i = 0; i < MATRIX_SIZE; i++) {
            v[i] = 0.0f;
            for (j = 0; j < MATRIX_SIZE; j++)
                v[i]  = v[i] + A[i][j] * u[j];
        }
    }

    gettimeofday(&tval_after, NULL);

    timersub(&tval_after, &tval_before, &tval_result);

	printf("Time elapsed: %ld.%06ld\n", (long int)tval_result.tv_sec, (long int)tval_result.tv_usec);
    return 0;
}
