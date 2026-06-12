# CPU registers and flags

## Registers

16-bit |Hi |Lo | Name/Function
-------|---|---|--------------
   AF  | A | - | Accumulator & Flags
   BC  | B | C | BC
   DE  | D | E | DE
   HL  | H | L | HL
   SP  | - | - | Stack Pointer
   PC  | - | - | Program Counter/Pointer

As shown above, most registers can be accessed either as one 16-bit
register, or as two separate 8-bit registers.

## The Flags Register (lower 8 bits of AF register)

Bit | Name | Explanation
----|------|-------
  7 |   z  | Zero flag
  6 |   n  | Subtraction flag (BCD)
  5 |   h  | Half Carry flag (BCD)
  4 |   c  | Carry flag

Contains information about the result of the most recent instruction that has affected
flags.

## The Zero Flag (Z)

This bit is set if and only if the result of an operation is zero. Used by conditional jumps.

## The Carry Flag (C, or Cy)

Is set in these cases:
- When the result of an 8-bit addition is higher than $FF.
- When the result of a 16-bit addition is higher than $FFFF.
- When the result of a subtraction or comparison
is lower than zero (like in Z80 and x86 CPUs, but unlike in
65XX and ARM CPUs).
- When a rotate/shift operation shifts out a \"1\" bit.

Used by conditional jumps and
instructions such as ADC, SBC, RL, RLA, etc.

## The BCD Flags (N, H)

These flags are used by the DAA instruction only. N indicates
whether the previous instruction has been a subtraction,
and H indicates carry for the lower 4 bits of the result. DAA also uses the C flag,
which must indicate carry for the upper 4 bits. After adding/subtracting two
BCD numbers, DAA is used to convert the result to BCD format. BCD
numbers range from $00 to $99 rather than $00 to $FF. Because only two flags
(C and H) exist to indicate carry-outs of BCD digits, DAA is ineffective for
16-bit operations (which have 4 digits), and use for INC/DEC operations
(which do not affect C-flag) has limits.

