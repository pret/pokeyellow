INCLUDE "engine/bank3f/data/map_songs.asm"
INCLUDE "engine/bank3f/data/map_header_pointers.asm"
INCLUDE "engine/bank3f/data/map_header_banks.asm"

Func_fc4dd:: ; fc4dd (3f:44dd)
; possibly to test if pika should be out?
	ld a,[wd430]
	bit 5,a
	jr nz,.asm_fc4f8 ; 3f:44f8
	ld a,[wd430]
	bit 7,a
	jr nz,.asm_fc4f8
	call IsStarterPikachuInOurParty
	jr nc,.asm_fc4f8
	ld a,[wWalkBikeSurfState]
	and a
	jr nz,.asm_fc4f8
	scf
	ret
.asm_fc4f8
	and a
	ret
	
Func_fc4fa:: ; fc4fa (3f:44fa)
	ld hl,wd430
	bit 4,[hl]
	res 4,[hl]
	jr nz,.asm_fc515
	call Func_1542
	call Func_fc523
	ld a,$ff
	ld [wSpriteStateData1 + $f2],a
	call Func_fcb84
	call Func_fc5bc
	ret
	
.asm_fc515
	call Func_fc53f
	xor a
	ld [wd431],a
	ld a,[wSpriteStateData1 + $9]
	ld [wSpriteStateData1 + $f9],a
	ret
	
Func_fc523:: ; fc523 (3f:4523)
	ld hl,wSpriteStateData1 + $f0
	call Func_fc52c
	ld hl,wSpriteStateData2 + $f0
Func_fc52c:: ; fc52c (3f:4523)
	ld bc,$10
	xor a
	call FillMemory
	ret

Func_fc534:: ; fc534 (3f:4534)
	call Func_fc53f
	call Func_fc5bc
	xor a
	ld [wd431],a
	ret
	
Func_fc53f:: ; fc53f (3f:453f)
	ld bc,wSpriteStateData1 + $f0
	ld a,[wYCoord]
	add $4
	ld e,a
	ld a,[wXCoord]
	add $4
	ld d,a
	ld a,[wd431]
	and a
	jr z,.asm_fc5aa
	cp $1
	jr z,.asm_fc59e
	cp $2
	jr z,.asm_fc584
	cp $3
	jr z,.asm_fc5aa
	cp $4
	jr z,.asm_fc5a4
	cp $5
	jr z,.asm_fc5a7
	cp $6
	jr z,.asm_fc5a1
	cp $7
	jr z,.asm_fc572
	jr .asm_fc59e
	
.asm_fc572
	ld a,[wSpriteStateData1 + $9]
	and a ; SPRITE_FACING_DOWN
	jr z,.asm_fc5a4
	cp SPRITE_FACING_UP 
	jr z,.asm_fc5a7
	cp SPRITE_FACING_LEFT
	jr z,.asm_fc5a1
	cp SPRITE_FACING_RIGHT
	jr z,.asm_fc59e
.asm_fc584
	ld a,[wSpriteStateData1 + $9]
	and a
	jr nz,.asm_fc58d
	dec e
	jr .asm_fc5aa
.asm_fc58d
	cp SPRITE_FACING_UP
	jr nz,.asm_fc594
	inc e
	jr .asm_fc5aa
.asm_fc594
	cp SPRITE_FACING_LEFT
	jr nz,.asm_fc59b
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
	ld hl,$104
	add hl,bc
	ld [hl],e
	inc hl
	ld [hl],d
	inc hl
Func_fc4b2:: ; fc4b2 (3f:44b2)
	ld [hl],$fe
	push hl
	ld hl,wd472
	set 5,[hl]
	pop hl
	ret
	
Func_fc5bc:: ; fc5bc (3f:45bc)
	ld a,$49
	ld [wSpriteStateData1 + $f0],a
	ld a,$ff
	ld [wSpriteStateData1 + $f2],a
	ld a,[wd431]
	and a
	jr z,.asm_fc5e4
	cp $1
	jr z,.asm_fc5e4
	cp $3
	jr z,.asm_fc5eb
	cp $4
	jr z,.asm_fc5e4
	cp $6
	jr z,.asm_fc5e4
	cp $7
	jr z,.asm_fc5f1
	call Func_fccb2
	ret
	
.asm_fc5e4
	ld a,[wSpriteStateData1 + $9]
	ld [wSpriteStateData1 + $f9],a
	ret
.asm_fc5eb
	ld a,$0
	ld [wSpriteStateData1 + $f9],a
	ret
.asm_fc5f1
	ld a,[wSpriteStateData1 + $9]
	xor $4
	ld [wSpriteStateData1 + $f9],a
	ret

Func_fc5fa:: ; fc5fa (3f:45fa)
	ld a,[wCurMap]
	cp OAKS_LAB
	jr z,.asm_fc63d
	cp ROUTE_22_GATE
	jr z,.asm_fc62d
	cp MT_MOON_2
	jr z,.asm_fc635
	cp ROCK_TUNNEL_1
	jr z,.asm_fc645
	ld a,[wCurMap]
	ld hl,Pointer_fc64b
	call Func_1568 ; similar to IsInArray, but not the same
	jr c,.asm_fc639
	ld a,[wCurMap]
	ld hl,Pointer_fc653
	call Func_1568
	jr nc,.asm_fc641
	ld a,[wSpriteStateData1 + $9]
	and a
	jr nz,.asm_fc641
	ld a,$3
	jr .asm_fc647
	
