# TODO

Prioritized task list. Check off items as they complete; add new items with phase prefix.

---

## Phase 0: Bootstrapping

- [x] Create project structure (`dos_port/`, `docs/references/`, etc.)
- [x] Write `README.md`, `ROADMAP.md`, `TODO.md`, `CLAUDE.md`
- [x] Fetch Pan Docs reference pages to `docs/references/pandocs/`
- [x] Write `docs/references/README.md` (DOS/DPMI/VGA reference links)
- [x] Write `docs/register_map.md` (SM83 → x86 mapping table)
- [x] Write `docs/glitch_safety.md` (glitch sandbox guidance)
- [x] `dos_port/include/gb_memmap.inc` — all GB address offsets
- [x] `dos_port/include/gb_macros.inc` — BUG_FIX_LEVEL macro + comment conventions
- [x] `dos_port/boot/entry.asm` — DPMI entry, memory alloc, /FIXALL|/FIXCRIT parse, main loop
- [x] `dos_port/boot/video.asm` — mode 13h init, test pattern, 2x blit stub
- [x] `dos_port/boot/timing.asm` — PIT reprogram (divisor 19886), tick ISR, vblank sync
- [x] `dos_port/Makefile` + `dos_port/link.ld`
- [x] `dos_port/src/util/fill_memory.asm` — first translated routine
- [x] `docs/translation_log.md` — FillMemory entry
- [x] `tools/saveconv.py` — stub only (see Phase 5)
- [x] `tools/colorize.py` — stub only (see Phase 5)
- [x] **Verify**: `make compare` succeeds with rgbds 1.0.1
      (verified 2026-06-12: pokeyellow.gbc, pokeyellow_debug.gbc, and
       pokeyellow.patch all check OK against the reference SHA1s)
- [x] **Verify**: `make -C dos_port` produces `pokeyellow_dos.exe` without warnings
- [x] **Verify**: `pokeyellow_dos.exe` shows test pattern + tick counter in DOSBox
      (verified 2026-06-12 in DOSBox-X 2024.03.01 with HDPMI32 as the DPMI host:
       mode 13h pattern renders, tick band cycles palette at 60 Hz, keypress
       exits cleanly, text mode + PIT + IRQ0 vector restored, DOS responsive)

---

## Phase 1: Core Infrastructure

- [x] Allocate GB memory block (EBP setup in entry.asm; now exercised by the
      PPU — required the SS=DS normalization fix in setup_flat_access, see
      CLAUDE.md "DPMI gotchas")
- [x] PPU: tile decoder (2bpp GB tiles → 8bpp indexed pixels) — src/ppu/ppu.asm
- [x] PPU: background tilemap renderer (SCX/SCY, wrapping, both LCDC tile
      data modes, both tilemaps, BGP shade mapping)
      (verified 2026-06-12 in DOSBox-X: demo tileset renders, arrow keys
       scroll with wrap in both axes, sub-tile fine offsets correct)
- [ ] PPU: OAM sprite renderer (40 sprites, 8×8 and 8×16, X priority)
- [ ] PPU: window layer renderer
- [ ] PPU: CGB attribute handling (palette, VRAM bank, flip bits)
- [x] Joypad: INT 9h handler → write `[EBP + IO_JOYP]` — src/input/joypad.asm
      (arrows/X/Z/Enter/RShift/Tab mapped; Esc = host quit; rJOYP select-bit
       protocol in joypad_update; IRQ1 vector restored on exit — verified)
- [ ] Save system: DOS file I/O replacing SRAM; define `.dsv` format
- [ ] Categorize all bugs in `docs/bugs_and_glitches.md` into critical/cosmetic/glitch
- [ ] `/FIXCRIT` runtime parsing wired to BUG_FIX_LEVEL

---

## Phase 2: Game Loop

- [x] Translate `home/init.asm` (Init, ClearVram, StopAllSounds, GBPalNormal)
      — src/init/init.asm. HW/subsystem steps (OAM DMA, ROM banking, LoadSGB,
      PlayIntro, audio, title screen) marked TODO and skipped to stay linkable.
