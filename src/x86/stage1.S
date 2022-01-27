#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#define STACK_BASE  0x2000
#define STAGE2_BASE 0x7e00
#define STAGE2_SIZE (STAGE2_BASE + 8)

.code16
.global _start

.section .rodata
disk: .byte 0
newline: .string "\r\n"
hello: .string "Hello from stage 1!\r\n"
size_str: .string "Stage 2 size: "
number_of_sectors: .string "Number of sectors: "
reading_sector: .string "Reading sector "
parenth: .string " ("
of: .string " of "
to_address: .string ") to address "

.section .text
_start:
    cli
    xor %ax, %ax
    mov %ax, %ss
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov $STACK_BASE, %sp

    mov %dl, disk

    mov $hello, %si
    call print_str

    mov $1, %ax
    mov $STAGE2_BASE, %bx
    xor %cx, %cx
    call print_reading_state

    mov $0x02,        %ah
    mov $1,           %al // Sectors count
    mov $0x80,        %dl // Drive
    mov $0,           %ch // Cylinder
    mov $0,           %dh // Head
    mov $2,           %cl // Cylinder and sector
    mov $STAGE2_BASE, %bx // Address
    int $0x13

    mov $STAGE2_SIZE, %bx
    mov (%bx), %ax
    call print_stage2_size

    // DX - dividend high (always zero)
    xor %dx, %dx
    // AX - dividend low
    mov $STAGE2_SIZE, %bx
    mov (%bx), %ax
    // BX - divisor (always 512)
    mov $512, %bx
    // AX - quotient
    // DX - remainder
    div %bx

    test %dx, %dx
    jz no_rem
    inc %ax
no_rem:

    push %ax
    call print_number_of_sectors
    pop %cx

    mov $STAGE2_BASE, %bx
    mov $1, %ax

    // AX - current sector index
    // BX - current address
    // CX - total number of sectors
read_loop:
    cmp %ax, %cx
    je finish

    add $512, %bx
    inc %ax

    push %ax
    push %bx
    push %cx

    call print_reading_state

    pop %cx
    pop %bx
    pop %ax
    push %ax
    push %bx
    push %cx

    add $1, %ax
    mov %al,          %cl // Cylinder and sector
    mov $0x02,        %ah
    mov $1,           %al // Sectors count
    mov $0x80,        %dl // Drive
    mov $0,           %ch // Cylinder
    mov $0,           %dh // Head
    int $0x13

    pop %cx
    pop %bx
    pop %ax
    jmp read_loop

finish:
    ljmp $0, $STAGE2_BASE

hang:
    cli
    hlt
    jmp hang

do_ret:
    ret

// AL - char
print_char:
    mov $0x0e,   %ah
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

// AX - size
print_stage2_size:
    push %ax

    mov $size_str, %si
    call print_str

    pop %ax
    call print_number

    mov $newline, %si
    call print_str

    ret

// AX - number of sectors
print_number_of_sectors:
    push %ax

    mov $number_of_sectors, %si
    call print_str

    pop %ax
    call print_number

    mov $newline, %si
    call print_str

    ret

// AX - current sector index
// BX - current address
// CX - total number of sectors
print_reading_state:
    push %ax
    push %bx
    push %cx

    mov $reading_sector, %si
    call print_str

    pop %cx
    pop %bx
    pop %ax
    push %ax
    push %bx
    push %cx

    inc %ax
    call print_number

    mov $parenth, %si
    call print_str

    pop %cx
    pop %bx
    pop %ax
    push %ax
    push %bx
    push %cx

    call print_number

    mov $of, %si
    call print_str

    pop %cx
    // pop %bx
    // pop %ax
    // push %ax
    // push %bx
    push %cx

    mov %cx, %ax
    call print_number

    mov $to_address, %si
    call print_str

    pop %cx
    pop %bx
    // pop %ax
    // push %ax
    push %bx
    push %cx

    mov %bx, %ax
    call print_number

    mov $newline, %si
    call print_str

    pop %cx
    pop %bx
    pop %ax
    ret
