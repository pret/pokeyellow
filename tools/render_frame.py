#!/usr/bin/env python3
"""Render FRAME.BIN (320x200 palette-indexed back buffer) to a PNG.

Values 0-3 = DMG shades (green ramp), 4-11 = sprite/extra colors.
Usage: render_frame.py FRAME.BIN out.png
"""
import sys
from PIL import Image

W, H = 320, 200

# DMG green ramp (debug palette) + a few distinct sprite colors so anything
# out of the 0-3 range is visually obvious.
PAL = {
    0: (224, 248, 208),  # lightest
    1: (136, 192, 112),
    2: (52, 104, 86),
    3: (8, 24, 32),      # darkest
    4: (255, 0, 0),      # sprite colors (magenta/red family) — should stand out
    5: (255, 128, 0),
    6: (255, 255, 0),
    7: (0, 255, 0),
    8: (0, 255, 255),
    9: (0, 128, 255),
    10: (128, 0, 255),
    11: (255, 0, 255),
}

def main():
    data = open(sys.argv[1], "rb").read()
    img = Image.new("RGB", (W, H))
    px = img.load()
    for y in range(H):
        for x in range(W):
            i = y * W + x
            v = data[i] if i < len(data) else 0
            px[x, y] = PAL.get(v, (255, 0, 255))
    img.save(sys.argv[2])
    print(f"Wrote {sys.argv[2]} ({len(data)} bytes in)")

if __name__ == "__main__":
    main()
