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
STAGE1_START

disk: .byte 0

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

    mov $0x02,        %ah
    mov $1,           %al /* Sectors count       */
    mov $0x80,        %dl /* Drive               */
    mov $0,           %ch /* Cylinder            */
    mov $0,           %dh /* Head                */
    mov $2,           %cl /* Cylinder and sector */
    mov $STAGE2_BASE, %bx /* Address             */
    int $0x13

    ljmp $0, $STAGE2_BASE

hang:
    cli
    hlt
    jmp hang
