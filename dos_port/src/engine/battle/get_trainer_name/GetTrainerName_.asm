; ╔══════════════════════════════════════════════════════════╗
; ║              PKMNDOS TRANSLATION MANIFEST               ║
; ╚══════════════════════════════════════════════════════════╝
; queue_id   : 1728
; label      : GetTrainerName_
; source     : engine/battle/get_trainer_name.asm
; category   : simple
; scratch    : dos_port/scratch/1728__GetTrainerName_.asm
; -----------------------------------------------------------
; target      : dos_port/src/engine/battle/get_trainer_name/GetTrainerName_.asm
; aggregator  : dos_port/src/engine/battle/get_trainer_name.asm
; -----------------------------------------------------------
; WORKER NOTES — fill in before calling work_queue complete
; registers   : HL→ESI, DE→EDX, BC→BX, A→AL
; hflag       : not involved
; bug_tags    : none
; notes       : W_RIVAL_NAME equ 0xD349 used; defined dummy constants for RIVAL1, etc.
; ╔══════════════════════════════════════════════════════════╗
; ║  CODE BELOW — do not modify the header above            ║
; ╚══════════════════════════════════════════════════════════╝

global GetTrainerName_

W_RIVAL_NAME equ 0xD349
RIVAL1 equ 0x19
RIVAL2 equ 0x2A
RIVAL3 equ 0x2B
TRAINER_NAME equ 7
TRAINER_NAME_LENGTH equ 13

extern wLinkEnemyTrainerName
extern wLinkState
extern wTrainerClass
extern wNameListIndex
extern wNameListType
extern wPredefBank
extern wNameBuffer
extern wTrainerName
extern TrainerNames
extern GetName
extern CopyData

GetTrainerName_:
    mov esi, wLinkEnemyTrainerName
    mov al, byte [ebp + wLinkState]
    and al, al
    jnz .foundName
    mov esi, W_RIVAL_NAME
    mov al, byte [ebp + wTrainerClass]
    cmp al, RIVAL1
    jz .foundName
    cmp al, RIVAL2
    jz .foundName
    cmp al, RIVAL3
    jz .foundName
    mov byte [ebp + wNameListIndex], al
    mov al, TRAINER_NAME
    mov byte [ebp + wNameListType], al
    mov al, 0 ; BANK(TrainerNames) stub
    mov byte [ebp + wPredefBank], al
    call GetName
    mov esi, wNameBuffer
.foundName:
    mov edx, wTrainerName
    mov bx, TRAINER_NAME_LENGTH
    jmp CopyData
