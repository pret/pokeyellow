# LCD Status Registers

:::tip TERMINOLOGY

A *dot* is the shortest period over which the PPU can output one pixel: is it equivalent to 1 T-cycle on DMG or on CGB Normal Speed mode or 2 T-cycles on CGB Double Speed mode. On each dot during mode 3, either the PPU outputs a pixel or the fetcher is stalling the [FIFOs](<#Pixel FIFO>).

:::

## FF44 — LY: LCD Y coordinate \[read-only\]

LY indicates the current horizontal line, which might be about to be drawn,
being drawn, or just been drawn. LY can hold any value from 0 to 153, with
values from 144 to 153 indicating the VBlank period.

## FF45 — LYC: LY compare

The Game Boy constantly compares the value of the LYC and LY registers.
When both values are identical, the "LYC=LY" flag in the STAT register
is set, and (if enabled) a STAT interrupt is requested.

## FF41 — STAT: LCD status

{{#bits 8 >
  ""  6:"LYC int select" 5:"Mode 2 int select" 4:"Mode 1 int select" 3:"Mode 0 int select" 2:"LYC == LY" 1-0:"PPU mode";
}}

- **LYC int select** (*Read/Write*): If set, selects the `LYC` == `LY` condition for [the STAT interrupt](<#INT $48 — STAT interrupt>).
- **Mode 2 int select** (*Read/Write*): If set, selects the Mode 2 condition for [the STAT interrupt](<#INT $48 — STAT interrupt>).
- **Mode 1 int select** (*Read/Write*): If set, selects the Mode 1 condition for [the STAT interrupt](<#INT $48 — STAT interrupt>).
- **Mode 0 int select** (*Read/Write*): If set, selects the Mode 0 condition for [the STAT interrupt](<#INT $48 — STAT interrupt>).
- **LYC == LY** (*Read-only*): Set when [LY](<#FF44 — LY: LCD Y coordinate \[read-only\]>) contains the same value as [LYC](<#FF45 — LYC: LY compare>); it is constantly updated.
- **PPU mode** (*Read-only*): Indicates [the PPU's current status](<#PPU modes>). Reports 0 instead when the [PPU is disabled](<#LCDC.7 — LCD enable>).
  
### Spurious STAT interrupts

A hardware quirk in the monochrome Game Boy makes the LCD interrupt
sometimes trigger when writing to STAT (including writing \$00) during
OAM scan, HBlank, VBlank, or LY=LYC. It behaves as if \$FF were
written for one M-cycle, and then the written value were written the next
M-cycle. Because the GBC in DMG mode does not have this quirk, two games
that depend on this quirk (Ocean's *Road Rash* and Vic Tokai's *Xerd
no Densetsu*) will not run on a GBC.
