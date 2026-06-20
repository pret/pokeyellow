; dos_port/engine/pokemon/add_mon.asm
global AddPartyMon_WriteMovePP
global _AddEnemyMonToPlayerParty
global _MoveMon

extern AddNTimes
extern FarCopyData
extern wMoveData
extern Moves
extern wPartyCount
extern wCurPartySpecies
extern wPartyMons
extern wLoadedMon
extern CopyData
extern wPartyMonOT
extern SkipFixedLengthTextEntries
extern wEnemyMonOT
extern wWhichPokemon
extern wPartyMonNicks
extern wEnemyMonNicks
extern wPokedexNum
extern IndexToPokedex
extern wPokedexOwned
extern FlagAction
extern wPokedexSeen
extern wMoveMonType
extern wDayCareMon
extern wBoxCount
extern wBoxMons
extern wDayCareMonOT
extern wBoxMonOT
extern wDayCareMonName
extern wBoxMonNicks
extern wMonDataLocation
extern LoadMonData
extern CalcLevelFromExperience
extern wCurEnemyLevel
extern CalcStats

; Constants
extern NUM_MOVES
extern MOVE_LENGTH
extern MOVE_PP
extern BANK_Moves
extern PARTY_LENGTH
extern PARTYMON_STRUCT_LENGTH
extern NAME_LENGTH
extern FLAG_SET
extern DAYCARE_TO_PARTY
extern PARTY_TO_DAYCARE
extern PARTY_TO_BOX
extern MONS_PER_BOX
extern BOXMON_STRUCT_LENGTH
extern MON_HP_EXP
extern MON_STATS

section .text

; INPUTS:
; ESI (HL) = pointer to moves array
; EDI (DE) = pointer to 1 byte BEFORE the destination PP array
AddPartyMon_WriteMovePP:
    mov bl, NUM_MOVES
.pploop:
    mov al, [ebp + esi]
    inc esi
    test al, al
    jz .empty
    
    dec al
    
    push esi
    push edi
    push bx
    
    mov esi, Moves
    mov bx, MOVE_LENGTH
    call AddNTimes
    
    mov dx, wMoveData
    call FarCopyData
    
    pop bx
    pop edi
    pop esi
    
    mov al, [ebp + wMoveData + MOVE_PP]
.empty:
    inc edi
    mov [ebp + edi], al
    dec bl
    jnz .pploop
    ret

_AddEnemyMonToPlayerParty:
    mov esi, wPartyCount
    mov al, [ebp + esi]
    cmp al, PARTY_LENGTH
    jz .partyFull
    
    inc al
    mov [ebp + esi], al
    mov cl, al
    movzx ecx, cl
    mov edx, esi
    add edx, ecx
    
    mov al, [ebp + wCurPartySpecies]
    mov [ebp + edx], al
    inc edx
    mov byte [ebp + edx], 0xff
    
    mov esi, wPartyMons
    mov al, [ebp + wPartyCount]
    dec al
    mov bx, PARTYMON_STRUCT_LENGTH
    call AddNTimes
    
    mov edx, esi
    mov esi, wLoadedMon
    mov bx, PARTYMON_STRUCT_LENGTH
    call CopyData
    
    mov esi, wPartyMonOT
    mov al, [ebp + wPartyCount]
    dec al
    call SkipFixedLengthTextEntries
    mov edx, esi
    
    mov esi, wEnemyMonOT
    mov al, [ebp + wWhichPokemon]
    call SkipFixedLengthTextEntries
    mov bx, NAME_LENGTH
    call CopyData
    
    mov esi, wPartyMonNicks
    mov al, [ebp + wPartyCount]
    dec al
    call SkipFixedLengthTextEntries
    mov edx, esi
    
    mov esi, wEnemyMonNicks
    mov al, [ebp + wWhichPokemon]
    call SkipFixedLengthTextEntries
    mov bx, NAME_LENGTH
    call CopyData
    
    mov al, [ebp + wCurPartySpecies]
    mov [ebp + wPokedexNum], al
    
    call IndexToPokedex
    
    mov al, [ebp + wPokedexNum]
    dec al
    mov cl, al
    mov bl, FLAG_SET
    mov esi, wPokedexOwned
    push cx
    push bx
    call FlagAction
    pop bx
    pop cx
    mov esi, wPokedexSeen
    call FlagAction
    
    clc
    ret

.partyFull:
    stc
    ret

_MoveMon:
    mov al, [ebp + wMoveMonType]
    test al, al ; BOX_TO_PARTY
    jz .checkPartyMonSlots
    cmp al, DAYCARE_TO_PARTY
    jz .checkPartyMonSlots
    cmp al, PARTY_TO_DAYCARE
    mov esi, wDayCareMon
    jz .findMonDataSrc
    
    ; PARTY_TO_BOX
    mov esi, wBoxCount
    mov al, [ebp + esi]
    cmp al, MONS_PER_BOX
    jnz .partyOrBoxNotFull
    jmp .boxFull
    
