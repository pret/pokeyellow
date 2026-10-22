PlayIntroScene:
	ldh a, [rIE]
	push af
	xor a
	ldh [rIF], a
	ld a, $f
	ldh [rIE], a
	ld a, $8
	ldh [rSTAT], a
	call InitYellowIntroGFXAndMusic
	call DelayFrame
.loop
	ld a, [wYellowIntroCurrentScene]
	bit 7, a
	jr nz, .go_to_title_screen
	call JoypadLowSensitivity
	ldh a, [hJoyPressed]
	and PAD_A | PAD_B | PAD_START
	jr nz, .go_to_title_screen
	call DoIntroCutscene
	ld a, $0
	ld [wCurrentAnimatedObjectOAMBufferOffset], a
	call RunObjectAnimations
	ld a, [wYellowIntroCurrentScene]
	cp $7
	call z, AlternateSurfingPikachuSpritePalette
	cp $b
	call z, AlternateFlyingPikachuSpritePalette
	call DelayFrame
	jr .loop

.go_to_title_screen
	vc_hook Stop_Reducing_intro_scene_flashing
	call YellowIntro_BlankPalettes
	xor a
	ldh [hLCDCPointer], a
	call DelayFrame
	xor a
	ldh [rIF], a
	pop af
	ldh [rIE], a
	ld a, $90
	ldh [hWY], a
	call ClearObjectAnimationBuffers
	ld hl, wTileMap
	ld bc, SCREEN_AREA
	xor a
	call YellowIntro_FillMemory
	call YellowIntro_BlankOAMBuffer
	ld a, $1
	ldh [hAutoBGTransferEnabled], a
	call DelayFrame
	call DelayFrame
	call DelayFrame
	xor a
	ldh [hAutoBGTransferEnabled], a
	ret

AlternateSurfingPikachuSpritePalette:
	ld a, [wShadowOAMSprite08Attributes]
	or $1
	ld [wShadowOAMSprite08Attributes], a
	ld a, [wShadowOAMSprite14Attributes]
	or $1
	ld [wShadowOAMSprite14Attributes], a
	ld a, [wShadowOAMSprite16Attributes]
	or $1
	ld [wShadowOAMSprite16Attributes], a
	ld a, [wShadowOAMSprite18Attributes]
	or $1
	ld [wShadowOAMSprite18Attributes], a
	ld a, [wShadowOAMSprite19Attributes]
	or $1
	ld [wShadowOAMSprite19Attributes], a
	ret

AlternateFlyingPikachuSpritePalette:
	ld a, [wShadowOAMSprite18Attributes]
	or $1
	ld [wShadowOAMSprite18Attributes], a
	ld a, [wShadowOAMSprite19Attributes]
	or $1
	ld [wShadowOAMSprite19Attributes], a
	ld a, [wShadowOAMSprite20Attributes]
	or $1
	ld [wShadowOAMSprite20Attributes], a
	ld a, [wShadowOAMSprite25Attributes]
	or $1
	ld [wShadowOAMSprite25Attributes], a
	ld a, [wShadowOAMSprite26Attributes]
	or $1
	ld [wShadowOAMSprite26Attributes], a
	ld a, [wShadowOAMSprite28Attributes]
	or $1
	ld [wShadowOAMSprite28Attributes], a
	ret

DoIntroCutscene:
	ld a, [wYellowIntroCurrentScene]
	ld hl, IntroCutsceneJumptable
	call GetIntroCutsceneJumptableEntry
	jp hl

IntroCutsceneJumptable:
	dw YellowIntroScene0 ; running pika 1
	dw YellowIntroScene1 ; wait last
	dw YellowIntroScene2 ; pikachu kick
	dw YellowIntroScene3 ; wait last
	dw YellowIntroScene4 ; running pika 2
	dw YellowIntroScene5 ; wait last
	dw YellowIntroScene6 ; surfing pika
	dw YellowIntroScene7 ; wait last
	dw YellowIntroScene8 ; running pika 3
	dw YellowIntroScene9 ; wait last
	dw YellowIntroScene10 ; flying pika
	dw YellowIntroScene11 ; wait last
	dw YellowIntroScene12 ; pika close up
	dw YellowIntroScene13 ; wait last
	dw YellowIntroScene14 ; pika thunderbolt
	dw YellowIntroScene15 ; wait last
	dw YellowIntroScene16 ; fade to white
	dw YellowIntroScene17 ; wait and quit

