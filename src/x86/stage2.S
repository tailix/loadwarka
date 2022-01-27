#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

.code16
.global _start

.section .rodata
disk_number: .string "Disk number: "

.section .text
_start:
    mov $disk_number, %si
    call print_str

    call restore_disk_number
    xor %ax, %ax
    mov %dl, %al
    call print_number

    mov $newline, %si
    call print_str

    call main

    ljmp $0, $hang
