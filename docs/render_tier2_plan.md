# Render Tier 2 Plan — chunky raw-index surface + hardware palette

Status: **planned, not yet implemented** (2026-06-15). Supersedes the "render
speed" follow-on noted in session_handoff.md. Cross-refs:
docs/386_optimization_strategy.md, session_handoff.md, the decoded-tile-cache
work already landed in src/ppu/ppu.asm.

---

## Goal & constraints

`render_bg` still spends most of a scroll frame on (1) ~120k instructions of
per-scanline tile **addressing** (re-walking the 32-wide tilemap torus, mode
branch, VRAM→cache offset) and (2) **triple full-screen memory traffic**
(scanline buf 64 KB → back buffer 64 KB → VGA 64 KB = 192 KB/frame). The
decoded-tile cache removed the per-pixel bit decode but not these.

Decisions locked in with the user:
- **Keep the GB tile system** (wOverworldMap blocks + 2bpp tile data + tilemap)
  as the source of truth — memory-efficient, preserves glitch/bug behavior.
- **Chunky 256-color output (mode 13h / Mode X), raw palette indices** — NOT a
  planar 16-color mode. Keeps the Phase 5 **GBC color** goal open (GBC needs up
  to ~56 on-screen colors; 4 bitplanes can only do 16).
- Target a **slow 386**; be aggressive.

---

## What we took from Game-Boy-DOS (GaelCathelin/Game-Boy-DOS, SCREEN.c)

That emulator uses planar VGA **mode 0xD** and writes GB 2bpp tile bytes
**directly** into VGA bitplanes, with the **VGA palette hardware** doing GB
shade mapping (attribute controller / DAC, reprogrammed once per frame). It runs
full-speed on a 486 **even though it redraws every frame with no hardware
scrolling**.

Transferable lessons (the planar mode itself is rejected — DMG-only, see above):

1. **Let the DAC do GB palette mapping; never bake shades into pixels.** Write
   the **raw color index** to the framebuffer and map indices→colors via DAC
   registers. A BGP/OBP change becomes a handful of register writes instead of a
   tile re-decode — cheaper *and* more faithful to palette fades/effects. (Our
   current tile cache bakes BGP in and rebuilds on BGP change; this removes that
   coupling entirely.)
2. **The redraw is not the enemy — the per-pixel cost is.** Their per-pixel work
   is ~nil (planar copy + HW palette), so a full per-frame redraw is fine. Our
   enemies are the 8bpp baking, the double copy, and software palette/compositing
   — not the act of redrawing. This means Tier 2 should first attack *cost per
   pixel and copy count*, and the offscreen surface is a second lever, not the
   only one.
3. (Later) **Hardware/region sprite compositing** is possible, but in chunky mode
   we keep software sprite compositing (cheap: few sprites visible).
4. Their `tweakTimings()` CRTC retiming is GB-specific; we run our own 60 Hz
   loop and don't need it.

---

## Architecture

### A. Palette: raw indices + DAC mapping (do this first — small, high-value)

Framebuffer pixels become **raw GB color indices**, and the DAC maps them:

| DAC entry | Meaning (DMG now)                  | GBC (Phase 5)                |
|-----------|------------------------------------|------------------------------|
| 0–3       | BG color 0–3 → BGP-mapped shade    | BG palette 0, colors 0–3     |
| 4–7       | OBJ via OBP0, colors 0–3 (0 unused)| OBJ palette 0                |
| 8–11      | OBJ via OBP1                       | OBJ palette 1                |
| …         |                                    | up to 32 BG + 24 OBJ entries |

- BG tiles write **raw color 0–3**. Sprites write **(4 | color)** for OBP0,
  **(8 | color)** for OBP1; color 0 = transparent (skip the write).
- On the per-frame shadow-register commit (frame.asm `commit_shadow_regs`), if
  BGP/OBP0/OBP1 changed, rewrite the 4/4/4 DAC entries. No surface/cache rebuild.
- This deletes the tile cache's BGP-bake and its BGP-dirty rebuild trigger:
  `rebuild_tile_cache` stores the **raw 2-bit color**, so the cache depends only
  on VRAM tile data (`g_tilecache_dirty`), never on palette.
- GBC-ready: a pixel can later encode `(palette<<2)|color` and the DAC holds all
  palettes; nothing about the chunky pipeline changes.

### B. Offscreen surface + viewport blit (the structural win)

