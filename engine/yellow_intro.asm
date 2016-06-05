PlayIntroScene:
	ld a, [rIE]
	push af
	xor a
	ld [rIF], a
	ld a, $f
	ld [rIE], a
	ld a, $8
	ld [rSTAT], a
	call InitYellowIntroGFXAndMusic
	call DelayFrame
.loop
	ld a, [wc634]
	bit 7, a
	jr nz, .go_to_title_screen
	call JoypadLowSensitivity
	ld a, [hJoyPressed]
	and A_BUTTON | B_BUTTON | START
	jr nz, .go_to_title_screen
	call Func_f98fc
	ld a, $0
	ld [wCurrentAnimatedObjectOAMBufferOffset], a
	call RunObjectAnimations
	ld a, [wc634]
	cp $7
	call z, Func_f98a2
	cp $b
	call z, Func_f98cb
	call DelayFrame
	jr .loop

.go_to_title_screen
	call YellowIntro_BlankPalettes
	xor a
	ld [hLCDCPointer], a
	call DelayFrame
	xor a
	ld [rIF], a
	pop af
	ld [rIE], a
	ld a, $90
	ld [hWY], a
	call ClearObjectAnimationBuffers
	ld hl, wTileMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	xor a
	call Bank3E_FillMemory
	call YellowIntro_BlankOAMBuffer
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	call DelayFrame
	call DelayFrame
	call DelayFrame
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	ret

Func_f98a2:
	ld a, [wOAMBuffer + 8 * 4 + 3]
	or $1
	ld [wOAMBuffer + 8 * 4 + 3], a
	ld a, [wOAMBuffer + 14 * 4 + 3]
	or $1
	ld [wOAMBuffer + 14 * 4 + 3], a
	ld a, [wOAMBuffer + 16 * 4 + 3]
	or $1
	ld [wOAMBuffer + 16 * 4 + 3], a
Func_f98b8:
	ld a, [wOAMBuffer + 18 * 4 + 3]
	or $1
	ld [wOAMBuffer + 18 * 4 + 3], a
	ld a, [wOAMBuffer + 19 * 4 + 3]
	or $1
	ld [wOAMBuffer + 19 * 4 + 3], a
	ret

Func_f98cb:
	ld a, [wOAMBuffer + 18 * 4 + 3]
	or $1
	ld [wOAMBuffer + 18 * 4 + 3], a
	ld a, [wOAMBuffer + 19 * 4 + 3]
	or $1
	ld [wOAMBuffer + 19 * 4 + 3], a
	ld a, [wOAMBuffer + 20 * 4 + 3]
	or $1
	ld [wOAMBuffer + 20 * 4 + 3], a
	ld a, [wOAMBuffer + 25 * 4 + 3]
	or $1
	ld [wOAMBuffer + 25 * 4 + 3], a
	ld a, [wOAMBuffer + 26 * 4 + 3]
	or $1
	ld [wOAMBuffer + 26 * 4 + 3], a
	ld a, [wOAMBuffer + 28 * 4 + 3]
	or $1
	ld [wOAMBuffer + 28 * 4 + 3], a
	ret

Func_f98fc:
	ld a, [wc634]
	ld hl, Jumptable_f9906
	call Func_fa06e
	jp [hl]

Jumptable_f9906:
	dw Func_f992f
	dw Func_f995f
	dw Func_f996a
	dw Func_f9a08
	dw Func_f9a1e
	dw Func_f9a60
	dw Func_f9a6b
	dw Func_f9ab1
	dw Func_f9ad8
	dw Func_f9af9
	dw Func_f9b04
	dw Func_f9bf6
	dw Func_f9cac
	dw Func_f9d12
	dw Func_f9d22
	dw Func_f9d8f
	dw Func_f9dbf
	dw Func_f9e12

Func_f992a:
	ld hl, wc634
	inc [hl]
	ret

