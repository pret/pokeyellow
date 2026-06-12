# Joypad Input

## FF00 — P1/JOYP: Joypad

The eight Game Boy action/direction buttons are arranged as a 2×4
matrix. Select either action or direction buttons by writing to this
register, then read out the bits 0-3.

{{#bits 8 >
  "P1" 5:"Select buttons" 4:"Select d-pad" 3:"Start / Down" 2:"Select / Up" 1:"B / Left" 0:"A / Right"
}}

- **Select buttons**: If this bit is `0`, then buttons (SsBA) can be read from the lower nibble.
- **Select d-pad**: If this bit is `0`, then directional keys can be read from the lower nibble.
- The lower nibble is *Read-only*.
  Note that, rather unconventionally for the Game Boy, a button being pressed is seen as the corresponding bit being **`0`**, not `1`.
  
  If neither buttons nor d-pad is selected (`$30` was written), then the low nibble reads `$F` (all buttons released).

:::tip NOTE

Most programs read from this port several times in a row
(the first reads are used as a short delay, allowing the inputs to stabilize,
and only the value from the last read is actually used).

:::

## Usage in SGB software

Beside for normal joypad input, SGB games misuse the joypad register to
output SGB command packets to the SNES, also, SGB programs may read out
gamepad states from up to four different joypads which can be connected
to the SNES. See SGB description for details.
