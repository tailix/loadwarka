#!/bin/sh

set -e

BIN='vendor/cross/root/bin'
CROSS="$BIN/i386-elf-"

./clean.sh

${CROSS}gcc -c src/x86_stage1.S -o src/x86_stage1.o
${CROSS}gcc -c src/x86_stage2.S -o src/x86_stage2.o
${CROSS}ld -Tsrc/x86_stage1.ld -o src/x86_stage1.bin src/x86_stage1.o
${CROSS}ld -Tsrc/x86_stage2.ld -o src/x86_stage2.bin src/x86_stage2.o
./testyboot mbr mbr.bin src/x86_stage1.bin
cat mbr.bin src/x86_stage2.bin > disk.img
