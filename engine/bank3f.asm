INCLUDE "data/map_songs.asm"
INCLUDE "data/map_header_pointers.asm"
INCLUDE "data/map_header_banks.asm"

Func_fc4dd:: ; fc4dd (3f:44dd)
; possibly to test if pika should be out?
	ld a, [wd430]
	bit 5, a
	jr nz, .asm_fc4f8 ; 3f:44f8
	ld a, [wd430]
	bit 7, a
	jr nz, .asm_fc4f8
	call IsStarterPikachuInOurParty
	jr nc, .asm_fc4f8
	ld a, [wWalkBikeSurfState]
	and a
	jr nz, .asm_fc4f8
	scf
	ret
.asm_fc4f8
	and a
	ret
	
Func_fc4fa:: ; fc4fa (3f:44fa)
	ld hl, wd430
	bit 4, [hl]
	res 4, [hl]
	jr nz, .asm_fc515
	call Func_1542
	call Func_fc523
	ld a, $ff
	ld [wSpriteStateData1 + $f2], a
	call Func_fcb84
	call Func_fc5bc
	ret
	
.asm_fc515
	call Func_fc53f
	xor a
	ld [wd431], a
	ld a, [wSpriteStateData1 + $9]
	ld [wSpriteStateData1 + $f9], a
	ret
	
Func_fc523:: ; fc523 (3f:4523)
	ld hl, wSpriteStateData1 + $f0
	call Func_fc52c
	ld hl, wSpriteStateData2 + $f0
Func_fc52c:: ; fc52c (3f:4523)
	ld bc, $10
	xor a
	call FillMemory
	ret

Func_fc534:: ; fc534 (3f:4534)
	call Func_fc53f
	call Func_fc5bc
	xor a
	ld [wd431], a
	ret
	
Func_fc53f:: ; fc53f (3f:453f)
	ld bc, wSpriteStateData1 + $f0
	ld a, [wYCoord]
	add $4
	ld e, a
	ld a, [wXCoord]
	add $4
	ld d, a
	ld a, [wd431]
	and a
	jr z, .asm_fc5aa
	cp $1
	jr z, .asm_fc59e
	cp $2
	jr z, .asm_fc584
	cp $3
	jr z, .asm_fc5aa
	cp $4
	jr z, .asm_fc5a4
	cp $5
	jr z, .asm_fc5a7
	cp $6
	jr z, .asm_fc5a1
	cp $7
	jr z, .asm_fc572
	jr .asm_fc59e
	
.asm_fc572
	ld a, [wSpriteStateData1 + $9]
	and a ; SPRITE_FACING_DOWN
	jr z, .asm_fc5a4
	cp SPRITE_FACING_UP 
	jr z, .asm_fc5a7
	cp SPRITE_FACING_LEFT
	jr z, .asm_fc5a1
	cp SPRITE_FACING_RIGHT
	jr z, .asm_fc59e
.asm_fc584
	ld a, [wSpriteStateData1 + $9]
	and a
	jr nz, .asm_fc58d
	dec e
	jr .asm_fc5aa
.asm_fc58d
	cp SPRITE_FACING_UP
	jr nz, .asm_fc594
	inc e
	jr .asm_fc5aa
.asm_fc594
	cp SPRITE_FACING_LEFT
	jr nz, .asm_fc59b
	inc d
	jr .asm_fc5aa
.asm_fc59b
	dec d
	jr .asm_fc5aa
.asm_fc59e
	inc d
	jr .asm_fc5aa
.asm_fc5a1
	dec d
	jr .asm_fc5aa
.asm_fc5a4
	inc e
	jr .asm_fc5aa
.asm_fc5a7
	dec e
	jr .asm_fc5aa ; useless jr
.asm_fc5aa
	ld hl, $104
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
Func_fc4b2:: ; fc4b2 (3f:44b2)
	ld [hl], $fe
	push hl
	ld hl, wd472
	set 5, [hl]
	pop hl
	ret
	
Func_fc5bc:: ; fc5bc (3f:45bc)
	ld a, $49
	ld [wSpriteStateData1 + $f0], a
	ld a, $ff
	ld [wSpriteStateData1 + $f2], a
	ld a, [wd431]
	and a
	jr z, .asm_fc5e4
	cp $1
	jr z, .asm_fc5e4
	cp $3
	jr z, .asm_fc5eb
	cp $4
	jr z, .asm_fc5e4
	cp $6
	jr z, .asm_fc5e4
	cp $7
	jr z, .asm_fc5f1
	call Func_fccb2
	ret
	
.asm_fc5e4
	ld a, [wSpriteStateData1 + $9]
	ld [wSpriteStateData1 + $f9], a
	ret
.asm_fc5eb
	ld a, $0
	ld [wSpriteStateData1 + $f9], a
	ret
.asm_fc5f1
	ld a, [wSpriteStateData1 + $9]
	xor $4
	ld [wSpriteStateData1 + $f9], a
	ret

Func_fc5fa:: ; fc5fa (3f:45fa)
	ld a, [wCurMap]
	cp OAKS_LAB
	jr z, .asm_fc63d
	cp ROUTE_22_GATE
	jr z, .asm_fc62d
	cp MT_MOON_2
	jr z, .asm_fc635
	cp ROCK_TUNNEL_1
	jr z, .asm_fc645
	ld a, [wCurMap]
	ld hl, Pointer_fc64b
	call Func_1568 ; similar to IsInArray, but not the same
	jr c, .asm_fc639
	ld a, [wCurMap]
	ld hl, Pointer_fc653
	call Func_1568
	jr nc, .asm_fc641
	ld a, [wSpriteStateData1 + $9]
	and a
	jr nz, .asm_fc641
	ld a, $3
	jr .asm_fc647
	
.asm_fc62d
	ld a, [wSpriteStateData1 + $9]
	and a
	jr z, .asm_fc645
	jr .asm_fc641
.asm_fc635
	ld a, $3
	jr .asm_fc647
.asm_fc639
	ld a, $4
	jr .asm_fc647
.asm_fc63d
	ld a, $6
	jr .asm_fc647
.asm_fc641
	ld a, $1
	jr .asm_fc647
.asm_fc645
	ld a, $3
.asm_fc647
	ld [wd431], a
	ret

Pointer_fc64b:: ; fc64b (3f:464b)
	db $c2, $4c, $4f, $ba, $be, $b8, $54, $ff
	
Pointer_fc653:: ; fc653 (3f:4653)
	db $2f, $e6, $3e, $5e, $80, $31, $a4, $ff

Func_fc65b:: ; fc65b (3f:465b)
	ld a, [wCurMap]
	cp VIRIDIAN_FOREST_EXIT
	jr z, .asm_fc673
	cp VIRIDIAN_FOREST_ENTRANCE
	jr z, .asm_fc67c
	ld a, [wCurMap]
	ld hl, Pointer_fc68e
	call Func_1568
	jr c, .asm_fc688
	jr .asm_fc684
.asm_fc673
	ld a, [wSpriteStateData1 + $9]
	cp SPRITE_FACING_UP
	jr z, .asm_fc688
	jr .asm_fc684
.asm_fc67c
	ld a, [wSpriteStateData1 + $9]
	and a ; SPRITE_FACING_DOWN
	jr z, .asm_fc684
	jr .asm_fc688
.asm_fc684
	ld a, $0
	jr .asm_fc68a
.asm_fc688
	ld a, $1
.asm_fc68a
	ld [wd431], a
	ret
	
Pointer_fc68e:: ; fc68e (3f:468e)
	db $33, $dd, $df, $e0, $e1, $de, $ec, $7f, $a8, $a9, $aa, $ff
	
Func_fc69a:: ; fc69a (3f:469a)
	ld a, [wCurMap]
	cp ROUTE_22_GATE
	jr z, .asm_fc6a7
	cp ROUTE_2_GATE
	jr z, .asm_fc6b0
	jr .asm_fc6bd
.asm_fc6a7
	ld a, [wSpriteStateData1 + $9]
	cp SPRITE_FACING_UP
	jr z, .asm_fc6b9
	jr .asm_fc6bd
.asm_fc6b0
	ld a, [wSpriteStateData1 + $9]
	cp SPRITE_FACING_UP
	jr z, .asm_fc6b9
	jr .asm_fc6bd
.asm_fc6b9
	ld a, $1
	jr .asm_fc6c1
.asm_fc6bd
	ld a, $3
	jr .asm_fc6c1
.asm_fc6c1
	ld [wd431], a
	ret

Func_fc6c5:: ; fc6c5 (3f:46c5)
	push hl
	ld hl, wd430
	set 2, [hl]
	pop hl
	ret

Func_fc6cd:: ; fc6cd (3f:46cd)
	push hl
	ld hl, wd430
	res 2, [hl]
	pop hl
	ret

Func_fc6d5:: ; fc6d5 (3f:46d5)
	call Func_fc6cd
	call Func_fc727
	ret nc
	push bc
	call Func_fcd25
	pop bc
	ret c
	ld bc, wSpriteStateData1 + $f0
	ld hl, $1
	add hl, bc
	bit 7, [hl]
	jp nz, asm_fc745
	ld a, [wFontLoaded]
	bit 0, a
	jp nz, asm_fc76a
	call Func_154a
	jp nz, asm_fc76a
	ld a, [hl]
	and $7f
	cp $a
	jr c, .asm_fc704
	xor a
