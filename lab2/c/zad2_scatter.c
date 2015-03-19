#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdlib.h>

int rank, nprocs;

int my_scatter(const void *sendbuf, int sendcount, MPI_Datatype sendtype, void *recvbuf, 
		int recvcount, MPI_Datatype recvtype, int root, MPI_Comm comm){
	
	int sendtypesize, recvtypesize;
	MPI_Type_size(sendtype, &sendtypesize);
	MPI_Type_size(recvtype, &recvtypesize);
	
	if (root == rank){
		for (int i=0; i<nprocs; i++)
			if (i != root){
				MPI_Send((void*)(sendbuf + i * sendcount * sendtypesize), sendcount, sendtype, i, 1, comm);	
			} else {
				memcpy(recvbuf, sendbuf + i * sendcount * sendtypesize, sendcount * sendtypesize);
			}
	} else {
		MPI_Recv(recvbuf, recvcount, recvtype, root, 1, comm, MPI_STATUS_IGNORE);
	}	
}

int main(int argc, char **argv) {
	int times, i, size, std_scatter;
	double start_time, end_time;
	
	MPI_Request myRequest;   // Initialize the MPI environment
	MPI_Init(NULL, NULL);    // Find out rank, size
    
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &nprocs);
    	
	if(argc < 4 || nprocs < 2){
		if (argc < 4)   fprintf(stderr,"Usage %s  <std|user> <size of local data> <times>", argv[0]); 
		else            fprintf(stderr, "World size must be greater than 1 for %s\n", argv[0]);
		MPI_Abort(MPI_COMM_WORLD, 1);
	}
	
	std_scatter = !strcmp(argv[1], "std");
	size = atoi(argv[2]);
	times = atoi(argv[3]);
	
	char* global_data = NULL, *local_data;	
	local_data = malloc(size);
	if (rank == 0){
		global_data = malloc(size * nprocs);
		for (int i=0; i<size * nprocs; i++)
			global_data[i] = i;
	}
	
	MPI_Barrier(MPI_COMM_WORLD);
	start_time = MPI_Wtime();

	for (int i=0; i<times; i++){
		if (std_scatter){
			MPI_Scatter(global_data, size, MPI_CHAR, local_data, size, MPI_CHAR, 0, MPI_COMM_WORLD);
		} else {
			my_scatter(global_data, size, MPI_CHAR, local_data, size, MPI_CHAR, 0, MPI_COMM_WORLD);
		}				
		//printf ("rank %d start data ind %d\n", rank, local_data[0]);

		MPI_Gather(local_data, size, MPI_CHAR, global_data, size, MPI_CHAR, 0, MPI_COMM_WORLD);

//		if (rank == 0){
//			for (int i=0; i<size * nprocs; i++)
//				printf("%d ",global_data[i]);
//			printf("\n");
//		}
//		MPI_Barrier(MPI_COMM_WORLD);
	}
	MPI_Barrier(MPI_COMM_WORLD);
	end_time = MPI_Wtime();
	
	if (rank == 0)
		printf("%f;  ", 1e6 * (end_time - start_time) / times);	

	MPI_Finalize();
	return 0;
}