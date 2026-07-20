DEF SURFING_MINIGAME_FLAT_WATER_Y EQU $74
DEF SURFING_MINIGAME_CENTER_X     EQU SCREEN_WIDTH_PX / 2 + OAM_X_OFS

	const_def
	const SURFING_MINIGAME_PIKACHU_STATE_RIDING       ; 0
	const SURFING_MINIGAME_PIKACHU_STATE_JUMPING      ; 1
	const SURFING_MINIGAME_PIKACHU_STATE_LANDING      ; 2
	const SURFING_MINIGAME_PIKACHU_STATE_CRASHED      ; 3
	const SURFING_MINIGAME_PIKACHU_STATE_GAME_END     ; 4
	const SURFING_MINIGAME_PIKACHU_STATE_INIT_RESULTS ; 5
	const SURFING_MINIGAME_PIKACHU_STATE_RESULTS      ; 6

SurfingPikachuMinigame::
	call SurfingPikachuMinigame_BlankPals
	call DelayFrame
	call DelayFrame
	call DelayFrame
	ldh a, [hTileAnimations]
	push af
	xor a
	ldh [hTileAnimations], a
	ld a, [wUpdateSpritesEnabled]
	push af
	ld a, $ff
	ld [wUpdateSpritesEnabled], a
	ldh a, [rIE]
	push af
	xor a
	ldh [rIF], a
	ld a, IE_VBLANK | IE_STAT | IE_TIMER | IE_SERIAL
	ldh [rIE], a
	ld a, STAT_MODE_0 ; request an interrupt at the start of each HBlank
	ldh [rSTAT], a
	ldh a, [hAutoBGTransferDest + 1]
	push af
	ld a, HIGH(vBGMap0)
	ldh [hAutoBGTransferDest + 1], a
	call SurfingPikachuMinigameIntro
	call SurfingPikachuLoop
	xor a
	ldh [rBGP], a
	ldh [rOBP0], a
	ldh [rOBP1], a
	call UpdateCGBPal_BGP
	call UpdateCGBPal_OBP0
	call UpdateCGBPal_OBP1
	call ClearObjectAnimationBuffers
	call ClearSprites
	xor a
	ldh [hLCDCPointer], a
	ldh [hSCX], a
	ldh [hSCY], a
	ld a, SCREEN_HEIGHT_PX ; keep the window below the visible screen
	ldh [hWY], a
	call DelayFrame
	pop af
	ldh [hAutoBGTransferDest + 1], a
	xor a
	ldh [rIF], a
	pop af
	ldh [rIE], a
	xor a
	ldh [rSTAT], a
	call RunDefaultPaletteCommand
	call ReloadMapAfterSurfingMinigame
	call PlayDefaultMusic
	call GBPalNormal
	pop af
	ld [wUpdateSpritesEnabled], a
	pop af
	ldh [hTileAnimations], a
	ret

SurfingPikachuLoop:
	call SurfingPikachuMinigame_LoadGFXAndLayout
	call DelayFrame
	ld b, SET_PAL_SURFING_PIKACHU_TITLE
	call RunPaletteCommand
.loop
	ld a, [wSurfingMinigameRoutineNumber]
	bit 7, a
	ret nz
	call SurfingPikachu_GetJoypad_3FrameBuffer
	call SurfingPikachu_CheckPressedSelect
	ret nz
	call RunSurfingMinigameRoutine
	ld a, 15 * OBJ_SIZE
	ld [wCurrentAnimatedObjectOAMBufferOffset], a
	call RunObjectAnimations
	call SurfingMinigame_MoveClouds
	call .DelayFrame
	call SurfingMinigame_UpdateMusicTempo
	jr .loop

.DelayFrame:
	call DelayFrame
	ret

SurfingPikachu_CheckPressedSelect:
	ld hl, wPikachuMapScriptFlags
	bit BIT_PIKACHU_MAP_SURF_SELECT, [hl]
	ret z
	ldh a, [hJoyPressed]
	and PAD_SELECT
	ret

SurfingMinigame_ToggleStartFlag: ; unused
	ldh a, [hJoyPressed]
	and PAD_START
	ret z
	ld hl, wSurfingMinigameUnusedToggle
	ld a, [hl]
	xor $1
	ld [hl], a
	ret

SurfingMinigame_UpdateMusicTempo:
	ld a, [wSurfingMinigameMusicTempoEnabled]
	and a
	ret z

	; check that all channels are on their last frame of note delay
	ld hl, wChannelNoteDelayCounters
	ld a, $1
	cp [hl]
	ret nz
	inc hl
	cp [hl]
	ret nz
	inc hl
	cp [hl]
	ret nz

	; de = ([wSurfingMinigamePikachuSpeed] & $3ff) * 2
	ld a, [wSurfingMinigamePikachuSpeed]
	ld e, a
	ld a, [wSurfingMinigamePikachuSpeed + 1]
	and $3
	ld d, a
	sla e
	rl d
	ld e, d
	ld d, $0
	ld hl, .Tempos
	add hl, de
	add hl, de
	ld a, [hli]
	ld [wMusicTempo + 1], a
	ld a, [hl]
	ld [wMusicTempo], a
	ret

.Tempos:
	dw 117
	dw 109
	dw 101
	dw  93
	dw  85

SurfingMinigame_ResetMusicTempo:
	ld hl, wChannelNoteDelayCounters
	ld a, $1
	cp [hl]
	ret nz
	inc hl
	cp [hl]
	ret nz
	inc hl
	cp [hl]
	ret nz
	ld a, 117
	ld [wMusicTempo + 1], a
	xor a
	ld [wMusicTempo], a
	ret

SurfingPikachuMinigame_LoadGFXAndLayout:
	call SurfingPikachu_ClearTileMap
	call ClearSprites
	call DisableLCD
	ld hl, wSurfingMinigameData
	ld bc, wSurfingMinigameDataEnd - wSurfingMinigameData
	xor a
	call FillMemory
	ld hl, wLYOverrides
	ld bc, wLYOverridesBufferEnd - wLYOverrides
	xor a
	call FillMemory
	xor a
	ldh [hAutoBGTransferEnabled], a
	call ClearObjectAnimationBuffers

	ld hl, SurfingPikachu1Graphics1
	ld de, vChars2
	ld bc, 80 tiles
	ld a, BANK(SurfingPikachu1Graphics1)
	call FarCopyData

	ld hl, SurfingPikachu1Graphics2
	ld de, vChars0
	ld bc, 256 tiles
	ld a, BANK(SurfingPikachu1Graphics2)
	call FarCopyData

	ld a, LOW(SurfingPikachuObjectSpawnData)
	ld [wAnimatedObjectSpawnStateDataPointer], a
	ld a, HIGH(SurfingPikachuObjectSpawnData)
	ld [wAnimatedObjectSpawnStateDataPointer + 1], a

	ld a, LOW(SurfingPikachuObjectCallbacks)
	ld [wAnimatedObjectJumptablePointer], a
	ld a, HIGH(SurfingPikachuObjectCallbacks)
	ld [wAnimatedObjectJumptablePointer + 1], a

	ld a, LOW(SurfingPikachuOAMData)
	ld [wAnimatedObjectOAMDataPointer], a
	ld a, HIGH(SurfingPikachuOAMData)
	ld [wAnimatedObjectOAMDataPointer + 1], a

	ld a, LOW(SurfingPikachuFrames)
	ld [wAnimatedObjectFramesDataPointer], a
	ld a, HIGH(SurfingPikachuFrames)
	ld [wAnimatedObjectFramesDataPointer + 1], a

	ld hl, vBGMap0
	ld bc, 2 * TILEMAP_AREA
	ld a, $0
	call FillMemory

	hlbgcoord 0, 6
	ld bc, 12 * TILEMAP_WIDTH
	ld a, $b ; water tile
	call FillMemory

	ld a, $1 ; surfing Pikachu
	lb de, SURFING_MINIGAME_FLAT_WATER_Y, SURFING_MINIGAME_CENTER_X
	call SpawnAnimatedObject

	ld a, SURFING_MINIGAME_FLAT_WATER_Y
	ld [wSurfingMinigamePikachuObjectHeight], a

	call SurfingMinigame_InitScanlineOverrides

	xor a
	ldh [hSCX], a
	ldh [hSCY], a
	ld a, $7e ; place the HP window just below Pikachu's waterline
	ldh [hWY], a
	ld a, rSCY - $ff00
	ldh [hLCDCPointer], a
	ld a, 0.25 ; initial speed
	ld [wSurfingMinigamePikachuSpeed], a
	xor a
	ld [wSurfingMinigamePikachuSpeed + 1], a
	xor a
	ld [wSurfingMinigamePikachuHP], a
	ld a, $60 ; initial HP: $6000 in little-endian BCD
	ld [wSurfingMinigamePikachuHP + 1], a
	ld hl, wSurfingMinigameWaveHeight
	ld bc, SCREEN_WIDTH
	ld a, SURFING_MINIGAME_FLAT_WATER_Y
	call FillMemory
	call SurfingPikachuMinigame_InitStaticSpriteLayout
	call SurfingPikachuMinigame_DrawStaticTilemapLayout
	ld a, LCDC_ON | LCDC_WIN_9C00 | LCDC_WIN_ON | LCDC_OBJ_ON | LCDC_BG_ON
	ldh [rLCDC], a
	call SurfingPikachuMinigame_SetBGPals
	ldpal a, SHADE_BLACK, SHADE_DARK, SHADE_LIGHT, SHADE_WHITE
	ldh [rOBP0], a
	ldpal a, SHADE_BLACK, SHADE_DARK, SHADE_WHITE, SHADE_WHITE
	ldh [rOBP1], a
	call UpdateCGBPal_OBP0
	call UpdateCGBPal_OBP1
	ret

SurfingPikachuMinigame_SetBGPals:
	ld a, [wOnSGB]
	and a
	jr nz, .sgb
	ldpal a, SHADE_BLACK, SHADE_LIGHT, SHADE_WHITE, SHADE_WHITE
	ldh [rBGP], a
	call UpdateCGBPal_BGP
	ret

.sgb
	ldpal a, SHADE_BLACK, SHADE_DARK, SHADE_LIGHT, SHADE_WHITE
	ldh [rBGP], a
	call UpdateCGBPal_BGP
	ret

SurfingPikachuMinigame_InitStaticSpriteLayout:
	ld hl, wSpriteDataEnd
	ld de, SurfingPikachuHPDigitTiles
	ld b, $97 ; HP digits: OAM Y
	ld c, $80 ; OAM X
	ld a, $4
	call SurfingPikachuMinigame_PlaceSpriteRowFromTiles
	ld de, SurfingPikachuMiniPikachuTile
	ld b, $96 ; progress marker: OAM Y
	ld c, $50 ; OAM X
	ld a, $1
	call SurfingPikachuMinigame_PlaceSpriteRowFromTiles
	ld de, SurfingPikachuWideCloudTiles
	ld b, $14 ; wide cloud: OAM Y
	ld c, $20 ; OAM X
	ld a, $5
	call SurfingPikachuMinigame_PlaceSpriteRowFromTiles
	ld de, SurfingPikachuNarrowCloudTiles
	ld b, $20 ; narrow cloud: OAM Y
	ld c, $80 ; OAM X
	ld a, $4
	call SurfingPikachuMinigame_PlaceSpriteRowFromTiles
	ret

SurfingPikachuMinigame_PlaceSpriteRowFromTiles:
.loop
	push af
	ld [hl], b
	inc hl
	ld [hl], c
	inc hl
	ld a, [de]
	ld [hl], a
	inc hl
	ld [hl], $0
	inc hl
	ld a, c
	add TILE_WIDTH
	ld c, a
	inc de
	pop af
	dec a
	jr nz, .loop
	ret

SurfingPikachuMiniPikachuTile:
	db $fe

SurfingPikachuHPDigitTiles:
	db $d0, $d0, $d0, $d0

SurfingPikachuWideCloudTiles:
	db $ec, $ed, $ed, $ee, $ef

SurfingPikachuNarrowCloudTiles:
	db $ec, $ed, $ee, $ef

SurfingPikachuMinigame_DrawStaticTilemapLayout:
	debgcoord 1, 1, vBGMap1
	ld hl, SurfingPikachuStatusBarTiles
	ld c, $9
.copyTileRow
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .copyTileRow
	hlbgcoord 1, 0, vBGMap1
	ld [hl], $15
	hlbgcoord 2, 0, vBGMap1
	ld [hl], $16
	hlbgcoord 12, 1, vBGMap1
	ld [hl], $1b
	hlbgcoord 13, 1, vBGMap1
	ld [hl], $1c
	ret

SurfingPikachuStatusBarTiles:
	db $17, $18, $19, $19, $19, $19, $19, $19, $19

