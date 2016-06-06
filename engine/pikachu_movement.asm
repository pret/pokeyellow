ApplyPikachuMovementData_:: ; fd2a1 (3f:52a1)
	ld a, b
	ld [wPikachuMovementScriptBank], a
	ld a, l
	ld [wPikachuMovementScriptAddress], a
	ld a, h
	ld [wPikachuMovementScriptAddress + 1], a
	call PikachuSwapSpriteStateData
.loop
	call LoadPikachuMovementCommandData
	jr nc, .done
	call ExecutePikachuMovementCommand
	jr .loop

.done
	call PikachuSwapSpriteStateData
	call DelayFrame
	ret

PikachuSwapSpriteStateData:
	ld a, [wUpdateSpritesEnabled]
	push af
	ld a, $ff
	ld [wUpdateSpritesEnabled], a
	push hl
	push de
	push bc

	ld hl, wSpriteStateData1
	ld de, wPikachuSpriteStateData1
	ld c, $10
	call SwapBytes3f

	ld hl, wSpriteStateData2
	ld de, wPikachuSpriteStateData2
	ld c, $10
	call SwapBytes3f

	pop bc
	pop de
	pop hl
	pop af
	ld [wUpdateSpritesEnabled], a
	ret

SwapBytes3f:
.loop
	ld b, [hl]
	ld a, [de]
	ld [hli], a
	ld a, b
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	ret

LoadPikachuMovementCommandData:
	call GetPikachuMovementScriptByte
	cp $3f
	ret z
	ld c, a
	ld b, 0
	ld hl, Data_fd3b0
	add hl, bc
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld [wPikaPicAnimPointer + 1], a
	ld a, [hli]
	cp $80
	jr nz, .no_param
	call GetPikachuMovementScriptByte
.no_param
	ld [wPikaPicAnimPointer], a
	ld a, [hli]
	ld [wPikaPicAnimCurGraphicID], a
	ld a, [hli]
	cp $80
	jr nz, .no_param2
	call GetPikachuMovementScriptByte
.no_param2
	ld [wPikaPicAnimPointerSetupFinished], a
	xor a
	ld [wPikaPicAnimTimer], a
	scf
	ret

ExecutePikachuMovementCommand:
	xor a
	ld [wd44d], a
	ld [wd457], a
	ld [wd458], a
	ld a, [wPlayerGrassPriority]
	push af
.loop
	ld bc, wSpriteStateData1
	ld a, [wPikaPicAnimPointer + 1]
	ld hl, Jumptable_fd4ac
	call .JumpTable
	ld a, [wPikaPicAnimCurGraphicID]
	ld hl, Jumptable_fd65c
	call .JumpTable
	call Func_fd36e
	call Func_fd39d
	call DelayFrame
	call DelayFrame
	ld hl, wd44d
	bit 7, [hl]
	jr z, .loop
	pop af
	ld [wPlayerGrassPriority], a
	scf
	ret

.JumpTable:
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl]

Func_fd36e:
	ld hl, 2
	add hl, bc
	ld a, [wPikaPicAnimTimer + 1]
	ld [hl], a
	ld a, [wPikaSpriteY]
	ld d, a
	ld a, [wd456]
	add d
	ld hl, 4
	add hl, bc
	ld [hl], a
	ld a, [wPikaPicAnimDelay]
	ld d, a
	ld a, [wPikaPicTextboxStartY]
	add d
	ld hl, 6
	add hl, bc
	ld [hl], a
	ld hl, wd44d
	bit 6, [hl]
	ret z
	ld hl, wPlayerGrassPriority - wSpriteStateData1
	add hl, bc
	ld [hl], 0
	ret

Func_fd39d:
	ld hl, wd44d
	bit 6, [hl]
	res 6, [hl]
	ld hl, wd736
	res 6, [hl]
	ret z
	set 6, [hl]
	call Func_fd7f3
	ret

