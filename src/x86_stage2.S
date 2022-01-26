/*
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
    mov $0x0E, %ah
    mov $'H', %al
    int $0x10
    mov $'e', %al
    int $0x10
    mov $'l', %al
    int $0x10
    mov $'l', %al
    int $0x10
    mov $'o', %al
    int $0x10
    mov $' ', %al
    int $0x10
    mov $'f', %al
    int $0x10
    mov $'r', %al
    int $0x10
    mov $'o', %al
    int $0x10
    mov $'m', %al
    int $0x10
    mov $' ', %al
    int $0x10
    mov $'S', %al
    int $0x10
    mov $'t', %al
    int $0x10
    mov $'a', %al
    int $0x10
    mov $'g', %al
    int $0x10
    mov $'e', %al
    int $0x10
    mov $' ', %al
    int $0x10
    mov $'2', %al
    int $0x10
    mov $'!', %al
    int $0x10
    mov $'\r', %al
    int $0x10
    mov $'\n', %al
    int $0x10

hang:
    cli
    hlt
    jmp hang