RunSurfingMinigameRoutine:
	ld a, [wSurfingMinigameRoutineNumber]
	ld e, a
	ld d, $0
	ld hl, .Jumptable
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

.Jumptable:
	dw SurfingMinigame_StartGame ; 0
	dw SurfingMinigame_RunGame ; 1
	dw SurfingMinigame_WaitToShowResults ; 2
	dw SurfingMinigame_ScrollToResultsScreen ; 3
	dw SurfingMinigame_DrawResultsScreenAndWait ; 4
	dw SurfingMinigame_WriteHPLeftAndWait ; 5
	dw SurfingMinigame_WriteRadnessAndWait ; 6
	dw SurfingMinigame_WriteTotalAndWait ; 7
	dw SurfingMinigame_AddRemainingHPToTotalAndWait ; 8
	dw SurfingMinigame_AddRadnessToTotalAndWait ; 9
	dw SurfingMinigame_WaitLast ; a
	dw SurfingMinigame_ExitOnPressA ; b
	dw SurfingMinigame_GameOver ; c

SurfingMinigame_StartGame:
	ld a, $2 ; "START" text
	lb de, $48, $e0 ; banner OAM Y, X (starts off the right edge)
	call SpawnAnimatedObject
	ld hl, wSurfingMinigameRoutineNumber
	inc [hl]
	ld a, TRUE
	ld [wSurfingMinigameMusicTempoEnabled], a
	ret

SurfingMinigame_RunGame:
	ld a, [wSurfingMinigameDistance]
	cp $18 ; end of the 24-section course
	jr nc, .finished
	ld hl, wSurfingMinigamePikachuHP
	ld a, [hli]
	or [hl]
	and a
	jr z, .dead
	call Random
	ld [wSurfingMinigameWaveRandomValue], a
	call SurfingMinigame_UpdateLYOverrides
	call SurfingMinigame_SetPikachuHeight
	call SurfingMinigame_ReadBGMapBuffer
	call SurfingMinigame_ScrollAndGenerateBGMap
	call SurfingMinigame_UpdatePikachuDistance
	call SurfingMinigame_Deduct1HP
	call SurfingMinigame_DrawHP
	ret

.finished
	ld hl, wSurfingMinigameRoutineNumber
	inc [hl]
	xor a
	ld [wSurfingMinigameMusicTempoEnabled], a
	ld a, 192 ; frames to coast before scrolling to the results screen
	ld [wSurfingMinigameRoutineDelay], a
	ret

.dead
	ld a, TRUE
	ld [wSurfingMinigameGameOver], a
	ld a, $c
	ld [wSurfingMinigameRoutineNumber], a
	ld a, $80 ; frames before accepting A on the game-over screen
	ld [wSurfingMinigameGameOverDelay], a
	ld a, $b ; "Oh no.." text
	lb de, $88, SURFING_MINIGAME_CENTER_X
	call SpawnAnimatedObject
	ld hl, ANIM_OBJ_Y_OFFSET
	add hl, bc
	ld [hl], $80
	ld hl, ANIM_OBJ_FIELD_B
	add hl, bc
	ld [hl], $80
	ld hl, ANIM_OBJ_FIELD_C
	add hl, bc
	ld [hl], $30 ; initial frame counter for the flipping animation
	xor a
	ld [wSurfingMinigameMusicTempoEnabled], a
	ret

SurfingMinigame_WaitToShowResults:
	call SurfingMinigame_RunDelayTimer
	jr c, .doneDelay
	xor a
	ld [wSurfingMinigameWaveRandomValue], a
	call SurfingMinigame_UpdateLYOverrides
	call SurfingMinigame_SetPikachuHeight
	call SurfingMinigame_ReadBGMapBuffer
	call SurfingMinigame_CoastAfterGoal
	call SurfingMinigame_ResetMusicTempo
	ret

.doneDelay
	ld hl, wSurfingMinigameRoutineNumber
	inc [hl]
	ld a, $90 ; initial horizontal scroll for the results transition
	ldh [hSCX], a
	ld a, $72 ; flat water before the beach sequence
	ld [wSurfingMinigameWaveFunctionNumber], a
	ld a, SURFING_MINIGAME_PIKACHU_STATE_GAME_END
	ld [wSurfingMinigamePikachuState], a
	xor a
	ldh [hLCDCPointer], a
	ld [wSurfingMinigameSCX], a
	ld [wSurfingMinigameSCX2], a
	ld [wSurfingMinigameSCXHi], a
	ret

SurfingMinigame_ScrollToResultsScreen:
	ldh a, [hSCX]
	and a
	jr z, .finished
	call SurfingMinigame_UpdateLYOverrides
	call SurfingMinigame_SetPikachuHeight
	call SurfingMinigame_ReadBGMapBuffer
	ldh a, [hSCX]
	dec a
	dec a
	dec a
	dec a
	ldh [hSCX], a
	ld a, TILEMAP_WIDTH_PX - 32 ; generate tiles 32 pixels behind the viewport
	ld [wSurfingMinigameXOffset], a
	call SurfingMinigame_GenerateBGMap
	ret

.finished
	xor a
	ld [wSurfingMinigamePikachuSpeed], a
	ld [wSurfingMinigamePikachuSpeed + 1], a
	ld hl, wSurfingMinigameRoutineNumber
	inc [hl]
	ld a, SURFING_MINIGAME_PIKACHU_STATE_INIT_RESULTS
	ld [wSurfingMinigamePikachuState], a
	ret

SurfingMinigame_DrawResultsScreenAndWait:
	call SurfingMinigame_DrawResultsScreen
	ld a, 32
	ld [wSurfingMinigameRoutineDelay], a
	ld hl, wSurfingMinigameRoutineNumber
	inc [hl]
	ret

SurfingMinigame_WriteHPLeftAndWait:
	call SurfingMinigame_RunDelayTimer
	ret nc
	call SurfingMinigame_WriteHPLeft
	ld a, 64
	ld [wSurfingMinigameRoutineDelay], a
	ld hl, wSurfingMinigameRoutineNumber
	inc [hl]
	ret

SurfingMinigame_WriteRadnessAndWait:
	call SurfingMinigame_RunDelayTimer
	ret nc
	call SurfingMinigame_WriteRadness
	ld a, 64
	ld [wSurfingMinigameRoutineDelay], a
	ld hl, wSurfingMinigameRoutineNumber
	inc [hl]
	ret

SurfingMinigame_WriteTotalAndWait:
	call SurfingMinigame_RunDelayTimer
	ret nc
	call SurfingMinigame_WriteTotal
	ld a, 64
	ld [wSurfingMinigameRoutineDelay], a
	ld hl, wSurfingMinigameRoutineNumber
	inc [hl]
	ret

SurfingMinigame_AddRemainingHPToTotalAndWait:
	call SurfingMinigame_RunDelayTimer
	ret nc
	call SurfingMinigame_AddRemainingHPToTotal
	push af
	call SurfingMinigame_BCDPrintTotalScore
	pop af
	ret nc
	ld a, 64
	ld [wSurfingMinigameRoutineDelay], a
	ld hl, wSurfingMinigameRoutineNumber
	inc [hl]
	ret

SurfingMinigame_AddRadnessToTotalAndWait:
	call SurfingMinigame_RunDelayTimer
	ret nc
	call SurfingMinigame_AddRadnessToTotal
	push af
	call SurfingMinigame_BCDPrintTotalScore
	pop af
	ret nc
	ld a, 128
	ld [wSurfingMinigameRoutineDelay], a
	ld hl, wSurfingMinigameRoutineNumber
	inc [hl]
	call DidPlayerGetAHighScore
	ret nc
	call SurfingMinigame_PrintTextHiScore
	ld a, SURFING_MINIGAME_PIKACHU_STATE_RESULTS
	ld [wSurfingMinigamePikachuState], a
	ret

SurfingMinigame_WaitLast:
	call SurfingMinigame_RunDelayTimer
	ret nc
	ld hl, wSurfingMinigameRoutineNumber
	inc [hl]
	ret

SurfingMinigame_ExitOnPressA:
	call SurfingMinigame_UpdateLYOverrides
	ldh a, [hJoyPressed]
	and PAD_A
	ret z
	ld hl, wSurfingMinigameRoutineNumber
	set 7, [hl]
	ret

SurfingMinigame_GameOver:
	call SurfingMinigame_UpdateLYOverrides
	call SurfingMinigame_SetPikachuHeight
	call SurfingMinigame_ReadBGMapBuffer
	call SurfingMinigame_ScrollAndGenerateBGMap
	call SurfingMinigame_ResetMusicTempo
	ld hl, wSurfingMinigameGameOverDelay
	ld a, [hl]
	and a
	jr z, .waitPressA
	dec [hl]
	ret

.waitPressA
	ldh a, [hJoyPressed]
	and PAD_A
	ret z
	ld hl, wSurfingMinigameRoutineNumber
	set 7, [hl]
	ret

SurfingMinigame_RunDelayTimer:
	ld hl, wSurfingMinigameRoutineDelay
	ld a, [hl]
	and a
	jr z, .setCarry
	dec [hl]
	and a
	ret

.setCarry
	scf
	ret

SurfingMinigame_UpdatePikachuDistance:
	ld a, [wSurfingMinigameDistance + 1]
	ld h, a
	ld a, [wSurfingMinigameDistance + 2]
	ld l, a
	ld a, [wSurfingMinigamePikachuSpeed]
	ld e, a
	ld a, [wSurfingMinigamePikachuSpeed + 1]
	ld d, a
	add hl, de
	ld a, h
	ld [wSurfingMinigameDistance + 1], a
	ld a, l
	ld [wSurfingMinigameDistance + 2], a
	ret nc
	ld hl, wSurfingMinigameDistance
	inc [hl]
	ld hl, wShadowOAMSprite04XCoord
	dec [hl]
	dec [hl]
	ret

SurfingMinigameAnimatedObjectFn_Pikachu:
	ld a, [wSurfingMinigamePikachuState]
	ld e, a
	ld d, $0
	ld hl, .StateFunctions
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

.StateFunctions:
	dw SurfingMinigame_UpdateRidingPikachu   ; 0
	dw SurfingMinigame_UpdateJumpingPikachu  ; 1
	dw SurfingMinigame_UpdateLandingPikachu  ; 2
	dw SurfingMinigame_UpdateCrashedPikachu  ; 3
	dw SurfingMinigame_UpdateGameEndPikachu  ; 4
	dw SurfingMinigame_InitResultsPikachu    ; 5
	dw SurfingMinigame_UpdateResultsPikachu  ; 6

SurfingMinigame_UpdateRidingPikachu:
	ld a, [wSurfingMinigameGameOver]
	and a
	jr nz, .gameOver
	call SurfingMinigame_SpawnWaterSpray
	ld a, [wSurfingMinigamePikachuObjectHeight]
	ld hl, ANIM_OBJ_Y_COORD
	add hl, bc
	ld [hl], a
	call SurfingMinigame_TryStartJump
	jr c, .startedJump
	call SurfingMinigame_UpdateSurfingFrame
	call SurfingMinigame_SpeedUpPikachu
	ret

.startedJump
	call SurfingMinigame_UpdateSurfingFrame
	ld a, SURFING_MINIGAME_PIKACHU_STATE_JUMPING
	ld [wSurfingMinigamePikachuState], a
	xor a
	ld hl, ANIM_OBJ_FIELD_C
	add hl, bc
	ld [hl], a
	ld hl, ANIM_OBJ_FIELD_D
	add hl, bc
	ld [hl], a
	ld hl, ANIM_OBJ_FIELD_E
	add hl, bc
	ld [hl], a
	ld [wSurfingMinigameRadnessMeter], a
	ld [wSurfingMinigameTrickFlags], a
	xor a
	ld [wChannelSoundIDs + CHAN8], a
	ld a, SFX_SURFING_JUMP
	call PlaySound
	ret

.gameOver
	xor a
	ld [wSurfingMinigamePikachuSpeed], a
	ld [wSurfingMinigamePikachuSpeed + 1], a
	ld a, SURFING_MINIGAME_PIKACHU_STATE_GAME_END
	ld [wSurfingMinigamePikachuState], a
	call SurfingMinigame_UpdateSurfingFrame
	ret

SurfingMinigame_UpdateJumpingPikachu:
	call SurfingMinigame_DPadAction
	call SurfingMinigame_UpdatePikachuHeight
	ret nc
	call SurfingMinigame_TileInteraction
	jr c, .crash
	call SurfingMinigame_CalculateAndAddRadnessFromStunt
	ld hl, ANIM_OBJ_FIELD_C
	add hl, bc
	ld [hl], $0
	ld a, SURFING_MINIGAME_PIKACHU_STATE_LANDING
	ld [wSurfingMinigamePikachuState], a
	ret