Data_fd3b0:
	db $01, $00, $00, $00 ; $00
	db $03, $80, $01, $00 ; $01
	db $04, $80, $01, $00 ; $02
	db $05, $80, $01, $00 ; $03
	db $06, $80, $01, $00 ; $04
	db $07, $80, $01, $00 ; $05
	db $08, $80, $01, $00 ; $06
	db $09, $80, $01, $00 ; $07
	db $0a, $80, $01, $00 ; $08
	db $03, $80, $06, $00 ; $09
	db $04, $80, $06, $00 ; $0a
	db $05, $80, $06, $00 ; $0b
	db $06, $80, $06, $00 ; $0c
	db $07, $80, $06, $00 ; $0d
	db $08, $80, $06, $00 ; $0e
	db $09, $80, $06, $00 ; $0f
	db $0a, $80, $06, $00 ; $10
	db $03, $80, $03, $80 ; $11
	db $04, $80, $03, $80 ; $12
	db $05, $80, $03, $80 ; $13
	db $06, $80, $03, $80 ; $14
	db $07, $80, $03, $80 ; $15
	db $08, $80, $03, $80 ; $16
	db $09, $80, $03, $80 ; $17
	db $0a, $80, $03, $80 ; $18
	db $03, $80, $07, $80 ; $19
	db $04, $80, $07, $80 ; $1a
	db $05, $80, $07, $80 ; $1b
	db $06, $80, $07, $80 ; $1c
	db $0b, $27, $02, $00 ; $1d step down
	db $0c, $27, $02, $00 ; $1e step up
	db $0d, $27, $02, $00 ; $1f step left
	db $0e, $27, $02, $00 ; $20 step right
	db $0f, $27, $02, $00 ; $21
	db $10, $27, $02, $00 ; $22
	db $11, $27, $02, $00 ; $23
	db $12, $27, $02, $00 ; $24
	db $0b, $0f, $02, $00 ; $25
	db $0c, $0f, $02, $00 ; $26
	db $0d, $0f, $02, $00 ; $27
	db $0e, $0f, $02, $00 ; $28
	db $0f, $0f, $02, $00 ; $29
	db $10, $0f, $02, $00 ; $2a
	db $11, $0f, $02, $00 ; $2b
	db $12, $0f, $02, $00 ; $2c
	db $0b, $0f, $08, $17 ; $2d
	db $0c, $0f, $08, $17 ; $2e
	db $0d, $0f, $08, $17 ; $2f
	db $0e, $0f, $08, $17 ; $30
	db $0f, $0f, $08, $17 ; $31
	db $10, $0f, $08, $17 ; $32
	db $11, $0f, $08, $17 ; $33
	db $12, $0f, $08, $17 ; $34
	db $13, $0f, $06, $00 ; $35 look down
	db $14, $0f, $06, $00 ; $36 look up
	db $15, $0f, $06, $00 ; $37 look left
	db $16, $0f, $06, $00 ; $38 look right
	db $02, $80, $04, $00 ; $39
	db $02, $80, $05, $00 ; $3a
	db $02, $80, $03, $80 ; $3b
	db $02, $80, $07, $80 ; $3c
	db $02, $80, $09, $80 ; $3d
	db $02, $80, $06, $00 ; $3e

Jumptable_fd4ac:
	dw Func_fd4e5
 	dw Func_fd4e9
 	dw Func_fd504
 	dw Func_fd50c
 	dw Func_fd511
 	dw Func_fd518
 	dw Func_fd52c
 	dw Func_fd540
 	dw Func_fd553
 	dw Func_fd566
 	dw Func_fd579
 	dw Func_fd5b1
 	dw Func_fd5b5
 	dw Func_fd5b9
 	dw Func_fd5bd
 	dw Func_fd5c1
 	dw Func_fd5c5
 	dw Func_fd5c9
 	dw Func_fd5cd
 	dw Func_fd5ea
 	dw Func_fd5ee
 	dw Func_fd5f2
 	dw Func_fd5f6
 	dw Func_fd4e5

Func_fd4dc:
	ld a, [wd44d]
	set 7, a
	ld [wd44d], a
	ret

Func_fd4e5:
	call Func_fd4dc
	ret

Func_fd4e9:
	ld hl, 4
	add hl, bc
	ld a, [hl]
	ld [wPikaSpriteY], a
	ld hl, 6
	add hl, bc
	ld a, [hl]
	ld [wPikaPicAnimDelay], a
	xor a
	ld [wd456], a
	ld [wPikaPicTextboxStartY], a
	call Func_fd4dc
	ret

Func_fd504:
	call Func_fd775
	ret nz
	call Func_fd4dc
	ret

Func_fd50c:
	call GetObjectFacing
	jr asm_fd58c

Func_fd511:
	call GetObjectFacing
	xor %100
	jr asm_fd58c

Func_fd518:
	call GetObjectFacing
	ld hl, Data_fd523
	call Func_fd5a0
	jr asm_fd58c

