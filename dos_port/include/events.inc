; events.inc — event-flag accessors over wEventFlags (W_EVENT_FLAGS).
;
; Faithful translation of pret's CheckEvent / SetEvent / ResetEvent
; (macros/scripts/events.asm). An event is a bit index (EVENT_*, from
; assets/event_constants.inc) into the wEventFlags bit array; this header turns an
; index into (byte offset, bit mask) at assembly time.
;
; Requires (include before this): gb_memmap.inc (W_EVENT_FLAGS) and
; assets/event_constants.inc (EVENT_* indices).
;
; Convention: EBP = base of emulated GB memory. All three macros CLOBBER AL.
; CheckEvent additionally sets ZF (and is the only one that reads flags):
;   ZF=1  → event is CLEAR   (use `jz` / `je`)
;   ZF=0  → event is SET     (use `jnz` / `jne`)
; matching pret's `bit n,[hl]` → `jr z` idiom exactly.

%ifndef EVENTS_INC
%define EVENTS_INC

; idx → byte offset within wEventFlags, and the single-bit mask. Modulo is written
; as idx-(idx/8)*8 to avoid NASM's '%' (preprocessor) in expressions.
%define EVENT_BYTE(i)  ((i) / 8)
%define EVENT_MASK(i)  (1 << ((i) - ((i) / 8) * 8))

; CheckEvent EVENT_X — test the flag; sets ZF (see header). Clobbers AL.
%macro CheckEvent 1
    mov al, [ebp + W_EVENT_FLAGS + EVENT_BYTE(%1)]
    test al, EVENT_MASK(%1)
%endmacro

; SetEvent EVENT_X — set the flag. Clobbers AL.
%macro SetEvent 1
    mov al, [ebp + W_EVENT_FLAGS + EVENT_BYTE(%1)]
    or  al, EVENT_MASK(%1)
    mov [ebp + W_EVENT_FLAGS + EVENT_BYTE(%1)], al
%endmacro

; ResetEvent EVENT_X — clear the flag. Clobbers AL.
%macro ResetEvent 1
    mov al, [ebp + W_EVENT_FLAGS + EVENT_BYTE(%1)]
    and al, ~EVENT_MASK(%1) & 0xFF
    mov [ebp + W_EVENT_FLAGS + EVENT_BYTE(%1)], al
%endmacro

%endif ; EVENTS_INC
