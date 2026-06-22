---
name: register-map
description: SM83 to x86 register mapping for this port.
---
# Skill: register-map

SM83 → x86 register mapping for this port.

## Register Table

| SM83 | x86 | Notes |
|------|-----|-------|
| A | AL | Accumulator |
| F: Z, C | EFLAGS ZF, CF | Direct |
| F: H | `[hf_shadow]` | BSS byte; lazy — only update where DAA/CPL consume H |
| F: N | (implicit) | Tracked via instruction choice, not a flag |
| BC | BX | B = BH, C = BL |
| DE | DX | D = DH, E = DL |
| HL | ESI | Full 32-bit, used for flat addressing |
| SP | ESP | Direct; mind calling convention |
| — | EBP | Fixed base → emulated GB address space |
| — | EDI | Secondary pointer / blit destination |
| — | ECX | Loop counter / scratch |

## EBP Memory Model

`EBP` = base of ~96 KB DPMI allocation (64 KB GB space + extras).
All emulated GB memory: `[EBP + constant]` where constants come from
`dos_port/include/gb_memmap.inc`. Never use raw GB addresses — always offset
from EBP. Example:

```nasm
; GB: ld a, [wCurItem]   →   x86: mov al, [ebp + wCurItem]
; GB: ld [hl], a         →   x86: mov [ebp + esi], al
```

## Preferred 386 Instructions

- `movzx`/`movsx` for zero/sign extension (never use AND to zero-extend)
- `imul reg, reg, imm` for index math
- `lea` for flags-preserving address computation
- `rep stos`/`rep movs` for block fills/copies
- Never use 32-bit operands for 8-bit/16-bit GB values without masking
