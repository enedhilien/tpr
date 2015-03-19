#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdlib.h>


int main(int argc, char** argv) {
	int rank, nprocs, times, i;
	double start_time, end_time;
	
	MPI_Request myRequest;   // Initialize the MPI environment
	MPI_Init(NULL, NULL);    // Find out rank, size
    
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &nprocs);
    	
	if(argc < 2 || nprocs < 2){
		if (argc < 2)   fprintf(stderr,"Usage %s <times>", argv[0]); 
		else            fprintf(stderr, "World size must be greater than 1 for %s\n", argv[0]);
		MPI_Abort(MPI_COMM_WORLD, 1);
	}
	times = atoi(argv[1]);
			
	//srand((int) MPI_Wtime());
	
	MPI_Barrier(MPI_COMM_WORLD);
	
	start_time = MPI_Wtime();
	for (i=0; i<times; i++){
		MPI_Barrier(MPI_COMM_WORLD);
	}	
	end_time = MPI_Wtime();
	
	if (rank == 0){
		printf("%f;  ", 1e6 * (end_time - start_time) / times);
	}
	
	MPI_Finalize();
}
