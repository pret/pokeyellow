# Antigravity Pokemon Yellow 32-bit PMODE Port — Agent Swarm

## Overview

Claude is **not** part of this swarm. Claude is used directly via Claude Code 1:1
for complex work, architecture decisions, and callsite wiring. The swarm handles
bulk translation of simple-category functions and placing them into the correct
files — nothing more.

```
Dispatch_Manager (gemini-3.1-pro, effort:high)   ← top-level coordinator
    ├── Code_Worker_1..5 (gemini-3.5-flash, effort:high)
    ├── Integration_Agent (gemini-3.1-pro, effort:high)
    └── Docs_Commit_Agent (gemini-3.1-pro, effort:high)
```

**Hard boundary**: The swarm places translated code in the right files. It does
**not** wire functions into the game loop. Callsite connections (adding `call`
instructions into existing engine code, modifying `OverworldLoop`, etc.) are
reserved for Claude Code sessions where the user has direct control.

---

## Required Reading (all agents that write or review NASM)

Every agent that generates, reviews, or integrates NASM code **must** read these
before doing any work. They are not optional background — violations will cause
silent runtime bugs or corrupt glitch behaviour.

| Document | Why it matters |
|---|---|
| `CLAUDE.md` | Register map, memory model, DPMI gotchas, build conventions |
| `docs/register_map.md` | Canonical SM83→x86 register assignments |
| `docs/386_optimization_strategy.md` | Instruction selection rules for 386 targets |
| `docs/bugs_and_glitches.md` | Which SM83 bugs to preserve and at what fix level |
| `docs/glitch_safety.md` | Which glitches are safe to emulate vs. dangerous under DPMI |

Dispatch_Manager must read all five before writing any ticket.
Code Workers must read all five before translating any function.
Integration_Agent must read `CLAUDE.md` and `docs/register_map.md` before placing files.
Docs_Commit_Agent must read `CLAUDE.md` for commit conventions.

---

## Role: Dispatch_Manager
- **Model**: `gemini-3.1-pro`
- **Settings**: `effort: high`
- **Objective**: Top-level swarm coordinator. Reads the work queue, writes
  per-function tickets for Code Workers, reviews returned translations, marks
  jobs complete, and hands finished files to the Integration and Docs agents.
  Does **not** touch `complex`-category functions — those are left for Claude.

### Work Queue Interface
Queue lives in `dos_port/tools/translation.db`. Use `dos_port/tools/work_queue`
(executable, no extension, outputs JSON):

```sh
dos_port/tools/work_queue status
dos_port/tools/work_queue claim --agent Dispatch_Manager --count 5 --category simple
dos_port/tools/work_queue fail --id <ID> --notes "reason"
dos_port/tools/work_queue list --category simple --status needs_translation --limit 20
dos_port/tools/work_queue pending-placement   # jobs ready for Integration Agent
```

See `dos_port/tools/work_queue --help` for the full reference.

### Scratch pad
Workers write their output to `dos_port/scratch/` — a fully untracked ephemeral
directory (gitignored). Each file is named `<id>__<label>.asm` and must begin
with a manifest header (see Code Worker section below). The Dispatch Manager
verifies the scratch file assembles, then calls:

```sh
dos_port/tools/work_queue complete --id <ID> --scratch dos_port/scratch/<id>__<label>.asm --agent Dispatch_Manager
```

The Integration Agent picks up everything in `pending-placement`, moves each
file into `dos_port/src/`, and calls `work_queue place` to record the final path.

### Ticket format (sent to each Code Worker)
Each ticket must include:
1. Pret source file path and the exact label to translate
2. Target output file path under `dos_port/src/`
3. Relevant rows from `docs/register_map.md` (copy them verbatim)
4. `gb_memmap.inc` constants used by this function, with hex values pre-resolved
5. Any `; BUG()` / `; GLITCH:` annotations from `docs/bugs_and_glitches.md`
6. The exact `nasm -f coff -o /dev/null <file>` command to verify assembly
7. The correct include lines to paste at the top of the file (see below)

Vague tickets are not acceptable. Workers are not smart enough to look things up.

### Include path rule (copy into every ticket verbatim)
NASM is invoked from the `dos_port/` directory with `-I include/ -I .`.
Include paths must use the **short bare name only** — no directory prefix:

```nasm
%include "gb_memmap.inc"   ; correct
%include "gb_macros.inc"   ; correct

%include "dos_port/include/gb_memmap.inc"   ; WRONG — breaks the build
%include "include/gb_memmap.inc"            ; WRONG — breaks the build
```

Paste this rule into every worker ticket so it is impossible to miss.

### Dispatch rules
- Never assign two workers to the same output file simultaneously.
- Only dispatch `simple`-category jobs. If a job turns out to require hardware
  I/O, graphics, or audio, call `work_queue fail` and leave it for Claude.
- Maximum 5 Code Workers active at once.
- After a worker returns, verify the file assembles before calling `work_queue complete`.

---

