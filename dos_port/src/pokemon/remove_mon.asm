; dos_port/src/pokemon/remove_mon.asm

%include "gb_macros.inc"
%include "gb_memmap.inc"

section .text

global _RemovePokemon

extern SkipFixedLengthTextEntries
extern CopyDataUntil
extern AddNTimes

%define PARTY_LENGTH 6
%define MONS_PER_BOX 20
%define NAME_LENGTH 11
%define PARTYMON_STRUCT_LENGTH 44
%define BOXMON_STRUCT_LENGTH 33

; -----------------------------------------------------------------------------
; _RemovePokemon
;
; Removes the pokemon at [wWhichPokemon] from the party or box, shifting
; all subsequent data up one slot.
; -----------------------------------------------------------------------------
_RemovePokemon:
    mov esi, W_PARTY_COUNT
    mov al, byte [ebp + W_REMOVE_MON_FROM_BOX]
    test al, al
    jz .gotCount
    mov esi, W_BOX_COUNT
.gotCount:
    mov al, byte [ebp + esi]
    dec al
    mov byte [ebp + esi], al
    inc esi
    
    movzx ecx, byte [ebp + W_WHICH_POKEMON]
    add esi, ecx
    lea edx, [esi + 1]

.shiftMonSpeciesLoop:
    mov al, byte [ebp + edx]
    inc edx
    mov byte [ebp + esi], al
    inc esi
    inc al ; reached terminator (0xFF)?
    jnz .shiftMonSpeciesLoop

    mov esi, W_PARTY_MON_OT
    mov dh, PARTY_LENGTH - 1
    mov al, byte [ebp + W_REMOVE_MON_FROM_BOX]
    test al, al
    jz .gotOTsPointer
    mov esi, W_BOX_MON_OT
    mov dh, MONS_PER_BOX - 1
.gotOTsPointer:
    mov al, byte [ebp + W_WHICH_POKEMON]
    call SkipFixedLengthTextEntries
    
    mov al, byte [ebp + W_WHICH_POKEMON]
    cmp al, dh
    jnz .notRemovingLastMon
    
    mov byte [ebp + esi], 0xFF
    ret

.notRemovingLastMon:
    mov edx, esi
    lea esi, [esi + NAME_LENGTH]
    
    mov ecx, W_PARTY_MON_NICKS
    mov al, byte [ebp + W_REMOVE_MON_FROM_BOX]
    test al, al
    jz .gotNicksPointer
    mov ecx, W_BOX_MON_NICKS
.gotNicksPointer:
    call CopyDataUntil

    mov esi, W_PARTY_MONS
    mov ecx, PARTYMON_STRUCT_LENGTH
    mov al, byte [ebp + W_REMOVE_MON_FROM_BOX]
    test al, al
    jz .gotMonStructs
    mov esi, W_BOX_MONS
    mov ecx, BOXMON_STRUCT_LENGTH
.gotMonStructs:
    mov al, byte [ebp + W_WHICH_POKEMON]
    call AddNTimes
    
    mov edx, esi
    mov al, byte [ebp + W_REMOVE_MON_FROM_BOX]
    test al, al
    jz .copyUntilPartyMonOT

    ; copy until W_BOX_MON_OT
    mov ecx, BOXMON_STRUCT_LENGTH
    add esi, ecx
    mov ecx, W_BOX_MON_OT
    jmp .shiftOTs

.copyUntilPartyMonOT:
    mov ecx, PARTYMON_STRUCT_LENGTH
    add esi, ecx
    mov ecx, W_PARTY_MON_OT

.shiftOTs:
    call CopyDataUntil

    mov esi, W_PARTY_MON_NICKS
    mov al, byte [ebp + W_REMOVE_MON_FROM_BOX]
    test al, al
    jz .gotNicksPointer2
    mov esi, W_BOX_MON_NICKS
.gotNicksPointer2:
    mov ecx, NAME_LENGTH
    mov al, byte [ebp + W_WHICH_POKEMON]
    call AddNTimes
    
    mov edx, esi
    mov ecx, NAME_LENGTH
    add esi, ecx
    
    mov ecx, W_PARTY_MON_NICKS_END
    mov al, byte [ebp + W_REMOVE_MON_FROM_BOX]
    test al, al
    jz .shiftMonNicks
    mov ecx, W_BOX_MON_NICKS_END
.shiftMonNicks:
    jmp CopyDataUntil
