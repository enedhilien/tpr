#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

int main(int argc, char **argv){
int loops = 5000;
int a,i;
omp_sched_t schedule_type;
#pragma omp parallel for shared(i,a)
for(i=0;i<loops;i++){
	a++;
	//printf("%d\n", omp_get_num_threads());
	omp_get_schedule(&schedule_type, &loops);
	printf("%d\n", schedule_type);
}

}
