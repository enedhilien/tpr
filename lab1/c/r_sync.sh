#!/bin/bash
module load libs/boost/1.52.0
module load libs/openblas/0.2.6
module load ruby/2.0.0-p247

NOW=test_c_rsync_$(date "+%F_%T")
PROGRAM="./send_recv"

mkdir $NOW
cp tpr/lab1/c/$PROGRAM.c ./$NOW
cp tpr/lab1/c/Makefile ./$NOW
cd $NOW

make

SIZES="1 64 128 256 1024 2056 4096 1048576 2097152 10485760 104857600"
TIMES="1 10 100 1000 10000 100000 1000000 10000000 100000000"

SIZES="1 100 1000"
TIMES="10 100"

for TIME in $TIMES
do
	echo $TIME >> "ticker"
	for SIZE in $SIZES
	do
		mpiexec -recvtimeout 100 -np 2 $PROGRAM sync $SIZE $TIME >> "sync.out"
	done
done
