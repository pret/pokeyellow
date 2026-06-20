%include "dos_port/include/gb_memmap.inc"

SECTION .text

global GainExperience
global DivideExpDataByNumMonsGainingExp
global BoostExp
global CallBattleCore

GainExperience:
	mov al, [ebp + wLinkState]
	cmp al, LINK_STATE_BATTLING
	je .return
	call DivideExpDataByNumMonsGainingExp
	mov esi, wPartyMon1
	xor al, al
	mov [ebp + wWhichPokemon], al
.partyMonLoop:
	inc esi
	mov al, [ebp + esi]
	inc esi
	mov ah, [ebp + esi]
	or al, ah
	jz .nextMon
	push esi
	mov esi, wPartyGainExpFlags
	mov al, [ebp + wWhichPokemon]
	mov cl, al
	mov bh, FLAG_TEST
	call FlagActionPredef
	mov al, cl
	test al, al
	pop esi
	jz .nextMon
	add esi, (MON_HP_EXP + 1) - (MON_HP + 1)
	mov edi, esi
	mov esi, wEnemyMonBaseStats
	mov cl, NUM_STATS
.gainStatExpLoop:
	mov al, [ebp + esi]
	inc esi
	mov bh, al
	mov al, [ebp + edi]
	add al, bh
	mov [ebp + edi], al
	jnc .nextBaseStat
	dec edi
	mov al, [ebp + edi]
	inc al
	jz .maxStatExp
	mov [ebp + edi], al
	inc edi
	jmp .nextBaseStat
.maxStatExp:
	dec al
	mov [ebp + edi], al
	inc edi
	mov [ebp + edi], al
.nextBaseStat:
	dec cl
	jz .statExpDone
	inc edi
	inc edi
	jmp .gainStatExpLoop
.statExpDone:
	xor al, al
	mov [ebp + hMultiplicand], al
	mov [ebp + hMultiplicand + 1], al
	mov al, [ebp + wEnemyMonBaseExp]
	mov [ebp + hMultiplicand + 2], al
	mov al, [ebp + wEnemyMonLevel]
	mov [ebp + hMultiplier], al
	call Multiply
	mov al, 7
	mov [ebp + hDivisor], al
	mov bh, 4
	call Divide
	mov esi, edi
	add esi, MON_OTID - (MON_DVS - 1)
	mov bh, [ebp + esi]
	inc esi
	mov al, [ebp + wPlayerID]
	cmp al, bh
	jne .tradedMon
	mov bh, [ebp + esi]
	mov al, [ebp + wPlayerID + 1]
	cmp al, bh
	mov al, 0
	je .next
.tradedMon:
	call BoostExp
	mov al, 1
.next:
	mov [ebp + wGainBoostedExp], al
	mov al, [ebp + wIsInBattle]
	dec al
	jz .noBoost
	call BoostExp
.noBoost:
	inc esi
	inc esi
	inc esi
	mov bh, [ebp + esi]
	mov al, [ebp + hQuotient + 3]
	mov [ebp + wExpAmountGained + 1], al
	add al, bh
	mov [ebp + esi], al
	dec esi
	mov bh, [ebp + esi]
	mov al, [ebp + hQuotient + 2]
	mov [ebp + wExpAmountGained], al
	adc al, bh
	mov [ebp + esi], al
	jnc .noCarry
	dec esi
	inc byte [ebp + esi]
	inc esi
.noCarry:
	inc esi
	push esi
	mov al, [ebp + wWhichPokemon]
	movzx ecx, al
	mov esi, wPartySpecies
	add esi, ecx
	mov al, [ebp + esi]
	mov [ebp + wCurSpecies], al
	call GetMonHeader
	mov dh, MAX_LEVEL
	call CalcExperience
	mov al, [ebp + hExperience]
	mov bh, al
	mov al, [ebp + hExperience + 1]
	mov cl, al
	mov al, [ebp + hExperience + 2]
	mov dh, al
	pop esi
	mov al, [ebp + esi]
	dec esi
	sub al, dh
	mov al, [ebp + esi]
	dec esi
	sbc al, cl
	mov al, [ebp + esi]
	sbc al, bh
	jc .next2
	mov al, bh
	mov [ebp + esi], al
	inc esi
	mov al, cl
	mov [ebp + esi], al
	inc esi
	mov al, dh
	mov [ebp + esi], al
	dec esi
.next2:
	push esi
	mov al, [ebp + wWhichPokemon]
	mov esi, wPartyMonNicks
	call GetPartyMonName
	mov esi, GainedText
	call PrintText
	xor al, al
	mov [ebp + wMonDataLocation], al
	call LoadMonData
	pop esi
	add esi, MON_LEVEL - MON_EXP
	push esi
	call CalcLevelFromExperience
	pop esi
	mov al, [ebp + esi]
	cmp al, dh
	je .nextMon_jump
	mov al, [ebp + wCurEnemyLevel]
	push eax
	push esi
	mov al, dh
	mov [ebp + wCurEnemyLevel], al
	mov [ebp + esi], al
	add esi, MON_SPECIES - MON_LEVEL
	mov al, [ebp + esi]
	mov [ebp + wCurSpecies], al
	mov [ebp + wPokedexNum], al
	call GetMonHeader
	add esi, (MON_MAXHP + 1) - MON_SPECIES
	push esi
	mov al, [ebp + esi]
	dec esi
	mov cl, al
	mov bh, [ebp + esi]
	push ebx
	mov edi, esi
	add esi, (MON_HP_EXP - 1) - MON_MAXHP
	mov bh, 1
	call CalcStats
	pop ebx
	pop esi
	mov al, [ebp + esi]
	dec esi
	sub al, cl
	mov cl, al
	mov al, [ebp + esi]
	sbc al, bh
	mov bh, al
	add esi, (MON_HP + 1) - MON_MAXHP
	mov al, [ebp + esi]
	add al, cl
	mov [ebp + esi], al
	dec esi
	mov al, [ebp + esi]
	adc al, bh
	mov [ebp + esi], al
	mov al, [ebp + wPlayerMonNumber]
	mov bh, al
	mov al, [ebp + wWhichPokemon]
	cmp al, bh
	jne .printGrewLevelText
	mov edi, wBattleMonHP
	mov al, [ebp + esi]
	inc esi
	mov [ebp + edi], al
	inc edi
	mov al, [ebp + esi]
	mov [ebp + edi], al
	add esi, MON_LEVEL - (MON_HP + 1)
	push esi
	mov edi, wBattleMonLevel
	mov cx, 1 + NUM_STATS * 2
	call CopyData
	pop esi
	mov al, [ebp + wPlayerBattleStatus3]
	test al, 1 << TRANSFORMED
	jnz .recalcStatChanges
	mov edi, wPlayerMonUnmodifiedLevel
	mov cx, 1 + NUM_STATS * 2
	call CopyData
