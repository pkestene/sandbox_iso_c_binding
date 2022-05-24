add_library(mpi_utils "")
target_sources(mpi_utils
  PRIVATE
  m_mpi_utils.F90
  m_do_stuff_wrap.F90)
target_link_libraries(mpi_utils
  PUBLIC
  MPI::MPI_Fortran)

add_library(do_stuff_in_c "")
target_sources(do_stuff_in_c
  PRIVATE
  do_stuff_in_c.c)
target_link_libraries(do_stuff_in_c
  PUBLIC
  MPI::MPI_C)

add_executable(test_mpi "")
target_sources(test_mpi
  PRIVATE
  test_mpi.F90)
target_link_libraries(test_mpi
  PRIVATE
  mpi_utils
  do_stuff_in_c)
