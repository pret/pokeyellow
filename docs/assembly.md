# Build & Assembly Reference

Everything needed to build `PKMN.EXE` and regenerate assets. Keep this in sync
with `dos_port/Makefile` and `dos_port/include/gb_memmap.inc`.

---

## Toolchain

| Tool | Package | Purpose |
|------|---------|---------|
| `nasm` | `nasm` (apt) | Assembles `.asm` → `.o` (COFF format) |
| `i386-pc-msdosdjgpp-ld` | `binutils-djgpp` (apt) | Links `.o` → DJGPP coff-go32-exe |
| `python3` | system | Asset generators (`dos_port/tools/`) |
| `rgbasm` / `rgbgfx` / `rgblink` | **rgbds 1.0.1 — build from source** (not in apt) | Renders `gfx/tilesets/*.png` → `*.2bpp`; required by `gen_all_assets.py` |
| `dosbox-x` | `dosbox-x` (apt on recent Ubuntu) or AUR / source | Testing (must be DOSBox-X, not DOSBox) |
| CWSDPMI.EXE / HDPMI32.EXE | external — **not in repo** | DPMI host; required to **run** `PKMN.EXE`, not to build it |

Install the apt-provided tools on Debian/Ubuntu:
```sh
sudo apt install nasm binutils-djgpp dosbox-x
```

> **Agent note (read before a clean build):** `rgbds` is **not** an apt package —
> it must be built from source pinned to **v1.0.1** (see `.rgbds-version` /
> README). And `PKMN.EXE` is a DJGPP coff-go32 binary that needs a **real-mode
> DPMI host** (CWSDPMI.EXE or HDPMI32.EXE) present in the run directory — the repo
> ships neither, so a fresh checkout can *build* but not *run* until you supply
> one. Full bootstrap below.

NASM flags used: `-f coff -I include/ -I . -O0`  
Linker script: `dos_port/link.ld`

**Critical linker rule:** every input section must appear in `link.ld`'s output
section map. An orphan section gets a VMA but its bytes never reach memory at
runtime — symptoms are a `rep movsb` that copies zeros while `mov [ebp+x], imm`
works fine. All asset data must go in `.data`, not `.rodata`.

---

## Fresh-Clone Bootstrap (build assets from nothing)

A fresh checkout has **no generated assets** and the tileset graphics aren't
committed, so a bare `make` in `dos_port/` fails with `unable to open include
file 'assets/..._gfx.inc'` / `'..._coll.inc'`. Those come from
`gfx/tilesets/*.2bpp`, which only exist after the repo-root (rgbds) build runs.
Do this once, in order:

```sh
# 0. apt tools (see table). rgbds is NOT apt — build v1.0.1 from source:
#    needs: bison flex pkg-config libpng-dev build-essential
sudo apt install -y nasm binutils-djgpp bison flex pkg-config libpng-dev build-essential
# fetch rgbds source v1.0.1 (tarball or git), then:
( cd /path/to/rgbds-1.0.1 && make -j && sudo make install PREFIX=/usr/local )
rgbasm --version          # must report v1.0.1

# 1. Repo ROOT: render tileset PNGs → gfx/tilesets/*.2bpp (rgbgfx).
#    The final ROM link (pokeyellow.gbc) may FAIL on a layout/WRAM-overflow
#    error with this rgbds — that's fine and expected; the *.2bpp graphics
#    we need are produced as intermediates *before* that step.
make                      # ignore the trailing 'Linking failed' for pokeyellow.gbc

# 2. dos_port: generate every assets/*.inc from the .2bpp + map data.
make -C dos_port assets

# 3. dos_port: assemble + link PKMN.EXE.
make -C dos_port
```

After step 3, `PKMN.EXE` exists. To **run** it (e.g. to dump `FRAME.BIN`) you
still need a DPMI host — see "Running headless" below.

### Running headless (CI / agents, no display)

DOSBox-X defaults to an OpenGL output that needs a display; run it under a
virtual framebuffer and force a software output:

```sh
xvfb-run -a dosbox-x -conf dos_port/dosbox-x.conf -defaultdir "$PWD" \
  -set "sdl output=surface"
```

This still requires a **DPMI host** (CWSDPMI.EXE / HDPMI32.EXE) in the mounted
directory next to `PKMN.EXE`; without it the program loads but exits before the
djgpp runtime starts (no `FRAME.BIN` is written). The repo does not ship one —
supply it locally. (The agent proxy blocks `delorie.com`, so CWSDPMI can't be
fetched from its canonical home in a sandboxed session.)

---

## Build Targets

All targets run from `dos_port/`:

| Target | Command | Notes |
|--------|---------|-------|
| Default (build EXE) | `make` | Assembles + links `PKMN.EXE` |
| Regenerate assets | `make assets` | Runs Python generators; see Asset Flags |
| Syntax check only | `make check` | Assembles every source to `/dev/null`, no link |
| Clean objects | `make clean` | Removes `.o` files and `PKMN.EXE` |

Convenience wrappers at repo root / `dos_port/`:
```sh
dos_port/build       # build (passes args to make)
dos_port/run         # build + launch in DOSBox-X
```

---

## NASM Build Flags

Pass as `make FLAG=1` or `make FLAG=value`. All NASM flags are passed via
`-D NAME` or `-D NAME=VALUE`.

### Gameplay flags

| Flag | Default | Effect |
|------|---------|--------|
| `SKIP_TITLE=1` | off | Boot straight to overworld, skipping title screen |
| `BUG_FIX_LEVEL=N` | `0` | `0` = original bugs, `1` = critical fixes only (`/FIXCRIT`), `2` = all fixes (`/FIXALL`) |

