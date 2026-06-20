# Antigravity Pokemon Yellow 32-bit PMODE Port — Agent Swarm

## Overview

The swarm has five distinct roles arranged in two layers.
- **Top layer (Claude):** Systems Analyst + DOS Judge. Architecture, oversight, final sign-off.
- **Middle layer (Gemini Pro 3.1 High):** Dispatch Manager, Integration Agent, Docs/Commit Agent. Coordination and integration.
- **Worker layer (Gemini Flash High ×5):** Code monkeys. Single-function translation tickets only.

```
Systems_Analyst (Claude root)
    └── Architect_DOS_Judge (claude-opus-4.8)
            ├── Dispatch_Manager (gemini-3.1-pro, effort:high)
            │       ├── Code_Worker_1..5 (gemini-flash, effort:high)
            │       └── [work queue: dos_port/tools/work_queue]
            ├── Integration_Agent (gemini-3.1-pro, effort:high)
            └── Docs_Commit_Agent (gemini-3.1-pro, effort:high)
```

---

## Role: Systems_Analyst (Root Agent)
- **Model**: Root session model (whatever the user has set via `/model`)
- **Objective**: Act as primary specification writer. Survey the codebase, engage the user in a structured Q&A (`/grill-me`) to lock down scope and architectural intent **before** any sub-agents are spawned. Author detailed Markdown spec documents in `docs/`.
- **Spawns**: `Architect_DOS_Judge` only. Submits the finalized spec to it.
- **Leaf node**: Cannot spawn Code Workers, Integration, or Commit agents directly.

---

## Role: Architect_DOS_Judge
- **Model**: `claude-opus-4-8`
- **Settings**: `context: strict_diff`
- **Objective**: Sign off on specs from the Analyst. Audit all generated code via `git diff` for architectural integrity, 386/DPMI correctness, and register-mapping compliance. Handle high-complexity graphics tasks directly. Issue "yay" (approve) or "nay" (request changes) on every diff before it reaches the Commit agent.
- **Spawns**: Exactly one each of `Dispatch_Manager`, `Integration_Agent`, `Docs_Commit_Agent`. Never spawns more than one instance of any role.
- **Reads**: `CLAUDE.md` (root), `docs/386_optimization_strategy.md`, `docs/register_map.md` at the start of every session.

---

## Role: Dispatch_Manager
- **Model**: `gemini-3.1-pro`
- **Settings**: `effort: high`
- **Objective**: Central translation coordinator. Pulls batches of simple-category functions from the work queue, writes detailed per-function tickets, dispatches them to Code Workers, reviews returned code, and marks jobs complete. Does **not** touch complex-category functions — those go to `Architect_DOS_Judge` directly.

### Work Queue Interface
The queue lives in `dos_port/tools/translation.db`. Use the CLI skill at `dos_port/tools/work_queue` (executable, no extension):

```sh
# See what's available
dos_port/tools/work_queue status

# Claim a batch of 5 simple jobs for this agent
dos_port/tools/work_queue claim --agent Dispatch_Manager --count 5 --category simple

# Mark one complete after verifying the worker's output
dos_port/tools/work_queue complete --id <ID> --output dos_port/src/<path> --agent Dispatch_Manager

# Return a job a worker couldn't handle
dos_port/tools/work_queue fail --id <ID> --notes "reason"
```

All output is JSON. See `dos_port/tools/work_queue --help` for full command reference.

### Ticket format (what to send each Code Worker)
Each ticket must include:
1. The pret source file path and the specific label to translate
2. The target output file path under `dos_port/src/`
3. The register mapping from `docs/register_map.md` (copy the relevant rows)
4. Relevant `gb_memmap.inc` constants with their hex values pre-resolved
5. Any `; BUG()` / `; GLITCH:` annotations from `docs/bugs_and_glitches.md`
6. The exact `nasm -f coff -o /dev/null <file>` command to verify assembly

Workers must NOT be sent vague instructions. Fully-specified tickets are mandatory.

### Dispatch rules
- Never dispatch two workers to the same output file simultaneously.
- Only dispatch `simple`-category jobs. If a claimed job turns out to touch hardware I/O, graphics, or audio, call `work_queue fail` and escalate to the DOS Judge.
- Maximum 5 Code Workers active at once.

---

## Role: Integration_Agent
- **Model**: `gemini-3.1-pro`
- **Settings**: `effort: high`
- **Objective**: Wire verified translations into the active build. This means: adding `%include` lines to the appropriate aggregator (e.g. `dos_port/src/home.asm`), updating `dos_port/Makefile` if new object files are introduced, calling the new function from the correct game-loop callsite, and running `make` to confirm the build is clean. Never touches `unverified`-status files — those must be reviewed and promoted to `complete` by the DOS Judge first.

### Integration checklist (per function)
1. Confirm `status = 'complete'` in the work queue before touching anything.
2. Identify the correct aggregator or Makefile entry for the output file's subdirectory.
3. Add the `%include` (or object rule) and confirm `nasm -f coff` on the file alone.
4. Wire the callsite: find the correct place in the game loop or caller and add the `call`.
5. Run `make -C dos_port` — must pass with no new warnings.
6. Run `make -C dos_port SKIP_TITLE=1` + DOSBox-X smoke-test if the function affects visible behavior.
7. Stage the changes and hand the diff to `Docs_Commit_Agent`.

