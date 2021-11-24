ViridianCity_Script:
	call EnableAutoTextBoxDrawing
	ld hl, ViridianCity_ScriptPointers
	ld a, [wViridianCityCurScript]
	call CallFunctionInTable
	ret

ViridianCity_ScriptPointers:
	dw ViridianCityScript0
	dw ViridianCityScript1
	dw ViridianCityScript2
	dw ViridianCityScript3
	dw ViridianCityScript4
	dw ViridianCityScript5
	dw ViridianCityScript6
	dw ViridianCityScript7
	dw ViridianCityScript8
	dw ViridianCityScript9
	dw ViridianCityScript10

ViridianCityScript0:
	call ViridianCityScript_1905b
	call ViridianCityScript_190ab
	ret

ViridianCityScript1:
	call ViridianCityScript_19162
ViridianCityScript2:
	call ViridianCityScript_1905b
	ret

ViridianCityScript_1905b:
	CheckEvent EVENT_VIRIDIAN_GYM_OPEN
	ret nz
	ld a, [wObtainedBadges]
	cp ~(1 << BIT_EARTHBADGE)
	jr nz, .gym_closed
	SetEvent EVENT_VIRIDIAN_GYM_OPEN
	ret
.gym_closed
	ld a, [wYCoord]
	cp 8
	ret nz
	ld a, [wXCoord]
	cp 32
	ret nz
	ld a, $f
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	call StartSimulatingJoypadStates
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, D_DOWN
	ld [wSimulatedJoypadStatesEnd], a
	xor a
	ld [wSpritePlayerStateData1FacingDirection], a
	ld [wJoyIgnore], a
	ldh [hJoyHeld], a
	ld a, $6
	ld [wViridianCityCurScript], a
	ret

ViridianCityScript6:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	ld a, $2
	ld [wViridianCityCurScript], a
	ret

ViridianCityScript_190ab:
	ld a, [wYCoord]
	cp 9
	ret nz
	ld a, [wXCoord]
	cp 19
	ret nz
	ld a, $5
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
	ldh [hJoyHeld], a
	call ViridianCityScript_1914d
	ld a, $5
	ld [wViridianCityCurScript], a
	ret

ViridianCityScript3:
	call ViridianCityScript_190ef
	call ViridianCityScript_190db
	ResetEvent EVENT_02F
	ld a, $4
	ld [wViridianCityCurScript], a
	ret

ViridianCityScript_190db:
	xor a
	ld [wListScrollOffset], a
	ld a, BATTLE_TYPE_OLD_MAN
	ld [wBattleType], a
	ld a, 5
	ld [wCurEnemyLVL], a
	ld a, RATTATA
	ld [wCurOpponent], a
	ret

ViridianCityScript_190ef:
	ld a, [wSprite03StateData1YPixels]
	ldh [hSpriteScreenYCoord], a
	ld a, [wSprite03StateData1XPixels]
	ldh [hSpriteScreenXCoord], a
	ld a, [wSprite03StateData2MapY]
	ldh [hSpriteMapYCoord], a
	ld a, [wSprite03StateData2MapX]
	ldh [hSpriteMapXCoord], a
	ret

ViridianCityScript4:
	call ViridianCityScript_1912a
	call UpdateSprites
	call Delay3
	SetEvent EVENT_02E
	xor a
	ld [wJoyIgnore], a
	ld a, $10
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
	ld [wBattleType], a
	ld [wJoyIgnore], a
	ld a, $2
	ld [wViridianCityCurScript], a
	ret

ViridianCityScript_1912a:
	ldh a, [hSpriteScreenYCoord]
	ld [wSprite03StateData1YPixels], a
	ldh a, [hSpriteScreenXCoord]
	ld [wSprite03StateData1XPixels], a
	ldh a, [hSpriteMapYCoord]
	ld [wSprite03StateData2MapY], a
	ldh a, [hSpriteMapXCoord]
	ld [wSprite03StateData2MapX], a
	ret

ViridianCityScript5:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	ld a, $0
	ld [wViridianCityCurScript], a
	ret