Func_f992f:
	xor a
	ld [hLCDCPointer], a
	lb de, $58, $58
	ld a, $1
	call YellowIntro_SpawnAnimatedObjectAndSavePointer
	xor a
	ld [hSCX], a
	ld [hSCY], a
	ld a, $90
	ld [hWY], a
	ld a, $e4
	ld [rBGP], a
	ld [rOBP0], a
	ld a, $c4
	ld [rOBP1], a
	call UpdateGBCPal_BGP
	call UpdateGBCPal_OBP0
	call UpdateGBCPal_OBP1
	ld a, $82
	ld [wc635], a
	call Func_f992a
	ret

Func_f995f:
	call Func_f9e41
	ret nc
	call YellowIntro_MaskCurrentAnimatedObjectStruct
	call Func_f992a
	ret

Func_f996a:
	call Func_f9e80
	ld c, $8
	call UpdateMusicCTimes
	xor a
	ld [hLCDCPointer], a
	ld hl, vBGMap0
	ld bc, $400
	xor a
	call Bank3E_FillMemory
	call Func_f9996
	lb de, $58, $b8 ; overloaded
	ld a, $4 ; overloaded
	call Func_f99d2
	ld a, $1
	call Func_f9e9a
	call Func_f9e35
	call Func_f992a
	ret

Func_f9996:
	ld hl, $98d4
	ld de, $20
	ld b, $6
	ld a, $90
.asm_f99a0
	ld c, $6
	push af
	push hl
.asm_f99a4
	ld [hli], a
	inc a
	dec c
	jr nz, .asm_f99a4
	pop hl
	add hl, de
	pop af
	add $10
	dec b
	jr nz, .asm_f99a0
	ld a, [hGBC]
	and a
	jr z, .asm_f99d1
	ld hl, $98d4
	ld de, $20
	ld b, $6
	ld a, $1
	ld [rVBK], a
.asm_f99c2
	ld c, $6
	push hl
.asm_f99c5
	ld [hli], a
	dec c
	jr nz, .asm_f99c5
	pop hl
	add hl, de
	dec b
	jr nz, .asm_f99c2
	xor a
	ld [rVBK], a
.asm_f99d1
	ret

Func_f99d2:
	ld hl, Unkn_f99f0
	ld a, $8
.asm_f99d7
	push af
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld a, [hli]
	push hl
	push af
	ld a, $8
	call SpawnAnimatedObject
	pop af
	ld hl, $b
	add hl, bc
	ld [hl], a
	pop hl
	pop af
	dec a
	jr nz, .asm_f99d7
	ret

Unkn_f99f0:
	db $d0, $20, $02
	db $f0, $30, $04
	db $d0, $40, $06
	db $c0, $50, $08
	db $e0, $60, $08
	db $c0, $70, $06
	db $e0, $80, $04
	db $f0, $90, $02

Func_f9a08:
	call Func_f9e41
	jr c, .asm_f9a17
	ld a, [hSCX]
	cp $68
	ret z
	add $4
	ld [hSCX], a
	ret

.asm_f9a17
	call MaskAllAnimatedObjectStructs
	call Func_f992a
	ret

Func_f9a1e:
	call Func_f9e80
	ld c, $5
	call UpdateMusicCTimes
	ld a, [hGBC]
	and a
	jr z, .asm_f9a47
	ld hl, $98d4
	ld de, $20
	ld b, $6
	ld a, $1
	ld [rVBK], a
	xor a
.asm_f9a38
	ld c, $6
	push hl
.asm_f9a3b
	ld [hli], a
	dec c
	jr nz, .asm_f9a3b
	pop hl
	add hl, de
	dec b
	jr nz, .asm_f9a38
	xor a
	ld [rVBK], a
.asm_f9a47
	xor a
	ld [hLCDCPointer], a
	call Func_f9e5f
	lb de, $58, $58
	ld a, $2
	call YellowIntro_SpawnAnimatedObjectAndSavePointer
	xor a
	call Func_f9e9a
	call Func_f9e35
	call Func_f992a
	ret

Func_f9a60:
	call Func_f9e41
	ret nc
	call YellowIntro_MaskCurrentAnimatedObjectStruct
	call Func_f992a
	ret

