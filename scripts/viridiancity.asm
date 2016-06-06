ViridianCityScript: ; 1902a (6:502a)
	call EnableAutoTextBoxDrawing
	ld hl, ViridianCityScriptPointers
	ld a, [W_VIRIDIANCITYCURSCRIPT]
	call JumpTable
	ret

ViridianCityScriptPointers: ; 19037 (6:5037)
	dw ViridianCityScript0  ; 1904d
	dw ViridianCityScript1  ; 19054
	dw ViridianCityScript2  ; 19057
	dw ViridianCityScript3  ; 190ca
	dw ViridianCityScript4  ; 19104
	dw ViridianCityScript5  ; 1913f
	dw ViridianCityScript6  ; 1909d
	dw ViridianCityScript7  ; 19191
	dw ViridianCityScript8  ; 191a7
	dw ViridianCityScript9  ; 191cf
	dw ViridianCityScript10 ; 191f9

ViridianCityScript0:
	call ViridianCityScript_1905b
	call ViridianCityScript_190ab
	ret

ViridianCityScript1:  ; 19054
	call ViridianCityScript_19162
ViridianCityScript2:  ; 19057
	call ViridianCityScript_1905b
	ret

ViridianCityScript_1905b:
	CheckEvent EVENT_VIRIDIAN_GYM_OPEN
	ret nz
	ld a, [wObtainedBadges]
	cp $7f ; all but Earthbadge
	jr nz, .asm_1906e
	SetEvent EVENT_VIRIDIAN_GYM_OPEN
	ret

.asm_1906e
	ld a, [wYCoord]
	cp 8
	ret nz
	ld a, [wXCoord]
	cp 32
	ret nz
	ld a, $f
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	call StartSimulatingJoypadStates
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, D_DOWN
	ld [wSimulatedJoypadStatesEnd], a
	xor a
	ld [wPlayerFacingDirection], a
	ld [wJoyIgnore], a
	ld [hJoyHeld], a
	ld a, $6
	ld [W_VIRIDIANCITYCURSCRIPT], a
	ret

ViridianCityScript6:  ; 1909d
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	ld a, $2
	ld [W_VIRIDIANCITYCURSCRIPT], a
	ret

ViridianCityScript_190ab:
	ld a, [wYCoord]
	cp 9
	ret nz
	ld a, [wXCoord]
	cp 19
	ret nz
	ld a, $5
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
	ld [hJoyHeld], a
	call ViridianCityScript_1914d
	ld a, $5
	ld [W_VIRIDIANCITYCURSCRIPT], a
	ret

ViridianCityScript3:  ; 190ca
	call ViridianCityScript_190ef
	call ViridianCityScript_190db
	ResetEvent EVENT_02F
	ld a, $4
	ld [W_VIRIDIANCITYCURSCRIPT], a
	ret

ViridianCityScript_190db:
	xor a
	ld [wListScrollOffset], a
	ld a, OLD_MAN_BATTLE
	ld [wBattleType], a
	ld a, 5
	ld [wCurEnemyLVL], a
	ld a, RATTATA
	ld [wCurOpponent], a
	ret

ViridianCityScript_190ef:
	ld a, [wSpriteStateData1 + 3 * $10 + 4]
	ld [$ffeb], a
	ld a, [wSpriteStateData1 + 3 * $10 + 6]
	ld [$ffec], a
	ld a, [wSpriteStateData2 + 3 * $10 + 4]
	ld [$ffed], a
	ld a, [wSpriteStateData2 + 3 * $10 + 5]
	ld [$ffee], a
	ret

ViridianCityScript4:  ; 19104
	call ViridianCityScript_1912a
	call UpdateSprites
	call Delay3
	SetEvent EVENT_02E
	xor a
	ld [wJoyIgnore], a
	ld a, $10
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
	ld [wBattleType], a
	ld [wJoyIgnore], a
	ld a, $2
	ld [W_VIRIDIANCITYCURSCRIPT], a
	ret

ViridianCityScript_1912a:
	ld a, [$ffeb]
	ld [wSpriteStateData1 + 3 * $10 + 4], a
	ld a, [$ffec]
	ld [wSpriteStateData1 + 3 * $10 + 6], a
	ld a, [$ffed]
	ld [wSpriteStateData2 + 3 * $10 + 4], a
	ld a, [$ffee]
	ld [wSpriteStateData2 + 3 * $10 + 5], a
	ret

ViridianCityScript5:  ; 1913f
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	ld a, $0
	ld [W_VIRIDIANCITYCURSCRIPT], a
	ret

ViridianCityScript_1914d:
	call StartSimulatingJoypadStates
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, D_DOWN
	ld [wSimulatedJoypadStatesEnd], a
	xor a
	ld [wPlayerFacingDirection], a
	ld [wJoyIgnore], a
	ret

