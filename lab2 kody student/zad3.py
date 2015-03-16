#!/usr/bin/python
from mpi4py import MPI
import numpy
import sys
comm = MPI.COMM_WORLD
rank = comm.Get_rank()
size = comm.Get_size()
########################################
#		   	mapy danych	               #
########################################

def my_Reduce_scatter(sendbuf, recvbuf, recvcounts):
	currentIndex = 0
	for i in range(0,len(recvcounts)):
		if i == rank:
			#TO JEST ZE DO RECV BUF PRZEPISUJEMY SAMEGO SIEBIE
			dupa = sendbuf[currentIndex:currentIndex+recvcounts[i]]	
			for p in range(0, size):
				if rank != p:
					recvbuf = comm.recv(source=p)
					#print rank, "odbieram", odebrane
					for k in range(0, recvcounts[i]):
						dupa[k] += recvbuf[k]
			recvbuf = dupa
			#print recvbuf
		else:
			comm.send(sendbuf[currentIndex:currentIndex+recvcounts[i]], dest=i)
			#print rank, "wysylam"
		currentIndex += recvcounts[i]
		
########################################
#		   	mapy danych	               #
########################################

result_reduce_scatter_times = {}
result_my_reduce_scatter_times = {}

########################################
#		   	zakres danych              #
########################################

count = 20
min_bytes = 2400/4
max_bytes = min_bytes * 10 + 1
step = min_bytes


########################################
#		   	standardowa	               #
########################################

for msg_size in range(min_bytes,max_bytes,step):		 
	send_buf = numpy.arange(msg_size, dtype='i')
	recv_buf = numpy.arange(msg_size/size, dtype='i')
	recv_counts = [msg_size/size for i in range(size)]
	before = MPI.Wtime()
	for _ in range(0,count):
		comm.Reduce_scatter(send_buf, recv_buf, recv_counts, MPI.SUM)
	after = MPI.Wtime()
	time = after - before
	result = time/count
	result_reduce_scatter_times[msg_size] = result

########################################
#		  	 	wlasna		           #
########################################

for msg_size in range(min_bytes,max_bytes,step):		 
	send_buf = numpy.arange(msg_size, dtype='i')
	recv_buf = numpy.arange(msg_size/size, dtype='i')
	recv_counts = [msg_size/size for i in range(size)]
	before = MPI.Wtime()
	for _ in range(0,count):
		my_Reduce_scatter(send_buf, recv_buf, recv_counts)
	after = MPI.Wtime()
	time = after - before
	result = time/count
	result_my_reduce_scatter_times[msg_size] = result

########################################
#		   	wypisanie danych           #
########################################

if rank == 0:
	print '\nrozmiar\treduce_scatter\tmy_reduce_scatter'
	for i in range(min_bytes,max_bytes,step):	
		print '{0}\t{1}\t{2}'.format(i, result_reduce_scatter_times[i], result_my_reduce_scatter_times[i])
		
