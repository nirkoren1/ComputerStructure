# 316443902 Nir Koren
# This file impelements the fuction rum_main
# The function gets from the user two strings and their length and an option in a menu using "scanf"
# Then the function builds two structs which contains the strings and their length
# Then the function sends the two structs to the "run_func" function by their addresses
    .data
    .section    .data
format_i: .string "%d\n"
format_s: .string "%s\n"
size_1: .int 0
size_2: .int 0
    .text
    .globl run_main
    .type run_main, @function
run_main:
    pushq %rbp
    movq %rsp, %rbp

    leaq format_i(%rip), %rdi
    leaq size_1(%rip), %rsi
    movq $0, %rax
    call scanf

    movq $format_i, %rdi
    movq size_1, %rsi
    movq $0, %rax
    call printf

    movq $0, %rax
    leave
    ret

