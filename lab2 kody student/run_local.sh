#!/bin/bash


mpiexec -np 8 ./zad1.py usr 100 250 1001 250 >> "scatter.out"
mpiexec -np 8 ./zad2.py usr 100 250 1001 250 >> "bcast.out"
mpiexec -np 8 ./scatter.py usr 100 250 1001 250 >> "scatter.out"

PROGRAM = zad1.py
ITERATIONS="10000 100000 1000000 10000000 100000000 1000000000 10000000000"
PROCS="1 2 4 8 12 20 24"
NOW=$PROGRAM_$(date "+%F_%T")

ITERATIONS="100 1000"
PROCS="1 2 4 8"

mkdir $NOW
cp ./$PROGRAM $NOW
cd $NOW
chmod u+x ./$PROGRAM

for PROC in $PROCS
do
        for ITER in $ITERATIONS
        do
                DIVIDED=$((ITER / PROC))
                mpiexec -np $PROC ./$PROGRAM ${DIVIDED%%.*} $ITER >> $PROGRAM.out		#nieskalowalne
                mpiexec -np $PROC ./$PROGRAM $ITER $ITER >> skal_$PROGRAM.out		#skalowalne
				#mpiexec -np $PROC ./rpi $ITER $ITER >> rpi1_skal.txt				#skalowalne
        done
done
