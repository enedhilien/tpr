#include <stdio.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h> 
#include <omp.h>
#include <time.h> 

#define BASE_BITS 8
#define BASE (1 << BASE_BITS)
#define MASK (BASE-1)
#define DIGITS(v, shift) (((v) >> shift) & MASK)
#define BILLION 1E9

int omp_lsd_radix_sort(size_t n, unsigned data[n]);

int main(int argc, char *argv[]){
  int problem_size, threads;
  int* to_sort ;
  if (argc < 3){
    printf("usage: %s <problem_size> <threads>", argv[0]);
    exit(1);
  }
  problem_size = atoi(argv[1]);
  threads = atoi(argv[2]);
  to_sort = malloc(problem_size * sizeof(unsigned));

  if (threads)
    omp_set_num_threads(threads);

  srand (time(NULL));

  for (int i=0; i<problem_size; i++){
    to_sort[i] = rand();
  }
  
  struct timespec requestStart, requestEnd;
  clock_gettime(CLOCK_REALTIME, &requestStart);

  int real_threads =  omp_lsd_radix_sort(problem_size, to_sort);

  clock_gettime(CLOCK_REALTIME, &requestEnd);  
  double accum = ( requestEnd.tv_sec - requestStart.tv_sec )  + ( requestEnd.tv_nsec - requestStart.tv_nsec )  / BILLION;

  printf("%d;%lf", real_threads, accum);
}

int omp_lsd_radix_sort(size_t n, unsigned data[n]) {
    unsigned * buffer = malloc(n*sizeof(unsigned));
    int total_digits = sizeof(unsigned)*8;
    int threads = 0;
    //Each thread use local_bucket to move data
    size_t i;
    for(int shift = 0; shift < total_digits; shift+=BASE_BITS) {
        size_t bucket[BASE] = {0};
 
        size_t local_bucket[BASE] = {0}; // size needed in each bucket/thread
        //1st pass, scan whole and check the count
        #pragma omp parallel firstprivate(local_bucket)
        {
            #pragma omp for schedule(static) nowait
            for(i = 0; i < n; i++){
                local_bucket[DIGITS(data[i], shift)]++;
            }
            #pragma omp critical
            for(i = 0; i < BASE; i++) {
                bucket[i] += local_bucket[i];
            }
            #pragma omp barrier
            #pragma omp single
            for (i = 1; i < BASE; i++) {
                bucket[i] += bucket[i - 1];
            }
            int nthreads = threads = omp_get_num_threads();
            int tid = omp_get_thread_num();
            for(int cur_t = nthreads - 1; cur_t >= 0; cur_t--) {
                if(cur_t == tid) {
                    for(i = 0; i < BASE; i++) {
                        bucket[i] -= local_bucket[i];
                        local_bucket[i] = bucket[i];
                    }
                } else { //just do barrier
                    #pragma omp barrier
                }
 
            }
            #pragma omp for schedule(static)
            for(i = 0; i < n; i++) { //note here the end condition
                buffer[local_bucket[DIGITS(data[i], shift)]++] = data[i];
            }
        }
        //now move data
        unsigned* tmp = data;
        data = buffer;
        buffer = tmp;
    }
    free(buffer);
    return threads;
}
