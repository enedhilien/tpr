#!/usr/bin/env python
from mpi4py import MPI
import numpy
import sys

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
		user_broadcast(count, msg_size, results)
	elif method == 'std':
		std_broadcast(count, msg_size, results)
	
	if(rank == 0):
		print_results(results, method, count)
	MPI.Finalize()

def usage():
	print "Usage: zad2.py <user|std> <count> <message_size>"
	
def std_broadcast(count, msg_size, results):
	data = numpy.arange(msg_size, dtype='b')
	
	before = MPI.Wtime()
	for i in xrange(0,count):
		comm.bcast(data, root=0)
	after = MPI.Wtime()
	time = after - before
	
	results[msg_size]['std'] = time / count
	

def user_broadcast(count, msg_size, results):
	data = numpy.arange(msg_size, dtype='b')
	
	before = MPI.Wtime()
	for i in xrange(0,count):
		send_broadcast(data, 0)
	after = MPI.Wtime()
	time = after - before
	
	results[msg_size]['user'] = time / count


def send_broadcast(data, root):
	if rank == root:
		for j in xrange(0,size):
			if(j != root):
				comm.send(data, dest=j)
	else:
		comm.recv(source=0)


def print_results(results, method, count):
	for i in results:	
		print '{0};{1};{2};{3}'.format(method, size, i, count, results[i][method])
	
if __name__ == "__main__":
	main(sys.argv[1:])
		
