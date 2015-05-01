#!/bin/bash
module add plgrid/tools/python
module add plgrid/libs/python-numpy
module add plgrid/tools/openmpi/1.6.5-gnu-4.9.2-ib

NOW=$(date "+%F_%T")

mkdir $NOW
cp tpr/lab1/python/zad1.py- ./$NOW
cd $NOW

chmod u+x ./zad1.py

SIZES="1 6 7 8 9 10 16 17 31 32 33 62 63 64 65 66 126 127 128 129 130 500 1000 10000 100000 1000000 10000000 100000000 1000000000"
TIMES="1 10 100 1000 10000 100000 1000000 10000000 100000000"

SIZES="1 6 7 8 9 10 16 17 31 32 33 62 63 64 65 66"
TIMES="1 10 100"

for TIME in $TIMES
do
	echo $TIME >> "ticker"
	for SIZE in $SIZES
	do
		mpiexec -np 2 ./zad1.py async $SIZE $TIME >> "async.out"
	done
	for SIZE in $SIZES
	do
		mpiexec -np 2 ./zad1.py sync $SIZE $TIME >> "sync.out"
	done
done
