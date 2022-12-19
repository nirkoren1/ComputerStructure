cmake_minimum_required(VERSION 3.23)
project(ComputerStructure C ASM)

set(CMAKE_C_STANDARD 99)
set(GCC_COVERAGE_COMPILE_FLAGS "-no-pie")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${GCC_COVERAGE_COMPILE_FLAGS}" )

include_directories(ex1_files)

add_executable(ComputerStructure
        ex3_files/main.c
        ex3_files/run_main.s
        ex3_files/func_select.s
        ex3_files/pstring.s
        ex3_files/pstring.h)
