#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

.code16
.extern _start
.extern program_size

.section .header
    ljmp $0, $_start
.align 4
// Size
.word program_size
