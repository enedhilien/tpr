import sys
from random import random, seed
from math import pow, sqrt
from mpi4py import MPI
import numpy as np

comm = MPI.COMM_WORLD
rank = comm.Get_rank()
size = comm.Get_size()
start_time = MPI.Wtime()
f = open("/dev/urandom", "rb")
rnd_str = f.read(4)
seed(rnd_str)
f.close()

comm.Barrier()
def main(argv):
    tries = int(argv[0])
    hits = 0
    throws = 0
    result = np.zeros(1)
    for i in range (1, tries):
        throws += 1
        x = random()
        y = random()
        dist = sqrt(pow(x, 2) + pow(y, 2))
        if dist <= 1.0:
            hits += 1.0

    # hits / throws = 1/4 Pi
    pi = np.zeros(1)
    pi[0] = 4 * (hits / throws)
    comm.Reduce(pi, result, op=MPI.SUM)
    if rank == 0:
        # iterations procesors time result
        print u"{0:d};{1:d};{2:.16f};{3:.15f};".format(tries, size, MPI.Wtime() - start_time, (result[0]/size))
    MPI.Finalize()



if __name__ == "__main__":
    main(sys.argv[1:])