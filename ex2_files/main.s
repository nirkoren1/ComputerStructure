# 316443902 Nir Koren
    .data
    .section    .rodata
format: .string "%d\n"
format_s: .string "%s\n"
true:   .string "True"
false:  .string "False"
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
    movq    id, %rax                # load the value of id into rax
    movq    id, %rdx                # load the value of id into rdx
    shrq    $16, %rdx               # shift rdx 16 bits to the right, gets the third byte
    xorq    %rdx, %rax              # xor rax with rdx which is the xor of the first and third byte
    shrq    $7, %rax                # shift rax 7 bits to the right
    andq    $0x1, %rax              # and rax with 0x1
    cmpq    $0, %rax                # compare rax with 0
    movq    $true, %rdx             # set rdx to true
    movq    $false, %rbx            # set rbx to false
    cmovne  %rdx, %rsi              # if rax is not 0 means the xor of the first and third byte is not 0 means bigger than 127, so print true
    cmove   %rbx, %rsi              # if rax is 0 means the xor of the first and third byte is 0 means less equals to 127, so print false
    movq    $format_s, %rdi         # set the first argument to the format string
    movq    $0, %rax                # set rax to 0
    call    printf                  # call printf

    ## part 4
    movq    id, %rax                # load the value of id into rax
    shrq    $24, %rax               # shift rax 24 bits to the right, gets the fourth byte
    movq    $0, %rbx                # set rbx to 0 the counter of the loop
    movq    $0, %rcx                # set rcx to 0 the counter of the 1s
.loop:
    movq    $0, %rdx                # set rdx to 0
    movq    $2, %rsi                # set rsi to 2
    divq    %rsi                    # divide rax by 2
    addq    %rdx, %rcx              # add rdx to rcx which is the counter of the 1s
    incq    %rbx                    # increment rdx
    cmpq    $8, %rbx                # compare rax with 8
    jne     .loop                   # if rax is not 8 means the loop is not done, so jump to .loop

    movq    $format, %rdi           # set the first argument to the format string
    movq    %rcx, %rsi              # load the value of rcx into rsi
    movq    $0, %rax                # set rax to 0
    call    printf                  # call printf

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


