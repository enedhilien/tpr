#!/bin/bash

#~ rm *.out
#~ mpiexec -np 8 ./zad1.py 100 >> "barrier.out"
#~ mpiexec -np 8 ./zad2.py std 100 250 >> "bcast.out"
#~ mpiexec -np 8 ./zad3.py user 100 250 >> "scatter.out"
#~ 
DIRNAME=lab2
FILENAME=${1}
PROGRAM=${FILENAME}.py
METHOD=${2}
NOW=$DIRNAME/${FILENAME}_$(date "+%F_%T")

mkdir $NOW
cp ./$PROGRAM $NOW
cd $NOW
chmod u+x ./$PROGRAM

ITERATIONS="10000 100000 1000000 10000000 100000000 1000000000 10000000000"
PROCS="1 2 4 8 12 20 24"


ITERATIONS="100 1000"
PROCS="1 2 4 8"



for PROC in $PROCS
do
        for ITER in $ITERATIONS
        do
                DIVIDED=$((ITER / PROC))
                mpiexec -np $PROC ./$PROGRAM $METHOD ${DIVIDED%%.*} $ITER >> $FILENAME.out		#nieskalowalne
                mpiexec -np $PROC ./$PROGRAM $METHOD $ITER $ITER >> skal_$FILENAME.out		#skalowalne
        done
done