.asm_fc62d
	ld a,[wSpriteStateData1 + $9]
	and a
	jr z,.asm_fc645
	jr .asm_fc641
.asm_fc635
	ld a,$3
	jr .asm_fc647
.asm_fc639
	ld a,$4
	jr .asm_fc647
.asm_fc63d
	ld a,$6
	jr .asm_fc647
.asm_fc641
	ld a,$1
	jr .asm_fc647
.asm_fc645
	ld a,$3
.asm_fc647
	ld [wd431],a
	ret

Pointer_fc64b:: ; fc64b (3f:464b)
	db $c2,$4c,$4f,$ba,$be,$b8,$54,$ff
	
Pointer_fc653:: ; fc653 (3f:4653)
	db $2f,$e6,$3e,$5e,$80,$31,$a4,$ff

Func_fc65b:: ; fc65b (3f:465b)
	ld a,[wCurMap]
	cp VIRIDIAN_FOREST_EXIT
	jr z,.asm_fc673
	cp VIRIDIAN_FOREST_ENTRANCE
	jr z,.asm_fc67c
	ld a,[wCurMap]
	ld hl,Pointer_fc68e
	call Func_1568
	jr c,.asm_fc688
	jr .asm_fc684
.asm_fc673
	ld a,[wSpriteStateData1 + $9]
	cp SPRITE_FACING_UP
	jr z,.asm_fc688
	jr .asm_fc684
.asm_fc67c
	ld a,[wSpriteStateData1 + $9]
	and a ; SPRITE_FACING_DOWN
	jr z,.asm_fc684
	jr .asm_fc688
.asm_fc684
	ld a,$0
	jr .asm_fc68a
.asm_fc688
	ld a,$1
.asm_fc68a
	ld [wd431],a
	ret
	
Pointer_fc68e:: ; fc68e (3f:468e)
	db $33,$dd,$df,$e0,$e1,$de,$ec,$7f,$a8,$a9,$aa,$ff
	
Func_fc69a:: ; fc69a (3f:469a)
	ld a,[wCurMap]
	cp ROUTE_22_GATE
	jr z,.asm_fc6a7
	cp ROUTE_2_GATE
	jr z,.asm_fc6b0
	jr .asm_fc6bd
.asm_fc6a7
	ld a,[wSpriteStateData1 + $9]
	cp SPRITE_FACING_UP
	jr z,.asm_fc6b9
	jr .asm_fc6bd
.asm_fc6b0
	ld a,[wSpriteStateData1 + $9]
	cp SPRITE_FACING_UP
	jr z,.asm_fc6b9
	jr .asm_fc6bd
.asm_fc6b9
	ld a,$1
	jr .asm_fc6c1
.asm_fc6bd
	ld a,$3
	jr .asm_fc6c1
.asm_fc6c1
	ld [wd431],a
	ret

Func_fc6c5:: ; fc6c5 (3f:46c5)
	push hl
	ld hl,wd430
	set 2,[hl]
	pop hl
	ret

Func_fc6cd:: ; fc6cd (3f:46cd)
	push hl
	ld hl,wd430
	res 2,[hl]
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
	ld bc,wSpriteStateData1 + $f0
	ld hl,$1
	add hl,bc
	bit 7,[hl]
	jp nz,asm_fc745
	ld a,[wFontLoaded]
	bit 0,a
	jp nz,asm_fc76a
	call Func_154a
	jp nz,asm_fc76a
	ld a,[hl]
	and $7f
	cp $a
	jr c,.asm_fc704
	xor a
.asm_fc704
	add a
	ld e,a
	ld d,0
	ld hl,PointerTable_fc710
	add hl,de
	ld a,[hli]
	ld h,[hl]
	ld l,a
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
	jr nc,.asm_fc73b
	ld a,[wSpriteStateData1 + $f1]
	and a
	jr nz,.asm_fc739
	push bc
	push hl
	call Func_fc534
	pop hl
	pop bc
.asm_fc739
	scf
	ret
.asm_fc73b
	ld hl,wSpriteStateData1 + $f2
	ld [hl],$ff
	dec hl
	ld [hl],$0
	xor a
	ret
asm_fc745: ; fc745 (3f:4745)
	ld hl,$1
	add hl,bc
	res 7,[hl]
	ld hl,wSpriteStateData2 - wSpriteStateData1
	add hl,bc
	ld [hl],a
	call Func_154a
	jr nz,.asm_fc75f
	ld a,[wSpriteStateData1 + $9]
	xor $4
	ld hl,$9
	add hl,bc
	ld [hl],a
.asm_fc75f
	xor a
	ld hl,$7
	add hl,bc
	ld [hli],a
	ld [hl],a
	call Func_fca99
	ret
asm_fc76a: ; fc76a (3f:476a)
	xor a
	ld hl,$7
	add hl,bc
	ld [hli],a
	ld [hl],a
	call Func_fca99
	call Func_fc82e
	jr c,.asm_fc783
	push bc
	callab InitializeSpriteScreenPosition
	pop bc
