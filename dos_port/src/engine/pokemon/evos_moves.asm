%include "dos_port/include/gb_memmap.inc"

SECTION .text

global TryEvolvingMon
global EvolutionAfterBattle
global RenameEvolvedMon
global CancelledEvolution
global LearnMoveFromLevelUp
global Func_3b079
global Func_3b0a2
global Func_3b10f
global WriteMonMoves
global WriteMonMoves_ShiftMoveData
global Evolution_FlagAction
global GetMonLearnset

TryEvolvingMon:
	mov esi, wCanEvolveFlags
	xor al, al
	mov [ebp + esi], al
	mov al, [ebp + wWhichPokemon]
	mov cl, al
	mov bh, FLAG_SET
	call Evolution_FlagAction

EvolutionAfterBattle:
	mov al, [ebp + hTileAnimations]
	push eax
	xor al, al
	mov [ebp + wEvolutionOccurred], al
	dec al
	mov [ebp + wWhichPokemon], al
	push esi
	push ebx
	push edx
	mov esi, wPartyCount
	push esi

.Evolution_PartyMonLoop:
	mov esi, wWhichPokemon
	inc byte [ebp + esi]
	pop esi
	inc esi
	mov al, [ebp + esi]
	cmp al, 0xFF
	je .done
	mov [ebp + wEvoOldSpecies], al
	push esi
	mov al, [ebp + wWhichPokemon]
	mov cl, al
	mov esi, wCanEvolveFlags
	mov bh, FLAG_TEST
	call Evolution_FlagAction
	mov al, cl
	test al, al
	jz .Evolution_PartyMonLoop
	
	mov al, [ebp + wEvoOldSpecies]
	dec al
	mov esi, EvosMovesPointerTable
	movzx eax, al
	shl eax, 1
	add esi, eax
	mov al, [esi]
	inc esi
	mov ah, [esi]
	movzx esi, ax
	
	push esi
	mov al, [ebp + wCurPartySpecies]
	push eax
	xor al, al
	mov [ebp + wMonDataLocation], al
	call LoadMonData
	pop eax
	mov [ebp + wCurPartySpecies], al
	pop esi

.evoEntryLoop:
	mov al, [esi]
	inc esi
	test al, al
	jz .Evolution_PartyMonLoop
	mov bh, al
	cmp al, EVOLVE_TRADE
	je .checkTradeEvo
	mov al, [ebp + wLinkState]
	cmp al, LINK_STATE_TRADING
	je .Evolution_PartyMonLoop
	mov al, bh
	cmp al, EVOLVE_ITEM
	je .checkItemEvo
	mov al, [ebp + wForceEvolution]
	test al, al
	jnz .Evolution_PartyMonLoop
	mov al, bh
	cmp al, EVOLVE_LEVEL
	je .checkLevel
	
.checkTradeEvo:
	mov al, [ebp + wLinkState]
	cmp al, LINK_STATE_TRADING
	jne .nextEvoEntry1
	mov al, [esi]
	inc esi
	mov bh, al
	mov al, [ebp + wLoadedMonLevel]
	cmp al, bh
	jc .Evolution_PartyMonLoop
	jmp .doEvolution
	
.checkItemEvo:
	mov al, [ebp + wIsInBattle]
	test al, al
	mov al, [esi]
	inc esi
	jnz .nextEvoEntry1
	mov bh, al
	mov al, [ebp + wCurItem]
	cmp al, bh
	jne .nextEvoEntry1
.checkLevel:
	mov al, [esi]
	inc esi
	mov bh, al
	mov al, [ebp + wLoadedMonLevel]
	cmp al, bh
	jc .nextEvoEntry2

