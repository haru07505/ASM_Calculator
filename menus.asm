default rel

global show_main_menu
global show_dec_menu
global show_hex_menu
global show_bin_menu
global show_convert_menu
global show_after_result_menu
global show_result_convert_menu
global prompt_choice

global msg_first
global msg_second
global msg_number
global msg_result_label
global msg_invalid_choice
global msg_invalid_number
global msg_div_zero
global msg_no_result
global msg_fraction_error
global msg_newline
global msg_space
global msg_equals
global msg_colon_space
global msg_neg_prefix
global msg_square_prefix
global msg_recip_prefix
global msg_close_equals
global msg_not_prefix

global sym_add
global sym_sub
global sym_mul
global sym_div
global sym_and
global sym_or
global sym_xor

extern print_z

section .data
msg_main_menu db 13,10
    db "===== ASM CALCULATOR =====",13,10
    db "1. DEC - So thuc",13,10
    db "2. HEX - So nguyen",13,10
    db "3. BIN - So nguyen",13,10
    db "4. Chuyen doi he so",13,10
    db "0. Thoat",13,10,0

msg_dec_menu db 13,10
    db "===== DEC - SO THUC =====",13,10
    db "1. Cong",13,10
    db "2. Tru",13,10
    db "3. Nhan",13,10
    db "4. Chia",13,10
    db "5. Doi dau",13,10
    db "6. Binh phuong",13,10
    db "7. Nghich dao",13,10
    db "0. Quay lai",13,10,0

msg_hex_menu db 13,10
    db "===== HEX - SO NGUYEN =====",13,10
    db "1. Cong",13,10
    db "2. Tru",13,10
    db "3. Nhan",13,10
    db "4. Chia",13,10
    db "5. AND",13,10
    db "6. OR",13,10
    db "7. XOR",13,10
    db "8. NOT",13,10
    db "0. Quay lai",13,10,0

msg_bin_menu db 13,10
    db "===== BIN - SO NGUYEN =====",13,10
    db "1. Cong",13,10
    db "2. Tru",13,10
    db "3. Nhan",13,10
    db "4. Chia",13,10
    db "5. AND",13,10
    db "6. OR",13,10
    db "7. XOR",13,10
    db "8. NOT",13,10
    db "0. Quay lai",13,10,0

msg_convert_menu db 13,10
    db "===== CHUYEN DOI HE SO =====",13,10
    db "Chi ho tro so nguyen.",13,10
    db "1. DEC -> HEX",13,10
    db "2. DEC -> BIN",13,10
    db "3. HEX -> DEC",13,10
    db "4. HEX -> BIN",13,10
    db "5. BIN -> DEC",13,10
    db "6. BIN -> HEX",13,10
    db "0. Quay lai",13,10,0

msg_after_result db 13,10
    db "Ban muon lam gi tiep?",13,10
    db "1. Tiep tuc tinh voi ket qua nay",13,10
    db "2. Doi ket qua sang he khac",13,10
    db "3. Lam phep tinh moi",13,10
    db "0. Menu chinh",13,10,0

msg_result_convert_menu db 13,10
    db "===== DOI KET QUA =====",13,10
    db "1. DEC",13,10
    db "2. HEX",13,10
    db "3. BIN",13,10
    db "0. Quay lai",13,10,0

msg_choice         db "Chon: ",0
msg_first          db "Nhap so thu nhat: ",0
msg_second         db "Nhap so thu hai: ",0
msg_number         db "Nhap so: ",0
msg_result_label   db "Ket qua ",0
msg_invalid_choice db "Lua chon khong hop le.",13,10,0
msg_invalid_number db "So nhap vao khong hop le.",13,10,0
msg_div_zero       db "Loi: khong the chia cho 0.",13,10,0
msg_no_result      db "Chua co ket qua de doi.",13,10,0
msg_fraction_error db "Khong the doi so thuc co phan le sang HEX/BIN.",13,10,0
msg_newline        db 13,10,0
msg_space          db " ",0
msg_equals         db " = ",0
msg_colon_space    db ": ",0
msg_neg_prefix     db "neg(",0
msg_square_prefix  db "square(",0
msg_recip_prefix   db "reciprocal(",0
msg_close_equals   db ") = ",0
msg_not_prefix     db "NOT ",0

sym_add db "+",0
sym_sub db "-",0
sym_mul db "*",0
sym_div db "/",0
sym_and db "AND",0
sym_or  db "OR",0
sym_xor db "XOR",0

section .text

show_main_menu:
    lea rcx, [msg_main_menu]
    jmp print_z

show_dec_menu:
    lea rcx, [msg_dec_menu]
    jmp print_z

show_hex_menu:
    lea rcx, [msg_hex_menu]
    jmp print_z

show_bin_menu:
    lea rcx, [msg_bin_menu]
    jmp print_z

show_convert_menu:
    lea rcx, [msg_convert_menu]
    jmp print_z

show_after_result_menu:
    lea rcx, [msg_after_result]
    jmp print_z

show_result_convert_menu:
    lea rcx, [msg_result_convert_menu]
    jmp print_z

prompt_choice:
    lea rcx, [msg_choice]
    jmp print_z
