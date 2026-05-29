default rel

%include "constants.inc"

section .data
global scale_q
global scale2_q

scale_q  dq 100
scale2_q dq 10000

section .bss
global current_type
global current_base
global selected_op
global use_last
global op_a
global op_b
global op_result
global op_symbol_ptr
global has_result
global last_result
global last_type
global last_base
global conv_src_base
global conv_dst_base

current_type  resq 1
current_base  resq 1
selected_op   resq 1
use_last      resq 1
op_a          resq 1
op_b          resq 1
op_result     resq 1
op_symbol_ptr resq 1

has_result resq 1
last_result resq 1
last_type   resq 1
last_base   resq 1

conv_src_base resq 1
conv_dst_base resq 1
