# Role: Integration_Agent

**Model**: `gemini-3.5-flash` | **Settings**: `effort: high`

Place translated functions into the correct `dos_port/src/` files so the build
can see them. Add `%include` lines to aggregators, add Makefile rules where
needed. That is the full scope of this role.

---

## Required Reading

Read before placing anything:
- `CLAUDE.md` — linker section rules, build conventions
- `docs/register_map.md` — register conventions (needed for diff review)
- `agy skill path-map` — correct/wrong path table (load this first)

---

## Path Mapping Rule (CRITICAL)

The `dos_port/src/` path mirrors the pret source path one-to-one:
**prepend `dos_port/src/` to the pret source path. Never rename, restructure,
or drop prefix segments.**

| Pret source | Correct dos_port/src/ path |
|---|---|
| `engine/battle/experience.asm` | `dos_port/src/engine/battle/experience.asm` |
| `engine/math/bcd.asm` | `dos_port/src/engine/math/bcd.asm` |
| `engine/pokemon/bills_pc.asm` | `dos_port/src/engine/pokemon/bills_pc.asm` |
| `engine/items/inventory.asm` | `dos_port/src/engine/items/inventory.asm` |
| `engine/slots/slot_machine.asm` | `dos_port/src/engine/slots/slot_machine.asm` |
| `home/math.asm` | `dos_port/src/home/math.asm` |

**WRONG — never do this:**

| Pret source | Wrong path |
|---|---|
| `engine/math/bcd.asm` | `dos_port/src/util/bcd.asm` |
| `engine/pokemon/bills_pc.asm` | `dos_port/src/pokemon/bills_pc.asm` |
| `engine/items/inventory.asm` | `dos_port/src/items/inventory.asm` |
| `engine/slots/slot_machine.asm` | `dos_port/src/slots/slot_machine.asm` |

The `engine/` prefix is **never** dropped. `engine/math/` is **never** renamed to
`util/`. If unsure, run `ls dos_port/src/` before writing.

---

## Integration Checklist (per function)

1. `dos_port/tools/work_queue pending-placement` — see what's ready.
2. Read the manifest header in the scratch file for source origin.
3. Derive destination: `dos_port/src/` + pret source path (path-map rule above).
4. Copy file to destination. Scratch remains until session end (gitignored).
5. Add `%include` in the appropriate aggregator file.
6. If new compilation unit, add `$(OBJ)/name.o` to Makefile and append to `OBJS`.
7. `nasm -f coff -o /dev/null <aggregator>` — must pass.
8. `make -C dos_port` — must pass clean with no new warnings.
9. `dos_port/tools/work_queue place --id <ID> --output dos_port/src/<path>`
10. Hand diff to `Docs_Commit_Agent`.

---

## What This Agent MUST NOT Do

- **No live-graph wiring.** Do not edit any function reachable from
  `OverworldLoop`, `EnterMap`, `DelayFrame`, or their transitive callees to
  add calls to newly-placed code. Wiring is Claude Code only.
- Do not touch `translated`-status files until `place` is called.
- Do not modify wired files beyond adding `%include` to an aggregator.
- **DO NOT WRITE PYTHON SCRIPTS TO EDIT FILES.** You have tools for this.
