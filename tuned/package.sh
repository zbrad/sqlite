#!/usr/bin/env bash
# Packages the output of tuned/build.sh into a release tarball.
#
# Layout matches what a consumer points LD_LIBRARY_PATH at directly:
# lib/libsqlite3.so.0 is the real soname the dynamic linker looks for
# (Python's stdlib _sqlite3 extension included) -- see the hermes-agent
# project memory "project_py314_local_build" for the consumer side of this.
#
# Usage: tuned/package.sh   (run after tuned/build.sh, from anywhere)
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

VERSION="$(./sqlite3 -version | awk '{print $1}')"
ARCH="$(uname -m)"
OUT="libsqlite3-${VERSION}-linux-${ARCH}"

rm -rf "$OUT" "${OUT}.tar.gz"
mkdir -p "$OUT/lib" "$OUT/bin" "$OUT/include"

cp libsqlite3.so "$OUT/lib/libsqlite3.so.${VERSION}"
ln -s "libsqlite3.so.${VERSION}" "$OUT/lib/libsqlite3.so.0"
ln -s "libsqlite3.so.0" "$OUT/lib/libsqlite3.so"
cp sqlite3 "$OUT/bin/"
cp sqlite3.h sqlite3ext.h "$OUT/include/"

tar czf "${OUT}.tar.gz" "$OUT"
sha256sum "${OUT}.tar.gz" > "${OUT}.tar.gz.sha256"
rm -rf "$OUT"

echo "version=${VERSION}"
echo "arch=${ARCH}"
echo "asset=${OUT}.tar.gz"
