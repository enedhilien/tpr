#!/usr/bin/python
from mpi4py import MPI
import numpy
import sys
comm = MPI.COMM_WORLD
rank = comm.Get_rank()
size = comm.Get_size()

########################################
#		   	mapa danych	               #
########################################

result_bcast_times = {}
result_mybcast_times = {}

def my_bcast(data, root):
	if rank == root:
		for j in range(0,size):
			if(j != root):
				comm.send(data, dest=j)
	else:
		comm.recv(source=0)


########################################
#		   	zakres danych              #
########################################

count = 200
min_bytes = 2500
max_bytes = 50001
step = 2500

########################################
#		   	standardowa	               #
########################################

for i in range(min_bytes,max_bytes,step):		 
	msg_size = i
	data = numpy.arange(msg_size, dtype='b')
	
	before = MPI.Wtime()
	for _ in range(0,count):
		comm.bcast(data, root=0)
	after = MPI.Wtime()
	time = after - before
	
	result_bcast_times[msg_size] = time / count
	
########################################
#			   	wlasna	      	       #
########################################

for i in range(min_bytes,max_bytes,step):		 
	
	msg_size = i
	data = numpy.arange(msg_size, dtype='b')
	
	before = MPI.Wtime()
	for _ in range(0,count):
		my_bcast(data, 0)
	after = MPI.Wtime()
	time = after - before
	
	result_mybcast_times[msg_size] = time / count

########################################
#		   	wypisanie danych           #
########################################

if rank == 0:
	print '\nrozmiar\tbcast\tmy_bcast'
	for i in range(min_bytes,max_bytes,step):	
		print '{0};{1};{2}'.format(i, result_bcast_times[i], result_mybcast_times[i])
		
