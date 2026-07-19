#!/bin/bash
set -e;

CC="gcc-13";
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)";
BUILD_DIR="$ROOT_DIR/build";
STAGING_DIR="/tmp/pipeos-initramfs";
OUTPUT="$BUILD_DIR/initramfs.cpio";

MODULES=(
	"init/init.c:init"
);

mkdir -p "$BUILD_DIR";
rm -rf "$STAGING_DIR";
mkdir -p "$STAGING_DIR";

echo "[1] Building Modules";
for entry in "${MODULES[@]}"; do
	src="${entry%%:*}";
	name="${entry##*:}";

	src_path="$ROOT_DIR/$src";
	out_path="$BUILD_DIR/$name";

	if [ ! -f "$src_path" ]; then
		echo "!! Skipping missing source: $src_path";
		continue;
	fi

	echo "-> $src => build/$name";
	"$CC" -static "$src_path" -o "$out_path";

	cp "$out_path" "$STAGING_DIR/$name";
done

echo "\n[2] Done";