YellowIntro_NextScene:
	ld hl, wYellowIntroCurrentScene
	inc [hl]
	vc_hook Reduce_intro_scene_flashing_0E
	ret

YellowIntroScene0:
	xor a
	ldh [hLCDCPointer], a
	lb de, $58, $58
	ld a, INTRO_FRAMESET_PIKACHU_FAR
	call YellowIntro_SpawnAnimatedObjectAndSavePointer
	xor a
	ldh [hSCX], a
	ldh [hSCY], a
	ld a, $90
	ldh [hWY], a
	ld a, $e4
	ldh [rBGP], a
	ldh [rOBP0], a
	ld a, $c4
	ldh [rOBP1], a
	call UpdateCGBPal_BGP
	call UpdateCGBPal_OBP0
	call UpdateCGBPal_OBP1
	ld a, 130
	ld [wYellowIntroSceneTimer], a
	call YellowIntro_NextScene
	ret

YellowIntroScene1:
	call YellowIntro_CheckFrameTimerDecrement
	ret nc
	call YellowIntro_MaskCurrentAnimatedObjectStruct
	call YellowIntro_NextScene
	ret

YellowIntroScene2:
	call YellowIntro_BlankPalsDelay2AndDisableLCD
	ld c, $8
	call UpdateMusicCTimes
	xor a
	ldh [hLCDCPointer], a
	hlbgcoord 0, 0
	ld bc, TILEMAP_AREA
	xor a
	call YellowIntro_FillMemory
	call YellowIntroScene2_PlaceGraphic
	lb de, $58, $b8 ; overloaded
	ld a, INTRO_FRAMESET_PIKACHU_UNUSED ; overloaded
	call LoadYellowIntroFlyingSpeedBars
	ld a, $1
	call YellowIntro_PrepareNextScenePalette
	call YellowIntro_SetTimerFor128Frames
	call YellowIntro_NextScene
	ret

YellowIntroScene2_PlaceGraphic:
	hlbgcoord 20, 6 ; top-left coordinate
	ld de, TILEMAP_WIDTH
	ld b, 6 ; graphic height
	ld a, $90 ; initial tile ID
.row
	ld c, 6 ; graphic width
	push af
	push hl
.col
	ld [hli], a
	inc a
	dec c
	jr nz, .col
	pop hl
	add hl, de
	pop af
	add $10 ; skip vtiles at the end of each row
	dec b
	jr nz, .row

	ldh a, [hOnCGB]
	and a
	jr z, .dmg_sgb

	; We can actually set palettes!
	hlbgcoord 20, 6
	ld de, TILEMAP_WIDTH
	ld b, 6 ; graphic height
	ld a, $1
	ldh [rVBK], a
.attr_row
	ld c, 6 ; graphic width
	push hl
.attr_col
	ld [hli], a
	dec c
	jr nz, .attr_col
	pop hl
	add hl, de
	dec b
	jr nz, .attr_row
	xor a
	ldh [rVBK], a

.dmg_sgb
	ret

LoadYellowIntroFlyingSpeedBars:
	ld hl, YellowIntroFlyingSpeedBarData
	ld a, $8
.loop
; Spawn speed bar object at indicated coordinates with indicated speeds
	push af
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld a, [hli]
	push hl
	push af
	ld a, INTRO_FRAMESET_SPEED_BAR
	call SpawnAnimatedObject
	pop af
	ld hl, $b
	add hl, bc
	ld [hl], a
	pop hl
	pop af
	dec a
	jr nz, .loop
	ret

