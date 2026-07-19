#!/bin/bash
set -e;

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)";
BUILD_DIR="$ROOT_DIR/build";
DISK_IMG="$BUILD_DIR/pipeos-disk.img";
MNT_DIR="/tmp/pipeos-rootfs";

CMDS=(
	"ls"
	"cat"
	"mkdir"
	"rm"
	"cp"
	"mv"
	"grep"
	"ps"
	"mount"
	"unmount"
	"echo"
	"pwd"
	"sh"
	"vi"
	"clear"
	"env"
);

echo "[1] Creating disk image";
mkdir -p "$BUILD_DIR";
dd if=/dev/zero of="$DISK_IMG" bs=1M count=512;
mkfs.ext4 -F "$DISK_IMG";

echo "[2] Mounting";
mkdir -p "$MNT_DIR";
sudo mount -o loop "$DISK_IMG" "$MNT_DIR";

echo "[3] Installing init";
if [ ! -f "$BUILD_DIR/init" ]; then
    echo "!! build/init not found, run build-modules.sh first";
    sudo umount "$MNT_DIR";
    exit 1;
fi
sudo cp "$BUILD_DIR/init" "$MNT_DIR/init";

echo "[4] Installing bash and busybox";
sudo mkdir -p "$MNT_DIR/bin";
sudo cp /bin/bash-static "$MNT_DIR/bin/bash";
sudo cp /bin/busybox "$MNT_DIR/bin/busybox";
for cmd in "${CMDS[@]}"; do
    sudo ln -sf busybox "$MNT_DIR/bin/$cmd";
done
sudo mkdir -p "$MNT_DIR/usr/bin";
sudo ln -sf /bin/busybox "$MNT_DIR/usr/bin/env";
sudo cp "$BUILD_DIR/pipeos" "$MNT_DIR/bin/pipeos";
sudo chmod +x "$MNT_DIR/bin/pipeos";

echo "[5] Creating .bashrc";
sudo mkdir -p "$MNT_DIR/root";
echo "enable -n help" > /tmp/pipeos-bashrc;
sudo cp /tmp/pipeos-bashrc "$MNT_DIR/root/.bashrc";

echo "[6] Creating essential directories";
sudo mkdir -p "$MNT_DIR/dev" "$MNT_DIR/proc" "$MNT_DIR/sys" "$MNT_DIR/root" "$MNT_DIR/var/pipeos";
sudo touch "$MNT_DIR/var/pipeos/.pipelines";

echo "[7] Installing NodeJS";
sudo mkdir -p "$MNT_DIR/usr/local/node";
sudo cp -r "$BUILD_DIR/node/"* "$MNT_DIR/usr/local/node";
sudo ln -sf /usr/local/node/bin/node "$MNT_DIR/bin/node";
sudo ln -sf /usr/local/node/bin/npm "$MNT_DIR/bin/npm";
sudo ln -sf /usr/local/node/bin/npx "$MNT_DIR/bin/npx";
sudo mkdir -p "$MNT_DIR/lib/x86_64-linux-gnu" "$MNT_DIR/lib64";
for lib in libdl.so.2 libstdc++.so.6 libm.so.6 libgcc_s.so.1 libpthread.so.0 libc.so.6; do
	sudo cp "/usr/lib/x86_64-linux-gnu/$lib" "$MNT_DIR/lib/x86_64-linux-gnu/$lib";
done
sudo cp /lib64/ld-linux-x86-64.so.2 "$MNT_DIR/lib64/ld-linux-x86-64.so.2";

echo "[7] Unmounting";
sudo umount "$MNT_DIR";

echo "[8] Done";
echo "Disk image: $DISK_IMG";
ls -lh "$DISK_IMG";
