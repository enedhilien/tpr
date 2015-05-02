#!/bin/bash
make
PROGRAM="./send_recv"

SIZES="1 6 7 8 9 10 16 17 31 32 33 62 63 64 65 66 126 127 128 129 130 500 1000 10000 100000 1000000"
TIMES="1 10 100 1000 "
rm ./*.out
for TIME in $TIMES
do
	for SIZE in $SIZES
	do
		mpiexec -np 2 $PROGRAM async $SIZE $TIME >> "async.out"
	done
	for SIZE in $SIZES
	do
		mpiexec -np 2 $PROGRAM sync $SIZE $TIME >> "sync.out"
	done
done
#./plotter2.py ./ sync.out async.out