.asm_fc704
	add a
	ld e, a
	ld d, 0
	ld hl, PointerTable_fc710
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl
	
PointerTable_fc710: ; fc710 (3f:4710)
	dw Func_fc793
	dw Func_fc7aa
	dw Func_fc803
	dw asm_fc9c3
	dw asm_fca1c
	dw asm_fc9ee
	dw asm_fc87f
	dw asm_fc904
	dw asm_fc937
	dw asm_fc969
	dw Func_fc726
	
Func_fc726: ; fc726 (3f:4726)
	ret

Func_fc727: ; fc727 (3f:4727)
	call Func_fc4dd
	jr nc, .asm_fc73b
	ld a, [wSpriteStateData1 + $f1]
	and a
	jr nz, .asm_fc739
	push bc
	push hl
	call Func_fc534
	pop hl
	pop bc
.asm_fc739
	scf
	ret
.asm_fc73b
	ld hl, wSpriteStateData1 + $f2
	ld [hl], $ff
	dec hl
	ld [hl], $0
	xor a
	ret
asm_fc745: ; fc745 (3f:4745)
	ld hl, $1
	add hl, bc
	res 7, [hl]
	ld hl, wSpriteStateData2 - wSpriteStateData1
	add hl, bc
	ld [hl], a
	call Func_154a
	jr nz, .asm_fc75f
	ld a, [wSpriteStateData1 + $9]
	xor $4
	ld hl, $9
	add hl, bc
	ld [hl], a
.asm_fc75f
	xor a
	ld hl, $7
	add hl, bc
	ld [hli], a
	ld [hl], a
	call Func_fca99
	ret
asm_fc76a: ; fc76a (3f:476a)
	xor a
	ld hl, $7
	add hl, bc
	ld [hli], a
	ld [hl], a
	call Func_fca99
	call Func_fc82e
	jr c, .asm_fc783
	push bc
	callab InitializeSpriteScreenPosition
	pop bc
.asm_fc783
	ld hl, $1
	add hl, bc
	ld [hl], $1
	ld hl, wSpriteStateData2 - wSpriteStateData1
	add hl, bc
	ld [hl], $0
	call Func_fcba1
	ret

Func_fc793: ; fc793 (3f:4793)
	call Func_fcba1
	push bc
	callab InitializeSpriteScreenPosition
	pop bc
	ld hl, $2
	add hl, bc
	ld [hl], $ff
	dec hl
	ld [hl], $1
	ret

Func_fc7aa: ; fc7aa (3f:47aa)
	call Func_fcc92
	jp c, Func_fc803
	dec a
	ld l, a
	ld h, $0
	add hl, hl
	add hl, hl
	ld de, Pointer_fc7e3
	add hl, de
	ld d, h
	ld e, l
	ld a, [de]
	inc de
	ld hl, $9
	add hl, bc
	ld [hl], a
	ld a, [de]
	inc de
	ld hl, $5
	add hl, bc
	ld [hl], a
	dec hl
	dec hl
	ld a, [de]
	ld [hl], a
	inc de
	ld a, [de]
	ld hl, $1
	add hl, bc
	ld [hl], a
	cp $4
	jp z, Func_fca0a
	call Func_fcd17
	jp c, Func_fc9df
	jp Func_fc9b4

Pointer_fc7e3: ; fc7e3 (3f:47e3)
	db $0, $0
	db $1, $3
	db $4, $0
	db $ff, $3
	db $8, $ff
	db $0, $3
	db $c, $1
	db $0, $3
	db $0, $0
	db $1, $4
	db $4, $0
	db $ff, $4
	db $8, $ff
	db $0, $4
	db $c, $1
	db $0, $4
	
Func_fc803: ; fc803 (3f:4803)
	call Func_fcae2
	ret c
	ld hl, wSpriteStateData2 - wSpriteStateData1
	add hl, bc
	dec [hl]
	jr nz, .asm_fc823
	push hl
	call Func_fccee
	pop hl
	cp $5
	jr nc, Func_fc842
	ld [hl], $20
	call Random
	and $c
	ld hl, $9
	add hl, bc
	ld [hl], a
.asm_fc823
	xor a
	ld hl, $7
	add hl, bc
	ld [hli], a
	ld [hl], a
	call Func_fca99
	ret

Func_fc82e: ; fc82e (3f:482e)
	ld a, [wWalkCounter]
	and a
	ret z
	scf
	ret

Func_fc835: ; fc835 (3f:4835)
	ld hl, wSpriteStateData2 - wSpriteStateData1
	add hl, bc
	ld [hl], $10
	ld hl, $1
	add hl, bc
	ld [hl], $1
	ret
	
Func_fc842: ; fc842 (3f:4842)
	ld hl, $0
	push af
	call Random
	ld a, [hRandomAdd]
	and %11
	ld e, a
	ld d, $0
	ld hl, PointerTable_fc85a
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	jp hl
	
PointerTable_fc85a: ; fc85a (3f:485a)
	dw Func_fc862
	dw Func_fc8f8
	dw Func_fc92b
	dw Func_fc95d
	
Func_fc862: ; fc862 (3f:4862)
	dec a
	add a
	add a
	and $c
	ld hl, $9
	add hl, bc
	ld [hl], a
	ld hl, $1
	add hl, bc
	ld [hl], $6
	xor a
	ld [wd432], a
	ld [wd433], a
	ld hl, wSpriteStateData2 - wSpriteStateData1
	add hl, bc
	ld [hl], $11
asm_fc87f: ; fc87f (3f:487f)
	ld a, [wd432]
	ld e, a
	ld a, [wd433]
	ld d, a
	call Func_fc82e
	jr c, Func_fc8c7
	call Func_fc6c5
	ld hl, $4
	add hl, bc
	ld a, [hl]
	sub e
	ld e, a
	inc hl
	inc hl
	ld a, [hl]
	sub d
	ld d, a
	ld hl, wSpriteStateData2 - wSpriteStateData1
	add hl, bc
	ld a, [hl]
	dec a
	add a
	add $d6
	ld l, a
	ld a, $48
	adc $0
	ld h, a
	ld a, [hli]
	ld [wd432], a
	add e
	ld e, a
	ld a, [hl]
	ld [wd433], a
	add d
	ld d, a
	ld hl, $4
	add hl, bc
	ld [hl], e
	inc hl
	inc hl
	ld [hl], d
	ld hl, wSpriteStateData2 - wSpriteStateData1
	add hl, bc
	dec [hl]
	ret nz
	jp Func_fc835
	
Func_fc8c7: ; fc8c7 (3f:48c7)
	ld hl, $4
	add hl, bc
	ld a, [hl]
	sub e
	ld [hl], a
	inc hl
	inc hl
	ld a, [hl]
	sub d
	ld [hl], a
	jp Func_fc835

Pointer_fc8d6: ; fc8d6 (3f:48d6)
	db $0, $0, $fe, $1, $fc
	db $2, $fe, $3, $0, $4
	db $fe, $3, $fc, $2, $fe
	db $1, $0, $0, $fe, $ff
	db $fc, $fe, $fe, $fd, $0
	db $fc, $fe, $fd, $fc, $fe
	db $fe, $ff, $00, $00
	
Func_fc8f8: ; fc8f8 (3f:48f8)
	ld hl, $1
	add hl, bc
	ld [hl], $7
	ld hl, wSpriteStateData2 - wSpriteStateData1
	add hl, bc
	ld [hl], $30
asm_fc904: ; fc904 (3f:4904)
	call Func_fc82e
	jp c, Func_fc835
	call Func_fc6c5
	ld hl, $7
	add hl, bc
	ld a, [hl]
	inc a
	cp $8
	ld [hl], a
	jr nz, .asm_fc91f
	xor a
	ld [hli], a
	ld a, [hl]
	inc a
	and %11
	ld [hl], a
.asm_fc91f
	call Func_fca99
	ld hl, wSpriteStateData2 - wSpriteStateData1
	add hl, bc
	dec [hl]
	ret nz
	jp Func_fc835
	
Func_fc92b: ; fc92b (3f:492b)
	ld hl, wSpriteStateData2 - wSpriteStateData1
	add hl, bc
	ld [hl], $20
	ld hl, $1
	add hl, bc
	ld [hl], $8
asm_fc937: ; fc937 (3f:4937)
	call Func_fc82e
	jp c, Func_fc835
	call Func_fc6c5
	ld hl, $7
	add hl, bc
	ld a, [hl]
	inc a
	cp $8
	ld [hl], a
	jr nz, .asm_fc951
	xor a
	ld [hli], a
	ld a, [hl]
	xor $1
	ld [hl], a
.asm_fc951
	call Func_fca99
	ld hl, wSpriteStateData2 - wSpriteStateData1
	add hl, bc
	dec [hl]
	ret nz
	jp Func_fc835
	
Func_fc95d: ; fc95d (3f:495d)
	ld hl, wSpriteStateData2 - wSpriteStateData1
	add hl, bc
	ld [hl], $20
	ld hl, $1
	add hl, bc
	ld [hl], $9
asm_fc969: ; fc969 (3f:4969)
	call Func_fc82e
	jp c, Func_fc835
	call Func_fc6c5
	ld hl, $7
	add hl, bc
	ld a, [hl]
	inc a
	cp $8
	ld [hl], a
	jr nz, .asm_fc988
	xor a
	ld [hl], a
	ld hl, $9
	add hl, bc
	ld a, [hl]
	call Func_fc994
	ld [hl], a
.asm_fc988
	call Func_fca99
	ld hl, wSpriteStateData2 - wSpriteStateData1
	add hl, bc
	dec [hl]
	ret nz
	jp Func_fc835
	
Func_fc994: ; fc994 (3f:4994)
	push hl
	ld hl, Pointer_fc9ac
	ld d, a
.loop
	ld a, [hli]
	cp d
	jr nz, .loop
	ld a, [hl]
	pop hl
	ret
	
Func_fc9a0: ; fc9a0 (3f:49a0)
	push hl
	ld hl, Pointer_fc9ac_End
	ld d, a
.loop
	ld a, [hld]
	cp d
	jr nz, .loop
	ld a, [hl]
	pop hl
	ret
	
Pointer_fc9ac: ; fc9ac (3f:49ac)
	db SPRITE_FACING_DOWN, SPRITE_FACING_LEFT, SPRITE_FACING_UP, SPRITE_FACING_RIGHT
	db SPRITE_FACING_DOWN, SPRITE_FACING_LEFT, SPRITE_FACING_UP, SPRITE_FACING_RIGHT
Pointer_fc9ac_End:
Func_fc9b4: ; fc9b4 (3f:49b4)
	ld hl, wSpriteStateData2 - wSpriteStateData1
	add hl, bc
	ld [hl], $8
	ld hl, $1
	add hl, bc
	ld [hl], $3
	call Func_fca38
asm_fc9c3: ; fc9c3 (3f:49c3)
	call Func_fca4b
	call Func_fca7e
	call Func_fca99
	ld hl, $100
	add hl, bc
	dec [hl]
	ret nz
	call Func_fca75
	call Func_fccb2
	ld hl, $1
	add hl, bc
	ld [hl], $1
	ret
	
Func_fc9df: ; fc9df (3f:49df)
	ld hl, wSpriteStateData2 - wSpriteStateData1
	add hl, bc
	ld [hl], $4
	ld hl, $1
	add hl, bc
	ld [hl], $5
	call Func_fca38
asm_fc9ee: ; fc9ee (3f:49ee)
	call asm_fca59
	call Func_fca7e
	call Func_fca99
	ld hl, wSpriteStateData2 - wSpriteStateData1
	add hl, bc
	dec [hl]
	ret nz
	call Func_fca75
	call Func_fccb2
	ld hl, $1
	add hl, bc
	ld [hl], $1
	ret
	
Func_fca0a: ; fca0a (3f:4a0a)
	ld hl, wSpriteStateData2 - wSpriteStateData1
	add hl, bc
	ld [hl], $8
	ld hl, $1
	add hl, bc
	ld [hl], $4
	call Func_fca38
	call Func_fca38
asm_fca1c: ; fca1c (3f:4a1c)
	call asm_fca59
	call Func_fca7e
	call Func_fca99
	ld hl, wSpriteStateData2 - wSpriteStateData1
	add hl, bc
	dec [hl]
	ret nz
	call Func_fca75
	call Func_fccb2
	ld hl, $1
	add hl, bc
	ld [hl], $1
	ret
	
Func_fca38: ; fca38 (3f:4a38)
	ld hl, $3
	add hl, bc
	ld e, [hl]
	inc hl
	inc hl
	ld d, [hl]
	ld hl, $104
	add hl, bc
	ld a, [hl]
	add e
	ld [hli], a
	ld a, [hl]
	add d
	ld [hl], a
	ret
	
Func_fca4b: ; fca4b (3f:4a4b)
	ld a, [wWalkBikeSurfState]
	cp $1
	jr nz, Func_fca68
	ld a, [wd736]
	bit 6, a
	jr nz, Func_fca68
asm_fca59: ; fca59 (3f:4a59)
	ld hl, $3
	add hl, bc
	ld a, [hli]
	add a
	add a
	add [hl]
	ld [hli], a
	ld a, [hli]
	add a
	add a
	add [hl]
	ld [hl], a
	ret
	
Func_fca68: ; fca68 (3f:4a68)
	ld hl, $3
	add hl, bc
	ld a, [hli]
	add a
	add [hl]
	ld [hli], a
	ld a, [hli]
	add a
	add [hl]
	ld [hli], a
	ret
	
Func_fca75: ; fca75 (3f:4a75)
	ld hl, $3
	add hl, bc
	xor a
	ld [hli], a
	inc hl
	ld [hl], a
	ret
	
Func_fca7e: ; fca7e (3f:4a7e)
	call Func_fcdad
	ld d, $2
	jr nc, .asm_fca87
	ld d, $5
.asm_fca87
	ld hl, $7
	add hl, bc
	ld a, [hl]
	inc a
	cp d
	jr nz, .asm_fca91
	xor a
.asm_fca91
	ld [hli], a
	ret nz
	ld a, [hl]
	inc a
	and $3
	ld [hl], a
	ret
	
Func_fca99: ; fca99 (3f:4a99)
	ld a, [wd430]
	bit 3, a
	jr nz, .asm_fcad1
	ld hl, $10e
	add hl, bc
	ld a, [hl]
	dec a
	swap a
	ld d, a
	ld a, [wd736]
	bit 7, a
	jr nz, .asm_fcad8
	ld hl, $9
	add hl, bc
	ld a, [hl]
	or d
	ld d, a
	ld a, [wFontLoaded]
	bit 0, a
	jr z, .asm_fcac4
	call Func_fcae2
	ret c
	jr .asm_fcacb
.asm_fcac4
	ld hl, $8
	add hl, bc
	ld a, d
	or [hl]
	ld d, a
.asm_fcacb
	ld hl, $2
	add hl, bc
	ld [hl], d
	ret
.asm_fcad1
	ld hl, $2
	add hl, bc
	ld [hl], $ff
	ret
.asm_fcad8
	ld a, [wSpriteStateData1 + $2]
	and $f
	or d
	ld [wSpriteStateData1 + $f2], a
	ret
	
Func_fcae2: ; fcae2 (3f:4ae2)
	ld hl, $104
	add hl, bc
	ld a, [wYCoord]
	add $4
	cp [hl]
	jr nz, .asm_fcaff
	inc hl
	ld a, [wXCoord]
	add $4
	cp [hl]
	jr nz, .asm_fcaff
	ld hl, $2
	add hl, bc
	ld [hl], $ff
	scf
	ret
.asm_fcaff
	and a
	ret

Func_fcb01: ; fcb01 (3f:4b01)
	push bc
	push de
	push hl
	ld bc, wSpriteStateData1 + $f0
	ld a, [wXCoord]
	add $4
	ld d, a
	ld a, [wYCoord]
	add $4
	ld e, a
	ld hl, $104
	add hl, bc
	ld a, [hl]
	sub e
	and a
	jr z, .asm_fcb30
	cp $ff
	jr z, .asm_fcb26
	cp $1
	jr z, .asm_fcb26
	jr .asm_fcb48
.asm_fcb26
	ld hl, $105
	add hl, bc
	ld a, [hl]
	sub d
	jr z, .asm_fcb43
	jr .asm_fcb48
.asm_fcb30
	ld hl, $105
	add hl, bc
	ld a, [hl]
	sub d
	cp $ff
	jr z, .asm_fcb43
	cp $1
	jr z, .asm_fcb43
	and a
	jr z, .asm_fcb43
	jr .asm_fcb48
.asm_fcb43
	pop hl
	pop de
	pop bc
	scf
	ret
.asm_fcb48
	pop hl
	pop de
	pop bc
	xor a
	ret

Func_fcb4d: ; fcb4d (3f:4b4d)
	call Func_fcb52
	ld e, a
	ret
	
Func_fcb52: ; fcb52 (3f:4b52)
	ld bc, wSpriteStateData1 + $f0
	ld a, [wXCoord]
	add $4
	ld d, a
	ld a, [wYCoord]
	add $4
	ld e, a
	ld hl, $104
	add hl, bc
	ld a, [hl]
	cp e
	jr z, Func_fcb71
	jr nc, .asm_fcb6e
	ld a, $4
	ret
.asm_fcb6e
	ld a, $0
	ret
	
Func_fcb71: ; fcb71 (3f:4b71)
	ld hl, $105
	add hl, bc
	ld a, [hl]
	cp d
	jr z, .asm_fcb81
	jr nc, .asm_fcb7e
	ld a, $8
	ret
.asm_fcb7e
	ld a, $c
	ret
.asm_fcb81
	ld a, $ff
	ret

Func_fcb84: ; fcb84 (3f:4b84)
	push bc
	ld hl, wd437
	ld [hl], $ff
	inc hl
	ld bc, $10
	xor a
	call FillMemory
	pop bc
	ret
	
Func_fcb94: ; fcb94 (3f:4b94)
	ld hl, wd437
	inc [hl]
	ld e, [hl]
	ld d, 0
	ld hl, wd438
	add hl, de
	ld [hl], a
	ret
	
Func_fcba1: ; fcba1 (3f:4ba1)
	call Func_fcb84
	call Func_fcbac
	ret c
	call Func_fcb94
	ret
	
Func_fcbac: ; fcbac (3f:4bac)
	ld bc, wSpriteStateData1 + $f0
	ld hl, $104
	add hl, bc
	ld a, [wYCoord]
	add $4
	sub [hl]
	jr z, .asm_fcbd7
	jr c, .asm_fcbca
	call Func_fcc01
	jr c, .asm_fcbc6
	ld a, $5
	and a
	ret
.asm_fcbc6
	ld a, $1
	and a
	ret
.asm_fcbca
	call Func_fcc01
	jr c, .asm_fcbd3
	ld a, $6
	and a
	ret
.asm_fcbd3
	ld a, $2
	and a
	ret
.asm_fcbd7
	ld hl, $105
	add hl, bc
	ld a, [wXCoord]
	add $4
	sub [hl]
	jr z, .asm_fcbff
	jr c, .asm_fcbf2
	call Func_fcc01
	jr c, .asm_fcbee
	ld a, $8
	and a
	ret
.asm_fcbee
	ld a, $4
	and a
	ret
.asm_fcbf2
	call Func_fcc01
	jr c, .asm_fcbfb
	ld a, $7
	and a
	ret
.asm_fcbfb
	ld a, $3
	and a
	ret
.asm_fcbff
	scf
	ret
	
Func_fcc01: ; fcc01 (3f:4c01)
	jr nc, .asm_fcc05
	cpl
	inc a
.asm_fcc05
	cp $2
	ret
	
Func_fcc08:: ; fcc08 (3f:4c08)
	call Func_fcc23
	ret nc
	ld a, [wd736]
	bit 6, a
	jr nz, .asm_fcc1b
	call Func_fcc42
	ret c
	call Func_fcb94
	ret
.asm_fcc1b
	call Func_fcc64
	ret c
	call Func_fcb94
	ret
	
Func_fcc23: ; fcc23 (3f:4c28)
	ld a, [wd430]
	bit 5, a
	jr nz, .asm_fcc40
	ld a, [wd430]
	bit 7, a
	jr nz, .asm_fcc40
	ld a, [wd472]
	bit 7, a
	jr z, .asm_fcc40
	ld a, [wWalkBikeSurfState]
	and a
	jr nz, .asm_fcc40
	scf
	ret
.asm_fcc40
	and a
	ret
	
Func_fcc42: ; fcc42 (3f:4c42)
	xor a
	ld a, [wPlayerDirection]
	bit 3, a
	jr nz, .asm_fcc58
	bit 2, a
	jr nz, .asm_fcc5b
	bit 1, a
	jr nz, .asm_fcc5e
	bit 0, a
	jr nz, .asm_fcc61
	scf
	ret
.asm_fcc58
	ld a, $2
	ret
.asm_fcc5b
	ld a, $1
	ret
.asm_fcc5e
	ld a, $3
	ret
.asm_fcc61
	ld a, $4
	ret
	
Func_fcc64: ; fcc64 (3f:4c64)
	ld hl, wd430
	bit 6, [hl]
	jr z, .asm_fcc6e
	res 6, [hl]
	ret
.asm_fcc6e
	set 6, [hl]
	xor a
	ld a, [wPlayerDirection]
	bit 3, a
	jr nz, .asm_fcc86
	bit 2, a
	jr nz, .asm_fcc89
	bit 1, a
	jr nz, .asm_fcc8c
	bit 0, a
	jr nz, .asm_fcc8f
	scf
	ret
.asm_fcc86
	ld a, $6
	ret
.asm_fcc89
	ld a, $5
	ret
.asm_fcc8c
	ld a, $7
	ret
.asm_fcc8f
	ld a, $8
	ret

Func_fcc92: ; fcc92 (3f:4c92)
	ld hl, wd437
	ld a, [hl]
	cp $ff
	jr z, .asm_fccb0
	and a
	jr z, .asm_fccb0
	dec [hl]
	ld e, a
	ld d, 0
	ld hl, wd438
	add hl, de
	inc e
	ld a, $ff
.asm_fcca8
	ld d, [hl]
	ldd [hl], a
	ld a, d
	dec e
	jr nz, .asm_fcca8
	and a
	ret
.asm_fccb0
	scf
	ret

Func_fccb2:: ; fccb2 (3f:4cb2)
	call Func_fcd01
	and a
	jr z, .asm_fccbf
	dec a
	and $3
	add a
	add a
	jr .asm_fccea
.asm_fccbf
	ld a, [wYCoord]
	add $4
	ld d, a
	ld a, [wXCoord]
	add $4
	ld e, a
	ld a, [wSpriteStateData2 + $f4]
	cp d
	jr z, .asm_fccd9
	ld a, SPRITE_FACING_DOWN
	jr c, .asm_fccea
	ld a, SPRITE_FACING_UP
	jr .asm_fccea
.asm_fccd9
	ld a, [wSpriteStateData2 + $f5]
	cp e
	jr z, .asm_fcce7
	ld a, SPRITE_FACING_RIGHT
	jr c, .asm_fccea
	ld a, SPRITE_FACING_LEFT
	jr .asm_fccea
.asm_fcce7
	ld a, [wSpriteStateData1 + $9]
.asm_fccea
	ld [wSpriteStateData1 + $f9], a
	ret
	
Func_fccee: ; fccee (3f:4cee)
	ld hl, wd437
	ld a, [hl]
	cp $ff
	jr z, .asm_fccff
	ld e, a
	ld d, 0
	ld hl, wd438
	add hl, de
	ld a, [hl]
	ret
.asm_fccff
	xor a
	ret
	
Func_fcd01: ; fcd01 (3f:4d01)
	ld hl, wd437
	ld a, [hl]
	cp $ff
	jr z, .asm_fcd15
	and a
	jr z, .asm_fcd15
	ld e, a
	ld d, 0
	ld hl, wd438
	add hl, de
	ld a, [hl]
	ret
.asm_fcd15
	xor a
	ret
	
Func_fcd17: ; fcd17 (3f:4d17)
	ld a, [wd437]
	cp $ff
	ret z
	cp $2
	jr nc, .asm_fcd23
	and a
	ret
.asm_fcd23
	scf
	ret
	
Func_fcd25: ; fcd25 (3f:4d25)
	ld h, wSpriteStateData2 / $100
	ld a, [H_CURRENTSPRITEOFFSET]
	add $4
	ld l, a
	ld b, [hl]
	ld a, [wYCoord]
	cp b
	jr z, .asm_fcd3a
	jr nc, .asm_fcd63
	add $8
	cp b
	jr c, .asm_fcd63
.asm_fcd3a
	inc l
	ld b, [hl]
	ld a, [wXCoord]
	cp b
	jr z, .asm_fcd49
	jr nc, .asm_fcd63
	add $9
	cp b
	jr c, .asm_fcd63
.asm_fcd49
	call Func_fcd83
	ld d, $60
	ld a, [hli]
	ld e, a
	cp d
	jr nc, .asm_fcd63
	ld a, [hld]
	cp d
	jr nc, .asm_fcd63
	ld bc, -20
	add hl, bc
	ld a, [hli]
	cp d
	jr nc, .asm_fcd63
	ld a, [hl]
	cp d
	jr c, .asm_fcd6f
.asm_fcd63
	ld h, wSpriteStateData1 / $100
	ld a, [H_CURRENTSPRITEOFFSET]
	add $2
	ld l, a
	ld [hl], $ff
	scf
	jr .asm_fcd82
.asm_fcd6f
	ld h, wSpriteStateData2 / $100
	ld a, [H_CURRENTSPRITEOFFSET]
	add $7
	ld l, a
	ld a, [wGrassTile]
	cp e
	ld a, $0
	jr nz, .asm_fcd80
	ld a, $80
.asm_fcd80
	ld [hl], a
	and a
.asm_fcd82
	ret
	
Func_fcd83: ; fcd83 (3f:4d83)
	ld h, wSpriteStateData1 / $100
	ld a, [H_CURRENTSPRITEOFFSET]
	add $4
	ld l, a
	ld a, [hli]
	add $4
	and $f0
	srl a
	ld c, a
	ld b, $0
	inc l
	ld a, [hl]
	add $2
	srl a
	srl a
	srl a
	add SCREEN_WIDTH
	ld d, 0
	ld e, a
	ld hl, wTileMap
	rept 5
	add hl, bc
	endr
	add hl, de
	ret
	
Func_fcdad: ; fcdad (3f:4dad)
	push bc
	push af
	ld a, [wPikachuHappiness]
	cp $50
	pop bc
	ld a, b
	pop bc
	ret

IsStarterPikachuInOurParty:: ; fcdb8 (3f:4db8)
	ld hl, wPartySpecies
	ld de, wPartyMon1OTID
	ld bc, wPartyMonOT
	push hl
.loop
	pop hl
	ld a, [hli]
	push hl
	inc a
	jr z, .noPlayerPikachu
	cp PIKACHU + 1
	jr nz, .curMonNotPlayerPikachu
	ld h, d
	ld l, e
	ld a, [wPlayerID]
	cp [hl]
	jr nz, .curMonNotPlayerPikachu
	inc hl
	ld a, [wPlayerID+1]
	cp [hl]
	jr nz, .curMonNotPlayerPikachu
	push de
	push bc
	ld hl, wPlayerName
	ld d, $6 ; possible player length - 1
.nameCompareLoop
	dec d
	jr z, .sameOT
	ld a, [bc]
	inc bc
	cp [hl]
	inc hl
	jr z, .nameCompareLoop
	pop bc
	pop de
.curMonNotPlayerPikachu
	ld hl, wPartyMon2 - wPartyMon1
	add hl, de
	ld d, h
	ld e, l
	ld hl, NAME_LENGTH
	add hl, bc
	ld b, h
	ld c, l
	jr .loop
.sameOT
	pop bc
	pop de
	ld h, d
	ld l, e
	ld bc, -NAME_LENGTH
	add hl, bc
	ld a, [hli]
	or [hl]
	jr z, .noPlayerPikachu ; XXX how is this determined?
	pop hl
	scf
	ret
.noPlayerPikachu
	pop hl
	and a
	ret

IsThisPartymonStarterPikachu_Box:: ; fce0d (3f:4e0d)
	ld hl, wBoxMon1
	ld bc, wBoxMon2 - wBoxMon1
	ld de, wBoxMonOT
	jr asm_fce21

IsThisPartymonStarterPikachu_Party:: ; fce18 (3f:4e18)
IsThisPartymonStarterPikachu::
	ld hl, wPartyMon1
	ld bc, wPartyMon2 - wPartyMon1
	ld de, wPartyMonOT
asm_fce21: ; fce21 (3f:4e21)
	ld a, [wWhichPokemon]
	call AddNTimes
	ld a, [hl]
	cp PIKACHU
	jr nz, .notPlayerPikachu
	ld bc, wPartyMon1OTID - wPartyMon1
	add hl, bc
	ld a, [wPlayerID]
	cp [hl]
	jr nz, .notPlayerPikachu
	inc hl
	ld a, [wPlayerID+1]
	cp [hl]
	jr nz, .notPlayerPikachu
	ld h, d
	ld l, e
	ld a, [wWhichPokemon]
	ld bc, NAME_LENGTH
	call AddNTimes
	ld de, wPlayerName
	ld b, $6
.loop
	dec b
	jr z, .isPlayerPikachu
	ld a, [de]
	inc de
	cp [hl]
	inc hl
	jr z, .loop
.notPlayerPikachu
	and a
	ret
.isPlayerPikachu
	scf
	ret
	
Func_fce5a:: ; fce5a (3f:4e5a)
	push de
	call IsStarterPikachuInOurParty
	pop de
	ret nc
	ld a, d
	cp $80
	ld a, [wPikachuMood]
	jr c, .asm_fce6c
	cp d
	jr c, .asm_fce6e
	ret
.asm_fce6c
	cp d
	ret c
.asm_fce6e
	ld a, d
	ld [wPikachuMood], a
	ret

Func_fce73:: ; fce73 (3f:4e73)
; function to test if a pokemon is alive?
	xor a
	ld [wWhichPokemon], a
	ld hl, wPartyCount
.loop
	inc hl
	ld a, [hl]
	cp $ff
	jr z, .asm_fcea9
	push hl
	call IsThisPartymonStarterPikachu_Party
	pop hl
	jr nc, .asm_fce9e
	ld a, [wWhichPokemon]
	ld hl, wPartyMon1HP
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld a, [hli]
	or [hl]
	ld d, a
	inc hl
	inc hl
	ld a, [hl]
	and a
	jr nz, .asm_fcea7
	jr .asm_fcea9
.asm_fce9e
	ld a, [wWhichPokemon]
	inc a
	ld [wWhichPokemon], a
	jr .loop
.asm_fcea7
	scf
	ret
.asm_fcea9
	and a
	ret

Func_fceab:: ; fceab (3f:4eab)
	ld hl, wPartySpecies
	ld de, wPartyMon1Moves
	ld bc, wPartyMonOT
	push hl
.loop
	pop hl
	ld a, [hli]
	push hl
	inc a
	jr z, .noSurfingPlayerPikachu
	cp PIKACHU+1
	jr nz, .curMonNotSurfingPlayerPikachu
	ld h, d
	ld l, e
	push hl
	push bc
	ld b, NUM_MOVES
.moveSearchLoop
	ld a, [hli]
	cp SURF
	jr z, .foundSurfingPikachu
	dec b
	jr nz, .moveSearchLoop
	pop bc
	pop hl
	jr .curMonNotSurfingPlayerPikachu
.foundSurfingPikachu
	pop bc
	pop hl
	inc hl
	inc hl
	inc hl
	inc hl
	ld a, [wPlayerID]
	cp [hl]
	jr nz, .curMonNotSurfingPlayerPikachu
	inc hl
	ld a, [wPlayerID+1]
	cp [hl]
	jr nz, .curMonNotSurfingPlayerPikachu
	push de
	push bc
	ld hl, wPlayerName
	ld d, $6
.nameCompareLoop
	dec d
	jr z, .foundSurfingPlayerPikachu
	ld a, [bc]
	inc bc
	cp [hl]
	inc hl
	jr z, .nameCompareLoop
	pop bc
	pop de
.curMonNotSurfingPlayerPikachu
	ld hl, wPartyMon2 - wPartyMon1
	add hl, de
	ld d, h
	ld e, l
	ld hl, NAME_LENGTH
	add hl, bc
	ld b, h
	ld c, l
	jr .loop
.foundSurfingPlayerPikachu
	pop bc
	pop de
	pop hl
	scf
	ret
.noSurfingPlayerPikachu
	pop hl
	and a
	ret

IsPlayerTalkingToPikachu:: ; fcf0c (3f:4f0c)
	ld a, [wd436]
	and a
	ret z
	ld a, [hSpriteIndexOrTextID]
	cp $f
	ret nz
	call InitializePikachuTextID
	xor a
	ld [hSpriteIndexOrTextID], a
	ld [wd436], a
	ret
	
InitializePikachuTextID: ; fcf20 (3f:4f20)
	ld a, $d4 ; display 
	ld [hSpriteIndexOrTextID], a
	xor a
	ld [wPlayerMovingDirection], a
	ld a, $1
	ld [wAutoTextBoxDrawingControl], a
	call DisplayTextID
	xor a
	ld [wAutoTextBoxDrawingControl], a
	ret

DoStarterPikachuEmotions: ; fcf35 (3f:4f35)
	ld e, a
	ld d, $0
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
.loop
	ld a, [de]
	inc de
	cp $ff
	jr z, .done
	ld c, a
	ld b, $0
	ld hl, Jumptable_fcf54
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call JumpToAddress
	jr .loop
.done
	ret
	
Jumptable_fcf54: ; fcf54 (3f:4f54)
	dw Func_fcf6a
	dw Func_fcf6b
	dw Func_fcf77
	dw Func_fcf8d
	dw Func_fcfb0
	dw Func_fd9d0
	dw Func_fcfc7
	dw Func_fcfbe
	dw Func_fcfe8
	dw Func_fcfe9
	dw Func_fcf6a
	
Func_fcf6a: ; fcf6a (3f:4f6a)
	ret

Func_fcf6b: ; fcf6b (3f:4f6b)
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	ld h, a
	inc de
	push de
	call PrintText
	pop de
	ret
	
Func_fcf77: ; fcf77 (3f:4f77)
	ld a, [de]
	inc de
	push de
	ld e, a
	nop
	call Func_fcf81
	pop de
	ret

Func_fcf81: ; fcf81 (3f:4f81)
	cp $ff
	ret z
	callab PlayPikachuSoundClip
	ret
	
Func_fcf8d: ; fcf8d (3f:4f8d)
	ld a, [wUpdateSpritesEnabled]
	push af
	ld a, $ff
	ld [wUpdateSpritesEnabled], a
	ld a, [de]
	inc de
	push de
	call Func_fcfa2
	pop de
	pop af
	ld [wUpdateSpritesEnabled], a
	ret
	
Func_fcfa2: ; fcfa2 (3f:4fa2)
	ld [wWhichEmotionBubble], a
	ld a, $f
	ld [wEmotionBubbleSpriteIndex], a
	predef EmotionBubble
	ret
	
Func_fcfb0: ; fcfb0 (3f:4fb0)
	ld a, [de]
	inc de
	ld l, a
	ld a, [de]
	inc de
	ld h, a
	push de
	ld b, $3f
	call Func_fd2a1
	pop de
	ret
	
Func_fcfbe: ; fcfbe (3f:4fbe)
	ld a, [de]
	inc de
	push de
	ld c, a
	call DelayFrames
	pop de
	ret
	
Func_fcfc7: ; fcfc7 (3f:4fc7)
	ld a, [de]
	inc de
	push de
	ld e, a
	ld d, $0
	ld hl, Jumptable_fcfda
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call JumpToAddress
	pop de
	ret

Jumptable_fcfda:
	dw Func_fd8ab
	dw LoadFontTilePatterns
	dw Func_fd8f8
	dw WaitForTextScrollButtonPress
	dw Func_fd8d4
	dw Func_fd8e1
	dw Func_fd8ee
	
Func_fcfe8: ; fcfe8 (3f:4fe8)
	ret
	
Func_fcfe9: ; fcfe9 (3f:4fe9)
	push de
	call Func_fcff2
	call UpdateSprites
	pop de
	ret

Func_fcff2: ; fcff2 (3f:4ff2)
	ld a, [wSpriteStateData1 + $9]
	xor $4
	ld [wSpriteStateData1 + $f9], a
	ret
	
Func_fcffb: ; fcffb (3f:4ffb)
; Inexplicably empty.
	rept 5
	nop
	endr
	ret

Func_fd001:: ; fd001 (3f:5001)
	ld a, e
	jr asm_fd00f
	
Func_fd004:: ; fd004 (3f:5004)
	call Func_fd05e
	jr c, asm_fd00f
	call Func_fd978
	call Func_fcffb
asm_fd00f: ; fd00f (3f:500f)
	ld [wExpressionNumber], a
	ld hl, PikachuEmotionTable
	call DoStarterPikachuEmotions
	ret
	
PikachuEmotionTable: ; fd019 (3f:4019)
	dw PikachuEmotion0_fd115
	dw PikachuEmotion1_fd141
	dw PikachuEmotion2_fd116
	dw PikachuEmotion3_fd160
	dw PikachuEmotion4_fd136
	dw PikachuEmotion5_fd14d
	dw PikachuEmotion6_fd153
	dw PikachuEmotion7_fd128
	dw PikachuEmotion8_fd147
	dw PikachuEmotion9_fd166
	dw PikachuEmotion10_fd11e
	dw PikachuEmotion11_fd173
	dw PikachuEmotion12_fd17a
	dw PikachuEmotion13_fd180
	dw PikachuEmotion14_fd189
	dw PikachuEmotion15_fd191
	dw PikachuEmotion16_fd197
	dw PikachuEmotion17_fd19d
	dw PikachuEmotion18_fd1a3
	dw PikachuEmotion19_fd1a9
	dw PikachuEmotion20_fd1b1
	dw PikachuEmotion21_fd1b9
	dw PikachuEmotion22_fd1c1
	dw PikachuEmotion23_fd1c7
	dw PikachuEmotion24_fd1cf
	dw PikachuEmotion25_fd1d7
	dw PikachuEmotion26_fd1df
	dw PikachuEmotion27_fd1eb
	dw PikachuEmotion28_fd1f1
	dw PikachuEmotion29_fd1f7
	dw PikachuEmotion30_fd1fc
	dw PikachuEmotion31_fd20a
	dw PikachuEmotion32_fd213
	dw PikachuEmotion33_fd05d
	
PikachuEmotion33_fd05d: ; fd05d (3f:505d)
	db $ff
	
Func_fd05e: ; fd05e (3f:505e)
	ld a, [wCurMap]
	cp POKEMON_FAN_CLUB
	jr nz, .notFanClub
	ld hl, wPreventBlackout
	bit 7, [hl]
	ld a, $1d
	jr z, .asm_fd0c9
	call Func_154a
	ld a, $1e
	jr nz, .asm_fd0c9
	jr .asm_fd096
.notFanClub
	ld a, [wCurMap]
	cp PEWTER_POKECENTER
	jr nz, .notPewterPokecenter
	call Func_154a
	ld a, $1a
	jr nz, .asm_fd0c9
	jr .asm_fd096
.notPewterPokecenter
	callab Func_f24ae
	ld a, e
	cp $ff
	jr nz, .asm_fd0c9
	jr .asm_fd096
.asm_fd096
	call IsPlayerPikachuAsleepInParty
	ld a, $b
	jr c, .asm_fd0c9
	callab Func_fce73 ; same bank
	ld a, $1c
	jr c, .asm_fd0c9
	ld a, [wCurMap]
	cp POKEMONTOWER_1
	jr c, .notInLavenderTower
	cp POKEMONTOWER_7 + 1
	ld a, $16
	jr c, .asm_fd0c9
.notInLavenderTower
	ld a, [wd49c]
	and a
	jr z, .asm_fd0c7
	dec a
	ld c, a
	ld b, $0
	ld hl, Pointer_fd0cb
	add hl, bc
	ld a, [hl]
	jr .asm_fd0c9
.asm_fd0c7
	and a
	ret
.asm_fd0c9
	scf
	ret
	
Pointer_fd0cb:
	db $12, $15, $17, $18, $19
	
IsPlayerPikachuAsleepInParty:: ; fd0d0 (3f:50d0)
	xor a
	ld [wWhichPokemon], a
.loop
	ld a, [wWhichPokemon]
	ld c, a
	ld b, $0
	ld hl, wPartySpecies
	add hl, bc
	ld a, [hl]
	cp $ff
	jr z, .done
	cp PIKACHU
	jr nz, .curMonNotStarterPikachu
	callab IsThisPartymonStarterPikachu
	jr nc, .curMonNotStarterPikachu
	ld a, [wWhichPokemon]
	ld hl, wPartyMon1Status
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld a, [hl]
	and SLP
	jr z, .done
	jr .curMonSleepingPikachu
.curMonNotStarterPikachu
	ld a, [wWhichPokemon]
	cp PARTY_LENGTH - 1
	jr z, .done
	inc a
	ld [wWhichPokemon], a
	jr .loop
.curMonSleepingPikachu
	scf
	ret
.done
	and a
	ret
	
PikachuEmotion0_fd115: ; fd115 (3f:5115)
	db $ff

PikachuEmotion2_fd116: ; fd116 (3f:5116)
	pikaemotion_dummy2
	pikaemotion_emotebubble SMILE_BUBBLE
	pikaemotion_pcm $22
	pikaemotion_5 $2
	db $ff

PikachuEmotion10_fd11e: ; fd11e (3f:511e)
	pikaemotion_dummy2
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADEXTRAPIKASPRITES
	pikaemotion_emotebubble HEART_BUBBLE
	pikaemotion_pcm $4
	pikaemotion_5 $a
	db $ff

PikachuEmotion7_fd128: ; fd128 (3f:5128)
	pikaemotion_dummy2
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADEXTRAPIKASPRITES
	pikaemotion_4 Pointer_fd224
	pikaemotion_pcm $0
	pikaemotion_4 Pointer_fd224
	pikaemotion_5 $7
	db $ff

PikachuEmotion4_fd136: ; fd136 (3f:5136)
	pikaemotion_dummy2
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADEXTRAPIKASPRITES
	pikaemotion_4 Pointer_fd230
	pikaemotion_pcm $1c
	pikaemotion_5 $4
	db $ff

PikachuEmotion1_fd141: ; fd141 (3f:5141)
	pikaemotion_dummy2
	pikaemotion_pcm $ff
	pikaemotion_5 $1
	db $ff

PikachuEmotion8_fd147: ; fd147 (3f:5147)
	pikaemotion_dummy2
	pikaemotion_pcm $26
	pikaemotion_5 $8
	db $ff

PikachuEmotion5_fd14d: ; fd14d (3f:514d)
	pikaemotion_dummy2
	pikaemotion_pcm $1e
	pikaemotion_5 $5
	db $ff

PikachuEmotion6_fd153: ; fd153 (3f:5153)
	pikaemotion_dummy2
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADEXTRAPIKASPRITES
	pikaemotion_pcm $ff
	pikaemotion_4 Pointer_fd21e
	pikaemotion_emotebubble SKULL_BUBBLE
	pikaemotion_5 $6
	db $ff

PikachuEmotion3_fd160: ; fd160 (3f:5160)
	pikaemotion_dummy2
	pikaemotion_pcm $27
	pikaemotion_5 $3
	db $ff

PikachuEmotion9_fd166: ; fd166 (3f:5166)
	pikaemotion_dummy2
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADEXTRAPIKASPRITES
	pikaemotion_pcm $5
	pikaemotion_4 Pointer_fd218
	pikaemotion_emotebubble SKULL_BUBBLE
	pikaemotion_5 $9
	db $ff

PikachuEmotion11_fd173: ; fd173 (3f:5173)
	pikaemotion_emotebubble ZZZ_BUBBLE
	pikaemotion_pcm $24
	pikaemotion_5 $b
	db $ff

PikachuEmotion12_fd17a: ; fd17a (3f:517a)
	pikaemotion_dummy2
	pikaemotion_pcm $ff
	pikaemotion_5 $c
	db $ff

PikachuEmotion13_fd180: ; fd180 (3f:5180)
	pikaemotion_dummy2
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADEXTRAPIKASPRITES
	pikaemotion_4 Pointer_fd21e
	pikaemotion_5 $d
	db $ff

PikachuEmotion14_fd189: ; fd189 (3f:5189)
	pikaemotion_dummy2
	pikaemotion_emotebubble BOLT_BUBBLE
	pikaemotion_pcm $9
	pikaemotion_5 $e
	db $ff

PikachuEmotion15_fd191: ; fd191 (3f:5191)
	pikaemotion_dummy2
	pikaemotion_pcm $21
	pikaemotion_5 $f
	db $ff

PikachuEmotion16_fd197: ; fd197 (3f:5197)
	pikaemotion_dummy2
	pikaemotion_pcm $20
	pikaemotion_5 $10
	db $ff

PikachuEmotion17_fd19d: ; fd19d (3f:519d)
	pikaemotion_dummy2
	pikaemotion_pcm $c
	pikaemotion_5 $11
	db $ff

PikachuEmotion18_fd1a3: ; fd1a3 (3f:51a3)
	pikaemotion_dummy2
	pikaemotion_pcm $ff
	pikaemotion_5 $12
	db $ff

PikachuEmotion19_fd1a9: ; fd1a9 (3f:51a9)
	pikaemotion_dummy2
	pikaemotion_emotebubble HEART_BUBBLE
	pikaemotion_pcm $20
	pikaemotion_5 $13
	db $ff

PikachuEmotion20_fd1b1: ; fd1b1 (3f:51b1)
	pikaemotion_dummy2
	pikaemotion_emotebubble HEART_BUBBLE
	pikaemotion_pcm $4
	pikaemotion_5 $14
	db $ff

PikachuEmotion21_fd1b9: ; fd1b9 (3f:51b9)
	pikaemotion_dummy2
	pikaemotion_emotebubble FISH_BUBBLE
	pikaemotion_pcm $ff
	pikaemotion_5 $15
	db $ff

PikachuEmotion22_fd1c1: ; fd1c1 (3f:51c1)
	pikaemotion_dummy2
	pikaemotion_pcm $3
	pikaemotion_5 $16
	db $ff

PikachuEmotion23_fd1c7: ; fd1c7 (3f:51c7)
	pikaemotion_dummy2
	pikaemotion_pcm $12
	pikaemotion_5 $17
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_SHOWMAPVIEW
	db $ff

PikachuEmotion24_fd1cf: ; fd1cf (3f:51cf)
	pikaemotion_dummy2
	pikaemotion_emotebubble EXCLAMATION_BUBBLE
	pikaemotion_pcm $ff
	pikaemotion_5 $18
	db $ff

PikachuEmotion25_fd1d7: ; fd1d7 (3f:51d7)
	pikaemotion_dummy2
	pikaemotion_emotebubble BOLT_BUBBLE
	pikaemotion_pcm $22
	pikaemotion_5 $19
	db $ff

PikachuEmotion26_fd1df: ; fd1df (3f:51df)
	pikaemotion_dummy2
	pikaemotion_emotebubble ZZZ_BUBBLE
	pikaemotion_pcm $24
	pikaemotion_5 $1a
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_SHOWMAPVIEW
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_CHECKPEWTERCENTER
	db $ff

PikachuEmotion27_fd1eb: ; fd1eb (3f:51eb)
	pikaemotion_dummy2
	pikaemotion_pcm $8
	pikaemotion_5 $1b
	db $ff

PikachuEmotion28_fd1f1: ; fd1f1 (3f:51f1)
	pikaemotion_dummy2
	pikaemotion_pcm $e
	pikaemotion_5 $1c
	db $ff

PikachuEmotion29_fd1f7: ; fd1f7 (3f:51f7)
	pikaemotion_pcm $4
	pikaemotion_5 $a
	db $ff

PikachuEmotion30_fd1fc: ; fd1fc (3f:51fc)
	pikaemotion_9
	pikaemotion_emotebubble HEART_BUBBLE
	pikaemotion_pcm $4
	pikaemotion_5 $14
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_SHOWMAPVIEW
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADFONT
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_CHECKLAVENDERTOWER
	db $ff

PikachuEmotion31_fd20a: ; fd20a (3f:520a)
	pikaemotion_pcm $12
	pikaemotion_5 $17
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_SHOWMAPVIEW
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_CHECKBILLSHOUSE
	db $ff

PikachuEmotion32_fd213: ; fd213 (3f:5213)
	pikaemotion_pcm $19
	pikaemotion_5 $17
	db $ff

Pointer_fd218: ; fd218 (3f:5218)

	db $00
	db $39, $01
	db $3e, $1e
	db $3f

Pointer_fd21e: ; fd21e (3f:521e)
	db $00
	db $39, $00
	db $3e, $1e
	db $3f

Pointer_fd224: ; fd224 (3f:5224)
	db $00
	db $3c, $07, $2f
	db $3c, $07, $2f
	db $3f

Pointer_fd22c: ; fd22c (3f:522c)
	db $3b, $1f, $03
	db $3f

Pointer_fd230: ; fd230 (3f:5230)
	db $00
	db $3c, $0f, $1f
	db $3c, $0f, $1f
	db $3f

Pointer_fd238: ; fd238 (3f:5238)
	db $00
	db $05, $07
	db $39, $00
	db $05, $07
	db $06, $07
	db $39, $00
	db $06, $07
	db $08, $07
	db $39, $00
	db $08, $07
	db $07, $07
	db $39, $00
	db $07, $07
	db $3f

Func_fd252: ; fd252 (3f:5252)
	ld a, $40
	ld [h_0xFFFC], a
	call Func_fd8ab
	call Func_fd266
	and a
	jr z, .asm_fd262
	call Func_159b
.asm_fd262
	xor a
	ld [h_0xFFFC], a
	ret

Func_fd266:
	ld a, [wSpriteStateData2 + 15 * 16 + 4]
	ld e, a
	ld a, [wSpriteStateData2 + 15 * 16 + 5]
	ld d, a
	ld a, [wYCoord]
	add 4
	cp e
	jr z, .asm_fd280
	jr nc, .asm_fd27e
	ld hl, Data_fd294
	ld a, 1
	ret

.asm_fd27e
	xor a
	ret

.asm_fd280
	ld a, [wXCoord]
	add 4
	cp d
	jr c, .asm_fd28e
	ld hl, Data_fd299
	ld a, 2
	ret

.asm_fd28e
	ld hl, Data_fd29d
	ld a, 3
	ret

Data_fd294:
	db $00
	db $36
	db $2b
	db $34
	db $3f

Data_fd299:
	db $00
	db $36
	db $34
	db $3f

Data_fd29d:
	db $00
	db $36
	db $33
	db $3f

Func_fd2a1:: ; fd2a1 (3f:52a1)
	ld a, b
	ld [wd44a], a
	ld a, l
	ld [wd44b], a
	ld a, h
	ld [wd44b + 1], a
	call Func_fd2c1
.asm_fd2b0
	call Func_fd2f5
	jr nc, .asm_fd2ba
	call Func_fd329
	jr .asm_fd2b0

.asm_fd2ba
	call Func_fd2c1
	call DelayFrame
	ret

Func_fd2c1:
	ld a, [wUpdateSpritesEnabled]
	push af
	ld a, $ff
	ld [wUpdateSpritesEnabled], a
	push hl
	push de
	push bc

	ld hl, wSpriteStateData1
	ld de, wSpriteStateData1 + $f0
	ld c, $10
	call Func_fd2eb

	ld hl, wSpriteStateData2
	ld de, wSpriteStateData2 + $f0
	ld c, $10
	call Func_fd2eb

	pop bc
	pop de
	pop hl
	pop af
	ld [wUpdateSpritesEnabled], a
	ret

Func_fd2eb:
.asm_fd2eb
	ld b, [hl]
	ld a, [de]
	ld [hli], a
	ld a, b
	ld [de], a
	inc de
	dec c
	jr nz, .asm_fd2eb
	ret

Func_fd2f5:
	call Func_157c
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
	ld [$d44e], a
	ld a, [hli]
	cp $80
	jr nz, .asm_fd311
	call Func_157c
.asm_fd311
	ld [$d44d], a
	ld a, [hli]
	ld [$d450], a
	ld a, [hli]
	cp $80
	jr nz, .asm_fd320
	call Func_157c
.asm_fd320
	ld [$d44f], a
	xor a
	ld [$d451], a
	scf
	ret

Func_fd329:
	xor a
	ld [$d44c], a
	ld [$d457], a
	ld [$d458], a
	ld a, [wSpriteStateData2 + 7]
	push af
.asm_fd337
	ld bc, wSpriteStateData1
	ld a, [$d44e]
	ld hl, Jumptable_fd4ac
	call Func_fd365
	ld a, [$d450]
	ld hl, Jumptable_fd65c
	call Func_fd365
	call Func_fd36e
	call Func_fd39d
	call DelayFrame
	call DelayFrame
	ld hl, $d44c
	bit 7, [hl]
	jr z, .asm_fd337
	pop af
	ld [wSpriteStateData2 + 7], a
	scf
	ret

Func_fd365:
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
	ld a, [$d452]
	ld [hl], a
	ld a, [$d454]
	ld d, a
	ld a, [$d456]
	add d
	ld hl, 4
	add hl, bc
	ld [hl], a
	ld a, [$d453]
	ld d, a
	ld a, [$d455]
	add d
	ld hl, 6
	add hl, bc
	ld [hl], a
	ld hl, $d44c
	bit 6, [hl]
	ret z
	ld hl, wSpriteStateData2 + 7 - wSpriteStateData1
	add hl, bc
	ld [hl], 0
	ret

Func_fd39d:
	ld hl, $d44c
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
	db $0b, $27, $02, $00 ; $1d
	db $0c, $27, $02, $00 ; $1e
	db $0d, $27, $02, $00 ; $1f
	db $0e, $27, $02, $00 ; $20
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
	db $13, $0f, $06, $00 ; $35
	db $14, $0f, $06, $00 ; $36
	db $15, $0f, $06, $00 ; $37
	db $16, $0f, $06, $00 ; $38
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
	ld a, [$d44c]
	set 7, a
	ld [$d44c], a
	ret

Func_fd4e5:
	call Func_fd4dc
	ret

Func_fd4e9:
	ld hl, 4
	add hl, bc
	ld a, [hl]
	ld [$d454], a
	ld hl, 6
	add hl, bc
	ld a, [hl]
	ld [$d453], a
	xor a
	ld [$d456], a
	ld [$d455], a
	call Func_fd4dc
	ret

Func_fd504:
	call Func_fd775
	ret nz
	call Func_fd4dc
	ret

Func_fd50c:
	call Func_fd75f
	jr asm_fd58c

Func_fd511:
	call Func_fd75f
	xor %100
	jr asm_fd58c

Func_fd518:
	call Func_fd75f
	ld hl, Data_fd523
	call Func_fd5a0
	jr asm_fd58c

Data_fd523:
	db SPRITE_FACING_DOWN
	db SPRITE_FACING_RIGHT
	db SPRITE_FACING_UP
	db SPRITE_FACING_LEFT
	db SPRITE_FACING_LEFT
	db SPRITE_FACING_DOWN
	db SPRITE_FACING_RIGHT
	db SPRITE_FACING_UP
	db $ff

Func_fd52c:
	call Func_fd75f
	ld hl, Data_fd537
	call Func_fd5a0
	jr asm_fd58c

Data_fd537:
	db SPRITE_FACING_DOWN
	db SPRITE_FACING_LEFT
	db SPRITE_FACING_UP
	db SPRITE_FACING_RIGHT
	db SPRITE_FACING_LEFT
	db SPRITE_FACING_UP
	db SPRITE_FACING_RIGHT
	db SPRITE_FACING_DOWN
	db $ff

Func_fd540:
	call Func_fd75f
	ld hl, Data_fd54b
	call Func_fd5a0
	jr asm_fd58c

Data_fd54b:
	db SPRITE_FACING_DOWN
	db SPRITE_FACING_UP | $10
	db SPRITE_FACING_UP
	db SPRITE_FACING_LEFT | $10
	db SPRITE_FACING_LEFT
	db SPRITE_FACING_DOWN | $10
	db SPRITE_FACING_RIGHT
	db SPRITE_FACING_RIGHT | $10

Func_fd553:
	call Func_fd75f
	ld hl, Data_fd55e
	call Func_fd5a0
	jr asm_fd58c

Data_fd55e:
	db SPRITE_FACING_DOWN
	db SPRITE_FACING_DOWN | $10
	db SPRITE_FACING_UP
	db SPRITE_FACING_RIGHT | $10
	db SPRITE_FACING_LEFT
	db SPRITE_FACING_LEFT | $10
	db SPRITE_FACING_RIGHT
	db SPRITE_FACING_UP | $10

Func_fd566:
	call Func_fd75f
	ld hl, Data_fd571
	call Func_fd5a0
	jr asm_fd58c

Data_fd571:
	db SPRITE_FACING_DOWN
	db SPRITE_FACING_RIGHT | $10
	db SPRITE_FACING_UP
	db SPRITE_FACING_DOWN | $10
	db SPRITE_FACING_LEFT
	db SPRITE_FACING_UP | $10
	db SPRITE_FACING_RIGHT
	db SPRITE_FACING_LEFT | $10

Func_fd579:
	call Func_fd75f
	ld hl, Data_fd584
	call Func_fd5a0
	jr asm_fd58c

Data_fd584:
	db SPRITE_FACING_DOWN
	db SPRITE_FACING_LEFT | $10
	db SPRITE_FACING_UP
	db SPRITE_FACING_UP | $10
	db SPRITE_FACING_LEFT
	db SPRITE_FACING_RIGHT | $10
	db SPRITE_FACING_RIGHT
	db SPRITE_FACING_DOWN | $10

asm_fd58c
	rrca
	rrca
	and $7
	ld e, a
	call Func_fd784
	ld d, a
	call Func_fd601
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
	ld a, 0
	jr asm_fd5d1

Func_fd5b5:
	ld a, 1
	jr asm_fd5d1

Func_fd5b9:
	ld a, 2
	jr asm_fd5d1

Func_fd5bd:
	ld a, 3
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
	call Func_fd769
asm_fd5d5
	call Func_fd784
	ld d, a
	push de
	call Func_fd601
	pop de
	call Func_fd775
	ret nz
	ld a, e
	call Func_fd7cb
	call Func_fd4dc
	ret

Func_fd5ea:
	ld a, 0
	jr asm_fd5fa

Func_fd5ee:
	ld a, 1
	jr asm_fd5fa

Func_fd5f2:
	ld a, 2
	jr asm_fd5fa

Func_fd5f6:
	ld a, 3
	jr asm_fd5fa

asm_fd5fa
	call Func_fd769
	call Func_fd4dc
	ret

Func_fd601:
	dr $fd601, $fd65c

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
	ld hl, $d44c
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
	call Func_fd75f
	or d
	ld [$d452], a
	ret

Func_fd68b:
	ret

Func_fd68c:
	call Func_fd74a
	ld d, a
	call Func_fd755
	or d
	ld [$d452], a
	ret

Func_fd698:
	call Func_fd74a
	ld d, a
	call Func_fd75f
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
	ld [$d452], a
	ret

Func_fd6c0:
	call Func_fd75f
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
	ld [$d452], a
	call Func_fd79d
	ld [$d456], a
	and a
	ret z
	call Func_fd672
	ret

Func_fd6e2:
	call Func_fd75f
	ld d, a
	call Func_fd74a
	or d
	ld [$d452], a
	call Func_fd79d
	ld [$d456], a
	ret

Func_fd6f4:
	ld a, [$d44f]
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
	ld [$d452], a
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
	ld [$d452], a
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

Func_fd75f:
	push hl
	ld hl, 9
	add hl, bc
	ld a, [hl]
	and $c
	pop hl
	ret

Func_fd769:
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
	ld hl, $d457
	inc [hl]
	ld a, [$d44d]
	and $1f
	inc a
	cp [hl]
	ret nz
	ld [hl], 0
	ret

Func_fd784:
	ld a, [$d44d]
	swap a
	rrca
	and $3
	inc a
	ret

Func_fd78e:
	ld hl, $d458
	inc [hl]
	ld a, [$d44f]
	and $f
	inc a
	cp [hl]
	ret nz
	ld [hl], 0
	ret

Func_fd79d:
	call Func_fd7b2
	ld a, [$d458]
	add e
	ld [$d458], a
	add $20
	ld e, a
	push hl
	push bc
	call Func_fd907
	pop bc
	pop hl
	ret

Func_fd7b2:
	ld a, [$d44f]
	and $f
	inc a
	ld d, a
	ld a, [$d44f]
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
	dr $fd7f3, $fd831
Func_fd831:
	dr $fd831, $fd8ab
Func_fd8ab: ; fd8ab (3f:58ab)
	dr $fd8ab, $fd8d4
Func_fd8d4: ; fd8d4 (3f:58d4)
	dr $fd8d4, $fd8e1
Func_fd8e1: ; fd8e1 (3f:58e1)
	dr $fd8e1, $fd8ee
Func_fd8ee: ; fd8ee (3f:58ee)
	dr $fd8ee, $fd8f8
Func_fd8f8: ; fd8f8 (3f:58f8)
	dr $fd8f8, $fd907
Func_fd907:
	dr $fd907, $fd978
Func_fd978: ; fd978 (3f:5978)
	dr $fd978, $fd9d0
Func_fd9d0: ; fd9d0 (3f:59d0)
	dr $fd9d0, $fe66f

OfficerJennySprite:    INCBIN "gfx/sprites/officer_jenny.2bpp"
PikachuSprite:         INCBIN "gfx/sprites/pikachu.2bpp"
SandshrewSprite:       INCBIN "gfx/sprites/sandshrew.2bpp"
OddishSprite:          INCBIN "gfx/sprites/oddish.2bpp"
BulbasaurSprite:       INCBIN "gfx/sprites/bulbasaur.2bpp"
JigglypuffSprite:      INCBIN "gfx/sprites/jigglypuff.2bpp"
Clefairy2Sprite:       INCBIN "gfx/sprites/clefairy2.2bpp"
ChanseySprite:         INCBIN "gfx/sprites/chansey.2bpp"
SurfingPikachuSprite:  INCBIN "gfx/sprites/surfing_pikachu.2bpp"
JessieSprite:          INCBIN "gfx/sprites/jessie.2bpp"
JamesSprite:           INCBIN "gfx/sprites/james.2bpp"