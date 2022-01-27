#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

.code16
.global _start
.extern init

.section .start
_start:
    ljmp $0, $init
