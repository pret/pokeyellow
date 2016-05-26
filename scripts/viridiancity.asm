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
	ld a, $80
	ld [wSimulatedJoypadStatesEnd], a
	xor a
	ld [wSpriteStateData1 + 9], a
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
	ld a, $80
	ld [wSimulatedJoypadStatesEnd], a
	xor a
	ld [wSpriteStateData1 + 9], a
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
	ld [wSpriteStateData1 + 9], a
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
	dr $19213,$192f5
