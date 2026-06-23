# Plan: Native-width BG renderer (Stage A Complete), border + connections (Stage B Current)

## Context

The DOS port renders the overworld at a **40×25-tile / 320×200** viewport, but
the BG renderer (`src/ppu/ppu.asm:render_bg`) still emulates the Game Boy's
**32×32-tile / 256px** VRAM tilemap as a 256×256 torus surface and blits a
320px-wide window from it **with 256px wrap**. Because 320 > 256, every scanline
wraps the seam, forcing screen columns 256–319 to mirror columns 0–63.

**Verified empirically (2026-06-16):** on a baseline frame, columns 256–319 were
**98.6% pixel-identical** to columns 0–63 (residual = the player sprite drawn on
top); a 100–163 vs 0–63 control was 46% different. Deterministic
`DEBUG_WALK_NORTH DEBUG_WALK_STEPS=1/2/3` captures show top-row garbage after a
**single** step — while the camera is still well inside the map, so it is **not**
an out-of-bounds map read. Root cause is purely the renderer's 256px torus plus
the `CopyMapViewToVRAM`/`FillExtraVRAMRows` "32 tiles + 8 wrapped onto cols 0–7"
fold and the SCY-wrap that reads stale VRAM rows 25–31.

The earlier 2026-06-16 out-of-map clamp in `LoadCurrentMapView`
(read outside `[wOverworldMap,wOverworldMapEnd)` → `wMapBackgroundTile`) fixed a
**separate** real bug (edge/transition OOB block reads) and **stays**.

**Intended outcome:** a port-native BG renderer that shows 40 distinct tile
columns with smooth 2px scrolling and no wrap duplication, then (Stage B/C) map
data + connection geometry sized so the centered viewport never reads past the
map and transitions place the player correctly.

**Decisions locked with the user:**
- Architecture: **native oversized surface + plain pixel-offset blit** (no torus).
- Scope: renderer **and** border **and** connections, executed as 3 sequential,
  independently-verifiable stages; **Stage A is complete**, B is current, C is specced.
- Scroll: **per-pixel smooth** (preserve the 2px/frame glide).

---

## Stage A — Native-width BG renderer (COMPLETED 2026-06-16)

### Key insight that makes this clean
`LoadCurrentMapView` (`src/engine/overworld/overworld.asm`) already maintains
**`wSurroundingTiles`** = a **44×32-tile** decoded view (`SURROUNDING_WIDTH=44`,
`SURROUNDING_HEIGHT=32`) with a 2-tile (16px) margin on each side of the 40×25
viewport, rebuilt **once per 16px walk-step** (on `wWalkCounter==7`, the first
frame of each step; intermediate frames only accumulate `H_SCX/H_SCY += 2`). So
the surrounding buffer already has exactly the margin the fine scroll needs.

The native renderer mirrors **`wSurroundingTiles` (352×256 px)** and blits a
320×200 window at a signed pixel offset = (half-block coarse) + (fine 0..14px),
with **no wrap**. This removes the 40-into-32 fold entirely.

### New renderer (`src/ppu/ppu.asm`)
- [x] **Replace `bg_surface`** (`resb 256*256`) with a native surface
   `resb 352*256` (`SURROUNDING_WIDTH*8` × `SURROUNDING_HEIGHT*8` = 88 KB BSS in
   the program image, not the GB alloc — fine).
- [x] **Rewrite `render_bg`** to:
   - Decode `wSurroundingTiles` (44×32 tile IDs) → native surface using the
     existing `tile_cache` (keep `rebuild_tile_cache` and `g_tilecache_dirty`
     unchanged; OBJ tiles still need the cache). Reuse the per-tile decode body
     of `surf_decode_tile` but with **stride 352 and no `&31`/`&1023` torus
     masking** — surface tile (col,row) at `row*8*352 + col*8`.
   - Source tile IDs from `wSurroundingTiles` (`W_SURROUNDING_TILES`, EBP-rel),
     not VRAM `$9800`. Tile-data addressing mode (LCDC bit 4 → `tiledata_mode`)
     is unchanged.
   - **Blit** a 320×200 window at origin `(Xoff, Yoff)` into the 352×256 surface
     with a plain per-row `rep movsb` (no seam branch). `Xoff/Yoff` derived in §3.
   - Sync strategy: simplest correct first — **decode all 44×32 each frame**
     (1408 tiles × 64B ≈ 90 KB memcpy/frame, trivially within 60 Hz budget on
     386+). The shadow/diff optimization (`sync_surface_diff`/`bg_tilemap_shadow`)
     can return later keyed on `wSurroundingTiles` instead of VRAM; not needed
     for correctness. Drop `surf_last_base`/torus-base logic.
