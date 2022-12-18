    .section .rodata
    .align 8
    .L10:
    .quad .L1
    .quad .L2
    .quad .L2
    .quad .L2
    .quad .L3
    .quad .L4
    .quad .L5


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
    jmp *L10(,%rax,8)                               # jump to the switch table

    .L1:



    leave                                           # restore the frame pointer
    ret
