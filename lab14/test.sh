#PBS -l walltime=00:20:00
#PBS -l nodes=1:ppn=12

#if [ "$#" -ne 1 ]; then
#	echo "Usage: " $0 "<problem size>"
#	exit
#fi

NPROCS="1 2 3 4 5 6 7 8 9 10 11 12"
SIZES="100000 1000000 1000000000 100000000000"

mkdir -p ./out
for SIZE in $SIZES
do	
	touch ./out/out_$SIZE.txt
	echo "threads;time" > ./out/out_$SIZE.txt

	for NPROC in $NPROCS
	do
		./a.out $SIZE $NPROC >> ./out/out_$SIZE.txt
	done
done
