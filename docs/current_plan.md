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
- [ ] **Stage 2 — `DisplayTextID`** dispatcher (`src/engine/overworld/display_text_id.asm`);
      flat-pointer text path; refactor `CheckNPCInteraction` onto it.
- [ ] **Stage 3 — `TX_START_ASM` (0x08) handler** in `TextCommandProcessor` + `TextScriptEnd`.
- [ ] **Stage 4 — Pallet Town reference** (`PalletTownOakText` event/var-gated `text_asm`).
- [ ] **Stage 5 — `RunMapScript`** dispatch skeleton (no-op default; cutscenes deferred to
      the movement + battle milestone).
- [ ] **Stage 6 — stub conventions** (force-set success flags; record via `stub add`).

## Deferred to the next milestone

Oak walk-up cutscene (needs scripted NPC movement + Pikachu battle stub); per-map
`_Script` state machines beyond the no-op skeleton; the `DisplayTextID` special dict
cases (start menu, mart, pokecenter, PC) — all stubbed and recorded.
