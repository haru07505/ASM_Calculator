default rel

%include "constants.inc"

global init_console
global print_z
global read_input
global input_buf

extern GetStdHandle
extern ReadFile
extern WriteFile

section .bss
stdin_handle  resq 1
stdout_handle resq 1
bytes_io      resd 1
char_buf      resb 1
input_buf     resb MAX_INPUT

section .text

init_console:
    push rbp
    mov rbp, rsp

    sub rsp, 32
    mov ecx, STD_INPUT_HANDLE
    call GetStdHandle
    mov [stdin_handle], rax

    mov ecx, STD_OUTPUT_HANDLE
    call GetStdHandle
    mov [stdout_handle], rax
    add rsp, 32

    pop rbp
    ret

print_z:
    push rbp
    mov rbp, rsp

    mov r10, rcx
    xor rax, rax

.len_loop:
    cmp byte [r10 + rax], 0
    je .write
    inc rax
    jmp .len_loop

.write:
    mov rcx, [stdout_handle]
    mov rdx, r10
    mov r8, rax
    lea r9, [bytes_io]
    sub rsp, 48
    mov qword [rsp + 32], 0
    call WriteFile
    add rsp, 48

    pop rbp
    ret

read_input:
    push rbp
    mov rbp, rsp
    push rsi
    push rdi

    xor esi, esi
    lea rdi, [input_buf]

.read_char:
    mov rcx, [stdin_handle]
    lea rdx, [char_buf]
    mov r8d, 1
    lea r9, [bytes_io]
    sub rsp, 48
    mov qword [rsp + 32], 0
    call ReadFile
    add rsp, 48

    cmp dword [bytes_io], 0
    je .done

    mov al, [char_buf]
    cmp al, 13
    je .line_end
    cmp al, 10
    je .line_end

    cmp esi, MAX_INPUT - 1
    jae .read_char

    mov [rdi + rsi], al
    inc rsi
    jmp .read_char

.line_end:
    cmp esi, 0
    je .read_char
    jmp .done

.done:
    mov byte [rdi + rsi], 0
    mov rax, rsi

    pop rdi
    pop rsi
    pop rbp
    ret
