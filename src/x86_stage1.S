#ifdef HAVE_CONFIG_H
#include "config.h"
#endif
.code16
.global _start
.section .text
_start:
    cli
    xor %ax, %ax
    mov %ax, %ss
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov $0x2000, %sp

    mov $0x02,   %ah
    mov $1,      %al /* Sectors count       */
    mov $0x80,   %dl /* Drive               */
    mov $0,      %ch /* Cylinder            */
    mov $0,      %dh /* Head                */
    mov $2,      %cl /* Cylinder and sector */
    mov $0x7e00, %bx /* Address             */
    int $0x13

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
    mov $'1', %al
    int $0x10
    mov $'!', %al
    int $0x10
    mov $'\r', %al
    int $0x10
    mov $'\n', %al
    int $0x10

    ljmp $0, $0x7e00

_loop:
    cli
    hlt
    jmp _loop