YellowIntroFlyingSpeedBarData:
	; y, x, speed
	db $d0, $20, $02
	db $f0, $30, $04
	db $d0, $40, $06
	db $c0, $50, $08
	db $e0, $60, $08
	db $c0, $70, $06
	db $e0, $80, $04
	db $f0, $90, $02

YellowIntroScene3:
	call YellowIntro_CheckFrameTimerDecrement
	jr c, .expired
	ldh a, [hSCX]
	cp $68
	ret z
	add $4
	ldh [hSCX], a
	ret

.expired
	call MaskAllAnimatedObjectStructs
	call YellowIntro_NextScene
	ret

YellowIntroScene4:
	call YellowIntro_BlankPalsDelay2AndDisableLCD
	ld c, $5
	call UpdateMusicCTimes
	ldh a, [hOnCGB]
	and a
	jr z, .dmg_sgb

	; We can actually set palettes!
	hlbgcoord 20, 6
	ld de, TILEMAP_WIDTH
	ld b, 6 ; graphic height
	ld a, $1
	ldh [rVBK], a
	xor a
.attr_row
	ld c, 6 ; graphic width
	push hl
.attr_col
	ld [hli], a
	dec c
	jr nz, .attr_col
	pop hl
	add hl, de
	dec b
	jr nz, .attr_row
	xor a
	ldh [rVBK], a

.dmg_sgb
	xor a
	ldh [hLCDCPointer], a
	call YellowIntro_LetterboxRunningPikachu
	lb de, $58, $58
	ld a, INTRO_FRAMESET_PIKACHU_MID
	call YellowIntro_SpawnAnimatedObjectAndSavePointer
	xor a
	call YellowIntro_PrepareNextScenePalette
	call YellowIntro_SetTimerFor128Frames
	call YellowIntro_NextScene
	ret

YellowIntroScene5:
	call YellowIntro_CheckFrameTimerDecrement
	ret nc
	call YellowIntro_MaskCurrentAnimatedObjectStruct
	call YellowIntro_NextScene
	ret

YellowIntroScene6:
	call YellowIntro_BlankPalsDelay2AndDisableLCD
	ld c, $5
	call UpdateMusicCTimes
	ld a, LOW(rSCY)
	ldh [hLCDCPointer], a
	call YellowIntro_Copy8BitSineWave
	hlbgcoord 0, 0
	ld bc, TILEMAP_WIDTH * 3
	xor a
	call YellowIntro_FillMemory
	hlbgcoord 0, 3
	ld c, TILEMAP_WIDTH / 2
	ld a, $20
.loop
	ld [hli], a
	inc a
	ld [hli], a
	dec a
	dec c
	jr nz, .loop
	hlbgcoord 0, 4
	ld bc, TILEMAP_WIDTH * 24
	ld a, $10
	call YellowIntro_FillMemory
	lb de, $40, $f8
	ld a, INTRO_FRAMESET_PIKACHU_SURFING
	call YellowIntro_SpawnAnimatedObjectAndSavePointer
	ld a, $1
	call YellowIntro_PrepareNextScenePalette
	call YellowIntro_SetTimerFor88Frames
	call YellowIntro_NextScene
	ret

YellowIntroScene7:
	call YellowIntro_CheckFrameTimerDecrement
	jr c, .expired
	ld hl, hSCX
	inc [hl]
	inc [hl]
	ld hl, wLYOverridesBuffer
	ld de, wLYOverridesBuffer + 1
	ld a, [hl]
	push af
	ld c, $ff
.shift_loop
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .shift_loop
	pop af
	ld [hl], a
	call Request7TileTransferFromC810ToC710
	ret

.expired
	call YellowIntro_MaskCurrentAnimatedObjectStruct
	call YellowIntro_NextScene
	ret

YellowIntroScene8:
	call YellowIntro_BlankPalsDelay2AndDisableLCD
	ld c, $5
	call UpdateMusicCTimes
	xor a
	ldh [hLCDCPointer], a
	call YellowIntro_LetterboxRunningPikachu
	lb de, $58, $58
	ld a, INTRO_FRAMESET_PIKACHU_NEAR
	call YellowIntro_SpawnAnimatedObjectAndSavePointer
	xor a
	call YellowIntro_PrepareNextScenePalette
	call YellowIntro_SetTimerFor128Frames
	call YellowIntro_NextScene
	ret

