#!/usr/bin/env bash
# Builds libsqlite3.so + the sqlite3 CLI from this checkout.
#
# Extensions enabled (--all = fts4 fts5 rtree; json1 is on by default):
# FTS5 is the one that actually matters here -- it's what pulled this repo
# into existence (hermes-agent's state.db needs it, see project memory
# "project_py314_local_build" in the hermes-agent project). FTS4/RTree/JSON1
# are cheap to carry along.
#
# Usage: tuned/build.sh   (run from anywhere; cd's to the repo root itself)
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

CFLAGS="${CFLAGS:--O2 -DNDEBUG}" ./configure --all --disable-static
make -j"$(nproc)"
strip --strip-unneeded libsqlite3.so sqlite3
