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
size_1: .int 0                                     # size of the first string
size_2: .int 0                                     # size of the second string
option: .int 0                                     # option in the menu
    .section    .bss
string_1: .space 100                               # first string
string_2: .space 100                               # second string
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

                                                   # get the first string
    leaq format_s_scan(%rip), %rdi                 # load format_s to rdi
    leaq string_1(%rip), %rsi                      # load string_1 to rsi
    movq $0, %rax                                  # load 0 to rax
    call scanf                                     # call scanf

    #print the first string by every character
    leaq string_1(%rip), %rdi                      # load string_1 to rdi
    .loop1:                                        # loop for printing the first string
    movb (%rdi), %al                               # load the character to al
    cmpb $0, %al                                   # compare the character to 0
    je .end1                                       # if the character is 0 jump to .end1
    leaq format_c_print(%rip), %rsi                # load format_c to rsi
    movq $0, %rax                                  # load 0 to rax
    call printf                                    # call printf
    incq %rdi                                      # increment rdi
    jmp .loop1                                     # jump to .loop1


                                                   # get the size of the second string
    leaq format_i_scan(%rip), %rdi                 # load format_i to rdi
    leaq size_2(%rip), %rsi                        # load size_2 to rsi
    movq $0, %rax                                  # load 0 to rax
    call scanf                                     # call scanf

                                                   # get the second string
    leaq format_s_scan(%rip), %rdi                 # load format_s to rdi
    leaq string_2(%rip), %rsi                      # load string_2 to rsi
    movq $0, %rax                                  # load 0 to rax
    call scanf                                     # call scanf

                                                   # build the first struct
    leaq string_1(%rip), %rdi                      # load string_1 to rdi
    leaq size_1(%rip), %rsi                        # load size_1 to rsi
    movq $0, %rax                                  # load 0 to rax
    call build_struct                              # call build_struct
    pushq %rax                                     # push the address of the first struct to the stack


                                                   # build the second struct
    leaq string_2(%rip), %rdi                      # load string_2 to rdi
    leaq size_2(%rip), %rsi                        # load size_2 to rsi
    movq $0, %rax                                  # load 0 to rax
    call build_struct                              # call build_struct
    pusq %rax                                      # save the address of the second struct

    movq $0, %rax
    leave
    ret

    .text
    .globl build_struct
    .type build_struct, @function
build_struct:
    pushq %rbp                                     # save the base pointer
    movq %rsp, %rbp                                # set the base pointer

                                                   # get the string from the user
    movq %rsi, (%rax)                              # save the string length in the struct
    movq $0, %rsi                                  # load 0 to rdi

    leaq string_1(%rip), %rdi                      # load string_1 to rdi
    .loop1:                                        # loop for printing the first string
    movb (%rdi), %al                               # load the character to al
    leaq %al,
    cmpb $0, %al                                   # compare the character to 0
    je .end1                                       # if the character is 0 jump to .end1
    incq %rdi                                      # increment rdi
    jmp .loop1                                     # jump to .loop1

    movq $0, %rax
    leave
    ret
