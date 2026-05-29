default rel

%include "constants.inc"

global read_choice
global read_fixed_value
global read_int_value_current_base
global parse_int
global parse_fixed

extern read_input
extern input_buf
extern current_base

section .text

read_choice:
    push rbp
    mov rbp, rsp

    call read_input
    lea rcx, [input_buf]
    mov edx, BASE_DEC
    call parse_int
    cmp rdx, 0
    je .ok
    mov rax, -1

.ok:
    pop rbp
    ret

read_fixed_value:
    push rbp
    mov rbp, rsp

    call read_input
    lea rcx, [input_buf]
    call parse_fixed

    pop rbp
    ret

read_int_value_current_base:
    push rbp
    mov rbp, rsp

    call read_input
    lea rcx, [input_buf]
    mov rdx, [current_base]
    call parse_int

    pop rbp
    ret

parse_int:
    push rbp
    mov rbp, rsp

    mov r9, rcx
    mov r8, rdx
    xor r10, r10
    mov r11, 1
    xor ecx, ecx

.skip_spaces:
    mov al, [r9]
    cmp al, ' '
    je .skip_one
    cmp al, 9
    je .skip_one
    jmp .read_sign

.skip_one:
    inc r9
    jmp .skip_spaces

.read_sign:
    cmp al, '-'
    jne .check_plus
    mov r11, -1
    inc r9
    jmp .check_prefix

.check_plus:
    cmp al, '+'
    jne .check_prefix
    inc r9

.check_prefix:
    cmp byte [r9], '0'
    jne .digit_loop

    cmp r8, BASE_HEX
    jne .check_bin_prefix
    mov al, [r9 + 1]
    cmp al, 'x'
    je .skip_prefix
    cmp al, 'X'
    je .skip_prefix
    jmp .digit_loop

.check_bin_prefix:
    cmp r8, BASE_BIN
    jne .digit_loop
    mov al, [r9 + 1]
    cmp al, 'b'
    je .skip_prefix
    cmp al, 'B'
    je .skip_prefix
    jmp .digit_loop

.skip_prefix:
    add r9, 2

.digit_loop:
    movzx eax, byte [r9]
    cmp al, 0
    je .finish
    cmp al, ' '
    je .finish_spaces
    cmp al, 9
    je .finish_spaces

    cmp al, '0'
    jb .invalid
    cmp al, '9'
    jbe .digit_0_9
    cmp al, 'A'
    jb .check_lower
    cmp al, 'F'
    jbe .digit_A_F

.check_lower:
    cmp al, 'a'
    jb .invalid
    cmp al, 'f'
    ja .invalid
    sub al, 'a' - 10
    jmp .have_digit

.digit_A_F:
    sub al, 'A' - 10
    jmp .have_digit

.digit_0_9:
    sub al, '0'

.have_digit:
    movzx rax, al
    cmp rax, r8
    jae .invalid
    imul r10, r8
    add r10, rax
    inc rcx
    inc r9
    jmp .digit_loop

.finish_spaces:
    inc r9
    mov al, [r9]
    cmp al, ' '
    je .finish_spaces
    cmp al, 9
    je .finish_spaces
    cmp al, 0
    jne .invalid

.finish:
    cmp rcx, 0
    je .invalid

    cmp r8, BASE_HEX
    jne .check_bin_limit
    cmp rcx, 8
    ja .invalid
    jmp .apply_sign

.check_bin_limit:
    cmp r8, BASE_BIN
    jne .apply_sign
    cmp rcx, 32
    ja .invalid

.apply_sign:
    mov rax, r10
    cmp r11, 1
    je .positive_value

    cmp r8, BASE_DEC
    je .negative_value
    mov rax, 80000000h
    cmp r10, rax
    ja .invalid

.negative_value:
    mov rax, r10
    neg rax
    jmp .ok

.positive_value:
    cmp r8, BASE_DEC
    je .ok
    movsxd rax, eax

.ok:
    xor edx, edx
    pop rbp
    ret

.invalid:
    xor rax, rax
    mov edx, 1
    pop rbp
    ret

parse_fixed:
    push rbp
    mov rbp, rsp
    push r12
    push r13

    mov r9, rcx
    xor r10, r10
    xor r8, r8
    mov r11, 1
    xor r12d, r12d
    xor r13d, r13d

.skip_spaces:
    mov al, [r9]
    cmp al, ' '
    je .skip_one
    cmp al, 9
    je .skip_one
    jmp .read_sign

.skip_one:
    inc r9
    jmp .skip_spaces

.read_sign:
    cmp al, '-'
    jne .check_plus
    mov r11, -1
    inc r9
    jmp .int_loop

.check_plus:
    cmp al, '+'
    jne .int_loop
    inc r9

.int_loop:
    mov al, [r9]
    cmp al, '0'
    jb .check_dot
    cmp al, '9'
    ja .check_dot

    movzx rax, al
    sub rax, '0'
    imul r10, 10
    add r10, rax
    inc r12
    inc r9
    jmp .int_loop

.check_dot:
    cmp al, '.'
    jne .end_parse
    inc r9

.frac_loop:
    mov al, [r9]
    cmp al, '0'
    jb .end_parse
    cmp al, '9'
    ja .end_parse

    cmp r13, 2
    jae .invalid
    movzx rax, al
    sub rax, '0'
    imul r8, 10
    add r8, rax
    inc r12
    inc r13
    inc r9
    jmp .frac_loop

.end_parse:
    mov al, [r9]
    cmp al, ' '
    je .skip_end_space
    cmp al, 9
    je .skip_end_space
    cmp al, 0
    jne .invalid
    jmp .validate

.skip_end_space:
    inc r9
    mov al, [r9]
    cmp al, ' '
    je .skip_end_space
    cmp al, 9
    je .skip_end_space
    cmp al, 0
    jne .invalid

.validate:
    cmp r12, 0
    je .invalid
    cmp r13, 1
    jne .build_result
    imul r8, 10

.build_result:
    mov rax, r10
    imul rax, 100
    add rax, r8
    cmp r11, 1
    je .ok
    neg rax

.ok:
    xor edx, edx
    pop r13
    pop r12
    pop rbp
    ret

.invalid:
    xor rax, rax
    mov edx, 1
    pop r13
    pop r12
    pop rbp
    ret
