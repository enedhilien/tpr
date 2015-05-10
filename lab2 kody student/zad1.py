#!/usr/bin/python
from mpi4py import MPI
import numpy
import sys

comm = MPI.COMM_WORLD
rank = comm.Get_rank()
size = comm.Get_size()

count = int(sys.argv[2])

comm.Barrier()
before = MPI.Wtime()

for i in range(0,count):		 
	comm.Barrier()
	
after = MPI.Wtime()
result = (after-before)/count
	
if rank == 0:
	print '{0};{1};{2}'.format(size, count, result)
