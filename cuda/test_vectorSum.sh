#!/bin/sh
#PBS -l nodes=1:ppn=1:gpus=1
#PBS -q gpgpu
#PBS -l walltime=00:01:00
module add gpu/cuda
cd /people/plgmatips/tpr/cuda

for SIZE_EXP iin 3 5 7 9
do
i	SIZE=`echo 10^$SIZE_EXP | bc`

	for $ in {1..5}
	do
   		./vectorSum $SIZE 
done
./vectorSum 100 1 
./vectorSum 1000 2
./vectorSum 10000 3
