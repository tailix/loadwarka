#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

.code16
.global hang
.global print_char
.global print_str

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
