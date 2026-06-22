#!/usr/bin/env python3
"""
colorize.py — Palette mapping tool for the Pokemon Yellow DOS port.

STATUS: STUB — Not yet implemented. This is a Phase 5 item.
The VGA palette layout (256-entry partition by context) must be finalized
before this tool can be written. See ROADMAP.md Phase 5 for details.

Planned function:
    For each asset (tileset, sprite sheet, font, battle backgrounds):
        1. Read the 2bpp GB tile data + CGB palette data
        2. Apply a per-context color mapping (overworld / battle / UI / etc.)
        3. Output 8bpp indexed pixel data + a VGA palette segment

    The 256-entry VGA palette will be partitioned by context:
        0x00–0x3F  UI elements (menu frames, text, HP bars)
        0x40–0x7F  Overworld tiles
        0x80–0xBF  Sprites / NPCs
        0xC0–0xFF  Battle backgrounds and Pokémon sprites

    Each partition holds palette data for the assets that use it.
    Assets targeting overlapping palettes are remapped during conversion.

Planned usage (Phase 5):
    colorize.py --context overworld --tileset tilesets/pallet.2bpp \
                --palette gbc_palettes.asm --out dos_port/assets/overworld.dat
"""

import sys


def main():
    print("colorize.py: NOT YET IMPLEMENTED (Phase 5 item)")
    print("See ROADMAP.md for the palette layout design.")
    print()
    print("Planned usage:")
    print("  colorize.py --context <overworld|battle|ui|sprite>")
    print("              --tileset <input.2bpp> --palette <gbc_palettes.asm>")
    print("              --out <output.dat>")
    sys.exit(1)


if __name__ == '__main__':
    main()
