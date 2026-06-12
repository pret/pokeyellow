# CLAUDE.md — Pokemon Yellow DOS Port

Project context for Claude Code sessions. Read this at the start of every session.

---

## What This Project Is

A from-scratch port of **Pokémon Yellow (Game Boy Color)** to **MS-DOS**, written
entirely in **x86 NASM assembly**, targeting 386+ in 32-bit protected mode via CWSDPMI.

The SM83 source at the **repository root** is the pret/pokeyellow disassembly — a
complete, labeled reverse-engineering of the original ROM. Treat it as **read-only
specification**. The actual port lives in `dos_port/`. All translated routines keep
the names used in pret (e.g. `CopyData`, `FillMemory`, `LoadSpriteOAM`) so the port
stays cross-referenceable against pret as documentation.

---

## Current Phase

**Phase 0: Bootstrapping** — See [TODO.md](TODO.md) for open items.

---

## Repo Layout

```
/                          ← pret/pokeyellow SM83 source (read-only reference)
  constants/hardware.inc   ← GB hardware register definitions (use for offsets)
  home/                    ← core GB routines (translation source)
  ram/wram.asm, hram.asm   ← GB memory layout definitions
  docs/bugs_and_glitches.md  ← known bugs in the original (reference for BUG tags)
dos_port/
  include/
    gb_memmap.inc          ← EBP-relative offsets for GB memory regions
    gb_macros.inc          ← BUG_FIX_LEVEL macro, BUG/GLITCH comment conventions
  boot/
    entry.asm              ← DPMI entry, memory alloc, /FIXALL|/FIXCRIT parsing, main loop
    video.asm              ← VGA mode 13h, test pattern, 2× blit
    timing.asm             ← PIT 60 Hz, tick ISR, vblank sync
  src/util/
    fill_memory.asm        ← first translated routine (FillMemory)
  Makefile
  link.ld                  ← DJGPP linker script
docs/
  register_map.md          ← SM83 → x86 register mapping (living doc)
  translation_log.md       ← per-routine translation notes
  glitch_safety.md         ← glitch sandbox guidance
  references/
    README.md              ← reference link index
    pandocs/               ← downloaded Pan Docs markdown pages
tools/
  colorize.py              ← palette tool (stub, Phase 5)
  saveconv.py              ← GB .sav ↔ DOS .dsv converter (stub, Phase 5)
```

---

## Hard Conventions

### Toolchain
- Assembler: NASM, Intel syntax
- Target: 386+, 32-bit protected mode
- DPMI host: CWSDPMI (auto-loaded by `i386-pc-msdosdjgpp-ld` stub)
- Linker: `i386-pc-msdosdjgpp-ld` from `binutils-djgpp` package
- Build: `nasm -f coff` → `i386-pc-msdosdjgpp-ld`
- Entry point: `start` (not `_start`)

### Register Mapping (SM83 → x86)

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

### Memory Model
`EBP` = base of a ~96 KB DPMI allocation (64 KB GB space + 8 KB CGB VRAM bank 1
+ 160×144 back buffer). Access emulated GB memory as `[EBP + constant]` where
constants come from `dos_port/include/gb_memmap.inc`. All offsets derived from
`constants/hardware.inc`.

**DJGPP addressing (critical, verified in testing):** the DS/CS selector base
is the program image, NOT linear 0. `setup_flat_access` (boot/entry.asm) raises
the DS limit to 4 GB (DPMI fn 0008h — the "nearptr" model) and stores the DS
base in `[ds_base]`. Every raw linear address must be biased by `-[ds_base]`
before use as a DS-relative offset:
- VGA framebuffer: use `[vga_base]` (= 0xA0000 − ds_base), never raw 0xA0000
- DPMI fn 0501h results: linear − ds_base (done in `alloc_gb_memory`; EBP is
  already biased)
- PSP/real-mode addresses: segment×16 − ds_base

Other verified DPMI gotchas:
- DPMI fn 0501h takes the size in **BX:CX as 16-bit halves**, not ECX
- A hardware ISR must load DS via `mov ds, [cs:isr_ds]` (CS base = DS base
  under DJGPP); don't assume SS holds the flat selector on ISR entry
- Restore the PIT divisor and original IRQ0 vector before exit (`pit_restore`)