.asm_fc783
	ld hl,$1
	add hl,bc
	ld [hl],$1
	ld hl,wSpriteStateData2 - wSpriteStateData1
	add hl,bc
	ld [hl],$0
	call Func_fcba1
	ret

Func_fc793: ; fc793 (3f:4793)
	call Func_fcba1
	push bc
	callab InitializeSpriteScreenPosition
	pop bc
	ld hl,$2
	add hl,bc
	ld [hl],$ff
	dec hl
	ld [hl],$1
	ret

Func_fc7aa: ; fc7aa (3f:47aa)
	call Func_fcc92
	jp c,Func_fc803
	dec a
	ld l,a
	ld h,$0
	add hl,hl
	add hl,hl
	ld de,Pointer_fc7e3
	add hl,de
	ld d,h
	ld e,l
	ld a,[de]
	inc de
	ld hl,$9
	add hl,bc
	ld [hl],a
	ld a,[de]
	inc de
	ld hl,$5
	add hl,bc
	ld [hl],a
	dec hl
	dec hl
	ld a,[de]
	ld [hl],a
	inc de
	ld a,[de]
	ld hl,$1
	add hl,bc
	ld [hl],a
	cp $4
	jp z,Func_fca0a
	call Func_fcd17
	jp c,Func_fc9df
	jp Func_fc9b4

Pointer_fc7e3: ; fc7e3 (3f:47e3)
	db $0,$0
	db $1,$3
	db $4,$0
	db $ff,$3
	db $8,$ff
	db $0,$3
	db $c,$1
	db $0,$3
	db $0,$0
	db $1,$4
	db $4,$0
	db $ff,$4
	db $8,$ff
	db $0,$4
	db $c,$1
	db $0,$4
	
Func_fc803: ; fc803 (3f:4803)
	call Func_fcae2
	ret c
	ld hl,wSpriteStateData2 - wSpriteStateData1
	add hl,bc
	dec [hl]
	jr nz,.asm_fc823
	push hl
	call Func_fccee
	pop hl
	cp $5
	jr nc,Func_fc842
	ld [hl],$20
	call Random
	and $c
	ld hl,$9
	add hl,bc
	ld [hl],a
.asm_fc823
	xor a
	ld hl,$7
	add hl,bc
	ld [hli],a
	ld [hl],a
	call Func_fca99
	ret

Func_fc82e: ; fc82e (3f:482e)
	ld a,[wWalkCounter]
	and a
	ret z
	scf
	ret

Func_fc835: ; fc835 (3f:4835)
	ld hl,wSpriteStateData2 - wSpriteStateData1
	add hl,bc
	ld [hl],$10
	ld hl,$1
	add hl,bc
	ld [hl],$1
	ret
	
Func_fc842: ; fc842 (3f:4842)
	ld hl,$0
	push af
	call Random
	ld a,[hRandomAdd]
	and %11
	ld e,a
	ld d,$0
	ld hl,PointerTable_fc85a
	add hl,de
	add hl,de
	ld a,[hli]
	ld h,[hl]
	ld l,a
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
	ld hl,$9
	add hl,bc
	ld [hl],a
	ld hl,$1
	add hl,bc
	ld [hl],$6
	xor a
	ld [wd432],a
	ld [wd433],a
	ld hl,wSpriteStateData2 - wSpriteStateData1
	add hl,bc
	ld [hl],$11
asm_fc87f: ; fc87f (3f:487f)
	ld a,[wd432]
	ld e,a
	ld a,[wd433]
	ld d,a
	call Func_fc82e
	jr c,Func_fc8c7
	call Func_fc6c5
	ld hl,$4
	add hl,bc
	ld a,[hl]
	sub e
	ld e,a
	inc hl
	inc hl
	ld a,[hl]
	sub d
	ld d,a
	ld hl,wSpriteStateData2 - wSpriteStateData1
	add hl,bc
	ld a,[hl]
	dec a
	add a
	add $d6
	ld l,a
	ld a,$48
	adc $0
	ld h,a
	ld a,[hli]
	ld [wd432],a
	add e
	ld e,a
	ld a,[hl]
	ld [wd433],a
	add d
	ld d,a
	ld hl,$4
	add hl,bc
	ld [hl],e
	inc hl
	inc hl
	ld [hl],d
	ld hl,wSpriteStateData2 - wSpriteStateData1
	add hl,bc
	dec [hl]
	ret nz
	jp Func_fc835
	
Func_fc8c7: ; fc8c7 (3f:48c7)
	ld hl,$4
	add hl,bc
	ld a,[hl]
	sub e
	ld [hl],a
	inc hl
	inc hl
	ld a,[hl]
	sub d
	ld [hl],a
	jp Func_fc835

Pointer_fc8d6: ; fc8d6 (3f:48d6)
	db $0,$0,$fe,$1,$fc
	db $2,$fe,$3,$0,$4
	db $fe,$3,$fc,$2,$fe
	db $1,$0,$0,$fe,$ff
	db $fc,$fe,$fe,$fd,$0
	db $fc,$fe,$fd,$fc,$fe
	db $fe,$ff,$00,$00
	
