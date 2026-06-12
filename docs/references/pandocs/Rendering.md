# Rendering overview

## Terminology

The entire frame is not drawn atomically; instead, the image is drawn by the **<abbr>PPU</abbr>** (Pixel-Processing Unit) progressively, **directly to the screen**.
A frame consists of 154 **scanlines**; during the first 144, the screen is drawn top to bottom, left to right.

The main implication of this rendering process is the existence of **raster effects**: modifying some rendering parameters in the middle of rendering.
The most famous raster effect is modifying the [scrolling registers](<#Viewport position (Scrolling)>) between scanlines to create a ["wavy" effect](https://gbdev.io/guides/deadcscroll#effects).

A "**dot**" = one 2<sup>22</sup> Hz (≅ 4.194 MHz) time unit.
Dots remain the same regardless of whether the CPU is in [Double Speed mode](<#FF4D — KEY1/SPD (CGB Mode only): Prepare speed switch>), so there are 4 dots per Normal Speed M-cycle, and 2 per Double Speed M-cycle.

:::tip NOTE

A frame is not exactly one 60<sup>th</sup> of a second: the Game Boy runs slightly slower than 60 Hz, as one frame takes ~16.74 ms instead of ~16.67 (the error is 0.45%).

:::

## PPU modes

<figure><figcaption>

During a frame, the Game Boy's PPU cycles between four modes as follows:

</figcaption>

{{#include imgs/src/ppu_modes_timing.svg:2:}}

</figure>

While the PPU is accessing some video-related memory, [that memory is inaccessible to the CPU](<#Accessing VRAM and OAM>) (writes are ignored, and reads return garbage values, usually $FF).

Mode | Action                                     | Duration                             | Accessible video memory
----:|--------------------------------------------|--------------------------------------|-------------------------
  2  | Searching for OBJs which overlap this line | 80 dots                              | VRAM, CGB palettes
  3  | Sending pixels to the LCD                  | Between 172 and 289 dots, see below  | None
  0  | Waiting until the end of the scanline      | 376 - mode 3's duration              | VRAM, OAM, CGB palettes
  1  | Waiting until the next frame               | 4560 dots (10 scanlines)             | VRAM, OAM, CGB palettes

## Mode 3 length

During Mode 3, by default the PPU outputs one pixel to the screen per dot, from left to right; the screen is 160 pixels wide, so the minimum Mode 3 length is 160 + 12[^first12] = 172 dots.

Unlike most game consoles, the Game Boy does not always output pixels steadily[^crt]: some features cause the rendering process to stall for a couple dots.
Any extra time spent stalling *lengthens* Mode 3; but since scanlines last for a fixed number of dots, Mode 0 is therefore shortened by that same amount of time.

Three things can cause Mode 3 "penalties":

- **Background scrolling**: At the very beginning of Mode 3, rendering is paused for [`SCX`](<#FF42–FF43 — SCY, SCX: Background viewport Y position, X position>) % 8 dots while the same number of pixels are discarded from the leftmost tile.
- **Window**: After the last non-window pixel is emitted, a 6-dot penalty is incurred while the BG fetcher is being set up for the window.
- **Objects**: Each object drawn during the scanline (even partially) incurs a 6- to 11-dot penalty ([see below](<#OBJ penalty algorithm>)).

On DMG and GBC in DMG mode, mid-scanline writes to [`BGP`](<#FF47 — BGP (Non-CGB Mode only): BG palette data>) allow observing this behavior precisely, as any delay shifts the write's effect to the left by that many dots.

### OBJ penalty algorithm

Only the OBJ's leftmost pixel matters here, transparent or not; it is designated as "The Pixel" in the following.

1. Determine the tile (background or window) that The Pixel is within. (This is affected by horizontal scrolling and/or the window!)
2. If that tile has **not** been considered by a previous OBJ yet[^order]:
   1. Count how many of that tile's pixels are strictly to the right of The Pixel.
   2. Subtract 2.
   3. Incur this many dots of penalty, or zero if negative (from waiting for the BG fetch to finish).
3. Incur a flat, 6-dot penalty (from fetching the OBJ's tile).

**Exception**: an OBJ with an OAM X position of 0 (thus, completely off the left side of the screen) always incurs a 11-dot penalty, regardless of `SCX`.


[^first12]: The 12 extra dots of penalty come from two tile fetches at the beginning of Mode 3. One is the first tile in the scanline (the one that gets shifted by `SCX` % 8 pixels), the other is simply discarded.

[^crt]: The Game Boy can afford to "take pauses", because it writes to a LCD it fully controls; by contrast, home consoles like the NES or SNES are on a schedule imposed by the screen they are hooked up to. Taking pauses arguably simplified the PPU's design while allowing greater flexibility to game developers.

[^order]: Since pixels are emitted from left to right, OBJs overlapping the scanline are considered from [leftmost](<#Byte 1 — X Position>) to rightmost, with ties broken by their index / OAM address (lowest first).
