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

    movzb (%r12), %r15                      # get the first byte of the pstring which is the length
    leaq 1(%r12), %rbx                      # increment the pointer to point to the first char
    .loop2:
        cmpq $0, %r15                       # check if we are done
        je .done                            # if so, jump to done
        cmpq %r13, %r15                     # compare the index to the length
        je .done2                            # if they are equal, jump to done
        movzb (%rbx), %rax                  # get the current char
        movb %al, (%r14)                    # copy the char
        incq %rbx                           # increment the pointer
        incq %r14                           # increment the pointer to copy to
        decq %r15                           # and decrement the length
        jmp .loop2                           # and loop
    .done2:

    movq %r14, %rax                         # copy pstring pointer to rax
    leave
    ret
