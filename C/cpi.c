#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <mpi.h>

int main (int argc, char **argv)
{
  // Definicion de variables
  int noProcs, rank;
  long long int i, noTrapecios, iterStart, iterStop;
  double startTime, endTime;
  double sum, f, x, dx, pi;

  // Parametros
  noTrapecios = 1e7;

  // Inicializa MPI
  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &noProcs);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  // Inicia la putacera
  startTime = MPI_Wtime();

  dx = 1.0 / noTrapecios;
  iterStart = 1 + noTrapecios * rank / noProcs;
  iterStop = noTrapecios * (rank + 1) / noProcs;
  sum = 0.0;

  for (i = iterStart; i <= iterStop; i++)
    {
      x = dx * (i - 0.5);
      f = 4.0 / (1.0 + x * x);
      sum += f;
    }

  MPI_Reduce(&sum, &pi, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);

      if (rank == 0)
      {
        endTime = MPI_Wtime();
        printf("Pi = %.50f\n", pi * dx);
        printf("Time = %.10f\n", endTime - startTime);
      }

    MPI_Finalize();
    return 0;
}
