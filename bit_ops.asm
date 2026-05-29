default rel

global bit_and
global bit_or
global bit_xor
global bit_not

section .text

bit_and:
    mov eax, ecx
    and eax, edx
    movsxd rax, eax
    xor edx, edx
    ret

bit_or:
    mov eax, ecx
    or eax, edx
    movsxd rax, eax
    xor edx, edx
    ret

bit_xor:
    mov eax, ecx
    xor eax, edx
    movsxd rax, eax
    xor edx, edx
    ret

bit_not:
    mov eax, ecx
    not eax
    movsxd rax, eax
    xor edx, edx
    ret
