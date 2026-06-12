# Interrupt Sources

## INT $40 — VBlank interrupt

This interrupt [is requested] every time the Game Boy enters VBlank ([Mode 1](<#PPU modes>)).

The VBlank interrupt occurs ca. 59.7 times a second on a handheld Game
Boy (DMG or CGB) or Game Boy Player and ca. 61.1 times a second on a
Super Game Boy (SGB). This interrupt occurs at the beginning of the
VBlank period (LY=144). During this period video hardware is not using
VRAM so it may be freely accessed. This period lasts approximately 1.1
milliseconds.

## INT $48 — STAT interrupt

There are various sources which can trigger this interrupt to occur as
described in [STAT register (\$FF41)](<#FF41 — STAT: LCD status>).

The various STAT interrupt sources (modes 0-2 and LYC=LY) have their 
state (inactive=low and active=high) logically ORed into a shared
"STAT interrupt line" if their respective enable bit is turned on.

A STAT interrupt [will be triggered][is requested] by a rising edge (transition from 
low to high) on the STAT interrupt line.

:::warning STAT blocking

If a STAT interrupt source logically ORs the interrupt line high while 
(or immediately after) it's already set high by another source, then 
there will be no low-to-high transition and so no interrupt will occur. 
This phenomenon is known as "STAT blocking" ([test ROM example](https://github.com/Gekkio/mooneye-gb/blob/2d52008228557f9e713545e702d5b7aa233d09bb/tests/acceptance/ppu/stat_irq_blocking.s#L21-L22)).

As mentioned in the description of the [STAT register](<#FF41 — STAT: LCD status>),
the PPU cycles through the different modes in a fixed order. So for 
example, if interrupts are enabled for two consecutive modes such as 
Mode 0 and Mode 1, then no interrupt will trigger for Mode 1 (since 
the STAT interrupt line won't have a chance to go low between them).

:::

### Using the STAT interrupt

One very popular use is to indicate to the user when the video
hardware is about to redraw a given LCD line. This can be useful for
dynamically controlling the SCX/SCY registers ($FF43/$FF42) to [perform
special video effects](https://github.com/gb-archive/DeadCScroll).

Example application: set LYC to WY, enable LY=LYC interrupt, and have
the handler disable objects. This can be used if you use the window for
a text box (at the bottom of the screen), and you want objects (sprites) to be
hidden by the text box.

## INT $50 — Timer interrupt

The timer interrupt [is requested] every time that the timer overflows (that is, when [TIMA](<#FF05 — TIMA: Timer counter>) exceeds $FF).

## INT $58 — Serial interrupt

The serial interrupt [is requested] upon completion of a serial data transfer.
In other words, eight serial clock cycles after starting a transfer (by setting [SC](<#FF02 — SC: Serial transfer control>) bit 7), the incoming data will be in [SB](<#FF01 — SB: Serial transfer data>) and the interrupt will be requested.

## INT $60 — Joypad interrupt

The Joypad interrupt [is requested] when any of [`P1`](<#FF00 — P1/JOYP: Joypad>) bits 0-3 change
from High to Low. This happens when a button is
pressed (provided that the action/direction buttons are enabled by
bit 5/4, respectively), however, due to switch bounce, one or more High to Low
transitions are usually produced when pressing a button.

### Using the joypad interrupt

This interrupt is useful to identify button presses if we have only selected
either action (bit 5) or direction (bit 4), but not both.
If both are selected and, for example, a bit is already held Low by an action button,
pressing the corresponding direction button would
make no difference. The only meaningful purpose of the Joypad
interrupt would be to terminate the STOP (low power) standby state. GBA SP,
because of the different buttons used, seems to not be affected by
switch bounce.

[is requested]: <#FF0F — IF: Interrupt flag>
