#!/usr/bin/env python3
"""Generate dos_port/assets/font_1bpp.inc from gfx/font/font.png.

font.1bpp is an rgbgfx build artifact (gitignored), so the DOS port embeds a
committed NASM data copy generated from the committed PNG source instead.
Requires Pillow: pip install Pillow

Run from the repo root: python3 tools/gen_font_inc.py
"""
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent.parent
SRC_PNG = ROOT / "gfx" / "font" / "font.png"
DST = ROOT / "dos_port" / "assets" / "font_1bpp.inc"

TILE_W, TILE_H = 8, 8
TILES_PER_ROW = 16


def main():
    try:
        from PIL import Image
    except ImportError:
        sys.exit("Pillow required: pip install Pillow")

    img = Image.open(SRC_PNG).convert("L")
    w, h = img.size
    num_tiles = (w // TILE_W) * (h // TILE_H)
    if num_tiles != 128:
        sys.exit(f"expected 128 tiles, got {num_tiles} from {w}x{h} image")

    data = bytearray()
    for ty in range(h // TILE_H):
        for tx in range(TILES_PER_ROW):
            for row in range(TILE_H):
                byte = 0
                for col in range(TILE_W):
                    px = img.getpixel((tx * TILE_W + col, ty * TILE_H + row))
                    if px < 128:  # dark pixel = set bit
                        byte |= 0x80 >> col
                data.append(byte)

    out = [
        "; font_1bpp.inc — generated from gfx/font/font.png via tools/gen_font_inc.py.",
        "; 128 tiles, 1bpp, 8 bytes each. Char code C ($80='A') -> tile (C-$80).",
        "; DO NOT EDIT BY HAND.",
        "",
        "font_1bpp_data:",
    ]
    for i in range(0, len(data), 16):
        out.append("    db " + ", ".join(f"0x{b:02X}" for b in data[i:i + 16]))
    out += [
        "font_1bpp_data_end:",
        "FONT_1BPP_SIZE equ font_1bpp_data_end - font_1bpp_data",
        "",
    ]
    DST.parent.mkdir(parents=True, exist_ok=True)
    DST.write_text("\n".join(out) + "\n")
    print(f"wrote {DST} ({len(data)} bytes, {num_tiles} tiles)")


if __name__ == "__main__":
    main()
