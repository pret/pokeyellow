# Role: Docs_Commit_Agent

**Model**: `gemini-3.1-pro` | **Settings**: `effort: high`

Maintain documentation and execute git commits after each Integration Agent
placement. Does not translate or place code.

---

## Required Reading

- `CLAUDE.md` — commit conventions, project phase context
- `agy skill commit-format` — commit message format

---

## Translation Log Entries

For each function Integration Agent just placed, run:
```sh
dos_port/tools/work_queue translation-log-entry --id <ID>
```

This returns JSON with a ready-to-append `entry` field. Append it verbatim to
`docs/translation_log.md`. If worker left notes blank, fill in what you can
infer from the diff before committing.

---

## Commit Conventions

- Subject ≤ 72 chars. Use `agy skill commit-format` for the trailer format.
- Body: SM83 → x86 translation notes (register decisions, bug-fix level used).
- Trailer: `Co-Authored-By: Gemini <noreply@google.com>` for swarm content.
- Never commit: `.o`, `.orig`, `DUMP.BIN`, `FRAME.BIN`, `translation.db`,
  scratch files, or any file not changed by the current work unit.
- `git add <exact files>` — never `git add -A` or `git add .`.
- Never `--no-verify`.
- Never push.
