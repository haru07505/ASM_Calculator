; advanced_ops.asm
; Nhóm phép toán nâng cao: bình phương, nghịch đảo

default rel

section .text
global asm_square
global asm_reciprocal

asm_square:
    ; result = a * a / 100
    ; vì a đang ở dạng fixed-point SCALE = 100
    mov rax, rcx
    imul rcx

    mov r10, 100
    cqo
    idiv r10
    ret

asm_reciprocal:
    ; result = 1 / a
    ; với SCALE = 100:
    ; result = 10000 / a

    cmp rcx, 0
    je reciprocal_zero

    mov r10, rcx
    mov rax, 10000

    cqo
    idiv r10
    ret

reciprocal_zero:
    ; 1/0 cũng là lỗi chia cho 0
    mov qword [r9], 1
    xor rax, rax
    ret