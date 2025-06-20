# Demonstration of implementing and using functions
    .intel_syntax noprefix

    .text
    .section .rodata

    .align 4
    .type length, @object
    .size length, 4
length:
    .long 8
length2:
    .long 7

message:
    .string "This is "

message2:
    .string " not x\n"


    .text
    .globl  print
    .type   print, @function

    # Register call order sequence: rdi, rsi, rdx, rcx, r8, r9, stack
print:
    push rbp
    mov rbp, rsp

    mov rax, [rbp + 16]
    mov rbx, [rbp + 24]
    push 0xFF
    push rbx
    push rax
    push r9
    push r8
    push rcx
    push rdx
    push rsi
    push rdi
    
loop:
    pop rbx
    cmp rbx, 0xFF
    je end
    cmp rbx, 'x'
    je loop
    mov esi, DWORD PTR length[rip]  # Setting up to pass second arg into function
    lea rdi, message[rip]           # Setting up to pass first arg into function
    call print2
    
    push rbx
    mov esi, 1              # Setting up to pass second arg into function
    mov rdi, rsp            # Setting up to pass first arg into function
    call print2
    pop rbx

    mov esi, DWORD PTR length2[rip]
    lea rdi, message2[rip]
    call print2
    jmp loop
    
end:
    mov rsp, rbp
    pop rbp
    ret
    .size       print, .-print


    .text
    .globl  print2
    .type   print2, @function

    # Register call order sequenc: rdi, rsi, rdx, rcx, r8, r9, stack
print2:
    # print(char* stringToPrint, int lengthOfString)
    # setting up call stack
    push rbp
    mov rbp, rsp

    # Start of function code to call write syscall
    mov rax, 0x01		# 0x01 is write syscall
    mov rdx, rsi        # length of string passed into function as second arg
    mov rsi, rdi	    # pointer to start of message to print as first arg
    mov rdi, 1			# setting fd to STDOUT (1)
    syscall

    cmp rax, 1
    jl return

    mov rax, 0

return:
    mov rsp, rbp
    pop rbp
    ret
    .size       print2, .-print2


    .text
    .globl  main
    .type   main, @function

    # Register call order sequence: rdi, rsi, rdx, rcx, r8, r9, stack
main:
    push rbp
    mov rbp, rsp

    mov rdi, 'a'
    mov rsi, 'c'
    mov rdx, 'x'
    mov rcx, 'w'
    mov r8, 'e'
    mov r9, 'x'
    push 'o'
    push 'p'
    
    call print

    mov rsp, rbp
    pop rbp
    ret
    .size       main, .-main
    .section    .note.GNU-stack,"",@progbits
