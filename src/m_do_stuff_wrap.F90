module do_stuff_wrap

  use, intrinsic :: iso_c_binding

  interface

     !> a wrapper to call C routine named "do_stuff"
     subroutine f_do_stuff(data_ptr, data_size, f_comm, nproc) bind(c, name='do_stuff')
       use, intrinsic :: iso_c_binding
       implicit none
       type(c_ptr)            ,        intent(in) :: data_ptr
       integer(kind=c_int32_t), value, intent(in) :: data_size
       integer(kind=c_int32_t)                    :: f_comm
       integer(kind=c_int32_t), value, intent(in) :: nproc
     end subroutine f_do_stuff

  end interface

end module do_stuff_wrap
