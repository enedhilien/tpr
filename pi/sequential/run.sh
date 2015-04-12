#!/bin/bash
module load libs/boost/1.52.0
module load libs/openblas/0.2.6
module load ruby/2.0.0-p247

pip install --user mpi4py

NOW=$(date "+%F_%T")

mkdir $NOW
cp rpi.c ./$NOW
cd $NOW

chmod u+x ./pi.py

mpiexec -np 1 ./rpi 1000 >> rpi.csv
#mpiexec -np 1 ./pi 10000 >> pi.txt
#mpiexec -np 1 ./pi 100000 >> pi.txt
#mpiexec -np 1 ./pi 100000 >> pi.txt