.recalcStatChanges:
	xor al, al
	mov [ebp + wCalculateWhoseStats], al
	mov esi, CalculateModifiedStats
	call CallBattleCore
	mov esi, ApplyBurnAndParalysisPenaltiesToPlayer
	call CallBattleCore
	mov esi, ApplyBadgeStatBoosts
	call CallBattleCore
	mov esi, DrawPlayerHUDAndHPBar
	call CallBattleCore
	mov esi, PrintEmptyString
	call CallBattleCore
	call SaveScreenTilesToBuffer1
.printGrewLevelText:
	; farcall_ModifyPikachuHappiness PIKAHAPPY_LEVELUP
	mov al, PIKAHAPPY_LEVELUP
	call ModifyPikachuHappiness
	mov esi, GrewLevelText
	call PrintText
	xor al, al
	mov [ebp + wMonDataLocation], al
	call LoadMonData
	mov dh, LEVEL_UP_STATS_BOX
	call PrintStatsBox
	call WaitForTextScrollButtonPress
	call LoadScreenTilesFromBuffer1
	xor al, al
	mov [ebp + wMonDataLocation], al
	mov al, [ebp + wCurSpecies]
	mov [ebp + wPokedexNum], al
	call LearnMoveFromLevelUp
	mov esi, wCanEvolveFlags
	mov al, [ebp + wWhichPokemon]
	mov cl, al
	mov bh, FLAG_SET
	call FlagActionPredef
	pop esi
	pop eax
	mov [ebp + wCurEnemyLevel], al
.nextMon_jump:
	jmp .nextMon
.nextMon:
	mov al, [ebp + wPartyCount]
	mov bh, al
	mov al, [ebp + wWhichPokemon]
	inc al
	cmp al, bh
	je .done
	mov [ebp + wWhichPokemon], al
	mov cx, PARTYMON_STRUCT_LENGTH
	mov esi, wPartyMon1
	call AddNTimes
	jmp .partyMonLoop
.done:
	mov esi, wPartyGainExpFlags
	xor al, al
	mov [ebp + esi], al
	mov al, [ebp + wPlayerMonNumber]
	mov cl, al
	mov bh, FLAG_SET
	push ebx
	call FlagActionPredef
	mov esi, wPartyFoughtCurrentEnemyFlags
	xor al, al
	mov [ebp + esi], al
	pop ebx
	call FlagActionPredef
.return:
	ret

DivideExpDataByNumMonsGainingExp:
	mov al, [ebp + wPartyGainExpFlags]
	mov bh, al
	xor al, al
	mov cl, 8
	mov dh, 0
.countSetBitsLoop:
	shr bh, 1
	adc dh, 0
	dec cl
	jnz .countSetBitsLoop
	cmp dh, 2
	jc .return
	mov [ebp + wTempByteValue], dh
	mov esi, wEnemyMonBaseStats
	mov cl, wEnemyMonBaseExp + 1 - wEnemyMonBaseStats
.divideLoop:
	xor al, al
	mov [ebp + hDividend], al
	mov al, [ebp + esi]
	mov [ebp + hDividend + 1], al
	mov al, [ebp + wTempByteValue]
	mov [ebp + hDivisor], al
	mov bh, 2
	call Divide
	mov al, [ebp + hQuotient + 3]
	mov [ebp + esi], al
	inc esi
	dec cl
	jnz .divideLoop
.return:
	ret

BoostExp:
	mov al, [ebp + hQuotient + 2]
	mov bh, al
	mov al, [ebp + hQuotient + 3]
	mov cl, al
	shr bh, 1
	rcr cl, 1
	add al, cl
	mov [ebp + hQuotient + 3], al
	mov al, [ebp + hQuotient + 2]
	adc al, bh
	mov [ebp + hQuotient + 2], al
	ret

CallBattleCore:
	; ld b, BANK(BattleCore)
	; jp Bankswitch
	call BattleCore
	ret

; Text routines
GainedText:
	; text_far _GainedText
	; text_asm
	mov al, [ebp + wBoostExpByExpAll]
	test al, al
	jnz .withExpAll
	mov al, [ebp + wGainBoostedExp]
	test al, al
	jnz .boosted
	mov esi, ExpPointsText
	ret
.withExpAll:
	mov esi, WithExpAllText
	ret
.boosted:
	mov esi, BoostedText
	ret

WithExpAllText:
	; text_far _WithExpAllText
	; text_asm
	mov esi, ExpPointsText
	ret

BoostedText:
	; text_far _BoostedText
	ret

ExpPointsText:
	; text_far _ExpPointsText
	ret

GrewLevelText:
	; text_far _GrewLevelText
	; sound_level_up
	ret
