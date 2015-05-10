#!/usr/bin/python
from mpi4py import MPI
import numpy
import sys

comm = MPI.COMM_WORLD
rank = comm.Get_rank()
size = comm.Get_size()

def main(argv):
	if (len(argv) != 5):
		usage()
		return -1;
	
	method = argv[0]
	count = int(argv[1])
	start_size = int(argv[2])
	end_size = int(argv[3])
	step = int(argv[4])
	
	steps = range(start_size, end_size, step)
	results = {}
	for step in steps:
		results[step] = {}
	
	user_broadcast(count, steps, rank, results)
	std_broadcast(count, steps, rank, results)
	if(rank == 0):
		print_results(results)
	MPI.Finalize()

def usage():
	print "Usage: zad2.py <usr|std> <count> <start_message_size> <end_message_size> <message_size_step>"
	
def std_broadcast(count, steps, rank, results):
	for msg_size in steps:	 
		data = numpy.arange(msg_size, dtype='b')
		
		before = MPI.Wtime()
		for i in xrange(0,count):
			comm.bcast(data, root=0)
		after = MPI.Wtime()
		time = after - before
		
		results[msg_size]['std'] = time / count
	

def user_broadcast(count, steps, rank, results):
	for msg_size in steps: 
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


def print_results(results):
	for i in results:	
		print '{0};{1};{2}'.format(i, results[i]['user'], results[i]['std'])
	
if __name__ == "__main__":
	main(sys.argv[1:])
		