Func_fc8f8: ; fc8f8 (3f:48f8)
	ld hl,$1
	add hl,bc
	ld [hl],$7
	ld hl,wSpriteStateData2 - wSpriteStateData1
	add hl,bc
	ld [hl],$30
asm_fc904: ; fc904 (3f:4904)
	call Func_fc82e
	jp c,Func_fc835
	call Func_fc6c5
	ld hl,$7
	add hl,bc
	ld a,[hl]
	inc a
	cp $8
	ld [hl],a
	jr nz,.asm_fc91f
	xor a
	ld [hli],a
	ld a,[hl]
	inc a
	and %11
	ld [hl],a
.asm_fc91f
	call Func_fca99
	ld hl,wSpriteStateData2 - wSpriteStateData1
	add hl,bc
	dec [hl]
	ret nz
	jp Func_fc835
	
Func_fc92b: ; fc92b (3f:492b)
	ld hl,wSpriteStateData2 - wSpriteStateData1
	add hl,bc
	ld [hl],$20
	ld hl,$1
	add hl,bc
	ld [hl],$8
asm_fc937: ; fc937 (3f:4937)
	call Func_fc82e
	jp c,Func_fc835
	call Func_fc6c5
	ld hl,$7
	add hl,bc
	ld a,[hl]
	inc a
	cp $8
	ld [hl],a
	jr nz,.asm_fc951
	xor a
	ld [hli],a
	ld a,[hl]
	xor $1
	ld [hl],a
.asm_fc951
	call Func_fca99
	ld hl,wSpriteStateData2 - wSpriteStateData1
	add hl,bc
	dec [hl]
	ret nz
	jp Func_fc835
	
Func_fc95d: ; fc95d (3f:495d)
	ld hl,wSpriteStateData2 - wSpriteStateData1
	add hl,bc
	ld [hl],$20
	ld hl,$1
	add hl,bc
	ld [hl],$9
asm_fc969: ; fc969 (3f:4969)
	call Func_fc82e
	jp c,Func_fc835
	call Func_fc6c5
	ld hl,$7
	add hl,bc
	ld a,[hl]
	inc a
	cp $8
	ld [hl],a
	jr nz,.asm_fc988
	xor a
	ld [hl],a
	ld hl,$9
	add hl,bc
	ld a,[hl]
	call Func_fc994
	ld [hl],a
.asm_fc988
	call Func_fca99
	ld hl,wSpriteStateData2 - wSpriteStateData1
	add hl,bc
	dec [hl]
	ret nz
	jp Func_fc835
	
Func_fc994: ; fc994 (3f:4994)
	push hl
	ld hl,Pointer_fc9ac
	ld d,a
.loop
	ld a,[hli]
	cp d
	jr nz,.loop
	ld a,[hl]
	pop hl
	ret
	
Func_fc9a0: ; fc9a0 (3f:49a0)
	push hl
	ld hl,Pointer_fc9ac_End
	ld d,a
.loop
	ld a,[hld]
	cp d
	jr nz,.loop
	ld a,[hl]
	pop hl
	ret
	
Pointer_fc9ac: ; fc9ac (3f:49ac)
	db SPRITE_FACING_DOWN,SPRITE_FACING_LEFT,SPRITE_FACING_UP,SPRITE_FACING_RIGHT
	db SPRITE_FACING_DOWN,SPRITE_FACING_LEFT,SPRITE_FACING_UP,SPRITE_FACING_RIGHT
Pointer_fc9ac_End:
Func_fc9b4: ; fc9b4 (3f:49b4)
	ld hl,wSpriteStateData2 - wSpriteStateData1
	add hl,bc
	ld [hl],$8
	ld hl,$1
	add hl,bc
	ld [hl],$3
	call Func_fca38
asm_fc9c3: ; fc9c3 (3f:49c3)
	call Func_fca4b
	call Func_fca7e
	call Func_fca99
	ld hl,$100
	add hl,bc
	dec [hl]
	ret nz
	call Func_fca75
	call Func_fccb2
	ld hl,$1
	add hl,bc
	ld [hl],$1
	ret
	
Func_fc9df: ; fc9df (3f:49df)
	ld hl,wSpriteStateData2 - wSpriteStateData1
	add hl,bc
	ld [hl],$4
	ld hl,$1
	add hl,bc
	ld [hl],$5
	call Func_fca38
asm_fc9ee: ; fc9ee (3f:49ee)
	call asm_fca59
	call Func_fca7e
	call Func_fca99
	ld hl,wSpriteStateData2 - wSpriteStateData1
	add hl,bc
	dec [hl]
	ret nz
	call Func_fca75
	call Func_fccb2
	ld hl,$1
	add hl,bc
	ld [hl],$1
	ret
	
Func_fca0a: ; fca0a (3f:4a0a)
	ld hl,wSpriteStateData2 - wSpriteStateData1
	add hl,bc
	ld [hl],$8
	ld hl,$1
	add hl,bc
	ld [hl],$4
	call Func_fca38
	call Func_fca38