Func_f9a6b:
	call Func_f9e80
	ld c, $5
	call UpdateMusicCTimes
	ld a, $42
	ld [hLCDCPointer], a
	call Func_f9ec4
	ld hl, vBGMap0
	ld bc, $60
	xor a
	call Bank3E_FillMemory
	ld hl, $9860
	ld c, $10
	ld a, $20
.asm_f9a8b
	ld [hli], a
	inc a
	ld [hli], a
	dec a
	dec c
	jr nz, .asm_f9a8b
	ld hl, $9880
	ld bc, $300
	ld a, $10
	call Bank3E_FillMemory
	lb de, $40, $f8
	ld a, $5
	call YellowIntro_SpawnAnimatedObjectAndSavePointer
	ld a, $1
	call Func_f9e9a
	call Func_f9e3b
	call Func_f992a
	ret

Func_f9ab1:
	call Func_f9e41
	jr c, .asm_f9ad1
	ld hl, hSCX
	inc [hl]
	inc [hl]
	ld hl, wc800
	ld de, wc800 + 1
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
	call Prep7TileTransferFromC810ToC710
	ret

.asm_f9ad1
	call YellowIntro_MaskCurrentAnimatedObjectStruct
	call Func_f992a
	ret

Func_f9ad8:
	call Func_f9e80
	ld c, $5
	call UpdateMusicCTimes
	xor a
	ld [hLCDCPointer], a
	call Func_f9e5f
	lb de, $58, $58
	ld a, $3
	call YellowIntro_SpawnAnimatedObjectAndSavePointer
	xor a
	call Func_f9e9a
	call Func_f9e35
	call Func_f992a
	ret

Func_f9af9:
	call Func_f9e41
	ret nc
	call YellowIntro_MaskCurrentAnimatedObjectStruct
	call Func_f992a
	ret

Func_f9b04:
	call Func_f9e80
	ld c, $5
	call UpdateMusicCTimes
	xor a
	ld [hLCDCPointer], a
	ld hl, vBGMap0
	ld bc, $400
	xor a
	call Bank3E_FillMemory
	ld hl, vBGMap0
	ld bc, $100
	ld a, $2
	call Bank3E_FillMemory
	ld hl, $9900
	ld de, Unkn_f9b6e
	lb bc, 6, 20
	call .FillBGMapBox
	ld hl, $988c
	ld de, Unkn_f9be6
	lb bc, 3, 4
	call .FillBGMapBox
	ld hl, $98e3
	ld de, Unkn_f9bf2
	lb bc, 2, 2
	call .FillBGMapBox
	lb de, $98, $58
	ld a, $6
	call YellowIntro_SpawnAnimatedObjectAndSavePointer
	ld a, $1
	call Func_f9e9a
	call Func_f9e35
	call Func_f992a
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

Unkn_f9b6e: INCBIN "gfx/unknown_f9b6e.map"
Unkn_f9be6: INCBIN "gfx/unknown_f9be6.map"
Unkn_f9bf2: INCBIN "gfx/unknown_f9bf2.map"

Func_f9bf6:
	call Func_f9e41
	jr c, .asm_f9c25
	ld a, [wc635]
	and $7
	ret nz
	ld a, [wc635]
	and $8
	sla a
	sla a
	sla a
	ld e, a
	ld d, $0
	ld hl, GFX_f9c2c
	add hl, de
	ld a, l
	ld [H_VBCOPYSRC], a
	ld a, h
	ld [H_VBCOPYSRC + 1], a
	xor a
	ld [H_VBCOPYDEST], a
	ld a, $96
	ld [H_VBCOPYDEST + 1], a
	ld a, $4
	ld [H_VBCOPYSIZE], a
	ret

.asm_f9c25
	call YellowIntro_MaskCurrentAnimatedObjectStruct
	call Func_f992a
	ret

GFX_f9c2c: INCBIN "gfx/unknown_f9c2c.2bpp"
GFX_f9c6c: INCBIN "gfx/unknown_f9c6c.2bpp" ; indirectly referenced

