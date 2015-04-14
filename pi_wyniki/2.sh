#!/bin/bash
module load libs/boost/1.52.0
module load libs/openblas/0.2.6
module load ruby/2.0.0-p247

NOW=$(date "+%F_%T")

cd pi
mkdir $NOW
cp rpi.c ./$NOW
cd $NOW

chmod +x ./rpi.c

mpicc -lm rpi.c -o rpi

ITERATIONS="10000000000"

PROCS="13 14 15 16 17 18 19 20 21 22 23 24"

for ITER in $ITERATIONS
do
        for PROC in $PROCS
        do
                DIVIDED=$((ITER / PROC))
                #mpiexec -np $PROC ./rpi ${DIVIDED%%.*} >> rpi2.txt		#nieskalowalne
                mpiexec -np $PROC ./rpi $ITER >> rpi2_skal.txt				#skalowalne
        done
done
