InitBattle::
	ld a, [wCurOpponent]
	and a
	jr z, DetermineWildOpponent

InitOpponent:
	ld a, [wCurOpponent]
	ld [wcf91], a
	ld [wEnemyMonSpecies2], a
	jr InitBattleCommon

DetermineWildOpponent:
	ld a, [wd732]
	bit 1, a
	jr z, .asm_3ef2f
	ldh a, [hJoyHeld]
	bit 1, a ; B button pressed?
	ret nz
.asm_3ef2f
	ld a, [wNumberOfNoRandomBattleStepsLeft]
	and a
	ret nz
	callfar TryDoWildEncounter
	ret nz
InitBattleCommon:
	ld a, [wMapPalOffset]
	push af
	ld hl, wLetterPrintingDelayFlags
	ld a, [hl]
	push af
	res 1, [hl]
	call InitBattleVariables
	ld a, [wEnemyMonSpecies2]
	sub OPP_ID_OFFSET
	jp c, InitWildBattle
	ld [wTrainerClass], a
	call GetTrainerInformation
	callfar ReadTrainer
	callfar DoBattleTransitionAndInitBattleVariables
	call _LoadTrainerPic
	xor a
	ld [wEnemyMonSpecies2], a
	ldh [hStartTileID], a
	dec a
	ld [wAICount], a
	hlcoord 12, 0
	predef CopyUncompressedPicToTilemap
	ld a, $ff
	ld [wEnemyMonPartyPos], a
	ld a, $2
	ld [wIsInBattle], a

; Is this a major story battle?
	ld a, [wLoneAttackNo]
	and a
	jp z, _InitBattleCommon
	callabd_ModifyPikachuHappiness PIKAHAPPY_GYMLEADER ; useless since already in bank3d
	jp _InitBattleCommon

InitWildBattle:
	ld a, $1
	ld [wIsInBattle], a
	callfar LoadEnemyMonData
	callfar DoBattleTransitionAndInitBattleVariables
	ld a, [wCurOpponent]
	cp RESTLESS_SOUL
	jr z, .isGhost
	callfar IsGhostBattle
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
	ldh [hStartTileID], a
	hlcoord 12, 0
	predef CopyUncompressedPicToTilemap

; common code that executes after init battle code specific to trainer or wild battles
_InitBattleCommon:
	ld b, SET_PAL_BATTLE_BLACK
	call RunPaletteCommand
	callfar SlidePlayerAndEnemySilhouettesOnScreen
	xor a
	ldh [hAutoBGTransferEnabled], a
	ld hl, .emptyString
	call PrintText
	call SaveScreenTilesToBuffer1
	call ClearScreen
	ld a, $98
	ldh [hAutoBGTransferDest + 1], a
	ld a, $1
	ldh [hAutoBGTransferEnabled], a
	call Delay3
	ld a, $9c
	ldh [hAutoBGTransferDest + 1], a
	call LoadScreenTilesFromBuffer1
	hlcoord 9, 7
	lb bc, 5, 10
	call ClearScreenArea
	hlcoord 1, 0
	lb bc, 4, 10
	call ClearScreenArea
	call ClearSprites
	ld a, [wIsInBattle]
	dec a ; is it a wild battle?
	ld hl, DrawEnemyHUDAndHPBar
	ld b, BANK(DrawEnemyHUDAndHPBar)
	call z, Bankswitch ; draw enemy HUD and HP bar if it's a wild battle
	callfar StartBattle
	callfar EndOfBattle
	pop af
	ld [wLetterPrintingDelayFlags], a
	pop af
	ld [wMapPalOffset], a
	ld a, [wSavedTileAnimations]
	ldh [hTileAnimations], a
	scf
	ret
.emptyString
	db "@"

_LoadTrainerPic:
; wd033-wd034 contain pointer to pic
	ld a, [wTrainerPicPointer]
	ld e, a
	ld a, [wTrainerPicPointer + 1]
	ld d, a ; de contains pointer to trainer pic
	ld a, [wLinkState]
	and a
	ld a, BANK(TrainerPics) ; this is where all the trainer pics are (not counting Red's)
	jr z, .loadSprite
	ld a, BANK(RedPicFront)
.loadSprite
	call UncompressSpriteFromDE
	ld de, vFrontPic
	ld a, $77
	ld c, a
	jp LoadUncompressedSpriteData

LoadMonBackPic:
; Assumes the monster's attributes have
; been loaded with GetMonHeader.
	ld a, [wBattleMonSpecies2]
	ld [wcf91], a
	hlcoord 1, 5
	lb bc, 7, 8
	call ClearScreenArea
	ld hl,  wMonHBackSprite - wMonHeader
	call UncompressMonSprite
	predef ScaleSpriteByTwo
	ld de, vBackPic
	call InterlaceMergeSpriteBuffers ; combine the two buffers to a single 2bpp sprite
	ld hl, vSprites
	ld de, vBackPic
	ld c, (2*SPRITEBUFFERSIZE)/16 ; count of 16-byte chunks to be copied
	ldh a, [hLoadedROMBank]
	ld b, a
	jp CopyVideoData

AnimateSendingOutMon:
	ld a, [wPredefRegisters]
	ld h, a
	ld a, [wPredefRegisters + 1]
	ld l, a
	ldh a, [hStartTileID]
	ldh [hDownArrowBlinkCount1], a
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
	ldh a, [hDownArrowBlinkCount1]
	add $31
	jr CopyUncompressedPicToHL

CopyUncompressedPicToTilemap:
	ld a, [wPredefRegisters]
	ld h, a
	ld a, [wPredefRegisters + 1]
	ld l, a
	ldh a, [hStartTileID]
CopyUncompressedPicToHL::
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
