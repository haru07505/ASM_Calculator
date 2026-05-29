default rel

%include "constants.inc"

global print_binary_result
global print_unary_result

extern print_z
extern format_current_value
extern format_int
extern current_type
extern selected_op
extern op_a
extern op_b
extern op_result
extern op_symbol_ptr

extern msg_space
extern msg_equals
extern msg_newline
extern msg_neg_prefix
extern msg_square_prefix
extern msg_recip_prefix
extern msg_close_equals
extern msg_not_prefix

section .bss
buf_a   resb 128
buf_b   resb 128
buf_res resb 128

section .text

print_binary_result:
    push rbp
    mov rbp, rsp

    mov rcx, [op_a]
    lea rdx, [buf_a]
    call format_current_value

    mov rcx, [op_b]
    lea rdx, [buf_b]
    call format_current_value

    mov rcx, [op_result]
    lea rdx, [buf_res]
    call format_current_value

    lea rcx, [buf_a]
    call print_z
    lea rcx, [msg_space]
    call print_z
    mov rcx, [op_symbol_ptr]
    call print_z
    lea rcx, [msg_space]
    call print_z
    lea rcx, [buf_b]
    call print_z
    lea rcx, [msg_equals]
    call print_z
    lea rcx, [buf_res]
    call print_z
    lea rcx, [msg_newline]
    call print_z

    pop rbp
    ret

print_unary_result:
    push rbp
    mov rbp, rsp

    mov rcx, [op_a]
    lea rdx, [buf_a]
    call format_current_value

    mov rcx, [op_result]
    lea rdx, [buf_res]
    call format_current_value

    cmp qword [current_type], TYPE_INT
    je .print_not

    cmp qword [selected_op], 5
    je .neg
    cmp qword [selected_op], 6
    je .square
    lea rcx, [msg_recip_prefix]
    jmp .print_fixed_unary

.neg:
    lea rcx, [msg_neg_prefix]
    jmp .print_fixed_unary

.square:
    lea rcx, [msg_square_prefix]

.print_fixed_unary:
    call print_z
    lea rcx, [buf_a]
    call print_z
    lea rcx, [msg_close_equals]
    call print_z
    lea rcx, [buf_res]
    call print_z
    lea rcx, [msg_newline]
    call print_z
    jmp .done

.print_not:
    lea rcx, [msg_not_prefix]
    call print_z
    lea rcx, [buf_a]
    call print_z
    lea rcx, [msg_equals]
    call print_z
    lea rcx, [buf_res]
    call print_z
    lea rcx, [msg_newline]
    call print_z

.done:
    pop rbp
    ret
