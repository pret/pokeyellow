# Handoff — faithful LoadMapHeader + map transitions

Status: **planned, not started** (2026-06-15). For a fresh session. This is the
"rest of the overworld map + transitions" work. The user chose the **faithful
`LoadMapHeader`** path (real ROM map-header format) over a hardcoded dispatcher.

Cross-refs: CLAUDE.md (faithfulness conventions), docs/session_handoff.md (open
problems), docs/render_opt_handoff.md (renderer is done + decoupled — see
"Renderer impact" below). pret source is the repo root (read-only spec).

---

## Goal

Make Pallet Town ↔ Route 1 ↔ Route 21 actually walkable: when the player walks
off a map edge into a connection, the game switches `wCurMap`, loads the new
map's header faithfully, and continues — the real Gen 1 behavior. Build it as
real infrastructure (faithful `LoadMapHeader`), not a per-map hardcode, so future
maps drop in by adding data.

---

## Current state (what exists)

- **Connection STRIPS already load** (done 2026-06-15, see translation_log.md):
  `LoadTileBlockMap` calls translated `LoadNorthSouthConnectionsTileMap` /
  `LoadEastWestConnectionsTileMap`; the 3-block border of `wOverworldMap` is
  filled from the connected map's edge. **But** the connection-struct fields are
  currently set by the **`SetupPalletTown` scaffold** with precomputed constants
  (NORTH_STRIP_SRC etc. in src/overworld/overworld.asm), and Route1/Route21
  `.blk` are copied to `OW_ROUTE1_BLK_GBADDR` ($5000) / `OW_ROUTE21_BLK_GBADDR`
  ($5200). This scaffold is what LoadMapHeader must REPLACE.
