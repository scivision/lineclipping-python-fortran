cmake_minimum_required(VERSION 3.0)
project(lineclip Fortran)
enable_testing()

add_compile_options(-O3 -mtune=native -g)

if(${CMAKE_Fortran_COMPILER_ID} STREQUAL GNU)
  add_compile_options(-Wall -Wextra -Wpedantic -Werror=array-bounds -fbacktrace -fexceptions)
  if(NOT CYGWIN AND NOT WIN32)
    add_compile_options(-fstack-protector-all)
  endif()
endif()


if(${CMAKE_Fortran_COMPILER_ID} STREQUAL Intel)
    add_compile_options(-coarray=shared)# -check all)
    link_libraries(-coarray=shared)
elseif(${CMAKE_Fortran_COMPILER_ID} STREQUAL GNU)
  find_package(OpenCoarrays)
  
  if(OpenCoarrays_FOUND)
    list(APPEND OpenCoarrays_LIBRARIES caf_mpi)
    add_compile_options(-fcoarray=lib)
  else()
    add_compile_options(-fcoarray=single)
  endif()
elseif(${CMAKE_Fortran_COMPILER_ID} STREQUAL Flang)
  link_libraries(-static-flang-libs)
endif()

add_library(lineclip lineclipping.f90)
target_link_libraries(lineclip)

add_executable(RunLineclip DemoLineclip.f90 assert.f90)
target_link_libraries(RunLineclip PRIVATE lineclip ${OpenCoarrays_LIBRARIES})

add_test(NAME clip COMMAND ./RunLineclip)
