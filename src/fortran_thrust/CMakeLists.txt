add_executable(test_fortran_thrust "")

if (CUDA_ENABLED)


else()

  target_sources(test_fortran_thrust
    PRIVATE
    thrust_openmp.cpp
    m_wrap_thrust.F90
    main.F90)

  target_compile_options(test_fortran_thrust
    PRIVATE
    -DUSE_THRUST_OPENMP)

  target_link_libraries(test_fortran_thrust
    PRIVATE
    ThrustOMP)

endif()
