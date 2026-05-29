default rel

%include "constants.inc"

global program_loop

extern show_main_menu
extern show_dec_menu
extern show_hex_menu
extern show_bin_menu
extern show_after_result_menu
extern prompt_choice
extern run_conversion_menu
extern show_result_conversion
extern read_choice
extern read_fixed_value
extern read_int_value_current_base
extern print_z
extern print_binary_result
extern print_unary_result

extern dec_add
extern dec_sub
extern dec_mul
extern dec_div
extern dec_neg
extern dec_square
extern dec_reciprocal
extern int_add
extern int_sub
extern int_mul
extern int_div
extern bit_and
extern bit_or
extern bit_xor
extern bit_not

extern current_type
extern current_base
extern selected_op
extern use_last
extern op_a
extern op_b
extern op_result
extern op_symbol_ptr
extern has_result
extern last_result
extern last_type
extern last_base

extern msg_first
extern msg_second
extern msg_invalid_choice
extern msg_invalid_number
extern msg_div_zero
extern msg_no_result

extern sym_add
extern sym_sub
extern sym_mul
extern sym_div
extern sym_and
extern sym_or
extern sym_xor

section .text

program_loop:
    push rbp
    mov rbp, rsp

.main_menu:
    call show_main_menu
    call prompt_choice
    call read_choice

    cmp rax, 1
    je .dec_new
    cmp rax, 2
    je .hex_new
    cmp rax, 3
    je .bin_new
    cmp rax, 4
    je .convert_menu
    cmp rax, 0
    je .exit

    lea rcx, [msg_invalid_choice]
    call print_z
    jmp .main_menu

.dec_new:
    mov qword [current_type], TYPE_FIXED
    mov qword [current_base], BASE_DEC
    mov qword [use_last], 0
    jmp .dec_menu

.dec_continue:
    mov qword [current_type], TYPE_FIXED
    mov qword [current_base], BASE_DEC
    mov qword [use_last], 1

.dec_menu:
    call show_dec_menu
    call prompt_choice
    call read_choice

    cmp rax, 0
    je .main_menu
    cmp rax, 1
    jl .bad_dec_choice
    cmp rax, 7
    jg .bad_dec_choice

    mov [selected_op], rax

    cmp qword [use_last], 1
    je .dec_have_a

    lea rcx, [msg_first]
    call print_z
    call read_fixed_value
    cmp rdx, 0
    jne .bad_number_dec
    mov [op_a], rax
    jmp .dec_check_binary

.dec_have_a:
    mov rax, [last_result]
    mov [op_a], rax

.dec_check_binary:
    mov rax, [selected_op]
    cmp rax, 4
    jg .dec_compute

    lea rcx, [msg_second]
    call print_z
    call read_fixed_value
    cmp rdx, 0
    jne .bad_number_dec
    mov [op_b], rax

.dec_compute:
    cmp qword [selected_op], 4
    jle .call_dec
    mov qword [op_b], 0

.call_dec:
    call call_dec_selected
    cmp rdx, 1
    je .div_zero_dec
    cmp rdx, 0
    jne .bad_dec_choice
    mov [op_result], rax

    mov rax, [selected_op]
    cmp rax, 4
    jg .print_dec_unary
    call print_binary_result
    jmp .store_fixed_result

.print_dec_unary:
    call print_unary_result

.store_fixed_result:
    mov rax, [op_result]
    mov [last_result], rax
    mov qword [last_type], TYPE_FIXED
    mov qword [last_base], BASE_DEC
    mov qword [has_result], 1
    mov qword [use_last], 0
    jmp .after_result

.bad_dec_choice:
    lea rcx, [msg_invalid_choice]
    call print_z
    jmp .dec_menu

.bad_number_dec:
    lea rcx, [msg_invalid_number]
    call print_z
    jmp .dec_menu

.div_zero_dec:
    lea rcx, [msg_div_zero]
    call print_z
    jmp .dec_menu

.hex_new:
    mov qword [current_type], TYPE_INT
    mov qword [current_base], BASE_HEX
    mov qword [use_last], 0
    jmp .int_menu

.hex_continue:
    mov qword [current_type], TYPE_INT
    mov qword [current_base], BASE_HEX
    mov qword [use_last], 1
    jmp .int_menu

.bin_new:
    mov qword [current_type], TYPE_INT
    mov qword [current_base], BASE_BIN
    mov qword [use_last], 0
    jmp .int_menu

.bin_continue:
    mov qword [current_type], TYPE_INT
    mov qword [current_base], BASE_BIN
    mov qword [use_last], 1

.int_menu:
    cmp qword [current_base], BASE_HEX
    je .show_hex_menu
    call show_bin_menu
    jmp .read_int_menu

.show_hex_menu:
    call show_hex_menu

.read_int_menu:
    call prompt_choice
    call read_choice

    cmp rax, 0
    je .main_menu
    cmp rax, 1
    jl .bad_int_choice
    cmp rax, 8
    jg .bad_int_choice

    mov [selected_op], rax

    cmp qword [use_last], 1
    je .int_have_a

    lea rcx, [msg_first]
    call print_z
    call read_int_value_current_base
    cmp rdx, 0
    jne .bad_number_int
    mov [op_a], rax
    jmp .int_check_binary

.int_have_a:
    mov rax, [last_result]
    mov [op_a], rax

.int_check_binary:
    cmp qword [selected_op], 8
    je .int_compute

    lea rcx, [msg_second]
    call print_z

    call read_int_value_current_base
    cmp rdx, 0
    jne .bad_number_int
    mov [op_b], rax

.int_compute:
    cmp qword [selected_op], 8
    jne .call_int
    mov qword [op_b], 0

