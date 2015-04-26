SRC=${EXEC:%=%.c}
MPICC?=mpicc

all: ${EXEC}

${EXEC}: $(SRC)
	${MPICC} -o ${EXEC} $(SRC) -std=c99