### Debug harness flags

These force deterministic execution paths and write output files (`FRAME.BIN` /
`DUMP.BIN`) then exit. All imply `SKIP_TITLE`.

| Flag | Effect | Output |
|------|--------|--------|
| `DEBUG_DUMP=1` | Dump selected GB memory windows to file then exit | `DUMP.BIN` |
| `DEBUG_TRANSITION=1` | Force a north Pallet Town → Route 1 crossing at boot | `FRAME.BIN` |
| `DEBUG_BASELINE=1` | Sub-flag of `DEBUG_TRANSITION`: dump pristine map before crossing | `FRAME.BIN` |
| `DEBUG_WALK_NORTH=1` | Simulate N northward steps then dump frame | `FRAME.BIN` |
| `DEBUG_WALK_STEPS=N` | Number of steps for `DEBUG_WALK_NORTH` (default: 8) | — |
| `DEBUG_NOCLIP=1` | Press **W** in-game to toggle walk-through-walls | — |

`DEBUG_DUMP`, `DEBUG_TRANSITION`, and `DEBUG_WALK_NORTH` also link in
`src/debug/debug_dump.asm`. `DEBUG_NOCLIP` does not imply `SKIP_TITLE`.

Typical debug loop:
```sh
make clean && make SKIP_TITLE=1 DEBUG_TRANSITION=1
dosbox-x -defaultdir "$PWD" -c 'mount c "'"$PWD"'"' -c c: -c PKMN.EXE -c exit
python3 tools/render_frame.py FRAME.BIN /tmp/f.png
```

---

## Asset Flags

Asset `.inc` files in `dos_port/assets/` are **generated** — never hand-edit
them. Fix the generator and re-run `make assets` instead. The `MapHeaderPointers`
table in `map_headers.inc` is computed at generation time; a partial hand-edit
will desync pointer addresses from blob offsets and silently corrupt map loads.

| Flag | Command | Effect |
|------|---------|--------|
| *(none)* | `make assets` | Regenerate all assets; `IF DEF(_DEBUG)` blocks stripped |
| `DEBUG_WARPS=1` | `make assets DEBUG_WARPS=1` | Include `IF DEF(_DEBUG)` warp entries (e.g. REDS_HOUSE_2F teleport warps to late-game maps) |

**Important:** `make` uses file timestamps. Changing `DEBUG_WARPS` between builds
requires an explicit `make assets` (or `touch assets/map_headers.inc`) to force
regeneration — a plain `make` will see the file as up to date.

Generators:

| Script | Produces | Source data |
|--------|----------|-------------|
| `dos_port/tools/gen_all_assets.py` | `overworld_gfx.inc`, `overworld_blocks.inc`, `pallet_town_blk.inc`, all `*_blk.inc` / `*_gfx.inc` / `*_blocks.inc` / `*_coll.inc` | `gfx/tilesets/*.2bpp`, `maps/*.blk` |
| `dos_port/tools/gen_map_headers.py` | `map_headers.inc`, `extra_includes.inc` | `constants/map_constants.asm`, `data/maps/headers/*.asm`, `data/maps/objects/*.asm` |

`gen_all_assets.py` requires the tilesets to have been rendered to `.2bpp` first
(`make` at the repo root with rgbds 1.0.1 installed).

---

## Output Files

| File | Location | Notes |
|------|----------|-------|
| `PKMN.EXE` | `dos_port/` | DOS 8.3 name required for DOSBox-X `-c` invocation |
| `pkmn.map` | `dos_port/` | Linker map — symbol addresses for debugging |
| `FRAME.BIN` | `dos_port/` | Raw 320×200 palette-indexed back-buffer dump; render with `dos_port/tools/render_frame.py` |
| `DUMP.BIN` | `dos_port/` | GB memory window dump from `debug_dump.asm` |

---

## Warp Entry Format

Warp entries in `map_headers.inc` are stored as **Y, X** (not X, Y). This
matches the original GB engine's collision scanner, which indexes by row (Y)
first. The pret `warp_event` macro takes arguments in **X, Y** order but the
emitted bytes — and the DOS port's `map_headers.inc` — are **Y, X, dest_warp_idx,
dest_map_id**. `dest_warp_idx` is `warp_id - 1` (0-based index into the
destination map's warp table).

---

## Single-File Syntax Check

```sh
nasm -f coff -o /dev/null dos_port/src/util/fill_memory.asm
```

---

## DOSBox-X Configuration

The repo ships a tracked config at **`dos_port/dosbox-x.conf`**. The `dos_port/run`
script loads it automatically via `dosbox-x -defaultdir <dos_port/> -conf dosbox-x.conf`.
It overrides the user's system config only for the settings below; everything else
(audio, window size, etc.) falls through to the system config.

```ini
[dosbox]
machine                   = vgaonly        ; Mode 13h plain VGA — required

[video]
memory io optimization 1  = false          ; VGA writes broken if true

[cpu]
cputype                   = 386_prefetch
cycles                    = fixed 23880    ; 386SX ~20 MHz baseline
cycleup                   = 500
cycledown                 = 500

[autoexec]
mount c .                                  ; . = -defaultdir (dos_port/)
c:
PKMN.EXE
```

To run manually without the script:
```sh
dosbox-x -defaultdir "$PWD/dos_port" -conf "$PWD/dos_port/dosbox-x.conf"
```

Must use **DOSBox-X**, not standard DOSBox. Standard DOSBox lacks the debugger
features and accuracy required for this port.
