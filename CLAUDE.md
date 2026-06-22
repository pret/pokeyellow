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

**Phase 2: Game Loop** — See [TODO.md](TODO.md) for open items.
Phase 1 delivered the BG tile decoder + tilemap renderer with SCX/SCY scrolling
(`src/ppu/ppu.asm`) and the keyboard → joypad ISR (`src/input/joypad.asm`);
window layer, OAM sprites, and the save system remain open there.

Phase 2 so far: `Init`/`ClearVram`/`StopAllSounds` (`src/init/init.asm`),
supporting home routines (`src/util/copy_data.asm`, `src/video/lcd_control.asm`,
`src/video/frame.asm`, `src/gfx/sprites.asm`), and a text/font engine
(`src/gfx/load_font.asm` 1bpp→2bpp expansion from `gfx/font/font.png`,
`src/text/text.asm` PlaceString/TextBoxBorder). The title screen
(`src/movie/title.asm`) and the overworld map loader/renderer
(`src/overworld/overworld.asm`) both render correctly in DOSBox-X: the title
shows "Pokémon Yellow Version", and `SKIP_TITLE=1` boots straight into a fully
drawn Pallet Town (Oak's Lab, tree border, sign) in the DMG-green palette.
Player movement now works: `OverworldLoop` reads the joypad and walks the
player in all four directions, scrolling the map smoothly via
`AdvancePlayerSprite` (which now relies purely on `LoadCurrentMapView` without
VRAM sliding) with land collision against the embedded `Overworld_Coll` passable-tile list.
The OAM sprite renderer (`src/ppu/ppu.asm:render_sprites`) is in: 8×8 DMG OBJ
emulation (X/Y flip, OBP0/OBP1, color-0 transparency, BG-priority bit), reading
`$FE00` and compositing after `render_bg`.

The `UpdatePlayerOAM` scaffold has been replaced by the **faithful sprite
engine**: `PrepareOAMData` (`src/gfx/sprite_oam.asm`) builds shadow OAM from the
16-slot `wSpriteStateData1/2` arrays (facing/animation table, under-grass
priority, OBP→CGB palette mapping, `$80+` tile path), and `UpdateSprites`
(`src/overworld/movement.asm`, with `UpdatePlayerSprite`/`Func_4e32`/`Func_5274`)
advances the player's facing and walk-frame leg animation each `OverworldLoop`
iteration. `frame.asm:update_oam` runs `PrepareOAMData` and DMA-copies shadow OAM
→ `$FE00` in the `DelayFrame` pipeline (gated on `wUpdateSpritesEnabled`).
`LoadPlayerSpriteGraphics` loads Red's standing tiles to `$8000` and walking
tiles to `$8800` (the VRAM layout the engine indexes; walking tiles time-share
vChars1 with the font, as on the GB). NPC slots are wired but inert (picture ID
0). Next: the NPC half of the sprite engine (`InitMapSprites` / sprite sets /
VRAM-slot allocation / `DetectCollisionBetweenSprites`), the window layer, then
the random-encounter trigger.

`render_bg` (`src/ppu/ppu.asm`) is a **native-width surface renderer**: it decodes
`wSurroundingTiles` (44×32 tile IDs) into a 352×256 pixel surface using the existing
`tile_cache` (2bpp→8bpp decoded tiles). It then blits a 320×200 window at a signed
pixel offset `(Xoff, Yoff)` derived from the coarse block alignment and the fine
`H_SCX`/`H_SCY` values, providing smooth per-pixel scrolling without wrap artifacts.
The old 256×256 VRAM torus emulation and related `RedrawRowOrColumn` rings are gone.
**Any new routine that writes VRAM tile data must set `g_tilecache_dirty`**.

**Temporary scaffold — two out-of-map clamps (`src/overworld/overworld.asm`):**
the extended 40×25-tile viewport draws a larger area than the original 20×18 and
the player is pinned at screen-center, so a player-centered camera near a map
edge reaches past the populated `wOverworldMap` data. Two complementary stopgaps
keep that from painting garbage:
1. **Block-ID clamp** in `DrawTileBlock`: a block ID past the embedded blockset
   is clamped to block 0.
2. **Block-map address clamp** in `LoadCurrentMapView`: `wOverworldMap` ($E800,
   2048 bytes) is separated from `wSurroundingTiles` ($E000, ~1728 bytes) by a
   ~$140-byte gap. Any read outside `[wOverworldMap, wOverworldMapEnd)` yields
   the map's border block (`wMapBackgroundTile`) instead of garbage, so the
   out-of-map area renders as clean dummy tiles matching the in-bounds border.

Both are stopgaps: the real fix is to **extend the map data** so those regions
hold real blocks (no blank area), after which both clamps are dead code and
should be deleted. The address clamp removes the garbage *now* (verified via
`FRAME.BIN` for baseline / north-transition / walk-to-edge); it does **not** yet
give editable map cells for that extended area — that still needs the map-data
extension (enlarged border / bigger block grid). See TODO.md (Phase 2).

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
  src/ppu/
    ppu.asm                ← software PPU: BG tile decoder + tilemap renderer
  src/input/
    joypad.asm             ← INT 9h keyboard ISR → GB joypad state
  Makefile
  link.ld                  ← DJGPP linker script
docs/
  register_map.md          ← SM83 → x86 register mapping (living doc)
  translation_log.md       ← per-routine translation notes
  glitch_safety.md         ← glitch sandbox guidance
  386_optimization_strategy.md ← Guide for fast and faithful 386 assembly optimizations
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

**Linker sections (critical, verified):** `link.ld` must explicitly map every
input section into a *loaded* output section (`.text`/`.data`). The
coff-go32-exe stub loads only the `.text`/`.data`/`.bss` extents it records;
any **orphan section** ld places elsewhere is given a VMA but its bytes never
reach memory, so symbols in it **read back as zero at runtime with no fault**.
This bit us hard: the overworld assets were in `section .rodata`, which had no
output rule, so `overworld_gfx`/`overworld_blocks`/`pallet_town_blk` were all
zero in memory → Pallet Town rendered all-white. `.rodata` is now folded into
`.data` in `link.ld`. Rule of thumb: put embedded data in `.data` (as the font
and title assets do), and if you ever add a new section name, add it to
`link.ld` first. Symptom of a broken/orphan section: a `rep movsb` from a
rodata label copies zeros while immediate `mov [ebp+x], imm` writes work fine.

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
- **`[EBP + disp]` addressing defaults to the SS segment**, and the go32
  loader (verified under HDPMI32) gives us an SS whose base does NOT match
  DS — so every EBP-relative GB memory access silently read/wrote the wrong
  linear memory until `setup_flat_access` was taught to normalize SS to the
  DS selector (with an ESP rebase of `ss_base - ds_base` in the same
  instruction pair). Symptom when broken: renderer reads all zeros, no crash.

### Video
- VGA Mode 13h (320×200, 256 colors)
- GB framebuffer: 160×144 at `[EBP + GB_BACKBUF]`
- 2× nearest-neighbor blit to `0xA0000`, centered (28-row letterbox top/bottom)
- Palette: 256-entry VGA (6-bit RGB via ports 0x3C8/0x3C9); layout TBD Phase 5.
  The current 4-shade DMG-green ramp (`dmg_palette` in `boot/video.asm`) is a
  **debug placeholder** — do not treat it as final. Phase 5 will translate the
  original **GBC** colors into the VGA palette (Yellow is CGB-enhanced; pull
  from the CGB palette data, not an expanded DMG ramp).

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

Full reference: **[docs/assembly.md](docs/assembly.md)** — build flags, asset flags, output files, warp format, DOSBox-X config.

Output EXE is **`dos_port/PKMN.EXE`** — DOS 8.3 name required for DOSBox-X `-c` invocation.

```sh
# Reference ROM (requires rgbds 1.0.1)
make compare

# DOS port (canonical; scripts below are wrappers)
make -C dos_port
make -C dos_port SKIP_TITLE=1          # skip title, boot straight to overworld
make -C dos_port BUG_FIX_LEVEL=1       # 1=critical fixes, 2=all fixes

# Asset regeneration (required after changing generator scripts or pret source)
make -C dos_port assets                # strip IF DEF(_DEBUG) blocks (normal)
make -C dos_port assets DEBUG_WARPS=1  # include debug warp entries
# IMPORTANT: make uses timestamps — changing DEBUG_WARPS requires explicit 'make assets'

# Convenience scripts (from repo root or dos_port/)
dos_port/build                         # build (passes args to make)
dos_port/run                           # build + launch in DOSBox-X

# Single file assembly check
nasm -f coff -o /dev/null dos_port/src/util/fill_memory.asm
```

DOSBox-X config (`~/.config/dosbox-x/dosbox-x-2026.06.02.conf`) is set to:
- `machine = vgaonly` (Mode 13h plain VGA — required)
- `cputype = 386_prefetch`
- `memory io optimization 1 = false` (VGA writes broken if true)

**Note:** All testing and debugging must occur on **DOSBox-X**, not standard DOSBox. Standard DOSBox lacks the accuracy and debugger features required for this port.

**Never hand-edit generated `assets/*.inc` files.** Fix the generator and re-run
`make assets`. The `MapHeaderPointers` table is computed at generation time — a
partial edit desyncs pointer addresses from blob offsets and silently corrupts
map loads (see `docs/translation_log.md` for the 2026-06-22 postmortem).

---

## Debugging (inspecting emulated GB memory)

The screen is a software PPU render: many distinct bugs collapse to the same
"all-white" / "all-garbage" picture, so **do not debug by staring at
screenshots and toggling tiles** — that loop ate two sessions on the `.rodata`
bug. Get ground truth from memory instead.

### Memory dump to a host file (primary, automatable)

`src/debug/debug_dump.asm` exfiltrates chosen windows of emulated GB memory to
`DUMP.BIN` (the dos_port dir / DOSBox-X C:), with **no PPU/palette/blit
confound** — the literal bytes at `[EBP + addr]`. It writes the file via DPMI
"Simulate Real Mode Interrupt" (INT 31h/0300h) into a conventional DOS buffer
(plain `int 21h` pointer args are NOT auto-translated under CWSDPMI), then
exits. Edit the `windows:` table to pick addresses.

```sh
make clean && make SKIP_TITLE=1 DEBUG_DUMP=1
dosbox-x -defaultdir "$PWD" -c 'mount c "'"$PWD"'"' -c c: -c PKMN.EXE -c exit
# then hexdump DUMP.BIN on the host (9 × 64-byte windows, in table order)
```

This is how the `.rodata` bug was localized: header vars and the `rep stosb`
border-fill were correct in the dump, but the whole `$4000`-asset window and
`$9000` tileset were zero — pointing at the asset load, not the map logic.

### DOSBox-X interactive debugger (secondary)

DOSBox-X (2026.06.02, SDL1) can also be built/run with the heavy debugger
(`Alt+Pause`; `MEMDUMPBIN <lin> <len>` writes a file). Linear address of a GB
offset = `[ds_base] + EBP + offset`; both are runtime values, so the file-dump
route above is usually faster than chasing them in the debugger.

### Back-buffer dump to PNG (preferred over screenshots)

`src/debug/debug_dump.asm:DumpBackbuffer` writes the full software-PPU back
buffer (`GB_BACKBUF`, 320×200 = 64000 raw palette-indexed bytes) to `FRAME.BIN`,
then exits — the **exact pixels DOSBox-X rendered**, with no compositor in the
loop (host Wayland/XWayland screenshot tools are unreliable across displays).
Render `FRAME.BIN` on the host with `tools/render_frame.py FRAME.BIN out.png`
(values 0–3 = DMG shades, 4–11 = sprite pixels), then view the PNG.
Driven by deterministic, input-free `%ifdef` harnesses in `EnterMap`:
`DEBUG_TRANSITION` (force a north crossing; add `DEBUG_BASELINE=1` — both via the
Makefile — for pristine Pallet Town) and `DEBUG_WALK_NORTH` (drive the real
movement primitives north `DEBUG_WALK_STEPS` steps, dumping at the crossing).
Typical loop: `make clean && make SKIP_TITLE=1 DEBUG_TRANSITION=1` →
`dosbox-x -defaultdir "$PWD" -c 'mount c "'"$PWD"'"' -c c: -c PKMN.EXE -c exit` →
`python3 ../tools/render_frame.py FRAME.BIN /tmp/f.png`. This is how the
2026-06-15 viewport diagnosis and the 2026-06-16 out-of-map clamp fix were made
(see docs/loadmapheader_handoff.md). Prefer this to screenshots for ground truth.

### Visual capture

`./test_render.sh [out.png]` does a clean `SKIP_TITLE=1` build, launches
DOSBox-X, waits, screenshots (spectacle → import fallback), and force-kills.
Good for confirming a final render once the data is known-correct. Note: under a
Wayland session the compositor screenshot may grab the wrong window — the
`FRAME.BIN` route above is more reliable.

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

## Package / System Install Policy

**All local package installs require explicit user permission before running**, even in
auto mode, for security reasons. This includes `apt`, `pacman`, `pip`, `npm -g`, and
any other package manager that modifies the system or user environment.

Exception: if Claude is running inside a self-contained web container / VM where it owns
the environment, installs may proceed without prompting.

---

## Save File Notes (Phase 5 — Not Yet Implemented)

- GB `.sav`: raw 32 KB SRAM dump (MBC5+RAM+BATTERY)
- DOS `.dsv`: `DOSV` magic + version byte + 2-byte checksum + 32 KB SRAM data
- Converter: `tools/saveconv.py` (stub until Phase 5 when save format is stable)
