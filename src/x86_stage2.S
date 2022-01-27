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

.code16
.global _start
.section .text
_start:
    ljmp $0, $main

.align 2
size: .word _end - _start

hello2: .string "Hello from stage 2!\r\n"
hello3: .string "Hello from sector 3!\r\n"

main:
    mov $hello2, %si
    call print_str

    mov $teststr, %si
    call print_str

    ljmp $0, $additional

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

.fill 437, 1, 0

teststr: .string "Test string\r\n"

additional:
    mov $hello3, %si
    call print_str

hang:
    cli
    hlt
    jmp hang

_end:
