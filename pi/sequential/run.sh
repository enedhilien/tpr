#!/bin/bash
#module load libs/boost/1.52.0
#module load libs/openblas/0.2.6
#module load ruby/2.0.0-p247
module load plgrid/tools/python
module load plgrid/libs/python-numpy
module load plgrid/tools/openmpi/1.6.5-gnu-4.9.2-ib

NOW=$(date "+%F_%T")

mkdir $NOW
cp tpr/pi/sequential/pi.py ./$NOW
cd $NOW

chmod u+x ./pi.py

mpiexec -np 1 ./pi.py 1000 >> rpi.csv
#mpiexec -np 1 ./pi 10000 >> pi.txt
#mpiexec -np 1 ./pi 100000 >> pi.txt
#mpiexec -np 1 ./pi 100000 >> pi.txt
