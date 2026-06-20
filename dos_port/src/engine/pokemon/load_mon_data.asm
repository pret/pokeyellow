%include "dos_port/include/gb_memmap.inc"
%include "dos_port/include/gb_constants.inc"

SECTION .text

global LoadMonData_
global GetMonSpecies

extern GetMonHeader
extern AddNTimes
extern CopyData

LoadMonData_:
    ; Load monster [wWhichPokemon] from list [wMonDataLocation]:
    ;  0: partymon
    ;  1: enemymon
    ;  2: boxmon
    ;  3: daycaremon
    ; Return monster id at wCurPartySpecies and its data at wLoadedMon.
    ; Also load base stats at wMonHeader for convenience.

    mov al, [ebp + wDayCareMonSpecies]
    mov [ebp + wCurPartySpecies], al
    mov al, [ebp + wMonDataLocation]
    cmp al, DAYCARE_DATA
    jz .GetMonHeader

    mov al, [ebp + wWhichPokemon]
    mov dl, al ; ld e, a
    call GetMonSpecies

.GetMonHeader:
    mov al, [ebp + wCurPartySpecies]
    mov [ebp + wCurSpecies], al
    call GetMonHeader

    mov esi, wPartyMons
    mov bx, PARTYMON_STRUCT_LENGTH
    mov al, [ebp + wMonDataLocation]
    cmp al, ENEMY_PARTY_DATA
    jc .getMonEntry

    mov esi, wEnemyMons
    jz .getMonEntry

    cmp al, BOX_DATA
    mov esi, wBoxMons
    mov bx, BOXMON_STRUCT_LENGTH
    jz .getMonEntry

    mov esi, wDayCareMon
    jmp .copyMonData

.getMonEntry:
    mov al, [ebp + wWhichPokemon]
    call AddNTimes

.copyMonData:
    mov edx, wLoadedMon
    mov bx, PARTYMON_STRUCT_LENGTH
    jmp CopyData

; get species of mon e in list [wMonDataLocation] for LoadMonData
GetMonSpecies:
    mov esi, wPartySpecies
    mov al, [ebp + wMonDataLocation]
    test al, al
    jz .getSpecies
    dec al
    jz .enemyParty
    mov esi, wBoxSpecies
    jmp .getSpecies
.enemyParty:
    mov esi, wEnemyPartySpecies
.getSpecies:
    movzx edx, dl
    add esi, edx ; d = 0, add hl, de -> add esi, edx
    mov al, [ebp + esi]
    mov [ebp + wCurPartySpecies], al
    ret
