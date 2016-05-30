InitBattle: ; f5ff2 (3d:5ff2)
	ld a, [wCurOpponent]
	and a
	jr z, asm_f6003

InitOpponent: ; f5ff8 (3d:5ff8)
	ld a, [wCurOpponent]
	ld [wcf91], a
	ld [wEnemyMonSpecies2], a
	jr asm_f601d
asm_f6003: ; f6003 (3d:6003)
	ld a, [wd732]
	bit 1, a
	jr z, .asm_f600f
	ld a, [hJoyHeld]
	bit 1, a ; B button pressed?
	ret nz
.asm_f600f
	ld a, [wNumberOfNoRandomBattleStepsLeft]
	and a
	ret nz
	callab TryDoWildEncounter
	ret nz
asm_f601d: ; f601d (f:601d)
	ld a, [wMapPalOffset]
	push af
	ld hl, wLetterPrintingDelayFlags
	ld a, [hl]
	push af
	res 1, [hl]
	call InitBattleVariables ; 3d:6236
	ld a, [wEnemyMonSpecies2]
	sub $c8
	jp c, InitWildBattle
	ld [wTrainerClass], a
	call GetTrainerInformation
	callab ReadTrainer
	callab DoBattleTransitionAndInitBattleVariables
	call _LoadTrainerPic ; 3d:615a
	xor a
	ld [wEnemyMonSpecies2], a
	ld [$ffe1], a
	dec a
	ld [wAICount], a
	coord hl, 12, 0
	predef CopyUncompressedPicToTilemap
	ld a, $ff
	ld [wEnemyMonPartyPos], a
	ld a, $2
	ld [wIsInBattle], a

	; Is this a major story battle?
	ld a,[wLoneAttackNo]
	and a
	jp z,InitBattle_Common
	callabd_ModifyPikachuHappiness PIKAHAPPY_GYMLEADER ; useless since already in bank3d
	jp InitBattle_Common

InitWildBattle: ; f607c (3d:607c)
	ld a, $1
	ld [wIsInBattle], a
	callab LoadEnemyMonData
	callab DoBattleTransitionAndInitBattleVariables
	ld a, [wCurOpponent]
	cp MAROWAK
	jr z, .isGhost
	callab IsGhostBattle
	jr nz, .isNoGhost
.isGhost
	ld hl, wMonHSpriteDim
	ld a, $66
	ld [hli], a   ; write sprite dimensions
	ld bc, GhostPic
	ld a, c
	ld [hli], a   ; write front sprite pointer
	ld [hl], b
	ld hl, wEnemyMonNick  ; set name to "GHOST"
	ld a, "G"
	ld [hli], a
	ld a, "H"
	ld [hli], a
	ld a, "O"
	ld [hli], a
	ld a, "S"
	ld [hli], a
	ld a, "T"
	ld [hli], a
	ld [hl], "@"
	ld a, [wcf91]
	push af
	ld a, MON_GHOST
	ld [wcf91], a
	ld de, vFrontPic
	call LoadMonFrontSprite ; load ghost sprite
	pop af
	ld [wcf91], a
	jr .spriteLoaded
.isNoGhost
	ld de, vFrontPic
	call LoadMonFrontSprite ; load mon sprite
.spriteLoaded
	xor a
	ld [wTrainerClass], a
	ld [$ffe1], a
	coord hl, 12, 0
	predef CopyUncompressedPicToTilemap

; common code that executes after init battle code specific to trainer or wild battles
InitBattle_Common: ; f60eb (3d:60eb)
	ld b, $0
	call RunPaletteCommand
	callab SlidePlayerAndEnemySilhouettesOnScreen
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	ld hl, .emptyString
	call PrintText
	call SaveScreenTilesToBuffer1
	call ClearScreen
	ld a, $98
	ld [$ffbd], a
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	call Delay3
	ld a, $9c
	ld [$ffbd], a
	call LoadScreenTilesFromBuffer1
	coord hl, 9, 7
	ld bc, $50a
	call ClearScreenArea
	coord hl, 1, 0
	ld bc, $40a
	call ClearScreenArea
	call ClearSprites
	ld a, [wIsInBattle]
	dec a ; is it a wild battle?
	ld hl, DrawEnemyHUDAndHPBar
	ld b,BANK(DrawEnemyHUDAndHPBar)
	call z, Bankswitch ; draw enemy HUD and HP bar if it's a wild battle
	callab StartBattle
	callab EndOfBattle
	pop af
	ld [wLetterPrintingDelayFlags], a
	pop af
	ld [wMapPalOffset], a
	ld a, [wSavedTilesetType]
	ld [hTilesetType], a
	scf
	ret
