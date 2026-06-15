# Session Handoff — 2026-06-15 (overworld renderer + collision)

Pass this to the next session. It captures the current state so you don't have to
re-derive it. Cross-refs: CLAUDE.md (Current Phase), TODO.md (Phase 2),
docs/386_optimization_strategy.md.

---

## TL;DR

The overworld renders and scrolls **correctly in all four directions** now
(verified by single-step screenshots, 2026-06-15). The window-garbage bug is
fixed. Remaining items, in priority order:

1. ~~**PERF** — `render_bg` too slow~~ ✅ DONE 2026-06-15 (decoded-tile cache; see below).
2. **Map connections** — un-stub the connection strips; removes map-edge corruption.
3. **BUG** — facing-DOWN collision lets the player walk 1 tile into objects.

The VGA mode is fine: we **are** rendering 320×200 (mode 13h, `present` copies
exactly 64000 bytes). Screen captures look 640×400 only because **DOSBox-X
upscales 2× for display** — not a bug in our code.

---

## What was fixed this session

### 1. Smooth-scroll `render_bg` rewrite (src/ppu/ppu.asm)
Replaced the tile-blitter (tiles pinned to 8-px slots, no sub-tile scroll) with a
**scanline renderer**: per output scanline, decode 41 tiles (40 visible + 1 for
the shift) into `bg_scanline_buf`, then copy 320 px starting at `SCX & 7`. Both
axes are now pixel-smooth and the old vertical sub-tile overflow is gone. It is
logically correct (samples the same tilemap rows the blitter did, just adds the
fine offset). **Cost:** ~8× more per-tile address resolves + per-pixel decode than
the blitter → this is the perf problem below.

### 2. Window-layer garbage at the bottom of the screen (src/ppu/ppu.asm:render_window)
Symptom: red/green vertical lines bottom-right (pixel values >3 indexing the
leftover `test_palette` ramps — nothing in our render path emits >3 normally).
Two compounding causes, both fixed:
- `LCDC_DEFAULT_VAL = 0xE3` has the window-enable bit set (bit 5) — the real
  Pokémon value. The game parks the window with `WY=144` to hide it on the 144-px
  GB screen, but our viewport is **200 px**, so rows 144–199 rendered the parked,
  uninitialized window. **Fix:** the window scanline loop is now bounded at
  `SCREEN_H` (144), not `RENDER_H` (200), so a parked `WY=144` stays hidden.
- The `wx_adj ≥ 0` copy path had no length clamp (unlike the left-clip path) and
  copied up to 320 bytes out of the 256-byte `row_buf`, spilling into adjacent BSS
  → those colored lines. **Fix:** clamp the copy to 256.

### 3. `DrawTileBlock` out-of-range block clamp (src/overworld/overworld.asm)
Still in place (temporary). Clamps block IDs past the 128-block embedded blockset
to block 0 so the extended 40×25 viewport doesn't paint garbage when the camera
reaches uninitialized `wOverworldMap` padding. **Becomes dead code once map
connections are implemented** (see below) — delete it then.

---

## Verified-good (don't re-investigate)
- Initial Pallet Town render: clean.
- Single-step scroll up / down / left / right: clean, correct content at edges.
- VGA output is 320×200 (640×400 = DOSBox-X 2× display scaling).

---

## Open problem 1 — render speed (TOP priority) — ✅ DONE (2026-06-15)

**Resolved** via a decoded-tile cache (the recommended pre-decode approach).
`render_bg` no longer bit-decodes per pixel in the hot path.

Implementation (src/ppu/ppu.asm):
- `tile_cache` (BSS, 384 tiles × 64 B = 24 KB) holds the whole BG/window
  tile-data region ($8000-$97FF) pre-decoded to 8bpp, with the BGP shade
  already baked in.
- `rebuild_tile_cache` decodes all 384 tiles in one linear pass (contiguous
  src + dst pointers) and records the BGP it used.
- `render_bg` rebuilds the cache only when `g_tilecache_dirty` is set **or**
  `IO_BGP` differs from the cached value; otherwise it reuses the cache (the
  common case while scrolling a static map). The per-tile inner loop is now two
  `mov`-pair 4-byte copies (`tile_cache → bg_scanline_buf`) instead of the
  8-iteration `shl`/`rcl` decode. The `SCX & 7` scanline buffer + 320 px copy
  for smooth horizontal scroll is unchanged.
- `g_tilecache_dirty` starts at 1 (in `.data`) and is set by every VRAM
  tile-data writer: `LoadFontTilePatterns`, `LoadTextBoxTilePatterns`
  (load_font.asm), `LoadYellowTitleScreenGFX` (title.asm),
  `LoadTilesetTilePatternData`, `LoadPlayerSpriteGraphics`,
  `SetupPalletTownNPCs` (overworld.asm), and `ClearVram` (init.asm). **If a new
  routine writes VRAM tile data ($8000-$97FF), it must set
  `g_tilecache_dirty` too**, or it will render stale tiles. (BGP/palette changes
  are auto-detected and need no flag.)

Verified: Pallet Town renders pixel-identical to the pre-optimization
known-good (SKIP_TITLE screenshot, 2026-06-15).

