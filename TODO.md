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
- [~] PPU: OAM sprite renderer — src/ppu/ppu.asm:render_sprites
      (40 sprites, 8×8, X/Y flip, OBP0/OBP1, color-0 transparency, BG-priority
       bit; reads $FE00, composited after render_bg. Verified 2026-06-14: the Red
       player sprite renders camera-locked at screen center and faces the walk
       direction. REMAINING: 8×16 OBJ size, the 10-sprites-per-scanline limit,
       and true smaller-X-wins priority — currently reverse-OAM-order draw, which
       only honors the index tiebreak.)
- [x] Sprite engine: faithful PrepareOAMData + UpdateSprites (replaces the
      UpdatePlayerOAM scaffold) — src/gfx/sprite_oam.asm, src/overworld/movement.asm.
      Player now renders via the real shadow-OAM pipeline driven by
      wSpriteStateData1/2: UpdateSprites advances facing + walk-frame animation,
      PrepareOAMData (run in the DelayFrame pipeline, DMA-copied to $FE00) builds
      shadow OAM with under-grass priority, OBP mapping, and the $80+ tile path.
      Walking tiles loaded to $8800 so the legs animate. NPC slots are inert but
      wired (picture ID 0). Verified 2026-06-15 via DEBUG_DUMP. REMAINING for the
      sprite engine: NPC slots (InitMapSprites / sprite sets / VRAM-slot alloc),
      DetectCollisionBetweenSprites, and the spinning/ledge paths.
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
- [x] Text engine: dictionary control codes (<PLAYER>, <PARA>, <CONT>, …),
      PrintText / dialogue-box flow, TextBoxGraphics tile loading.
      All 20 dict codes implemented; TextCommandProcessor + PrintText translated.
      LoadTextBoxTilePatterns loads box/extra tiles ($60–$7F) from font_extra.png.
      Phase 2 stubs: manual_text_scroll (no-op), scroll_text_up (no-op), TX_FAR
      (skip 3 bytes). W_PLAYER_NAME/W_RIVAL_NAME addresses TODO: verify vs. sym.
