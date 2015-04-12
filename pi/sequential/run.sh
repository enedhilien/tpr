#!/bin/bash
module load libs/boost/1.52.0
module load libs/openblas/0.2.6
module load ruby/2.0.0-p247
module add plgrid/tools/python
module add plgrid/libs/python-numpy
module add plgrid/tools/openmpi/1.6.5-gnu-4.9.2-ib

pip install --user mpi4py

NOW=$(date "+%F_%T")

mkdir $NOW
cp tpr/pi/sequential/pi.py ./$NOW
cd $NOW

chmod u+x ./pi.py

mpiexec -np 5 ./pi.py 1000 >> rpi.csv
#mpiexec -np 1 ./pi 10000 >> pi.txt
#mpiexec -np 1 ./pi 100000 >> pi.txt
#mpiexec -np 1 ./pi 100000 >> pi.txt
