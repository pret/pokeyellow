; dos_port/src/slots/slot_machine.asm

%include "gb_macros.inc"
%include "gb_memmap.inc"

section .text

global SlotMachine_SetFlags
global SlotMachine_FindWheel1Wheel2Matches
global SlotMachine_CheckForMatch

extern Random

%define BIT_SLOTS_CAN_WIN 6
%define BIT_SLOTS_CAN_WIN_WITH_7_OR_BAR 7

; -----------------------------------------------------------------------------
; SlotMachine_SetFlags
; -----------------------------------------------------------------------------
SlotMachine_SetFlags:
    mov al, byte [ebp + W_SLOT_MACHINE_FLAGS]
    test al, (1 << BIT_SLOTS_CAN_WIN_WITH_7_OR_BAR)
    jnz .exit
    
    mov al, byte [ebp + W_SLOT_MACHINE_ALLOW_MATCHES_COUNTER]
    test al, al
    jnz .allowMatches
    
    call Random
    test al, al
    jz .setAllowMatchesCounter
    
    mov bl, al
    mov al, byte [ebp + W_SLOT_MACHINE_SEVEN_AND_BAR_MODE_CHANCE]
    cmp bl, al
    jc .allowSevenAndBarMatches
    
    mov al, 210
    cmp bl, al
    jc .allowMatches
    
    mov byte [ebp + W_SLOT_MACHINE_FLAGS], 0
.exit:
    ret

.allowMatches:
    or byte [ebp + W_SLOT_MACHINE_FLAGS], (1 << BIT_SLOTS_CAN_WIN)
    ret

.setAllowMatchesCounter:
    mov byte [ebp + W_SLOT_MACHINE_ALLOW_MATCHES_COUNTER], 60
    ret

.allowSevenAndBarMatches:
    or byte [ebp + W_SLOT_MACHINE_FLAGS], (1 << BIT_SLOTS_CAN_WIN_WITH_7_OR_BAR)
    ret

; -----------------------------------------------------------------------------
; SlotMachine_FindWheel1Wheel2Matches
; Return whether wheel 1 and wheel 2's current positions allow a match in Z flag.
; -----------------------------------------------------------------------------
SlotMachine_FindWheel1Wheel2Matches:
    mov esi, W_SLOT_MACHINE_WHEEL1_BOTTOM_TILE
    mov edi, W_SLOT_MACHINE_WHEEL2_BOTTOM_TILE
    
    ; bottom-bottom
    mov al, byte [ebp + edi]
    cmp al, byte [ebp + esi]
    jz .match
    
    ; bottom-middle
    inc edi
    mov al, byte [ebp + edi]
    cmp al, byte [ebp + esi]
    jz .match
    
    ; middle-middle
    inc esi
    cmp al, byte [ebp + esi]
    jz .match
    
    ; top-middle
    inc esi
    cmp al, byte [ebp + esi]
    jz .match
    
    ; top-top
    inc edi
    mov al, byte [ebp + edi]
    cmp al, byte [ebp + esi]
    jz .match
    
    ; no match
    dec edi
    dec edi
    ; Make sure Z flag is cleared (we know we are here because cmp failed)
    test esp, esp
.match:
    ret

; -----------------------------------------------------------------------------
; SlotMachine_CheckForMatch
; Compares the slot machine tiles at ESI, EDI, and ECX.
; Z flag is set if all three match.
; -----------------------------------------------------------------------------
SlotMachine_CheckForMatch:
    mov al, byte [ebp + edi]
    cmp al, byte [ebp + esi]
    jnz .no_match
    
    mov al, byte [ebp + ecx]
    cmp al, byte [ebp + esi]
.no_match:
    ret