.crash
	ld a, SURFING_MINIGAME_PIKACHU_STATE_CRASHED
	ld [wSurfingMinigamePikachuState], a
	ld a, $60 ; crash animation duration in frames
	ld [wSurfingMinigameCrashTimer], a
	ld a, $10
	call SetCurrentAnimatedObjectCallbackAndResetFrameStateRegisters
	xor a
	ld [wChannelSoundIDs + CHAN8], a
	ld a, SFX_SURFING_CRASH
	call PlaySound
	ret

SurfingMinigame_UpdateLandingPikachu:
	ld hl, ANIM_OBJ_FIELD_C
	add hl, bc
	ld a, [hl]
	cp $20 ; landing splash lasts 32 frames
	jr nc, .done
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	ld d, $4
	call SurfingPikachu_Sine
	ld hl, ANIM_OBJ_Y_OFFSET
	add hl, bc
	ld [hl], a
	call SurfingMinigame_SpawnWaterSpray
	ld a, [wSurfingMinigamePikachuObjectHeight]
	ld hl, ANIM_OBJ_Y_COORD
	add hl, bc
	ld [hl], a
	ret

.done
	ld hl, ANIM_OBJ_Y_OFFSET
	add hl, bc
	ld [hl], $0
	ld a, SURFING_MINIGAME_PIKACHU_STATE_RIDING
	ld [wSurfingMinigamePikachuState], a
	ret

SurfingMinigame_UpdateCrashedPikachu:
	ld hl, wSurfingMinigameCrashTimer
	ld a, [hl]
	and a
	jr z, .done
	dec [hl]
	ld a, [wSurfingMinigamePikachuObjectHeight]
	ld hl, ANIM_OBJ_Y_COORD
	add hl, bc
	ld [hl], a
	ret

.done
	ld a, SURFING_MINIGAME_PIKACHU_STATE_RIDING
	ld [wSurfingMinigamePikachuState], a
	ld a, $4
	call SetCurrentAnimatedObjectCallbackAndResetFrameStateRegisters
	ret

SurfingMinigame_UpdateGameEndPikachu:
	ld a, [wSurfingMinigamePikachuObjectHeight]
	ld hl, ANIM_OBJ_Y_COORD
	add hl, bc
	ld [hl], a
	call SurfingMinigame_UpdateSurfingFrame
	ret

SurfingMinigame_InitResultsPikachu:
	ld a, $f
	call SetCurrentAnimatedObjectCallbackAndResetFrameStateRegisters
	ld hl, ANIM_OBJ_FIELD_C
	add hl, bc
	ld [hl], $0
	ret

SurfingMinigame_UpdateResultsPikachu:
	ld hl, ANIM_OBJ_FIELD_C
	add hl, bc
	ld a, [hl]
	inc [hl]
	inc [hl]
	and $3f ; 64-frame bobbing cycle
	cp $20 ; only apply the sine offset during the second half
	jr c, .resetOffset
	ld d, $10
	call SurfingPikachu_Sine
	ld hl, ANIM_OBJ_Y_OFFSET
	add hl, bc
	ld [hl], a
	ret

.resetOffset
	ld hl, ANIM_OBJ_Y_OFFSET
	add hl, bc
	ld [hl], $0
	ret

SurfingMinigame_DPadAction:
	ld de, hJoy5
	ld a, [de]
	and PAD_LEFT
	jr nz, .dLeft
	ld a, [de]
	and PAD_RIGHT
	jr nz, .dRight
	ret

.dLeft
	ld hl, ANIM_OBJ_FIELD_E
	add hl, bc
	ld [hl], $0
	ld hl, ANIM_OBJ_FIELD_D
	add hl, bc
	ld a, [hl]
	inc [hl]
	cp $b
	jr c, .dLeftSkip
	call .StartTrick
	ld hl, wSurfingMinigameTrickFlags
	set 0, [hl]
.dLeftSkip
	ld hl, ANIM_OBJ_FRAME_SET
	add hl, bc
	ld a, [hl]
	cp $e
	jr nc, .dLeftReset
	inc [hl]
	ret

.dLeftReset
	ld [hl], $1
	ret

.dRight
	ld hl, ANIM_OBJ_FIELD_D
	add hl, bc
	ld [hl], $0
	ld hl, ANIM_OBJ_FIELD_E
	add hl, bc
	ld a, [hl]
	inc [hl]
	cp $d
	jr c, .dRightSkip
	call .StartTrick
	ld hl, wSurfingMinigameTrickFlags
	set 1, [hl]
.dRightSkip
	ld hl, ANIM_OBJ_FRAME_SET
	add hl, bc
	ld a, [hl]
	cp $1
	jr z, .dRightReset
	dec [hl]
	ret

.dRightReset
	ld [hl], $e
	ret

.StartTrick:
	call SurfingMinigame_IncreaseRadnessMeter
	xor a
	ld hl, ANIM_OBJ_FIELD_D
	add hl, bc
	ld [hl], a
	ld hl, ANIM_OBJ_FIELD_E
	add hl, bc
	ld [hl], a
	ld a, SFX_SURFING_FLIP
	call PlaySound
	ret

SurfingMinigame_TileInteraction:
	ld hl, ANIM_OBJ_FRAME_SET
	add hl, bc
	ld a, [wSurfingMinigameBGMapReadBuffer]
	cp $6 ; rising slope
	jr z, .risingSlope
	cp $14 ; wave crest
	jr z, .waveCrest
	cp $12 ; wave face
	jr z, .waveFace
	cp $7 ; falling slope
	jr z, .fallingSlope
	ld a, [hl]
	cp $1
	jp z, .wipeout
	cp $2
	jr z, .hardLanding
	cp $3
	jr z, .roughLanding
	cp $4
	jr z, .cleanLanding
	cp $5
	jr z, .roughLanding
	cp $6
	jr z, .hardLanding
	cp $7
	jr z, .wipeout
	jr .wipeout

.risingSlope
	ld a, [hl]
	cp $1
	jr z, .wipeout
	cp $2
	jr z, .wipeout
	cp $3
	jr z, .wipeout
	cp $4
	jr z, .hardLanding
	cp $5
	jr z, .roughLanding
	cp $6
	jr z, .cleanLanding
	cp $7
	jr z, .roughLanding
	jr .wipeout

.fallingSlope
	ld a, [hl]
	cp $1
	jr z, .roughLanding
	cp $2
	jr z, .cleanLanding
	cp $3
	jr z, .roughLanding
	cp $4
	jr z, .hardLanding
	cp $5
	jr z, .wipeout
	cp $6
	jr z, .wipeout
	cp $7
	jr z, .wipeout
	jr .wipeout

.waveFace
.waveCrest
	ld a, [hl]
	cp $1
	jr z, .wipeout
	cp $2
	jr z, .hardLanding
	cp $3
	jr z, .roughLanding
	cp $4
	jr z, .cleanLanding
	cp $5
	jr z, .cleanLanding
	cp $6
	jr z, .roughLanding
	cp $7
	jr z, .hardLanding
	jr .wipeout

.hardLanding
	call SurfingMinigame_ReduceSpeedBy128
	jr .cleanLanding

.roughLanding
	call SurfingMinigame_ReduceSpeedBy64
.cleanLanding
	xor a
	ld [wChannelSoundIDs + CHAN8], a
	ld a, SFX_SURFING_LAND
	call PlaySound
	and a
	ret

.wipeout
	ld a, 0.25 ; reset speed after a wipeout
	ld [wSurfingMinigamePikachuSpeed], a
	xor a
	ld [wSurfingMinigamePikachuSpeed + 1], a
	scf
	ret

SurfingMinigame_SpeedUpPikachu:
	ld a, [wSurfingMinigamePikachuSpeed + 1]
	cp $2
	ret nc
	ld h, a
	ld a, [wSurfingMinigamePikachuSpeed]
	ld l, a
	ld de, 0.0078125 ; increase speed by 1/128 per frame
	add hl, de
	ld a, h
	ld [wSurfingMinigamePikachuSpeed + 1], a
	ld a, l
	ld [wSurfingMinigamePikachuSpeed], a
	ret

SurfingMinigame_ReduceSpeedBy64:
	ld a, [wSurfingMinigamePikachuSpeed + 1]
	and a
	jr nz, .go
	ld a, [wSurfingMinigamePikachuSpeed]
	cp 0.25 ; avoid underflow when reducing speed
	jr nc, .go
	xor a
	ld [wSurfingMinigamePikachuSpeed], a
	ret

.go
	ld a, [wSurfingMinigamePikachuSpeed + 1]
	ld h, a
	ld a, [wSurfingMinigamePikachuSpeed]
	ld l, a
	ld de, -0.25 ; reduce speed after a rough landing
	add hl, de
	ld a, h
	ld [wSurfingMinigamePikachuSpeed + 1], a
	ld a, l
	ld [wSurfingMinigamePikachuSpeed], a
	ret

SurfingMinigame_ReduceSpeedBy128:
	ld a, [wSurfingMinigamePikachuSpeed + 1]
	and a
	jr nz, .go
	ld a, [wSurfingMinigamePikachuSpeed]
	cp 0.5 ; avoid underflow when reducing speed
	jr nc, .go
	xor a
	ld [wSurfingMinigamePikachuSpeed], a
	ret

.go
	ld a, [wSurfingMinigamePikachuSpeed + 1]
	ld h, a
	ld a, [wSurfingMinigamePikachuSpeed]
	ld l, a
	ld de, -0.5 ; reduce speed after a hard landing
	add hl, de
	ld a, h
	ld [wSurfingMinigamePikachuSpeed + 1], a
	ld a, l
	ld [wSurfingMinigamePikachuSpeed], a
	ret

SurfingMinigame_TryStartJump:
	ldh a, [hSCX]
	and $7 ; horizontal pixel within the current tile
	cp $3
	jr c, .noJump
	cp $5
	jr nc, .noJump
	ld a, [wSurfingMinigameBGMapReadBuffer]
	cp $14 ; wave crest
	jr nz, .noJump
	call SurfingMinigame_GetSpeedDividedBy32
	cp $a
	jr c, .noJump
	ld [wSurfingMinigameJumpArcMagnitude], a
	call SurfingMinigame_ResetJumpArc
	scf
	ret

.noJump
	and a
	ret

SurfingMinigame_UpdateSurfingFrame:
	ldh a, [hSCX]
	and $7 ; horizontal pixel within the current tile
	cp $3
	ret c
	cp $5
	ret nc
	ld a, [wSurfingMinigameBGMapReadBuffer]
	cp $6 ; rising slope
	jr z, .risingSlope
	cp $14 ; wave crest
	jr z, .risingSlope
	cp $7 ; falling slope
	jr z, .fallingSlope
	call SurfingMinigame_UpdateBoardAngle
	ld a, $4
	ld hl, ANIM_OBJ_FRAME_SET
	add hl, bc
	ld [hl], a
	ret

.risingSlope
	ld a, $6
	jr .selectFrame

.fallingSlope
	ld a, $2
.selectFrame
	ld e, a
	ld a, [wSurfingMinigameBoardAngleOffset]
	dec a
	add e
	ld hl, ANIM_OBJ_FRAME_SET
	add hl, bc
	ld [hl], a
	ret

SurfingMinigame_UpdateBoardAngle:
	ld hl, wSurfingMinigameBoardAngleTimer
	ld a, [hl]
	inc [hl]
	and $7 ; update the board angle every eight frames
	ret nz
	ld a, [wSurfingMinigameBoardAngleDecreasing]
	and a
	jr z, .increase
	ld a, [wSurfingMinigameBoardAngleOffset]
	and a
	jr z, .startIncreasing
	dec a
	ld [wSurfingMinigameBoardAngleOffset], a
	ret

.startIncreasing
	xor a
	ld [wSurfingMinigameBoardAngleDecreasing], a
	ret

.increase
	ld a, [wSurfingMinigameBoardAngleOffset]
	cp $2
	jr z, .startDecreasing
	inc a
	ld [wSurfingMinigameBoardAngleOffset], a
	ret

.startDecreasing
	ld a, $1
	ld [wSurfingMinigameBoardAngleDecreasing], a
	ret

SurfingMinigame_GetSpeedDividedBy32:
	ld a, [wSurfingMinigamePikachuSpeed]
	ld l, a
	ld a, [wSurfingMinigamePikachuSpeed + 1]
	ld h, a
	add hl, hl
	add hl, hl
	add hl, hl
	ld a, h
	ret

SurfingMinigame_SpawnWaterSpray:
	ld hl, wSurfingMinigameWaterSprayCounter
	ld a, [hl]
	inc [hl]
	and $3
	ret nz
	call .GetYCoord
	ld d, a
	ld hl, ANIM_OBJ_X_COORD
	add hl, bc
	ld e, [hl]
	ld a, $a ; water spray
	push bc
	call SpawnAnimatedObject
	pop bc
	ret

