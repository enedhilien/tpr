#!/bin/bash

COUNT=10
MSG_SIZE=100
declare -a arr=("../mpihosts-8pr-1rdz" "../mpihosts-4pr-2rdz" "../mpihosts-2pr-4rdz")

touch results.out
echo "mpihosts file;       zad;            std;           my" > results.out

make EXEC="zad1"
make EXEC="zad2_bcast"
make EXEC="zad2_scatter"

for mpihosts in "${arr[@]}"
do
	
	echo -n $mpihosts >> 	results.out
	echo -n "; zad1;          " >> 	results.out

	mpiexec -recvtimeout 100 -machinefile $mpihosts -np 8 ./zad1 $COUNT >> results.out
	
	echo "" >> results.out
	echo -n $mpihosts       >> 	results.out
	echo -n "; zad1_bcast;    "  >> 	results.out

	mpiexec -recvtimeout 100 -machinefile $mpihosts -np 8 ./zad2_bcast std $MSG_SIZE $COUNT >> results.out
	mpiexec -recvtimeout 100 -machinefile $mpihosts -np 8 ./zad2_bcast user $MSG_SIZE $COUNT >> results.out
	
	echo "" >> results.out
	echo -n  $mpihosts        >> 	results.out
	echo -n  "; zad2_scatter;  " >> 	results.out

	mpiexec -recvtimeout 100 -machinefile $mpihosts -np 8 ./zad2_scatter std $MSG_SIZE $COUNT >> results.out
	mpiexec -recvtimeout 100 -machinefile $mpihosts -np 8 ./zad2_scatter user $MSG_SIZE $COUNT >> results.out
	
	echo "" >> results.out
done

