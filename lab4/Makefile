EXECS=matrix
MPICC?=mpicc

all: ${EXECS}

matrix: matrix.c
	${MPICC} -o matrix matrix.c -std=c99