.emptyString
	db "@"

_LoadTrainerPic: ; f615a (3d:615a)
; wd033-wd034 contain pointer to pic
	ld a, [wTrainerPicPointer] ; wd033
	ld e, a
	ld a, [wTrainerPicPointer + 1] ; wd034
	ld d, a ; de contains pointer to trainer pic
	ld a, [wLinkState]
	and a
	ld a, Bank(TrainerPics) ; this is where all the trainer pics are (not counting Red's)
	jr z, .loadSprite
	ld a, Bank(RedPicFront)
.loadSprite
	call UncompressSpriteFromDE
	ld de, vFrontPic
	ld a, $77
	ld c, a
	jp LoadUncompressedSpriteData
	
LoadMonBackPic: ; f6178 (3d:6178)
; Assumes the monster's attributes have
; been loaded with GetMonHeader.
	ld a, [wBattleMonSpecies2]
	ld [wcf91], a
	coord hl, 1, 5
	ld bc,$708
	call ClearScreenArea
	ld hl,  wMonHBackSprite - wMonHeader
	call UncompressMonSprite
	predef ScaleSpriteByTwo
	ld de, vBackPic
	call InterlaceMergeSpriteBuffers ; combine the two buffers to a single 2bpp sprite
	ld hl, vSprites
	ld de, vBackPic
	ld c, (2*SPRITEBUFFERSIZE)/16 ; count of 16-byte chunks to be copied
	ld a, [H_LOADEDROMBANK]
	ld b, a
	jp CopyVideoData
	
Func_f61a6: ; f61a6 (3d:f61a6)
	ld a, [wPredefRegisters]
	ld h, a
	ld a, [wPredefRegisters + 1]
	ld l, a
	ld a, [$ffe1]
	ld [H_DOWNARROWBLINKCNT1], a
	ld b, $4c
	ld a, [wIsInBattle]
	and a
	jr z, .asm_f61ef
	add b
	ld [hl], a
	call Delay3
	ld bc, -41
	add hl, bc
	ld a, $1
	ld [wNumMovesMinusOne], a
	ld bc, $303
	predef CopyDownscaledMonTiles
	ld c, $4
	call DelayFrames
	ld bc, -41
	add hl, bc
	xor a
	ld [wNumMovesMinusOne], a
	ld bc, $505
	predef CopyDownscaledMonTiles
	ld c, $5
	call DelayFrames
	ld bc, -41
	jr .asm_f61f2
.asm_f61ef
	ld bc, -123
.asm_f61f2
	add hl, bc
	ld a, [H_DOWNARROWBLINKCNT1]
	add $31
	jr CopyUncompressedPicToHL

Func_f61f9: ; f61f9 (3d:61f9)
	ld a, [wPredefRegisters]
	ld h, a
	ld a, [wPredefRegisters + 1]
	ld l, a
	ld a, [$ffe1]
CopyUncompressedPicToHL: ; f6203 (3d:6203)
	ld bc, $707
	ld de, $14
	push af
	ld a, [wSpriteFlipped]
	and a
	jr nz, .asm_f6220
	pop af
.asm_f6211
	push bc
	push hl
.asm_f6213
	ld [hl], a
	add hl, de
	inc a
	dec c
	jr nz, .asm_f6213
	pop hl
	inc hl
	pop bc
	dec b
	jr nz, .asm_f6211
	ret
	
.asm_f6220
	push bc
	ld b, $0
	dec c
	add hl, bc
	pop bc
	pop af
.asm_f6227
	push bc
	push hl
.asm_f6229
	ld [hl], a
	add hl, de
	inc a
	dec c
	jr nz, .asm_f6229
	pop hl
	dec hl
	pop bc
	dec b
	jr nz, .asm_f6227
	ret
	
INCLUDE "engine/battle/init_battle_variables.asm"
INCLUDE "engine/battle/moveEffects/focus_energy_effect.asm"
INCLUDE "engine/battle/moveEffects/heal_effect.asm"
INCLUDE "engine/battle/moveEffects/transform_effect.asm"
INCLUDE "engine/battle/moveEffects/reflect_light_screen_effect.asm"
INCLUDE "engine/battle/moveEffects/mist_effect.asm"
INCLUDE "engine/battle/moveEffects/one_hit_ko_effect.asm"
INCLUDE "engine/battle/moveEffects/pay_day_effect.asm"
INCLUDE "engine/battle/moveEffects/paralyze_effect.asm"