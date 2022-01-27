#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

.code16
.global _start

.section .rodata
disk_number: .string "Disk number: "
hello2: .string "Hello from stage 2!\r\n"
hello3: .string "Hello from sector 3!\r\n"
hello4: .string "Hello from sector 4!\r\n"

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

    mov $hello2, %si
    call print_str

    mov $teststr3, %si
    call print_str

    mov $teststr4, %si
    call print_str

    ljmp $0, $sector3

.fill 512, 1, 0

teststr3: .string "Test string from sector 3\r\n"

sector3:
    mov $hello3, %si
    call print_str

    ljmp $0, $sector4

.fill 512, 1, 0

teststr4: .string "Test string from sector 4\r\n"

sector4:
    mov $hello4, %si
    call print_str
    ljmp $0, $hang