asm_fca1c: ; fca1c (3f:4a1c)
	call asm_fca59
	call Func_fca7e
	call Func_fca99
	ld hl,wSpriteStateData2 - wSpriteStateData1
	add hl,bc
	dec [hl]
	ret nz
	call Func_fca75
	call Func_fccb2
	ld hl,$1
	add hl,bc
	ld [hl],$1
	ret
	
Func_fca38: ; fca38 (3f:4a38)
	ld hl,$3
	add hl,bc
	ld e,[hl]
	inc hl
	inc hl
	ld d,[hl]
	ld hl,$104
	add hl,bc
	ld a,[hl]
	add e
	ld [hli],a
	ld a,[hl]
	add d
	ld [hl],a
	ret
	
Func_fca4b: ; fca4b (3f:4a4b)
	ld a,[wWalkBikeSurfState]
	cp $1
	jr nz,Func_fca68
	ld a,[wd736]
	bit 6,a
	jr nz,Func_fca68
asm_fca59: ; fca59 (3f:4a59)
	ld hl,$3
	add hl,bc
	ld a,[hli]
	add a
	add a
	add [hl]
	ld [hli],a
	ld a,[hli]
	add a
	add a
	add [hl]
	ld [hl],a
	ret
	
Func_fca68: ; fca68 (3f:4a68)
	ld hl,$3
	add hl,bc
	ld a,[hli]
	add a
	add [hl]
	ld [hli],a
	ld a,[hli]
	add a
	add [hl]
	ld [hli],a
	ret
	
Func_fca75: ; fca75 (3f:4a75)
	ld hl,$3
	add hl,bc
	xor a
	ld [hli],a
	inc hl
	ld [hl],a
	ret
	
Func_fca7e: ; fca7e (3f:4a7e)
	call Func_fcdad
	ld d,$2
	jr nc,.asm_fca87
	ld d,$5
.asm_fca87
	ld hl,$7
	add hl,bc
	ld a,[hl]
	inc a
	cp d
	jr nz,.asm_fca91
	xor a
.asm_fca91
	ld [hli],a
	ret nz
	ld a,[hl]
	inc a
	and $3
	ld [hl],a
	ret
	
Func_fca99: ; fca99 (3f:4a99)
	ld a,[wd430]
	bit 3,a
	jr nz,.asm_fcad1
	ld hl,$10e
	add hl,bc
	ld a,[hl]
	dec a
	swap a
	ld d,a
	ld a,[wd736]
	bit 7,a
	jr nz,.asm_fcad8
	ld hl,$9
	add hl,bc
	ld a,[hl]
	or d
	ld d,a
	ld a,[wFontLoaded]
	bit 0,a
	jr z,.asm_fcac4
	call Func_fcae2
	ret c
	jr .asm_fcacb
.asm_fcac4
	ld hl,$8
	add hl,bc
	ld a,d
	or [hl]
	ld d,a
.asm_fcacb
	ld hl,$2
	add hl,bc
	ld [hl],d
	ret
.asm_fcad1
	ld hl,$2
	add hl,bc
	ld [hl],$ff
	ret
.asm_fcad8
	ld a,[wSpriteStateData1 + $2]
	and $f
	or d
	ld [wSpriteStateData1 + $f2],a
	ret
	
Func_fcae2: ; fcae2 (3f:4ae2)
	ld hl,$104
	add hl,bc
	ld a,[wYCoord]
	add $4
	cp [hl]
	jr nz,.asm_fcaff
	inc hl
	ld a,[wXCoord]
	add $4
	cp [hl]
	jr nz,.asm_fcaff
	ld hl,$2
	add hl,bc
	ld [hl],$ff
	scf
	ret
.asm_fcaff
	and a
	ret

Func_fcb01: ; fcb01 (3f:4b01)
	push bc
	push de
	push hl
	ld bc,wSpriteStateData1 + $f0
	ld a,[wXCoord]
	add $4
	ld d,a
	ld a,[wYCoord]
	add $4
	ld e,a
	ld hl,$104
	add hl,bc
	ld a,[hl]
	sub e
	and a
	jr z,.asm_fcb30
	cp $ff
	jr z,.asm_fcb26
	cp $1
	jr z,.asm_fcb26
	jr .asm_fcb48
.asm_fcb26
	ld hl,$105
	add hl,bc
	ld a,[hl]
	sub d
	jr z,.asm_fcb43
	jr .asm_fcb48
.asm_fcb30
	ld hl,$105
	add hl,bc
	ld a,[hl]
	sub d
	cp $ff
	jr z,.asm_fcb43
	cp $1
	jr z,.asm_fcb43
	and a
	jr z,.asm_fcb43
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
	ld e,a
	ret
	
Func_fcb52: ; fcb52 (3f:4b52)
	ld bc,wSpriteStateData1 + $f0
	ld a,[wXCoord]
	add $4
	ld d,a
	ld a,[wYCoord]
	add $4
	ld e,a
	ld hl,$104
	add hl,bc
	ld a,[hl]
	cp e
	jr z,Func_fcb71
	jr nc,.asm_fcb6e
	ld a,$4
	ret
.asm_fcb6e
	ld a,$0
	ret
	
