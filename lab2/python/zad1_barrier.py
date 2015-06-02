#!/usr/bin/python
from mpi4py import MPI
import numpy
import sys
comm = MPI.COMM_WORLD
rank = comm.Get_rank()

count = 10000

########################################
#		   		barrier	               #
########################################

comm.Barrier()
before = MPI.Wtime()

for i in range(0,count):		 
	comm.Barrier()
	
after = MPI.Wtime()
time = after - before
result = time/count
	
if rank == 0:
	print result
