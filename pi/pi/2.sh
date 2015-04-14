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

ITERATIONS="100000000 1000000000 10000000000"

PROCS="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24"

for ITER in $ITERATIONS
do
        for PROC in $PROCS
        do
                DIVIDED=$((ITER / PROC))
                mpiexec -np $PROC ./rpi ${DIVIDED%%.*} >> rpi.txt		#nieskalowalne
                #mpiexec -np $PROC ./rpi $ITER >> rpi.txt				#skalowalne
        done
done