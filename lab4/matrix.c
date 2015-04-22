#include <stdio.h>
#include <time.h>
#include <math.h>
#include <stdlib.h>
#include <mpi.h>

int main(int argc, char** argv){

	MPI_Init(NULL, NULL);

	int world_rank;
	int world_size;	
	int rows = atoi(argv[1]);
	int columns = atoi(argv[2]);	
	int i, j;

	MPI_Comm_size(MPI_COMM_WORLD, &world_size);
	MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);

	MPI_Datatype columnType;
	MPI_Type_vector(columns,1 , columns, MPI_INT, &columnType);
	MPI_Type_commit(&columnType);

	int** array;//macierz 
	array = malloc(rows * sizeof(int *));
	for (i = 0; i < rows; i++)
		array[i] = malloc(columns * sizeof(int));

	if (world_rank == 0){
	} else { 
		for (i = world_rank - 1; i < rows; i += (world_size - 1) ){
			for(j = 0 ; j < columns ; j++){
				array[i][j] = j+i+j+7;
			}
		}
		for (i = world_rank - 1; i < rows; i += (world_size - 1) ){
			for(j = 0 ; j < columns ; j++){
				printf("Process %d (%d, %d) = %d\n", world_rank, j, i, array[i][j]);
			} 
		}
	}
}
	


