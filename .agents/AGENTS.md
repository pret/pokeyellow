# Antigravity Pokemon Yellow DOS Port — Agent Swarm

## Overview

Claude Code handles architecture, complex functions, and live-graph wiring.
The swarm handles bulk translation of `simple`-category functions only.

```
Dispatch_Manager (gemini-3.1-pro)       ← coordinator
    ├── Code_Worker_1..5 (gemini-3.5-flash)
    ├── Integration_Agent (gemini-3.5-flash)
    └── Docs_Commit_Agent (gemini-3.1-pro)
```

**Hard boundary**: Swarm places translated code. It does **not** wire functions
into the live game loop. Live-graph connections (`OverworldLoop`, `EnterMap`,
`DelayFrame` callees) are Claude Code only.

---

## Role Files (read your role file before doing anything)

| Role | File |
|---|---|
| Dispatch_Manager | `.agents/roles/dispatch.md` |
| Code_Worker | `.agents/roles/worker.md` |
| Integration_Agent | `.agents/roles/integration.md` |
| Docs_Commit_Agent | `.agents/roles/docs.md` |

---

## Skills (load on demand with `agy skill <name>`)

| Skill | When to load |
|---|---|
| `register-map` | Before writing any NASM |
| `path-map` | Before placing any file |
| `386-checklist` | When choosing instructions |
| `bug-check` | When BUG/GLITCH annotation needed |
| `glitch-escalation` | When hitting a $FF__ register |
| `commit-format` | Before committing |

---

## Work Queue Quick Reference

```sh
dos_port/tools/work_queue status
dos_port/tools/work_queue claim --agent <NAME> --count 5 --category simple
dos_port/tools/work_queue pending-placement
dos_port/tools/work_queue list --status needs_translation --category simple --limit 20
```

Run `dos_port/tools/work_queue --help` for full command reference.

Status pipeline: `needs_translation → in_progress → translated → [wired → verified]`

`wired` and `verified` are Claude Code session transitions only.

---

## Category Definitions

**`simple`** → swarm handles: pure arithmetic, data lookup, flag set/clear,
inventory math, battle formulas, BCD, random numbers. No `$FF__` I/O.

**`complex`** → Claude Code only: anything touching PPU, VGA, OAM, tile cache,
audio, joypad, menus with tile rendering, map transitions, pikachu, link cable.

---

## Swarm Rules

1. **No Claude in the loop.** Swarm does not spawn Claude agents.
2. **Live-graph boundary is inviolable.** No new edges into untested code from
   live-game-loop functions. Translated functions calling each other is fine.
3. **No direct DB access.** Never run `sqlite3` on `translation.db`.
   Use `dos_port/tools/work_queue` exclusively.
4. **No parallel file edits.** One worker per output file at a time.
5. **Work queue is source of truth.** Never mark translated outside the tool.
6. **No `git add -A`.** Stage only files changed by the current work unit.
7. **No `--no-verify`.** Never skip pre-commit hooks.
8. **Hardware escalation.** `$FF__` hit on a simple job → `recategorize complex` + `fail`.
9. **Strict command invocation.** Use exact bare path `dos_port/tools/work_queue`.
   Never prefix with `./`, `/bin/bash`, or `sh`.
10. **`complete` requires status=translated.** `place` requires `output ≠ scratch`.

---

## Adding New Functions to the Queue

```sh
dos_port/tools/build_index             # non-destructive, adds only new rows
dos_port/tools/build_index --rebuild   # full reset (clears manual status changes)
```

---

## Agent Invocation Note

Due to dynamic subagent registration, use `TypeName: self` in `invoke_subagent`
and supply the full system prompt + ticket in the `Prompt` field.