.doEvolution:
	mov [ebp + wCurEnemyLevel], al
	mov al, 1
	mov [ebp + wEvolutionOccurred], al
	push esi
	mov al, [esi]
	mov [ebp + wEvoNewSpecies], al
	mov al, [ebp + wWhichPokemon]
	mov esi, wPartyMonNicks
	call GetPartyMonName
	call CopyToStringBuffer
	mov cl, 50
	call DelayFrames
	xor al, al
	mov [ebp + hAutoBGTransferEnabled], al
	mov al, 1
	mov [ebp + hAutoBGTransferEnabled], al
	mov al, 0xFF
	mov [ebp + wUpdateSpritesEnabled], al
	call EvolveMon
	jc CancelledEvolution
	pop esi
	mov al, [esi]
	mov [ebp + wCurSpecies], al
	mov [ebp + wLoadedMonSpecies], al
	mov [ebp + wEvoNewSpecies], al
	mov al, MONSTER_NAME
	mov [ebp + wNameListType], al
	mov al, BANK(MonsterNames)
	mov [ebp + wPredefBank], al
	call GetName
	push esi
	mov cl, 40
	call DelayFrames
	call RenameEvolvedMon
	
	mov al, [ebp + wPokedexNum]
	push eax
	mov al, [ebp + wCurSpecies]
	mov [ebp + wPokedexNum], al
	call IndexToPokedex
	mov al, [ebp + wPokedexNum]
	dec al
	mov esi, BaseStats
	mov cx, BASE_DATA_SIZE
	call AddNTimes
	mov edi, wMonHeader
	call CopyData
	mov al, [ebp + wCurSpecies]
	mov [ebp + wMonHIndex], al
	pop eax
	mov [ebp + wPokedexNum], al
	
	mov esi, wLoadedMonHPExp - 1
	mov edi, wLoadedMonStats
	mov bh, 1
	call CalcStats
	
	mov al, [ebp + wWhichPokemon]
	mov esi, wPartyMon1
	mov cx, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	mov edi, esi
	push esi
	push ebx
	add esi, MON_MAXHP
	mov al, [ebp + esi]
	inc esi
	mov bh, al
	mov cl, [ebp + esi]
	mov esi, wLoadedMonMaxHP + 1
	mov al, [ebp + esi]
	dec esi
	sub al, cl
	mov cl, al
	mov al, [ebp + esi]
	sbc al, bh
	mov bh, al
	mov esi, wLoadedMonHP + 1
	mov al, [ebp + esi]
	add al, cl
	mov [ebp + esi], al
	dec esi
	mov al, [ebp + esi]
	adc al, bh
	mov [ebp + esi], al
	dec esi
	pop ebx
	call CopyData
	
	mov al, [ebp + wCurSpecies]
	mov [ebp + wPokedexNum], al
	xor al, al
	mov [ebp + wMonDataLocation], al
	call LearnMoveFromLevelUp
	pop esi
	call SetPartyMonTypes
	
	mov al, [ebp + wIsInBattle]
	test al, al
	
	call IndexToPokedex
	mov al, [ebp + wPokedexNum]
	dec al
	mov cl, al
	mov bh, FLAG_SET
	mov esi, wPokedexOwned
	push ebx
	call Evolution_FlagAction
	pop ebx
	mov esi, wPokedexSeen
	call Evolution_FlagAction
	pop edx
	pop esi
	mov al, [ebp + wLoadedMonSpecies]
	mov [ebp + esi], al
	push esi
	mov esi, edx
	jmp .nextEvoEntry2

.nextEvoEntry1:
	inc esi
.nextEvoEntry2:
	inc esi
	jmp .evoEntryLoop
	
.done:
	pop edx
	pop ebx
	pop esi
	pop eax
	mov [ebp + hTileAnimations], al
	mov al, [ebp + wLinkState]
	cmp al, LINK_STATE_TRADING
	je .return
	mov al, [ebp + wIsInBattle]
	test al, al
	jnz .return
	mov al, [ebp + wEvolutionOccurred]
	test al, al
.return:
	ret

RenameEvolvedMon:
	mov al, [ebp + wCurSpecies]
	push eax
	mov al, [ebp + wMonHIndex]
	mov [ebp + wNameListIndex], al
	call GetName
	pop eax
	mov [ebp + wCurSpecies], al
	mov esi, wNameBuffer
	mov edi, wStringBuffer
