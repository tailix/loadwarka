#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#define STACK_BASE  0x2000

.code16

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
    ljmp $0, $_start
