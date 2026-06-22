#!/usr/bin/env bash
# Build the MCP-patched DOSBox-X for the Pokemon Yellow DOS port debugger.
#
# Clones dosbox-x at the version matching the system install, applies the
# MCP socket patch, and builds with --enable-debug=heavy.
#
# Output: tools/dosbox-x-mcp/dosbox-x  (not committed to repo)
#
# Run from anywhere; script auto-locates the repo root.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TOOLS_DIR="$SCRIPT_DIR"

# Detect DOSBox-X version from system install
DOSBOX_VER="$(dosbox-x --version 2>&1 | grep -oP 'version \K[0-9]+\.[0-9]+\.[0-9]+')"
if [ -z "$DOSBOX_VER" ]; then
    echo "ERROR: dosbox-x not found in PATH" >&2
    exit 1
fi
DOSBOX_TAG="dosbox-x-v${DOSBOX_VER}"
echo "System DOSBox-X: $DOSBOX_VER → tag $DOSBOX_TAG"

# Where we clone/build
SRC_NOSPACE="/tmp/dosbox-x-mcp-src"
BUILD_DIR="/tmp/dosbox-x-mcp-build"
FINAL_BIN="${TOOLS_DIR}/dosbox-x-mcp/dosbox-x"

# Clone if needed
if [ ! -d "$SRC_NOSPACE/.git" ]; then
    echo "Cloning dosbox-x at $DOSBOX_TAG..."
    git clone --depth=1 --branch "$DOSBOX_TAG" \
        https://github.com/joncampbell123/dosbox-x "$SRC_NOSPACE"
fi

# Apply MCP patch (idempotent — skip if already applied)
PATCH_FILE="${TOOLS_DIR}/dosbox-x-mcp.patch"
if [ -f "$PATCH_FILE" ]; then
    echo "Applying MCP patch..."
    cd "$SRC_NOSPACE"
    git diff --quiet || git stash
    git apply --check "$PATCH_FILE" 2>/dev/null && git apply "$PATCH_FILE" || \
        echo "(patch already applied or conflicts — skipping)"
    cd - >/dev/null
fi

# Configure + build
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

if [ ! -f "$SRC_NOSPACE/configure" ]; then
    (cd "$SRC_NOSPACE" && ./autogen.sh 2>&1 | tail -3)
fi

# Enable heavy debug + SDL2 + MT-32 + printer.
# SDL2: required on Arch (sdl12-compat's SDL1 lacks some DOSBox-X key constants).
# MT-32 uses system libmt32emu (munt package on Arch).
# Printer uses CUPS (libcups).
"$SRC_NOSPACE/configure" \
    --enable-debug=heavy \
    --enable-sdl2 \
    --enable-mt32 \
    --enable-printer \
    --prefix="$BUILD_DIR/install" \
    2>&1 | grep -E "debug|mt32|printer|curses|SDL|error:|configure:" | grep -v "^checking " | head -20

make -j"$(nproc)" 2>&1 | tail -10

# Install binary
mkdir -p "$(dirname "$FINAL_BIN")"
cp src/dosbox-x "$FINAL_BIN"
chmod +x "$FINAL_BIN"

echo ""
echo "Done. Binary: $FINAL_BIN"
echo "Run: dos_port/tools/run_with_mcp.sh"
