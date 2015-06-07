#!/bin/sh
#PBS -l nodes=1:ppn=1:gpus=1
#PBS -q gpgpu
#PBS -l walltime=00:00:50
module add gpu/cuda
cd /people/plgmatips/tpr/cuda3/

echo "Global: "
./FD_2D_global

echo "Shared: "
./FD_2D_shared

echo "Texture pad: "
./FD_2D_texture_pad