YellowIntroScene9:
	call YellowIntro_CheckFrameTimerDecrement
	ret nc
	call YellowIntro_MaskCurrentAnimatedObjectStruct
	call YellowIntro_NextScene
	ret

YellowIntroScene10:
	call YellowIntro_BlankPalsDelay2AndDisableLCD
	ld c, $5
	call UpdateMusicCTimes
	xor a
	ldh [hLCDCPointer], a
	hlbgcoord 0, 0
	ld bc, TILEMAP_AREA
	xor a
	call YellowIntro_FillMemory
	hlbgcoord 0, 0
	ld bc, TILEMAP_WIDTH * 8
	ld a, $2
	call YellowIntro_FillMemory
	hlbgcoord 0, 8
	ld de, YellowIntroCloudsTilemap
	lb bc, 6, 20
	call .FillBGMapBox
	hlbgcoord 12, 4
	ld de, YellowIntroCloudPairTilemap
	lb bc, 3, 4
	call .FillBGMapBox
	hlbgcoord 3, 7
	ld de, YellowIntroSmallCloudTilemap
	lb bc, 2, 2
	call .FillBGMapBox
	lb de, $98, $58
	ld a, INTRO_FRAMESET_PIKACHU_FLYING
	call YellowIntro_SpawnAnimatedObjectAndSavePointer
	ld a, $1
	call YellowIntro_PrepareNextScenePalette
	call YellowIntro_SetTimerFor128Frames
	call YellowIntro_NextScene
	ret

.FillBGMapBox:
.fill_row
	push bc
	push hl
.fill_col
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .fill_col
	pop hl
	ld bc, $20
	add hl, bc
	pop bc
	dec b
	jr nz, .fill_row
	ret

YellowIntroCloudsTilemap:     INCBIN "gfx/intro/clouds.tilemap"
YellowIntroCloudPairTilemap:  INCBIN "gfx/intro/cloud_pair.tilemap"
YellowIntroSmallCloudTilemap: INCBIN "gfx/intro/small_cloud.tilemap"

YellowIntroScene11:
	call YellowIntro_CheckFrameTimerDecrement
	jr c, .expired
	ld a, [wYellowIntroSceneTimer]
	and $7
	ret nz
	ld a, [wYellowIntroSceneTimer]
	and $8
	sla a
	sla a
	sla a
	ld e, a
	ld d, $0
	ld hl, YellowIntroCloudGFX
	add hl, de
	ld a, l
	ldh [hVBlankCopySource], a
	ld a, h
	ldh [hVBlankCopySource + 1], a
	xor a
	ldh [hVBlankCopyDest], a
	ld a, $96
	ldh [hVBlankCopyDest + 1], a
	ld a, $4
	ldh [hVBlankCopySize], a
	ret

.expired
	call YellowIntro_MaskCurrentAnimatedObjectStruct
	call YellowIntro_NextScene
	ret

YellowIntroCloudGFX: INCBIN "gfx/intro/clouds.2bpp"

YellowIntroScene12:
	call YellowIntro_BlankPalsDelay2AndDisableLCD
	ld c, $5
	call UpdateMusicCTimes
	xor a
	ldh [hLCDCPointer], a
	hlbgcoord 0, 0
	ld bc, TILEMAP_WIDTH * 4
	ld a, $1
	call YellowIntro_FillMemory
	hlbgcoord 0, 4
	ld bc, TILEMAP_WIDTH * 10
	xor a
	call YellowIntro_FillMemory
	hlbgcoord 0, 14
	ld bc, TILEMAP_WIDTH * 4
	ld a, $1
	call YellowIntro_FillMemory

	hlbgcoord 5, 6 ; top-left coordinate
	ld de, TILEMAP_WIDTH
	ld a, $4 ; initial tile ID
	ld b, 8 ; graphic height
