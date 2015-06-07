#!/bin/sh
#PBS -l nodes=1:ppn=1:gpus=1
#PBS -q gpgpu
#PBS -l walltime=02:00:00
module add gpu/cuda
cd /people/plgmatips/tpr/cuda

mkdir -p x_size_II
MAX_SIZE=`echo 10^9 | bc`
for BLOCK_SIZE in 1024 768 512 256 128 64 16 8 2 1
do	
        LOG_FILE="x_size_II/stats_${BLOCK_SIZE}.csv"
        echo "vector_size; nblocks; blocksize; time; cpu_time; incorret" > $LOG_FILE

        for SIZE in {1000..600000..1000}
        do
                ./vectorSum $SIZE $BLOCK_SIZE 100 >> $LOG_FILE
        done

done

