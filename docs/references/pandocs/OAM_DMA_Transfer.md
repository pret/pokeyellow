
# OAM DMA Transfer

## FF46 — DMA: OAM DMA source address & start

Writing to this register starts a DMA transfer from ROM or RAM to OAM
(Object Attribute Memory).  The written value specifies the
transfer source address divided by $100, that is, source and destination are:

```
Source:      $XX00-$XX9F   ;XX = $00 to $DF
Destination: $FE00-$FE9F
```

The transfer takes 160 M-cycles: 640 dots (1.4 lines) in normal speed,
or 320 dots (0.7 lines) in CGB Double Speed Mode.
This is much faster than a CPU-driven copy.

## OAM DMA bus conflicts

On DMG, during OAM DMA, the CPU can access only HRAM (memory at $FF80-$FFFE).
For this reason, the programmer must copy a short procedure (see below) into HRAM, and use
this procedure to start the transfer **from inside HRAM**, and wait until
the transfer has finished.

On CGB, the cartridge and WRAM are on separate buses.
This means that the CPU can access ROM or cartridge SRAM during OAM DMA from WRAM, or WRAM during OAM DMA from ROM or SRAM.
However, because a `call` writes a return address to the stack, and the stack and variables are usually in WRAM,
it's still recommended to busy-wait in HRAM for DMA to finish even on CGB.

:::warning Interrupts

An interrupt writes a return address to the stack and fetches the interrupt handler's instructions from ROM.
Thus, it's critical to prevent interrupts during OAM DMA, especially in a program that uses timer, serial, or joypad interrupts, since they are not synchronized to the LCD.
This can be done by executing DMA within the VBlank interrupt handler or through the `di` instruction.

:::

While an OAM DMA is in progress, the PPU cannot read OAM properly either.
Thus, most programs execute DMA during [Mode 1](<#PPU modes>), inside or immediately after their VBlank handler.
But it is also possible to execute it during display redraw (Modes 2 and 3),
allowing to display more than 40 objects on the screen (that is, for
example 40 objects in the top half, and other 40 objects in the bottom half of
the screen), at the cost of a couple lines that lack objects.
If the transfer is started during Mode 3, graphical glitches may happen.

The details:

* If OAM DMA is active during OAM scan (mode 2), most PPU revisions read each object
  as being off-screen and thus hidden on that line.
* If OAM DMA is active during rendering (mode 3), the PPU reads whatever 16-bit word
  the DMA unit is writing to OAM when the object is fetched.
  This causes an incorrect tile number and attributes for objects already determined to be in range.

<!-- TODO: find Hacktix test ROM -->
<!-- TODO: keep working on "Red from OAM", a reproducer that races the beam to overwrite tile number and attributes of objects previously seen in Mode 2 -->

## Best practices

This 10-byte routine starts a transfer and waits for it to finish.
Many games copy a routine like it into HRAM and call it during Mode 1.

```rgbasm
run_dma:
    ld a, HIGH(start address)
    ldh [$FF46], a  ; start DMA transfer (starts right after instruction)
    ld a, 40        ; delay for a total of 4×40 = 160 M-cycles
.wait
    dec a           ; 1 M-cycle
    jr nz, .wait    ; 3 M-cycles
    ret
```

If HRAM is tight, this more compact procedure saves 5 bytes of HRAM
at the cost of a few M-cycles spent jumping to the tail in HRAM.

```rgbasm
run_dma:          ; This part must be in ROM.
    ld a, HIGH(start address)
    ld bc, $2846  ; B: wait time; C: LOW($FF46)
    jp run_dma_tail


run_dma_tail:     ; This part must be in HRAM.
    ldh [c], a
.wait
    dec b
    jr nz, .wait
    ret z         ; Conditional `ret` is 1 M-cycle slower, which avoids
                  ; reading from the stack on the last M-cycle of DMA.
```

If starting a mid-frame transfer, wait for Mode 0 first
so that the transfer cleanly overlaps Mode 2 on the next two lines,
making objects invisible on those lines.
