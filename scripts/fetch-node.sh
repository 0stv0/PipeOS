#!/bin/bash
set -e;

NODE_VERSION="v22.14.0";
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)";
BUILD_DIR="$ROOT_DIR/build";

mkdir -p "$BUILD_DIR";
cd "$BUILD_DIR";

if [ ! -d "node" ]; then
	echo "[1] Downloading NodeJS";
	wget "https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-linux-x64.tar.xz";

	echo "[2] Extracting NodeJS";
	tar xf "node-${NODE_VERSION}-linux-x64.tar.xz";
	mv "node-${NODE_VERSION}-linux-x64" node;
	rm -f "node-${NODE_VERSION}-linux-x64.tar.xz";
else
	echo "[*] Node.js already present at build/node, skipping download";
fi

echo "[*] Done NodeJS";
"$BUILD_DIR/node/bin/node" --version;
