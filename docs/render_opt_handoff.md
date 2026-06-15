# Render Optimization Journey — running handoff

Living progress log for the render-speed work. **One section per step**, revised
as each lands. Read top-to-bottom for current state, then "Next step" for what to
do. Plan of record: docs/render_tier2_plan.md. Background: docs/session_handoff.md,
docs/386_optimization_strategy.md.

Decisions locked with the user:
- Keep the GB tile system (tilemap + 2bpp tiles) as source of truth.
- **Chunky 256-color output, raw palette indices** (NOT planar 16-color) — keeps
  the Phase 5 GBC-color goal open. We let the VGA DAC do GB palette mapping
  (idea borrowed from GaelCathelin/Game-Boy-DOS; that emulator uses planar mode
  0xD, which we reject because 16 colors can't represent GBC).
- Target a slow 386; be aggressive. Each step independently shippable + pixel-
  verifiable against the known-good Pallet Town (`./test_render.sh`).

---

## Status board

| Step | What | State |
|------|------|-------|
| 0 | Decoded-tile cache (raw bit-decode out of hot path) | ✅ done (earlier) |
| 1 | Raw color indices + DAC palette mapping | ✅ done 2026-06-15 |
| 2 | Kill the double full-screen copy | ✅ done 2026-06-15 |
| 3 | Offscreen chunky surface + viewport blit | ✅ done 2026-06-15 |
| 4 | (optional) Mode X / hardware scroll | ⬜ maybe |

User feedback after step 1: "already way faster." (Some hitching walking *down*
is from the missing-map-connector junk data — already tracked separately, not a
renderer issue.)

---

## Step 1 — raw color indices + DAC palette mapping ✅ (2026-06-15)

**Goal:** stop baking BGP/OBP shades into framebuffer pixels. Write the *raw* GB
color and let the VGA DAC map color→shade, set once per frame. Cheaper (palette
change = a few register writes, not a tile re-decode) and more faithful to
palette fades/effects.

**Framebuffer index convention now:**
- BG / window: raw color `0-3` → DAC entries `0-3`
- Sprite via OBP0: `4 + color` → DAC `4-7`
- Sprite via OBP1: `8 + color` → DAC `8-11`
- Sprite color 0 still transparent (not written). BG-priority check now tests BG
  *color* 0 (`cmp [backbuf],0`), which is more correct than the old "shade 0".

**Changes:**
- `src/ppu/ppu.asm`:
  - `rebuild_tile_cache` stores raw color (dropped the `bgp_tab` lookup + BGP
    unpack). `tile_cache` no longer depends on BGP, so `render_bg`'s rebuild
    trigger is `g_tilecache_dirty` only — the BGP-compare and `g_tilecache_bgp`
    are gone.
  - `decode_win_row` / `render_window` write raw color (dropped BGP unpack).
  - `render_sprites` writes `4|color` / `8|color` (dropped the OBP0/OBP1 unpack
    and `obp_tab`). `bgp_tab` and `obp_tab` BSS removed.
- `boot/video.asm`: new `commit_palette` — reads BGP/OBP0/OBP1 ($FF47-49, three
  consecutive regs), programs DAC entries 0-11 from `dmg_palette`
  (`DAC[base+c] = dmg_palette[(reg>>2c)&3]`). Skips when the three regs are
  unchanged (`pal_shadow`, init 0xFF). Note: it uses EBP as scratch *after*
  deriving `esi = ebp+IO_BGP` (pushad/popad save EBP).
- `src/video/frame.asm`: `DelayFrame` calls `commit_palette` right after
  `commit_shadow_regs` (the per-frame VBlank-style register commit).

**Why identical on screen:** at the normal BGP/OBP ($E4 etc., identity mapping)
raw color == old shade and `DAC[c] = dmg_palette[c]`, so output is byte-identical.
The win shows on palette changes (no rebuild) and unblocks steps 2-3.

**Verified:** `./test_render.sh` — Pallet Town BG + player/NPC sprites render
correctly in DMG green (sprites confirm the DAC 4-11 path). Build clean (only the
pre-existing benign BSS `align` warnings).

**Gotchas for later:**
- Anything that writes the back buffer directly must use the raw-index convention
  now (e.g. a future textbox/HUD), not shade values.
- `draw_player_marker` (gated off) writes "shade" 0/3 — harmless at normal BGP,
  but revisit if re-enabled.
- `video_init` still loads the boot test palette + `dmg_palette` into DAC 0-3;
  `commit_palette` overrides 0-11 from frame 1. Fine, but that init block is now
  mostly boot-diagnostic.

---

## Step 2 — kill the double full-screen copy ✅ (2026-06-15)

**Was:** a scroll frame moved ~192 KB — `render_bg` decoded 41 tiles into
`bg_scanline_buf` (~64 KB write), then `rep movsb` copied 320 px/line into the
back buffer at the `SCX&7` offset (64 KB), then `present` copied the back buffer
to VGA (64 KB).

**Now:** `render_bg` assembles each scanline **directly into the back buffer** in
one write pass — `bg_scanline_buf` and the per-line `rep movsb` copy are gone.
~64 KB/frame + the copy-loop overhead removed (192 KB → ~128 KB traffic).

**How the `SCX&7` fine offset is handled without the buffer:** each tile's 8
decoded bytes are written at `dest_pos = tile_col*8 - fine_x`, with per-tile
left/right clipping (`bg_row_ptr` = row start). Tile 0 left-clips by `fine_x`
(writes `8-fine_x` bytes at row start); the last tile right-clips to the
remaining room. With `fine_x = 0` the 41st tile clips to zero → 40 full tiles;
with `fine_x > 0` tiles 0 and 40 are partial → exactly 320 px. The `rep movsb`
count is the (possibly clipped) tile width.

**Why keep the back buffer + `present`:** window (text boxes — potentially large)
and sprites composite in fast RAM, and sprite BG-priority reads the composited
pixel. Doing that on VGA would mean slow VGA reads + scattered VGA writes.
`present` is a single streaming `rep movsd` (cheap). So we cut the *redundant RAM
copy*, not `present`.

**Changes:** `src/ppu/ppu.asm` `render_bg` scan loop rewritten; BSS `bg_fine_y2`
and `bg_scanline_buf` removed, `bg_row_ptr` added.

**Verified:** `./test_render.sh` — Pallet Town pixel-correct, sub-tile fine
offset intact (no horizontal seam), sprites correct.

---

## Step 3 — offscreen chunky surface + viewport blit ✅ (2026-06-15)

The structural win. `render_bg` no longer re-resolves 41 tiles × 200 scanlines or
walks the tilemap torus per frame.

**Design (decoupled — NO changes to the faithful scroll/redraw logic):** a
`bg_surface` (256×256 chunky raw-color, in BSS) mirrors the *decoded* BG tilemap
torus. Each frame `render_bg`:
1. Picks the BG tilemap base (LCDC bit 3) and tile-data mode (bit 4).
2. **Syncs** the surface: if `g_tilecache_dirty` (tile data changed) or the
   tilemap base switched → full rebuild (`rebuild_tile_cache` +
   `rebuild_surface_full`, refreshing `bg_tilemap_shadow`). Otherwise
   `sync_surface_diff` compares the live VRAM tilemap to `bg_tilemap_shadow` and
   re-decodes only the changed tiles via `surf_decode_tile` (while walking that
   is just the edge strip `RedrawRowOrColumn` wrote — cheap, no spikes).
3. **Blits** a 320×200 window from the surface at `(SCX,SCY)` with 256-px torus
   wrap on both axes (1–2 `rep movsb` per row). No per-tile addressing, no
   40-into-32 fold. Sampling matches the old renderer exactly: BG pixel (x,y) =
   surface pixel `((SCX+x)&255,(SCY+y)&255)`.

This is the chosen "screen-area torus surface" option (the 256×256 torus *is* the
GB's BG map space; we mirror it rather than maintaining a separate wider surface,
so the existing sliding-window scroll machinery is untouched). `tile_cache` is
kept as the decoded-tile-data store the surface copies from (so a future
animated-tile `g_tilecache_dirty` tick costs a cache rebuild + surface copy, not
a full fresh 2bpp decode).

**Changes:** `src/ppu/ppu.asm` — `render_bg` rewritten as sync+blit; new
`surf_decode_tile` / `rebuild_surface_full` / `sync_surface_diff`; BSS gained
`bg_surface` (64 KB), `bg_tilemap_shadow` (1 KB), `surf_last_base`; removed the
per-scanline scratch (`bg_fine_x`, `bg_tile_col0`, `bg_fine_y8`,
`bg_tilemap_row`, `bg_row_ptr`, `bg_y`). `rebuild_tile_cache` unchanged.

**Cost:** static frame = ~1024-byte tilemap diff + one 64 KB windowed blit (no
addressing tax). Walking frame = + re-decode of the changed edge tiles (~tens of
tiles). Full rebuild only on map load / tile-data change.

**Verified (2026-06-15):** clean-boot capture matches the known-good Pallet Town
exactly; user-driven scrolling in all directions renders clean, correctly-aligned
tiles with no stale strips or seams at the 256-px torus boundary.

**Known issue (separate, NOT this step's regression):** a **red strip** has been
observed that is not background data — under the lazy pea-soup palette the BG is
always green (0–3) and sprites 4–11, so a red strip implies a pixel value ≥12
indexing the un-initialized DAC ramps. Tracked as a NEEDS-FIXED item in TODO.md
(distinct from the missing-connector junk). Not addressed here.

**Possible follow-ups:**
- `sync_surface_diff` uses a byte compare over 1024 entries; could be dword-batched
  (negligible vs. what was removed, so not done).
- Step 4 (Mode X / hardware scroll) remains available if a slower target needs it
  — would let the CRTC scroll and cut the per-frame 64 KB blit too, drawing only
  exposed strips. Big change; only if required.

---

## Next step — none mandatory

Tier 2 (steps 1–3) is complete: the per-frame tile-decode, double copy, and
per-scanline tile addressing are all gone. Step 4 (Mode X) is optional and only
worth it if the real target CPU still struggles. Otherwise the render-opt quest
is done; remaining overworld work (map connectors, facing-down collision) is in
docs/session_handoff.md.