.row
	ld c, 12 ; graphic width
	push hl
.col
	ld [hli], a
	inc a
	dec c
	jr nz, .col
	pop hl
	add hl, de
	add $4 ; skip vtiles at the end of each row
	dec b
	jr nz, .row

	hlbgcoord 4, 6
	ld [hl], $3
	hlbgcoord 4, 7
	ld [hl], $74
	hlbgcoord 5, 13
	ld [hl], $0
	lb de, $60, $58
	ld a, INTRO_FRAMESET_PIKACHU_EYES
	call YellowIntro_SpawnAnimatedObjectAndSavePointer
	xor a
	call YellowIntro_PrepareNextScenePalette
	call YellowIntro_SetTimerFor128Frames
	call YellowIntro_NextScene
	ret

YellowIntroScene13:
	call YellowIntro_CheckFrameTimerDecrement
	ret nc
	lb de, $68, $58
	ld a, INTRO_FRAMESET_CHEEK_SPARKS
	call SpawnAnimatedObject
	call YellowIntro_NextScene
	ret

YellowIntroScene14:
	ld de, YellowIntroThunderboltPalSequence
	call YellowIntro_LoadDMGPalAndIncrementCounter
	jr c, .expired
	ldh [rBGP], a
	ldh [rOBP0], a
	and $f0
	ldh [rOBP1], a
	call UpdateCGBPal_BGP
	call UpdateCGBPal_OBP0
	call UpdateCGBPal_OBP1
	ret

.expired
	call MaskAllAnimatedObjectStructs
	call YellowIntro_BlankOAMBuffer
	ld hl, wTileMap
	ld bc, SCREEN_WIDTH * 4
	ld a, $1
	call YellowIntro_FillMemory
	hlcoord 0, 4
	ld bc, SCREEN_WIDTH * 10
	xor a
	call YellowIntro_FillMemory
	hlcoord 0, 14
	ld bc, SCREEN_WIDTH * 4
	ld a, $1
	call YellowIntro_FillMemory
	ld a, $1
	ldh [hAutoBGTransferEnabled], a
	call DelayFrame
	call DelayFrame
	call DelayFrame
	xor a
	ldh [hAutoBGTransferEnabled], a
	ld a, $e4
	ldh [rOBP0], a
	ldh [rBGP], a
	call UpdateCGBPal_BGP
	call UpdateCGBPal_OBP0
	lb de, $58, $58
	ld a, INTRO_FRAMESET_PIKACHU_THUNDER
	call YellowIntro_SpawnAnimatedObjectAndSavePointer
	call YellowIntro_NextScene
	ld a, $28
	vc_hook Reduce_intro_scene_flashing_0F
	ld [wYellowIntroSceneTimer], a
	ret

YellowIntroScene15:
	call YellowIntro_CheckFrameTimerDecrement
	jr c, .expired
	ld a, [wYellowIntroSceneTimer]
	and $3
	ret nz
	ldh a, [rOBP0]
	xor $ff
	ldh [rOBP0], a
	ldh a, [rBGP]
	xor $3
	ldh [rBGP], a
	call UpdateCGBPal_BGP
	call UpdateCGBPal_OBP0
	ret

.expired
	xor a
	ldh [hLCDCPointer], a
	ld a, $e4
	ldh [rBGP], a
	ldh [rOBP0], a
	call UpdateCGBPal_BGP
	call UpdateCGBPal_OBP0
	call YellowIntro_NextScene
YellowIntroScene16:
	ld de, YellowIntroFadeToWhitePalSequence
	call YellowIntro_LoadDMGPalAndIncrementCounter
	jr c, .expired
	ldh [rOBP0], a
	ldh [rBGP], a
	call UpdateCGBPal_BGP
	call UpdateCGBPal_OBP0
	ret

.expired
	call YellowIntro_NextScene
	ret

