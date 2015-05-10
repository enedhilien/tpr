#!/usr/bin/python
from mpi4py import MPI
import numpy
import sys
import copy

comm = MPI.COMM_WORLD
rank = comm.Get_rank()
size = comm.Get_size()

def main(argv):
	if (len(argv) != 3):
		usage()
		return -1;
	
	method = argv[0]
	count = int(argv[1])
	msg_size = int(argv[2])

	results = {}
	results[msg_size] = {}
	
	if method == 'user':
		user_scatter(count, msg_size, results)
	elif method == 'std':
		std_scatter(count, msg_size, results)
	
	if(rank == 0):
		print_results(results, method)
	MPI.Finalize()

def usage():
	print "Usage: zad3.py <user|std> <count> <message_size>"
	
def std_scatter(count, msg_size, results):
	data = numpy.arange(msg_size-1, dtype='b')
	chunk_size = len(data)/size
	send_buf = numpy.array_split(data, size)
	
	before = MPI.Wtime()
	for _ in xrange(0, count):
		comm.scatter(send_buf, root=0)
	after = MPI.Wtime()
	
	results[msg_size]['std'] = (after - before)/count
	

def user_scatter(count, msg_size, results):
	data = numpy.arange(msg_size-1, dtype='b')
	chunk_size = len(data)/size
	send_buf = numpy.array_split(data, size)
	recv_buf = numpy.empty(chunk_size, dtype='b')
	before = MPI.Wtime()
	for _ in xrange(0, count):
		user_reduce_scatter(data, root=0, recv_buf=recv_buf)
	after = MPI.Wtime()
	
	results[msg_size]['user'] = (after - before)/count


def user_reduce_scatter(data, recv_buf,root = 0):
	if rank == root:
		for i in xrange(0,size):
			if(i != root):
				comm.send(data[i], dest=i)
			else:
				recv_buf = copy.deepcopy(data[i])
	else:
		comm.recv(source=0)


def print_results(results, method):
	for i in results:	
		print '{0};{1};{2};{3}'.format(method, size, i, results[i][method])
	
if __name__ == "__main__":
	main(sys.argv[1:])
		
