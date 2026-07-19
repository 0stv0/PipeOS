#!/bin/bash
set -e
KERNEL_VERSION="6.12"
BUILD_DIR="$(dirname "$0")/../build"

mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

if [ ! -d "linux-${KERNEL_VERSION}" ]; then
    wget "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${KERNEL_VERSION}.tar.xz"
    tar xf "linux-${KERNEL_VERSION}.tar.xz"
fi

cd "linux-${KERNEL_VERSION}"
make defconfig
make CC=gcc-13 -j$(nproc)

echo "Kernel built: $(pwd)/arch/x86/boot/bzImage"

