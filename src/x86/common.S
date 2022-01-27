#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#define STACK_BASE 0x2000

.code16
.global newline
.global disk_number
.global restore_disk_number
.global hang
.global print_char
.global print_str
.global print_number

.section .rodata
newline: .string "\r\n"

.section .data
disk_number: .byte 0

.section .header
    ljmp $0, $init

.align 4
.word program_size

init:
    cli
    xor %ax, %ax
    mov %ax, %ss
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov $STACK_BASE, %sp
    mov %dl, disk_number
    ljmp $0, $_start

.section .text
restore_disk_number:
    mov $disk_number, %bx
    mov (%bx), %dl
    ret

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