Func_f9cac:
	call Func_f9e80
	ld c, $5
	call UpdateMusicCTimes
	xor a
	ld [hLCDCPointer], a
	ld hl, vBGMap0
	ld bc, $80
	ld a, $1
	call Bank3E_FillMemory
	ld hl, $9880
	ld bc, $140
	xor a
	call Bank3E_FillMemory
	ld hl, $99c0
	ld bc, $80
	ld a, $1
	call Bank3E_FillMemory
	ld hl, $98c5
	ld de, $20
	ld a, $4
	ld b, $8
.asm_f9ce1
	ld c, $c
	push hl
.asm_f9ce4
	ld [hli], a
	inc a
	dec c
	jr nz, .asm_f9ce4
	pop hl
	add hl, de
	add $4
	dec b
	jr nz, .asm_f9ce1
	ld hl, $98c4
	ld [hl], $3
	ld hl, $98e4
	ld [hl], $74
	ld hl, $99a5
	ld [hl], $0
	lb de, $60, $58
	ld a, $9
	call YellowIntro_SpawnAnimatedObjectAndSavePointer
	xor a
	call Func_f9e9a
	call Func_f9e35
	call Func_f992a
	ret

Func_f9d12:
	call Func_f9e41
	ret nc
	lb de, $68, $58
	ld a, $a
	call SpawnAnimatedObject
	call Func_f992a
	ret

Func_f9d22:
	ld de, Unkn_f9dd6
	call Func_f9e4d
	jr c, .asm_f9d3c
	ld [rBGP], a
	ld [rOBP0], a
	and $f0
	ld [rOBP1], a
	call UpdateGBCPal_BGP
	call UpdateGBCPal_OBP0
	call UpdateGBCPal_OBP1
	ret

.asm_f9d3c
	call MaskAllAnimatedObjectStructs
	call YellowIntro_BlankOAMBuffer
	ld hl, wTileMap
	ld bc, $50
	ld a, $1
	call Bank3E_FillMemory
	coord hl, 0, 4
	ld bc, CopyVideoDataAlternate
	xor a
	call Bank3E_FillMemory
	coord hl, 0, 14
	ld bc, $50
	ld a, $1
	call Bank3E_FillMemory
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	call DelayFrame
	call DelayFrame
	call DelayFrame
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	ld a, $e4
	ld [rOBP0], a
	ld [rBGP], a
	call UpdateGBCPal_BGP
	call UpdateGBCPal_OBP0
	lb de, $58, $58
	ld a, $7
	call YellowIntro_SpawnAnimatedObjectAndSavePointer
	call Func_f992a
	ld a, $28
	ld [wc635], a
	ret

Func_f9d8f:
	call Func_f9e41
	jr c, .asm_f9dad
	ld a, [wc635]
	and $3
	ret nz
	ld a, [rOBP0]
	xor $ff
	ld [rOBP0], a
	ld a, [rBGP]
	xor $3
	ld [rBGP], a
	call UpdateGBCPal_BGP
	call UpdateGBCPal_OBP0
	ret

.asm_f9dad
	xor a
	ld [hLCDCPointer], a
	ld a, $e4
	ld [rBGP], a
	ld [rOBP0], a
	call UpdateGBCPal_BGP
	call UpdateGBCPal_OBP0
	call Func_f992a
Func_f9dbf:
	ld de, Unkn_f9e0a
	call Func_f9e4d
	jr c, .asm_f9dd2
	ld [rOBP0], a
	ld [rBGP], a
	call UpdateGBCPal_BGP
	call UpdateGBCPal_OBP0
	ret

.asm_f9dd2
	call Func_f992a
	ret

Unkn_f9dd6:
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

Unkn_f9e0a:
	db $e4, $90, $90, $40
	db $40, $00, $00, $ff

Func_f9e12:
	ld c, 64
	call DelayFrames
	ld hl, wc634
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

Func_f9e35:
	ld a, $80
	ld [wc635], a
	ret

Func_f9e3b:
	ld a, $58
	ld [wc635], a
	ret

