program fpi
  use mpi
  implicit none

    integer ierr, noProc, rank
    integer*8 i, noTrapecios, iterStart, iterStop
! Super importante definir el tipo de dato, en este caso double precision
    double precision startTime, endTime
    double precision sum, x, dx, pi, f

! Parametros
noTrapecios = 10000000

! Inicializa MPI
call MPI_Init(ierr)
call MPI_Comm_size(MPI_COMM_WORLD, noProc, ierr)
call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)

! inicia la putacera
startTime = MPI_Wtime()

dx = 1.0 / noTrapecios
iterStart = 1 + noTrapecios * rank / noProc
iterStop = noTrapecios * (rank + 1) / noProc
sum = 0.0; pi = 0.0

do i = iterStart, iterStop
  x = dx * (i - 0.5)
  f = 4.0 / (1.0 + x * x)
  sum = sum + f
end do

! se ocupa que la variable sea del tipo de dato, doubles con doubles y bla
call MPI_Reduce(sum, pi, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD, ierr)

if (rank == 0) then
  endTime = MPI_Wtime()
  
  print '(a5,1x,f20.10)', 'Time: ', endTime - startTime
  print '(a5,1x,f60.50)', "Pi: ", pi * dx
endif

call MPI_FINALIZE(ierr)

end program fpi
