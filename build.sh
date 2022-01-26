#!/bin/sh

set -e

BIN='../cross/root/bin'
CROSS="$BIN/i386-elf-"

${CROSS}as -c src/x86_stage1.S -o src/x86_stage1.o
${CROSS}as -c src/x86_stage2.S -o src/x86_stage2.o
${CROSS}ld -Ttext 200000 --oformat binary -o src/x86_stage1.bin src/x86_stage1.o
${CROSS}ld -Ttext 200000 --oformat binary -o src/x86_stage2.bin src/x86_stage2.o
./testyboot mbr mbr.bin src/x86_stage1.bin
cat mbr.bin src/x86_stage2.bin > disk.img