Func_f9e41:
	ld hl, wc635
	ld a, [hl]
	and a
	jr z, .asm_f9e4b
	dec [hl]
	and a
	ret

.asm_f9e4b
	scf
	ret

Func_f9e4d:
	ld hl, wc635
	ld a, [hl]
	inc [hl]
	ld l, a
	ld h, $0
	add hl, de
	ld a, [hl]
	cp $ff
	jr z, .asm_f9e5d
	and a
	ret

.asm_f9e5d
	scf
	ret

Func_f9e5f:
	ld hl, vBGMap0
	ld bc, $80
	ld a, $1
	call Bank3E_FillMemory
	ld hl, $9880
	ld bc, $140
	xor a
	call Bank3E_FillMemory
	ld hl, $99c0
	ld bc, $80
	ld a, $1
	call Bank3E_FillMemory
	ret

Func_f9e80:
	xor a
	ld [rBGP], a
	ld [rOBP0], a
	ld [rOBP1], a
	call UpdateGBCPal_BGP
	call UpdateGBCPal_OBP0
	call UpdateGBCPal_OBP1
	call DelayFrame
	call DelayFrame
	call DisableLCD
	ret

Func_f9e9a:
	ld e, a
	callab Func_720ad
	xor a
	ld [hSCX], a
	ld [hSCY], a
	ld a, $90
	ld [hWY], a
	ld a, $e3
	ld [rLCDC], a
	ld a, $e4
	ld [rBGP], a
	ld [rOBP0], a
	ld a, $e0
	ld [rOBP1], a
	call UpdateGBCPal_BGP
	call UpdateGBCPal_OBP0
	call UpdateGBCPal_OBP1
	ret

Func_f9ec4:
	ld de, wc800
	ld a, $8
.asm_f9ec9
	push af
	ld hl, Unkn_f9ed8
	ld bc, $20
	call Bank3E_CopyData
	pop af
	dec a
	jr nz, .asm_f9ec9
	ret

Unkn_f9ed8:
	db  0,  0,  1,  2,  2,  3,  3,  3
	db  4,  3,  3,  3,  2,  2,  1,  0
	db  0,  0, -1, -2, -2, -3, -3, -3
	db -4, -3, -3, -3, -2, -2, -1,  0

Prep7TileTransferFromC810ToC710:
	ld a, wc810 % $100
	ld [H_VBCOPYSRC], a
	ld a, wc810 / $100
	ld [H_VBCOPYSRC + 1], a
	ld a, wc710 % $100
	ld [H_VBCOPYDEST], a
	ld a, wc710 / $100
	ld [H_VBCOPYDEST + 1], a
	ld a, $7
	ld [H_VBCOPYSIZE], a
	ret

InitYellowIntroGFXAndMusic:
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	ld [hSCX], a
	ld [hSCY], a
	ld [H_AUTOBGTRANSFERDEST], a
	ld a, $98
	ld [H_AUTOBGTRANSFERDEST + 1], a
	call YellowIntro_BlankTileMap
	ld hl, wTileMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	ld a, $1
	call Bank3E_FillMemory
	coord hl, 0, 4
	ld bc, CopyVideoDataAlternate
	xor a
	call Bank3E_FillMemory
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	call DelayFrame
	call DelayFrame
	call DelayFrame
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	ld de, $6b5a
	ld hl, $8000
	ld bc, $3eff
	call CopyVideoData
	ld de, $635a
	ld hl, $9000
	ld bc, $3e80
	call CopyVideoData
	call ClearObjectAnimationBuffers
	call LoadYellowIntroObjectAnimationDataPointers
	ld b, $8
	call RunPaletteCommand
	xor a
	ld hl, wc634
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, MUSIC_INTRO_BATTLE
	ld c, BANK(Music_IntroBattle)
	call PlayMusic
	ret

