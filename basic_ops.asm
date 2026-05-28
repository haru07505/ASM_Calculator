; basic_ops.asm
; Nhóm phép toán cơ bản: cộng, trừ, đổi dấu

default rel

section .text
global asm_add
global asm_sub
global asm_neg

asm_add:
    ; result = a + b
    ; RCX = a, RDX = b
    mov rax, rcx
    add rax, rdx
    ret

asm_sub:
    ; result = a - b
    mov rax, rcx
    sub rax, rdx
    ret

asm_neg:
    ; result = -a
    mov rax, rcx
    neg rax
    ret