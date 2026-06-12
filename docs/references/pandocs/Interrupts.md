# Interrupts

## IME: Interrupt master enable flag \[write only\]

`IME` is a flag internal to the CPU that controls whether *any* interrupt handlers are called, regardless of the contents of `IE`.
`IME` cannot be read in any way, and is modified by these instructions/events only:

- **`ei`**: Enables interrupt handling (that is, `IME := 1`)
- **`di`**: Disables interrupt handling (that is, `IME := 0`)
- **`reti`**: Enables interrupts and returns (same as `ei` immediately followed by `ret`)
- **When an [interrupt handler](<#Interrupt handling>) is executed**: Disables interrupts before `call`ing the interrupt handler

`IME` is unset (interrupts are disabled) [when the game starts running](<#0100-0103 — Entry point>).

The effect of `ei` is delayed by one instruction. This means that `ei`
followed immediately by `di` does not allow any interrupts between them.
This interacts with the [`halt` bug](<#halt bug>) in an interesting way.

## FFFF — IE: Interrupt enable

{{#bits 8 >
  "IE" 4:"Joypad" 3:"Serial" 2:"Timer" 1:"LCD" 0:"VBlank"
}}

- **VBlank** (*Read/Write*): Controls whether [the VBlank interrupt handler](<#INT $40 — VBlank interrupt>) may be called (see `IF` below).
- **LCD** (*Read/Write*): Controls whether [the LCD interrupt handler](<#INT $48 — STAT interrupt>) may be called (see `IF` below).
- **Timer** (*Read/Write*): Controls whether [the Timer interrupt handler](<#INT $50 — Timer interrupt>) may be called (see `IF` below).
- **Serial** (*Read/Write*): Controls whether [the Serial interrupt handler](<#INT $58 — Serial interrupt>) may be called (see `IF` below).
- **Joypad** (*Read/Write*): Controls whether [the Joypad interrupt handler](<#INT $60 — Joypad interrupt>) may be called (see `IF` below).

## FF0F — IF: Interrupt flag

{{#bits 8 >
  "IF" 4:"Joypad" 3:"Serial" 2:"Timer" 1:"LCD" 0:"VBlank"
}}

- **VBlank** (*Read/Write*): Controls whether [the VBlank interrupt handler](<#INT $40 — VBlank interrupt>) is being requested.
- **LCD** (*Read/Write*): Controls whether [the LCD interrupt handler](<#INT $48 — STAT interrupt>) is being requested.
- **Timer** (*Read/Write*): Controls whether [the Timer interrupt handler](<#INT $50 — Timer interrupt>) is being requested.
- **Serial** (*Read/Write*): Controls whether [the Serial interrupt handler](<#INT $58 — Serial interrupt>) is being requested.
- **Joypad** (*Read/Write*): Controls whether [the Joypad interrupt handler](<#INT $60 — Joypad interrupt>) is being requested.

When an interrupt request signal (some internal wire going from the PPU/APU/... to the CPU) changes from low to high, the corresponding bit in the `IF` register becomes set.
For example, bit 0 becomes set when the PPU enters the [VBlank](<#PPU modes>) period.

Any set bits in the `IF` register are only **requesting** an interrupt.
The actual **execution** of the interrupt handler happens only if both the `IME` flag and the corresponding bit in the `IE` register are set; otherwise the
interrupt "waits" until **both** `IME` and `IE` allow it to be serviced.

Since the CPU automatically sets and clears the bits in the `IF` register, it
is usually not necessary to write to the `IF` register. However, the user
may still do that in order to manually request (or discard) interrupts.
Just like real interrupts, a manually requested interrupt isn't serviced
unless/until `IME` and `IE` allow it.

## Interrupt handling

1. The `IF` bit corresponding to this interrupt and the `IME` flag are reset by the CPU.
The former "acknowledges" the interrupt, while the latter prevents any further interrupts
from being handled until the program re-enables them, typically by using the `reti` instruction.
2. The corresponding interrupt handler (see the `IE` and `IF` register descriptions [above](<#FFFF — IE: Interrupt enable>)) is
called by the CPU. This is a regular call, exactly like what would be performed by a `call <address>` instruction (the current PC is pushed onto the stack
and then set to the address of the interrupt handler).

The following interrupt service routine is executed when control is being transferred to an interrupt handler:

1. Two wait states are executed (2 M-cycles pass while nothing happens; presumably the CPU is executing `nop`s during this time).
2. The current value of the PC register is pushed onto the stack, consuming 2 more M-cycles.
3. The PC register is set to the address of the handler (one of: $40, $48, $50, $58, $60).
This consumes one last M-cycle.

The entire process [lasts 5 M-cycles](https://gist.github.com/SonoSooS/c0055300670d678b5ae8433e20bea595#user-content-isr-and-nmi).

## Interrupt priorities

In the following circumstances it is possible that more than one bit in the IF register is set, requesting more than one interrupt at once:

1. More than one interrupt request signal changed from low to high at the same time.
2. Several interrupts have been requested while IME/IE didn't allow them to be serviced.
3. The user has written a value with several bits set (for example binary 00011111) to the IF register.

If IME and IE allow the servicing of more than one of the
requested interrupts, the interrupt with the highest priority
is serviced first. The priorities follow the order of the bits in the IE
and IF registers: Bit 0 (VBlank) has the highest priority, and Bit 4
(Joypad) has the lowest priority.

## Nested interrupt handling

The CPU automatically disables all the other interrupts by setting IME=0
when it services an interrupt. Usually IME remains zero until the
interrupt handler returns (and sets IME=1 by means of the `reti` instruction).
However, if you want to allow the servicing of other interrupts (of any priority)
during the execution of an interrupt handler, you may do so by using the
`ei` instruction in the handler.
