default rel

%include "constants.inc"

global format_current_value
global format_int
global format_fixed
global get_base_name

extern current_type
extern current_base

section .data
hex_digits db "0123456789ABCDEF"
name_dec   db "DEC",0
name_hex   db "HEX",0
name_bin   db "BIN",0

section .bss
rev_buf resb 128

section .text

format_current_value:
    push rbp
    mov rbp, rsp

    cmp qword [current_type], TYPE_FIXED
    jne .int_value
    call format_fixed
    jmp .done

.int_value:
    mov r8, rdx
    mov rdx, [current_base]
    call format_int

.done:
    pop rbp
    ret

format_int:
    push rbp
    mov rbp, rsp
    push rbx
    push rsi
    push rdi

    mov rdi, r8
    mov r11, r8
    mov rbx, rdx
    mov rax, rcx

    cmp rbx, BASE_HEX
    je .hex32
    cmp rbx, BASE_BIN
    je .bin32

    test rax, rax
    jge .positive
    mov byte [rdi], '-'
    inc rdi
    neg rax

.positive:
    cmp rax, 0
    jne .digits
    mov byte [rdi], '0'
    inc rdi
    jmp .done_digits

.digits:
    lea rsi, [rev_buf]
    xor r9d, r9d
    lea r10, [hex_digits]

.digit_loop:
    xor rdx, rdx
    div rbx
    mov dl, [r10 + rdx]
    mov [rsi + r9], dl
    inc r9
    test rax, rax
    jne .digit_loop

.reverse_loop:
    dec r9
    mov al, [rsi + r9]
    mov [rdi], al
    inc rdi
    test r9, r9
    jne .reverse_loop

.done_digits:
    mov byte [rdi], 0
    mov rax, r11

    pop rdi
    pop rsi
    pop rbx
    pop rbp
    ret

.hex32:
    mov eax, ecx
    lea r10, [hex_digits]
    mov r9d, 8

.hex_loop:
    mov edx, eax
    shr edx, 28
    and edx, 0Fh
    mov dl, [r10 + rdx]
    mov [rdi], dl
    inc rdi
    shl eax, 4
    dec r9d
    jne .hex_loop

    mov byte [rdi], 0
    mov rax, r11

    pop rdi
    pop rsi
    pop rbx
    pop rbp
    ret

.bin32:
    mov eax, ecx
    mov r9d, 32

.bin_loop:
    mov dl, '0'
    test eax, 80000000h
    jz .write_bit
    mov dl, '1'

.write_bit:
    mov [rdi], dl
    inc rdi
    shl eax, 1
    dec r9d
    jne .bin_loop

    mov byte [rdi], 0
    mov rax, r11

    pop rdi
    pop rsi
    pop rbx
    pop rbp
    ret

format_fixed:
    push rbp
    mov rbp, rsp
    push rbx
    push rsi
    push rdi

    mov rdi, rdx
    mov r11, rdx
    mov rax, rcx

    test rax, rax
    jge .abs_ready
    mov byte [rdi], '-'
    inc rdi
    neg rax

.abs_ready:
    xor rdx, rdx
    mov rbx, 100
    div rbx
    mov r10, rdx

    cmp rax, 0
    jne .integer_digits
    mov byte [rdi], '0'
    inc rdi
    jmp .integer_done

.integer_digits:
    lea rsi, [rev_buf]
    xor r9d, r9d
    mov rbx, 10

.int_digit_loop:
    xor rdx, rdx
    div rbx
    add dl, '0'
    mov [rsi + r9], dl
    inc r9
    test rax, rax
    jne .int_digit_loop

.int_reverse_loop:
    dec r9
    mov al, [rsi + r9]
    mov [rdi], al
    inc rdi
    test r9, r9
    jne .int_reverse_loop

.integer_done:
    cmp r10, 0
    je .done

    mov byte [rdi], '.'
    inc rdi
    mov rax, r10
    xor rdx, rdx
    mov rbx, 10
    div rbx
    add al, '0'
    mov [rdi], al
    inc rdi
    add dl, '0'
    mov [rdi], dl
    inc rdi

.done:
    mov byte [rdi], 0
    mov rax, r11

    pop rdi
    pop rsi
    pop rbx
    pop rbp
    ret

get_base_name:
    cmp rcx, BASE_DEC
    je .dec
    cmp rcx, BASE_HEX
    je .hex
    lea rax, [name_bin]
    ret

.dec:
    lea rax, [name_dec]
    ret

.hex:
    lea rax, [name_hex]
    ret