Render the map into a **chunky raw-index surface** and per frame copy a window
out of it — eliminating all per-frame tile addressing and the torus/40-into-32
fold.

Surface-size options (pick at implementation time; (2) recommended):
1. **Whole-map surface.** Simplest blits (flat camera offset, no wrap), but a big
   map (≈640×960+ px) is ~0.6–1 MB via DPMI. Rebuild on map load only; strip
   updates only for animated/script tile changes.
2. **Screen+margin torus surface (recommended).** ~360×240–256×256 (~90–110 KB),
   kept in sync by **porting `RedrawRowOrColumn`/`AdvancePlayerSprite`'s
   sliding-window trick to write decoded tiles into this surface** instead of
   (or in addition to) the GB VRAM tilemap. Per frame: one windowed blit; per 8
   px scrolled: decode one exposed tile row/col into the surface edge. Most
   memory-efficient and closest to the GB's own approach. Cost: the blit splits
   into two memcpys per row at the torus seam.

Per-frame overworld pipeline becomes:
1. `commit_shadow_regs` (+ DAC update if palette changed).
2. (option 2) if a tile row/col was exposed this step, decode that strip into the
   surface edge (ports the existing RedrawRowOrColumn logic, chunky target).
3. **Blit the 320×200 window** from the surface at `(camX, camY)` → back buffer
   *or directly to VGA*. Source stride = surface width; `rep movsd` per row.
4. Composite sprites (raw OBP indices; color-0 skip; BG-priority compares the
   surface/backbuf value against 0, same as today).
5. `present` (only if we kept a back buffer).

### C. Kill the double copy

Regardless of A/B: render the BG window straight into the back buffer (drop the
separate `bg_scanline_buf` → back-buffer copy), or blit the window **directly to
VGA** and composite sprites on VGA (drop `present` entirely). We already
`wait_vblank`, so direct-to-VGA is likely tear-free; fall back to back
buffer+present if tearing shows. Traffic 192 KB → 64–128 KB/frame.

---

## Faithfulness / risk notes

- **VRAM-corruption glitches.** Some original glitches depend on the physical
  32×32 VRAM tilemap and its wrap. Rendering from a flat surface built off the
  block/tile data may not reproduce VRAM-tilemap-corruption effects. We already
  deviate (extended 40×25 viewport, DrawTileBlock clamp), so this is consistent
  with current scope — but note it for the glitch-sandbox work. Keep the GB
  tilemap updates running as the logical model where cheap, so game logic that
  reads them stays faithful.
- **Animated tiles** (water/flower) and script tile changes must mark the
  affected surface region dirty (whole-map option) or be re-decoded into the
  window (torus option). Add a small "surface dirty rect / tile" hook analogous
  to `g_tilecache_dirty`.
- **Extended viewport.** We render 40×25 tiles, wider than the GB's 20×18 and
  wider than the 32-tile torus — the surface approach removes the fragile
  40-into-32 fold, which is a net simplification.
- **Sprites over the extended area** behave as today.

---

## Rollout order (each independently shippable + verifiable)

Progress is tracked step-by-step in **docs/render_opt_handoff.md** (revised each
step).

1. **Palette → raw indices + DAC mapping** (section A). ✅ DONE 2026-06-15 —
   `commit_palette` in video.asm, raw-color PPU output, BGP/cache decoupled. See
   the handoff for details.
2. **Kill the double copy** (section C). ✅ DONE 2026-06-15 — `render_bg`
   assembles directly into the back buffer with inline `SCX&7` clipping;
   `bg_scanline_buf` + the per-line copy removed. Kept the back buffer +
   `present` (fast RAM compositing for window/sprites). See the handoff.
3. **Offscreen surface + viewport blit** (section B, torus option). ✅ DONE
   2026-06-15 — `bg_surface` (256×256) mirrors the decoded BG tilemap torus, kept
   in sync by a per-frame tilemap-vs-shadow diff (`sync_surface_diff`, only
   changed tiles re-decoded) with full rebuild on tile-data/base change;
   `render_bg` blits a 320×200 torus-wrapped window. Decoupled — the faithful
   scroll/RedrawRowOrColumn logic is untouched (we mirror by VRAM tilemap
   address, so the sliding window + edge redraw just works). See the handoff.
4. (Optional, later) Mode X for page-flip / true hardware scroll if still slow on
   the target CPU.

Verify each step with `./test_render.sh` (pixel compare to the known-good Pallet
Town) and, once input automation exists, a four-direction scroll pass. Log frame
timing if a counter is added.
