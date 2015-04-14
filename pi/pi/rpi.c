#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>
#include <mpi.h>
#include <math.h>
#include <string.h>
#include <stdint.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int main (int argc, char *argv[]) {
		int size;
		int rank;
		long long i;
        long double x, y;
        long double pi;
        long double result;
        long long iterations = atoll(argv[1]);

        MPI_Init (&argc, &argv);  /* starts MPI */
        MPI_Comm_rank (MPI_COMM_WORLD, &rank);  /* get current process id */
        MPI_Comm_size (MPI_COMM_WORLD, &size);  /* get current process id */
		double start = MPI_Wtime();

        int randomData = open("/dev/urandom", O_RDONLY);
        int seed;
		ssize_t read_size = read(randomData, &seed, sizeof(int));
		srand(seed);
        close(randomData);
        MPI_Barrier(MPI_COMM_WORLD);

        long long counter = 0;
        for(i = 0; i < iterations; i++) {
                x = (((long double)rand()) / ((long double)RAND_MAX));
                y = (((long double)rand()) / ((long double)RAND_MAX));

                if((x * x + y * y) <= 1) {
                        counter++;
                }
        }

        pi = 4.0 * ((long double)counter) / ((long double)iterations);

		MPI_Reduce(&pi, &result, 1, MPI_LONG_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);

        if(rank == 0) {
                //printf("%.16Lg\n", result/(long double)size);
                //iterations, world size, pi, time,
                printf("%lld; %d; %Lf; %f\n", iterations, size, pi, MPI_Wtime() - start);
        }

        MPI_Finalize();
}
