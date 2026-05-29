default rel

global mainCRTStartup

extern ExitProcess
extern init_console
extern program_loop

section .text

mainCRTStartup:
    and rsp, -16

    call init_console
    call program_loop

    xor ecx, ecx
    sub rsp, 32
    call ExitProcess
