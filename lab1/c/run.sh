#!/bin/bash
module load libs/boost/1.52.0
module load libs/openblas/0.2.6
module load ruby/2.0.0-p247

NOW=$(date "+%F_%T")

mkdir $NOW
cp tpr/lab1/python/zad1.py ./$NOW
cd $NOW

chmod u+x ./zad1.py

SIZES="1 64 128 256 1024 2056 4096 1048576 2097152 10485760 104857600"
TIMES="1 10 100 1000 10000 100000 1000000 10000000 100000000"

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
