import numpy
from mpi4py import MPI
comm = MPI.COMM_WORLD

rank = comm.Get_rank()
rankF = numpy.array(float(rank))
total = numpy.zeros(1)
comm.Reduce(rankF, total, op=MPI.MAX)
if rank==0:
    print total