- [x] **Blit offset (the smooth-scroll math).** The window's top-left within the
   surface = the 2-tile margin minus the partial scroll already consumed:
   - Coarse: `wSurroundingTiles` is built so the 40×25 view begins at
     surface tile `(2,2)` only when `wXBlockCoord/wYBlockCoord == 0`; when a
     half-block coord is set, `LoadCurrentMapView` currently bakes a +2-tile
     offset into the `wTileMap` copy (see its `.adjust_x_coord`/`.adjust_y_coord`).
     In the native model we **drop that copy** and instead fold the half-block
     into the blit origin: `baseX = (2 - wXBlockCoord*2) tiles`,
     `baseY = (2 - wYBlockCoord*2) tiles` … (exact sign to be confirmed against
     a capture — see Verification; this is the one spot to calibrate).
   - Fine: the 0..14px within a step. Reuse `H_SCX`/`H_SCY`, but interpret them
     as a **signed pixel offset into the surface**, not a torus SCX/SCY. The
     accumulation in `AdvancePlayerSprite.scroll` (`H_SCX/H_SCY += 2*stepvec`)
     stays; only the renderer's interpretation changes.
   - `Xoff = baseX_px - H_SCX_signed`, `Yoff = baseY_px - H_SCY_signed`
     (sign calibrated empirically). Surface margin (16px) ≥ max fine (14px), so
     `Xoff/Yoff` stay in `[0, 352-320]`/`[0, 256-200]` — assert/clamp during bring-up.

### Retire the GB-VRAM BG scroll pipeline
These exist only to feed the torus; with the native surface they are dead:
- [x] `CopyMapViewToVRAM` / `CopyMapViewToVRAM2` (`overworld.asm`) — BG path.
- [x] `FillExtraVRAMRows` (`overworld.asm`) — stale-row hack; delete.
- [x] `RedrawRowOrColumn` + `Schedule{North,South}RowRedraw` /
  `Schedule{East,West}ColumnRedraw` + `CopyToRedrawRowOrColumnSrcTiles`
  (`overworld.asm`) and its `DelayFrame` call site (`frame.asm:58`).
- [x] `wMapViewVRAMPointer` slide block in `AdvancePlayerSprite` (`overworld.asm`
  ~1087–1141, the `.checkWest/.checkSouth/.checkNorth` `&0x03|0x98` ring math)
  and its resets (`ResetMapVariables`, `.mapTransition`, DEBUG harness).
- [x] `do_bg_transfer` BG copy in `frame.asm` is gated on `H_AUTO_BG_TRANSFER_EN`,
  which the overworld sets to 0 (`overworld.asm:403`); leave the routine for
  now (text/menu may use it later) but it is inert in the overworld.

**Keep:** `LoadCurrentMapView` (now the sole producer of the displayed BG, via
`wSurroundingTiles`), `AdvancePlayerSprite`'s coord/block bookkeeping
(`wXCoord/wYCoord/wXBlockCoord/wYBlockCoord`, `MoveTileBlockMapPointer*`,
`CheckMapConnections`), `wTileMap` (still written by text/menu code — see Risk),
`rebuild_tile_cache`, `render_window`, `render_sprites`, `present`.

### Coupling to verify, not assume
- **Text boxes / menus** write to `wTileMap`, not `wSurroundingTiles`. They are
  drawn while the player is **stationary** (fine offset 0, half-block aligned),
  where the visible window equals `wTileMap`. Overworld menus are not wired yet
  (Phase 2), so this is a **verification checkpoint**, not a blocker. Contingency
  if/when text lands: mirror `wTileMap` text writes into `wSurroundingTiles` at
  the current view offset, or composite `wTileMap` over the surface when
  stationary. Note in the handoff doc; do not solve speculatively now.

### Files touched (Stage A)
- `dos_port/src/ppu/ppu.asm` — surface size, `render_bg`, decode helper, drop
  torus/diff/base state.
- `dos_port/src/engine/overworld/overworld.asm` — delete the VRAM-ring scroll routines
  and the `wMapViewVRAMPointer` slide; simplify `AdvancePlayerSprite` to: update
  coords/blocks → `LoadCurrentMapView` → accumulate `H_SCX/H_SCY`. Drop
  `CopyMapViewToVRAM`/`FillExtraVRAMRows` calls in `LoadMapData`/`.mapTransition`
  and the DEBUG harness.
- `dos_port/src/video/frame.asm` — remove the `RedrawRowOrColumn` call (line 58).
- `dos_port/include/gb_memmap.inc` — comment updates only (no layout change in A).

### Verification (Stage A) — FRAME.BIN ground truth, per project convention
Build/capture loop (already wired):
```
make clean && make SKIP_TITLE=1 DEBUG_WALK_NORTH=1 DEBUG_WALK_STEPS=N
dosbox-x -defaultdir "$PWD" -c 'mount c "'"$PWD"'"' -c c: -c PKMN.EXE -c exit
python3 ../tools/render_frame.py FRAME.BIN /tmp/f.png
```
Checks:
- [x] **Wrap gone:** re-run the cols-256–319-vs-0–63 comparison (the script in the
   2026-06-16 session); expect it to now diverge like a normal control
   (~40–50% different), proving 40 distinct columns.