ViridianCityScript_19162:
	CheckEvent EVENT_02D
	ret nz
	ld a, [wYCoord]
	cp 9
	ret nz
	ld a, [wXCoord]
	cp 19
	ret nz
	ld a, $8
	ld [hSpriteIndexOrTextID], a
	ld a, SPRITE_FACING_RIGHT
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $8
	ld [wPlayerFacingDirection], a
	ld a, $8
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, D_UP | D_DOWN | D_LEFT | D_RIGHT | START | SELECT
	ld [wJoyIgnore], a
	ret

ViridianCityScript7:  ; 19191
	call ViridianCityScript_190ef
	call ViridianCityScript_190db
	SetEvent EVENT_02F
	ld a, D_UP | D_DOWN | D_LEFT | D_RIGHT | START | SELECT
	ld [wJoyIgnore], a
	ld a, $8
	ld [W_VIRIDIANCITYCURSCRIPT], a
	ret

ViridianCityScript8:  ; 191a7
	call ViridianCityScript_1912a
	call UpdateSprites
	call Delay3
	SetEvent EVENT_02D
	ld a, D_UP | D_DOWN | D_LEFT | D_RIGHT | START | SELECT
	ld [wJoyIgnore], a
	ld a, $8
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
	ld [wBattleType], a
	dec a
	ld [wJoyIgnore], a
	ld a, $9
	ld [W_VIRIDIANCITYCURSCRIPT], a
	ret

ViridianCityScript9:  ; 191cf
	ld de, ViridianCityOldManMovementData2
	ld a, [wXCoord]
	cp 19
	jr z, .asm_191e4
	callab Func_f1a01
	ld de, ViridianCityOldManMovementData1
.asm_191e4
	ld a, $8
	ld [hSpriteIndexOrTextID], a
	call MoveSprite
	ld a, $a
	ld [W_VIRIDIANCITYCURSCRIPT], a
	ret

ViridianCityOldManMovementData1:
	db NPC_MOVEMENT_RIGHT
ViridianCityOldManMovementData2:
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db $ff

ViridianCityScript10: ; 191f9
	ld a, [wd730]
	bit 0, a
	ret nz
	ld a, $3
	ld [wMissableObjectIndex], a
	predef HideObject
	xor a
	ld [wJoyIgnore], a
	ld a, $2
	ld [W_VIRIDIANCITYCURSCRIPT], a
	ret

ViridianCityTextPointers:
	dw ViridianCityText_0 ; 19233
	dw ViridianCityText_1 ; 1923f
	dw ViridianCityText_2 ; 1924b
	dw ViridianCityText_3 ; 19257
	dw ViridianCityText_4 ; 19263
	dw ViridianCityText_5 ; 1926f
	dw ViridianCityText_6 ; 1927b
	dw ViridianCityText_7 ; 1928c
	dw ViridianCityText_8 ; 192b9
	dw ViridianCityText_9 ; 192c5
	dw ViridianCityText_10 ; 192d1
	dw MartSignText ; 23e5
	dw PokeCenterSignText ; 23ea
	dw ViridianCityText_11 ; 192dd
	dw ViridianCityText_12 ; 192e9
	dw ViridianCityText_13 ; 19287

ViridianCityText_0:
	TX_ASM
	callba Func_f18bb
	jp TextScriptEnd

ViridianCityText_1:
	TX_ASM
	callba Func_f18c7
	jp TextScriptEnd

ViridianCityText_2:
	TX_ASM
	callba Func_f18e9
	jp TextScriptEnd

ViridianCityText_3:
	TX_ASM
	callba Func_f1911
	jp TextScriptEnd

ViridianCityText_4:
	TX_ASM
	callba Func_f192c
	jp TextScriptEnd

ViridianCityText_5:
	TX_ASM
	callba Func_f194a
	jp TextScriptEnd

ViridianCityText_6:
	TX_ASM
	callba Func_f198e
	jp TextScriptEnd

ViridianCityText_13:
	TX_FAR _ViridianCityText_19219
	db "@"

ViridianCityText_7:
	TX_ASM
	CheckEvent EVENT_02D
	jr nz, .asm_192a6
	ld hl, ViridianCityText_192af
	call PrintText
	ld c, 2
	call DelayFrames
	ld a, $7
	ld [W_VIRIDIANCITYCURSCRIPT], a
	jr .asm_192ac

.asm_192a6
	ld hl, ViridianCityText_192b4
	call PrintText
.asm_192ac
	jp TextScriptEnd

ViridianCityText_192af:
	TX_FAR _ViridianCityText_1920a
	db "@"

ViridianCityText_192b4:
	TX_FAR _OldManTextAfterBattle
	db "@"

ViridianCityText_8:
	TX_ASM
	callba Func_f19c5
	jp TextScriptEnd

ViridianCityText_9:
	TX_ASM
	callba Func_f19d1
	jp TextScriptEnd

ViridianCityText_10:
	TX_ASM
	callba Func_f19dd
	jp TextScriptEnd

ViridianCityText_11:
	TX_ASM
	callba Func_f19e9
	jp TextScriptEnd

ViridianCityText_12:
	TX_ASM
	callba Func_f19f5
	jp TextScriptEnd
