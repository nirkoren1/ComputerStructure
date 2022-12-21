# Nir Koren 316443902
    .section .rodata
error_message1: .string "invalid input!\n"
    .text
    .globl pstrlen
    .type pstrlen, @function
pstrlen:
    pushq %rbp                              # save frame pointer
    movq %rsp, %rbp                         # set frame pointer

    movq %rdi, %rax                         # copy pstring pointer to rax
    movzb (%rax), %rax                      # get the first byte of the pstring which is the length

    leave                                   # restore frame pointer
    ret                                     # return

    .text
    .globl replaceChar
    .type replaceChar, @function
replaceChar:
    pushq %rbp                              # save frame pointer
    movq %rsp, %rbp                         # set frame pointer

    movq %rdi, %r12                         # copy pstring pointer to r12
    movq %rsi, %r13                         # copy char to replace to r13
    movq %rdx, %r14                         # copy char to replace with to r14

    movzb (%r12), %r15                      # get the first byte of the pstring which is the length
    leaq 1(%r12), %rbx                      # increment the pointer to point to the first char
    .loop:
        cmpq $0, %r15                       # check if we are done
        je .done                            # if so, jump to done
        movzb (%rbx), %rax                  # get the current char
        cmpq %rax, %r13                     # compare it to the char to replace
        je .replace                         # if they are equal, jump to replace
        incq %rbx                           # otherwise, increment the pointer
        decq %r15                           # and decrement the length
        jmp .loop                           # and loop
    .replace:
        movb %r14b, (%rbx)                  # replace the char
        incq %rbx                           # increment the pointer
        decq %r15                           # and decrement the length
        jmp .loop                           # and loop
    .done:

    movq %r12, %rax                         # copy pstring pointer to rax
    leave
    ret


    .text
    .globl pstrijcpy
    .type pstrijcpy, @function
pstrijcpy:
    pushq %rbp                              # save frame pointer
    movq %rsp, %rbp                         # set frame pointer

    movq %rdi, %r12                         # get the destination pstring pointer
    movq %rsi, %r13                         # get the source pstring pointer
    movq %rdx, %r14                         # get the starting index
    movq %rcx, %r15                         # get the ending index

                                            # check for errors
    movzb (%r13), %rax                      # get the length of the source pstring
    cmpb %al, %r14b                         # compare it to the starting index
    jge .error                              # if it is less than or equal, jump to error

    movzb (%r12), %rax                      # get the length of the destination pstring
    cmpb %al, %r14b                         # compare it to the starting index
    jge .error                              # if it is less than or equal, jump to error

    cmpb $0, %r14b                          # compare it to 0
    jl .error                               # if it is less than 0, jump to error

    movzb (%r12), %rax                      # get the length of the destination pstring
    cmpb %al, %r15b                         # compare it to the ending index of the destination pstring
    jge .error                              # if it is less than or equal, jump to error

    movzb (%r13), %rax                      # get the length of the source pstring
    cmpb %al, %r15b                         # compare it to the ending index of the source pstring
    jge .error                              # if it is less than or equal, jump to error

    cmpb $0, %r15b                          # compare it to 0
    jl .error                               # if it is less than 0, jump to error

    cmpb %r14b, %r15b                       # compare the starting index to the ending index
    jl .error                               # if it is greater, jump to error

    leaq 0(%r12), %rbx                      # increment the pointer to point to the first char of the destination pstring
    pushq %rbp                              # save frame pointer
    leaq 0(%r13), %rbp                      # increment the pointer to point to the first char of the source pstring
    movq $-1, %rax                          # set the counter to -1
    .loop2:
        incq %rax                           # increment the counter
        incq %rbx                           # increment the pointer to the destination pstring
        incq %rbp                           # increment the pointer to the source pstring
        cmpq %rax, %r14                     # compare it to the starting index
        jg .loop2                           # if it is less, loop
        cmpq %rax, %r15                     # compare it to the ending index
        jl .done2                           # if it is greater, jump to done
        movzb (%rbp), %r8                   # get the current char of the source pstring
        movb %r8b, (%rbx)                   # copy it to the destination pstring
        jmp .loop2                          # loop
    .error:
        movq $error_message1, %rdi          # set the error message
        movq $0, %rax                       # set rax to 0
        call printf                         # print the error message
        pushq %rbp                          # save frame pointer
        jmp .done2                          # jump to done
    .done2:

    movq %r12, %rax                         # copy pstring pointer to rax
    popq %rbp                               # restore frame pointer
    leave
    ret

    .text
    .globl swapCase
    .type swapCase, @function
