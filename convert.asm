default rel

%include "constants.inc"

global run_conversion_menu
global show_result_conversion
global print_conversion_result

extern show_convert_menu
extern show_result_convert_menu
extern prompt_choice
extern print_z
extern read_choice
extern read_input
extern parse_int
extern format_int
extern format_fixed
extern get_base_name
extern input_buf

extern op_a
extern last_result
extern last_type
extern has_result
extern conv_src_base
extern conv_dst_base
extern scale_q

extern msg_number
extern msg_invalid_choice
extern msg_invalid_number
extern msg_no_result
extern msg_fraction_error
extern msg_result_label
extern msg_space
extern msg_equals
extern msg_colon_space
extern msg_newline

section .bss
conv_buf_a   resb 128
conv_buf_res resb 128

section .text

run_conversion_menu:
    push rbp
    mov rbp, rsp

.menu_loop:
    call show_convert_menu
    call prompt_choice
    call read_choice

    cmp rax, 0
    je .done
    cmp rax, 1
    je .dec_hex
    cmp rax, 2
    je .dec_bin
    cmp rax, 3
    je .hex_dec
    cmp rax, 4
    je .hex_bin
    cmp rax, 5
    je .bin_dec
    cmp rax, 6
    je .bin_hex

    lea rcx, [msg_invalid_choice]
    call print_z
    jmp .menu_loop

.dec_hex:
    mov qword [conv_src_base], BASE_DEC
    mov qword [conv_dst_base], BASE_HEX
    jmp .do_conversion

.dec_bin:
    mov qword [conv_src_base], BASE_DEC
    mov qword [conv_dst_base], BASE_BIN
    jmp .do_conversion

.hex_dec:
    mov qword [conv_src_base], BASE_HEX
    mov qword [conv_dst_base], BASE_DEC
    jmp .do_conversion

.hex_bin:
    mov qword [conv_src_base], BASE_HEX
    mov qword [conv_dst_base], BASE_BIN
    jmp .do_conversion

.bin_dec:
    mov qword [conv_src_base], BASE_BIN
    mov qword [conv_dst_base], BASE_DEC
    jmp .do_conversion

.bin_hex:
    mov qword [conv_src_base], BASE_BIN
    mov qword [conv_dst_base], BASE_HEX

.do_conversion:
    lea rcx, [msg_number]
    call print_z
    call read_input
    lea rcx, [input_buf]
    mov rdx, [conv_src_base]
    call parse_int
    cmp rdx, 0
    jne .bad_number

    mov [op_a], rax
    call print_conversion_result
    jmp .menu_loop

.bad_number:
    lea rcx, [msg_invalid_number]
    call print_z
    jmp .menu_loop

.done:
    pop rbp
    ret

print_conversion_result:
    push rbp
    mov rbp, rsp

    mov rcx, [op_a]
    mov rdx, [conv_src_base]
    lea r8, [conv_buf_a]
    call format_int

    mov rcx, [op_a]
    mov rdx, [conv_dst_base]
    lea r8, [conv_buf_res]
    call format_int

    mov rcx, [conv_src_base]
    call get_base_name
    mov rcx, rax
    call print_z
    lea rcx, [msg_space]
    call print_z
    lea rcx, [conv_buf_a]
    call print_z
    lea rcx, [msg_equals]
    call print_z
    mov rcx, [conv_dst_base]
    call get_base_name
    mov rcx, rax
    call print_z
    lea rcx, [msg_space]
    call print_z
    lea rcx, [conv_buf_res]
    call print_z
    lea rcx, [msg_newline]
    call print_z

    pop rbp
    ret

show_result_conversion:
    push rbp
    mov rbp, rsp

    cmp qword [has_result], 1
    je .has_last
    lea rcx, [msg_no_result]
    call print_z
    jmp .done

.has_last:
    call show_result_convert_menu
    call prompt_choice
    call read_choice

    cmp rax, 0
    je .done
    cmp rax, 1
    je .target_dec
    cmp rax, 2
    je .target_hex
    cmp rax, 3
    je .target_bin
    lea rcx, [msg_invalid_choice]
    call print_z
    jmp .done

.target_dec:
    mov qword [conv_dst_base], BASE_DEC
    jmp .format_last

.target_hex:
    mov qword [conv_dst_base], BASE_HEX
    jmp .format_last

.target_bin:
    mov qword [conv_dst_base], BASE_BIN

.format_last:
    cmp qword [last_type], TYPE_FIXED
    je .format_fixed_last

    mov rcx, [last_result]
    mov rdx, [conv_dst_base]
    lea r8, [conv_buf_res]
    call format_int
    jmp .print_last_result

.format_fixed_last:
    cmp qword [conv_dst_base], BASE_DEC
    jne .fixed_to_int_base

    mov rcx, [last_result]
    lea rdx, [conv_buf_res]
    call format_fixed
    jmp .print_last_result

.fixed_to_int_base:
    mov rax, [last_result]
    cqo
    idiv qword [scale_q]
    cmp rdx, 0
    jne .fraction_error

    mov rcx, rax
    mov rdx, [conv_dst_base]
    lea r8, [conv_buf_res]
    call format_int
    jmp .print_last_result

.fraction_error:
    lea rcx, [msg_fraction_error]
    call print_z
    jmp .done

.print_last_result:
    lea rcx, [msg_result_label]
    call print_z
    mov rcx, [conv_dst_base]
    call get_base_name
    mov rcx, rax
    call print_z
    lea rcx, [msg_colon_space]
    call print_z
    lea rcx, [conv_buf_res]
    call print_z
    lea rcx, [msg_newline]
    call print_z

.done:
    pop rbp
    ret