.GetYCoord:
	ldh a, [hSCX]
	and TILE_WIDTH ; select one of the two adjacent wave-height samples
	jr nz, .getHeightPlus9
	ld hl, wSurfingMinigameWaveHeight + 8
	jr .gotHL

.getHeightPlus9
	ld hl, wSurfingMinigameWaveHeight + 9
.gotHL
	ld a, [wSurfingMinigameBGMapReadBuffer + 1]
	cp $6 ; rising slope
	jr z, .risingSlope
	cp $14 ; wave crest
	jr z, .waveCrest
	cp $7 ; falling slope
	jr z, .fallingSlope
	ld a, [hl]
	ret

.risingSlope
.waveCrest
	ldh a, [hSCX]
	and $7 ; horizontal pixel within the current tile
	ld e, a
	ld a, [hl]
	sub e
	ret

.fallingSlope
	ldh a, [hSCX]
	and $7 ; horizontal pixel within the current tile
	add [hl]
	ret

SurfingMinigame_MoveBannerToCenter:
	ld hl, ANIM_OBJ_X_COORD
	add hl, bc
	ld a, [hl]
	cp SURFING_MINIGAME_CENTER_X
	ret z
	add 4 ; move four pixels per frame
	ld [hl], a
	ret

SurfingMinigame_MaskCurrentAnimatedObject: ; unreferenced
	call MaskCurrentAnimatedObjectStruct
	ret

SurfingMinigameAnimatedObjectFn_FlippingPika:
	ld hl, ANIM_OBJ_FIELD_B
	add hl, bc
	ld a, [hl]
	and a
	ret z
	dec [hl]
	dec [hl]
	ld d, a
	ld hl, ANIM_OBJ_FIELD_C
	add hl, bc
	ld a, [hl]
	inc [hl]
	call SurfingPikachu_Sine
	cp $80
	jr nc, .positive
	xor $ff
	inc a
.positive
	ld hl, ANIM_OBJ_Y_OFFSET
	add hl, bc
	ld [hl], a
	ret

SurfingMinigameAnimatedObjectFn_IntroAnimationPikachu:
	ld hl, ANIM_OBJ_FIELD_B
	add hl, bc
	ld a, [hl]
	inc [hl]
	and $1
	ret z
	ld hl, ANIM_OBJ_X_COORD
	add hl, bc
	ld a, [hl]
	cp $c0 ; fully off the right side of the screen
	jr z, .done
	inc [hl]
	ret

.done
	ld a, $1
	ld [wSurfingMinigameIntroAnimationFinished], a
	call MaskCurrentAnimatedObjectStruct
	ret

SurfingMinigame_MoveClouds:
	ld a, [wSurfingMinigameCloudScrollFraction]
	ld e, a
	ld d, $0
	ld a, [wSurfingMinigamePikachuSpeed]
	ld l, a
	ld a, [wSurfingMinigamePikachuSpeed + 1]
	ld h, a
	add hl, de
	ld a, l
	ld [wSurfingMinigameCloudScrollFraction], a
	ld d, h
	ld hl, wShadowOAMSprite05XCoord
	ld e, 9 ; number of cloud sprites
.loop
	ld a, [hl]
	add d
	ld [hli], a
	inc hl
	inc hl
	inc hl
	dec e
	jr nz, .loop
	ret

SurfingMinigame_ReadBGMapBuffer:
	ld a, [wSurfingMinigameBGMapReadBuffer] ; unused read
	ldh a, [hSCX]
	add 9 * TILE_WIDTH ; sample the wave nine tiles into the viewport
	ld e, a
	; convert the pixel X coordinate to a tile coordinate
	srl e
	srl e
	srl e
	ld d, $0
	ld hl, vBGMap0
	add hl, de
	ld a, [wSurfingMinigamePikachuObjectHeight]
	; convert Pikachu's pixel Y coordinate to a tile coordinate
	srl a
	srl a
	srl a
	ld c, a
.loop
	ld a, c
	and a
	jr z, .copy
	dec c
	ld de, TILEMAP_WIDTH
	add hl, de
	ld a, h
	and HIGH(TILEMAP_AREA - 1)
	or HIGH(vBGMap0)
	ld h, a
	jr .loop

.copy
	ld de, wSurfingMinigameBGMapReadBuffer
	ld a, e
	ldh [hVBlankCopyDest], a
	ld a, d
	ldh [hVBlankCopyDest + 1], a
	ld a, l
	ldh [hVBlankCopySource], a
	ld a, h
	ldh [hVBlankCopySource + 1], a
	ld a, 1 ; copy one tile during VBlank
	ldh [hVBlankCopySize], a
	ret

SurfingMinigame_SetPikachuHeight:
	ldh a, [hSCX]
	and TILE_WIDTH ; select one of the two adjacent wave-height samples
	jr nz, .rightHalf
	ld hl, wSurfingMinigameWaveHeight + 7
	jr .gotWaveHeight

.rightHalf
	ld hl, wSurfingMinigameWaveHeight + 8
.gotWaveHeight
	ld a, [wSurfingMinigameBGMapReadBuffer]
	cp $6 ; rising slope
	jr z, .risingSlope
	cp $14 ; wave crest
	jr z, .waveCrest
	cp $7 ; falling slope
	jr z, .fallingSlope
	ld a, [hl]
	ld [wSurfingMinigamePikachuObjectHeight], a
	ret

.risingSlope
.waveCrest
	ldh a, [hSCX]
	and $7 ; horizontal pixel within the current tile
	ld e, a
	ld a, [hl]
	sub e
	ld [wSurfingMinigamePikachuObjectHeight], a
	ret

.fallingSlope
	ldh a, [hSCX]
	and $7 ; horizontal pixel within the current tile
	add [hl]
	ld [wSurfingMinigamePikachuObjectHeight], a
	ret

SurfingMinigame_Deduct1HP:
	ld hl, wSurfingMinigamePikachuHP
	ld e, $99
	call .BCD_Deduct
	ret nc
	inc hl
	ld e, $99
.BCD_Deduct:
	ld a, [hl]
	and a
	jr z, .rollOver
	sub $1
	daa
	ld [hl], a
	and a
	ret

.rollOver
	ld [hl], e
	scf
	ret

SurfingMinigame_DrawHP:
	ld de, wSurfingMinigamePikachuHP + 1
	ld hl, wShadowOAMSprite00TileID
	ld a, [de]
	call .PlaceBCDNumber
	ld hl, wShadowOAMSprite02TileID
	ld a, [de]
.PlaceBCDNumber:
	ld c, a
	swap a
	and $f
	add $d0
	ld [hli], a
	inc hl
	inc hl
	inc hl
	ld a, c
	and $f
	add $d0
	ld [hl], a
	dec de
	ret

SurfingMinigame_DrawResultsScreen:
	ld hl, wTileMap
	ld bc, SCREEN_AREA
	xor a
	call FillMemory
	ld hl, .BeachOutroTilemap
	decoord 0, 6
	ld bc, .BeachOutroTilemapEnd - .BeachOutroTilemap
	call CopyData
	call .PlaceTextbox
	ld hl, wShadowOAMSprite05XCoord
	ld bc, 9 * OBJ_SIZE
	xor a
	call FillMemory
	ld a, $1
	ldh [hAutoBGTransferEnabled], a
	ret

.BeachOutroTilemap:
INCBIN "gfx/surfing_pikachu/beach_outro.tilemap"
.BeachOutroTilemapEnd:

.PlaceTextbox:
	hlcoord 1, 1
	lb de, $3b, $3c
	ld a, $40
	call .placeRow
	hlcoord 1, 2
	lb de, $3f, $3f
	ld a, $ff
	call .placeRow
	hlcoord 1, 3
	lb de, $3f, $3f
	ld a, $ff
	call .placeRow
	hlcoord 1, 4
	lb de, $3f, $3f
	ld a, $ff
	call .placeRow
	hlcoord 1, 5
	lb de, $3f, $3f
	ld a, $ff
	call .placeRow
	hlcoord 1, 6
	lb de, $3f, $3f
	ld a, $ff
	call .placeRow
	hlcoord 1, 7
	lb de, $3f, $3f
	ld a, $ff
	call .placeRow
	hlcoord 1, 8
	lb de, $3f, $3f
	ld a, $ff
	call .placeRow
	hlcoord 1, 9
	lb de, $3d, $3e
	ld a, $40
	call .placeRow
	ret

.placeRow:
	ld [hl], d
	inc hl
	ld c, SCREEN_WIDTH - 4 ; box interior width
.loop
	ld [hli], a
	dec c
	jr nz, .loop
	ld [hl], e
	ret

SurfingMinigame_PrintTextHiScore:
	ld hl, .Hi_Score
	decoord 6, 8
	ld bc, .Hi_ScoreEnd - .Hi_Score
	call CopyData
	ret

.Hi_Score:
	db $20, $2e, $2f, $30, $31, $2c, $32, $23, $33 ; Hi-Score!!
.Hi_ScoreEnd:

SurfingMinigame_WriteHPLeft:
	ld hl, .HP_Left
	decoord 2, 2
	ld bc, .HP_LeftEnd - .HP_Left
	call CopyData
	call SurfingMinigame_BCDPrintHPLeft
	ret

.HP_Left:
	db $20, $21, $ff, $22, $23, $24, $25 ; HP Left
.HP_LeftEnd:

SurfingMinigame_AddRemainingHPToTotal:
	ld c, 99
.loop
	push bc
	ld hl, wSurfingMinigamePikachuHP
	ld a, [hli]
	or [hl]
	and a
	jr z, .dead
	call SurfingMinigame_Deduct1HP
	ld e, $1
	call SurfingMinigame_AddPointsToTotal
	pop bc
	dec c
	jr nz, .loop
	ld a, SFX_PRESS_AB
	call PlaySound
	and a
	ret

.dead
	pop bc
	scf
	ret

SurfingMinigame_BCDPrintHPLeft:
	hlcoord 10, 2
	ld de, wSurfingMinigamePikachuHP + 1
	ld a, [de]
	call SurfingPikachu_PlaceBCDNumber
	inc hl
	ld a, [de]
	call SurfingPikachu_PlaceBCDNumber
	inc hl
	inc hl
	ld [hl], $21 ; P
	inc hl
	ld [hl], $25 ; t
	inc hl
	ld [hl], $26 ; s
	ret

SurfingMinigame_WriteRadness:
	ld hl, .Radness
	decoord 2, 4
	ld bc, .RadnessEnd - .Radness
	call CopyData
	call SurfingMinigame_BCDPrintRadness
	ret

.Radness:
	db $27, $28, $29, $2a, $23, $26, $26 ; Radness
.RadnessEnd:

SurfingMinigame_AddRadnessToTotal:
	ld c, 99
.loop
	push bc
	ld hl, wSurfingMinigameRadnessScore
	ld a, [hli]
	ld e, a
	or [hl]
	jr z, .done
	ld d, [hl]
	ld a, e
	sub $1
	daa
	ld e, a
	ld a, d
	sbc $0
	daa
	ld [hld], a
	ld [hl], e
	ld e, $1
	call SurfingMinigame_AddPointsToTotal
	pop bc
	dec c
	jr nz, .loop
	ld a, SFX_PRESS_AB
	call PlaySound
	and a
	ret

.done
	pop bc
	scf
	ret

SurfingMinigame_BCDPrintRadness:
	ld a, [wSurfingMinigameRadnessScore + 1]
	hlcoord 10, 4
	call SurfingPikachu_PlaceBCDNumber
	ld a, [wSurfingMinigameRadnessScore]
	hlcoord 12, 4
	call SurfingPikachu_PlaceBCDNumber
	inc hl
	inc hl
	ld [hl], $21 ; P
	inc hl
	ld [hl], $25 ; t
	inc hl
	ld [hl], $26 ; s
	ret

SurfingMinigame_AddPointsToTotal:
	ld a, [wSurfingMinigameTotalScore]
	add e
	daa
	ld [wSurfingMinigameTotalScore], a
	ld a, [wSurfingMinigameTotalScore + 1]
	adc $0
	daa
	ld [wSurfingMinigameTotalScore + 1], a
	ret nc
	ld a, $99
	ld [wSurfingMinigameTotalScore], a
	ld [wSurfingMinigameTotalScore + 1], a
	ret

SurfingMinigame_BCDPrintTotalScore:
	ld a, [wSurfingMinigameTotalScore + 1]
	hlcoord 10, 6
	call SurfingPikachu_PlaceBCDNumber
	ld a, [wSurfingMinigameTotalScore]
	hlcoord 12, 6
	call SurfingPikachu_PlaceBCDNumber
	inc hl
	inc hl
	ld [hl], $21 ; P
	inc hl
	ld [hl], $25 ; t
	inc hl
	ld [hl], $26 ; s
	ret