swapCase:
    pushq %rbp                              # save frame pointer
    movq %rsp, %rbp                         # set frame pointer

    movq %rdi, %r12                         # copy pstring pointer to r12

    movzb (%r12), %r15                      # get the first byte of the pstring which is the length
    leaq 1(%r12), %rbx                      # increment the pointer to point to the first char
    .loop3:
        cmpq $0, %r15                       # check if we are done
        je .done3                           # if so, jump to done
        movzb (%rbx), %rax                  # get the current char
        cmpq $0x41, %rax                    # compare it to 'A'
        jl .skip                            # if it is less, jump to skip
        cmpq $0x5a, %rax                    # compare it to 'Z'
        jg .skip                            # if it is greater, jump to skip
        addq $0x20, %rax                    # otherwise, add 0x20 to it
        movb %al, (%rbx)                    # and store it
        jmp .skip2                          # jump to skip
    .skip:
        cmpq $0x61, %rax                    # compare it to 'a'
        jl .skip2                           # if it is less, jump to skip2
        cmpq $0x7a, %rax                    # compare it to 'z'
        jg .skip2                           # if it is greater, jump to skip2
        subq $0x20, %rax                    # otherwise, subtract 0x20 from it
        movb %al, (%rbx)                    # and store it
        jmp .skip2                          # jump to skip2
    .skip2:
        incq %rbx                           # increment the pointer
        decq %r15                           # and decrement the length
        jmp .loop3                          # and loop
    .done3:

    movq %r12, %rax                         # copy pstring pointer to rax
    leave
    ret

    .text
    .globl pstrijcmp
    .type pstrijcmp, @function
pstrijcmp:
    pushq %rbp                              # save frame pointer
    movq %rsp, %rbp                         # set frame pointer

    movq %rdi, %r12                         # get the first pstring pointer
    movq %rsi, %r13                         # get the second pstring pointer
    movq %rdx, %r14                         # get the starting index
    movq %rcx, %r15                         # get the ending index

                                            # check for errors
    movzb (%r12), %rax                      # get the length of the first pstring
    cmpb %al, %r14b                         # compare it to the starting index
    jge .error2                             # if it is less than or equal, jump to error

    movzb (%r13), %rax                      # get the length of the second pstring
    cmpb %al, %r14b                         # compare it to the starting index
    jge .error2                             # if it is less than or equal, jump to error

    cmpb $0, %r14b                          # compare it to 0
    jl .error2                              # if it is less than 0, jump to error

    movzb (%r12), %rax                      # get the length of the first pstring
    cmpb %al, %r15b                         # compare it to the ending index of the first pstring
    jge .error2                             # if it is less than or equal, jump to error

    movzb (%r13), %rax                      # get the length of the second pstring
    cmpb %al, %r15b                         # compare it to the ending index of the second pstring
    jge .error2                             # if it is less than or equal, jump to error

    cmpb $0, %r15b                          # compare it to 0
    jl .error2                              # if it is less than 0, jump to error

    cmpb %r14b, %r15b                       # compare the starting index to the ending index
    jl .error2                              # if it is greater, jump to error

    leaq 0(%r12), %rbx                      # increment the pointer to point to the first char of the first pstring
    pushq %rbp                              # save frame pointer
    leaq 0(%r13), %rbp                      # increment the pointer to point to the first char of the second pstring
    movq $-1, %rax                          # set the counter to -1
    .loop4:
        incq %rax                           # increment the counter
        incq %rbx                           # increment the pointer to the first pstring
        incq %rbp                           # increment the pointer to the second pstring
        cmpq %rax, %r14                     # compare it to the starting index
        jg .loop4                           # if it is less, loop
        cmpq %rax, %r15                     # compare it to the ending index
        jl .done_zero                       # if it is greater, jump to done_zero
        movzb (%rbx), %r8                   # get the current char of the first pstring
        movzb (%rbp), %r9                   # get the current char of the second pstring
        cmpb %r8b, %r9b                     # compare them
        je .loop4                           # loop
        jl .done_plus1                      # if the first char is less, jump to done_plus1
        jmp .done_minus1                    # otherwise, jump to done_minus1
    .error2:
        movq $error_message1, %rdi          # set the error message
        movq $0, %rax                       # set rax to 0
        call printf                         # print the error message
        pushq %rbp                          # save frame pointer
        movq $-2, %rax                      # set rax to -2
        jmp .done4                          # jump to done
    .done_zero:
        movq $0, %rax                       # set rax to 0
        jmp .done4                          # jump to done
    .done_plus1:
        movq $1, %rax                       # set rax to 1
        jmp .done4                          # jump to done
    .done_minus1:
        movq $-1, %rax                      # set rax to -1
        jmp .done4                          # jump to done
    .done4:

    popq %rbp                               # restore frame pointer
    leave
    ret
