SRC=${EXEC:%=%.cu}
MPICC?=nvcc

all: ${EXEC}

${EXEC}: $(SRC)
	${MPICC} -o ${EXEC} $(SRC) -std=c99