SurfingMinigame_WriteTotal:
	ld hl, .Total
	decoord 2, 6
	ld bc, .TotalEnd - .Total
	call CopyData
	call SurfingMinigame_BCDPrintRadness
	call SurfingMinigame_BCDPrintTotalScore
	ret

.Total:
	db $2b, $2c, $25, $28, $2d ; Total
.TotalEnd:

DidPlayerGetAHighScore:
	ld hl, wSurfingMinigameHiScore + 1
	ld a, [wSurfingMinigameTotalScore + 1]
	cp [hl]
	jr c, .notHighScore
	jr nz, .highScore
	dec hl
	ld a, [wSurfingMinigameTotalScore]
	cp [hl]
	jr c, .notHighScore
	jr nz, .highScore
.notHighScore
	call WaitForSoundToFinish
	ldpikacry e, PikachuCry28
	call SurfingMinigame_PlayPikaCryIfSurfingPikaInParty
	and a
	ret

.highScore
	ld a, [wSurfingMinigameTotalScore]
	ld [wSurfingMinigameHiScore], a
	ld a, [wSurfingMinigameTotalScore + 1]
	ld [wSurfingMinigameHiScore + 1], a
	call WaitForSoundToFinish
	ldpikacry e, PikachuCry34
	call SurfingMinigame_PlayPikaCryIfSurfingPikaInParty
	ld a, SFX_GET_ITEM2_4_2
	call PlaySound
	scf
	ret

SurfingMinigame_PlayPikaCryIfSurfingPikaInParty:
	push de
	callfar IsSurfingStarterPikachuInParty
	pop de
	ret nc
	callfar PlayPikachuSoundClip
	ret

SurfingMinigame_IncreaseRadnessMeter:
	ld a, [wSurfingMinigameRadnessMeter]
	inc a
	cp $4
	jr c, .cap
	ld a, $3
.cap
	ld [wSurfingMinigameRadnessMeter], a
	ret

SurfingMinigame_CalculateAndAddRadnessFromStunt:
	; Compute the amount of radness points from the
	; current trick based on the number of
	; consecutive flips
	; Single flip:                +0050
	; 2 of the same flip:         +0150
	; 3 or more of the same flip: +0350
	; 2 different flips:          +0180
	; 3 or more different flips:  +0500
	ld a, [wSurfingMinigameRadnessMeter]
	and a
	ret z
	ld a, [wSurfingMinigameTrickFlags]
	and $3
	cp $3 ; did a combination of front and back flips
	jr z, .mixedChain
	ld a, [wSurfingMinigameRadnessMeter]
	ld d, a
	ld e, $1
	ld a, $0
.getAmountOfRadness
	add e
	sla e
	dec d
	jr nz, .getAmountOfRadness
.addRadness50AtATime
	push af
	ld e, $50
	call SurfingMinigame_AddRadness
	pop af
	dec a
	jr nz, .addRadness50AtATime
	ld hl, ANIM_OBJ_Y_COORD
	add hl, bc
	ld a, [hl]
	sub $10
	ld d, a
	ld hl, ANIM_OBJ_X_COORD
	add hl, bc
	ld e, [hl]
	ld a, [wSurfingMinigameRadnessMeter]
	add $3
	push bc
	call SpawnAnimatedObject
	pop bc
	ret

.mixedChain
	ld a, [wSurfingMinigameRadnessMeter]
	cp $3
	jr c, .add180RadnessPoints
	ld a, 10
.add500Radness50AtATime
	push af
	ld e, $50
	call SurfingMinigame_AddRadness
	pop af
	dec a
	jr nz, .add500Radness50AtATime
	ld hl, ANIM_OBJ_Y_COORD
	add hl, bc
	ld a, [hl]
	sub $10
	ld d, a
	ld hl, ANIM_OBJ_X_COORD
	add hl, bc
	ld e, [hl]
	ld a, $9
	push bc
	call SpawnAnimatedObject
	pop bc
	ret

.add180RadnessPoints
	ld e, $50
	call SurfingMinigame_AddRadness
	ld e, $50
	call SurfingMinigame_AddRadness
	ld e, $50
	call SurfingMinigame_AddRadness
	ld e, $30
	call SurfingMinigame_AddRadness
	ld hl, ANIM_OBJ_Y_COORD
	add hl, bc
	ld a, [hl]
	sub $10
	ld d, a
	ld hl, ANIM_OBJ_X_COORD
	add hl, bc
	ld e, [hl]
	ld a, $8
	push bc
	call SpawnAnimatedObject
	pop bc
	ret

SurfingMinigame_AddRadness:
	ld a, [wSurfingMinigameRadnessScore]
	add e
	daa
	ld [wSurfingMinigameRadnessScore], a
	ld a, [wSurfingMinigameRadnessScore + 1]
	adc $0
	daa
	ld [wSurfingMinigameRadnessScore + 1], a
	ret nc
	ld a, $99
	ld [wSurfingMinigameRadnessScore], a
	ld [wSurfingMinigameRadnessScore + 1], a
	ret

SurfingMinigame_CoastAfterGoal:
	ld a, $a0 ; generate tiles ahead of the viewport
	ld [wSurfingMinigameXOffset], a
	ldh a, [hSCX]
	ld h, a
	ld a, [wSurfingMinigameSCX]
	ld l, a
	ld de, 9.0 ; pixels per frame
	add hl, de
	ld a, l
	ld [wSurfingMinigameSCX], a
	ld a, h
	ldh [hSCX], a
	jr SurfingMinigame_GenerateBGMap

SurfingMinigame_ScrollAndGenerateBGMap:
	ld a, $a0 ; generate tiles ahead of the viewport
	ld [wSurfingMinigameXOffset], a
	ldh a, [hSCX]
	ld h, a
	ld a, [wSurfingMinigameSCX]
	ld l, a
	ld de, 1.5 ; pixels per frame
	add hl, de
	ld a, l
	ld [wSurfingMinigameSCX], a
	ld a, h
	ldh [hSCX], a
SurfingMinigame_GenerateBGMap:
	ld hl, wSurfingMinigameSCX2
	ldh a, [hSCX]
	cp [hl]
	ret z
	ld [hl], a
	and $f0 ; align to a two-tile boundary
	ld hl, wSurfingMinigameSCXHi
	cp [hl]
	ret z
	ld [hl], a
	call SurfingMinigame_GetWaveDataPointers
	; b and c contain the height of the next wave to appear
	; on screen, in number of pixels from the top of the screen
	ld a, b
	ld [wSurfingMinigameWaveHeightBuffer], a
	ld a, c
	ld [wSurfingMinigameWaveHeightBuffer + 1], a
	push de
	ld hl, wSurfingMinigameWaveHeight
	ld de, wSurfingMinigameWaveHeight + 2
	ld c, SCREEN_WIDTH - 2
.copyLoop
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .copyLoop
	ld a, [wSurfingMinigameWaveHeightBuffer]
	ld [hli], a
	ld a, [wSurfingMinigameWaveHeightBuffer + 1]
	ld [hl], a
	pop de
	ld hl, wRedrawRowOrColumnSrcTiles
	ld c, SurfingMinigameWavePattern01 - SurfingMinigameWavePattern00
.loop
	ld a, [de]
	call .CopyRedrawSrcTiles
	inc de
	dec c
	jr nz, .loop
	ld a, [wSurfingMinigameXOffset]
	ld e, a
	ldh a, [hSCX]
	add e
	and $f0 ; align to a two-tile boundary
	srl a
	srl a
	srl a
	ld e, a
	ld d, $0
	ld hl, vBGMap0
	add hl, de
	ld a, l
	ldh [hRedrawRowOrColumnDest], a
	ld a, h
	ldh [hRedrawRowOrColumnDest + 1], a
	ld a, $1
	ldh [hRedrawRowOrColumnMode], a
	ret

.CopyRedrawSrcTiles:
	push de
	push hl
	ld l, a
	ld h, $0
	ld de, SurfingMinigame_BGMetatileTable
	add hl, hl
	add hl, hl
	add hl, de
	ld e, l
	ld d, h
	pop hl
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	pop de
	ret

SurfingMinigame_GetWaveDataPointers:
	ld a, [wSurfingMinigameWaveFunctionNumber]
	ld e, a
	ld d, $0
	ld hl, .WaveFunctions
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