YellowIntroThunderboltPalSequence:
	db $e4, $c0, $c0, $e4
	db $e4, $c0, $c0, $e4
	db $e4, $c0, $c0, $e4
	db $e4, $c0, $c0, $e4
	db $e4, $c0, $c0, $e4
	db $e4, $c0, $c0, $e4
	db $e4, $c0, $c0, $e4
	db $e4, $c0, $c0, $e4
	db $e4, $c0, $c0, $e4
	db $e4, $c0, $c0, $e4
	db $e4, $c0, $c0, $e4
	db $e4, $c0, $c0, $e4
	db $e4, $c0, $c0, $ff

YellowIntroFadeToWhitePalSequence:
	db $e4, $90, $90, $40
	db $40, $00, $00, $ff

YellowIntroScene17:
	ld c, 64
	call DelayFrames
	ld hl, wYellowIntroCurrentScene
	set 7, [hl]
	ret

YellowIntro_SpawnAnimatedObjectAndSavePointer:
	call SpawnAnimatedObject
	ld a, c
	ld [wYellowIntroAnimatedObjectStructPointer], a
	ld a, b
	ld [wYellowIntroAnimatedObjectStructPointer + 1], a
	ret

YellowIntro_MaskCurrentAnimatedObjectStruct:
	ld a, [wYellowIntroAnimatedObjectStructPointer]
	ld c, a
	ld a, [wYellowIntroAnimatedObjectStructPointer + 1]
	ld b, a
	call MaskCurrentAnimatedObjectStruct
	ret

YellowIntro_SetTimerFor128Frames:
	ld a, 128
	ld [wYellowIntroSceneTimer], a
	ret

YellowIntro_SetTimerFor88Frames:
	ld a, 88
	ld [wYellowIntroSceneTimer], a
	ret

YellowIntro_CheckFrameTimerDecrement:
	ld hl, wYellowIntroSceneTimer
	ld a, [hl]
	and a
	jr z, .expired
	dec [hl]
	and a
	ret

.expired
	vc_hook Stop_reducing_intro_scene_flashing_0F
	scf
	ret

YellowIntro_LoadDMGPalAndIncrementCounter:
	ld hl, wYellowIntroSceneTimer
	ld a, [hl]
	vc_hook Stop_reducing_intro_scene_flashing_0E
	inc [hl]
	ld l, a
	ld h, $0
	add hl, de
	ld a, [hl]
	cp $ff
	jr z, .expired
	and a
	ret

.expired
	scf
	ret

YellowIntro_LetterboxRunningPikachu:
	hlbgcoord 0, 0
	ld bc, TILEMAP_WIDTH * 4
	ld a, $1
	call YellowIntro_FillMemory
	hlbgcoord 0, 4
	ld bc, TILEMAP_WIDTH * 10
	xor a
	call YellowIntro_FillMemory
	hlbgcoord 0, 14
	ld bc, TILEMAP_WIDTH * 4
	ld a, $1
	call YellowIntro_FillMemory
	ret

YellowIntro_BlankPalsDelay2AndDisableLCD:
	xor a
	ldh [rBGP], a
	ldh [rOBP0], a
	ldh [rOBP1], a
	call UpdateCGBPal_BGP
	call UpdateCGBPal_OBP0
	call UpdateCGBPal_OBP1
	call DelayFrame
	call DelayFrame
	call DisableLCD
	ret

YellowIntro_PrepareNextScenePalette:
	ld e, a
	callfar YellowIntroPaletteAction
	xor a
	ldh [hSCX], a
	ldh [hSCY], a
	ld a, $90
	ldh [hWY], a
	ld a, $e3
	ldh [rLCDC], a
	ld a, $e4
	ldh [rBGP], a
	ldh [rOBP0], a
	ld a, $e0
	ldh [rOBP1], a
	call UpdateCGBPal_BGP
	call UpdateCGBPal_OBP0
	call UpdateCGBPal_OBP1
	ret

YellowIntro_Copy8BitSineWave:
	; Copy this sine wave into wLYOverridesBuffer 8 times (end just before wc900)
	ld de, wLYOverridesBuffer
	ld a, $8
