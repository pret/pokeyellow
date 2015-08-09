PlayDefaultMusic:: ; 216b (0:216b)
	call WaitForSoundToFinish
	xor a
	ld c, a
	ld d, a
	ld [wcfca], a
	jr asm_2188

Func_2176:: ; 2176 (0:2176)
	ld c, $a
	ld d, $0
	ld a, [wd72e]
	bit 5, a
	jr z, asm_2188
	xor a
	ld [wcfca], a
	ld c, $8
	ld d, c
asm_2188: ; 2118 (0:2118)
	ld a, [wWalkBikeSurfState]
	and a
	jr z, .asm_21ac
	cp $2
	jr z, .asm_219b
	call Func_21c8
	jr c, .asm_21ac
	ld a, $d2 ; MUSIC_BIKE_RIDING
	jr .asm_219d
.asm_219b
	ld a, $d6 ; MUSIC_SURFING
.asm_219d
	ld b, a
	ld a, d
	and a
	ld a, $1f ; BANK(Music_BikeRiding)
	jr nz, .asm_21a7
	ld [wc0ef], a
.asm_21a7
	ld [wc0f0], a
	jr .asm_21b5
.asm_21ac
	ld a, [wd35b]
	ld b, a
	call Func_21f5
	jr c, .asm_21ba
.asm_21b5
	ld a, [wcfca]
	cp b
	ret z
.asm_21ba
	ld a, c
	ld [wMusicHeaderPointer], a
	ld a, b
	ld [wcfca], a
	ld [wc0ee], a
	jp PlaySound

Func_21c8:: ; 21c8 (0:21c8)
; probably used to not change music upon getting on bike
	ld a,[W_CURMAP]
	cp ROUTE_23
	jr z,.asm_21e1
	cp VICTORY_ROAD_1
	jr z,.asm_21e1
	cp VICTORY_ROAD_2
	jr z,.asm_21e1
	cp VICTORY_ROAD_3
	jr z,.asm_21e1
	cp INDIGO_PLATEAU
	jr z,.asm_21e1
	and a
	ret
.asm_21e1
	scf
	ret

Func_21e3:: ; 21e5 (0:21e5)
	ld c,$6
	push bc
	push hl
	callba Music2_UpdateMusic ; 2:509d
	pop hl
	pop bc
	dec c
	jr nz, Func_21e3
	ret
	
;Func_235f:: ; 235f (0:235f)
;	ld a, [wc0ef]
;	ld b, a
;	cp BANK(Music2_UpdateMusic)
;	jr nz, .checkForBank08
;.bank02
;	ld hl, Music2_UpdateMusic
;	jr .asm_2378
;.checkForBank08
;	cp BANK(Music8_UpdateMusic)
;	jr nz, .bank1F
;.bank08
;	ld hl, Music8_UpdateMusic
;	jr .asm_2378
;.bank1F
;	ld hl, Music1f_UpdateMusic
;.asm_2378
;	ld c, $6
;.asm_237a
;	push bc
;	push hl
;	call Bankswitch
;	pop hl
;	pop bc
;	dec c
;	jr nz, .asm_237a
;	ret

Func_21f5:: ; 21f5 (0:21f5)
	ld a, [wd35c]
	ld e, a
	ld a, [wc0ef]
	cp e
	jr nz, .asm_2204
	ld [wc0f0], a
	and a
	ret
.asm_2204
	ld a, c
	and a
	ld a, e
	jr nz, .asm_220c
	ld [wc0ef], a
.asm_220c
	ld [wc0f0], a
	scf
	ret

PlayMusic:: ; 2211 (0:2211)
	ld b, a
	ld [wc0ee], a
	xor a
	ld [wMusicHeaderPointer], a
	ld a, c
	ld [wc0ef], a
	ld [wc0f0], a
	ld a, b
	jr PlaySound
	
Func_2223:: ; 2223 (0:2223)
	xor a
	ld [wc02a],a
	ld [wc02b],a
	ld [wc02c],a
	ld [wc02d],a
	ld [rNR10],a
	ret
	
StopAllMusic:: ; 2233 (0:2233)
	ld a,$FF
	ld [wc0ee],a
; plays music specified by a. If value is $ff, music is stopped
PlaySound:: ; 2238 (0:2238)
	push hl
	push de
	push bc
	ld b, a
	ld a, [wc0ee]
	and a
	jr z, .asm_224f
	xor a
	ld [wc02a], a
	ld [wc02b], a
	ld [wc02c], a
	ld [wc02d], a
.asm_224f
	ld a, [wMusicHeaderPointer]
	and a
	jr z, .asm_226a
	ld a, [wc0ee]
	and a
	jr z, .asm_2284
	xor a
	ld [wc0ee], a
	ld a, [wcfca]
	cp $ff
	jr nz, .asm_2273
	xor a
	ld [wMusicHeaderPointer], a
.asm_226a
	xor a
	ld [wc0ee], a
	call Func_22ec
	jr .asm_2284
.asm_2273
	ld a,b
	ld [wcfca],a
	ld a,[wMusicHeaderPointer]
	ld [wcfc8],a
	ld [wcfc9],a
	ld a,b
	ld [wMusicHeaderPointer],a
.asm_2284
	pop bc
	pop de
	pop hl
	ret

Func_2288:: ; 2288 (0:2288)
	ld a,[H_LOADEDROMBANK]
	push af
	ld a, [wc0ef]
	call BankswitchCommon
	ld d,$0
	ld a,c
	add a
	ld e,a
	ld hl,wc006
	add hl,de
	ld a,[hli]
	ld e,a
	ld a,[hld]
	ld d,a
	ld a,[de]
	inc de
	ld [hl],e
	inc hl
	ld [hl],d
	ld e,a
	pop af
	call BankswitchCommon
	ld a,e
	ret

Func_22aa:: ; 22aa (0:22aa)
	push hl
	push de
	push bc
	homecall Func_219f8 ; 8:59f8
	pop bc
	pop de
	pop hl
	ret
	
Func_22c0:: ; 22c0 (0:22c0)
	push hl
	push de
	push bc
	homecall Func_21ab7 ; 8:5ab7
	pop bc
	pop de
	pop hl
	ret
	
Func_22d6:: ; 22d6 (0:22d6)
	push hl
	push de
	push bc
	homecall Func_21b3f
	pop bc
	pop de
	pop hl
	ret
	
Func_22ec:: ; 22ec (0:22ec)
	ld a,[H_LOADEDROMBANK]
	push af
	ld a,[wc0ef]
	call BankswitchCommon
	cp BANK(Func_984e)
	jr nz, .checkForBank08
.bank02
	ld a, b
	call Func_984e
	jr .done
.checkForBank08
	cp BANK(Func_218bb)
	jr nz, .checkForBank1F
.bank08
	ld a, b
	call Func_218bb
	jr .done
.checkForBank1F
	cp BANK(Func_7d10d)
	jr nz, .bank20
	ld a, b
	call Func_7d10d
	jr .done
.bank20
	ld a,b
	call Func_82bd4
.done
	pop af
	call BankswitchCommon
	ret

