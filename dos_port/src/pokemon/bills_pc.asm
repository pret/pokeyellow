; dos_port/src/pokemon/bills_pc.asm

%include "gb_macros.inc"
%include "gb_memmap.inc"

section .text

global KnowsHMMove
global BillsPCDepositLogic
global BillsPCWithdrawLogic
global BillsPCReleaseLogic

extern IsInArray
extern MoveMon
extern RemovePokemon

%define PARTYMON_STRUCT_LENGTH 44
%define BOXMON_STRUCT_LENGTH 33
%define NUM_MOVES 4

%define PARTY_LENGTH 6
%define MONS_PER_BOX 20

%define BOX_TO_PARTY 0
%define PARTY_TO_BOX 1

%define CUT 15
%define FLY 19
%define SURF 57
%define STRENGTH 70
%define FLASH 148

; -----------------------------------------------------------------------------
; KnowsHMMove
; returns whether mon with party index [W_WHICH_POKEMON] knows an HM move
; returns C flag set if true.
; -----------------------------------------------------------------------------
KnowsHMMove:
    mov esi, W_PARTY_MON1_MOVES
    mov ecx, PARTYMON_STRUCT_LENGTH
    jmp .next
    ; unreachable in original GB code, preserved for bug compatibility
    mov esi, W_BOX_MON1_MOVES
    mov ecx, BOXMON_STRUCT_LENGTH
.next:
    movzx eax, byte [ebp + W_WHICH_POKEMON]
    imul ecx, eax
    add esi, ecx
    
    mov bh, NUM_MOVES
.loop:
    mov al, byte [ebp + esi]
    inc esi
    
    push esi
    push bx
    lea esi, [HMMoveArray]
    mov edx, 1
    call IsInArray
    pop bx
    pop esi
    
    jc .done ; if carry, it knows an HM
    
    dec bh
    jnz .loop
    
    clc
.done:
    ret

; -----------------------------------------------------------------------------
; BillsPCDepositLogic
; Abstracted logic for depositing a Pokemon into the box.
; Returns C flag if the party is empty or the box is full.
; -----------------------------------------------------------------------------
BillsPCDepositLogic:
    mov al, byte [ebp + W_PARTY_COUNT]
    dec al
    jz .fail
    
    mov al, byte [ebp + W_BOX_COUNT]
    cmp al, MONS_PER_BOX
    jz .fail
    
    mov byte [ebp + W_MOVE_MON_TYPE], PARTY_TO_BOX
    call MoveMon
    
    mov byte [ebp + W_REMOVE_MON_FROM_BOX], 0
    call RemovePokemon
    
    clc
    ret
.fail:
    stc
    ret

; -----------------------------------------------------------------------------
; BillsPCWithdrawLogic
; Abstracted logic for withdrawing a Pokemon into the party.
; Returns C flag if the box is empty or the party is full.
; -----------------------------------------------------------------------------
BillsPCWithdrawLogic:
    mov al, byte [ebp + W_BOX_COUNT]
    test al, al
    jz .fail
    
    mov al, byte [ebp + W_PARTY_COUNT]
    cmp al, PARTY_LENGTH
    jz .fail
    
    mov byte [ebp + W_MOVE_MON_TYPE], BOX_TO_PARTY
    call MoveMon
    
    mov byte [ebp + W_REMOVE_MON_FROM_BOX], 1
    call RemovePokemon
    
    clc
    ret
.fail:
    stc
    ret

; -----------------------------------------------------------------------------
; BillsPCReleaseLogic
; Abstracted logic for releasing a Pokemon from the box.
; Returns C flag if the box is empty.
; -----------------------------------------------------------------------------
BillsPCReleaseLogic:
    mov al, byte [ebp + W_BOX_COUNT]
    test al, al
    jz .fail
    
    mov byte [ebp + W_REMOVE_MON_FROM_BOX], 1
    call RemovePokemon
    
    clc
    ret
.fail:
    stc
    ret

section .data

HMMoveArray:
    db CUT
    db FLY
    db SURF
    db STRENGTH
    db FLASH
    db 0xFF ; end
