#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

.code16
.extern _start

.section .header
    ljmp $0, $_start
