---
name: bug-check
description: BUG_FIX_LEVEL convention for this port.
---
# Skill: bug-check

BUG_FIX_LEVEL convention for this port.

## Levels

- `BUG_FIX_LEVEL 0` — original buggy behavior (default / no flag)
- `BUG_FIX_LEVEL 1` — critical bugs only (`/FIXCRIT` flag on PKMN.EXE)
- `BUG_FIX_LEVEL 2` — all bugs including cosmetic (`/FIXALL` flag)

## Template

```nasm
; BUG(critical): <what goes wrong> — pret ref: <file>:<label>, bugs_and_glitches.md#L<N>
%if BUG_FIX_LEVEL >= 1
    ; corrected implementation
%else
    ; original buggy behavior (verbatim from SM83)
%endif
```

For cosmetic/non-critical bugs:
```nasm
; BUG(cosmetic): <what goes wrong> — pret ref: <file>:<label>
%if BUG_FIX_LEVEL >= 2
    ; corrected implementation
%else
    ; original behavior
%endif
```

## When to Apply

1. Check ticket for explicit `; BUG()` annotations — apply if present.
2. If unsure whether something is a bug, check `docs/bugs_and_glitches.md`.
3. If the function has NO known bugs, emit no BUG block.
4. Never invent BUG blocks for behavior not documented in bugs_and_glitches.md.

## Glitch Comment

For intentional exploitable glitches:
```nasm
; GLITCH: <name> — <one-line description>
; Safety: safe under DPMI (bounded) | unsafe on bare HW if ACE reachable
```

Do NOT use the `%if` block for glitches — glitches are always preserved.
