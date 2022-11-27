# this program is printing a integer value saved in a variable called id
    .data
    .section    .rodata
format: .string "%d\n"
id: .quad 316443902
    .text
.globl main
    .type main, @function
main:
    pushq   %rbp                    # save the base pointer
    movq    %rsp, %rbp              # set the base pointer to the stack pointer
    subq    $16, %rsp               # allocate 16 bytes on the stack

    ## part 1
    movq    $format, %rdi           # set the first argument to the format string
    movq    id, %rsi                # load the value of id into rsi
    movq    $0, %rax                # set rax to 0
    call    printf                  # call printf

    ## part 2
    movq    id, %rax                # load the value of id into rax
    shrq    $8, %rax                # shift rax 8 bits to the right
    andq    $0x1, %rax              # and rax with 0x1
    cmpq    $0, %rax                # compare rax with 0
    je      .Dec2Even               # if rax is 0 means the last bit is 0 means the number is even, so jump to .Dec2Even
    jne     .Dec2Odd                # if rax is 1 means the last bit is 1 means the number is odd, so jump to .Dec2Odd

.PrintPart2:
    movq    $format, %rdi           # set the first argument to the format string
    movq    %rax, %rsi              # load the value of rax into rsi
    movq    $0, %rax                # set rax to 0
    call    printf                  # call printf

    ## part 3


    ## finish
    movq    $0, %rax                # set rax to 0
    movq    %rbp, %rsp              # restore the stack pointer
    popq    %rbp                    # restore the base pointer
    ret

.Dec2Odd:
    movq    id, %rax                # load the value of id into rax
    leaq    (%rax,%rax,2), %rax     # multiply rax by 3
    jmp     .PrintPart2             # jump to .PrintPart2

.Dec2Even:
    movq    id, %rax                # load the value of id into rax
    movq    $0, %rdx                # set rdx to 0
    movq    $3, %rcx                # set rcx to 3
    divq    %rcx                    # divide rax by rcx and store the remainder in rdx
    movq    %rdx, %rax              # move rdx to rax
    jmp     .PrintPart2             # jump to .PrintPart2