.compareNamesLoop:
	mov al, [ebp + edi]
	inc edi
	cmp al, [ebp + esi]
	inc esi
	jne .return
	cmp al, '@'
	jne .compareNamesLoop
	mov al, [ebp + wWhichPokemon]
	mov cx, NAME_LENGTH
	mov esi, wPartyMonNicks
	call AddNTimes
	push esi
	call GetName
	mov esi, wNameBuffer
	pop edi
	jmp CopyData
.return:
	ret

CancelledEvolution:
	pop esi
	jmp EvolutionAfterBattle.Evolution_PartyMonLoop

LearnMoveFromLevelUp:
	mov al, [ebp + wPokedexNum]
	mov [ebp + wCurPartySpecies], al
	call GetMonLearnset
.learnSetLoop:
	mov al, [esi]
	inc esi
	test al, al
	jz .done
	mov bh, al
	mov al, [ebp + wCurEnemyLevel]
	cmp al, bh
	mov al, [esi]
	inc esi
	jne .learnSetLoop
	mov dh, al
	mov al, [ebp + wMonDataLocation]
	test al, al
	jnz .next
	mov esi, wPartyMon1Moves
	mov al, [ebp + wWhichPokemon]
	mov cx, PARTYMON_STRUCT_LENGTH
	call AddNTimes
.next:
	mov bh, NUM_MOVES
.checkCurrentMovesLoop:
	mov al, [ebp + esi]
	inc esi
	cmp al, dh
	je .done
	dec bh
	jnz .checkCurrentMovesLoop
	mov al, dh
	mov [ebp + wMoveNum], al
	mov [ebp + wNamedObjectIndex], al
	call GetMoveName
	call CopyToStringBuffer
	call LearnMove
	mov al, bh
	test al, al
	jz .done
	call IsThisPartyMonStarterPikachu
	jnc .done
	mov al, [ebp + wMoveNum]
	cmp al, THUNDERBOLT
	je .foundThunderOrThunderbolt
	cmp al, THUNDER
	jne .done
.foundThunderOrThunderbolt:
	mov al, 5
	mov [ebp + wPikachuEmotionModifier], al
	mov al, 0x85
	mov [ebp + wPikachuMood], al
.done:
	mov al, [ebp + wCurPartySpecies]
	mov [ebp + wPokedexNum], al
	ret

Func_3b079:
	mov al, [ebp + wCurPartySpecies]
	push eax
	call Func_3b0a2
	jc .asm_3b09c

	call Func_3b10f
	jnc .asm_3b096

	call Func_3b0a2
	jc .asm_3b09c

	call Func_3b10f
	jnc .asm_3b096

	call Func_3b0a2
	jc .asm_3b09c
.asm_3b096:
	pop eax
	mov [ebp + wCurPartySpecies], al
	test al, al
	clc
	ret
.asm_3b09c:
	pop eax
	mov [ebp + wCurPartySpecies], al
	stc
	ret

Func_3b0a2:
	mov al, [ebp + wTempTMHM]
	mov [ebp + wMoveNum], al
	call CanLearnTM
	mov al, cl
	test al, al
	jnz .asm_3b0ec
	mov esi, Pointer_3b0ee
	mov al, [ebp + wCurPartySpecies]
	mov edx, 1
	call IsInArray
	jc .asm_3b0d2
	mov al, 0xFF
	mov [ebp + wMonHGrowthRate], al
	mov al, [ebp + wTempTMHM]
	mov esi, wMonHMoves
	mov edx, 1
	call IsInArray
	jc .asm_3b0ec
.asm_3b0d2:
	mov al, [ebp + wTempTMHM]
	mov dh, al
	call GetMonLearnset
.loop:
	mov al, [esi]
	inc esi
	test al, al
	jz .asm_3b0ea
	mov bh, al
	mov al, [ebp + wCurEnemyLevel]
	cmp al, bh
	jc .asm_3b0ea
	mov al, [esi]
	inc esi
	cmp al, dh
	je .asm_3b0ec
	jmp .loop
.asm_3b0ea:
	test al, al
	clc
	ret
.asm_3b0ec:
	stc
	ret

Func_3b10f:
	mov cl, 0
