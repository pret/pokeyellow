---
name: 386-checklist
description: Fast instruction selection checklist for 386+ NASM translations.
---
# Skill: 386-checklist

Fast instruction selection checklist for 386+ NASM translations.

## Memory Access

- `[EBP + constant]` for ALL GB memory — never use raw GB addresses
- Use `movzx eax, byte [ebp + addr]` to load 8-bit value into 32-bit reg
- Use `movzx eax, word [ebp + addr]` for 16-bit
- For 16-bit GB HL register pair: use ESI for pointer, `movzx esi, word [...]`

## Arithmetic

- 8-bit add/sub: operate on AL/BL/etc., let carry propagate naturally
- 16-bit GB arithmetic (BC, DE, HL): use 16-bit x86 BX/DX/SI with `movzx` after
- Multiply: `imul eax, ecx, N` preferred over shift sequences for clarity
- Divide: `div` or `idiv` with zero-extension for unsigned GB divisions

## Flags

- Z flag: direct — `test al, al` / `cmp al, bl` works identically
- C flag: direct — `jc`/`jnc` works
- H flag: lazy — only compute `[hf_shadow]` if DAA or CPL follows
- N flag: implicit in instruction choice (SUB sets, ADD clears)

## Common Patterns

```nasm
; GB: ld a, [hl]         → movzx eax, byte [ebp + esi]
; GB: ld [hl], a         → mov [ebp + esi], al
; GB: inc hl             → inc esi
; GB: ld hl, NN         → mov esi, NN
; GB: push bc            → push ebx
; GB: pop bc             → pop ebx
; GB: call Label         → call Label
; GB: ret                → ret
; GB: ret z              → jz .done  (inline check before call)
; GB: jr nz, .label      → jnz .label
```

## Forbidden

- Do not use `[ESP + N]` to access GB memory
- Do not use segment overrides (DS:, ES:) — flat model only
- Do not use `loop` instruction — it only tests CX (16-bit under 32-bit mode)
- Do not use FAR jumps/calls
