#!/bin/sh
#PBS -l nodes=1:ppn=1:gpus=1
#PBS -q gpgpu
#PBS -l walltime=05:00:00
module add gpu/cuda
cd /people/plgmatips/tpr/cuda3/

OUT_FILE="out/16_gpu.csv"
echo "net size, block size, global [s], shared [s], texture pad [s]" > $OUT_FILE

for SIZE in 32 64 96 128 160 192 224 256 384 512 640 768 896 1024 1280 1536 1792 2048 2560 3072 3584 4096 5120 6144 7168 8192
do
    echo -n $SIZE ", 16, "
    ./FD_2D_global $SIZE
    echo -n ", "
    ./FD_2D_shared $SIZE
    echo -n ", "
    ./FD_2D_texture_pad $SIZE
    echo ""
done >> $OUT_FILE
