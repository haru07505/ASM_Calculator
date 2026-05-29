default rel

global int_add
global int_sub
global int_mul
global int_div

section .text

int_add:
    mov eax, ecx
    add eax, edx
    movsxd rax, eax
    xor edx, edx
    ret

int_sub:
    mov eax, ecx
    sub eax, edx
    movsxd rax, eax
    xor edx, edx
    ret

int_mul:
    mov eax, ecx
    imul eax, edx
    movsxd rax, eax
    xor edx, edx
    ret

int_div:
    mov r10d, edx
    cmp r10d, 0
    je .div_zero

    mov eax, ecx
    cdq
    idiv r10d
    movsxd rax, eax
    xor edx, edx
    ret

.div_zero:
    xor rax, rax
    mov edx, 1
    ret
