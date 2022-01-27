#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

.code16
.global hang
.global print_char
.global print_str
.global print_number

.section .text
hang:
    cli
    hlt
    jmp hang

do_ret:
    ret

// AL - char
print_char:
    mov $0x0E,   %ah
    mov $0x0001, %bx
    int $0x10
    ret

// SI - string pointer
print_str:
    lodsb
    test %al, %al
    jz do_ret
    call print_char
    jmp print_str

// AX - number
print_number:
    test %ax, %ax
    jnz print_number_notnull
    mov $0x0e, %ah
    mov $'0', %al
    int $0x10
    ret

// AX - number
print_number_notnull:
    test %ax, %ax
    jz do_ret

    // DX - dividend high (always zero)
    // AX - dividend low
    xor %dx, %dx
    // BX - divisor (always 10)
    mov $10, %bx
    // AX - quotient
    // DX - remainder
    div %bx

    push %dx
    call print_number_notnull
    pop %dx

    mov $0x0e, %ah
    mov %dl, %al
    add $'0', %al
    int $0x10

    ret
