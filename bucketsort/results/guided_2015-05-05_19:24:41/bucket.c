#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <stdint.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <omp.h>

#define SCHEDULE_TYPE dynamic

void min_and_max(int *array, int start, int end, int *minmax_results, int tid);

void paralell_min_and_max(int *t, int size, int *min, int *max)
{
	int threads = omp_get_max_threads();
	int results[threads*2];
	int chunk_size = size/threads;
#pragma omp parallel
{
	int tid = omp_get_thread_num();
	int start = chunk_size*tid;
	int end = (start + chunk_size)-1;
	min_and_max(t, start, end, results, tid);
}
#pragma omp barrier
	int i;
	int minmax[2];
	min_and_max(results, 0, threads, minmax, 0);
	*min = minmax[0];
	*max = minmax[1];
}

void min_and_max(int *array, int start, int end, int *minmax_results, int tid)
{
	//~ printf("%d - %d: %d\n", start, end, array[start]);
	minmax_results[tid*2] = array[start];
	minmax_results[tid*2+1] = array[start];
	
	int i;
	for(i=start;i<=end;i++){
		if(array[i] < minmax_results[tid*2]){
			minmax_results[tid*2] = array[i];
		}
		if(array[i] > minmax_results[tid*2+1]){
			minmax_results[tid*2+1] = array[i];
		}
	}
}

void prepare_seed()
{
	    int randomData = open("/dev/urandom", O_RDONLY);
        int seed;
		ssize_t read_size = read(randomData, &seed, sizeof(int));
		srand(seed);
        close(randomData);
}

int *initialize_array(int size){
	int i, *array;
	array = (int*)(malloc(sizeof(int)*size));
	for(i=0;i<size;i++){
		array[i] = rand();
	}
	return array;		
}

int cmpfunc (const void * a, const void * b)
{
   return ( *(int*)a - *(int*)b );
}

int getBucketIndex(int element, int *boundaries, int bucketsCount){
	int index = 0;
	while(element > boundaries[index]){
		if(index++ > bucketsCount){
			index = bucketsCount-1;
			break;
		}
	}
	//~ printf("%d, %d\n", element, index);
	return index;
}

int main(int argc, char** argv) {
        int n = atoi(argv[1]);
        int threads = atoi(argv[2]);
		int bucketCount = atoi(argv[3]);
		int i,j;
		
        omp_set_num_threads(threads);
        double start_all = omp_get_wtime();
        int *array = initialize_array(n);

        int **buckets = (int**)(malloc(sizeof(int*) * bucketCount));
        int bucketsIndexes[bucketCount];
        int nPerBucket = n/bucketCount;
        for(i=0;i<bucketCount;i++){
			bucketsIndexes[i]=0;
			buckets[i] = (int*)(malloc(sizeof(int) * nPerBucket));
		}
        
        double start_sorting = omp_get_wtime();
        int min, max;
        paralell_min_and_max(array, n, &min, &max);
        int *boundaries = (int*)(malloc(sizeof(int) * bucketCount));

        int bound = (max-min)/bucketCount;
        for(i=0;i<bucketCount;i++){
			boundaries[i]= min + (i+1)*bound;
			//~ printf("%d\n", boundaries[i]);
		}
		 
		#pragma omp for schedule(SCHEDULE_TYPE)
		for(i=0;i<n;i++){
			int bucketIndex = getBucketIndex(array[i], boundaries, bucketCount);
			buckets[bucketIndex][bucketsIndexes[bucketIndex]++] = array[i];
		}
		
		#pragma omp for schedule(SCHEDULE_TYPE)
		for(i=0;i<bucketCount;i++){
			qsort(buckets[i], bucketsIndexes[i], sizeof(int), cmpfunc);
		}
		
		//~ for(i=0;i<bucketCount;i++){
			//~ for(j=0;j<bucketsIndexes[i];j++){
				//~ printf("%d ", buckets[i][j]);
			//~ }
			//~ printf("\n");
		//~ }

		double end = omp_get_wtime();
        printf("%d; %d; %.16g; %.16g; %.16g\n", n, threads, end - start_all, end-start_sorting, start_sorting - start_all);
        return 0;
}
