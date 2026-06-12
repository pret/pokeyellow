# Viewport position (Scrolling)

These registers can be accessed even during Mode 3, but modifications may not take
effect immediately (see further below).

## FF42–FF43 — SCY, SCX: Background viewport Y position, X position

These two registers specify the top-left coordinates of the visible 160×144 pixel area within the
256×256 pixels BG map. Values in the range 0–255 may be used.

The PPU calculates the bottom-right coordinates of the viewport with those formulas: `bottom := (SCY + 143) % 256` and `right := (SCX + 159) % 256`.
As suggested by the modulo operations, in case the values are larger than 255 they will "wrap around" towards the top-left corner of the tilemap.

<figure><figcaption>

Example from the homebrew game *Mindy's Hike*:

</figcaption>

![VRAM view diagram](imgs/scrolling_diagram.png)

</figure>

## Mid-frame behavior

The scroll registers are re-read on each [tile fetch](<#Get Tile>), except for the low 3 bits of `SCX`, which are only read at the beginning of the scanline (for the initial shifting of pixels).

All models before the CGB-D read the Y coordinate once for each bitplane (so a very precisely timed `SCY` write allows "desyncing" them), but CGB-D and later use the same Y coordinate for both no matter what.
