#!/bin/bash
module add plgrid/tools/python
module add plgrid/libs/python-numpy
module add plgrid/tools/openmpi/1.6.5-gnu-4.9.2-ib

DIRNAME=lab2_small3
FILENAME=$1
METHOD=$2
TYPE=$3
PROGRAM=${FILENAME}.py
NOW=$DIRNAME/${FILENAME}_${METHOD}_${TYPE}

mkdir $NOW
cp 'tpr/lab2 kody student'/$PROGRAM $NOW
cd $NOW
chmod u+x ./$PROGRAM

ITERATIONS="1000000"
SIZES="100 1000 10000 100000 100000 100000000 1000000000000"
PROCS="1 2 4 8 12 16 20 24"

#ITERATIONS="10 100"
#SIZES="25 50 75"
#PROCS="1 2"

echo $METHOD >> opts
echo $FILENAME >> opts

for PROC in $PROCS
do
        for ITER in $ITERATIONS
        do
		for SIZE in $SIZES
               	do
			DIVIDED=$((ITER / PROC))
                	mpiexec -np $PROC ./$PROGRAM $METHOD ${DIVIDED%%.*} $SIZE >> $FILENAME.out		#nieskalowalne
#                	mpiexec -np $PROC ./$PROGRAM $METHOD $ITER $SIZE >> skal_$FILENAME.out		#skalowalne
		done
        done
done
