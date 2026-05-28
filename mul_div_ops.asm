; mul_div_ops.asm
; Nhóm phép toán nhân, chia, chia lấy dư

default rel

section .text
global asm_mul
global asm_div
global asm_mod

asm_mul:
    ; result = a * b / 100
    ; vì a và b đang ở dạng fixed-point SCALE = 100
    mov rax, rcx
    imul rdx

    mov r10, 100
    cqo
    idiv r10
    ret

asm_div:
    ; kiểm tra chia cho 0
    cmp rdx, 0
    je div_zero

    ; cqo sẽ ghi đè RDX nên phải lưu b vào R10
    mov r10, rdx

    ; result = a * 100 / b
    mov rax, rcx
    imul rax, 100

    cqo
    idiv r10
    ret

asm_mod:
    ; kiểm tra chia cho 0
    cmp rdx, 0
    je div_zero

    ; result = a % b
    mov r10, rdx
    mov rax, rcx

    cqo
    idiv r10

    ; phần dư nằm trong RDX
    mov rax, rdx
    ret

div_zero:
    ; R9 là địa chỉ biến error
    ; error = 1 nghĩa là lỗi chia cho 0
    mov qword [r9], 1
    xor rax, rax
    ret