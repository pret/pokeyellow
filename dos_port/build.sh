#!/usr/bin/env bash
# Build the Pokemon Yellow DOS port.
# Usage: ./build.sh [BUG_FIX_LEVEL=0|1|2] [make args...]
set -e
cd "$(dirname "${BASH_SOURCE[0]}")"
exec make "$@"