.checkPartyMonSlots:
    mov esi, wPartyCount
    mov al, [ebp + esi]
    cmp al, PARTY_LENGTH
    jnz .partyOrBoxNotFull

.boxFull:
    stc
    ret

.partyOrBoxNotFull:
    inc al
    mov [ebp + esi], al
    mov cl, al
    movzx ecx, cl
    mov edx, esi
    add edx, ecx
    
    mov al, [ebp + wMoveMonType]
    cmp al, DAYCARE_TO_PARTY
    mov al, [ebp + wDayCareMon]
    jz .copySpecies
    mov al, [ebp + wCurPartySpecies]
.copySpecies:
    mov [ebp + edx], al
    inc edx
    mov byte [ebp + edx], 0xff
    
    mov al, [ebp + wMoveMonType]
    dec al
    mov esi, wPartyMons
    mov bx, PARTYMON_STRUCT_LENGTH
    mov al, [ebp + wPartyCount]
    jnz .addMonOffset
    
    mov esi, wBoxMons
    mov bx, BOXMON_STRUCT_LENGTH
    mov al, [ebp + wBoxCount]
.addMonOffset:
    dec al
    call AddNTimes
    
.findMonDataSrc:
    push esi
    mov edx, esi
    mov al, [ebp + wMoveMonType]
    test al, al
    mov esi, wBoxMons
    mov bx, BOXMON_STRUCT_LENGTH
    jz .addMonOffset2
    
    cmp al, DAYCARE_TO_PARTY
    mov esi, wDayCareMon
    jz .copyMonData
    
    mov esi, wPartyMons
    mov bx, PARTYMON_STRUCT_LENGTH
.addMonOffset2:
    mov al, [ebp + wWhichPokemon]
    call AddNTimes
    
.copyMonData:
    push esi
    push dx
    mov bx, BOXMON_STRUCT_LENGTH
    call CopyData
    pop dx
    pop esi
    
    mov al, [ebp + wMoveMonType]
    test al, al
    jz .findOTdest
    cmp al, DAYCARE_TO_PARTY
    jz .findOTdest
    
    movzx eax, word BOXMON_STRUCT_LENGTH
    add esi, eax
    mov al, [ebp + esi] ; Level
    
    add edx, 3
    mov [ebp + edx], al
    
.findOTdest:
    mov al, [ebp + wMoveMonType]
    cmp al, PARTY_TO_DAYCARE
    mov edx, wDayCareMonOT
    jz .findOTsrc
    
    dec al
    mov esi, wPartyMonOT
    mov al, [ebp + wPartyCount]
    jnz .addOToffset
    mov esi, wBoxMonOT
    mov al, [ebp + wBoxCount]
.addOToffset:
    dec al
    call SkipFixedLengthTextEntries
    mov edx, esi

.findOTsrc:
    mov esi, wBoxMonOT
    mov al, [ebp + wMoveMonType]
    test al, al
    jz .addOToffset2
    
    mov esi, wDayCareMonOT
    cmp al, DAYCARE_TO_PARTY
    jz .copyOT
    mov esi, wPartyMonOT
.addOToffset2:
    mov al, [ebp + wWhichPokemon]
    call SkipFixedLengthTextEntries
.copyOT:
    mov bx, NAME_LENGTH
    call CopyData
    
    mov al, [ebp + wMoveMonType]
    cmp al, PARTY_TO_DAYCARE
    mov edx, wDayCareMonName
    jz .findNickSrc
    
    dec al
    mov esi, wPartyMonNicks
    mov al, [ebp + wPartyCount]
    jnz .addNickOffset
    
    mov esi, wBoxMonNicks
    mov al, [ebp + wBoxCount]
.addNickOffset:
    dec al
    call SkipFixedLengthTextEntries
    mov edx, esi
    
.findNickSrc:
    mov esi, wBoxMonNicks
    mov al, [ebp + wMoveMonType]
    test al, al
    jz .addNickOffset2
    
    mov esi, wDayCareMonName
    cmp al, DAYCARE_TO_PARTY
    jz .copyNick
    mov esi, wPartyMonNicks
.addNickOffset2:
    mov al, [ebp + wWhichPokemon]
    call SkipFixedLengthTextEntries
.copyNick:
    mov bx, NAME_LENGTH
    call CopyData
    
    pop esi ; was saved at start of findMonDataSrc
    mov al, [ebp + wMoveMonType]
    cmp al, PARTY_TO_BOX
    jz .done
    cmp al, PARTY_TO_DAYCARE
    jz .done
    
    push esi
    shr al, 1
    add al, 2
    mov [ebp + wMonDataLocation], al
    call LoadMonData
    call CalcLevelFromExperience
    mov al, dh
    mov [ebp + wCurEnemyLevel], al
    pop esi
    
    movzx ecx, word BOXMON_STRUCT_LENGTH
    add esi, ecx
    mov [ebp + esi], al
    inc esi
    
    mov edx, esi
    
    movzx ecx, word ((MON_HP_EXP - 1) - MON_STATS)
    add esi, ecx
    mov bl, 1
    call CalcStats
    
.done:
    clc
    ret
