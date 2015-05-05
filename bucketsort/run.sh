#!/bin/bash
module load libs/boost/1.52.0
module load libs/openblas/0.2.6
module load ruby/2.0.0-p247

NOW=$1_$(date "+%F_%T")

mkdir $NOW
cp bucket.c ./$NOW
cd $NOW

chmod +x ./bucket.c

gcc -fopenmp bucket.c -o bucket -D SCHEDULE_TYPE=$2
chmod u+x ./bucket

ITERATIONS="100000 10000000 100000000 1000000000 1000000000 1000000000"

THREADS="1 2 4 8 12"

BUCKETS="5 10 15 20 40 60 80 100"

ITERATIONS="1000"

THREADS="1 2"

BUCKETS="10"

for THREAD IN THREADS
do
        for ITER in $ITERATIONS
        do
			for BUCKET in $BUCKETS
			do
				./bucket $ITER $THREAD $BUCKET >> bucket.out
			done
        done
done