Data_fd523:
	db SPRITE_FACING_DOWN,  SPRITE_FACING_RIGHT
	db SPRITE_FACING_UP,    SPRITE_FACING_LEFT
	db SPRITE_FACING_LEFT,  SPRITE_FACING_DOWN
	db SPRITE_FACING_RIGHT, SPRITE_FACING_UP
	db $ff

Func_fd52c:
	call GetObjectFacing
	ld hl, Data_fd537
	call Func_fd5a0
	jr asm_fd58c

Data_fd537:
	db SPRITE_FACING_DOWN,  SPRITE_FACING_LEFT
	db SPRITE_FACING_UP,    SPRITE_FACING_RIGHT
	db SPRITE_FACING_LEFT,  SPRITE_FACING_UP
	db SPRITE_FACING_RIGHT, SPRITE_FACING_DOWN
	db $ff

Func_fd540:
	call GetObjectFacing
	ld hl, Data_fd54b
	call Func_fd5a0
	jr asm_fd58c

Data_fd54b:
	db SPRITE_FACING_DOWN,  SPRITE_FACING_UP | $10
	db SPRITE_FACING_UP,    SPRITE_FACING_LEFT | $10
	db SPRITE_FACING_LEFT,  SPRITE_FACING_DOWN | $10
	db SPRITE_FACING_RIGHT, SPRITE_FACING_RIGHT | $10

Func_fd553:
	call GetObjectFacing
	ld hl, Data_fd55e
	call Func_fd5a0
	jr asm_fd58c

Data_fd55e:
	db SPRITE_FACING_DOWN,  SPRITE_FACING_DOWN | $10
	db SPRITE_FACING_UP,    SPRITE_FACING_RIGHT | $10
	db SPRITE_FACING_LEFT,  SPRITE_FACING_LEFT | $10
	db SPRITE_FACING_RIGHT, SPRITE_FACING_UP | $10

Func_fd566:
	call GetObjectFacing
	ld hl, Data_fd571
	call Func_fd5a0
	jr asm_fd58c

Data_fd571:
	db SPRITE_FACING_DOWN,  SPRITE_FACING_RIGHT | $10
	db SPRITE_FACING_UP,    SPRITE_FACING_DOWN | $10
	db SPRITE_FACING_LEFT,  SPRITE_FACING_UP | $10
	db SPRITE_FACING_RIGHT, SPRITE_FACING_LEFT | $10

Func_fd579:
	call GetObjectFacing
	ld hl, Data_fd584
	call Func_fd5a0
	jr asm_fd58c

Data_fd584:
	db SPRITE_FACING_DOWN,  SPRITE_FACING_LEFT | $10
	db SPRITE_FACING_UP,    SPRITE_FACING_UP | $10
	db SPRITE_FACING_LEFT,  SPRITE_FACING_RIGHT | $10
	db SPRITE_FACING_RIGHT, SPRITE_FACING_DOWN | $10

asm_fd58c
	rrca
	rrca
	and $7
	ld e, a
	call Func_fd784
	ld d, a
	call UpdatePikachuPosition
	call Func_fd775
	ret nz
	call Func_fd4dc
	ret

Func_fd5a0:
	push de
	ld d, a
.asm_fd5a2
	ld a, [hli]
	cp d
	jr z, .asm_fd5ad
	inc hl
	cp $ff
	jr nz, .asm_fd5a2
	pop de
	ret

.asm_fd5ad
	ld a, [hl]
	pop de
	scf
	ret

Func_fd5b1:
	ld a, SPRITE_FACING_DOWN >> 2
	jr asm_fd5d1

Func_fd5b5:
	ld a, SPRITE_FACING_UP >> 2
	jr asm_fd5d1

Func_fd5b9:
	ld a, SPRITE_FACING_LEFT >> 2
	jr asm_fd5d1

Func_fd5bd:
	ld a, SPRITE_FACING_RIGHT >> 2
	jr asm_fd5d1

Func_fd5c1:
	ld e, 4
	jr asm_fd5d5

Func_fd5c5:
	ld e, 5
	jr asm_fd5d5

Func_fd5c9:
	ld e, 6
	jr asm_fd5d5

Func_fd5cd:
	ld e, 7
	jr asm_fd5d5

asm_fd5d1
	ld e, a
	call SetObjectFacing
asm_fd5d5
	call Func_fd784
	ld d, a
	push de
	call UpdatePikachuPosition
	pop de
	call Func_fd775
	ret nz
	ld a, e
	call Func_fd7cb
	call Func_fd4dc
	ret

