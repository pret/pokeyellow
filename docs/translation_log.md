# Translation Log

Running notes on routines translated from SM83 to x86. One entry per routine.
Use this to document non-obvious decisions, flag edge cases found, and track
which H-flag situations were encountered.

Format:
```
## RoutineName
- Source: <file>:<label>
- Translated: <dos_port file>
- Date: YYYY-MM-DD
- H-flag: <involved / not involved / lazy>
- Bug tags: <none / BUG(critical) / BUG(cosmetic) / GLITCH>
- Notes: <decisions and edge cases>
```

---

## FillMemory

- **Source:** `home/copy2.asm:137–155`
- **Translated:** `dos_port/src/util/fill_memory.asm`
- **pret cross-ref:** `FillMemory` (home/copy2.asm)
- **H-flag:** Not involved — pure store loop, no arithmetic.
- **Bug tags:** None. FillMemory is clean.

### Summary

Fills `BC` bytes at `HL` with byte `A`.

### SM83 Analysis

The original uses a double-loop to handle the full 16-bit count in two nested
8-bit decrements. This exists because on the SM83, 16-bit register
decrements (`dec bc`) do not set the Zero flag, so you can't branch on them.
The workaround:

1. If `B == 0`: use C as an 8-bit count directly (less than 256 bytes).
2. If `B != 0 && C == 0`: it's an exact multiple of 256; loop B times without
   incrementing B.
3. If `B != 0 && C != 0`: increment B first, then loop `B+1` times (each inner
   loop does 256 bytes, but the last iteration runs only C bytes before C wraps).

### x86 Translation Decision

`movzx ecx, bx` zero-extends the full 16-bit count into ECX, and `rep stosb`
handles any value 0–65535 correctly. The double-loop trick is not needed.

Edge cases verified:
| BX | SM83 path | x86 ECX | Correct? |
|----|-----------|---------|----------|
| 0x0000 | B=0, C=0, copies 256 bytes (!!) | 0 — no-op | x86 is correct; SM83 has a subtle bug here: if B=0 AND C=0, it enters `.eightbitcopyamount`, increments B to 1, then loops 256 times with dec C starting at 0, which wraps to 255 and counts 256 bytes. **This is a latent SM83 bug.** The game presumably never calls FillMemory with BC=0, but it's worth noting. |
| 0x00FF | B=0, C=255, 8-bit path | 255 — correct | ✓ |
| 0x0100 | B=1, C=0, exact 256 path | 256 — correct | ✓ |
| 0x0101 | B=1, C=1, B incremented to 2 | 257 — correct | ✓ |
| 0xFFFF | B=255, C=255, large count | 65535 — correct | ✓ |

**Edge case: BX=0x0000** — the SM83 FillMemory actually copies 256 bytes when
called with BC=0 (it falls through to the 8-bit path, increments B from 0 to 1,
then loops with C starting at 0 which wraps to 255 after first dec). This is
arguably a SM83 bug. The x86 translation (rep stosb with ECX=0) does nothing
instead. Since the game never calls FillMemory with BC=0 in practice
(confirmed by pret source review), this difference is acceptable. Tagged as:

```nasm
; BUG(cosmetic): BC=0 edge case — SM83 writes 256 bytes; x86 writes 0.
; pret ref: home/copy2.asm:FillMemory
; Game never passes BC=0 in practice. Fixed by /FIXALL for purity.
; %if BUG_FIX_LEVEL >= 2 ... handle BC=0 as no-op ... %endif
; (Currently: x86 behavior is the "fixed" behavior; the SM83 behavior is the bug.)
```

### Register Use

- `EDI`: scratch destination pointer (per register map convention for secondary pointer)
- `ECX`: loop counter — clobbered (callee must not rely on it)
- `ESI`: **preserved** — contains the GB address (HL) unchanged after return
- `EBX`: **preserved** — contains BC (count) unchanged after return
- `EAX`: **preserved** — AL = fill byte, unchanged after return

---

*Add new entries below as routines are translated.*
