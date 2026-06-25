# Current Plan: Pokémon Data/Stats Engine

The data layer beneath items and battle: party/box data structures, species base
stats, the stat-calculation formula, experience/leveling, and Pokémon
creation/loading. Building it now unblocks **items**, **battle**, and the
**deferred Oak starter-Pikachu gift** in `current_plan_script_engine.md` (which
needs `AddPartyMon`). Sequencing: **Pokémon → items → battle.**

Much of this is already drafted under `dos_port/src/engine/pokemon/` but **none is
wired into the Makefile**, the data tables don't exist, and the drafts use
pret-style lowercase WRAM names (`wPartyCount`) that `gb_memmap.inc` only defines
in UPPERCASE (`W_PARTY_COUNT`).

## Conventions
- Track routines via `dos_port/tools/work_queue` (`claim`/`place`/`wire`/`verify`)
  over `translation.db`; defer UI deps via `stub add --kind pokemon|menu|...`.
- **Naming:** add lowercase pret-name aliases (`wPartyCount equ 0xD162`) so the
  faithful drafts assemble unmodified (CLAUDE.md mandates pret names). Full
  UPPERCASE reconciliation is out of scope.
- Base stats are static data → **generated** by a Python tool from the pret source
  (`gen_base_stats.py`), never hand-authored.

## Stages

- [~] **Stage 1 — Symbol foundations.** (Core done.) Created
  `dos_port/include/gb_constants.inc`
  (struct field offsets `MON_*`, lengths `PARTYMON_STRUCT_LENGTH=44`/
  `BOXMON_STRUCT_LENGTH=33`/`BASE_DATA_SIZE=28`, data-location + growth-rate
  constants — from `constants/pokemon_data_constants.asm`). Add ~25 lowercase
  Pokémon WRAM aliases to `gb_memmap.inc` (`wParty*`, enemy/box/daycare,
  `wMonHeader`+fields, `wLoadedMon`+fields, `wPokedexNum`, lowercase aliases of
  existing `W_*`). Addresses verified vs. `ram/wram.asm` / `pokeyellow.sym`.
  DONE: `gb_constants.inc`, the verified-safe `wMonHeader` region + party +
  `CalcStats` inputs in `gb_memmap.inc`, and corrected `W_MON_H_GROWTH_RATE`
  ($D0CA→$D0CB off-by-one). DEFERRED to Stage 5 (need a `pokeyellow.sym`): the
  cross-section loaded/enemy/box/daycare aliases.

- [x] **Stage 2 — Data tables.** DONE. Hand-translated `GrowthRateTable` →
  `assets/growth_rates.inc`; wrote `tools/gen_base_stats.py` →
  `assets/base_stats.inc` (`BaseStats` 151×28 dex-order + `IndexToPokedex` 190B),
  validated vs. canonical values (Bulbasaur/Pikachu/Mewtwo/Mew); `src/data/
  pokemon_data.asm` exposes the globals; wired into Makefile (`POKEMON_SRCS` +
  `assets` target); full project builds + links. (TM/HM bitfield zeroed → Stage 6.)

- [ ] **Stage 3 — Core formula.** Write `GetMonHeader` (new
  `dos_port/src/home/pokemon.asm`, from `home/pokemon.asm:403`) and `CalcStat` +
  `CalcStats` (new `dos_port/src/home/move_mon.asm`, from `home/move_mon.asm:34`).
  Depends only on already-ported `Multiply`/`Divide`/`AddNTimes` + HRAM scratch.
  Wire `src/home/pokemon.asm`, `src/home/move_mon.asm`, `src/home/math.asm`,
  `src/engine/math/multiply_divide.asm` + new asset includes into the Makefile
  `ALL_SRCS`.

- [ ] **Stage 4 — Verify CalcStats (milestone gate).** `DEBUG_CALCSTATS` harness
  seeds a known case (Bulbasaur L5, DVs=15, 0 stat-exp; + a stat-exp case), runs
  `CalcStats`, dumps the 5 stats to `DUMP.BIN`; compare against canonical Gen-1
  values on the host. No renderer in the loop.

- [ ] **Stage 5 — Creation / loading (unblocks Oak gift).** Write `_AddPartyMon`
  (`src/engine/pokemon/add_mon.asm`, from `engine/pokemon/add_mon.asm:1`; stub
  `AskName`/Pokédex). Fix + wire the drafted `load_mon_data.asm`,
  `experience.asm`, `set_types.asm`, `remove_mon.asm`. Verify: add a known mon,
  dump its party_struct.

- [ ] **Stage 6 — Evolution / learnset / PC.** Generate `EvosMovesPointerTable` +
  `MonsterNames`; wire `evos_moves.asm` (`WriteMonMoves`/`GetMonLearnset` needed by
  `_AddPartyMon`; stub evolution/rename UI) and `bills_pc.asm`.

## What exists vs. needs writing (from exploration)
- **Exists (drafted, unwired):** `experience.asm`, `set_types.asm`,
  `remove_mon.asm`, `add_mon.asm` (partial — `_AddPartyMon` missing),
  `load_mon_data.asm` (broken include), `evos_moves.asm`, `bills_pc.asm`;
  `_Multiply`/`_Divide`, `Multiply`/`Divide`, `AddNTimes`.
- **Missing (must write):** `CalcStats`/`CalcStat`, `GetMonHeader`, `_AddPartyMon`,
  `BaseStats`/`GrowthRateTable`/`EvosMovesPointerTable`/`MonsterNames` data,
  `gb_constants.inc`, ~25 WRAM aliases. **No pokemon/battle/math file is in the
  Makefile build yet.**