Func_fcb71: ; fcb71 (3f:4b71)
	ld hl,$105
	add hl,bc
	ld a,[hl]
	cp d
	jr z,.asm_fcb81
	jr nc,.asm_fcb7e
	ld a,$8
	ret
.asm_fcb7e
	ld a,$c
	ret
.asm_fcb81
	ld a,$ff
	ret

Func_fcb84: ; fcb84 (3f:4b84)
	push bc
	ld hl,wd437
	ld [hl],$ff
	inc hl
	ld bc,$10
	xor a
	call FillMemory
	pop bc
	ret
	
Func_fcb94: ; fcb94 (3f:4b94)
	ld hl,wd437
	inc [hl]
	ld e,[hl]
	ld d,0
	ld hl,wd438
	add hl,de
	ld [hl],a
	ret
	
Func_fcba1: ; fcba1 (3f:4ba1)
	call Func_fcb84
	call Func_fcbac
	ret c
	call Func_fcb94
	ret
	
Func_fcbac: ; fcbac (3f:4bac)
	ld bc,wSpriteStateData1 + $f0
	ld hl,$104
	add hl,bc
	ld a,[wYCoord]
	add $4
	sub [hl]
	jr z,.asm_fcbd7
	jr c,.asm_fcbca
	call Func_fcc01
	jr c,.asm_fcbc6
	ld a,$5
	and a
	ret
.asm_fcbc6
	ld a,$1
	and a
	ret
.asm_fcbca
	call Func_fcc01
	jr c,.asm_fcbd3
	ld a,$6
	and a
	ret
.asm_fcbd3
	ld a,$2
	and a
	ret
.asm_fcbd7
	ld hl,$105
	add hl,bc
	ld a,[wXCoord]
	add $4
	sub [hl]
	jr z,.asm_fcbff
	jr c,.asm_fcbf2
	call Func_fcc01
	jr c,.asm_fcbee
	ld a,$8
	and a
	ret
.asm_fcbee
	ld a,$4
	and a
	ret
.asm_fcbf2
	call Func_fcc01
	jr c,.asm_fcbfb
	ld a,$7
	and a
	ret
.asm_fcbfb
	ld a,$3
	and a
	ret
.asm_fcbff
	scf
	ret
	
Func_fcc01: ; fcc01 (3f:4c01)
	jr nc,.asm_fcc05
	cpl
	inc a
.asm_fcc05
	cp $2
	ret
	
Func_fcc08:: ; fcc08 (3f:4c08)
	call Func_fcc23
	ret nc
	ld a,[wd736]
	bit 6,a
	jr nz,.asm_fcc1b
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
	ld a,[wd430]
	bit 5,a
	jr nz,.asm_fcc40
	ld a,[wd430]
	bit 7,a
	jr nz,.asm_fcc40
	ld a,[wd472]
	bit 7,a
	jr z,.asm_fcc40
	ld a,[wWalkBikeSurfState]
	and a
	jr nz,.asm_fcc40
	scf
	ret
.asm_fcc40
	and a
	ret
	
Func_fcc42: ; fcc42 (3f:4c42)
	xor a
	ld a,[wPlayerDirection]
	bit 3,a
	jr nz,.asm_fcc58
	bit 2,a
	jr nz,.asm_fcc5b
	bit 1,a
	jr nz,.asm_fcc5e
	bit 0,a
	jr nz,.asm_fcc61
	scf
	ret
.asm_fcc58
	ld a,$2
	ret
.asm_fcc5b
	ld a,$1
	ret
.asm_fcc5e
	ld a,$3
	ret
.asm_fcc61
	ld a,$4
	ret
	
Func_fcc64: ; fcc64 (3f:4c64)
	ld hl,wd430
	bit 6,[hl]
	jr z,.asm_fcc6e
	res 6,[hl]
	ret
.asm_fcc6e
	set 6,[hl]
	xor a
	ld a,[wPlayerDirection]
	bit 3,a
	jr nz,.asm_fcc86
	bit 2,a
	jr nz,.asm_fcc89
	bit 1,a
	jr nz,.asm_fcc8c
	bit 0,a
	jr nz,.asm_fcc8f
	scf
	ret
.asm_fcc86
	ld a,$6
	ret
.asm_fcc89
	ld a,$5
	ret
.asm_fcc8c
	ld a,$7
	ret
.asm_fcc8f
	ld a,$8
	ret

Func_fcc92: ; fcc92 (3f:4c92)
	ld hl,wd437
	ld a,[hl]
	cp $ff
	jr z,.asm_fccb0
	and a
	jr z,.asm_fccb0
	dec [hl]
	ld e,a
	ld d,0
	ld hl,wd438
	add hl,de
	inc e
	ld a,$ff
.asm_fcca8
	ld d,[hl]
	ldd [hl],a
	ld a,d
	dec e
	jr nz,.asm_fcca8
	and a
	ret
.asm_fccb0
	scf
	ret

Func_fccb2:: ; fccb2 (3f:4cb2)
	call Func_fcd01
	and a
	jr z,.asm_fccbf
	dec a
	and $3
	add a
	add a
	jr .asm_fccea
