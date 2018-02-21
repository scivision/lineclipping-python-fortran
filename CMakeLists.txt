cmake_minimum_required(VERSION 2.8.12)
project( morecvutils Fortran )

add_compile_options(-O3 -mtune=native -g)

if(${CMAKE_Fortran_COMPILER_ID} MATCHES "GNU")
  add_compile_options(-Wall -Wextra -Wpedantic -Werror=array-bounds -fbacktrace 
    -fexceptions -fstack-protector-all)
endif()


if(${CMAKE_Fortran_COMPILER_ID} STREQUAL Intel)
    add_compile_options(-coarray=shared)# -check all)
    link_libraries(-coarray=shared) # seems silly but that's what's needed at object code step for ifort
elseif(${CMAKE_Fortran_COMPILER_ID} STREQUAL GNU)
  if ($ENV{TRAVIS}) # on Travis-CI
    add_compile_options(-fcoarray=single)
  else()
    add_compile_options(-fcoarray=lib)
    set(FCAF ${FCAF} caf_mpi)
  endif()
endif()

add_library(lineclip lineclipping.f90)
target_link_libraries(lineclip ${FCAF})

add_executable(RunLineclip DemoLineclip.f90 assert.f90)
target_link_libraries(RunLineclip lineclip)
