cmake_minimum_required(VERSION 3.13)

project(sanbox
  LANGUAGES C CXX Fortran
  VERSION 1.0
  DESCRIPTION "sanbox for testing idea related to interfacing c/c++ and fortran using iso_c_bindings")

# export compiles commands to json (for LSP)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# subdirectory cmake contains useful macros
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

# setup build type (Release / Debug)
include(set_default_build_type)
set_default_build_type()

# prevent build in-place
if(${PROJECT_SOURCE_DIR} STREQUAL ${PROJECT_BINARY_DIR})
    message(FATAL_ERROR "In-source builds not allowed. Please run CMake from top directory and specify a build directory (e.g., cmake -H. -Bbuild).")
endif()

option (USE_MPI "Activate / want MPI build" ON)
option (USE_MPI_CUDA_AWARE_ENFORCED "Some MPI cuda-aware implementation are not well detected; use this to enforce" OFF)


#####################################################################
#find_package(MPI REQUIRED)
find_package(MPI)
if (USE_MPI)
  if(MPI_Fortran_FOUND)
    message(STATUS "MPI support found")
    message(STATUS "MPI compile flags: " ${MPI_Fortran_COMPILE_FLAGS})
    message(STATUS "MPI include path: " ${MPI_Fortran_INCLUDE_PATH})
    message(STATUS "MPI LINK flags path: " ${MPI_Fortran_LINK_FLAGS})
    message(STATUS "MPI libraries: " ${MPI_Fortran_LIBRARIES})

    #set(CMAKE_EXE_LINKER_FLAGS ${MPI_Fortran_LINK_FLAGS})
    find_program(OMPI_INFO
      NAMES ompi_info
      HINTS ${MPI_Fortran_LIBRARIES}/../bin)

    # Full command line to probe if cuda support in MPI implementation is enabled
    # ompi_info --parsable --all | grep mpi_built_with_cuda_support:value
    if (OMPI_INFO)
      execute_process(COMMAND ${OMPI_INFO}
        OUTPUT_VARIABLE _output)
      if ( (_output MATCHES "smcuda") OR (USE_MPI_CUDA_AWARE_ENFORCED) )
        message(STATUS "Found OpenMPI with CUDA support built.")
      else()
        message(WARNING "OpenMPI found, but it was not built with CUDA support.")
        add_compile_options(-DMPI_CUDA_AWARE_OFF)
      endif()
    endif()
  else()
    message(WARNING "Not compiling with MPI. Suppress this warning with -DUSE_MPI=OFF")
    set(USE_MPI OFF)
  endif()
endif()

# if CUDA available ? i.e. checking for a CUDA compiler
# if cuda compiler is not found, the test checking CMAKE_CUDA_COMPILER will fail
include(CheckLanguage)
check_language(CUDA)
if (CMAKE_CUDA_COMPILER)
  enable_language(CUDA)
  set(CUDA_ENABLED ON)
else()
  set(CUDA_ENABLED OFF)
endif()

# check for thrust (Nvidia CUDA/OpenMP)
# you'll probably need to adjust env var CMAKE_PREFIX_PATH, e.g.
# export CMAKE_PREFIX_PATH=/usr/local/cuda-11.7/targets/x86_64-linux/lib/cmake:$CMAKE_PREFIX_PATH
find_package(Thrust)
if (Thrust_FOUND)

  if(CUDA_ENABLED)
    thrust_create_target(Thrust)
  else()
    thrust_create_target(ThrustOMP HOST CPP DEVICE OMP)
  endif()

  # enable build of a test using thrust inside fortran (OpenMP or CUDA backend) wrapped
  # using iso_c_binding
  set(DO_FORTRAN_THRUST_TEST ON)

else()

  message("Nvidia Thrust library not found")

endif()


#####################################################################
add_subdirectory(src)

##################### PRINT CONFIGURE STATUS ######################
message("//===================================================")
message("// ${PROJECT_NAME} build configuration:")
message("// ${PROJECT_NAME} version : ${PROJECT_VERSION}")
message("//===================================================")
message("  CMake version          : ${CMAKE_VERSION}")
if (NOT CMAKE_BUILD_TYPE)
  message("  CMake build type       : NOT SET !")
else()
  message("  CMake build type       : ${CMAKE_BUILD_TYPE}")
endif()
message("  CMake install prefix   : ${CMAKE_INSTALL_PREFIX}")
message("  CMake system processor : ${CMAKE_SYSTEM_PROCESSOR}")
message("  CMake system name (OS) : ${CMAKE_SYSTEM_NAME}")
message("")
message("  Fortran compiler Id  : ${CMAKE_Fortran_COMPILER_ID} ${CMAKE_Fortran_COMPILER_VERSION}")
message("  Fortran compiler exe :${CMAKE_Fortran_COMPILER}")
message("  Fortran flags        : ${CMAKE_Fortran_FLAGS}")
message("")
message("  Thrust               : ${Thrust_FOUND}")
message("  CUDA enabled         : ${CUDA_ENABLED}")
