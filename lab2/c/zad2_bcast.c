#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdlib.h>

int rank, nprocs;

int my_bcast(void *buff, int count, MPI_Datatype datatype, int root, MPI_Comm comm){
	int i;	
	if (root == rank){
		for (i=0; i<nprocs; i++)
			if (i != root)
				MPI_Send(buff, count, datatype, i, 1, comm);		
	} else {
		MPI_Recv(buff, count, datatype, root, 1, comm, MPI_STATUS_IGNORE);
		//printf("rank %d receive: %s\n", rank, buff);
	}
}


int main(int argc, char** argv) {
	int times, i, size, std_bcast;
	double start_time, end_time;
	
	MPI_Request myRequest;   // Initialize the MPI environment
	MPI_Init(NULL, NULL);    // Find out rank, size
    
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &nprocs);
    	
	if(argc < 4 || nprocs < 2){
		if (argc < 4)   fprintf(stderr,"Usage %s  <std|user> <size> <times>", argv[0]); 
		else            fprintf(stderr, "World size must be greater than 1 for %s\n", argv[0]);
		MPI_Abort(MPI_COMM_WORLD, 1);
	}
	
	std_bcast = !strcmp(argv[1], "std");
	size = atoi(argv[2]);
	times = atoi(argv[3]);
	
	//srand((int) MPI_Wtime());
	char * buff = malloc(sizeof(char) * size);
	MPI_Barrier(MPI_COMM_WORLD);
	
	//strcpy(buff, "succes");
	start_time = MPI_Wtime();
	if (!std_bcast){
		for (i=0; i<times; i++){				
			my_bcast(buff, size, MPI_CHAR, 0, MPI_COMM_WORLD);
		}		
	} else {
		for (i=0; i<times; i++){
			MPI_Bcast(buff, size, MPI_CHAR, 0, MPI_COMM_WORLD);
		}
	}
	MPI_Barrier(MPI_COMM_WORLD);
	end_time = MPI_Wtime();
	
	if (rank == 0){
		printf("%f;  ", 1e6 * (end_time - start_time) / times);
	}
	
	MPI_Finalize();
}