Func_fd5ea:
	ld a, SPRITE_FACING_DOWN >> 2
	jr asm_fd5fa

Func_fd5ee:
	ld a, SPRITE_FACING_UP >> 2
	jr asm_fd5fa

Func_fd5f2:
	ld a, SPRITE_FACING_LEFT >> 2
	jr asm_fd5fa

Func_fd5f6:
	ld a, SPRITE_FACING_RIGHT >> 2
	jr asm_fd5fa

asm_fd5fa
	call SetObjectFacing
	call Func_fd4dc
	ret

UpdatePikachuPosition:
	push de
	ld d, 0
	ld hl, Jumptable_fd60f
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop de
	ld a, d
	jp [hl]

Jumptable_fd60f:
	dw MovePikachuSpriteDown
	dw MovePikachuSpriteUp
	dw MovePikachuSpriteLeft
	dw MovePikachuSpriteRight
	dw MovePikachuSpriteDownLeft
	dw MovePikachuSpriteDownRight
	dw MovePikachuSpriteUpLeft
	dw MovePikachuSpriteUpRight

MovePikachuSpriteDown:
	ld d, 0
	ld e, a
	jr asm_fd64d

MovePikachuSpriteUp:
	ld d, 0
	cpl
	inc a
	ld e, a
	jr asm_fd64d

MovePikachuSpriteLeft:
	cpl
	inc a
	ld d, a
	ld e, 0
	jr asm_fd64d

MovePikachuSpriteRight:
	ld d, a
	ld e, 0
	jr asm_fd64d

MovePikachuSpriteDownLeft:
	ld e, a
	cpl
	inc a
	ld d, a
	jr asm_fd64d

MovePikachuSpriteDownRight:
	ld e, a
	ld d, a
	jr asm_fd64d

MovePikachuSpriteUpLeft:
	cpl
	inc a
	ld e, a
	ld d, a
	jr asm_fd64d

MovePikachuSpriteUpRight:
	ld d, a
	cpl
	inc a
	ld e, a
	jr asm_fd64d

asm_fd64d
	ld a, [wPikaPicAnimDelay]
	add d
	ld [wPikaPicAnimDelay], a
	ld a, [wPikaSpriteY]
	add e
	ld [wPikaSpriteY], a
	ret

Jumptable_fd65c:
	dw Func_fd678
	dw Func_fd6a3
	dw Func_fd698
	dw Func_fd6f4
	dw Func_fd6ff
	dw Func_fd718
	dw Func_fd68c
	dw Func_fd6c6
	dw Func_fd6c0
	dw Func_fd6e2
	dw Func_fd68b

Func_fd672:
	ld hl, wd44d
	set 6, [hl]
	ret

Func_fd678:
	ld hl, 7
	add hl, bc
	xor a
	ld [hli], a
	ld [hl], a
	call Func_fd74a
	ld d, a
	call GetObjectFacing
	or d
	ld [wPikaPicAnimTimer + 1], a
	ret

Func_fd68b:
	ret

Func_fd68c:
	call Func_fd74a
	ld d, a
	call Func_fd755
	or d
	ld [wPikaPicAnimTimer + 1], a
	ret

Func_fd698:
	call Func_fd74a
	ld d, a
	call GetObjectFacing
	or d
	ld d, a
	jr asm_fd6ac

Func_fd6a3:
	call Func_fd74a
	ld d, a
	call Func_fd755
	or d
	ld d, a
asm_fd6ac
	ld hl, 8
	add hl, bc
	call Func_fd78e
	jr nz, .asm_fd6b6
	inc [hl]
.asm_fd6b6
	ld a, [hl]
	rrca
	rrca
	and 3
	or d
	ld [wPikaPicAnimTimer + 1], a
	ret

Func_fd6c0:
	call GetObjectFacing
	ld d, a
	jr asm_fd6ca

Func_fd6c6:
	call Func_fd755
	ld d, a
asm_fd6ca
	call Func_fd74a
	or d
	ld d, a
	call Func_fd736
	or d
	ld [wPikaPicAnimTimer + 1], a
	call Func_fd79d
	ld [wd456], a
	and a
	ret z
	call Func_fd672
	ret

Func_fd6e2:
	call GetObjectFacing
	ld d, a
	call Func_fd74a
	or d
	ld [wPikaPicAnimTimer + 1], a
	call Func_fd79d
	ld [wd456], a
	ret