Decode work per frame on a static map drops from ~65k px-decodes to ~0 (cache
reused); only the cheap row copies + the existing scanline copy remain. The
cache rebuild (24,576 px) happens only on tileset/sprite/font/palette changes.

Possible follow-on (not done): make `render_window`/`decode_win_row` read the
same `tile_cache` instead of its own per-pixel decode; it is far less hot
(≤144 rows, only when a window is visible) so it was left as-is to limit scope.

**Bigger win (architectural — this is the open "VGA-native renderer" refactor in
TODO Phase 2):** pre-render the scrolling map to an offscreen 8bpp surface and
blit a `SCX`/`SCY`-offset viewport each frame, updating only the
`RedrawRowOrColumn` edge. Eliminates nearly all per-frame tile work. NOTE a real
tension to resolve here: the GB VRAM tilemap is **32 tiles wide (256 px)** but our
viewport is **40 tiles (320 px)** — wider than the torus. `CopyMapViewToVRAM`
currently folds the extra 8 tiles into columns 0–7 and relies on the renderer's
mod-32 wrap to unfold them; this is fragile and is part of why the refactor wants a
wider `wTileMap`/`wSurroundingTiles`. Decide: **optimize-in-place (pre-decode
tiles) vs. full VGA-native rewrite.** Recommendation: do the pre-decode first (big,
low-risk win) and treat the offscreen-surface rewrite as the follow-on refactor.

**Pre-computation answer (user asked):** yes — pre-decoding tile patterns to 8bpp
is the single highest-value precompute. (Sprite pre-scaling at build time is
already noted in the refactor plan.)

---

## Open problem 2 — map connections — ✅ STRIPS DONE (2026-06-15)

**Resolved (strip loading).** `LoadTileBlockMap` now loads the N/S/W/E
connection strips via translated `LoadNorthSouthConnectionsTileMap` /
`LoadEastWestConnectionsTileMap`. Pallet Town connects north→Route1,
south→Route21 (Route1/Route21 `.blk` embedded at OW_ROUTE1/21_BLK_GBADDR;
structs set in SetupPalletTown). Dump-verified the N border = Route 1 bottom 3
rows, S border = Route 21 top 3 rows. The border now shows real adjacent terrain.
**Remaining:** the map-*transition* trigger (walking into Route 1 as the active
map) is a separate follow-on (TODO.md); the DrawTileBlock clamp is kept (E/W
borders + reads past wOverworldMapEnd still need it).

### (historical) Open problem 2 — map connections (removes edge corruption)

User believes much of the remaining corruption is from missing map connectors —
consistent with the code. `LoadTileBlockMap` (src/overworld/overworld.asm)
translates the N/S/W/E connection-strip logic but forces every connected map to
`$FF` (skip), so the area beyond Pallet Town is uninitialized `wOverworldMap`
padding. Walking toward an edge exposes it → DrawTileBlock clamp → block 0.
**Action:** implement the connection-strip loading (load adjacent maps' edge block
data into the padding rows/cols). Then the edge corruption is gone and the
DrawTileBlock clamp is dead code to delete.

---

## Open problem 3 — facing-DOWN collision penetration (BUG)

Player can move ~1 tile into objects (signs, building roofs/fronts) when
approaching them **from above (facing down)**. Confirmed not graphical.

**Root cause:** `GetTileInFrontOfPlayer` (src/overworld/overworld.asm:~1303)
checks the tile **±1** from the player-center tile (20,12). But the player moves in
16px / 2-tile steps, so it must check **±2** — matching pret
`_GetTileAndCoordsInFrontOfPlayer` (engine/overworld/player_state.asm:261), which
uses down=`lda_coord 8,11`, up=`8,7`, left=`6,9`, right=`10,9` (all ±2 from the
center tile 8,9). Up/left/right "work" only because they approach thick solid
masses where ±1 vs ±2 lands on solid either way; down approaches thin top edges
where the ±1 tile is still passable.

**Proposed fix (verify in-game):** down (20,13)→(20,14), up (20,11)→(20,10),
left (19,12)→(18,12), right (21,12)→(22,12). Then walk into objects from all four
sides and confirm the player stops one tile away with no penetration and no
new over-blocking. Not applied this session because it needs in-game verification
(no input automation available here).

---

## Key file/line references
- `src/ppu/ppu.asm` — `render_bg` (~104, scanline renderer), `render_window`
  (~411, window-bound + copy-clamp fix), `render_sprites` (~251).
- `src/overworld/overworld.asm` — `GetTileInFrontOfPlayer` (~1303),
  `DrawTileBlock` (~579, temp clamp), `LoadTileBlockMap` (~486, stubbed
  connections), `AdvancePlayerSprite` (~793), `CopyMapViewToVRAM` (~738).
- `src/video/frame.asm` — `DelayFrame` per-frame pipeline (render order, ~50).
- `boot/video.asm` — mode 13h + `present` (320×200, confirmed).
- `include/gb_memmap.inc` — RENDER_W/H=320/200, SCREEN_H=144, SCREEN_TILES_W/H
  =40/25, TILEMAP_W=32.
- pret reference: `engine/overworld/player_state.asm` (collision geometry),
  `home/overworld.asm` (map view/scroll).
