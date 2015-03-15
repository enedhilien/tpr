#!/bin/bash

COUNT=10000
BYTES="1 2 3 4 5 6 7 8 9 10 20 30 40 50 60 70 80 90 100 125 150 200 250 300 400 500 750 1000 1400 1800 2400 3000 3500 4000 4500 5000 6000 7000 8000 9000 10000 12500 15000 17500 20000 25000 40000 70000 100000 150000 200000 400000 600000 800000 1000000"

touch async.out
touch sync.out

echo "Msg[B];Send[us];Recv[us]" > async.out
echo "Msg[B];Send[us];Recv[us]" > sync.out

make
PROGRAM="./send_recv"

for BYTE in $BYTES
do
	mpiexec -recvtimeout 100 -machinefile ../mpihosts -np 2 ${PROGRAM} async $BYTE $COUNT >> async.out
	mpiexec -recvtimeout 100 -machinefile ../mpihosts -np 2 ${PROGRAM} sync $BYTE $COUNT >> sync.out
done



