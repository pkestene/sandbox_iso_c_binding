#include <stdint.h>
#include <stdio.h>
#include <mpi.h>
/**
 * interface to fortran implementation
 */
void mpi_sum_int_c(int32_t* array, int32_t array_size, MPI_Fint* comm, int32_t* ierr);

void do_stuff(int32_t* dataf,
              int32_t dataf_size,
              MPI_Fint* f_comm,
              int32_t nproc)
{
  int nbTask=-1, myRank=-1;
  int32_t ierr = 1;

  // retrieve MPI communicator
  MPI_Comm comm = MPI_Comm_f2c(*f_comm);

  MPI_Comm_size(comm, &nbTask);
  MPI_Comm_rank(comm, &myRank);

  printf("[C] rank%d nproc=%d\n",myRank,nproc);

  // now call a fortran implemented subroutine
  mpi_sum_int_c(dataf, dataf_size, f_comm, &ierr);

  printf("mpi_sum_int_c call with error status %d\n",ierr);

}