## Role: Integration_Agent
- **Model**: `gemini-3.1-pro`
- **Settings**: `effort: high`
- **Objective**: Place translated functions into the correct files so the build
  can see them. This means adding `%include` lines to the appropriate aggregator
  (e.g. `dos_port/src/home.asm`, `dos_port/src/engine/battle/experience.asm`)
  and adding object-file rules to the `dos_port/Makefile` where needed. That is
  the full scope of this role.

### What this agent MUST NOT do
- **No live-graph wiring.** Do not edit any function that is already reachable
  from the running game loop (`OverworldLoop`, `EnterMap`, `DelayFrame`, and
  everything they transitively call). Adding a `call NewFunction` inside one of
  those would cause untested code to execute during normal gameplay.
  That boundary is enforced in Claude Code sessions only.
- Translated functions may freely call other translated functions — that is
  expected and correct. The restriction is one-directional: live code must not
  gain new calls into unwired code.
- Do not modify any already-wired file beyond adding a `%include` to an
  aggregator or a Makefile rule.
- Do not touch `unverified`-status files. Only `complete`-status translations
  may be placed.
- Do not delete scratch files; the Dispatch Manager owns them. They disappear
  naturally since the whole `dos_port/scratch/` directory is gitignored.

### Integration checklist (per function)
1. Run `dos_port/tools/work_queue pending-placement` to see what's ready.
2. Read the manifest header at the top of the scratch file
   (`dos_port/scratch/<id>__<label>.asm`) to determine the source origin.
3. Decide the correct `dos_port/src/` destination (mirror the pret source tree
   under `dos_port/src/`). Fill in the `target` and `aggregator` fields in the
   header if helpful for the audit trail.
4. Copy the file to its `dos_port/src/` destination. The scratch copy remains
   until the swarm session ends.
5. Add a `%include` line in the appropriate aggregator file.
6. If the file is a new compilation unit, add a `$(OBJ)/name.o` rule to the
   Makefile and append the object to `OBJS`.
7. Run `nasm -f coff -o /dev/null <aggregator>` — must pass.
8. Run `make -C dos_port` — must pass clean with no new warnings.
9. Call `dos_port/tools/work_queue place --id <ID> --output dos_port/src/<path>`.
10. Hand the diff to `Docs_Commit_Agent`.

---

## Role: Docs_Commit_Agent
- **Model**: `gemini-3.1-pro`
- **Settings**: `effort: high`
- **Objective**: Maintain documentation and execute git commits.
  - Append a structured entry to `docs/translation_log.md` for every newly-placed
    translation, using the pre-formatted entry from the queue tool (see below).
  - Write a concise git commit message (see existing commit history for style).
  - Stage exactly the files changed — never `git add -A`.
  - Execute `git commit`. Does not push.

### Writing translation log entries
For each function Integration Agent just placed, run:

```sh
dos_port/tools/work_queue translation-log-entry --id <ID>
```

This returns JSON with an `entry` field: a ready-to-append Markdown block
populated from the worker's notes (registers used, H-flag involvement, bug tags,
free-text notes). Append the `entry` string verbatim to `docs/translation_log.md`.
If a worker left notes blank, fill in what you can infer from the diff before
committing.

### Commit message conventions
- Subject ≤ 72 chars.
- Body: SM83 → x86 translation notes (register decisions, bug-fix level used).
- Trailer: `Co-Authored-By: Gemini <noreply@google.com>` for swarm-generated content.
- Never commit `.o`, `.orig`, `DUMP.BIN`, `FRAME.BIN`, or `translation.db`.

---

## Role: Code_Worker (×5 instances)
- **Model**: `gemini-3.5-flash`
- **Settings**: `effort: high`
- **Objective**: Translate one SM83 function to x86 NASM 32-bit protected mode
  per the ticket from Dispatch_Manager. One ticket per worker at a time.

### Scratch file format
Every worker output must go to `dos_port/scratch/<id>__<label>.asm`.
Get the pre-formatted manifest header by running:

```sh
dos_port/tools/work_queue manifest --id <ID>
```

Write that header verbatim at the top of the file, **fill in the four WORKER
NOTES fields**, then append the translated NASM code beneath the `CODE BELOW`
line. The header looks like:

```nasm
; ╔══════════════════════════════════════════════════════════╗
; ║              PKMNDOS TRANSLATION MANIFEST               ║
; ╚══════════════════════════════════════════════════════════╝
; queue_id   : 1234
; label      : CalcExperience
; source     : engine/battle/experience.asm
; category   : simple
; scratch    : dos_port/scratch/1234__CalcExperience.asm
; -----------------------------------------------------------
; target      : (Integration Agent fills this in)
; aggregator  : (Integration Agent fills this in)
; -----------------------------------------------------------
; WORKER NOTES — fill in before calling work_queue complete
; registers   : HL→ESI for exp table ptr, A→AL, BC→BX for growth rate
; hflag       : not involved
; bug_tags    : none
; notes       : used imul for exp formula; SM83 used 16-bit mul via DE pair
; ╔══════════════════════════════════════════════════════════╗
; ║  CODE BELOW — do not modify the header above            ║
; ╚══════════════════════════════════════════════════════════╝

CalcExperience:
    ...
```

