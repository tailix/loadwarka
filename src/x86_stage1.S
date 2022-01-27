/*
    Copyright (c) 2008-2009 Micah Elizabeth Scott
    Copyright (c) 2022 Alex Kotov <kotovalexarian@gmail.com>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "x86_common.h"

.code16
.global _start
.section .text
_start:
    ljmp $0, $STAGE1_ADDR(main)

.align 4
size: .word _end - _start

disk: .byte 0
newline: .string "\r\n"
hello: .string "Hello stage 1!\r\n"
stage1_size_str: .string "Stage 1 size: "
stage2_size_str: .string "Stage 2 size: "

main:
    cli
    xor %ax, %ax
    mov %ax, %ss
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov $STACK_BASE, %sp

    mov %dl, STAGE1_ADDR(disk)

    mov $STAGE1_ADDR(hello), %si
    call print_str

    mov $0x02,        %ah
    mov $1,           %al /* Sectors count       */
    mov $0x80,        %dl /* Drive               */
    mov $0,           %ch /* Cylinder            */
    mov $0,           %dh /* Head                */
    mov $2,           %cl /* Cylinder and sector */
    mov $STAGE2_BASE, %bx /* Address             */
    int $0x13

    mov $STAGE1_ADDR(stage1_size_str), %si
    call print_str

    mov $STAGE1_ADDR(size), %bx
    mov (%bx), %ax
    call print_number

    mov $STAGE1_ADDR(newline), %si
    call print_str

    mov $STAGE1_ADDR(stage2_size_str), %si
    call print_str

    mov $STAGE2_ADDR(size), %bx
    mov (%bx), %ax
    call print_number

    mov $STAGE1_ADDR(newline), %si
    call print_str

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
    jmp do_ret

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

_end:
