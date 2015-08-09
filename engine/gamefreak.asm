LoadShootingStarGraphics: ; 70000 (1c:4000)
	ld a, $f9
	ld [rOBP0], a ; $ff48
	ld a, $a4
	ld [rOBP1], a ; $ff49
	call Func_3040
	call Func_3061
	ld de, AnimationTileset2 ; $4757 ; star tile (top left quadrant)
	ld hl, vChars1 + $200
	ld bc, (BANK(AnimationTileset2) << 8) + $01
	call CopyVideoData
	ld de, AnimationTileset2 + $100 ; $481e ; star tile (bottom left quadrant)
	ld hl, vChars1 + $210
	ld bc, (BANK(AnimationTileset2) << 8) + $01
	call CopyVideoData
	ld de, FallingStar ; $4190
	ld hl, vChars1 + $220
	ld bc, (BANK(FallingStar) << 8) + $01
	call CopyVideoData
	ld hl, GameFreakLogoOAMData ; $4140
	ld de, wOAMBuffer + $60
	ld bc, $40
	call CopyData
	ld hl, GameFreakShootingStarOAMData ; $4180
	ld de, wOAMBuffer
	ld bc, $10
	jp CopyData

AnimateShootingStar: ; 7004a (1c:404a)
	call LoadShootingStarGraphics
	ld a, $c2 ; (SFX_1f_67 - SFX_Headers_1f) / 3
	call PlaySound
	ld hl, wOAMBuffer
	ld bc, $a004
.asm_70058
	push hl
	push bc
.asm_7005a
	ld a, [hl]
	add $4
	ld [hli], a
	ld a, [hl]
	add $fc
	ld [hli], a
	inc hl
	inc hl
	dec c
	jr nz, .asm_7005a
	ld c, $1
	call CheckForUserInterruption
	pop bc
	pop hl
	ret c
	ld a, [hl]
	cp $50
	jr nz, .asm_70076
	jr .asm_70058
.asm_70076
	cp b
	jr nz, .asm_70058
	ld hl, wOAMBuffer
	ld c, $4
	ld de, $4
.loop
	ld [hl], $a0
	add hl, de
	dec c
	jr nz, .loop
	ld b, $3
.asm_70089
	ld hl, rOBP0 ; $ff48
	rrc [hl]
	rrc [hl]
	call Func_3040
	ld c, $a
	call CheckForUserInterruption
	ret c
	dec b
	jr nz, .asm_70089
	ld de, wOAMBuffer
	ld a, $18
.asm_700a1
	push af
	ld hl, OAMData_70101 ; $40ee
	ld bc, $4
	call CopyData
	pop af
	dec a
	jr nz, .asm_700a1
	xor a
	ld [wWhichTrade], a ; wWhichTrade
	ld hl, PointerTable_70105 ; 1c:4105
	ld c, $6
.asm_700b8
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	push bc
	push hl
	ld hl, wOAMBuffer + $50
	ld c, $4
.asm_700c3
	ld a, [de]
	cp $ff
	jr z, .asm_700e8
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	inc hl
	push bc
	ld a, [de]
	ld b,a
	ld a, [hl]
	and $f0
	or b
	ld [hl], a
	inc de
	pop bc
	inc hl
	dec c
	jr nz, .asm_700c3
	ld a, [wWhichTrade] ; wWhichTrade
	cp $18
	jr z, .asm_700e8
	add $6
	ld [wWhichTrade], a ; wWhichTrade
.asm_700e8
	call Func_70142
	push af
	ld hl, wOAMBuffer + $10
	ld de, wOAMBuffer
	ld bc, $50
	call CopyData
	pop af
	pop hl
	pop bc
	ret c
	dec c
	jr nz, .asm_700b8
	and a
	ret

OAMData_70101: ; 70101 (1c:4101)
	db $00,$00,$A2,$90

PointerTable_70105: ; 70105 (1c:4105)
	dw OAMData_70111
	dw OAMData_7011d
	dw OAMData_70129
	dw OAMData_70135
	dw OAMData_70141
	dw OAMData_70141

; each entry is only half of an OAM tile
OAMData_70111: ; 70111 (1c:4111)
	db $68,$30
	db $05,$68
	db $40,$05
	db $68,$58
	db $04,$68
	db $78,$07

OAMData_7011d: ; 7011d (1c:411d)
	db $68,$38
	db $05,$68
	db $48,$06
	db $68,$60
	db $04,$68
	db $70,$07

OAMData_70129: ; 70129 (1c:4129)
	db $68,$34
	db $05,$68
	db $4c,$06
	db $68,$54
	db $06,$68
	db $64,$07

OAMData_70135: ; 70135 (1c:4135)
	db $68,$3c
	db $05,$68
	db $5c,$04
	db $68,$6c
	db $07,$68
	db $74,$07

OAMData_70141: ; 70141 (1c:4141)
	db $FF

Func_70142: ; 70142 (1c:4142)
	ld b, $8
.asm_70144
	ld hl, wOAMBuffer + $5c
	ld a, [wWhichTrade] ; wWhichTrade
	ld de, $fffc
	ld c, a
.asm_7014e
	inc [hl]
	add hl, de
	dec c
	jr nz, .asm_7014e
	ld a, [rOBP1] ; $ff49
	xor $a0
	ld [rOBP1], a ; $ff49
	call Func_3061
	ld c, $3
	call CheckForUserInterruption
	ret c
	dec b
	jr nz, .asm_70144
	ret

GameFreakLogoOAMData: ; 70166 (1c:4166)
	db $48,$50,$8D,$00
	db $48,$58,$8E,$00
	db $50,$50,$8F,$00
	db $50,$58,$90,$00
	db $58,$50,$91,$00
	db $58,$58,$92,$00
	db $60,$30,$80,$00
	db $60,$38,$81,$00
	db $60,$40,$82,$00
	db $60,$48,$83,$00
	db $60,$50,$93,$00
	db $60,$58,$84,$00
	db $60,$60,$85,$00
	db $60,$68,$83,$00
	db $60,$70,$81,$00
	db $60,$78,$86,$00

GameFreakShootingStarOAMData: ; 701a6 (1c:41a6)
	db $00,$A0,$A0,$14
	db $00,$A8,$A0,$34
	db $08,$A0,$A1,$14
	db $08,$A8,$A1,$34

FallingStar: ; 701b6 (1c:41b6)
	INCBIN "gfx/falling_star.2bpp"
