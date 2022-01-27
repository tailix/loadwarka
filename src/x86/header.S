#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

.code16

.section .header
    ljmp $0, $_start
.align 4
// Size
.word program_size