Func_fd6f4:
	ld a, [wPikaPicAnimPointerSetupFinished]
	and $40
	cp $40
	jr z, Func_fd6ff
	jr Func_fd718

Func_fd6ff:
	call Func_fd755
	ld d, a
	call Func_fd78e
	jr nz, .asm_fd710
	ld hl, Data_fd731
.asm_fd70b
	ld a, [hli]
	cp d
	jr nz, .asm_fd70b
	ld d, [hl]
.asm_fd710
	call Func_fd74a
	or d
	ld [wPikaPicAnimTimer + 1], a
	ret

Func_fd718:
	call Func_fd755
	ld d, a
	call Func_fd78e
	jr nz, .asm_fd529
	ld hl, Data_fd731End
.asm_fd524
	ld a, [hld]
	cp d
	jr nz, .asm_fd524
	ld d, [hl]
.asm_fd529
	call Func_fd74a
	or d
	ld [wPikaPicAnimTimer + 1], a
	ret

Data_fd731:
	db SPRITE_FACING_DOWN
	db SPRITE_FACING_LEFT
	db SPRITE_FACING_UP
	db SPRITE_FACING_RIGHT
	db SPRITE_FACING_DOWN
Data_fd731End:

Func_fd736:
	push hl
	ld hl, 7
	add hl, bc
	ld a, [hl]
	inc a
	and $3
	ld [hli], a
	jr nz, .asm_fd747
	ld a, [hl]
	inc a
	and $3
	ld [hl], a
.asm_fd747
	ld a, [hl]
	pop hl
	ret

Func_fd74a:
	push hl
	ld hl, wSpriteStateData2 - wSpriteStateData1 + 14
	add hl, bc
	ld a, [hl]
	dec a
	swap a
	pop hl
	ret

Func_fd755:
	push hl
	ld hl, 2
	add hl, bc
	ld a, [hl]
	and $c
	pop hl
	ret

GetObjectFacing:
	push hl
	ld hl, 9
	add hl, bc
	ld a, [hl]
	and $c
	pop hl
	ret

SetObjectFacing:
	push hl
	ld hl, 9
	add hl, bc
	add a
	add a
	and $c
	ld [hl], a
	pop hl
	ret

Func_fd775:
	ld hl, wd457
	inc [hl]
	ld a, [wPikaPicAnimPointer]
	and $1f
	inc a
	cp [hl]
	ret nz
	ld [hl], 0
	ret

Func_fd784:
	ld a, [wPikaPicAnimPointer]
	swap a
	rrca
	and $3
	inc a
	ret

Func_fd78e:
	ld hl, wd458
	inc [hl]
	ld a, [wPikaPicAnimPointerSetupFinished]
	and $f
	inc a
	cp [hl]
	ret nz
	ld [hl], 0
	ret

Func_fd79d:
	call Func_fd7b2
	ld a, [wd458]
	add e
	ld [wd458], a
	add $20
	ld e, a
	push hl
	push bc
	call Sine_e
	pop bc
	pop hl
	ret

Func_fd7b2:
	ld a, [wPikaPicAnimPointerSetupFinished]
	and $f
	inc a
	ld d, a
	ld a, [wPikaPicAnimPointerSetupFinished]
	swap a
	and $7
	ld e, a
	ld a, 1
	jr z, .asm_fd7c9
.asm_fd7c5
	add a
	dec e
	jr nz, .asm_fd7c5
.asm_fd7c9
	ld e, a
	ret

Func_fd7cb:
	push bc
	ld c, a
	ld b, 0
	ld hl, Data_fd7e3
	add hl, bc
	add hl, bc
	ld d, [hl]
	inc hl
	ld e, [hl]
	pop bc
	ld hl, wSpriteStateData2 - wSpriteStateData1 + 4
	add hl, bc
	ld a, [hl]
	add e
	ld [hli], a
	ld a, [hl]
	add d
	ld [hl], a
	ret

Data_fd7e3:
	db  0,  1
	db  0, -1
	db -1,  0
	db  1,  0
	db -1,  1
	db  1,  1
	db -1, -1
	db  1, -1

Func_fd7f3:
	push bc
	push de
	push hl
	
	ld bc, wOAMBuffer + 4 * 36
	ld a, [wPikaSpriteY]
	ld e, a
	ld a, [wPikaPicAnimDelay]
	ld d, a
	ld hl, Data_fd80b
	call Func_fd814

	pop hl
	pop de
	pop bc
	ret

