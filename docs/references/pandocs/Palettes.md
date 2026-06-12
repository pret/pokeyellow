# Palettes

## LCD Monochrome Palettes

Non-Color games have access to one palette for the background (and Window), and two for OBJs.

In CGB Mode the color palettes are taken from [CGB palette memory](<#LCD Color Palettes (CGB only)>)
instead.

### FF47 — BGP (Non-CGB Mode only): BG palette data

This register assigns gray shades to the [color indices](<#Data format>) of the BG and Window tiles.

{{#bits 8 >
  "Color for..."  7-6:"ID 3" 5-4:"ID 2" 3-2:"ID 1" 1-0:"ID 0";
}}

Each of the two-bit values map to a color thusly:

Value | Color
------|-------
  0   | White
  1   | Light gray
  2   | Dark gray
  3   | Black

### FF48–FF49 — OBP0, OBP1 (Non-CGB Mode only): OBJ palette 0, 1 data

These registers assigns gray shades to the color indexes of the OBJs that use the corresponding palette.
They work exactly like [`BGP`](<#FF47 — BGP (Non-CGB Mode only): BG palette data>), except that the lower two bits are ignored because color index 0 is transparent for OBJs.

## LCD Color Palettes (CGB only)

The GBC provides 8 palettes for the background (and Window), and 8 for OBJs; they are selected via the [attribute maps](<#BG Map Attributes (CGB Mode only)>) and [OAM attributes](<#Byte 3 — Attributes/Flags>) respectively.

:::tip NOTE

All background colors are initialized as white [by the boot ROM](<#Power-Up Sequence>).

:::

Colors on the Game Boy Color are stored as RGB555, meaning a single color is composed of three 5-bit components, one for each of red, green, and blue.
Each 15-bit color occupies the lower part of a 16-bit word[^bit15]:

{{#include imgs/src/rgb555.svg}}

The color palettes are stored in two dedicated banks of palette RAM (or <abbr title="Color RAM">CRAM</abbr> for *color RAM*), 64 bytes each[^cram_size]: one for background/window palettes and the other for OBJ palettes.

The two bytes of each color are stored in **little-endian** byte order, meaning that the low byte comes first.
For example, the two palettes shown in the previous diagram would be stored like this:

{{#include imgs/src/color_ram.svg}}

Unlike VRAM, OAM, or wave RAM, CRAM is not exposed in the memory map and cannot be accessed directly.
Instead, each bank of CRAM is accessed through a pair of registers: one register is used to select a CRAM address, and the other provides read/write access to the byte at that address.
Much like VRAM, the CRAM data registers are inaccessible when the PPU is reading from CRAM, that is, during [Mode 3](<#PPU modes>): writes are ignored, and reads return $FF.

[^bit15]:
The 16th bit, bit 15, is **ignored** by the rendering process.
Conventionally, that bit is generally clear (for example, the canonical pure white is `$7FFF` and not `$FFFF`), but the hardware treats both identically: it's fine to fill color RAM with $FF bytes to set it to all-white.

[^cram_size]:
2 bytes/color × 4 colors/palette × 8 palettes = 64 bytes.

### FF68 — BGPI (CGB Mode only): Background palette index

{{#bits 8 >
  "BGPI"  7:"Auto-increment" 5-0:"Address";
}}

- **Auto-increment**: `0` = Disabled; `1` = Enabled
- **Address**: Specifies which byte of BG Palette Memory can be accessed through
  [`BGPD`](<#FF69 — BGPD (CGB Mode only): Background palette data>)

Unlike `BGPD`, this register can be freely accessed outside VBlank and HBlank.

### FF69 — BGPD (CGB Mode only): Background palette data

As each color is two bytes in size, you must read/write this register *twice* to access a whole color.

This is made much easier through the use of the address auto-increment: `BGPI`'s "address" field is automatically incremented (wrapping around from 63 back to 0) after each write to this register, even if the write fails due to CRAM being inaccessible.
Reads, however, never trigger auto-increment.

### FF6A–FF6B — OBPI, OBPD (CGB Mode only): OBJ palette index, OBJ palette data

These registers function exactly like BGPI and BGPD respectively; the 64 bytes of OBJ palette memory are entirely separate from Background palette memory, but function the same.

Note that while 4 colors are stored per OBJ palette, color #0 is never used, as it's always transparent. It's thus fine to write garbage values, or even leave it uninitialized.

:::tip NOTE

In CGB mode, the boot ROM leaves all object colors uninitialized (and thus somewhat random/unreliable), aside from setting the first byte of OBJ0 color #0 to $00, which is unused.

In DMG compatibility mode, the boot ROM sets the first 2 object palettes which are used by OBP0/OBP1, [as explained here](<#Compatibility palettes>).

:::

### RGB Translation by CGBs

![sRGB versus CGB color mixing](imgs/VGA_versus_CGB.png)

When developing graphics on PCs, note that the RGB values will have
different appearance on CGB displays as on VGA/HDMI monitors calibrated
to sRGB color. Because the GBC is not lit, the highest intensity will
produce light gray rather than white. The intensities are not
linear; the values $10-$1F will all appear very bright, while medium and
darker colors are ranged at $00-0F.

The CGB display's pigments aren't perfectly saturated. This means the
colors mix quite oddly: increasing the intensity of only one R/G/B color
will also influence the other two R/G/B colors. For example, a color
setting of $03EF (Blue=$00, Green=$1F, Red=$0F) will appear as Neon Green
on VGA displays, but on the CGB it'll produce a decently washed out
Yellow. See the image above.

### RGB Translation by GBAs

Even though GBA is described to be compatible to CGB games, most CGB
games are completely unplayable on older GBAs because most colors are
invisible (black). Of course, colors such like Black and White will
appear the same on both CGB and GBA, but medium intensities are arranged
completely different. Intensities in range $00–07 are invisible/black
(unless eventually under best sunlight circumstances, and when gazing at
the screen under obscure viewing angles), unfortunately, these
intensities are regularly used by most existing CGB games for medium and
darker colors.

:::tip WORKAROUND

Newer CGB games may avoid this effect by changing palette data when
detecting GBA hardware ([see how](<#Detecting CGB (and GBA) functions>)).
Based on measurements of GBC and GBA palettes using the
[144p Test Suite](https://github.com/pinobatch/240p-test-mini/tree/master/gameboy),
a fairly close approximation is `GBA = GBC × 3/4 + $08` for each R/G/B
component. The result isn't quite perfect, and it may turn
out that the color mixing is different also; anyways, it'd be still
ways better than no conversion.

:::

This problem with low brightness levels does not affect later GBA SP
units and Game Boy Player. Thus ideally, the player should have control
of this brightness correction.