LoadYellowIntroObjectAnimationDataPointers:
	ld a, YellowIntro_AnimatedObjectSpawnStateData % $100
	ld [wAnimatedObjectSpawnStateDataPointer], a
	ld a, YellowIntro_AnimatedObjectSpawnStateData / $100
	ld [wAnimatedObjectSpawnStateDataPointer + 1], a
	ld a, YellowIntro_AnimatedObjectJumptable % $100
	ld [wAnimatedObjectJumptablePointer], a
	ld a, YellowIntro_AnimatedObjectJumptable / $100
	ld [wAnimatedObjectJumptablePointer + 1], a
	ld a, YellowIntro_AnimatedObjectOAMData % $100
	ld [wAnimatedObjectOAMDataPointer], a
	ld a, YellowIntro_AnimatedObjectOAMData / $100
	ld [wAnimatedObjectOAMDataPointer + 1], a
	ld a, YellowIntro_AnimatedObjectFramesData % $100
	ld [wAnimatedObjectFramesDataPointer], a
	ld a, YellowIntro_AnimatedObjectFramesData / $100
	ld [wAnimatedObjectFramesDataPointer + 1], a
	ret

YellowIntro_BlankTileMap:
	ld hl, wTileMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	ld a, $7f
	call Bank3E_FillMemory
	ret

Bank3E_CopyData:
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, c
	or b
	jr nz, .loop
	ret

Bank3E_FillMemory:
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
	ld hl, wOAMBuffer
	ld bc, wOAMBufferEnd - wOAMBuffer
	xor a
	call Bank3E_FillMemory
	ret

YellowIntro_BlankPalettes:
	xor a
	ld [rBGP], a
	ld [rOBP0], a
	ld [rOBP1], a
	call UpdateGBCPal_BGP
	call UpdateGBCPal_OBP0
	call UpdateGBCPal_OBP1
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
	dw Func_fa007
	dw Func_fa007
	dw Func_fa008
	dw Func_fa014
	dw Func_fa02b
	dw Func_fa062

Func_fa007:
	ret

Func_fa008:
	ld hl, $4
	add hl, bc
	ld a, [hl]
	cp $58
	ret z
	sub $4
	ld [hl], a
	ret

Func_fa014:
	ld hl, $4
	add hl, bc
	ld a, [hl]
	cp $58
	jr z, .asm_fa020
	add $4
	ld [hl], a
.asm_fa020
	ld hl, $5
	add hl, bc
	cp $58
	ret z
	add $1
	ld [hl], a
	ret

Func_fa02b:
	ld hl, $b
	add hl, bc
	ld e, [hl]
	ld d, $0
	ld hl, Jumptable_fa03b
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]

Jumptable_fa03b:
	dw Func_fa03f
	dw Func_fa051

Func_fa03f:
	ld hl, $5
	add hl, bc
	ld a, [hl]
	cp $58
	jr z, .asm_fa04c
	sub $2
	ld [hl], a
	ret

.asm_fa04c
	ld hl, $b
	add hl, bc
	inc [hl]
Func_fa051:
	ld hl, $c
	add hl, bc
	ld a, [hl]
	inc [hl]
	ld d, $8
	call Func_fa079
	ld hl, $7
	add hl, bc
	ld [hl], a
	ret

Func_fa062:
	ld hl, $b
	add hl, bc
	ld a, [hl]
	ld hl, $4
	add hl, bc
	add [hl]
	ld [hl], a
	ret

Func_fa06e:
	ld e, a
	ld d, $0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

Func_fa077: ; cosine
	add $10
Func_fa079:
	and $3f
	cp $20
	jr nc, .asm_fa084
	call Func_fa08e
	ld a, h
	ret

.asm_fa084
	and $1f
	call Func_fa08e
	ld a, h
	xor $ff
	inc a
	ret

Func_fa08e:
	ld e, a
	ld a, d
	ld d, $0
	ld hl, Unkn_fa0aa
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, $0
.asm_fa09d
	srl a
	jr nc, .asm_fa0a2
	add hl, de
.asm_fa0a2
	sla e
	rl d
	and a
	jr nz, .asm_fa09d
	ret

Unkn_fa0aa:
	sine_wave $100
