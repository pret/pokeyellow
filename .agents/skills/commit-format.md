# Skill: commit-format

Git commit message conventions for swarm-generated translations.

## Format

```
Translate <Label>[, <Label2>...]: <one-line summary>

SM83→x86 notes:
- <register decisions, e.g. "HL→ESI for table ptr">
- <H-flag involvement, e.g. "H flag not used">
- <BUG_FIX_LEVEL applied, e.g. "BUG(cosmetic) block at RestorePPAmount">
- <any notable deviation from literal translation>

Co-Authored-By: Gemini <noreply@google.com>
```

## Rules

- Subject line ≤ 72 characters
- Use present tense: "Translate", not "Translated"
- Body SM83 notes are mandatory — do not omit
- Trailer is `Co-Authored-By: Gemini <noreply@google.com>` for all swarm commits
- Never commit: `.o`, `.orig`, `DUMP.BIN`, `FRAME.BIN`, `translation.db`,
  scratch files, unrelated editor files
- Stage only the files changed by this work unit: `git add <exact paths>`
- Never `git add -A` or `git add .`
- Never `--no-verify`
- Never push

## Example

```
Translate CalcExperience, GainExperience: battle experience formulas

SM83→x86 notes:
- HL→ESI for exp table ptr, BC→BX for growth rate pair
- H flag not involved
- imul used for exp formula (SM83 used 16-bit mul via DE pair)
- BUG(cosmetic) block at exp overflow display (BUG_FIX_LEVEL >= 2)

Co-Authored-By: Gemini <noreply@google.com>
```
