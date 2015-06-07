#!/bin/sh
#PBS -l nodes=1:ppn=1
#PBS -q plgrid
#PBS -l walltime=04:00:00
module add gpu/cuda
cd /people/plgmatips/tpr/cuda3/

OUT_FILE="out/16_cpu.csv"
#echo "net size, cpu [s]" > $OUT_FILE

for SIZE in 1280 1536 1792 2048 2560 3072 3584 4096 5120 6144 7168 8192
do
    echo -n $SIZE ", "
    ./FD_2D_cpu $SIZE
    echo ""
done >> $OUT_FILE
