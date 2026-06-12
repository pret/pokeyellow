; fill_memory.asm — FillMemory routine translated from SM83 to x86.
;
; Source: home/copy2.asm:137–155 (pret/pokeyellow)
; Reference: docs/translation_log.md (FillMemory entry)
;
; SM83 original:
;   FillMemory — fill BC bytes at HL with byte value A.
;   Uses a double-loop to handle 16-bit count in two nested 8-bit loops.
;
; x86 translation:
;   Register map: HL→ESI (EBP-relative dest), BC→BX (count), A→AL (fill byte)
;   The double-loop collapses to movzx+rep stosb — same semantics, no edge cases.
;   EDI used as scratch destination pointer (per register map: "Secondary pointer").
;
; Build: nasm -f coff -I ../../include/ -o fill_memory.o fill_memory.asm

bits 32

%include "gb_memmap.inc"
%include "gb_macros.inc"

; ---------------------------------------------------------------------------
; Exported symbols
; ---------------------------------------------------------------------------
global FillMemory

; ---------------------------------------------------------------------------
; Code
; ---------------------------------------------------------------------------
section .text

; ---------------------------------------------------------------------------
; FillMemory — fill BX bytes at [EBP+ESI] with AL
;
; In:  ESI = destination offset (GB address, EBP-relative)
;      BX  = byte count (16-bit, up to 65535)
;      AL  = fill value
; Out: ESI unchanged (EDI is the scratch pointer; ESI is preserved)
;      EBX unchanged (ECX is clobbered as the rep counter)
;      EAX unchanged
;
; Flags: DF must be 0 (forward direction) before calling — callers must ensure
;        this. Under DJGPP the default direction flag is always 0.
;
; H-flag: not involved — FillMemory performs no arithmetic, no DAA/CPL follow.
; N-flag: not involved.
; C-flag: not set by this routine.
; ---------------------------------------------------------------------------
FillMemory:
    push ecx
    push edi

    movzx   ecx, bx              ; zero-extend 16-bit BC count to full 32 bits
                                 ; count=0 → rep stosb is a no-op (correct)
    lea     edi, [ebp + esi]     ; flat destination: EBP base + GB-space offset
    rep stosb                    ; fill ECX bytes at ES:EDI with AL
                                 ; ES = DS = flat selector under DJGPP

    pop edi
    pop ecx
    ret

; ---------------------------------------------------------------------------
; Notes on the SM83 double-loop and why it collapses here:
;
; The original SM83 code increments B when C != 0 before entering the loop
; to handle the case where BC = 0x?? 00 (a non-multiple-of-256 count that
; has C=0 on entry). This produces:
;   if (B == 0)                → 8-bit count path (C < 256)
;   elif (C == 0)              → exact multiple of 256
;   else                       → inc B, so outer loop runs B+1 times
;
; In x86, movzx ecx, bx zero-extends the full 16-bit count into ECX, and
; rep stosb handles any value 0..65535 correctly. The double-loop quirk is
; a SM83 limitation that does not exist on x86.
;
; Edge cases verified:
;   BX=0x0000 (count=0)    → ECX=0   → rep stosb no-op (correct)
;   BX=0x00FF (count=255)  → ECX=255 → 255 bytes written (correct)
;   BX=0x0100 (count=256)  → ECX=256 → 256 bytes written
;     (SM83: B=1, C=0 → .mulitpleof0x100 path, correct, no inc B)
;   BX=0x0101 (count=257)  → ECX=257 → 257 bytes written
;     (SM83: B=1, C=1 → inc B to 2, then loops: 256+1 = 257, correct)
; ---------------------------------------------------------------------------
