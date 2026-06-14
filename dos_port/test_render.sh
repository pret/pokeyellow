#!/usr/bin/env bash
# test_render.sh — automated render test.
# Builds with SKIP_TITLE, launches DOSBox-X (fullscreen if possible), waits for
# the overworld to render, takes a screenshot, then force-kills DOSBox-X.
#
# Screenshot strategy: spectacle first; fall back to import(1) on :0 if the
# spectacle output is suspiciously small (< 200 KB = probably a terminal).
#
# Suppressions vs interactive DOSBox-X:
#   -defaultdir : suppresses the "select working directory" GUI dialog
#   kill -9     : bypasses the quit-warning confirmation dialog
#
# Usage: ./test_render.sh [output.png]
set -e

DOSPORT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHOT="${1:-/tmp/pkmn_render_test.png}"

echo "[test_render] Clean build with SKIP_TITLE..."
cd "$DOSPORT"
make clean -s
make SKIP_TITLE=1

echo "[test_render] Launching DOSBox-X..."
# -defaultdir  : suppresses CWD selector dialog (DOSBox-X uses this as its root)
# -fs          : start fullscreen (so spectacle captures the game, not a bg window)
# mount + c: + PKMN.EXE : explicit DOS commands to mount and run the game
dosbox-x \
    -defaultdir "$DOSPORT" \
    -fs \
    -c "mount c \"$DOSPORT\"" \
    -c "c:" \
    -c "PKMN.EXE" \
    > /tmp/dosbox_test.log 2>&1 &
DOSBOX_PID=$!

# With SKIP_TITLE: Init → EnterMap → LoadMapData → OverworldLoop.
# 10s is generous even on slow hosts; covers DPMI + game init.
echo "[test_render] Waiting 10s for overworld frame..."
sleep 10

echo "[test_render] Capturing screenshot..."
spectacle -b -f -n -o "$SHOT" 2>/dev/null || true

# Sanity check: if spectacle captured something suspiciously small (< 200 KB),
# it probably grabbed a small terminal window instead of the game. Fall back to
# ImageMagick's import(1) against the X11 root window (works via XWayland).
if [ ! -s "$SHOT" ] || [ "$(stat -c%s "$SHOT" 2>/dev/null || echo 0)" -lt 204800 ]; then
    echo "[test_render] spectacle output small/missing — trying import(1) fallback..."
    DISPLAY=:0 import -window root "$SHOT" 2>/dev/null || true
fi

echo "[test_render] Killing DOSBox-X (PID $DOSBOX_PID)..."
# SIGKILL (kill -9): bypasses DOSBox-X's close-warning dialog entirely.
kill -9 "$DOSBOX_PID" 2>/dev/null || true
wait "$DOSBOX_PID" 2>/dev/null || true

echo "[test_render] Done. Screenshot: $SHOT"