.asm_fccbf
	ld a,[wYCoord]
	add $4
	ld d,a
	ld a,[wXCoord]
	add $4
	ld e,a
	ld a,[wSpriteStateData2 + $f4]
	cp d
	jr z,.asm_fccd9
	ld a,SPRITE_FACING_DOWN
	jr c,.asm_fccea
	ld a,SPRITE_FACING_UP
	jr .asm_fccea
.asm_fccd9
	ld a,[wSpriteStateData2 + $f5]
	cp e
	jr z,.asm_fcce7
	ld a,SPRITE_FACING_RIGHT
	jr c,.asm_fccea
	ld a,SPRITE_FACING_LEFT
	jr .asm_fccea
.asm_fcce7
	ld a,[wSpriteStateData1 + $9]
.asm_fccea
	ld [wSpriteStateData1 + $f9],a
	ret
	
Func_fccee: ; fccee (3f:4cee)
	ld hl,wd437
	ld a,[hl]
	cp $ff
	jr z,.asm_fccff
	ld e,a
	ld d,0
	ld hl,wd438
	add hl,de
	ld a,[hl]
	ret
.asm_fccff
	xor a
	ret
	
Func_fcd01: ; fcd01 (3f:4d01)
	ld hl,wd437
	ld a,[hl]
	cp $ff
	jr z,.asm_fcd15
	and a
	jr z,.asm_fcd15
	ld e,a
	ld d,0
	ld hl,wd438
	add hl,de
	ld a,[hl]
	ret
.asm_fcd15
	xor a
	ret
	
Func_fcd17: ; fcd17 (3f:4d17)
	ld a,[wd437]
	cp $ff
	ret z
	cp $2
	jr nc,.asm_fcd23
	and a
	ret
.asm_fcd23
	scf
	ret
	
Func_fcd25: ; fcd25 (3f:4d25)
	ld h,wSpriteStateData2 / $100
	ld a,[H_CURRENTSPRITEOFFSET]
	add $4
	ld l,a
	ld b,[hl]
	ld a,[wYCoord]
	cp b
	jr z,.asm_fcd3a
	jr nc,.asm_fcd63
	add $8
	cp b
	jr c,.asm_fcd63
.asm_fcd3a
	inc l
	ld b,[hl]
	ld a,[wXCoord]
	cp b
	jr z,.asm_fcd49
	jr nc,.asm_fcd63
	add $9
	cp b
	jr c,.asm_fcd63
.asm_fcd49
	call Func_fcd83
	ld d,$60
	ld a,[hli]
	ld e,a
	cp d
	jr nc,.asm_fcd63
	ld a,[hld]
	cp d
	jr nc,.asm_fcd63
	ld bc,-20
	add hl,bc
	ld a,[hli]
	cp d
	jr nc,.asm_fcd63
	ld a,[hl]
	cp d
	jr c,.asm_fcd6f
.asm_fcd63
	ld h,wSpriteStateData1 / $100
	ld a,[H_CURRENTSPRITEOFFSET]
	add $2
	ld l,a
	ld [hl],$ff
	scf
	jr .asm_fcd82
.asm_fcd6f
	ld h,wSpriteStateData2 / $100
	ld a,[H_CURRENTSPRITEOFFSET]
	add $7
	ld l,a
	ld a,[wGrassTile]
	cp e
	ld a,$0
	jr nz,.asm_fcd80
	ld a,$80
.asm_fcd80
	ld [hl],a
	and a
.asm_fcd82
	ret
	
Func_fcd83: ; fcd83 (3f:4d83)
	ld h,wSpriteStateData1 / $100
	ld a,[H_CURRENTSPRITEOFFSET]
	add $4
	ld l,a
	ld a,[hli]
	add $4
	and $f0
	srl a
	ld c,a
	ld b,$0
	inc l
	ld a,[hl]
	add $2
	srl a
	srl a
	srl a
	add SCREEN_WIDTH
	ld d,0
	ld e,a
	ld hl,wTileMap
	rept 5
	add hl,bc
	endr
	add hl,de
	ret
	
Func_fcdad: ; fcdad (3f:4dad)
	push bc
	push af
	ld a,[wPikachuHappiness]
	cp $50
	pop bc
	ld a,b
	pop bc
	ret

IsStarterPikachuInOurParty:: ; fcdb8 (3f:4db8)
	ld hl,wPartySpecies
	ld de,wPartyMon1OTID
	ld bc,wPartyMonOT
	push hl
.loop
	pop hl
	ld a,[hli]
	push hl
	inc a
	jr z,.noPlayerPikachu
	cp PIKACHU + 1
	jr nz,.curMonNotPlayerPikachu
	ld h,d
	ld l,e
	ld a,[wPlayerID]
	cp [hl]
	jr nz,.curMonNotPlayerPikachu
	inc hl
	ld a,[wPlayerID+1]
	cp [hl]
	jr nz,.curMonNotPlayerPikachu
	push de
	push bc
	ld hl,wPlayerName
	ld d,$6 ; possible player length - 1
.nameCompareLoop
	dec d
	jr z,.sameOT
	ld a,[bc]
	inc bc
	cp [hl]
	inc hl
	jr z,.nameCompareLoop
	pop bc
	pop de
