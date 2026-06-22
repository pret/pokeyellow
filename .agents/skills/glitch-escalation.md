# Skill: glitch-escalation

When to stop and escalate instead of translating.

## Escalation Triggers

Stop immediately and report to Dispatch_Manager if the function:

1. **Accesses a `$FF__` hardware register** not listed in your ticket.
   These are I/O boundaries — see `CLAUDE.md` "Hardware I/O Boundary" section.
   Do NOT guess what the register does. Report the register address.

2. **Calls a graphics or audio routine** not in your ticket (any function in
   `home/audio.asm`, `home/lcd.asm`, `engine/gfx/`, etc.).

3. **Accesses `$FE00`** (OAM) or `$FF40–$FF4B` (LCDC, palettes, DMA).

4. **Involves a glitch rated "unsafe"** in `docs/glitch_safety.md`.
   Unsafe = can trigger ACE or write to arbitrary memory under DPMI.

## How to Escalate

```sh
dos_port/tools/work_queue recategorize --id <ID> --category complex --notes "reason: $FF4X access"
dos_port/tools/work_queue fail --id <ID> --notes "escalated to complex: <reason>"
```

Return to Dispatch_Manager with:
- The register or function that triggered escalation
- The line number in the pret source

## Safe to Translate Without Escalation

- Any `$FF` address that is a GB RAM address (`$FF80–$FFFE` = HRAM):
  these are regular memory, not I/O. Map via `[EBP + hram_offset]`.
- `call` to another simple function listed in `AGENTS.md` simple category.
- Bit manipulation of GB RAM bytes (status flags, counters, etc.).
