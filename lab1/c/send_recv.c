
#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdlib.h>

int main(int argc, char** argv) {
    MPI_Request myRequest;
    // Initialize the MPI environment
    MPI_Init(NULL, NULL);
    // Find out rank, size
    int world_rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);
    int world_size;
    MPI_Comm_size(MPI_COMM_WORLD, &world_size);
    int async, size, times;

    if(argc < 4 || (strcmp(argv[1], "async") && strcmp(argv[1], "sync") )){
        printf("Usage %s <async|sync> <size> <times>", argv[0]);
        MPI_Abort(MPI_COMM_WORLD, 1);
    }
    async = !strcmp(argv[1], "async");
    size = atoi(argv[2]);
    times = atoi(argv[3]);

    // We are assuming at least 2 processes for this task
    if (world_size < 2) {
        fprintf(stderr, "World size must be greater than 1 for %s\n", argv[0]);
        MPI_Abort(MPI_COMM_WORLD, 1);
    }

    //allocating buffer
    srand((int) MPI_Wtime());
    unsigned char * payload = malloc(sizeof(unsigned char) * size);

    double start_time, end_time, one_message_send_time, other_node_statistic;
    int number;
    if (world_rank == 0) {
        //generating buffor
        for (int i = 0; i < size; ++i) {
            payload[i] = rand();
        }

        start_time = MPI_Wtime();
        if (async){
            for (int i = 0; i < times; ++i) {
                MPI_Isend(payload, size, MPI_UNSIGNED_CHAR, 1, 1, MPI_COMM_WORLD, &myRequest);
            }
        }
        else{
            for (int i = 0; i < times; ++i) {
                MPI_Send(payload, size, MPI_UNSIGNED_CHAR, 1, 1, MPI_COMM_WORLD);
            }
        }
        end_time = MPI_Wtime();
        one_message_send_time = 1e6 * (end_time - start_time) / times;
        MPI_Send(&one_message_send_time, 1, MPI_DOUBLE_INT, 1, 2, MPI_COMM_WORLD);
    } else if (world_rank == 1) {
        start_time = MPI_Wtime();
        for (int i = 0; i < times; ++i) {
            MPI_Recv(payload, size, MPI_UNSIGNED_CHAR, 0, 1, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        }
        end_time = MPI_Wtime();
        one_message_send_time = 1e6 * (end_time - start_time) / times;
        MPI_Recv(&other_node_statistic, 1, MPI_DOUBLE_INT, 0, 2, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        printf("%d;%.10f;%.10f\n", size, other_node_statistic, one_message_send_time);
    }
    MPI_Finalize();
}