- [x] Translate title screen logic (PrepareTitleScreen / DisplayTitleScreen)
      — dos_port/src/movie/title.asm. Bounce animation, blink state machine,
        and A/Start → main menu input. Audio/OAM/CGB stubs; MainMenu → Init reset.
        Assets generated by tools/gen_title_gfx_inc.py → dos_port/assets/*.inc.
        Verified build: make check + make succeed, pokeyellow_dos.exe produced.
- [x] Translate overworld engine (map loader/renderer; Pallet Town renders)
- [x] Translate player movement — src/overworld/overworld.asm
      (OverworldLoop joypad state machine; AdvancePlayerSprite + sliding
       wMapViewVRAMPointer + RedrawRowOrColumn edge redraw wired into DelayFrame;
       MoveTileBlockMapPointer{E,W,S,N}; land collision via IsTilePassable against
       the embedded Overworld_Coll list. Verified 2026-06-14 in DOSBox-X: walking
       in all four directions scrolls Pallet Town smoothly with correct tiles at
       the newly exposed edges; trees/buildings collide. Omitted vs pret: OAM
       sprite shift, ledges, tile-pair collisions, warps, NPCs, battles, scripts.)
- [ ] **MAJOR REFACTOR: VGA-native renderer (40×25 viewport, 320×200 native output)**
      Plan: `/home/beowulf-linux/.claude/plans/greedy-roaming-toucan.md`
      
      Current 160×144 → 2× blit wasteful: 144-pass scanline decode is expensive on 386
      (550k cycles/frame), and the bottom 44 GB rows are silently clipped. Replace with:
      - Tile-blitter PPU: 40×25 = 1,000 tile passes per frame (not 4,608 scanline
        tile-strip decodes); single direct write to 320×200 back buffer.
      - WRAM expansion: wTileMap 360→1,000 B, wSurroundingTiles 480→1,408 B;
        all addresses via constants (no hardcoded offsets).
      - Sprite pre-scale at build time (2bpp 8×8 → 8bpp 16×16): 65 KB static table,
        zero per-frame decode cost.
      - `present()` simplifies to `rep movsd` (16k dwords, ~1 ms on 386).
      
      Scope: 8 implementation steps across ppu.asm, video.asm, gb_memmap.inc,
      overworld.asm, movement.asm, sprite_oam.asm, gen_spr_tiles.py. Multi-session task.
      
      Awaiting: first session to start with Step 1 (geometry constants).
      
- [ ] **Extend map data to cover the extended-draw region, then remove the
      `DrawTileBlock` out-of-range block clamp.** The 40×25-tile viewport draws
      a larger area than the original 20×18, so the camera can reach into
      uninitialized `wOverworldMap` padding and read block IDs past the embedded
      blockset. A temporary clamp (block ID → 0 when out of range) in
      `DrawTileBlock` (src/overworld/overworld.asm) stops the garbage. The real
      fix is to extend the maps so those regions hold real blocks (no blank
      area); once done, delete the clamp — it becomes dead code.
- [ ] **BUG — collision: facing DOWN lets the player penetrate 1 tile into
      objects** (signs, building roofs/fronts) when approached from the top.
      Confirmed NOT a graphical artifact (user, 2026-06-15). Root cause:
      `GetTileInFrontOfPlayer` (src/overworld/overworld.asm) checks the tile **±1**
      from the player-center tile (20,12), but the player moves in 16px / 2-tile
      steps, so it must check **±2** — matching pret
      `_GetTileAndCoordsInFrontOfPlayer` (engine/overworld/player_state.asm):
      down=`lda_coord 8,11`, up=`8,7`, left=`6,9`, right=`10,9` (all ±2 from
      center 8,9). Proposed fix: down (20,13)→(20,14), up (20,11)→(20,10),
      left (19,12)→(18,12), right (21,12)→(22,12); then verify all four
      directions in DOSBox-X (down stops short of objects; up/left/right don't
      become over-restrictive).
- [x] **PERF — heavily optimize render_bg** (2026-06-15). The per-pixel
      2bpp→8bpp decode is no longer in the hot path: a 24 KB decoded-tile cache
      (`tile_cache`, 384 tiles × 64 B, BGP baked in) pre-decodes $8000-$97FF
      once, rebuilt by `rebuild_tile_cache` only when `g_tilecache_dirty` is set
      (by VRAM-tile loaders) or BGP changed. `render_bg` assembles scanlines by
      copying cached rows. Verified pixel-identical. See translation_log.md /
      session_handoff.md. **Invariant:** new VRAM-tile-data writers must set
      `g_tilecache_dirty`. Larger win still open (folds into the VGA-native
      refactor below): pre-render the map torus to an offscreen 8bpp surface and
      blit a SCX/SCY-offset viewport, updating only the RedrawRowOrColumn edge —
      eliminates nearly all per-frame tile work.
- [ ] **NEEDS FIXED — red strip / out-of-range pixel values.** A red strip
      appears on screen that is NOT background data: under the current lazy
      "pea-soup green" palette the BG can only render raw colors 0–3 (all green)
      and sprites 4–11 (also green), and `commit_palette` only initializes DAC
      entries 0–11. A red strip therefore means some renderer path writes pixel
      values ≥12, which index the leftover boot `test_palette` ramps (12–63 =
      red). Distinct from the missing-map-connector junk (that's a separate
      item). Investigate writers that could emit ≥12 into the back buffer:
      `render_window`/`row_buf` edge handling, `render_sprites` with garbage
      OAM/tile/attr in uninitialized slots, or any direct back-buffer write.
      Belt-and-suspenders fix: also initialize DAC entries 12–255 to a safe
      color (or black) in `video_init` so out-of-range values don't show as
      garish red and are easier to spot/triage. (Reported 2026-06-15.)
- [x] **Map connections: un-stub the LoadTileBlockMap N/S/W/E connection
      strips** (2026-06-15). `LoadNorthSouthConnectionsTileMap` /
      `LoadEastWestConnectionsTileMap` are translated and wired in; the N/S/W/E
      connection-strip headers are loaded. Pallet Town now connects north→Route1,
      south→Route21 (block data embedded at OW_ROUTE1/21_BLK_GBADDR; structs set
      in SetupPalletTown). Dump-verified: the wOverworldMap N border = Route 1's
      bottom 3 rows, S border = Route 21's top 3 rows. So the border now shows
      real adjacent terrain instead of the background-block wall.
- [ ] **Map transition across a connection — faithful LoadMapHeader** (next up).
      Decision (2026-06-15): build the real ROM map-header infrastructure (not a
      hardcoded dispatcher) so Pallet Town ↔ Route 1 ↔ Route 21 become walkable.
      **Full plan + format spec + phased steps + the pointer-relocation challenge
      are in docs/loadmapheader_handoff.md** — start there. Involves: embed +
      relocate map headers/object data + a MapHeaderPointers table; translate
      LoadMapHeader / LoadTilesetHeader / CopyMapConnectionHeader / CheckMapConnections;
      wire the post-step connection check into OverworldLoop; retire the
      SetupPalletTown scaffold. Renderer needs no changes (surface mirror is
      decoupled). DrawTileBlock clamp stays (E/W + past-map-end).
- [ ] Translate NPC movement / collision
- [ ] Translate random encounter trigger
- [ ] Translate battle engine (UI rendering pass first)

---

## Phase 3: Audio

- [ ] Define audio HAL interface (`dos_port/include/audio_hal.inc`)
- [ ] Detect sound hardware at startup (SB16 > GM/MT-32 > AdLib > Tandy > speaker)
- [ ] SB16 driver (`dos_port/src/audio/sb16.asm`)
- [ ] General MIDI / MPU-401 driver (`dos_port/src/audio/gm.asm`)
- [ ] Roland MT-32 driver (`dos_port/src/audio/mt32.asm`)
- [ ] AdLib / OPL2 driver (`dos_port/src/audio/adlib.asm`)
- [ ] Map GB APU channels (pulse 1/2, wave, noise) to sound card equivalents
- [ ] Audio mixing / volume control

### Phase 3 design direction (per user, 2026-06-14)

- **Two output families, two strategies:**
  - **Tandy & SB16** — treat as a more-or-less 1:1 conversion of the GB APU
    channels (pulse 1/2, wave, noise) to the chip's equivalents (real-time
    synthesis from the GB sound source, like the chiptune original).
  - **MT-32 & General MIDI** — drive with **pre-rendered MIDI files** instead of
    real-time channel synthesis. MT-32 and GM use *different* instrument maps, so
    we keep **two MIDI copies of each track** (one voiced for MT-32 patches, one
    for the GM patch set).
- **Generate the MIDI at build time** from the Game Boy sound source code
  (the pret `audio/music/*.asm` + engine note/tempo tables) via a new tool
  (e.g. `tools/gen_midi.py`) — don't hand-author or ship binary MIDI as opaque
  assets; derive them from the disassembly so they stay in sync.
- **Explore instrument choices per track** rather than a single fixed voice on
  every track. The MT-32 has a large patch set (and programmable timbres) and GM
  lets us pick specific program numbers — pick voicings that suit each track
  (e.g. battle vs. town vs. fanfare) instead of one default instrument.
- Open questions to resolve when Phase 3 starts: how faithfully to map GB
  envelope/duty/sweep into MIDI CC/velocity; whether MT-32 gets custom timbres
  (SysEx) or sticks to factory patches; per-track tempo/loop-point extraction.

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

- [x] Test target: specify DOSBox, 86Box, or real hardware configuration: DOSBOX-X is the default test platform
- [ ] Linker: verify `cwsdstub` is not needed separately (confirmed: built into `i386-pc-msdosdjgpp-ld`)
- [ ] CGB VRAM bank 1 bank-switching emulation (currently placeholder at `GB_VRAM1`)
- [ ] Network transport decision (IPX vs serial vs TCP)
- [ ] 86Box/container launcher for ACE glitch sandboxing (Phase 6 stretch)