.WaveFunctions:
	; Each state selects the next 8-metatile slice of a wave sequence.
	dw SurfingMinigame_ChooseNextWaveSequence ; 00

	dw SurfingMinigame_LoadWavePattern13AndAdvance ; 01
	dw SurfingMinigame_LoadWavePattern14AndAdvance ; 02
	dw SurfingMinigame_LoadWavePattern15AndAdvance ; 03
	dw SurfingMinigame_LoadWavePattern16AndAdvance ; 04
	dw SurfingMinigame_LoadWavePattern00AndAdvance ; 05
	dw SurfingMinigame_LoadWavePattern17AndAdvance ; 06
	dw SurfingMinigame_LoadWavePattern18AndAdvance ; 07
	dw SurfingMinigame_LoadWavePattern19AndAdvance ; 08
	dw SurfingMinigame_LoadWavePattern00AndAdvance ; 09
	dw SurfingMinigame_LoadWavePattern00AndAdvance ; 0a
	dw SurfingMinigame_LoadWavePattern00AndAdvance ; 0b
	dw SurfingMinigame_LoadWavePattern00AndAdvance ; 0c
	dw SurfingMinigame_LoadFlatWaveAndReset ; 0d

	dw SurfingMinigame_LoadWavePattern08AndAdvance ; 0e
	dw SurfingMinigame_LoadWavePattern09AndAdvance ; 0f
	dw SurfingMinigame_LoadWavePattern0AAndAdvance ; 10
	dw SurfingMinigame_LoadWavePattern0BAndAdvance ; 11
	dw SurfingMinigame_LoadWavePattern0CAndAdvance ; 12
	dw SurfingMinigame_LoadWavePattern0DAndAdvance ; 13
	dw SurfingMinigame_LoadWavePattern00AndAdvance ; 14
	dw SurfingMinigame_LoadWavePattern00AndAdvance ; 15
	dw SurfingMinigame_LoadWavePattern00AndAdvance ; 16
	dw SurfingMinigame_LoadWavePattern00AndAdvance ; 17
	dw SurfingMinigame_LoadWavePattern00AndAdvance ; 18
	dw SurfingMinigame_LoadFlatWaveAndReset ; 19

	dw SurfingMinigame_LoadWavePattern0EAndAdvance ; 1a
	dw SurfingMinigame_LoadWavePattern0FAndAdvance ; 1b
	dw SurfingMinigame_LoadWavePattern10AndAdvance ; 1c
	dw SurfingMinigame_LoadWavePattern11AndAdvance ; 1d
	dw SurfingMinigame_LoadWavePattern12AndAdvance ; 1e
	dw SurfingMinigame_LoadWavePattern0EAndAdvance ; 1f
	dw SurfingMinigame_LoadWavePattern0FAndAdvance ; 20
	dw SurfingMinigame_LoadWavePattern10AndAdvance ; 21
	dw SurfingMinigame_LoadWavePattern11AndAdvance ; 22
	dw SurfingMinigame_LoadWavePattern12AndAdvance ; 23
	dw SurfingMinigame_LoadWavePattern00AndAdvance ; 24
	dw SurfingMinigame_LoadWavePattern00AndAdvance ; 25
	dw SurfingMinigame_LoadWavePattern00AndAdvance ; 26
	dw SurfingMinigame_LoadWavePattern00AndAdvance ; 27
	dw SurfingMinigame_LoadFlatWaveAndReset ; 28

	dw SurfingMinigame_LoadWavePattern13AndAdvance ; 29
	dw SurfingMinigame_LoadWavePattern14AndAdvance ; 2a
	dw SurfingMinigame_LoadWavePattern15AndAdvance ; 2b
	dw SurfingMinigame_LoadWavePattern16AndAdvance ; 2c
	dw SurfingMinigame_LoadWavePattern00AndAdvance ; 2d
	dw SurfingMinigame_LoadWavePattern00AndAdvance ; 2e
	dw SurfingMinigame_LoadWavePattern00AndAdvance ; 2f
	dw SurfingMinigame_LoadWavePattern00AndAdvance ; 30
	dw SurfingMinigame_LoadFlatWaveAndReset ; 31

	dw SurfingMinigame_LoadWavePattern17AndAdvance ; 32
	dw SurfingMinigame_LoadWavePattern18AndAdvance ; 33
	dw SurfingMinigame_LoadWavePattern19AndAdvance ; 34
	dw SurfingMinigame_LoadWavePattern17AndAdvance ; 35
	dw SurfingMinigame_LoadWavePattern18AndAdvance ; 36
	dw SurfingMinigame_LoadWavePattern19AndAdvance ; 37
	dw SurfingMinigame_LoadWavePattern17AndAdvance ; 38
	dw SurfingMinigame_LoadWavePattern18AndAdvance ; 39
	dw SurfingMinigame_LoadWavePattern19AndAdvance ; 3a
	dw SurfingMinigame_LoadWavePattern00AndAdvance ; 3b
	dw SurfingMinigame_LoadWavePattern00AndAdvance ; 3c
	dw SurfingMinigame_LoadWavePattern00AndAdvance ; 3d
	dw SurfingMinigame_LoadWavePattern00AndAdvance ; 3e
	dw SurfingMinigame_LoadFlatWaveAndReset ; 3f

	dw SurfingMinigame_LoadWavePattern1AAndAdvance ; 40
	dw SurfingMinigame_LoadWavePattern1BAndAdvance ; 41
	dw SurfingMinigame_LoadWavePattern0EAndAdvance ; 42
	dw SurfingMinigame_LoadWavePattern0FAndAdvance ; 43
	dw SurfingMinigame_LoadWavePattern10AndAdvance ; 44
	dw SurfingMinigame_LoadWavePattern11AndAdvance ; 45
	dw SurfingMinigame_LoadWavePattern12AndAdvance ; 46
	dw SurfingMinigame_LoadWavePattern1AAndAdvance ; 47
	dw SurfingMinigame_LoadWavePattern1BAndAdvance ; 48
	dw SurfingMinigame_LoadWavePattern00AndAdvance ; 49
	dw SurfingMinigame_LoadWavePattern00AndAdvance ; 4a
	dw SurfingMinigame_LoadWavePattern00AndAdvance ; 4b
	dw SurfingMinigame_LoadFlatWaveAndReset ; 4c

	dw SurfingMinigame_LoadWavePattern08AndAdvance ; 4d
	dw SurfingMinigame_LoadWavePattern09AndAdvance ; 4e
	dw SurfingMinigame_LoadWavePattern0AAndAdvance ; 4f
	dw SurfingMinigame_LoadWavePattern0BAndAdvance ; 50
	dw SurfingMinigame_LoadWavePattern0CAndAdvance ; 51
	dw SurfingMinigame_LoadWavePattern0DAndAdvance ; 52
	dw SurfingMinigame_LoadWavePattern00AndAdvance ; 53
	dw SurfingMinigame_LoadWavePattern1AAndAdvance ; 54
	dw SurfingMinigame_LoadWavePattern1BAndAdvance ; 55
	dw SurfingMinigame_LoadWavePattern1AAndAdvance ; 56
	dw SurfingMinigame_LoadWavePattern1BAndAdvance ; 57
	dw SurfingMinigame_LoadWavePattern00AndAdvance ; 58
	dw SurfingMinigame_LoadWavePattern00AndAdvance ; 59
	dw SurfingMinigame_LoadWavePattern00AndAdvance ; 5a
	dw SurfingMinigame_LoadFlatWaveAndReset ; 5b

	dw SurfingMinigame_LoadWavePattern0EAndAdvance ; 5c
	dw SurfingMinigame_LoadWavePattern0FAndAdvance ; 5d
	dw SurfingMinigame_LoadWavePattern10AndAdvance ; 5e
	dw SurfingMinigame_LoadWavePattern11AndAdvance ; 5f
	dw SurfingMinigame_LoadWavePattern12AndAdvance ; 60
	dw SurfingMinigame_LoadWavePattern13AndAdvance ; 61
	dw SurfingMinigame_LoadWavePattern14AndAdvance ; 62
	dw SurfingMinigame_LoadWavePattern15AndAdvance ; 63
	dw SurfingMinigame_LoadWavePattern16AndAdvance ; 64
	dw SurfingMinigame_LoadWavePattern00AndAdvance ; 65
	dw SurfingMinigame_LoadWavePattern00AndAdvance ; 66
	dw SurfingMinigame_LoadWavePattern00AndAdvance ; 67
	dw SurfingMinigame_LoadWavePattern00AndAdvance ; 68
	dw SurfingMinigame_LoadFlatWaveAndReset ; 69

	dw SurfingMinigame_LoadWavePattern01AndAdvance ; 6a
	dw SurfingMinigame_LoadWavePattern02AndAdvance ; 6b
	dw SurfingMinigame_LoadWavePattern03AndAdvance ; 6c
	dw SurfingMinigame_LoadWavePattern04AndAdvance ; 6d
	dw SurfingMinigame_LoadWavePattern05AndAdvance ; 6e
	dw SurfingMinigame_LoadWavePattern06AndAdvance ; 6f
	dw SurfingMinigame_LoadWavePattern07AndAdvance ; 70
	dw SurfingMinigame_LoadFlatWave ; 71

	dw SurfingMinigame_LoadWavePattern00AndAdvance ; 72
	dw SurfingMinigame_LoadWavePattern1CAndAdvance ; 73
	dw SurfingMinigame_LoadBeachPatternAndAdvance ; 74
	dw SurfingMinigame_LoadBeachPatternAndAdvance ; 75
	dw SurfingMinigame_LoadBeachPatternAndAdvance ; 76
	dw SurfingMinigame_LoadBeachPatternAndAdvance ; 77
	dw SurfingMinigame_LoadBeachPatternAndAdvance ; 78
	dw SurfingMinigame_LoadBeachPatternAndAdvance ; 79
	dw SurfingMinigame_LoadBeachPatternAndAdvance ; 7a
	dw SurfingMinigame_LoadBeachPatternAndReset ; 7b

SurfingMinigame_ChooseNextWaveSequence:
	ld a, [wSurfingMinigameDistance]
	cp $16 ; force the final "Big Kahuna" wave at section 22
	jr c, .checkParam
	jr z, .bigKahuna
	jr nc, .gotWave
.bigKahuna
	ld a, $6a
	jr .gotNextFn

.checkParam
	ld a, [wSurfingMinigameWaveRandomValue]
	and a
	jr z, .gotWave
	dec a
	and $7
	ld e, a
	ld d, $0
	ld hl, SurfingMinigame_WaveSequenceStarts
	add hl, de
	ld a, [hl]
.gotNextFn
	ld [wSurfingMinigameWaveFunctionNumber], a
.gotWave
	lb bc, SURFING_MINIGAME_FLAT_WATER_Y, SURFING_MINIGAME_FLAT_WATER_Y
	ld de, SurfingMinigameWavePattern00
	ret

SurfingMinigame_WaveSequenceStarts:
	; Starting states for the eight randomly selected wave sequences.
	db $01, $0e, $1a, $29, $32, $40, $4d, $5c

; b and c are the left and right wave heights in screen pixels.
; de points to the eight metatiles that form the next course slice.
SurfingMinigame_LoadWavePattern00AndAdvance:
	lb bc, SURFING_MINIGAME_FLAT_WATER_Y, SURFING_MINIGAME_FLAT_WATER_Y
	ld de, SurfingMinigameWavePattern00
	jp SurfingMinigame_AdvanceWaveFunction

SurfingMinigame_LoadWavePattern01AndAdvance:
	lb bc, SURFING_MINIGAME_FLAT_WATER_Y, SURFING_MINIGAME_FLAT_WATER_Y - 1 * TILE_HEIGHT
	ld de, SurfingMinigameWavePattern01
	jp SurfingMinigame_AdvanceWaveFunction

SurfingMinigame_LoadWavePattern02AndAdvance:
	lb bc, SURFING_MINIGAME_FLAT_WATER_Y - 2 * TILE_HEIGHT, SURFING_MINIGAME_FLAT_WATER_Y - 3 * TILE_HEIGHT
	ld de, SurfingMinigameWavePattern02
	jp SurfingMinigame_AdvanceWaveFunction

SurfingMinigame_LoadWavePattern03AndAdvance:
	lb bc, SURFING_MINIGAME_FLAT_WATER_Y - 4 * TILE_HEIGHT, SURFING_MINIGAME_FLAT_WATER_Y - 5 * TILE_HEIGHT
	ld de, SurfingMinigameWavePattern03
	jp SurfingMinigame_AdvanceWaveFunction

SurfingMinigame_LoadWavePattern04AndAdvance:
	lb bc, SURFING_MINIGAME_FLAT_WATER_Y - 6 * TILE_HEIGHT, SURFING_MINIGAME_FLAT_WATER_Y - 6 * TILE_HEIGHT
	ld de, SurfingMinigameWavePattern04
	jp SurfingMinigame_AdvanceWaveFunction

SurfingMinigame_LoadWavePattern05AndAdvance:
	lb bc, SURFING_MINIGAME_FLAT_WATER_Y - 6 * TILE_HEIGHT, SURFING_MINIGAME_FLAT_WATER_Y - 5 * TILE_HEIGHT
	ld de, SurfingMinigameWavePattern05
	jp SurfingMinigame_AdvanceWaveFunction

SurfingMinigame_LoadWavePattern06AndAdvance:
	lb bc, SURFING_MINIGAME_FLAT_WATER_Y - 4 * TILE_HEIGHT, SURFING_MINIGAME_FLAT_WATER_Y - 3 * TILE_HEIGHT
	ld de, SurfingMinigameWavePattern06
	jp SurfingMinigame_AdvanceWaveFunction

SurfingMinigame_LoadWavePattern07AndAdvance:
	lb bc, SURFING_MINIGAME_FLAT_WATER_Y - 2 * TILE_HEIGHT, SURFING_MINIGAME_FLAT_WATER_Y - 1 * TILE_HEIGHT
	ld de, SurfingMinigameWavePattern07
	jp SurfingMinigame_AdvanceWaveFunction

SurfingMinigame_LoadWavePattern08AndAdvance:
	lb bc, SURFING_MINIGAME_FLAT_WATER_Y, SURFING_MINIGAME_FLAT_WATER_Y - 1 * TILE_HEIGHT
	ld de, SurfingMinigameWavePattern08
	jp SurfingMinigame_AdvanceWaveFunction

SurfingMinigame_LoadWavePattern09AndAdvance:
	lb bc, SURFING_MINIGAME_FLAT_WATER_Y - 2 * TILE_HEIGHT, SURFING_MINIGAME_FLAT_WATER_Y - 3 * TILE_HEIGHT
	ld de, SurfingMinigameWavePattern09
	jp SurfingMinigame_AdvanceWaveFunction

SurfingMinigame_LoadWavePattern0AAndAdvance:
	lb bc, SURFING_MINIGAME_FLAT_WATER_Y - 4 * TILE_HEIGHT, SURFING_MINIGAME_FLAT_WATER_Y - 5 * TILE_HEIGHT
	ld de, SurfingMinigameWavePattern0A
	jp SurfingMinigame_AdvanceWaveFunction

SurfingMinigame_LoadWavePattern0BAndAdvance:
	lb bc, SURFING_MINIGAME_FLAT_WATER_Y - 5 * TILE_HEIGHT, SURFING_MINIGAME_FLAT_WATER_Y - 5 * TILE_HEIGHT
	ld de, SurfingMinigameWavePattern0B
	jp SurfingMinigame_AdvanceWaveFunction

SurfingMinigame_LoadWavePattern0CAndAdvance:
	lb bc, SURFING_MINIGAME_FLAT_WATER_Y - 4 * TILE_HEIGHT, SURFING_MINIGAME_FLAT_WATER_Y - 3 * TILE_HEIGHT
	ld de, SurfingMinigameWavePattern0C
	jp SurfingMinigame_AdvanceWaveFunction

SurfingMinigame_LoadWavePattern0DAndAdvance:
	lb bc, SURFING_MINIGAME_FLAT_WATER_Y - 2 * TILE_HEIGHT, SURFING_MINIGAME_FLAT_WATER_Y - 1 * TILE_HEIGHT
	ld de, SurfingMinigameWavePattern0D
	jp SurfingMinigame_AdvanceWaveFunction

SurfingMinigame_LoadWavePattern0EAndAdvance:
	lb bc, SURFING_MINIGAME_FLAT_WATER_Y, SURFING_MINIGAME_FLAT_WATER_Y - 1 * TILE_HEIGHT
	ld de, SurfingMinigameWavePattern0E
	jp SurfingMinigame_AdvanceWaveFunction

SurfingMinigame_LoadWavePattern0FAndAdvance:
	lb bc, SURFING_MINIGAME_FLAT_WATER_Y - 2 * TILE_HEIGHT, SURFING_MINIGAME_FLAT_WATER_Y - 3 * TILE_HEIGHT
	ld de, SurfingMinigameWavePattern0F
	jp SurfingMinigame_AdvanceWaveFunction