.curMonNotPlayerPikachu
	ld hl,wPartyMon2 - wPartyMon1
	add hl,de
	ld d,h
	ld e,l
	ld hl,NAME_LENGTH
	add hl,bc
	ld b,h
	ld c,l
	jr .loop
.sameOT
	pop bc
	pop de
	ld h,d
	ld l,e
	ld bc,-NAME_LENGTH
	add hl,bc
	ld a,[hli]
	or [hl]
	jr z,.noPlayerPikachu ; XXX how is this determined?
	pop hl
	scf
	ret
.noPlayerPikachu
	pop hl
	and a
	ret

IsThisPartymonStarterPikachu_Box:: ; fce0d (3f:4e0d)
	ld hl,wBoxMon1
	ld bc,wBoxMon2 - wBoxMon1
	ld de,wBoxMonOT
	jr asm_fce21

IsThisPartymonStarterPikachu_Party:: ; fce18 (3f:4e18)
IsThisPartymonStarterPikachu::
	ld hl,wPartyMon1
	ld bc,wPartyMon2 - wPartyMon1
	ld de,wPartyMonOT
asm_fce21: ; fce21 (3f:4e21)
	ld a,[wWhichPokemon]
	call AddNTimes
	ld a,[hl]
	cp PIKACHU
	jr nz,.notPlayerPikachu
	ld bc,wPartyMon1OTID - wPartyMon1
	add hl,bc
	ld a,[wPlayerID]
	cp [hl]
	jr nz,.notPlayerPikachu
	inc hl
	ld a,[wPlayerID+1]
	cp [hl]
	jr nz,.notPlayerPikachu
	ld h,d
	ld l,e
	ld a,[wWhichPokemon]
	ld bc,NAME_LENGTH
	call AddNTimes
	ld de,wPlayerName
	ld b,$6
.loop
	dec b
	jr z,.isPlayerPikachu
	ld a,[de]
	inc de
	cp [hl]
	inc hl
	jr z,.loop
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
	ld a,d
	cp $80
	ld a,[wPikachuMood]
	jr c,.asm_fce6c
	cp d
	jr c,.asm_fce6e
	ret
.asm_fce6c
	cp d
	ret c
.asm_fce6e
	ld a,d
	ld [wPikachuMood],a
	ret

Func_fce73:: ; fce73 (3f:4e73)
; function to test if a pokemon is alive?
	xor a
	ld [wWhichPokemon],a
	ld hl,wPartyCount
.loop
	inc hl
	ld a,[hl]
	cp $ff
	jr z,.asm_fcea9
	push hl
	call IsThisPartymonStarterPikachu_Party
	pop hl
	jr nc,.asm_fce9e
	ld a,[wWhichPokemon]
	ld hl,wPartyMon1HP
	ld bc,wPartyMon2 - wPartyMon1
	call AddNTimes
	ld a,[hli]
	or [hl]
	ld d,a
	inc hl
	inc hl
	ld a,[hl]
	and a
	jr nz,.asm_fcea7
	jr .asm_fcea9
.asm_fce9e
	ld a,[wWhichPokemon]
	inc a
	ld [wWhichPokemon],a
	jr .loop
.asm_fcea7
	scf
	ret
.asm_fcea9
	and a
	ret

Func_fceab:: ; fceab (3f:4eab)
	ld hl,wPartySpecies
	ld de,wPartyMon1Moves
	ld bc,wPartyMonOT
	push hl
.loop
	pop hl
	ld a,[hli]
	push hl
	inc a
	jr z,.noSurfingPlayerPikachu
	cp PIKACHU+1
	jr nz,.curMonNotSurfingPlayerPikachu
	ld h,d
	ld l,e
	push hl
	push bc
	ld b,NUM_MOVES
.moveSearchLoop
	ld a,[hli]
	cp SURF
	jr z,.foundSurfingPikachu
	dec b
	jr nz,.moveSearchLoop
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
	ld a,[wPlayerID]
	cp [hl]
	jr nz,.curMonNotSurfingPlayerPikachu
	inc hl
	ld a,[wPlayerID+1]
	cp [hl]
	jr nz,.curMonNotSurfingPlayerPikachu
	push de
	push bc
	ld hl,wPlayerName
	ld d,$6
.nameCompareLoop
	dec d
	jr z,.foundSurfingPlayerPikachu
	ld a,[bc]
	inc bc
	cp [hl]
	inc hl
	jr z,.nameCompareLoop
	pop bc
	pop de
.curMonNotSurfingPlayerPikachu
	ld hl,wPartyMon2 - wPartyMon1
	add hl,de
	ld d,h
	ld e,l
	ld hl,NAME_LENGTH
	add hl,bc
	ld b,h
	ld c,l
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

Func_fcf0c:: ; fcf0c (3f:4f0c)
	dr $fcf0c,$fd001
Func_fd001:: ; fd001 (3f:5001)
	dr $fd001,$fd004
Func_fd004:: ; fd004 (3f:5004)
	dr $fd004,$fd0d0
Func_fd0d0:: ; fd0d0 (3f:50d0)
	dr $fd0d0,$fd252
Func_fd252: ; fd252 (3f:5252)
	dr $fd252,$fd2a1
Func_fd2a1:: ; fd2a1 (3f:52a1)
	dr $fd2a1,$fe66f

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