.loop
	push af
	ld hl, .SineWave
	ld bc, .SineWaveEnd - .SineWave
	call YellowIntro_CopyData
	pop af
	dec a
	jr nz, .loop
	ret

.SineWave:
; a sine wave with amplitude 4
	db  0,  0,  1,  2,  2,  3,  3,  3
	db  4,  3,  3,  3,  2,  2,  1,  0
	db  0,  0, -1, -2, -2, -3, -3, -3
	db -4, -3, -3, -3, -2, -2, -1,  0
.SineWaveEnd:

Request7TileTransferFromC810ToC710:
	ld a, $10
	ldh [hVBlankCopySource], a
	ld a, HIGH(wLYOverridesBuffer)
	ldh [hVBlankCopySource + 1], a
	ld a, $10
	ldh [hVBlankCopyDest], a
	ld a, HIGH(wLYOverrides)
	ldh [hVBlankCopyDest + 1], a
	ld a, $7
	ldh [hVBlankCopySize], a
	ret

InitYellowIntroGFXAndMusic:
	xor a
	ldh [hAutoBGTransferEnabled], a
	ldh [hSCX], a
	ldh [hSCY], a
	ldh [hAutoBGTransferDest], a
	ld a, $98
	ldh [hAutoBGTransferDest + 1], a
	call YellowIntro_BlankTileMap
	ld hl, wTileMap
	ld bc, SCREEN_AREA
	ld a, $1
	call YellowIntro_FillMemory
	hlcoord 0, 4
	ld bc, SCREEN_WIDTH * 10
	xor a
	call YellowIntro_FillMemory
	ld a, $1
	ldh [hAutoBGTransferEnabled], a
	call DelayFrame
	call DelayFrame
	call DelayFrame
	xor a
	ldh [hAutoBGTransferEnabled], a
	ld de, YellowIntroGraphics2
	ld hl, vChars0
	lb bc, BANK(YellowIntroGraphics2), (YellowIntroGraphics2End - YellowIntroGraphics2 - $10) / $10
	call CopyVideoData
	ld de, YellowIntroGraphics1
	ld hl, vChars2
	lb bc, BANK(YellowIntroGraphics1), (YellowIntroGraphics1End - YellowIntroGraphics1) / $10
	call CopyVideoData
	call ClearObjectAnimationBuffers
	call LoadYellowIntroObjectAnimationDataPointers
	ld b, SET_PAL_GENERIC
	call RunPaletteCommand
	xor a
	ld hl, wYellowIntroCurrentScene
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, MUSIC_YELLOW_INTRO
	ld c, BANK(Music_YellowIntro)
	call PlayMusic
	ret

LoadYellowIntroObjectAnimationDataPointers:
	ld a, LOW(YellowIntro_AnimatedObjectSpawnStateData)
	ld [wAnimatedObjectSpawnStateDataPointer], a
	ld a, HIGH(YellowIntro_AnimatedObjectSpawnStateData)
	ld [wAnimatedObjectSpawnStateDataPointer + 1], a
	ld a, LOW(YellowIntro_AnimatedObjectJumptable)
	ld [wAnimatedObjectJumptablePointer], a
	ld a, HIGH(YellowIntro_AnimatedObjectJumptable)
	ld [wAnimatedObjectJumptablePointer + 1], a
	ld a, LOW(YellowIntro_AnimatedObjectOAMData)
	ld [wAnimatedObjectOAMDataPointer], a
	ld a, HIGH(YellowIntro_AnimatedObjectOAMData)
	ld [wAnimatedObjectOAMDataPointer + 1], a
	ld a, LOW(YellowIntro_AnimatedObjectFramesData)
	ld [wAnimatedObjectFramesDataPointer], a
	ld a, HIGH(YellowIntro_AnimatedObjectFramesData)
	ld [wAnimatedObjectFramesDataPointer + 1], a
	ret

YellowIntro_BlankTileMap:
	ld hl, wTileMap
	ld bc, SCREEN_AREA
	ld a, ' '
	call YellowIntro_FillMemory
	ret

