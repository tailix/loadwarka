#!/bin/sh

set -e

BIN='vendor/cross/root/bin'
SRC='src/x86'
CROSS="$BIN/i386-elf-"

STAGE1_LDFLAGS='--defsym=program_start=0x7c00'
STAGE2_LDFLAGS='--defsym=program_start=0x7e00'

STAGE1_OBJS="$SRC/common.o $SRC/stage1.o"
STAGE2_OBJS="$SRC/common.o $SRC/stage2.o $SRC/main.o"

./clean.sh

${CROSS}gcc -c $SRC/common.S -o $SRC/common.o
${CROSS}gcc -c $SRC/stage1.S -o $SRC/stage1.o
${CROSS}gcc -c $SRC/stage2.S -o $SRC/stage2.o
${CROSS}gcc -c $SRC/main.c   -o $SRC/main.o

${CROSS}ld -T$SRC/linker.ld -o $SRC/stage1.bin $STAGE1_LDFLAGS $STAGE1_OBJS
${CROSS}ld -T$SRC/linker.ld -o $SRC/stage2.bin $STAGE2_LDFLAGS $STAGE2_OBJS

./testyboot mbr mbr.bin $SRC/stage1.bin
cat mbr.bin $SRC/stage2.bin > disk.img