- [x] Supporting home routines:
      CopyData/FarCopyData (src/util/copy_data.asm),
      DisableLCD/EnableLCD/ClearBgMap/FillBgMap (src/video/lcd_control.asm),
      DelayFrame/DelayFrames (src/video/frame.asm),
      ClearSprites/HideSprites (src/gfx/sprites.asm)
- [x] Text engine: LoadFontTilePatterns (src/gfx/load_font.asm, 1bpp→2bpp),
      PlaceString / TextBoxBorder (src/text/text.asm). Font art embedded from
      gfx/font/font.png via tools/gen_font_inc.py → assets/font_1bpp.inc.
      (verified 2026-06-13 in DOSBox-X: "POKEMON YELLOW" / "DOS PORT" rendered
       in the real game font — see docs/testing.md)
- [ ] Text engine: dictionary control codes (<PLAYER>, <PARA>, <CONT>, …),
      PrintText / dialogue-box flow, TextBoxGraphics tile loading
- [ ] Translate title screen logic (PrepareTitleScreen)
- [ ] Translate overworld engine
- [ ] Translate player movement
- [ ] Translate NPC movement / collision
- [ ] Translate random encounter trigger
- [ ] Translate battle engine (UI rendering pass first)

---

## Phase 3: Audio

- [ ] Define audio HAL interface (`dos_port/include/audio_hal.inc`)
- [ ] Detect sound hardware at startup (SB16 > GM > AdLib > Tandy > speaker)
- [ ] SB16 driver (`dos_port/src/audio/sb16.asm`)
- [ ] General MIDI / MPU-401 driver (`dos_port/src/audio/gm.asm`)
- [ ] Roland MT-32 driver (`dos_port/src/audio/mt32.asm`)
- [ ] AdLib / OPL2 driver (`dos_port/src/audio/adlib.asm`)
- [ ] Map GB APU channels (pulse 1/2, wave, noise) to sound card equivalents
- [ ] Audio mixing / volume control

---

## Phase 4: Network Multiplayer

- [ ] Define link cable HAL (`dos_port/include/serial_hal.inc`)
- [ ] Replace `; TODO-HW: network HAL` stubs with HAL calls
- [ ] Decide transport protocol (IPX / null-modem / TCP)
- [ ] Implement chosen transport driver
- [ ] Test trade flow
- [ ] Test battle flow

---

## Phase 5: Polish & Save Compatibility

- [ ] Finalize VGA palette layout (256-entry partition: UI / overworld / sprites / battle)
- [ ] Implement `tools/colorize.py` fully
- [ ] Full colorization pass (all tilesets, sprites, menus)
- [ ] Fullscreen scaling: integer scale options beyond 2×
- [ ] **`tools/saveconv.py`** — implement after DOS save format is stable
  - GB `.sav` (32 KB raw SRAM) ↔ DOS `.dsv` (`DOSV` + version + checksum + data)
  - Validate checksum, warn on corrupt saves before converting
- [ ] Packaging: README for end users, DOSBox config, 86Box config

---

## Phase 6: Glitch Preservation & Sandbox

- [ ] Tag every translated bug with `; BUG(critical|cosmetic):` comment
- [ ] Tag every intentional glitch with `; GLITCH:` comment
- [ ] DPMI host ID detection (INT 31h fn 0400h) → set `running_on_bare_hw` flag
- [ ] Startup warning when critical glitches enabled on bare hardware
- [ ] Finalize `docs/glitch_safety.md` with per-glitch safety ratings
- [ ] Stretch: launcher script for 86Box/DOSBox when ACE glitch mode selected

---

## Deferred / Open Questions

- [ ] Test target: specify DOSBox, 86Box, or real hardware configuration
- [ ] Linker: verify `cwsdstub` is not needed separately (confirmed: built into `i386-pc-msdosdjgpp-ld`)
- [ ] CGB VRAM bank 1 bank-switching emulation (currently placeholder at `GB_VRAM1`)
- [ ] Network transport decision (IPX vs serial vs TCP)
- [ ] 86Box/container launcher for ACE glitch sandboxing (Phase 6 stretch)
