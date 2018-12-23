cmake_minimum_required(VERSION 3.7)
project(lineclip Fortran)
enable_testing()


if(CMAKE_BUILD_TYPE STREQUAL Debug)
  add_compile_options(-g -O0)
else()
  add_compile_options(-O3)
endif()

if(${CMAKE_Fortran_COMPILER_ID} STREQUAL GNU)
  if(${CMAKE_Fortran_COMPILER_VERSION} VERSION_GREATER_EQUAL 8)
    list(APPEND FFLAGS -std=f2018)
  endif()
  
  list(APPEND FFLAGS -mtune=native -Wall -Wextra -Wpedantic -Werror=array-bounds -fbacktrace -fexceptions)
  if(UNIX AND NOT (CYGWIN OR APPLE))
    list(APPEND FFLAGS -fstack-protector-all)
  endif()
elseif(${CMAKE_Fortran_COMPILER_ID} STREQUAL PGI)

elseif(${CMAKE_Fortran_COMPILER_ID} STREQUAL Flang)
  list(APPEND FFLAGS -Mallocatable=03)
endif()


set(DEMO_COARRAYS FALSE)
if(${CMAKE_Fortran_COMPILER_ID} STREQUAL Intel)
    list(APPEND FFLAGS -coarray=shared)
    link_libraries(-coarray=shared)
    set(DEMO_COARRAYS TRUE)
elseif(${CMAKE_Fortran_COMPILER_ID} STREQUAL GNU)
  find_package(OpenCoarrays)
  
  if(OpenCoarrays_FOUND)
    list(APPEND OpenCoarrays_LIBRARIES caf_mpi)
    list(APPEND FFLAGS -fcoarray=lib)
    set(DEMO_COARRAYS TRUE)
  else()
    list(APPEND FFLAGS -fcoarray=single)
  endif()
endif()


add_library(assert assert.f90)
target_compile_options(assert PRIVATE ${FFLAGS})

set(f08 GNU Intel)
if(CMAKE_Fortran_COMPILER_ID IN_LIST f08)
  target_sources(assert PRIVATE error2008.f90)
else()
  target_sources(assert PRIVATE error2003.f90)
endif()


add_library(lineclip lineclipping.f90)
target_compile_options(lineclip PRIVATE ${FFLAGS})
target_link_libraries(lineclip PRIVATE assert)

add_executable(RunLineclip DemoLineclip.f90)
target_compile_options(RunLineclip PRIVATE ${FFLAGS})
target_link_libraries(RunLineclip PRIVATE assert lineclip ${OpenCoarrays_LIBRARIES})
add_test(NAME clip COMMAND RunLineclip)

if(DEMO_COARRAYS)
  add_executable(CoarrayLineclip DemoCoarrayLineclip.f90)
  target_compile_options(CoarrayLineclip PRIVATE ${FFLAGS})
  target_link_libraries(CoarrayLineclip PRIVATE assert lineclip ${OpenCoarrays_LIBRARIES})
  add_test(NAME CoarrayClip COMMAND cafrun CoarrayLineclip)
endif()
