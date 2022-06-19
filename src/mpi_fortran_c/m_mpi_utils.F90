module mpi_utils

  use mpi
  use, intrinsic :: iso_c_binding

  implicit none

contains

  subroutine mpi_sum_int(data, comm, ierr)

    ! dummy args
    integer(kind=c_int32_t), intent(inout) :: data(:)
    integer                 ,intent(in)    :: comm
    integer                 ,intent(out)   :: ierr

    ! local vars
    integer :: data_size
    integer, allocatable :: xsum(:)

    ierr = 0

    if (comm /= MPI_COMM_SELF .and. comm /= MPI_COMM_NULL) then

       data_size = size(data)

       !  Accumulate data on all proc. in comm
       allocate(xsum(data_size))
       call MPI_ALLREDUCE(data,xsum,data_size,MPI_INTEGER,MPI_SUM,comm,ierr)
       data(:) = xsum(:)
       deallocate(xsum)

    end if

  end subroutine mpi_sum_int

  !> wrapper arround mpi_sum_int than can be called in C/CUDA
  !! this routine is only meant to be called from C/CUDA
  subroutine mpi_sum_int_c(data_ptr,data_size,comm,ier) bind(c, name="mpi_sum_int_c")

    use, intrinsic :: iso_c_binding, only: c_associated,c_loc,c_ptr,c_f_pointer,c_int32_t
    implicit none

    ! dummy args
    type(c_ptr)            , value, intent(in)  :: data_ptr
    integer(kind=c_int32_t), value, intent(in)  :: data_size
    integer(kind=c_int32_t),        intent(in)  :: comm
    integer(kind=c_int32_t),        intent(out) :: ier

    ! local vars
    integer(kind=c_int32_t), pointer              :: data(:) => null()

    ! convert the c pointer into a fortran array
    call c_f_pointer(data_ptr, data, [data_size])

    call mpi_sum_int(data, comm, ier)

  end subroutine mpi_sum_int_c

end module mpi_utils