### Video
- VGA Mode 13h (320×200, 256 colors)
- GB framebuffer: 160×144 at `[EBP + GB_BACKBUF]`
- 2× nearest-neighbor blit to `0xA0000`, centered (28-row letterbox top/bottom)
- Palette: 256-entry VGA (6-bit RGB via ports 0x3C8/0x3C9); layout TBD Phase 5

### Timing
- PIT channel 0: divisor 19886, mode 3 → ~60 Hz
- Frame loop: `wait_vblank → wait_pit_tick → update → render → present`
- VBlank detection: port 0x3DA bit 3 (VSync active high)
- No cycle-counted delay loops

### Hardware I/O Boundary
**Do not translate GB I/O register accesses directly.** These are translation
boundaries. Emit a `; TODO-HW:` comment describing what the original code does:

- `$FF40–$FF4B` (LCDC, STAT, SCX/SCY, palettes, OAM DMA) → software renderer
- `$FF01/$FF02` (serial SB/SC) → `; TODO-HW: network HAL` (Phase 4)
- `$FF04–$FF07` (timer) → PIT-based main loop, not translated
- `$FF10–$FF26` (APU) → `; TODO-HW: audio HAL` (Phase 3)

### RST Vectors
`RST $00`–`$38` become regular labeled `CALL` targets, not interrupt-style dispatch.

### 386+ Instructions
Prefer: `movzx`/`movsx` for zero/sign extension, `imul reg, reg, imm` for
tile/map index math, `lea` for flags-preserving address computation, `rep stos/movs`
for block fills/copies.

---

## Bug Fix Conventions

Every translated routine with a known bug gets a conditional block:

```nasm
; BUG(critical): <description> — pret ref: <file>:<label>, bugs_and_glitches.md#L<N>
%if BUG_FIX_LEVEL >= 1
    ; fixed implementation
%else
    ; original behavior (possibly buggy)
%endif
```

Levels: `1` = critical bugs only (`/FIXCRIT`), `2` = all bugs (`/FIXALL`).

For intentional glitches that are user-exploitable features:
```nasm
; GLITCH: <name> — <brief description>
; Safety: safe under DPMI (bounded) | unsafe on bare HW if ACE reachable
```

---

## Build Commands

```sh
# Reference ROM (requires rgbds 1.0.1)
make compare

# DOS port
make -C dos_port

# Single file assembly check
nasm -f coff -o /dev/null dos_port/src/util/fill_memory.asm
```

---

## Key Reference URLs

All key reference documents are also mirrored locally in `docs/references/pandocs/`.

- **Pan Docs** (GB hardware): https://gbdev.io/pandocs/
- **Ralf Brown's Interrupt List**: https://www.delorie.com/djgpp/doc/rbinter/
- **DPMI 0.9 Spec**: https://www.phatcode.net/res/262/files/dpmi09.html
- **DJGPP docs**: https://www.delorie.com/djgpp/doc/
- **DJGPP FAQ (hardware/interrupts)**: https://www.delorie.com/djgpp/v2faq/faq18.html
- **PC Game Programmer's Encyclopedia**: http://qzx.com/pc-gpe/
- **Abrash Black Book**: https://www.phatcode.net/res/224/files/html/
- **Awesome DOS**: https://github.com/balintkissdev/awesome-dos

---

## Translation Workflow

1. Pick a routine from `home/` or `engine/` with no `$FF__` I/O accesses.
2. Create `dos_port/src/<mirrored path>/<filename>.asm`.
3. Translate following the register map. Use `%include "dos_port/include/gb_memmap.inc"`.
4. Emit `; TODO-HW:` for any I/O boundary hit.
5. Emit `; BUG(level):` for any known bug (check `docs/bugs_and_glitches.md`).
6. Add an entry to `docs/translation_log.md`.
7. Verify assembly: `nasm -f coff -o /dev/null <file>`.

---

## Save File Notes (Phase 5 — Not Yet Implemented)

- GB `.sav`: raw 32 KB SRAM dump (MBC5+RAM+BATTERY)
- DOS `.dsv`: `DOSV` magic + version byte + 2-byte checksum + 32 KB SRAM data
- Converter: `tools/saveconv.py` (stub until Phase 5 when save format is stable)
