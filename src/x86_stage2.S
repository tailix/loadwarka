#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

.code16
.global _start
.extern program_size
.section .text
_start:
    ljmp $0, $main

.align 2
size: .word program_size

hello2: .string "Hello from stage 2!\r\n"
hello3: .string "Hello from sector 3!\r\n"
hello4: .string "Hello from sector 4!\r\n"

main:
    mov $hello2, %si
    call print_str

    mov $teststr3, %si
    call print_str

    mov $teststr4, %si
    call print_str

    ljmp $0, $sector3

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

.fill 512, 1, 0

teststr3: .string "Test string from sector 3\r\n"

sector3:
    mov $hello3, %si
    call print_str

    ljmp $0, $sector4

.fill 512, 1, 0

teststr4: .string "Test string from sector 4\r\n"

sector4:
    mov $hello4, %si
    call print_str

hang:
    cli
    hlt
    jmp hang
