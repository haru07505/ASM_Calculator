; calc_core.asm
; Hàm calc điều phối phép toán và gọi các hàm ASM tương ứng

default rel

section .text
global calc

extern asm_add
extern asm_sub
extern asm_neg

extern asm_mul
extern asm_div
extern asm_mod

extern asm_square
extern asm_reciprocal

calc:
    ; error = 0
    mov qword [r9], 0

    cmp r8b, '+'
    je asm_add

    cmp r8b, '-'
    je asm_sub

    cmp r8b, 'n'        ; n = đổi dấu ±
    je asm_neg

    cmp r8b, '*'
    je asm_mul

    cmp r8b, '/'
    je asm_div

    cmp r8b, '%'
    je asm_mod

    cmp r8b, 's'        ; s = square, x²
    je asm_square

    cmp r8b, 'r'        ; r = reciprocal, 1/x
    je asm_reciprocal

    ; operator không hợp lệ
    mov qword [r9], 2
    xor rax, rax
    ret