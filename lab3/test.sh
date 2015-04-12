#!/bin/bash

echo $(date) "start"

out=result_$(date +'%s').out
touch $out
echo "Problem size, size per proc, procs, t1, t2, t3, t4, pi" > $out

make EXEC="pi"

NPROCS="2 3 4 5 6 7 8 9 10 11 12"
SIZES="1e7 5e7 1e8"

mpiexec -recvtimeout 100 -machinefile ./mpihosts -np 1 ./pi 1 T >> $out

for SIZE in $SIZES
do
	mpiexec -recvtimeout 100 -machinefile ./mpihosts -np 1 ./pi $SIZE T >> $out
	for NPROC in $NPROCS
	do
		mpiexec -recvtimeout 100 -machinefile ./mpihosts -np $NPROC ./pi $SIZE T >> $out
		mpiexec -recvtimeout 100 -machinefile ./mpihosts -np $NPROC ./pi $SIZE F >> $out
	done
	echo $(date) $SIZE
done

echo $(date) 
