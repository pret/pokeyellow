# Current Plan: Script Engine — Faithful Translation

Active work item: faithfully translate gen-1's script system (per-map `_Script`
state machines + `_TextPointers` / `text_asm` text scripts, gated on the event-flag
system, dispatched by `DisplayTextID` / `RunMapScript`). Full plan:
`~/.claude/plans/hazy-hopping-puffin.md`.

**Milestone 1 — event-gated dialog foundation.** Actions needing systems not yet
ported (battling, items, party, menus, music) are stubbed and recorded; where an event
must persist past a stubbed set-piece, the stub force-sets the event flag.

## Tracking (the DB is the source of truth)

Use `dos_port/tools/work_queue` (over `translation.db`). The swarm `claim`/`place`
pipeline is for simple mass translation; the script engine is hand-translated by Claude
Code via targeted claims and the `wired`/`verified` transitions:

- `work_queue claim --name DisplayTextID --agent <id>` (or `--id N`) → translate →
  `place --output …` → `wire --id N` → `verify --id N`.
- Per-map scripts are the `script` category (`scripts/*.asm`, indexed by `build_index`).
- Stub deferrals: `work_queue stub add --id N --kind <battle|items|pokemon|party|menu|
  music|sfx|save|misc> --notes "…"`; sweep later with `stub list --kind X --unresolved`.
- `dos_port/tools/gen_progress_report` → `docs/translation_progress.md` (snapshot).
- Translation-log entries: `work_queue translation-log-entry --id N` → `docs/translation_log.md`.
  Header-level work (event macros) is logged in `translation_log.md` directly.

## Stages (see the full plan for detail)

- [x] **Pass 1 — tooling** (claim by id/name, `script` category + migration, `stubs`
      table + subcommands, `gen_progress_report`). Committed.
- [x] **Stage 1 — event-flag system**: `gen_event_constants.py` → `assets/event_constants.inc`;
      `include/events.inc` (`CheckEvent`/`SetEvent`/`ResetEvent`). Assembles.
- [x] **Stage 2+3 — text_asm dispatch** (collapsed): instead of `DisplayTextID` +
      `TX_START_ASM`-in-stream, a map TextTable slot can be a **SCRIPT entry**
      (`dd <routine>, 0xFFFFFFFF`). `CheckNPCInteraction` CALLs the flat `text_asm`
      routine; new shared `ShowTextStream` (copy flat→`NPC_DIALOG_BUF`, `PrintText`,
      wait) serves both scripts and plain text. `gen_npc_dialogs.py` gained a
      `SCRIPT_OVERRIDES` registry. Builds + links; **visual test pending Oak spawn**.
- [x] **Stage 4 — Pallet Town reference** (`src/scripts/pallet_town.asm`): `PalletTownOakText`
      gates on `EVENT_GOT_POKEBALLS_FROM_OAK` (`CheckEvent`) → two branches. Test with
      `DEBUG_OAK_EVENT=1` once Oak is spawn-gated into the map.
- [ ] **Stage 5 — `RunMapScript`** dispatch skeleton (no-op default; cutscenes deferred to
      the movement + battle milestone).
- [ ] **Stage 6 — stub conventions** (force-set success flags; record via `stub add`).
      Started: deferred Oak intro recorded as stubs on `PalletTownOakText` (battle, misc).

## Testing note

Oak does not spawn by default (no intro/spawn-gating yet), so the dialog can't be
reached until Oak is spawned into Pallet Town. To visually test: spawn Oak (debug
spawn flag), then talk to him — default build shows "Hey! Wait!", `DEBUG_OAK_EVENT=1`
(needs `make clean`) shows "That was close!". Plain Girl/Fisher dialog is the
regression check for the refactored `ShowTextStream` path.

## Deferred to the next milestone

Oak walk-up cutscene (needs scripted NPC movement + Pikachu battle stub); per-map
`_Script` state machines beyond the no-op skeleton; the `DisplayTextID` special dict
cases (start menu, mart, pokecenter, PC) — all stubbed and recorded.
