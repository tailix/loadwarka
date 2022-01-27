#!/bin/sh

set -e

BIN='vendor/cross/root/bin'
SRC='src/x86'
CROSS="$BIN/i386-elf-"

./clean.sh

${CROSS}gcc -c $SRC/start.S  -o $SRC/start.o
${CROSS}gcc -c $SRC/stage1.S -o $SRC/stage1.o
${CROSS}gcc -c $SRC/stage2.S -o $SRC/stage2.o

${CROSS}ld -T$SRC/stage1.ld -o $SRC/stage1.bin $SRC/start.o $SRC/stage1.o
${CROSS}ld -T$SRC/stage2.ld -o $SRC/stage2.bin $SRC/start.o $SRC/stage2.o

./testyboot mbr mbr.bin $SRC/stage1.bin
cat mbr.bin $SRC/stage2.bin > disk.img