SurfingMinigame_LoadWavePattern10AndAdvance:
	lb bc, SURFING_MINIGAME_FLAT_WATER_Y - 4 * TILE_HEIGHT, SURFING_MINIGAME_FLAT_WATER_Y - 4 * TILE_HEIGHT
	ld de, SurfingMinigameWavePattern10
	jp SurfingMinigame_AdvanceWaveFunction

SurfingMinigame_LoadWavePattern11AndAdvance:
	lb bc, SURFING_MINIGAME_FLAT_WATER_Y - 4 * TILE_HEIGHT, SURFING_MINIGAME_FLAT_WATER_Y - 3 * TILE_HEIGHT
	ld de, SurfingMinigameWavePattern11
	jp SurfingMinigame_AdvanceWaveFunction

SurfingMinigame_LoadWavePattern12AndAdvance:
	lb bc, SURFING_MINIGAME_FLAT_WATER_Y - 2 * TILE_HEIGHT, SURFING_MINIGAME_FLAT_WATER_Y - 1 * TILE_HEIGHT
	ld de, SurfingMinigameWavePattern12
	jp SurfingMinigame_AdvanceWaveFunction

SurfingMinigame_LoadWavePattern13AndAdvance:
	lb bc, SURFING_MINIGAME_FLAT_WATER_Y, SURFING_MINIGAME_FLAT_WATER_Y - 1 * TILE_HEIGHT
	ld de, SurfingMinigameWavePattern13
	jp SurfingMinigame_AdvanceWaveFunction

SurfingMinigame_LoadWavePattern14AndAdvance:
	lb bc, SURFING_MINIGAME_FLAT_WATER_Y - 2 * TILE_HEIGHT, SURFING_MINIGAME_FLAT_WATER_Y - 3 * TILE_HEIGHT
	ld de, SurfingMinigameWavePattern14
	jp SurfingMinigame_AdvanceWaveFunction

SurfingMinigame_LoadWavePattern15AndAdvance:
	lb bc, SURFING_MINIGAME_FLAT_WATER_Y - 3 * TILE_HEIGHT, SURFING_MINIGAME_FLAT_WATER_Y - 3 * TILE_HEIGHT
	ld de, SurfingMinigameWavePattern15
	jp SurfingMinigame_AdvanceWaveFunction

SurfingMinigame_LoadWavePattern16AndAdvance:
	lb bc, SURFING_MINIGAME_FLAT_WATER_Y - 2 * TILE_HEIGHT, SURFING_MINIGAME_FLAT_WATER_Y - 1 * TILE_HEIGHT
	ld de, SurfingMinigameWavePattern16
	jp SurfingMinigame_AdvanceWaveFunction

SurfingMinigame_LoadWavePattern17AndAdvance:
	lb bc, SURFING_MINIGAME_FLAT_WATER_Y, SURFING_MINIGAME_FLAT_WATER_Y - 1 * TILE_HEIGHT
	ld de, SurfingMinigameWavePattern17
	jp SurfingMinigame_AdvanceWaveFunction

SurfingMinigame_LoadWavePattern18AndAdvance:
	lb bc, SURFING_MINIGAME_FLAT_WATER_Y - 2 * TILE_HEIGHT, SURFING_MINIGAME_FLAT_WATER_Y - 2 * TILE_HEIGHT
	ld de, SurfingMinigameWavePattern18
	jp SurfingMinigame_AdvanceWaveFunction

SurfingMinigame_LoadWavePattern19AndAdvance:
	lb bc, SURFING_MINIGAME_FLAT_WATER_Y - 2 * TILE_HEIGHT, SURFING_MINIGAME_FLAT_WATER_Y - 1 * TILE_HEIGHT
	ld de, SurfingMinigameWavePattern19
	jp SurfingMinigame_AdvanceWaveFunction

SurfingMinigame_LoadWavePattern1AAndAdvance:
	lb bc, SURFING_MINIGAME_FLAT_WATER_Y, SURFING_MINIGAME_FLAT_WATER_Y - 1 * TILE_HEIGHT
	ld de, SurfingMinigameWavePattern1A
	jp SurfingMinigame_AdvanceWaveFunction

SurfingMinigame_LoadWavePattern1BAndAdvance:
	lb bc, SURFING_MINIGAME_FLAT_WATER_Y - 1 * TILE_HEIGHT, SURFING_MINIGAME_FLAT_WATER_Y - 1 * TILE_HEIGHT
	ld de, SurfingMinigameWavePattern1B
	jp SurfingMinigame_AdvanceWaveFunction

SurfingMinigame_LoadWavePattern1CAndAdvance:
	lb bc, SURFING_MINIGAME_FLAT_WATER_Y, SURFING_MINIGAME_FLAT_WATER_Y
	ld de, SurfingMinigameWavePattern1C
	jp SurfingMinigame_AdvanceWaveFunction

SurfingMinigame_LoadBeachPatternAndAdvance:
	lb bc, SURFING_MINIGAME_FLAT_WATER_Y, SURFING_MINIGAME_FLAT_WATER_Y
	ld de, SurfingMinigameBeachPattern
	jp SurfingMinigame_AdvanceWaveFunction

SurfingMinigame_LoadBeachPatternAndReset:
	lb bc, SURFING_MINIGAME_FLAT_WATER_Y, SURFING_MINIGAME_FLAT_WATER_Y
	ld de, SurfingMinigameBeachPattern
	jp SurfingMinigame_ResetWaveSequence

SurfingMinigame_LoadFlatWaveAndReset:
	lb bc, SURFING_MINIGAME_FLAT_WATER_Y, SURFING_MINIGAME_FLAT_WATER_Y
	ld de, SurfingMinigameWavePattern00
	jp SurfingMinigame_ResetWaveSequence

SurfingMinigame_LoadFlatWave:
	lb bc, SURFING_MINIGAME_FLAT_WATER_Y, SURFING_MINIGAME_FLAT_WATER_Y
	ld de, SurfingMinigameWavePattern00
	ret

SurfingMinigame_AdvanceWaveFunctionFromA: ; unused
	inc a
	ld [wSurfingMinigameWaveFunctionNumber], a
	ret

SurfingMinigame_AdvanceWaveFunction:
	ld hl, wSurfingMinigameWaveFunctionNumber
	inc [hl]
	ret

SurfingMinigame_ResetWaveSequence:
	xor a
	ld [wSurfingMinigameWaveFunctionNumber], a
	ret

SurfingPikachuMinigameIntro:
	call SurfingPikachu_ClearTileMap
	call ClearSprites
	call DisableLCD
	xor a
	ldh [hAutoBGTransferEnabled], a
	call ClearObjectAnimationBuffers
	ld hl, SurfingPikachu1Graphics3
	ld de, vChars1
	ld bc, 144 tiles
	ld a, BANK(SurfingPikachu1Graphics3)
	call FarCopyData
	ld a, LOW(SurfingPikachuObjectSpawnData)
	ld [wAnimatedObjectSpawnStateDataPointer], a
	ld a, HIGH(SurfingPikachuObjectSpawnData)
	ld [wAnimatedObjectSpawnStateDataPointer + 1], a
	ld a, LOW(SurfingPikachuObjectCallbacks)
	ld [wAnimatedObjectJumptablePointer], a
	ld a, HIGH(SurfingPikachuObjectCallbacks)
	ld [wAnimatedObjectJumptablePointer + 1], a
	ld a, LOW(SurfingPikachuOAMData)
	ld [wAnimatedObjectOAMDataPointer], a
	ld a, HIGH(SurfingPikachuOAMData)
	ld [wAnimatedObjectOAMDataPointer + 1], a
	ld a, LOW(SurfingPikachuFrames)
	ld [wAnimatedObjectFramesDataPointer], a
	ld a, HIGH(SurfingPikachuFrames)
	ld [wAnimatedObjectFramesDataPointer + 1], a
	ld a, $c ; intro Pikachu
	lb de, SURFING_MINIGAME_FLAT_WATER_Y, SURFING_MINIGAME_CENTER_X
	call SpawnAnimatedObject
	call DrawSurfingPikachuMinigameIntroBackground
	xor a
	ldh [hSCX], a
	ldh [hSCY], a
	ld a, SCREEN_HEIGHT_PX ; keep the window below the visible screen
	ldh [hWY], a
	ld b, SET_PAL_SURFING_PIKACHU_MINIGAME
	call RunPaletteCommand
	ld a, LCDC_ON | LCDC_WIN_9C00 | LCDC_WIN_ON | LCDC_OBJ_ON | LCDC_BG_ON
	ldh [rLCDC], a
	ld a, $1
	ldh [hAutoBGTransferEnabled], a
	call DelayFrame
	call DelayFrame
	call DelayFrame
	call SurfingPikachuMinigame_SetBGPals
	ldpal a, SHADE_BLACK, SHADE_DARK, SHADE_LIGHT, SHADE_WHITE
	ldh [rOBP0], a
	ldpal a, SHADE_BLACK, SHADE_DARK, SHADE_WHITE, SHADE_WHITE
	ldh [rOBP1], a
	call UpdateCGBPal_OBP0
	call UpdateCGBPal_OBP1
	call DelayFrame
	ld a, MUSIC_SURFING_PIKACHU
	ld c, BANK(Music_SurfingPikachu)
	call PlayMusic
	xor a
	ld [wSurfingMinigameIntroAnimationFinished], a
.loop
	ld a, [wSurfingMinigameIntroAnimationFinished]
	and a
	ret nz
	ld a, $0
	ld [wCurrentAnimatedObjectOAMBufferOffset], a
	call RunObjectAnimations
	call DelayFrame
	jr .loop

DrawSurfingPikachuMinigameIntroBackground:
	ld hl, wTileMap
	ld bc, SCREEN_AREA
	ld a, $ff
	call FillMemory
	ld hl, SurfingMinigame_BeachIntroTilemap
	decoord 0, 6
	ld bc, 12 * SCREEN_WIDTH
	call CopyData
	ld de, SurfingMinigame_TitleTilemap
	hlcoord 4, 0
	lb bc, 6, 12 ; title graphic dimensions: rows, columns
	call .CopyBox
	hlcoord 3, 7
	lb bc, 3, SCREEN_WIDTH - 5 ; clear the instruction text area
	call .FillBoxWithFF
	ld hl, SurfingMinigame_UseControlPadTilemap
	decoord 3, 7
	ld bc, SurfingMinigame_UseControlPadTilemapEnd - SurfingMinigame_UseControlPadTilemap
	call CopyData
	ld hl, SurfingMinigame_ToSurfRadTilemap
	decoord 4, 9
	ld bc, SurfingMinigame_ToSurfRadTilemapEnd - SurfingMinigame_ToSurfRadTilemap
	call CopyData
	ret

.CopyBox:
.copyRow
	push bc
	push hl
.copyColumn
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .copyColumn
	ld bc, SCREEN_WIDTH
	pop hl
	add hl, bc
	pop bc
	dec b
	jr nz, .copyRow
	ret

.FillBoxWithFF:
.fillRow
	push bc
	push hl
.fillColumn
	ld [hl], $ff
	inc hl
	dec c
	jr nz, .fillColumn
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .fillRow
	ret

SurfingMinigame_BeachIntroTilemap: INCBIN "gfx/surfing_pikachu/beach_intro.tilemap"
SurfingMinigame_BeachIntroTilemapEnd:
	ASSERT SurfingMinigame_BeachIntroTilemapEnd - SurfingMinigame_BeachIntroTilemap == 12 * SCREEN_WIDTH
SurfingMinigame_UseControlPadTilemap: INCBIN "gfx/surfing_pikachu/use_control_pad.tilemap"
SurfingMinigame_UseControlPadTilemapEnd:
SurfingMinigame_ToSurfRadTilemap: INCBIN "gfx/surfing_pikachu/to_surf_rad.tilemap"
SurfingMinigame_ToSurfRadTilemapEnd:
SurfingMinigame_TitleTilemap: INCBIN "gfx/surfing_pikachu/title.tilemap"
SurfingMinigame_TitleTilemapEnd:
	ASSERT SurfingMinigame_TitleTilemapEnd - SurfingMinigame_TitleTilemap == 6 * 12

SurfingMinigame_UpdateLYOverrides:
	ld hl, wLYOverrides + 2 * TILE_HEIGHT
	ld de, wLYOverrides + 2 * TILE_HEIGHT + 1
	ld c, SCREEN_HEIGHT_PX - 2 * TILE_HEIGHT
	ld a, [hl]
	push af
.loop
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .loop
	pop af
	ld [hl], a
	ret

SurfingMinigame_InitScanlineOverrides:
	ld hl, wLYOverrides
	ld bc, wLYOverridesEnd - wLYOverrides
	ld de, $0
