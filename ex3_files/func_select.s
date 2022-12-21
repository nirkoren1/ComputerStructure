# Nir Koren 316443902
    .section .rodata
format_scan_c: .string "%s"
format_scan_i: .string "%d"
invalid_option: .string "invalid option!\n"
format_case_1: .string "first pstring length: %d, second pstring length: %d\n"
format_case_2: .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
format_case_3: .string "length: %d, string: %s\n"
format_case_4: .string "length: %d, string: %s\n"
format_case_5: .string "compare result: %d\n"
    .align 8
    .L10:
    .quad .L1
    .quad .L2
    .quad .L2
    .quad .L6
    .quad .L3
    .quad .L4
    .quad .L5
    .section .data
old_char: .byte 0
new_char: .byte 0
start_idx: .byte 0
end_idx: .byte 0

    .text
    .globl run_func
    .type run_func, @function
run_func:
    pushq %rbp                                      # save the frame pointer
    movq %rsp, %rbp                                 # set the frame pointer

    movq %rdi, %r12                                 # move the first argument to r12
    movq %rsi, %r13                                 # move the second argument to r13
    movq %rdx, %r14                                 # move the third argument to r14

    leaq -31(%r14), %rax                            # load the offset of the switch table
    cmpq $0, %rax                                   # check if the offset is negative
    js .L6                                          # if so, jump to the default case
    cmpq $6, %rax                                   # check if the offset is greater than the number of cases
    ja .L6                                          # if so, jump to the default case
    jmp *.L10(,%rax,8)                              # jump to the switch table

    .L6:                                            # default case printing "invalid option!"
    movq $invalid_option, %rdi
    movq $0, %rax
    call printf
    jmp .L7                                         # jump to the end of the function

    .L1:                                            # case 1
    movq %r12, %rdi                                 # move the first argument to rdi
    call pstrlen                                    # call pstrlen
    movq %rax, %r12                                 # move the return value to r12

    movq %r13, %rdi                                 # move the second argument to rdi
    call pstrlen                                    # call pstrlen
    movq %rax, %r13                                 # move the return value to r13

    movq $format_case_1, %rdi                       # move the format string to rdi
    movq %r12, %rsi                                 # move the first argument to rsi
    movq %r13, %rdx                                 # move the second argument to rdx
    movq $0, %rax
    call printf                                     # call printf
    jmp .L7                                         # jump to the end of the function

    .L2:                                            # case 2
    leaq format_scan_c(%rip), %rdi                  # move the format string to rdi
    leaq old_char(%rip), %rsi                       # move the address of old_char to rsi
    movq $0, %rax
    call scanf                                      # call scanf

    leaq format_scan_c(%rip), %rdi                  # move the format string to rdi
    leaq new_char(%rip), %rsi                       # move the address of new_char to rsi
    movq $0, %rax
    call scanf                                      # call scanf

    movq %r12, %rdi                                 # move the first argument to rdi
    movzbq old_char, %rsi                             # move the address of old_char to rsi
    movzbq new_char, %rdx                             # move the address of new_char to rdx
    movq $0, %rax
    pushq %r13                                      # save the second pstring
    call replaceChar                                # call replaceChar

    popq %r13                                       # pop the second pstring
    movq %r13, %rdi                                 # move the first argument to rdi
    movzbq old_char, %rsi                             # move the address of old_char to rsi
    movzbq new_char, %rdx                             # move the address of new_char to rdx
    pushq %rax                                      # push the return value from the first call to the stack
    movq $0, %rax
    call replaceChar                                # call replaceChar
    movq %rax, %r13                                 # move the return value to r13

    movq $format_case_2, %rdi                       # move the format string to rdi
    movq old_char, %rsi                             # move the address of old_char to rsi
    movq new_char, %rdx                             # move the address of new_char to rdx
    popq %r12                                       # pop the return value from the stack
    movq %r12, %rcx                                 # move the first argument to rcx
    leaq 1(%rcx), %rcx                              # start printing from the second byte
    movq %r13, %r8                                  # move the second argument to r8
    leaq 1(%r8), %r8                                # start printing from the second byte
    movq $0, %rax
    call printf                                     # call printf
    jmp .L7                                         # jump to the end of the function


    .L3:                                            # case 3
    leaq format_scan_i(%rip), %rdi                  # move the format string to rdi
    leaq start_idx(%rip), %rsi                      # move the address of start_idx to rsi
    movq $0, %rax
    call scanf                                      # call scanf

    leaq format_scan_i(%rip), %rdi                  # move the format string to rdi
    leaq end_idx(%rip), %rsi                        # move the address of end_idx to rsi
    movq $0, %rax
    call scanf                                      # call scanf

    movq %r12, %rdi                                 # move the address of r12 to rdi
    movq %r13, %rsi                                 # move the address of r13 to rsi
    movzb start_idx, %rdx                           # move the address of start_idx to rdx
    movzb end_idx, %rcx                             # move the address of end_idx to rcx
    movq $0, %rax
    pushq %r13                                      # save the second pstring
    call pstrijcpy                                  # call pstrijcpy
    popq %r13                                       # pop the second pstring
    movq %rax, %r12                                 # move the return value to r12

    movq $format_case_3, %rdi                       # move the format string to rdi
    movq %r12, %rsi                                 # move the address of r12 to rsi
    movzb (%rsi), %rsi                              # get the length of the string which is the first byte of the rsi points to
    movq %r12, %rdx                                 # move the address of r12 to rdx
    leaq 1(%rdx), %rdx                              # start printing from the second byte
    movq $0, %rax
    call printf                                     # call printf

    movq $format_case_3, %rdi                       # move the format string to rdi
    movq %r13, %rsi                                 # move the address of r13 to rsi
    movzb (%rsi), %rsi                              # get the length of the string which is the first byte of the rsi points to
    movq %r13, %rdx                                 # move the address of r13 to rdx
    leaq 1(%rdx), %rdx                              # start printing from the second byte
    movq $0, %rax
    call printf                                     # call printf
    jmp .L7                                         # jump to the end of the function

    .L4:                                            # case 4
    movq %r12, %rdi                                 # move the address of r12 to rdi
    movq $0, %rax
    call swapCase                                    # call swapCase
    movq %rax, %r12                                 # move the return value to r12
    pushq %r12                                      # push the return value to the stack

    movq %r13, %rdi                                 # move the address of r13 to rdi
    movq $0, %rax
    call swapCase                                    # call swapCase
    movq %rax, %r13                                 # move the return value to r13

    popq %r12                                       # pop the return value from the stack
    movq $format_case_4, %rdi                       # move the format string to rdi
    movq %r12, %rsi                                 # move the address of r12 to rsi
    movzb (%rsi), %rsi                              # get the length of the string which is the first byte of the rsi points to
    movq %r12, %rdx                                 # move the address of r12 to rdx
    leaq 1(%rdx), %rdx                              # start printing from the second byte
    movq $0, %rax
    call printf                                     # call printf

    movq $format_case_4, %rdi                       # move the format string to rdi
    movq %r13, %rsi                                 # move the address of r13 to rsi
    movzb (%rsi), %rsi                              # get the length of the string which is the first byte of the rsi points to
    movq %r13, %rdx                                 # move the address of r13 to rdx
    leaq 1(%rdx), %rdx                              # start printing from the second byte
    movq $0, %rax
    call printf                                     # call printf
    jmp .L7                                         # jump to the end of the function

    .L5:                                            # case 5
    leaq format_scan_i(%rip), %rdi                  # move the format string to rdi
    leaq start_idx(%rip), %rsi                      # move the address of start_idx to rsi
    movq $0, %rax
    call scanf                                      # call scanf
    movq %rsi, start_idx                            # move the return value to start_idx

    leaq format_scan_i(%rip), %rdi                  # move the format string to rdi
    leaq end_idx(%rip), %rsi                        # move the address of end_idx to rsi
    movq $0, %rax
    call scanf                                      # call scanf

    movq %r12, %rdi                                 # move the address of r12 to rdi
    movq %r13, %rsi                                 # move the address of r13 to rsi
    movzb start_idx, %rdx                           # move the address of start_idx to rdx
    movzb end_idx, %rcx                             # move the address of end_idx to rcx
    movq $0, %rax
    call pstrijcmp                                  # call pstrijcmp
    movq %rax, %r14                                 # move the return value to r14

    movq $format_case_5, %rdi                       # move the format string to rdi
    movq %r14, %rsi                                 # move the address of r14 to rsi
    movq $0, %rax
    call printf                                     # call printf
    jmp .L7                                         # jump to the end of the function


    .L7:                                            # end of the function
    leave                                           # restore the frame pointer
    ret
