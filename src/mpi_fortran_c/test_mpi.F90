program test_mpi

  use mpi
  use mpi_utils
  use do_stuff_wrap
  use, intrinsic :: iso_c_binding

  implicit none

  integer   :: nbTask, myRank, ierr, i

  integer(kind=c_int32_t), allocatable, target :: data(:)
  integer                                      :: data_size=12


  call MPI_Init(ierr)

  call MPI_COMM_SIZE(MPI_COMM_WORLD, nbTask, ierr)
  call MPI_COMM_RANK(MPI_COMM_WORLD, myRank, ierr)

  write (*,*) 'I am task', myRank, 'out of',nbTask

  allocate(data(data_size))


  ! step 1
  ! just perform a MPI_Allreduce directly from Fortran
  do i=1,data_size
     data(i) = data_size*myrank + i
  end do

  call mpi_sum_int(data, MPI_COMM_WORLD, ierr)

  write(*,*) "[F] ", "rank", myRank, "| step1 |", data

  ! step 2 (should give the same results as step 1)
  ! perform a MPI_Allreduce from a fortran subroutine call by a C function, itself called here
  ! just checking all parameters are passed correctly back and forth between fortran and C
  do i=1,data_size
     data(i) = data_size*myrank + i
  end do

  call f_do_stuff(c_loc(data(1)), size(data), MPI_COMM_WORLD, nbTask)

  write(*,*) "[F] ", "rank", myRank, "| step2 |", data

  deallocate(data)
  call MPI_Finalize(ierr)

end program test_mpi