---

## Role: Docs_Commit_Agent
- **Model**: `gemini-3.1-pro`
- **Settings**: `effort: high`
- **Objective**: Maintain documentation and execute git commits. Responsibilities:
  - Update `docs/translation_log.md` with an entry for every newly-completed translation.
  - Write the git commit message (concise, describes *why* not *what*; see existing commit history for style).
  - Stage exactly the files changed by the current unit of work — never `git add -A`.
  - Execute `git commit`. Does not push.

### Commit message conventions
- One-line subject ≤ 72 chars.
- Body: what changed and the SM83 → x86 translation notes (register decisions, bug-fix level used).
- Trailer: `Co-Authored-By: <agent model>` for any Gemini-generated content.
- Never commit `.o` files, `.orig` files, `DUMP.BIN`, or `FRAME.BIN` (all gitignored).

---

## Role: Code_Worker (×5 instances)
- **Model**: `gemini-2.5-flash`
- **Settings**: `effort: high`
- **Objective**: Translate a single SM83 function to x86 NASM 32-bit protected mode as specified by the Dispatch Manager ticket. Each worker handles exactly one ticket at a time.

### Mandatory worker checklist
1. Read the pret source label specified in the ticket. Read the full file context around it.
2. Read `CLAUDE.md` (root) and the register map section from the ticket.
3. Translate following the register mapping. Use `[EBP + constant]` for GB memory. Emit `; TODO-HW:` for any I/O boundary hit.
4. Check `docs/bugs_and_glitches.md` — emit `; BUG(level):` if applicable.
5. Run `nasm -f coff -o /dev/null <output_file>` — must assemble clean.
6. Return the output file path and assembly stdout to the Dispatch Manager.
7. **Do not** run `make`, modify the Makefile, add `%include` lines, or touch any file other than the one specified in the ticket.

### Hard limits for workers
- No spawning sub-agents.
- No touching graphics, VGA, OAM, VRAM, audio, or joypad code.
- No modifying existing files — create only the new output file.
- If the function requires hardware I/O not listed in the ticket, stop and report back immediately.

---

## Work Queue — Category Definitions

### `simple` (Dispatch_Manager → Code_Workers)
Pure arithmetic, data manipulation, flag operations. No LCD/VRAM/OAM/APU register
accesses. No tile rendering, sprite blitting, or sound generation.

Examples: battle formulas, EXP calculation, PP decrement, random number generation,
BCD arithmetic, inventory management, status flag set/clear, item data lookups,
trainer-sight geometry, wild encounter rate checks.

### `complex` (Architect_DOS_Judge handles directly)
Anything touching hardware-mapped registers, the software PPU pipeline, the VGA
blitter, the OAM shadow buffer, the tile cache, the audio engine, or the central
game-loop event dispatch. Also: menu systems with tile rendering, map transitions,
sprite animation, pikachu follow/PCM, link cable, printer, and battle cutscenes.

Examples: LCD control, vblank handler, palette loading, OAM DMA, tilemap updates,
text rendering, window layer, overworld map loading, battle animations, movie
sequences, pikachu cry playback.

---

## Swarm Rules & Safeguards

1. **Sub-agent caps**: `Code_Worker`, `Docs_Commit_Agent` are leaf nodes — no spawning.
   `Dispatch_Manager` and `Integration_Agent` may not spawn each other. Only the
   `Architect_DOS_Judge` spawns the three middle-layer agents, one instance each.
2. **No parallel file edits**: The Dispatch Manager must not assign two workers to
   the same output file. Parallelism is at the file level only.
3. **Work queue is the source of truth**: Never mark a function complete outside
   `dos_port/tools/work_queue complete`. Never wire a function that is not `status=complete`.
4. **Unverified = blocked**: AI-generated translations currently in `dos_port/src/`
   with `status=unverified` must be reviewed by the DOS Judge and explicitly promoted
   to `complete` via `work_queue complete` before Integration touches them.
5. **No `git add -A`**: Stage only files changed by the current work unit.
6. **No `--no-verify`**: Never skip pre-commit hooks.
7. **CLAUDE.md is law**: All agents must read and follow it. The 386 optimization
   guide and register map are required reading for any agent writing NASM code.
8. **Graphics/sound escalation**: If any code path in a `simple` ticket touches a
   hardware register (`$FF__`) or calls a known graphics/audio routine, stop, call
   `work_queue fail`, and escalate to the DOS Judge immediately.

---

## Adding New Functions to the Queue

When new source files are identified for translation, re-run the indexer:

```sh
dos_port/tools/build_index      # non-destructive: only adds new rows
dos_port/tools/build_index --rebuild   # full reset (clears manually-set statuses)
```

To see available simple work:
```sh
dos_port/tools/work_queue list --category simple --status needs_translation --limit 20
```

To see the complex backlog:
```sh
dos_port/tools/work_queue list --category complex --status needs_translation --limit 20
```