YellowIntro_CopyData:
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, c
	or b
	jr nz, .loop
	ret

YellowIntro_FillMemory:
	push de
	ld e, a
.loop
	ld a, e
	ld [hli], a
	dec bc
	ld a, c
	or b
	jr nz, .loop
	pop de
	ret

YellowIntro_BlankOAMBuffer:
	ld hl, wShadowOAM
	ld bc, wShadowOAMEnd - wShadowOAM
	xor a
	call YellowIntro_FillMemory
	ret

YellowIntro_BlankPalettes:
	xor a
	ldh [rBGP], a
	ldh [rOBP0], a
	ldh [rOBP1], a
	call UpdateCGBPal_BGP
	call UpdateCGBPal_OBP0
	call UpdateCGBPal_OBP1
	ret

YellowIntro_AnimatedObjectSpawnStateData:
	db $00, $00, $00
	db $01, $01, $00
	db $02, $01, $00
	db $03, $01, $00
	db $04, $02, $00
	db $05, $03, $00
	db $06, $04, $00
	db $07, $01, $00
	db $08, $05, $00
	db $09, $01, $00
	db $0a, $01, $00

YellowIntro_AnimatedObjectJumptable:
	dw YellowIntroAnimatedObjectFn_DoNothing
	dw YellowIntroAnimatedObjectFn_DoNothing
	dw YellowIntroAnimatedObjectFn_MoveLeft
	dw YellowIntroAnimatedObjectFn_MoveRightAndDown
	dw YellowIntroAnimatedObjectFn_MoveUpThenBob
	dw YellowIntroAnimatedObjectFn_ChangeXCoord

YellowIntroAnimatedObjectFn_DoNothing:
	ret

YellowIntroAnimatedObjectFn_MoveLeft:
	ld hl, ANIM_OBJ_X_COORD
	add hl, bc
	ld a, [hl]
	cp $58
	ret z
	sub $4
	ld [hl], a
	ret

YellowIntroAnimatedObjectFn_MoveRightAndDown:
	ld hl, ANIM_OBJ_X_COORD
	add hl, bc
	ld a, [hl]
	cp $58
	jr z, .moved_right
	add $4
	ld [hl], a
.moved_right
	ld hl, ANIM_OBJ_Y_COORD
	add hl, bc
	cp $58
	ret z
	add $1
	ld [hl], a
	ret

YellowIntroAnimatedObjectFn_MoveUpThenBob:
	ld hl, ANIM_OBJ_FIELD_B
	add hl, bc
	ld e, [hl]
	ld d, $0
	ld hl, .Jumptable
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

.Jumptable:
	dw .MoveUpBeforeBob
	dw .BobUpAndDown

.MoveUpBeforeBob:
	ld hl, ANIM_OBJ_Y_COORD
	add hl, bc
	ld a, [hl]
	cp $58
	jr z, .moved_up
	sub $2
	ld [hl], a
	ret

.moved_up
	ld hl, ANIM_OBJ_FIELD_B
	add hl, bc
	inc [hl]
.BobUpAndDown:
	ld hl, ANIM_OBJ_FIELD_C
	add hl, bc
	ld a, [hl]
	inc [hl]
	ld d, $8
	call Intro_Sine
	ld hl, $7
	add hl, bc
	ld [hl], a
	ret

YellowIntroAnimatedObjectFn_ChangeXCoord: ; unused?
	ld hl, ANIM_OBJ_FIELD_B
	add hl, bc
	ld a, [hl]
	ld hl, ANIM_OBJ_X_COORD
	add hl, bc
	add [hl]
	ld [hl], a
	ret

GetIntroCutsceneJumptableEntry:
	ld e, a
	ld d, $0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

Intro_Cosine:
	add $10
Intro_Sine:
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

INCLUDE "data/sprite_anims/intro_frames.asm"
INCLUDE "data/sprite_anims/intro_oam.asm"

INCLUDE "gfx/yellow_intro.asm"
