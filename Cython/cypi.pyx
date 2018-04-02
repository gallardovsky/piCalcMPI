from mpi4py import MPI
import numpy as np

cpdef double cypi(noTrap):
# Inicializar variables
    cdef long long noTrapecios = noTrap
    cdef long long int i = 0
    cdef double f = 0.0
    cdef double sum = np.float64(0.0)

# Inicializa MPI

    comm = MPI.COMM_WORLD
    cdef int noProcs = comm.Get_size()
    cdef int rank = comm.Get_rank()

    startTime = MPI.Wtime()
# Inicia la putacera

    cdef double dx = 1.0 / noTrapecios
    cdef long long int iterStart = 1 + noTrapecios * rank / noProcs
    cdef long long int iterStop = noTrapecios * (rank + 1) / noProcs

    for i in xrange(iterStart, iterStop):
        x = dx * (i - 0.5)
        f = 4.0 / (1.0 + x * x)
        sum += f

    pi = np.float64(0.0)

    pi = comm.reduce(sum, MPI.SUM, 0)

    if rank == 0:
        endTime = MPI.Wtime()
        print ('''
        Pi = %10.50f
        time = %6.10f
            ''' \
        % (pi * dx, endTime - startTime))
