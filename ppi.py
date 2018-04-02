import numpy as np
from mpi4py import MPI

# Inicializa MPI
noTrapecios = 10000000

comm = MPI.COMM_WORLD
noProcs = comm.Get_size()
rank = comm.Get_rank()

# Inicia la putacera
startTime = MPI.Wtime()

dx = 1.0 / noTrapecios
iterStart = 1 + noTrapecios * rank // noProcs
iterStop = noTrapecios * (rank + 1) // noProcs
sum = np.float64(0.0)

for i in range(iterStart, iterStop):
    x = dx * (i - 0.5)
    f = 4.0 / (1.0 + x * x)
    sum += f

pi = np.float64(0.0)
pi = comm.reduce(sum, MPI.SUM, 0)

if rank == 0:
    endTime = MPI.Wtime()
    print ('''
    Pi = %10.52f
    time = %6.12f
        ''' \
    % (pi * dx, endTime - startTime))
