module wrap_thrust

 use, intrinsic :: iso_c_binding

 interface

#ifdef USE_THRUST_OPENMP
    subroutine f_thrust_openmp(data_ptr, data_size, data_sum) bind(c, name='test_thrust_openmp')
      use, intrinsic :: iso_c_binding
      implicit none
      type(c_ptr)            , value             :: data_ptr
      integer(kind=c_int32_t), value, intent(in) :: data_size
      integer(kind=c_int32_t)                    :: data_sum
    end subroutine f_thrust_openmp
#endif

#ifdef USE_THRUST_CUDA
    subroutine f_thrust_cuda(data_ptr, data_size, data_sum) bind(c, name='test_thrust_cuda')
      use, intrinsic :: iso_c_binding
      implicit none
      type(c_ptr)            , value             :: data_ptr
      integer(kind=c_int32_t), value, intent(in) :: data_size
      integer(kind=c_int32_t)                    :: data_sum
    end subroutine f_thrust_cuda
#endif


 end interface

end module wrap_thrust
