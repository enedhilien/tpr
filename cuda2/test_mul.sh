#!/bin/sh
#PBS -l nodes=1:ppn=1:gpus=1
#PBS -q gpgpu
#PBS -l walltime=00:20:00
module add gpu/cuda
cd /people/plgmatips/tpr/cuda2/matrixs/

mkdir -p results
#usage: %s <matrixA> <matrixB> <outputC> <Width> <block_size> <tires>

echo "size;width;height;block_size;tries;time"
../matrixMultiplication A_18x18.txt B_18x18.txt C_18x18.out 18   18  500
../matrixMultiplication A_64x64.txt B_64x64.txt C_64x64.out 64   64  400
../matrixMultiplication A_128x128.txt B_128x128.txt C_128x128.out 128  128 300
../matrixMultiplication A_256x256.txt B_256x256.txt C_256x256.out 256  256 200
../matrixMultiplication A_320x320.txt B_320x320.txt C_320x320.out 320  320 150
../matrixMultiplication A_512x512.txt B_512x512.txt C_512x512.out 512  512 100
../matrixMultiplication A_640x640.txt B_640x640.txt C_640x640.out 640  640 100
../matrixMultiplication A_1024x1024.txt B_1024x1024.txt C_1024x1024.out 1024 1024 100
