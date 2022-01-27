#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#define STACK_BASE  0x2000

.code16
.global disk_number
.global restore_disk_number

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
