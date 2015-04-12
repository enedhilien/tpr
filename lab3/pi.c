#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <limits.h>

// http://stackoverflow.com/questions/20141239/random-number-to-each-process-in-mpi

int main(int argc, char** argv) {
  int rank, nprocs, nameLen, i; // size by proc
  double t1,t2,t3,t4, value;
  long long int problemSize, sizePerProc, inside = 0, insideSum = 0;
  long double pi = 0;
  char processorName[MPI_MAX_PROCESSOR_NAME];
  long double x =0, y=0;

  MPI_Init(NULL, NULL); 
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &nprocs);
	MPI_Get_processor_name(processorName, &nameLen);

	if (argc < 3){
		if (rank == 0){
	  		fprintf(stderr, "Usage %s <size> <<T|N> size by proc>\n", argv[0]);
	  		MPI_Abort(MPI_COMM_WORLD, 1);
		}
	}
 
	if ( strcmp(argv[2], "T") == 0){
		sizePerProc = (long long int)atof(argv[1]);
		problemSize = sizePerProc * nprocs;
	} else {
		problemSize = (long long int)atof(argv[1]);
		sizePerProc = problemSize / nprocs;
	}
	
	srand ((unsigned)time(NULL) + rank * nprocs + nameLen); //+ rank * nprocs + nameLen

	t1 = MPI_Wtime();

	if (nprocs > 1){
		MPI_Bcast(&sizePerProc, 1, MPI_LONG_LONG_INT, 0, MPI_COMM_WORLD);
	}

	t2 = MPI_Wtime();	

	for (i=0; i<sizePerProc; ++i){
	  x = (double)rand() / (double)RAND_MAX ;
	  y = (double)rand() / (double)RAND_MAX ;
	  if ( x*x + y*y <= 1){
	    ++inside;
	  }
	} 
	
	t3 = MPI_Wtime();

	if (nprocs > 1){
		MPI_Reduce(&inside, &insideSum, 1, MPI_LONG_LONG_INT, MPI_SUM, 0, MPI_COMM_WORLD);
	} else {
		insideSum = inside;
	}

	//printf("c: %d, %ld\n", rank, inside);
	if (rank == 0){
		pi = (4.0 * (long double)insideSum) / (long double)(problemSize); 
		t4 = MPI_Wtime();
		printf("%lld, %lld, %d, %f, %f, %f, %f, %Lf\n", problemSize, sizePerProc, nprocs, t1, t2, t3, t4, pi);
	}
	
	MPI_Finalize();
}


	

	
	