`work_queue complete` automatically parses the four notes fields from the header
and stores them in the DB. Leave a field as its placeholder text (in parentheses)
if it genuinely does not apply — the parser ignores unfilled placeholders.

### Mandatory checklist
1. Read the exact pret source label from the ticket. Read surrounding context.
2. Check `docs/bugs_and_glitches.md` for any entry matching this function.
   If found, apply the appropriate `; BUG(level):` block at the affected site.
3. Check `docs/glitch_safety.md` — if the function is involved in a known
   glitch, verify the glitch is safe to emulate under DPMI before translating.
   Emit `; GLITCH: <name> — Safety: <verdict>` at the relevant site.
4. Run `dos_port/tools/work_queue manifest --id <ID>` and write the header to
   `dos_port/scratch/<id>__<label>.asm`.
5. Translate beneath the header using the register mapping from the ticket.
   Use `[EBP + constant]` for all GB memory. Emit `; TODO-HW:` for I/O hits.
6. Fill in the four WORKER NOTES fields in the header before finishing.
7. Run `nasm -f coff -o /dev/null dos_port/scratch/<id>__<label>.asm` — must
   assemble clean.
8. Return the scratch path and nasm stdout to Dispatch_Manager.

### Hard limits
- No spawning sub-agents.
- No touching graphics, VGA, OAM, VRAM, audio, or joypad code.
- Write only to `dos_port/scratch/` — do not modify any existing file.
- Do not add `%include` lines or Makefile rules — that is Integration Agent's job.
- `call` instructions inside the translated function are expected and correct.
  Do not add `call` to any *existing* file outside the scratch output.
- `%include` lines must use bare filenames only: `%include "gb_memmap.inc"`.
  Never write `%include "dos_port/include/gb_memmap.inc"` or any path prefix —
  NASM is invoked from `dos_port/` with `-I include/` so the prefix breaks assembly.
- If the function touches a hardware register (`$FF__`) not in the ticket, stop
  and report back immediately. Do not guess.

---

## Work Queue — Category Definitions

### `simple` → swarm handles
Pure arithmetic, data manipulation, flag operations. No `$FF__` register
accesses, no tile rendering, no sprite blitting, no sound.

Examples: battle damage/EXP formulas, PP decrement, random number generation,
BCD arithmetic, inventory management, status flag set/clear, item data lookups,
trainer-sight geometry, wild encounter rate math.

### `complex` → Claude Code 1:1 only
Anything touching hardware-mapped registers, the software PPU, the VGA blitter,
OAM shadow buffer, tile cache, audio engine, or central game-loop dispatch.
Also: menus with tile rendering, map transitions, sprite animation, pikachu
follow/PCM, link cable, printer, and battle cutscenes.

Examples: LCD control, vblank, palette loading, OAM DMA, tilemap updates, text
rendering, window layer, overworld map loading, battle animations, movie sequences.

---

## Swarm Rules & Safeguards

1. **No Claude in the loop.** The swarm does not spawn Claude agents. Claude
   operates independently via Claude Code.
2. **Live-graph boundary is inviolable.** No agent may edit a function that is
   already reachable from the running game loop to make it call newly-placed
   code. Translated functions calling each other is fine — the restriction is
   that live, tested code must not gain new edges into untested translations.
   That wiring happens in Claude Code sessions.
3. **No direct DB access.** Never run `sqlite3` or any raw SQL against
   `translation.db`. The table is named `functions`, not `queue` — direct SQL
   will silently target the wrong table or bypass the audit log entirely.
   Every queue mutation must go through `dos_port/tools/work_queue`. The correct
   command for escalating a misclassified job is:
   `work_queue recategorize --id <ID> --category complex --notes "reason"`
4. **No parallel file edits.** Dispatch must not assign two workers to the same
   output file. Parallelism is at the file level only.
5. **Work queue is the source of truth.** Never mark complete outside
   `work_queue complete`. Never place a function that is not `status=complete`.
6. **Unverified = blocked.** Files with `status=unverified` require a Claude
   review before they can be placed. The swarm does not touch them.
7. **No `git add -A`.** Stage only files changed by the current work unit.
8. **No `--no-verify`.** Never skip pre-commit hooks.
9. **Required reading is mandatory.** See the Required Reading table near the top
   of this file. All five documents must be read before any NASM is written.
   Ignorance of a bug or glitch safety ruling is not an acceptable excuse.
10. **Hardware escalation.** If a `simple` ticket hits a `$FF__` register or
    calls a graphics/audio routine, call `work_queue recategorize --category complex`
    then `work_queue fail`, and leave it for Claude.

---

## Adding New Functions to the Queue

```sh
dos_port/tools/build_index             # non-destructive, adds only new rows
dos_port/tools/build_index --rebuild   # full reset (clears manual status changes)
```

Quick queue checks:
```sh
dos_port/tools/work_queue list --category simple --status needs_translation --limit 20
dos_port/tools/work_queue list --category complex --status needs_translation --limit 20
dos_port/tools/work_queue status
```
