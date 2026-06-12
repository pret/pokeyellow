; gb_macros.inc — Translation macros and bug-fix level definitions.
; Include after gb_memmap.inc in every translated source file.

%ifndef GB_MACROS_INC
%define GB_MACROS_INC

; ---------------------------------------------------------------------------
; Bug fix level
; 0 = original behavior (all glitches active) — default
; 1 = fix critical bugs only (buffer overflows, OOB writes, save corruption, ACE)
; 2 = fix all documented bugs (cosmetic, behavioral, critical)
;
; Set at build time via Makefile: nasm -D BUG_FIX_LEVEL=1 ...
; Set at runtime: entry.asm parses /FIXCRIT (level 1) and /FIXALL (level 2)
; and writes the value to [bug_fix_level] in BSS, which runtime-conditional
; code reads. The compile-time define gates code that cannot be conditional at
; runtime (e.g. code size / alignment-sensitive paths).
; ---------------------------------------------------------------------------
%ifndef BUG_FIX_LEVEL
  %define BUG_FIX_LEVEL 0
%endif

; ---------------------------------------------------------------------------
; Translation comment conventions
;
; BUG(critical): <description>
;   A bug that can cause buffer overflows, OOB writes, save corruption, or
;   arbitrary code execution. Fixed when BUG_FIX_LEVEL >= 1 (/FIXCRIT).
;   Template:
;     ; BUG(critical): <what goes wrong>
;     ; pret ref: <source file>:<label>, docs/bugs_and_glitches.md#L<line>
;     %if BUG_FIX_LEVEL >= 1
;       ; ... fixed implementation
;     %else
;       ; ... original (buggy) behavior
;     %endif
;
; BUG(cosmetic): <description>
;   A minor behavioral or visual bug that does not threaten save data or
;   system stability. Fixed when BUG_FIX_LEVEL >= 2 (/FIXALL).
;   Same template as above but %if BUG_FIX_LEVEL >= 2.
;
; GLITCH: <name> — <description>
;   An intentional glitch that users may exploit (MissingNo, item dup, etc.).
;   Safety tag: "safe under DPMI" or "unsafe on bare HW if ACE reachable".
;   These are never fixed by any flag — they are preserved behavior.
;   Example:
;     ; GLITCH: MissingNo encounter — reads past end of species table
;     ; Safety: safe under DPMI (bounded to emulated WRAM)
;
; TODO-HW: <description>
;   A GB hardware I/O access that has not yet been translated.
;   The original code is preserved as a comment; a stub (nop or ret) is emitted.
;   Example:
;     ; TODO-HW: write to rLCDC ($FF40) to enable/disable LCD
;     ;   original: ld [rLCDC], a
;     ;   pending: software renderer reads [EBP + IO_LCDC] to determine render state
; ---------------------------------------------------------------------------

; ---------------------------------------------------------------------------
; Convenience macros for GB memory access via EBP
; ---------------------------------------------------------------------------

; Load byte from GB address in ESI into AL
%macro GB_LD_A_HL 0
    mov al, [ebp + esi]
%endmacro

; Store AL to GB address in ESI
%macro GB_LD_HL_A 0
    mov [ebp + esi], al
%endmacro

; Load byte from GB address in ESI into AL, post-increment ESI (hli)
%macro GB_LD_A_HLI 0
    mov al, [ebp + esi]
    inc esi
%endmacro

; Store AL to GB address in ESI, post-increment ESI (hli)
%macro GB_LD_HLI_A 0
    mov [ebp + esi], al
    inc esi
%endmacro

; Load byte from GB address in ESI into AL, post-decrement ESI (hld)
%macro GB_LD_A_HLD 0
    mov al, [ebp + esi]
    dec esi
%endmacro

; Load byte from HRAM offset (ldh a, [offset]) — offset is $FF00-relative
%macro GB_LDH_A 1
    mov al, [ebp + GB_IO + (%1 & 0x7F)]
%endmacro

; Store AL to HRAM offset (ldh [offset], a)
%macro GB_LDH 1
    mov [ebp + GB_IO + (%1 & 0x7F)], al
%endmacro

%endif ; GB_MACROS_INC
