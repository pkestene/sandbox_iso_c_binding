!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
program test_fortran_thrust

 use wrap_thrust
 use, intrinsic :: iso_c_binding

 implicit none

 integer(kind=c_int32_t)                      :: n = 100
 integer(kind=c_int32_t), dimension(:), allocatable, target :: data
 integer(kind=c_int32_t)                      :: data_sum=0
 integer                                      :: i
 type(c_ptr)                                  :: data_ptr

#ifdef USE_THRUST_OPENMP
 write(*,*) "Test fortran thrust - OpenMP"
#else
 write(*,*) "Test fortran thrust - CUDA"
#endif

 allocate(data(n))

 do i=1,n
    data(i) = i
 end do

 write(*,*) "(native) sum(data)=", SUM(data)
 write(*,*) "N*(N+1)/2=",n*(n+1)/2

 data_ptr = c_loc(data(1))

#ifdef USE_THRUST_OPENMP
 call f_thrust_openmp(data_ptr, size(data), data_sum)
 write(*,*) "(thrust openmp) sum(data)=", data_sum
#else
 call f_thrust_cuda(data_ptr, size(data), data_sum)
 write(*,*) "(thrust cuda) sum(data)=", data_sum
#endif

 deallocate(data)

end program test_fortran_thrust
