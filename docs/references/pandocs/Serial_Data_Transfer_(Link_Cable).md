# Serial Data Transfer (Link Cable)

Communication between two Game Boy systems happens one byte at a time. One
Game Boy generates a clock signal internally and thus controls when the
exchange happens. In SPI terms, the Game Boy generating the clock is
called the "master" while the other one (the "slave" Game Boy) receives it.
If it hasn't gotten around to loading up the next
data byte at the time the transfer begins, the last one will go out
again. Alternately, if it's ready to send the next byte but the last
one hasn't gone out yet, it has no choice but to wait.

## FF01 — SB: Serial transfer data

Before a transfer, it holds the next byte that will go out.

During a transfer, it has a blend of the outgoing and incoming bytes.
Each cycle, the leftmost bit is shifted out (and over the wire) and the
incoming bit is shifted in from the other side:

{{#bits 8 >
   "Initially" 7:"o.7" 6:"o.6" 5:"o.5" 4:"o.4" 3:"o.3" 2:"o.2" 1:"o.1" 0:"o.0" ;
   "1 shift"  7:"o.6" 6:"o.5" 5:"o.4" 4:"o.3" 3:"o.2" 2:"o.1" 1:"o.0" 0:"i.7" ;
   "2 shifts" 7:"o.5" 6:"o.4" 5:"o.3" 4:"o.2" 3:"o.1" 2:"o.0" 1:"i.7" 0:"i.6" ;
   "3 shifts" 7:"o.4" 6:"o.3" 5:"o.2" 4:"o.1" 3:"o.0" 2:"i.7" 1:"i.6" 0:"i.5" ;
   "4 shifts" 7:"o.3" 6:"o.2" 5:"o.1" 4:"o.0" 3:"i.7" 2:"i.6" 1:"i.5" 0:"i.4" ;
   "5 shifts" 7:"o.2" 6:"o.1" 5:"o.0" 4:"i.7" 3:"i.6" 2:"i.5" 1:"i.4" 0:"i.3" ;
   "6 shifts" 7:"o.1" 6:"o.0" 5:"i.7" 4:"i.6" 3:"i.5" 2:"i.4" 1:"i.3" 0:"i.2" ;
   "7 shifts" 7:"o.0" 6:"i.7" 5:"i.6" 4:"i.5" 3:"i.4" 2:"i.3" 1:"i.2" 0:"i.1" ;
   "8 shifts" 7:"i.7" 6:"i.6" 5:"i.5" 4:"i.4" 3:"i.3" 2:"i.2" 1:"i.1" 0:"i.0"
}}

## FF02 — SC: Serial transfer control

{{#bits 8 >
   "SC" 7:"Transfer enable" 1:"Clock speed" 0:"Clock select"
}}

- **Transfer enable** (*Read/Write*): If `1`, a transfer is either requested or in progress.
- **Clock speed** \[*CGB Mode only*\] (*Read/Write*): If set to `1`, enable high speed serial clock (~256 kHz in normal-speed mode)
- **Clock select** (*Read/Write*): `0` = External clock ("slave"), `1` = Internal clock ("master").

The master Game Boy will load up a data byte in SB and then set
SC to \$81 (Transfer requested, use internal clock). It will be notified
that the transfer is complete in two ways: SC's Bit 7 will be cleared, and a [Serial interrupt](<#INT $58 — Serial interrupt>)
will be requested. When checking SC to determine if the transfer is complete, make sure to only read SC's Bit 7.

The other Game Boy will load up a data byte and has to set SC's
Bit 7 (that is, SC=\$80) to enable the serial port. The externally clocked
Game Boy will have a [serial interrupt](<#INT $58 — Serial interrupt>) requested at the end of the
transfer, and SC's Bit 7 will be cleared.

### Internal Clock

In Non-CGB Mode the Game Boy supplies an internal clock of 8192Hz only
(allowing to transfer about 1 KByte per second minus overhead for delays).
In CGB Mode four internal clock rates are available, depending on Bit 1
of the SC register, and on whether the CGB Double Speed Mode is used:

Clock freq | Transfer speed | Conditions
-----------|----------------|------------
   8192 Hz |     1 KB/s     | Bit 1 cleared, Normal speed
  16384 Hz |     2 KB/s     | Bit 1 cleared, Double-speed Mode
 262144 Hz |    32 KB/s     | Bit 1 set,     Normal speed
 524288 Hz |    64 KB/s     | Bit 1 set,     Double-speed Mode

### External Clock

The external clock is typically supplied by another Game Boy, but might
be supplied by another computer (for example if connected to a PC's
parallel port), in that case the external clock may have any speed. Even
the old/monochrome Game Boy is reported to recognize external clocks of
up to 500 kHz. And there is no limitation in the other direction: even
when suppling an external clock speed of "1 bit per month," the Game Boy
will eagerly wait for the next bit to be transferred. It isn't required
that the clock pulses are sent at a regular interval either.

## Timeouts

When using external clock then the transfer will not complete until the
last bit is received. In case that the second Game Boy isn't supplying a
clock signal, if it gets turned off, or if there is no second Game Boy
connected at all) then transfer will never complete. For this reason the
transfer procedure should use a timeout counter, and abort the
communication if no response has been received during the timeout
interval.

## Disconnects

On a disconnected link cable, the input bit on a master will start to read 1.
This means a master will start to receive $FF bytes.

If a disconnection happens during transmission, the input will be pulled up to 1 over a 20uSec period. (TODO: Only measured on a CGB rev E)
This means if the slave was sending a 0 bit at the time of the disconnect, you will read 0 bits for up to 20 μs.
Which, on a CGB at the highest speed, can amount to more than one byte.

## Delays and Synchronization

The master Game Boy should always execute a small
delay after each transfer, in order to ensure that the other
Game Boy has enough time to prepare itself for the next transfer. That is, the
Game Boy with external clock must have set its transfer start bit before
the Game Boy with internal clock starts the transfer. Alternately, the
two Game Boy systems could switch between internal and external clock for each
transferred byte to ensure synchronization.

Transfer is initiated when the master Game Boy sets its Transfer
Start Flag.
This bit is automatically set to 0 (on both) at the end of transfer.
Reading this bit can be used to determine if the transfer is still
active.