.call_int:
    call call_int_selected
    cmp rdx, 1
    je .div_zero_int
    cmp rdx, 0
    jne .bad_int_choice
    mov [op_result], rax

    cmp qword [selected_op], 8
    je .print_int_unary
    call print_binary_result
    jmp .store_int_result

.print_int_unary:
    call print_unary_result

.store_int_result:
    mov rax, [op_result]
    mov [last_result], rax
    mov qword [last_type], TYPE_INT
    mov rax, [current_base]
    mov [last_base], rax
    mov qword [has_result], 1
    mov qword [use_last], 0
    jmp .after_result

.bad_int_choice:
    lea rcx, [msg_invalid_choice]
    call print_z
    jmp .int_menu

.bad_number_int:
    lea rcx, [msg_invalid_number]
    call print_z
    jmp .int_menu

.div_zero_int:
    lea rcx, [msg_div_zero]
    call print_z
    jmp .int_menu

.convert_menu:
    call run_conversion_menu
    jmp .main_menu

.after_result:
    call show_after_result_menu
    call prompt_choice
    call read_choice

    cmp rax, 1
    je .continue_with_result
    cmp rax, 2
    je .convert_last_result
    cmp rax, 3
    je .new_same_mode
    cmp rax, 0
    je .main_menu

    lea rcx, [msg_invalid_choice]
    call print_z
    jmp .after_result

.continue_with_result:
    cmp qword [has_result], 1
    jne .no_result_after
    cmp qword [last_type], TYPE_FIXED
    je .dec_continue
    cmp qword [last_base], BASE_HEX
    je .hex_continue
    cmp qword [last_base], BASE_BIN
    je .bin_continue
    jmp .main_menu

.convert_last_result:
    call show_result_conversion
    jmp .after_result

.new_same_mode:
    cmp qword [last_type], TYPE_FIXED
    je .dec_new
    cmp qword [last_base], BASE_HEX
    je .hex_new
    cmp qword [last_base], BASE_BIN
    je .bin_new
    jmp .main_menu

.no_result_after:
    lea rcx, [msg_no_result]
    call print_z
    jmp .after_result

.exit:
    pop rbp
    ret

call_dec_selected:
    push rbp
    mov rbp, rsp

    mov rax, [selected_op]
    cmp rax, 1
    je .add
    cmp rax, 2
    je .sub
    cmp rax, 3
    je .mul
    cmp rax, 4
    je .div
    cmp rax, 5
    je .neg
    cmp rax, 6
    je .square
    cmp rax, 7
    je .reciprocal
    jmp .invalid

.add:
    lea rax, [sym_add]
    mov [op_symbol_ptr], rax
    mov rcx, [op_a]
    mov rdx, [op_b]
    call dec_add
    jmp .done

.sub:
    lea rax, [sym_sub]
    mov [op_symbol_ptr], rax
    mov rcx, [op_a]
    mov rdx, [op_b]
    call dec_sub
    jmp .done

.mul:
    lea rax, [sym_mul]
    mov [op_symbol_ptr], rax
    mov rcx, [op_a]
    mov rdx, [op_b]
    call dec_mul
    jmp .done

.div:
    lea rax, [sym_div]
    mov [op_symbol_ptr], rax
    mov rcx, [op_a]
    mov rdx, [op_b]
    call dec_div
    jmp .done

.neg:
    mov rcx, [op_a]
    call dec_neg
    jmp .done

.square:
    mov rcx, [op_a]
    call dec_square
    jmp .done

.reciprocal:
    mov rcx, [op_a]
    call dec_reciprocal
    jmp .done

.invalid:
    xor rax, rax
    mov edx, 2

.done:
    pop rbp
    ret

call_int_selected:
    push rbp
    mov rbp, rsp

    mov rax, [selected_op]
    cmp rax, 1
    je .add
    cmp rax, 2
    je .sub
    cmp rax, 3
    je .mul
    cmp rax, 4
    je .div
    cmp rax, 5
    je .and
    cmp rax, 6
    je .or
    cmp rax, 7
    je .xor
    cmp rax, 8
    je .not
    jmp .invalid

.add:
    lea rax, [sym_add]
    mov [op_symbol_ptr], rax
    mov rcx, [op_a]
    mov rdx, [op_b]
    call int_add
    jmp .done

.sub:
    lea rax, [sym_sub]
    mov [op_symbol_ptr], rax
    mov rcx, [op_a]
    mov rdx, [op_b]
    call int_sub
    jmp .done

.mul:
    lea rax, [sym_mul]
    mov [op_symbol_ptr], rax
    mov rcx, [op_a]
    mov rdx, [op_b]
    call int_mul
    jmp .done

.div:
    lea rax, [sym_div]
    mov [op_symbol_ptr], rax
    mov rcx, [op_a]
    mov rdx, [op_b]
    call int_div
    jmp .done

.and:
    lea rax, [sym_and]
    mov [op_symbol_ptr], rax
    mov rcx, [op_a]
    mov rdx, [op_b]
    call bit_and
    jmp .done

.or:
    lea rax, [sym_or]
    mov [op_symbol_ptr], rax
    mov rcx, [op_a]
    mov rdx, [op_b]
    call bit_or
    jmp .done

.xor:
    lea rax, [sym_xor]
    mov [op_symbol_ptr], rax
    mov rcx, [op_a]
    mov rdx, [op_b]
    call bit_xor
    jmp .done

.not:
    mov rcx, [op_a]
    call bit_not
    jmp .done

.invalid:
    xor rax, rax
    mov edx, 2

.done:
    pop rbp
    ret
