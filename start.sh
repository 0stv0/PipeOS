#!/bin/bash
set -e

./scripts/build-modules.sh;
./scripts/build-rootfs.sh;

qemu-system-x86_64 -kernel build/linux-6.12/arch/x86/boot/bzImage -drive file=build/pipeos-disk.img,format=raw -append "root=/dev/sda rw console=ttyS0 quiet loglevel=0 init=/init" -nographic;