.asm_3b111:
	mov esi, EvosMovesPointerTable
	mov bh, 0
	movzx ecx, cl
	add esi, ecx
	add esi, ecx
	mov al, [esi]
	inc esi
	mov ah, [esi]
	movzx esi, ax
.asm_3b11b:
	mov al, [esi]
	inc esi
	test al, al
	jz .asm_3b130
	cmp al, 2
	jne .asm_3b124
	inc esi
.asm_3b124:
	inc esi
	mov al, [ebp + wCurPartySpecies]
	cmp al, [esi]
	je .asm_3b138
	inc esi
	mov al, [esi]
	test al, al
	jnz .asm_3b11b
.asm_3b130:
	inc cl
	mov al, cl
	cmp al, VICTREEBEL
	jc .asm_3b111
	test al, al
	clc
	ret
.asm_3b138:
	inc cl
	mov al, cl
	mov [ebp + wCurPartySpecies], al
	stc
	ret

WriteMonMoves:
	call GetPredefRegisters
	push esi
	push edx
	push ebx
	call GetMonLearnset
	jmp .firstMove
.nextMove:
	pop edx
.nextMove2:
	inc esi
.firstMove:
	mov al, [esi]
	inc esi
	test al, al
	jz .done
	mov bh, al
	mov al, [ebp + wCurEnemyLevel]
	cmp al, bh
	jc .done
	mov al, [ebp + wLearningMovesFromDayCare]
	test al, al
	jz .skipMinLevelCheck
	mov al, [ebp + wDayCareStartLevel]
	cmp al, bh
	jnc .nextMove2

.skipMinLevelCheck:
	push edx
	mov cl, NUM_MOVES
.alreadyKnowsCheckLoop:
	mov al, [ebp + edx]
	inc edx
	cmp al, [esi]
	je .nextMove
	dec cl
	jnz .alreadyKnowsCheckLoop

	pop edx
	push edx
	mov cl, NUM_MOVES
.findEmptySlotLoop:
	mov al, [ebp + edx]
	test al, al
	jz .writeMoveToSlot2
	inc edx
	dec cl
	jnz .findEmptySlotLoop

	pop edx
	push edx
	push esi
	mov esi, edx
	call WriteMonMoves_ShiftMoveData
	mov al, [ebp + wLearningMovesFromDayCare]
	test al, al
	jz .writeMoveToSlot

	push edx
	mov cx, MON_PP - (MON_MOVES + 3)
	add esi, ecx
	mov edx, esi
	call WriteMonMoves_ShiftMoveData
	pop edx

.writeMoveToSlot:
	pop esi
.writeMoveToSlot2:
	mov al, [esi]
	mov [ebp + edx], al
	mov al, [ebp + wLearningMovesFromDayCare]
	test al, al
	jz .nextMove

	push esi
	mov al, [esi]
	mov esi, MON_PP - MON_MOVES
	add esi, edx
	push esi
	dec al
	mov esi, Moves
	mov cx, MOVE_LENGTH
	call AddNTimes
	mov edi, wBuffer
	mov al, BANK(Moves)
	call FarCopyData
	mov al, [ebp + wBuffer + 5]
	pop esi
	mov [ebp + esi], al
	pop esi
	jmp .nextMove

.done:
	pop ebx
	pop edx
	pop esi
	ret

WriteMonMoves_ShiftMoveData:
	mov cl, NUM_MOVES - 1
.loop:
	inc edx
	mov al, [ebp + edx]
	mov [ebp + esi], al
	inc esi
	dec cl
	jnz .loop
	ret

Evolution_FlagAction:
	jmp FlagActionPredef

GetMonLearnset:
	mov esi, EvosMovesPointerTable
	mov bh, 0
	mov al, [ebp + wCurPartySpecies]
	dec al
	mov cl, al
	movzx ecx, cl
	add esi, ecx
	add esi, ecx
	mov al, [esi]
	inc esi
	mov ah, [esi]
	movzx esi, ax
.skipEvolutionDataLoop:
	mov al, [esi]
	inc esi
	test al, al
	jnz .skipEvolutionDataLoop
	ret
