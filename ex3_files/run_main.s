# 316443902 Nir Koren
# This file impelements the fuction rum_main
# The function gets from the user two strings and their length and an option in a menu using "scanf"
# Then the function builds two structs which contains the strings and their length
# Then the function sends the two structs to the "run_func" function by their addresses
    .data
    .section    .rodata
format_i_scan: .string "%d\0"                      # format for scanning integers
format_s_scan: .string "%s\0"                      # format for scanning strings
format_i_print: .string "%d\n"                     # format for scanning integers
format_s_print: .string "%s\n"                     # format for scanning strings
format_c_print: .string "%c"                       # format for printing characters
    .section    .data
size_1: .byte 0                                     # size of the first string
size_2: .byte 0                                     # size of the second string
option: .int 0                                     # option in the menu
    .section    .bss
string_1: .space 100                               # first string
string_2: .space 100                               # second string
pstring_1: .space 256                                 # pointer to the first string
pstring_2: .space 256                                 # pointer to the second string

    .text
    .globl run_main
    .type run_main, @function
run_main:
    pushq %rbp                                     # save the base pointer
    movq %rsp, %rbp                                # set the base pointer

                                                   # get the size of the first string
    leaq format_i_scan(%rip), %rdi                      # load format_i to rdi
    leaq size_1(%rip), %rsi                        # load size_1 to rsi
    movq $0, %rax                                  # load 0 to rax
    call scanf                                     # call scanf
    movzbq size_1(%rip), %r8                        # load size_1 to r8

                                                   # get the first string
    leaq format_s_scan(%rip), %rdi                 # load format_s to rdi
    leaq string_1(%rip), %rsi                      # load string_1 to rsi
    movq $0, %rax                                  # load 0 to rax
    call scanf                                     # call scanf
    movq string_1(%rip), %r9                       # load string_1 to r9

                                                   # get the size of the second string
    leaq format_i_scan(%rip), %rdi                 # load format_i to rdi
    leaq size_2(%rip), %rsi                        # load size_2 to rsi
    movq $0, %rax                                  # load 0 to rax
    call scanf                                     # call scanf
    movzbq size_2(%rip), %r10                        # load size_2 to r10

                                                   # get the second string
    leaq format_s_scan(%rip), %rdi                 # load format_s to rdi
    leaq string_2(%rip), %rsi                      # load string_2 to rsi
    movq $0, %rax                                  # load 0 to rax
    call scanf                                     # call scanf
    movq string_2(%rip), %r11                      # load string_2 to r11

                                                   # build the first struct
    movq %r8, %rdi                                 # load size_1 to rdi
    movq %r9, %rsi                                 # load string_1 to rsi
    movq $0, %rax                                  # load 0 to rax
    call build_struct                              # call build_struct

                                                   # build the second struct
    movq %r10, %rdi                                # load size_2 to rdi
    movq %r11, %rsi                                # load string_2 to rsi
    movq $0, %rax                                  # load 0 to rax
    call build_struct                              # call build_struct

                                                      # print pstring_1
    leaq format_i_print(%rip), %rdi                # load format_i to rdi
    leaq pstring_1(%rip), %rsi                     # load pstring_1 to rsi
    movb (%rsi), %sil                               # load pstring_1 to sil
    movq $0, %rax                                  # load 0 to rax
    call printf                                    # call printf


    movq $0, %rax
    leave
    ret


    .text
    .globl build_struct
    .type build_struct, @function
build_struct:
    pushq %rbp                                     # save the base pointer
    movq %rsp, %rbp                                # set the base pointer

                                                   # load the size of the struct to pstring first byte
    movq (%rsi), %rax                              # load the size of the struct to rax
    movq %rax, pstring_1(%rip)                      # load rax to pstring_1

                                                   # loop every character in the string and save it in the struct pstring
    .loop:
    movzbl (%rdi), %eax                            # load the first character of the string to rax
    movb %al, pstring_1(%rip)                       # load rax to pstring_1
    addq $1, %rdi                                  # add 1 to rdi
    addq $1, %rax                                  # add 1 to rax
    cmpq %rax, %rsi                                # compare rax to rsi
    jne .loop                                      # jump to .loop if rax != rsi

    leave
    ret