- [x] **No top-row garbage** at `DEBUG_WALK_STEPS=1,2,3` (the reproducer).
- [x] **Baseline unchanged:** `DEBUG_TRANSITION=1 DEBUG_BASELINE=1` still renders
   clean Pallet Town.
- [x] **Smoothness:** capture mid-step (odd `DEBUG_WALK_STEPS`) shows a 2px-offset
   glide, not a tile snap. Calibrate the `Xoff/Yoff` sign here.
- [x] **Interactive:** `make SKIP_TITLE=1`, launch DOSBox-X, walk all four
   directions and across the north transition; confirm coherent scroll + edges
   (edges may still show border-block fill until Stage B — that's expected).

---

## Stage B — Enlarge MAP_BORDER so the centered viewport never reads past the map (CURRENT)

**Problem:** player is pinned at screen tile (20,12) = block (5,3). The 40×25
viewport spans 10×6.25 blocks, so centering needs ~5 blocks left/right and ~3
up/down of real data around the player. `MAP_BORDER=3` is too small near edges →
the out-of-map clamp paints border tiles (clean, but not real map).

**Approach / Execution Plan (File-by-file):**

1. `dos_port/include/gb_memmap.inc`:
   - [ ] Change `MAP_BORDER` from `3` to `6` to cover the 5-block half-width + margin of our wider 40x25 viewport.
   - [ ] Change `W_OVERWORLD_MAP_SIZE` from `0x514` (1300 bytes) to `0x800` (2048 bytes). This guarantees that the largest maps in the game (e.g., Route 17 at 72 blocks high) will perfectly fit within the buffer when padded with `MAP_BORDER = 6` (which requires 1848 bytes).
   - [ ] Delete `W_REDRAW_ROW_OR_COLUMN_SRC_TILES` (80 bytes) entirely, as its corresponding logic was ripped out in Stage A.
   - [ ] Shift `W_TILEMAP_BACKUP2` down to `0xED80` (which is `0xE580` + `0x800`) to safely accommodate the expanded `wOverworldMap` buffer.

2. `dos_port/src/engine/overworld/overworld.asm`:
   - [ ] `SCREEN_BLOCK_WIDTH/HEIGHT` and `SURROUNDING_WIDTH/HEIGHT` are decoupled from `MAP_BORDER` and remain unchanged.
   - [ ] The codebase already leverages `MAP_BORDER * 2` symbolically (e.g., `add al, MAP_BORDER * 2`). Merely audit and update the hardcoded math inside the comments (e.g., change `10 + 6 = 16` to `10 + 12 = 22`). Note: Stage C will programmatically fix the `gen_map_headers.py` math.
   - [ ] Keep the out-of-map clamp in `DrawTileBlock` strictly as a safety net.

- [ ] **Verify:** baseline + walk-to-edge in all four directions show **real map data**
to the screen edge (no border-block band) via the FRAME.BIN loop.

---

## Stage C — Re-derive connection geometry for the new border/viewport (SPEC)

**Problem:** `tools/gen_map_headers.py` computes per-direction connection fields
(`_blk/_map/_win/_y/_x/_len`) with hardcoded `+6`/`+3`/`*2` that assume
`MAP_BORDER=3` and the GB's player-at-tile-(8,8). After Stage B these are wrong,
so transitions place the player/camera incorrectly.

**Approach (to detail next session):**
- [ ] Parameterize `gen_map_headers.py` formulas by `MAP_BORDER` and by the DOS
  player tile (20,12) instead of the GB (8,8). Regenerate
  `dos_port/assets/map_headers.inc`.
- [ ] The `connection`-macro formulas are hand-tuned per direction; **re-derive and
  verify each direction empirically** with `DEBUG_TRANSITION` (north today;
  add south/east/west harness variants) + FRAME.BIN, not by trusting the formula.
- [ ] Once map data fully covers the viewport, **delete both stopgaps**: the
  `DrawTileBlock` block-ID clamp and the `LoadCurrentMapView` address clamp.

- [ ] **Verify:** cross each connection; player stays at screen-center (20,12), new
map is correctly framed, no garbage, return crossing works.

---

## Out of scope (this whole pass)
- Audio, window/menu mid-scroll compositing, NPC sprite engine, save system.
- The `sync_surface_diff` perf optimization (full re-decode is fine at 60 Hz).

## Rollback
Each stage is a separable commit. Stage A is self-contained: if scroll
calibration regresses, the prior torus `render_bg` + VRAM-ring routines are in
git history. Keep the FRAME.BIN comparison script handy as the objective gate.
