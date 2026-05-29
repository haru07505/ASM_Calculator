default rel

global dec_add
global dec_sub
global dec_mul
global dec_div
global dec_neg
global dec_square
global dec_reciprocal

extern scale_q
extern scale2_q

section .text

dec_add:
    mov rax, rcx
    add rax, rdx
    xor edx, edx
    ret

dec_sub:
    mov rax, rcx
    sub rax, rdx
    xor edx, edx
    ret

dec_mul:
    mov rax, rcx
    imul rdx
    idiv qword [scale_q]
    xor edx, edx
    ret

dec_div:
    mov r10, rdx
    cmp r10, 0
    je .div_zero

    mov rax, rcx
    imul qword [scale_q]
    idiv r10
    xor edx, edx
    ret

.div_zero:
    xor rax, rax
    mov edx, 1
    ret

dec_neg:
    mov rax, rcx
    neg rax
    xor edx, edx
    ret

dec_square:
    mov rax, rcx
    imul rcx
    idiv qword [scale_q]
    xor edx, edx
    ret

dec_reciprocal:
    mov r10, rcx
    cmp r10, 0
    je .div_zero

    mov rax, [scale2_q]
    cqo
    idiv r10
    xor edx, edx
    ret

.div_zero:
    xor rax, rax
    mov edx, 1
    ret
