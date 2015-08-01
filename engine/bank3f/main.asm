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
	call Func_fcdb8
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
	ld bc,wSpriteStateData1 + $10
	ld a,[W_YCOORD]
	add $4
	ld e,a
	ld a,[W_XCOORD]
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
	call Func_fc4b2
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
	ld a,[W_CURMAP]
	cp OAKS_LAB
	jr z,.asm_fc63d
	cp ROUTE_22_GATE
	jr z,.asm_fc62d
	cp MT_MOON_2
	jr z,.asm_fc635
	cp ROCK_TUNNEL_1
	jr z,.asm_fc645
	ld a,[W_CURMAP]
	ld hl,Pointer_fc46b
	call Func_1568 ; similar to IsInArray, but not the same
	jr c,.asm_fc639
	ld a,[W_CURMAP]
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
	ld a,[W_CURMAP]
	cp VIRIDIAN_FOREST_EXIT
	jr z,.asm_fc673
	cp VIRIDIAN_FOREST_ENTRANCE
	jr z,.asm_fc67c
	ld a,[W_CURMAP]
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
	ld a,[W_CURMAP]
	cp ROUTE_22_GATE
	jr z,.asm_fc6a7
	cp ROUTE_2_GATE
	jr z,.asm_fc6b0
	jr .asm_fc6bd
.asm_fc6a7
	ld a,[wSpriteStateData1 + $9]
	cp SPRITE_FACING_DOWN
	jr z,.asm_fc6b9
	jr .asm_fc6bd
.asm_fc6b0
	ld a,[wSpriteStateData1 + $9]
	cp SPRITE_FACING_DOWN
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

INCBIN "baserom.gbc",$fc6c5,$fcc08 - $fc6c5
Func_fcc08:: ; fcc08 (3f:4c08)
INCBIN "baserom.gbc",$fcc08,$fe66f - $fcc08

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