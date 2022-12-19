# 316443902 Nir Koren
# This file impelements the fuction rum_main
# The function gets from the user two strings and their length and an option in a menu using "scanf"
# Then the function builds two structs which contains the strings and their length
# Then the function sends the two structs to the "run_func" function by their addresses
    .data
    .section    .rodata
format_i_scan: .string "%d\0"                      # format for scanning integers
format_s_scan: .string "%s\0"                      # format for scanning strings
    .section    .data
    .align 1
size_1: .byte 0                                    # size of the first string
string_1: .space 256                               # pointer to the first struct
size_2: .byte 0                                    # size of the second string
string_2: .space 256                               # pointer to the second struct# option in the menu
option: .long 0


    .text
    .globl run_main
    .type run_main, @function
run_main:
    pushq %rbp                                     # save the base pointer
    movq %rsp, %rbp                                # set the base pointer

                                                   # get the size of the first string
    leaq size_1(%rip), %rsi                        # set the first argument for scanf
    leaq format_i_scan(%rip), %rdi                 # set the second argument for scanf
    movq $0, %rax                                  # set the return value to 0
    call scanf                                     # call scanf to scan the size of the first string

                                                   # get the first string
    leaq string_1(%rip), %rsi                      # set the first argument for scanf
    leaq format_s_scan(%rip), %rdi                 # set the second argument for scanf
    movq $0, %rax                                  # set the return value to 0
    call scanf                                     # call scanf to scan the first string

                                                   # get the size of the second string
    leaq size_2(%rip), %rsi                        # set the first argument for scanf
    leaq format_i_scan(%rip), %rdi                 # set the second argument for scanf
    movq $0, %rax                                  # set the return value to 0
    call scanf                                     # call scanf to scan the size of the second string

                                                   # get the second string
    leaq string_2(%rip), %rsi                      # set the first argument for scanf
    leaq format_s_scan(%rip), %rdi                 # set the second argument for scanf
    movq $0, %rax                                  # set the return value to 0
    call scanf                                     # call scanf to scan the second string

                                                   # get the option from the menu
    leaq option(%rip), %rsi                        # set the first argument for scanf
    leaq format_i_scan(%rip), %rdi                 # set the second argument for scanf
    movq $0, %rax                                  # set the return value to 0
    call scanf                                     # call scanf to scan the option from the menu

    leaq size_1(%rip), %rdi                        # set the first argument for run_func
    leaq size_2(%rip), %rsi                        # set the second argument for run_func
    movq option(%rip), %rdx                        # set the third argument for run_func
    movq $0, %rax                                  # set the return value to 0
    call run_func                                  # call run_func

    leave                                          # restore the base pointer
    ret                                            # return from the function

