#!/bin/bash
module load libs/boost/1.52.0
module load libs/openblas/0.2.6
module load ruby/2.0.0-p247

NOW=$(date "+%F_%T")

mkdir $NOW
cp rpi.c ./$NOW
cd $NOW

chmod +x ./rpi.c

mpicc -lm rpi.c -o rpi

ITERATIONS="10000 100000 1000000 10000000 100000000 1000000000 10000000000"

PROCS="1 2 4 8 12 20 24"

for PROC in $PROCS
do
        for ITER in $ITERATIONS
        do
                DIVIDED=$((ITER / PROC))
                mpiexec -np $PROC ./rpi ${DIVIDED%%.*} $ITER >> rpi1.txt		#nieskalowalne
				#mpiexec -np $PROC ./rpi $ITER $ITER >> rpi1_skal.txt				#skalowalne
        done
done