Data_fd80b:
	db $02
	db $0c, $00, $ff, 0
	db $0c, $08, $ff, 1 << OAM_X_FLIP

Func_fd814:
	ld a, e
	add $10
	ld e, a
	ld a, d
	add $8
	ld d, a
	ld a, [hli]
.asm_fd81d
	push af
	ld a, [hli]
	add e
	ld [bc], a
	inc bc
	ld a, [hli]
	add d
	ld [bc], a
	inc bc
	ld a, [hli]
	ld [bc], a
	inc bc
	ld a, [hli]
	ld [bc], a
	inc bc
	pop af
	dec a
	jr nz, .asm_fd81d
	ret

LoadPikachuShadowIntoVRAM:
	ld hl, vNPCSprites2 + $7f * $10
	ld de, LedgeHoppingShadowGFX_3F
	lb bc, BANK(LedgeHoppingShadowGFX_3F), (LedgeHoppingShadowGFX_3FEnd - LedgeHoppingShadowGFX_3F) / 8
	jp CopyVideoDataDoubleAlternate

LedgeHoppingShadowGFX_3F:
INCBIN "gfx/ledge_hopping_shadow.1bpp"
LedgeHoppingShadowGFX_3FEnd:

LoadPikachuBallIconIntoVRAM:
	ld hl, vNPCSprites2 + $7e * $10
	ld de, GFX_fd86b
	lb bc, BANK(GFX_fd86b), 1
	jp CopyVideoDataDoubleAlternate

Func_fd851:
	ld hl, vNPCSprites + $c * $10
	ld a, 3
.asm_fd856
	push af
	push hl
	ld de, GFX_fd86b
	lb bc, BANK(GFX_fd86b), 4
	call CopyVideoDataAlternate
	pop hl
	ld de, 4 * $10
	add hl, de
	pop af
	dec a
	jr nz, .asm_fd856
	ret

GFX_fd86b:
INCBIN "gfx/unknown_fd86b.2bpp"

LoadPikachuSpriteIntoVRAM: ; fd8ab (3f:58ab)
	ld de, PikachuSprite
	lb bc, BANK(PikachuSprite), (SandshrewSprite - PikachuSprite) / 32
	ld hl, vNPCSprites + $c * $10
	push bc
	call CopyVideoDataAlternate
	ld de, PikachuSprite + $c * $10
	ld hl, vNPCSprites2 + $c * $10
	ld a, [h_0xFFFC]
	and a
	jr z, .load
	ld de, PikachuSprite + $c * $10
	ld hl, vNPCSprites2 + $4c * $10
.load
	pop bc
	call CopyVideoDataAlternate
	call LoadPikachuShadowIntoVRAM
	call LoadPikachuBallIconIntoVRAM
	ret

PikachuPewterPokecenterCheck: ; fd8d4 (3f:58d4)
	ld a, [wCurMap]
	cp PEWTER_POKECENTER
	ret nz
	call EnablePikachuFollowingPlayer
	call StarterPikachuEmotionCommand_turnawayfromplayer
	ret

PikachuFanClubCheck: ; fd8e1 (3f:58e1)
	ld a, [wCurMap]
	cp POKEMON_FAN_CLUB
	ret nz
	call EnablePikachuFollowingPlayer
	call StarterPikachuEmotionCommand_turnawayfromplayer
	ret

PikachuBillsHouseCheck: ; fd8ee (3f:58ee)
	ld a, [wCurMap]
	cp BILLS_HOUSE
	ret nz
	call EnablePikachuFollowingPlayer
	ret

Pikachu_LoadCurrentMapViewUpdateSpritesAndDelay3: ; fd8f8 (3f:58f8)
	call LoadCurrentMapView
	call UpdateSprites
	call Delay3
	ret

Cosine_e: ; cosine?
	ld a, e
	add $10
	jr asm_fd908

Sine_e: ; sine?
	ld a, e
asm_fd908
	and $3f
	cp $20
	jr nc, .asm_fd913
	call GetSine
	ld a, h
	ret

.asm_fd913
	and $1f
	call GetSine
	ld a, h
	cpl
	inc a
	ret

GetSine:
	ld e, a
	ld a, d
	ld d, 0
	ld hl, SineWave_3f
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, 0
.asm_fd92b
	srl a
	jr nc, .asm_fd930
	add hl, de
.asm_fd930
	sla e
	rl d
	and a
	jr nz, .asm_fd92b
	ret

SineWave_3f:
	sine_wave $100
