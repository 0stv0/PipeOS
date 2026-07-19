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

echo "[5] Creating .bashrc";
sudo mkdir -p "$MNT_DIR/root";
echo "enable -n help" > /tmp/pipeos-bashrc;
sudo cp /tmp/pipeos-bashrc "$MNT_DIR/root/.bashrc";

echo "[6] Creating essential directories";
sudo mkdir -p "$MNT_DIR/dev" "$MNT_DIR/proc" "$MNT_DIR/sys" "$MNT_DIR/root";

echo "[7] Unmounting";
sudo umount "$MNT_DIR";

echo "[8] Done";
echo "Disk image: $DISK_IMG";
ls -lh "$DISK_IMG";
