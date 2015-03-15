#!/usr/bin/env python
from mpi4py import MPI
import sys
from array import array
import numpy

comm = MPI.COMM_WORLD
rank = comm.Get_rank()

if len(sys.argv) < 4:
	print 'Usage ./zad1 <async|sync> <size> <times>'
	sys.exit(1)

type = sys.argv[1]
size = int(sys.argv[2])
times = int(sys.argv[3])
buff = numpy.arange(size, dtype='b')

class Timer(object):
	def __init__(self):
		self.t_start = 0
		self.diff = 0
	def start(self):
		self.t_start = MPI.Wtime() 
	def stop(self):
		t = MPI.Wtime()
		self.diff = t - self.t_start
	def micro_time(self, n):		
		return (1e6*self.diff)/n
		
def sendAsync():
	for i in xrange(0, times):
		comm.Isend(buff, dest=1)

def sendSync():
	for i in xrange(0, times):
		comm.Ssend(buff, dest=1)

def receiveMsg():
	for i in xrange(0, times):
		status = MPI.Status()
		data = comm.Recv(buff, source=0, status=status)


comm.Barrier()  
		
timer = Timer()
if rank == 0:
	timer.start()
	if type == 'sync':
		sendSync();
	else :
		sendAsync();
	timer.stop()
	send_t = timer.micro_time(times)
	comm.send(send_t, dest=1)
elif rank == 1:
	timer.start()
	receiveMsg()
	timer.stop()
	status = MPI.Status()
	data = comm.recv(source=0)
	print str(size)+';'+str(data)+';'+str(timer. micro_time(times))
else :
	print "Expected 2 nodes "

MPI.Finalize()