.loop
	ld a, e
	and SurfingMinigame_LYOverridesInitialSineWaveEnd - SurfingMinigame_LYOverridesInitialSineWave - 1
	ld e, a
	push hl
	ld hl, SurfingMinigame_LYOverridesInitialSineWave
	add hl, de
	ld a, [hl]
	pop hl
	ld [hli], a
	inc e
	dec bc
	ld a, c
	or b
	jr nz, .loop
	ret

SurfingPikachu_GetJoypad_3FrameBuffer:
	call Joypad
	ldh a, [hFrameCounter]
	and a
	jr nz, .delayed
	ldh a, [hJoyHeld]
	ldh [hJoy5], a
	ld a, $2 ; sample held input once every three frames
	ldh [hFrameCounter], a
	ret

.delayed
	xor a
	ldh [hJoy5], a
	ret

SurfingPikachuMinigame_BlankPals:
	xor a
	ldh [rBGP], a
	ldh [rOBP0], a
	ldh [rOBP1], a
	call UpdateCGBPal_BGP
	call UpdateCGBPal_OBP0
	call UpdateCGBPal_OBP1
	ret

SurfingPikachuMinigame_NormalPals:
	ldpal a, SHADE_BLACK, SHADE_DARK, SHADE_LIGHT, SHADE_WHITE
	ldh [rBGP], a
	ldh [rOBP0], a
	ldpal a, SHADE_BLACK, SHADE_DARK, SHADE_WHITE, SHADE_WHITE
	ldh [rOBP1], a
	call UpdateCGBPal_BGP
	call UpdateCGBPal_OBP0
	call UpdateCGBPal_OBP1
	ret

SurfingPikachu_ClearTileMap:
	ld hl, wTileMap
	ld bc, SCREEN_AREA
	xor a
	call FillMemory
	ret

SurfingMinigame_ResetJumpArc:
	xor a
	ld [wSurfingMinigameJumpDescending], a
	ld [wSurfingMinigameJumpArcFraction], a
	ret

SurfingMinigame_UpdatePikachuHeight:
	ld a, [wSurfingMinigameJumpDescending]
	and a
	jr nz, .descending
	ld a, [wSurfingMinigameJumpArcMagnitude]
	ld d, a
	ld a, [wSurfingMinigameJumpArcFraction]
	or d
	jr z, .done
	ld a, [wSurfingMinigameJumpArcFraction]
	ld e, a
	ld hl, -0.5 ; decrease jump velocity
	add hl, de
	ld a, l
	ld [wSurfingMinigameJumpArcFraction], a
	ld a, h
	ld [wSurfingMinigameJumpArcMagnitude], a

	; -(4 * a ** 2)
	ld e, a
	ld d, $0
	call SurfingMinigame_NTimesDE
	ld e, l
	ld d, h
	ld a, $4
	call SurfingMinigame_NTimesDE
	ld a, l
	xor $ff
	inc a
	ld l, a
	ld a, h
	xor $ff
	ld h, a

	push hl
	ld hl, ANIM_OBJ_Y_COORD
	add hl, bc
	ld d, [hl]
	ld hl, ANIM_OBJ_FIELD_C
	add hl, bc
	ld e, [hl]
	pop hl

	add hl, de
	ld e, l
	ld d, h

	ld hl, ANIM_OBJ_Y_COORD
	add hl, bc
	ld [hl], d
	ld hl, ANIM_OBJ_FIELD_C
	add hl, bc
	ld [hl], e
	and a
	ret

.done
	ld a, $1
	ld [wSurfingMinigameJumpDescending], a
	and a
	ret

.descending
	ld a, [wSurfingMinigamePikachuObjectHeight]
	ld e, a
	ld hl, ANIM_OBJ_Y_COORD
	add hl, bc
	ld a, [hl]
	cp SCREEN_HEIGHT_PX
	jr nc, .okay
	cp e
	jr nc, .reset
.okay
	ld a, [wSurfingMinigameJumpArcMagnitude]
	ld d, a
	ld a, [wSurfingMinigameJumpArcFraction]
	ld e, a
	ld hl, 0.5 ; increase fall velocity
	add hl, de
	ld a, l
	ld [wSurfingMinigameJumpArcFraction], a
	ld a, h
	ld [wSurfingMinigameJumpArcMagnitude], a

	; 4 * a ** 2
	ld e, a
	ld d, $0
	call SurfingMinigame_NTimesDE
	ld e, l
	ld d, h
	ld a, $4
	call SurfingMinigame_NTimesDE

	push hl
	ld hl, ANIM_OBJ_Y_COORD
	add hl, bc
	ld d, [hl]
	ld hl, ANIM_OBJ_FIELD_C
	add hl, bc
	ld e, [hl]
	pop hl

	add hl, de
	ld e, l
	ld d, h

	ld hl, ANIM_OBJ_Y_COORD
	add hl, bc
	ld [hl], d
	ld hl, ANIM_OBJ_FIELD_C
	add hl, bc
	ld [hl], e
	and a
	ret

.reset
	ld hl, ANIM_OBJ_Y_COORD
	add hl, bc
	ld a, [wSurfingMinigamePikachuObjectHeight]
	ld [hl], a
	ld hl, ANIM_OBJ_FIELD_C
	add hl, bc
	ld [hl], $0
	scf
	ret

SurfingMinigame_NTimesDE:
	ld hl, $0
.loop
	srl a
	jr nc, .noAdd
	add hl, de
.noAdd
	sla e
	rl d
	and a
	jr nz, .loop
	ret

SurfingPikachu_PlaceBCDNumber:
	ld c, a
	swap a
	and $f
	add $d0
	ld [hli], a
	ld a, c
	and $f
	add $d0
	ld [hl], a
	dec de
	ret

SurfingPikachu_Cosine: ; cosine
	add $10
SurfingPikachu_Sine: ; sine
	and $3f ; wrap the 64-step full sine cycle
	cp $20 ; the second half-cycle is negative
	jr nc, .positive
	call .GetSine
	ld a, h
	ret

.positive
	and $1f ; index the 32-entry half-wave table
	call .GetSine
	ld a, h
	xor $ff
	inc a
	ret

.GetSine:
	ld e, a
	ld a, d
	ld d, $0
	ld hl, .SineWave
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, $0
.loop
	srl a
	jr nc, .noAdd
	add hl, de
.noAdd
	sla e
	rl d
	and a
	jr nz, .loop
	ret

.SineWave:
	sine_table 32

SurfingPikachuObjectSpawnData:
	; frameset, callback, tile offset
	db $00, $00, $00 ; 0: unused
	db $04, $01, $00 ; 1: surfing Pikachu
	db $11, $02, $00 ; 2: START
	db $12, $02, $00 ; 3: GOAL
	db $15, $00, $00 ; 4: +50
	db $16, $00, $00 ; 5: +150
	db $17, $00, $00 ; 6: +350
	db $18, $00, $00 ; 7: +750
	db $19, $00, $00 ; 8: +180
	db $1a, $00, $00 ; 9: +500
	db $14, $00, $00 ; a: water spray
	db $13, $03, $00 ; b: Oh no...
	db $1b, $04, $00 ; c: intro Pikachu

SurfingPikachuObjectCallbacks:
	dw SurfingMinigameAnimatedObjectFn_nop ; 0
	dw SurfingMinigameAnimatedObjectFn_Pikachu ; 1
	dw SurfingMinigame_MoveBannerToCenter ; 2
	dw SurfingMinigameAnimatedObjectFn_FlippingPika ; 3
	dw SurfingMinigameAnimatedObjectFn_IntroAnimationPikachu ; 4

SurfingMinigameAnimatedObjectFn_nop:
	ret

INCLUDE "data/sprite_anims/surfing_pikachu_frames.asm"
INCLUDE "data/sprite_anims/surfing_pikachu_oam.asm"

SurfingMinigame_LYOverridesInitialSineWave:
; a sine wave with amplitude 2
	db  0,  0,  0,  1,  1,  1,  1,  2
	db  2,  2,  1,  1,  1,  1,  0,  0
	db  0,  0,  0, -1, -1, -1, -1, -2
	db -2, -2, -1, -1, -1, -1,  0,  0
SurfingMinigame_LYOverridesInitialSineWaveEnd:

SurfingMinigame_BGMetatileTable: ; metatiles of 2x2 tiles
	db $00, $00, $00, $00 ; 00 ; sky block (blank)
	db $0b, $0b, $0b, $0b ; 01 ; water block
	db $0b, $02, $02, $06 ; 02
	db $03, $0b, $07, $03 ; 03
	db $06, $06, $06, $06 ; 04
	db $07, $07, $07, $07 ; 05
	db $06, $04, $04, $08 ; 06
	db $05, $07, $08, $05 ; 07
	db $0b, $0b, $11, $12 ; 08
	db $0b, $0b, $13, $03 ; 09
	db $14, $12, $04, $08 ; 0a
	db $13, $07, $08, $05 ; 0b
	db $06, $14, $06, $14 ; 0c ; unused, identical to 11
	db $13, $07, $13, $07 ; 0d
	db $08, $08, $08, $08 ; 0e ; solid blue
	db $14, $12, $14, $12 ; 0f
	db $0b, $11, $02, $14 ; 10
	db $06, $14, $06, $14 ; 11
	db $0c, $0c, $0d, $0d ; 12 ; beach top block
	db $0d, $0d, $0d, $0d ; 13 ; beach sand block
	db $0e, $0f, $10, $0b ; 14 ; beach shore block
	db $12, $13, $12, $13 ; 15

SurfingMinigameWavePattern00:
	db $00, $00, $00, $01, $01, $01, $01, $01
SurfingMinigameWavePattern01:
	db $00, $00, $00, $01, $01, $02, $04, $06
SurfingMinigameWavePattern02:
	db $00, $00, $00, $01, $02, $04, $06, $0e
SurfingMinigameWavePattern03:
	db $00, $00, $00, $10, $11, $06, $0e, $0e
SurfingMinigameWavePattern04:
	db $00, $00, $00, $15, $15, $0e, $0e, $0e
SurfingMinigameWavePattern05:
	db $00, $00, $00, $03, $05, $07, $0e, $0e
SurfingMinigameWavePattern06:
	db $00, $00, $00, $01, $03, $05, $07, $0e
SurfingMinigameWavePattern07:
	db $00, $00, $00, $01, $01, $03, $05, $07
SurfingMinigameWavePattern08:
	db $00, $00, $00, $01, $01, $02, $04, $06
SurfingMinigameWavePattern09:
	db $00, $00, $00, $01, $02, $04, $06, $0e
SurfingMinigameWavePattern0A:
	db $00, $00, $00, $08, $0f, $0a, $0e, $0e
SurfingMinigameWavePattern0B:
	db $00, $00, $00, $09, $0d, $0b, $0e, $0e
SurfingMinigameWavePattern0C:
	db $00, $00, $00, $01, $03, $05, $07, $0e
SurfingMinigameWavePattern0D:
	db $00, $00, $00, $01, $01, $03, $05, $07
SurfingMinigameWavePattern0E:
	db $00, $00, $00, $01, $01, $02, $04, $06
SurfingMinigameWavePattern0F:
	db $00, $00, $00, $01, $10, $11, $06, $0e
SurfingMinigameWavePattern10:
	db $00, $00, $00, $01, $15, $15, $0e, $0e
SurfingMinigameWavePattern11:
	db $00, $00, $00, $01, $03, $05, $07, $0e
SurfingMinigameWavePattern12:
	db $00, $00, $00, $01, $01, $03, $05, $07
SurfingMinigameWavePattern13:
	db $00, $00, $00, $01, $01, $02, $04, $06
SurfingMinigameWavePattern14:
	db $00, $00, $00, $01, $08, $0f, $0a, $0e
SurfingMinigameWavePattern15:
	db $00, $00, $00, $01, $09, $0d, $0b, $0e
SurfingMinigameWavePattern16:
	db $00, $00, $00, $01, $01, $03, $05, $07
SurfingMinigameWavePattern17:
	db $00, $00, $00, $01, $01, $10, $11, $06
SurfingMinigameWavePattern18:
	db $00, $00, $00, $01, $01, $15, $15, $0e
SurfingMinigameWavePattern19:
	db $00, $00, $00, $01, $01, $03, $05, $07
SurfingMinigameWavePattern1A:
	db $00, $00, $00, $01, $01, $08, $0f, $0a
SurfingMinigameWavePattern1B:
	db $00, $00, $00, $01, $01, $09, $0d, $0b
SurfingMinigameWavePattern1C:
	db $00, $00, $00, $14, $14, $14, $14, $14
SurfingMinigameBeachPattern:
	db $00, $00, $00, $12, $13, $13, $13, $13
