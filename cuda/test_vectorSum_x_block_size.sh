#!/bin/sh
#PBS -l nodes=1:ppn=1:gpus=1
#PBS -q gpgpu
#PBS -l walltime=00:40:00
module add gpu/cuda
cd /people/plgmatips/tpr/cuda

mkdir -p x_block_size
MAX_SIZE=`echo 10^9 | bc`
for SIZE in 524288 600000
do	
	LOG_FILE="x_block_size/stats_${SIZE}.csv"
	echo "vector_size; nblocks; blocksize; time; cpu_time; incorret" > $LOG_FILE

	for BLOCK_SIZE in {1..1050}
	do	
   		./vectorSum $SIZE $BLOCK_SIZE 100 >> $LOG_FILE
	done


done

