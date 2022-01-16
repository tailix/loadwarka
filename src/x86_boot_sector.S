#ifdef HAVE_CONFIG_H
#include "config.h"
#endif
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
    mov $',', %al
    int $0x10
    mov $' ', %al
    int $0x10
    mov $'W', %al
    int $0x10
    mov $'o', %al
    int $0x10
    mov $'r', %al
    int $0x10
    mov $'l', %al
    int $0x10
    mov $'d', %al
    int $0x10
    mov $'!', %al
    int $0x10
    mov $'\r', %al
    int $0x10
    mov $'\n', %al
    int $0x10
_loop:
    jmp _loop