- **Map setup is the `SetupPalletTown` scaffold** (src/overworld/overworld.asm):
  hardcodes wCurMap, dims, tileset pointers, border block, connections, player
  start (center, wYCoord=wXCoord=8 — deliberately away from edges), and copies
  all assets to the ROM window. `LoadMapData` calls
  DisableLCD → ResetMapVariables → LoadTextBoxTilePatterns → LoadScreenRelatedData
  (= LoadTileBlockMap + LoadTilesetTilePatternData + LoadCurrentMapView) →
  CopyMapViewToVRAM. `LoadMapHeader` is explicitly skipped ("setup done by
  SetupPalletTown scaffold").
- **Renderer impact: NONE.** The Tier-2 surface renderer (render_bg) mirrors the
  VRAM tilemap via a per-frame diff and is fully decoupled — when LoadTileBlockMap
  / CopyMapViewToVRAM rewrite the map, the surface picks it up automatically. No
  renderer changes are needed for transitions.
- `wYCoord`/`wXCoord` are committed by `AdvancePlayerSprite` (W_Y_COORD/W_X_COORD
  += step vector at end of a step). Player can in principle reach the edge values.

---

## The map-header binary format (what to embed + parse)

From `macros/scripts/maps.asm`:

`map_header` emits the **fixed header** (copied to `wCurMapHeader`):
```
db tileset_id
db height, width            ; in 4x4-tile blocks
dw Blocks                   ; -> map .blk data
dw TextPointers
dw Script
db connections              ; NORTH|SOUTH|WEST|EAST bits (8/4/2/1)
```
Then, **in order N,S,W,E for each set connection bit**, an 11-byte
`map_connection_struct` (see macros/ram.asm):
```
db ConnectedMap
dw ConnectionStripSrc       ; into connected map's Blocks
dw ConnectionStripDest      ; into wOverworldMap border
db ConnectionStripLength
db ConnectedMapWidth
db ConnectedMapYAlignment
db ConnectedMapXAlignment
dw ConnectedMapViewPointer  ; into wOverworldMap
```
Then `end_map_header` emits `dw <Map>_Object`.

**Object data** (`data/maps/objects/<Map>.asm`, pointed to by the `dw Object`):
```
db border_block
def_warp_events  -> N warps;  each warp_event = db y,x,destWarpID,destMap (4 bytes, preceded by count)
def_bg_events    -> N signs;  each = db y,x,textID (3 bytes, preceded by count)
def_object_events-> N sprites; each = picture/movement/etc (see object_event macro), preceded by count
def_warps_to     -> warp-to data (for arriving)
```

Pallet Town examples (already read):
- header: `map_header PalletTown, PALLET_TOWN, OVERWORLD, NORTH | SOUTH` +
  `connection north, Route1, ROUTE_1, 0` + `connection south, Route21, ROUTE_21, 0`.
- object: border `$0b`; 3 warps; 4 signs; 3 objects (Oak/Girl/Fisher).

Map dims (constants/map_constants.asm): PALLET_TOWN 10×9, ROUTE_1 10×18,
ROUTE_21 10×45. Connection bits (map_data_constants.asm): EAST=1,WEST=2,SOUTH=4,
NORTH=8.

---

## What `LoadMapHeader` does (home/overworld.asm:1793, enumerate to translate)

1. (skip MarkTownVisited / toggleable objects — defer/stub)
2. `SwitchToMapRomBank` — **no-op in flat model**.
3. tileset bookkeeping (wUnusedCurMapTilesetCopy, hPreviousTileset, the
   NO_PREVIOUS_MAP bit) — mostly bookkeeping; keep minimal.
4. `GetMapHeaderPointer` — `MapHeaderPointers[wCurMap]` (+bank). **We need a flat
   table** mapping map id → flat addr of that map's embedded header.
5. Copy fixed header → `wCurMapHeader` (`wCurMapHeaderEnd - wCurMapHeader` bytes).
6. Init all 4 wXxxConnectedMap = $FF, then `CopyMapConnectionHeader` (11 bytes
   each) for each connection bit set, into wNorth/South/West/EastConnectionHeader.
7. Read object-data pointer (2 bytes), then parse object data: border block →
   wMapBackgroundTile, warps (→wNumberOfWarps + wWarpEntries), signs
   (CopySignData), sprites (InitSprites). Several of these can be **stubbed**
   initially (see "scope" below).
8. `predef LoadTilesetHeader` — loads the tileset's gfx/block/coll pointers +
   grass tile + counts into wTileset* from a tileset-header table. We currently
   set wTilesetGfxPtr/BlocksPtr/CollisionPtr by hand in the scaffold; this must
   become the faithful LoadTilesetHeader reading an embedded OVERWORLD tileset
   header.
9. `wCurrentMapHeight2 = wCurMapHeight*2`, `wCurrentMapWidth2 = wCurMapWidth*2`
   (the east/south edge thresholds CheckMapConnections compares against).
10. music setup (defer — audio is Phase 3).

---

## Transition flow (home/overworld.asm) — `CheckMapConnections` (~line 525)

Reached after a step via `CheckWarpsNoCollision` (line 360): if no warp matches,
`jp CheckMapConnections`. Logic per direction:
- **West:** `wXCoord == $FF`? → wCurMap = wWestConnectedMap; wXCoord =
  WestXAlignment; wYCoord += WestYAlignment; view ptr = WestViewPointer adjusted
  by (wYCoord>>1) rows of (WestConnectedMapWidth + 2*MAP_BORDER); → `.loadNewMap`.
- **East:** `wXCoord == wCurrentMapWidth2`? → analogous with East fields.
- **North:** `wYCoord == $FF`? → wCurMap = wNorthConnectedMap; wYCoord =
  NorthYAlignment; wXCoord += NorthXAlignment; view ptr = NorthViewPointer +
  (wXCoord>>1); → `.loadNewMap`.
- **South:** `wYCoord == wCurrentMapHeight2`? → analogous with South fields.
- else `.didNotEnterConnectedMap` → `jp OverworldLoop`.

`.loadNewMap`: (pikachu flags — skip) → **`LoadMapHeader`** →
PlayDefaultMusicFadeOutCurrent (skip) → RunPaletteCommand SET_PAL_OVERWORLD
(skip/Phase 5) → `InitMapSprites` (sprite VRAM slots — can keep NPC scaffold or
stub) → **`LoadTileBlockMap`** → `jp OverworldLoopLessDelay`.

(Note: after LoadTileBlockMap the view must be rebuilt — pret relies on the
subsequent loop + RedrawRowOrColumn; verify our LoadCurrentMapView +
CopyMapViewToVRAM are invoked so the surface repopulates. May need to call
LoadCurrentMapView + CopyMapViewToVRAM in .loadNewMap like LoadMapData does.)

---

## THE KEY DESIGN CHALLENGE — pointer relocation

The embedded map headers' pointers (`Blocks`, `Object`, and every connection
`StripSrc`/`StripDest`/`ViewPointer`) are **GB-absolute addresses from the
original ROM/WRAM layout**. Our flat port puts map data at different ROM-window
addresses (OW_*_GBADDR) and wOverworldMap at $E580 (not the GB $C6E8). So the
embedded pointers will be wrong unless handled. Two options:

- **(Recommended) Asset-gen relocation:** extend `tools/gen_overworld_assets.py`
  (or a new tool) to emit each map's header bytes WITH our addresses substituted:
  Blocks → OW_<MAP>_BLK_GBADDR, Object → our object-data addr, and recompute the
  connection struct pointers (StripSrc = our connected-map blocks + _blk;
  StripDest/ViewPointer = W_OVERWORLD_MAP + offset) using the same formulas as the
  pret `connection` macro (macros/scripts/maps.asm — already decoded in
  src/overworld/overworld.asm's NORTH_*/SOUTH_* constant comments). Then
  LoadMapHeader parses them faithfully with no runtime fixup.
- **(Alt) Runtime fixup:** parse the original pointers and relocate in
  LoadMapHeader. More runtime code, more error-prone.

Either way, you need a **memory map** for the embedded data of all three maps:
headers, object data, and blocks at distinct ROM-window addresses (extend the
OW_*_GBADDR block; there's free space above $5400). Define a `MapHeaderPointers`
flat table (map id → header addr) for at least PALLET_TOWN(00), ROUTE_1(0C),
ROUTE_21(20).

---

## Suggested phased plan (keep the per-step-handoff cadence)

**Step A — data infra:** decide the ROM-window memory map for 3 maps' headers +
object data + blocks; build the asset-gen that emits relocated header/object
binaries + a MapHeaderPointers table; embed OVERWORLD tileset header data. Verify
by DEBUG_DUMP that the embedded header bytes + relocated pointers are correct.

**Step B — LoadMapHeader + LoadTilesetHeader + CopyMapConnectionHeader:**
translate them; add the `wCurMapHeader`/connection-header WRAM region +
wCurrentMapWidth2/Height2 to gb_memmap.inc (see addresses below). Replace the
`SetupPalletTown` scaffold: `EnterMap` sets wCurMap = PALLET_TOWN and calls
LoadMapHeader; LoadMapData stops skipping it. Stub deferrable parts (warps/signs/
wild/music/palette) with clear `; TODO` markers. Verify Pallet Town still boots
identically (DEBUG_DUMP header + render).

**Step C — CheckMapConnections + overworld wiring:** translate
CheckMapConnections; wire the post-step warp/connection check into OverworldLoop
(pret does CheckWarpsNoCollision→CheckMapConnections after a completed step);
ensure the player can reach the edge (collision + coord commit). `.loadNewMap`
calls LoadMapHeader + LoadTileBlockMap + LoadCurrentMapView + CopyMapViewToVRAM.
Verify by walking north into Route 1 and south into Route 21 (user-driven; or
DEBUG_DUMP wCurMap + wOverworldMap after a scripted edge cross).

**Step D — polish:** Route 1's own north (Viridian) / Route 21's south
(Cinnabar) stay $FF until those maps are added; the DrawTileBlock clamp stays
until all reachable regions have data. Update docs + handoffs.

---

## WRAM addresses (verify/add in dos_port/include/gb_memmap.inc)

Already present: W_CUR_MAP (0xD35E? check), W_CUR_MAP_TILESET, W_CUR_MAP_HEIGHT,
W_CUR_MAP_WIDTH, W_CUR_MAP_DATA_PTR (0xD369), W_CUR_MAP_CONNECTIONS (0xD36F),
W_{NORTH,SOUTH,WEST,EAST}_CONNECTED_MAP (0xD370/7B/86/91, 11-byte structs),
W_OBJECT_DATA_PTR_TEMP (0xD3A8), W_MAP_BACKGROUND_TILE (0xD3AC),
W_NUMBER_OF_WARPS (0xD3AD), W_WARP_ENTRIES (0xD3AE), W_CURRENT_TILE_BLOCK_MAP_VIEW_PTR
(0xD35E? check — comment says 0xD35E), W_Y_COORD (0xD360), W_X_COORD (0xD361),
CONN_* struct field offsets (added 2026-06-15).

**Need to add (check pret ram/wram.asm for exact addresses):**
- `wCurMapHeader` region + `wCurMapHeaderEnd` (the fixed-header copy target). In
  pret it's the block starting at wCurMapTileset through the connections byte;
  our W_CUR_MAP_* vars ARE that region — confirm they're contiguous & ordered to
  match the header byte layout, or define a dedicated copy buffer.
- `wCurrentMapHeight2` / `wCurrentMapWidth2` (ram/wram.asm:2108/2111).
- `wNumSigns`, sign/sprite data regions (if not stubbing).
- The connection-header sub-fields are the CONN_* offsets already defined.

NOTE: our W_CUR_MAP_* layout was hand-assigned and may NOT be byte-contiguous in
header order. LoadMapHeader copies a contiguous header blob — either (a) make the
WRAM vars contiguous in the right order, or (b) copy into a dedicated wCurMapHeader
buffer and have the code read fields from there. Decide early in Step B.

---

## Gotchas / faithfulness notes

- SwitchToMapRomBank, hLoadedROMBank, BANK() → no-ops in the flat model.
- Keep `; TODO-HW:` for music/palette; `; TODO:` for deferred warp/sign/sprite
  parsing. Don't block the transition milestone on them.
- The connection-struct precomputed constants currently in overworld.asm
  (NORTH_STRIP_SRC etc.) become DEAD once headers are embedded+parsed — delete
  them with the SetupPalletTown scaffold, but keep their derivation comments
  (they document the `connection` macro math) somewhere.
- DrawTileBlock out-of-range clamp: still needed (E/W borders, past-map-end).
- Verify via DEBUG_DUMP (src/debug/debug_dump.asm — edit the `windows` table),
  not screenshots, per project debugging policy. Build: `make SKIP_TITLE=1 DEBUG_DUMP=1`.
- Renderer needs no changes (surface mirror is decoupled).

---

## Key references

- pret: `home/overworld.asm` — LoadMapHeader (1793), CheckMapConnections (525),
  CheckWarpsNoCollision (360), LoadNorth/SouthConnectionsTileMap, LoadTileBlockMap.
- pret macros: `macros/scripts/maps.asm` (map_header/connection/object_event),
  `macros/ram.asm` (map_connection_struct).
- pret data: `data/maps/headers/{PalletTown,Route1,Route21}.asm`,
  `data/maps/objects/*.asm`, `data/maps/map_header_pointers.asm`,
  `constants/map_constants.asm`, `constants/map_data_constants.asm`.
- ours: `src/overworld/overworld.asm` (SetupPalletTown scaffold, LoadMapData,
  LoadTileBlockMap + connection loaders, AdvancePlayerSprite coord commit,
  OverworldLoop), `tools/gen_overworld_assets.py`, `dos_port/assets/*.inc`,
  `dos_port/include/gb_memmap.inc`.
