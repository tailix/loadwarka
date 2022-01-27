#!/bin/sh

set -e

./build.sh

qemu-system-i386 disk.img