ViridianCityScript_1914d:
	call StartSimulatingJoypadStates
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, D_DOWN
	ld [wSimulatedJoypadStatesEnd], a
	xor a
	ld [wSpritePlayerStateData1FacingDirection], a
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
	ldh [hSpriteIndexOrTextID], a
	ld a, SPRITE_FACING_RIGHT
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $8
	ld [wSpritePlayerStateData1FacingDirection], a
	ld a, $8
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, D_UP | D_DOWN | D_LEFT | D_RIGHT | START | SELECT
	ld [wJoyIgnore], a
	ret

ViridianCityScript7:
	call ViridianCityScript_190ef
	call ViridianCityScript_190db
	SetEvent EVENT_02F
	ld a, D_UP | D_DOWN | D_LEFT | D_RIGHT | START | SELECT
	ld [wJoyIgnore], a
	ld a, $8
	ld [wViridianCityCurScript], a
	ret

ViridianCityScript8:
	call ViridianCityScript_1912a
	call UpdateSprites
	call Delay3
	SetEvent EVENT_02D
	ld a, D_UP | D_DOWN | D_LEFT | D_RIGHT | START | SELECT
	ld [wJoyIgnore], a
	ld a, $8
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
	ld [wBattleType], a
	dec a
	ld [wJoyIgnore], a
	ld a, $9
	ld [wViridianCityCurScript], a
	ret

ViridianCityScript9:
	ld de, ViridianCityOldManMovementData2
	ld a, [wXCoord]
	cp 19
	jr z, .asm_191e4
	callfar Func_f1a01
	ld de, ViridianCityOldManMovementData1
.asm_191e4
	ld a, $8
	ldh [hSpriteIndexOrTextID], a
	call MoveSprite
	ld a, $a
	ld [wViridianCityCurScript], a
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

ViridianCityScript10:
	ld a, [wd730]
	bit 0, a
	ret nz
	ld a, $3
	ld [wMissableObjectIndex], a
	predef HideObject
	xor a
	ld [wJoyIgnore], a
	ld a, $2
	ld [wViridianCityCurScript], a
	ret

ViridianCity_TextPointers:
	dw ViridianCityText_0
	dw ViridianCityText_1
	dw ViridianCityText_2
	dw ViridianCityText_3
	dw ViridianCityText_4
	dw ViridianCityText_5
	dw ViridianCityText_6
	dw ViridianCityText_7
	dw ViridianCityText_8
	dw ViridianCityText_9
	dw ViridianCityText_10
	dw MartSignText
	dw PokeCenterSignText
	dw ViridianCityText_11
	dw ViridianCityText_12
	dw ViridianCityText_13

ViridianCityText_0:
	text_asm
	farcall Func_f18bb
	jp TextScriptEnd

ViridianCityText_1:
	text_asm
	farcall Func_f18c7
	jp TextScriptEnd

ViridianCityText_2:
	text_asm
	farcall Func_f18e9
	jp TextScriptEnd

ViridianCityText_3:
	text_asm
	farcall Func_f1911
	jp TextScriptEnd

ViridianCityText_4:
	text_asm
	farcall Func_f192c
	jp TextScriptEnd

ViridianCityText_5:
	text_asm
	farcall Func_f194a
	jp TextScriptEnd

ViridianCityText_6:
	text_asm
	farcall Func_f198e
	jp TextScriptEnd

ViridianCityText_13:
	text_far _ViridianCityText_19219
	text_end

ViridianCityText_7:
	text_asm
	CheckEvent EVENT_02D
	jr nz, .asm_192a6
	ld hl, ViridianCityText_192af
	call PrintText
	ld c, 2
	call DelayFrames
	ld a, $7
	ld [wViridianCityCurScript], a
	jr .asm_192ac

.asm_192a6
	ld hl, ViridianCityText_192b4
	call PrintText
.asm_192ac
	jp TextScriptEnd

ViridianCityText_192af:
	text_far _ViridianCityText_1920a
	text_end

ViridianCityText_192b4:
	text_far _OldManTextAfterBattle
	text_end

ViridianCityText_8:
	text_asm
	farcall Func_f19c5
	jp TextScriptEnd

ViridianCityText_9:
	text_asm
	farcall Func_f19d1
	jp TextScriptEnd

ViridianCityText_10:
	text_asm
	farcall Func_f19dd
	jp TextScriptEnd

ViridianCityText_11:
	text_asm
	farcall Func_f19e9
	jp TextScriptEnd

ViridianCityText_12:
	text_asm
	farcall Func_f19f5
	jp TextScriptEnd
