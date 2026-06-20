# Antigravity Pokemon Yellow 32-bit PMODE Port — Agent Swarm

## Overview

Claude is **not** part of this swarm. Claude is used directly via Claude Code 1:1
for complex work, architecture decisions, and callsite wiring. The swarm handles
bulk translation of simple-category functions and placing them into the correct
files — nothing more.

```
Dispatch_Manager (gemini-3.1-pro, effort:high)   ← top-level coordinator
    ├── Code_Worker_1..5 (gemini-2.5-flash, effort:high)
    ├── Integration_Agent (gemini-3.1-pro, effort:high)
    └── Docs_Commit_Agent (gemini-3.1-pro, effort:high)
```

**Hard boundary**: The swarm places translated code in the right files. It does
**not** wire functions into the game loop. Callsite connections (adding `call`
instructions into existing engine code, modifying `OverworldLoop`, etc.) are
reserved for Claude Code sessions where the user has direct control.

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
dos_port/tools/work_queue complete --id <ID> --output dos_port/src/<path> --agent Dispatch_Manager
dos_port/tools/work_queue fail --id <ID> --notes "reason"
dos_port/tools/work_queue list --category simple --status needs_translation --limit 20
```

See `dos_port/tools/work_queue --help` for the full reference.

### Ticket format (sent to each Code Worker)
Each ticket must include:
1. Pret source file path and the exact label to translate
2. Target output file path under `dos_port/src/`
3. Relevant rows from `docs/register_map.md` (copy them verbatim)
4. `gb_memmap.inc` constants used by this function, with hex values pre-resolved
5. Any `; BUG()` / `; GLITCH:` annotations from `docs/bugs_and_glitches.md`
6. The exact `nasm -f coff -o /dev/null <file>` command to verify assembly

Vague tickets are not acceptable. Workers are not smart enough to look things up.

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
- **No callsite wiring.** Do not add `call FunctionName` anywhere in existing
  engine code. Do not modify `OverworldLoop`, `EnterMap`, `DelayFrame`, or any
  other active game-loop entry point. Callsite connections are done later in a
  Claude Code session.
- Do not modify any file that already has code in it beyond adding a `%include`
  to an aggregator or a rule to the Makefile.
- Do not touch `unverified`-status files. Only `complete`-status translations
  may be placed.

### Integration checklist (per file)
1. Confirm `status = 'complete'` in the work queue for the function.
2. Identify the correct aggregator for the output file's subdirectory.
3. Add the `%include` line. Confirm `nasm -f coff -o /dev/null <aggregator>` passes.
4. If the output file is a new compilation unit, add a `$(OBJ)/name.o` rule to
   the Makefile and add the object to the `OBJS` list.
5. Run `make -C dos_port` — must pass clean with no new warnings.
6. Hand the diff to `Docs_Commit_Agent`.

---

## Role: Docs_Commit_Agent
- **Model**: `gemini-3.1-pro`
- **Settings**: `effort: high`
- **Objective**: Maintain documentation and execute git commits.
  - Update `docs/translation_log.md` for every newly-placed translation.
  - Write a concise git commit message (see existing commit history for style).
  - Stage exactly the files changed — never `git add -A`.
  - Execute `git commit`. Does not push.

### Commit message conventions
- Subject ≤ 72 chars.
- Body: SM83 → x86 translation notes (register decisions, bug-fix level used).
- Trailer: `Co-Authored-By: Gemini <noreply@google.com>` for swarm-generated content.
- Never commit `.o`, `.orig`, `DUMP.BIN`, `FRAME.BIN`, or `translation.db`.

---

## Role: Code_Worker (×5 instances)
- **Model**: `gemini-2.5-flash`
- **Settings**: `effort: high`
- **Objective**: Translate one SM83 function to x86 NASM 32-bit protected mode
  per the ticket from Dispatch_Manager. One ticket per worker at a time.

### Mandatory checklist
1. Read the exact pret source label from the ticket. Read surrounding context in
   the file to understand what the function does.
2. Translate using the register mapping from the ticket. Use `[EBP + constant]`
   for all GB memory accesses. Emit `; TODO-HW:` for any I/O boundary hit.
3. Apply `; BUG(level):` annotations if listed in the ticket.
4. Run `nasm -f coff -o /dev/null <output_file>` — must assemble clean.
5. Return the output file path and the nasm stdout to Dispatch_Manager.

### Hard limits
- No spawning sub-agents.
- No touching graphics, VGA, OAM, VRAM, audio, or joypad code.
- Create the output file only — do not modify any existing file.
- Do not add `%include` lines, Makefile rules, or `call` instructions anywhere.
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
2. **Callsite wiring is forbidden.** No agent may add `call` instructions to
   existing engine code. That work happens in Claude Code sessions.
3. **No parallel file edits.** Dispatch must not assign two workers to the same
   output file. Parallelism is at the file level only.
4. **Work queue is the source of truth.** Never mark complete outside
   `work_queue complete`. Never place a function that is not `status=complete`.
5. **Unverified = blocked.** Files with `status=unverified` require a Claude
   review before they can be placed. The swarm does not touch them.
6. **No `git add -A`.** Stage only files changed by the current work unit.
7. **No `--no-verify`.** Never skip pre-commit hooks.
8. **CLAUDE.md is law.** All agents must read it before generating any code.
   `docs/386_optimization_strategy.md` and `docs/register_map.md` are required
   reading for any agent writing NASM.
9. **Hardware escalation.** If a `simple` ticket hits a `$FF__` register or
   calls a graphics/audio routine, call `work_queue fail` immediately and do
   not attempt to translate it.

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
