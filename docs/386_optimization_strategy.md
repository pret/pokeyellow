# 386 Optimization Strategy

This document provides a strategy and reference guide for LLMs and contributors when optimizing existing codebase elements to make them faster on Intel 386 processors.

## Core Philosophy

This port strives to remain a faithful translation of Pokémon Yellow. However, the constraints and capabilities of the 386 architecture require adjustments to maintain smooth graphics and processing speed.
- **Preserve Behavior:** You must ensure that optimizations behave as close to the original Sharp SM83 (Game Boy CPU) implementation as reasonably possible, preserving intentional glitches or known bugs as requested by the `/FIXCRIT` or `/FIXALL` macros. 
- **Favor Faster Alternatives:** Where functionally identical, a faster 386 alternative should be preferred over a direct 1:1 opcode translation of the SM83 routine. 
- **Prompt the User:** If a specific optimization requires a significant architectural change, breaks a bug intentionally preserved, or creates a tradeoff between extreme faithfulness and performance, **inform the user and ask for their decision**. Do not unilaterally make sweeping changes that affect original behavior.

## Memory Latency and Addressing

Memory access on the 386 is significantly slower than register operations. 
- Avoid unnecessary memory operations. Cache intermediate values in registers (like `EAX`, `ECX`, `EDX`, `EBX`, `ESI`, `EDI`) during complex calculations.
- Using 32-bit `DWORD` memory accesses (`MOVSD`) moves four times as much data per instruction compared to 8-bit (`MOVSB`), effectively dividing memory bus utilization for block copies.

## Basic Arithmetic Options and Cycle Costs

Cycle counts should guide your selection of instructions. Below is a baseline for 386 cycle costs (approximate, assuming zero wait state memory and no cache/pipeline stalls):

| Instruction Type | Operands | Approx. Clock Cycles | Notes |
| :--- | :--- | :--- | :--- |
| `LEA` | `reg32, mem` | 2 | Ideal for flag-preserving additions and small multiplications. |
| `ADD` / `SUB` | `reg, reg` or `reg, imm` | 2 | Very fast. Preferred for basic arithmetic. |
| `ADD` / `SUB` | `reg, mem` | 6 | Slower due to memory read. |
| `ADD` / `SUB` | `mem, reg` | 7 | Slower due to memory read + write. |
| `INC` / `DEC` | `reg` | 2 | Equivalent to ADD/SUB but doesn't affect the Carry flag. |
| `SHL` / `SHR` / `SAR` | `reg, imm` | 3 | Constant time on 386 due to the barrel shifter. |
| `MUL` (Unsigned) | `reg16` | ~21-25 | Slow. Avoid if multiplying by a power of 2. |
| `IMUL` | `reg, reg, imm` | ~22-38 | Hardware integer multiplication. Costly compared to shifts or `LEA`. |

## Bit Shifting and Multiplication Tricks

1. **The 386 Barrel Shifter:** Unlike the 8086, which cost extra cycles per bit shifted, the 80386 contains a 64-bit barrel shifter. This means shifting by 1 bit or 31 bits in a register takes the same amount of time (**3 cycles**).
2. **Strength Reduction for Powers of Two:** Never use `MUL` or `IMUL` when multiplying or dividing by powers of two. Use `SHL` and `SHR` instead.
3. **Scaled Indexing instead of Shifts:** The 386 provides hardware scaled indexing (`[base + index * scale + displacement]`), where scale can be 1, 2, 4, or 8. 
   - Instead of `SHL ECX, 2` followed by `ADD EAX, ECX`, simply use `LEA EAX, [EAX + ECX*4]`. This combines a shift and an add into a single instruction taking only **2 cycles** and doesn't affect `EFLAGS`.
4. **Zero-Extension / Sign-Extension:** Use `MOVZX` and `MOVSX` when loading an 8-bit or 16-bit value into a 32-bit register. This is faster than zeroing the 32-bit register first (e.g. `XOR EAX, EAX`) and then doing a partial register move (`MOV AL, val`).

## LLM Optimization Checklist
When optimizing or translating a new routine:
- [ ] Is there a direct memory operation that can be moved to a register?
- [ ] Can a series of shifts and adds be consolidated into an `LEA` instruction?
- [ ] Are we using 32-bit data moves (`MOVSD`, `REP MOVSD`) instead of 8-bit where memory size allows?
- [ ] Is `IMUL` used for a power-of-2 multiplication that could be an `SHL`?
- [ ] Does this routine change original Game Boy behavior or fix a bug that should be preserved under the current glitch policy? (If yes, ask the user).
