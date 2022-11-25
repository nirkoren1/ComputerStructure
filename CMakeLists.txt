cmake_minimum_required(VERSION 3.23)
project(ComputerStructure C ASM)

set(CMAKE_C_STANDARD 99)
set(GCC_COVERAGE_COMPILE_FLAGS "-no-pie")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${GCC_COVERAGE_COMPILE_FLAGS}" )

include_directories(ex1_files)

add_executable(ComputerStructure
        ex1_files/ex1.c
        ex1_files/ex1.h
        ex1_files/main.c
        ex2_files/do_main.c)
