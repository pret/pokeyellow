FarCopyDataDouble:: ; 15d4 (0:15d4)
; Expand bc bytes of 1bpp image data
; from a:de to 2bpp data at hl.
	ld [wd122+1],a
	ld a,[H_LOADEDROMBANK]
	push af
	ld a,[wd122+1]
	call BankswitchCommon
	ld a,h ; swap hl and de
	ld h,d
	ld d,a
	ld a,l
	ld l,e
	ld e,a
	ld a,b
	and a
	jr z,.8bitcopyamount
	ld a,c
	and a ; multiple of $100
	jr z, .expandloop ; if so, do not increment b because the first instance of dec c results in underflow
.8bitcopyamount
	inc b
.expandloop
	ld a,[de]
	inc de
	ld [hli],a
	ld [hli],a
	inc de
	dec c
	jr nz, .expandloop
	dec b
	jr nz, .expandloop
	pop af
	call BankswitchCommon
	ret

CopyVideoDataLCDEnabled:: ; 
; Wait for the next VBlank, then copy c 2bpp
; tiles from b:de to hl, 8 tiles at a time.
; This takes c/8 frames.

	ld a, [H_AUTOBGTRANSFERENABLED]
	push af
	xor a ; disable auto-transfer while copying
	ld [H_AUTOBGTRANSFERENABLED], a

	ld a, [H_LOADEDROMBANK]
	push af

	ld a, b
	call BankswitchCommon

	ld a, e
	ld [H_VBCOPYSRC], a
	ld a, d
	ld [H_VBCOPYSRC + 1], a

	ld a, l
	ld [H_VBCOPYDEST], a
	ld a, h
	ld [H_VBCOPYDEST + 1], a

.loop
	ld a, c
	cp 8
	jr nc, .keepgoing

.done
	ld [H_VBCOPYSIZE], a
	call DelayFrame
	pop af
	call CommonBankswitch
	pop af
	ld [H_AUTOBGTRANSFERENABLED], a
	ret

.keepgoing
	ld a, 8
	ld [H_VBCOPYSIZE], a
	call DelayFrame
	ld a, c
	sub 8
	ld c, a
	jr .loop

CopyVideoDataDoubleLCDEnabled::
; Wait for the next VBlank, then copy c 1bpp
; tiles from b:de to hl, 8 tiles at a time.
; This takes c/8 frames.
	ld a, [H_AUTOBGTRANSFERENABLED]
	push af
	xor a ; disable auto-transfer while copying
	ld [H_AUTOBGTRANSFERENABLED], a
	ld a, [H_LOADEDROMBANK]
	push af

	ld a, b
	call BankswitchCommon

	ld a, e
	ld [H_VBCOPYDOUBLESRC], a
	ld a, d
	ld [H_VBCOPYDOUBLESRC + 1], a

	ld a, l
	ld [H_VBCOPYDOUBLEDEST], a
	ld a, h
	ld [H_VBCOPYDOUBLEDEST + 1], a

.loop
	ld a, c
	cp 8
	jr nc, .keepgoing

.done
	ld [H_VBCOPYDOUBLESIZE], a
	call DelayFrame
	pop af
	call BankswitchCommon
	pop af
	ld [H_AUTOBGTRANSFERENABLED], a
	ret

.keepgoing
	ld a, 8
	ld [H_VBCOPYDOUBLESIZE], a
	call DelayFrame
	ld a, c
	sub 8
	ld c, a
	jr .loop

FillMemory:: ; 166e (0:166e)
	push af
	ld a,b
	and a
	jr z, .8bitcopyamount
	ld a,c
	and a
	jr z, .mulitpleof$100
.8bitcopyamount
	inc b
.multipleof$100
	pop af
.loop
	ld [hli],a
	dec c
	jr nz, .loop
	dec b
	jr nz, .loop
	ret
	
Func_1681:: ; 1681 (0:1681)
	push bc
	ld b,a
	ld a, [H_LOADEDROMBANK]
	push af
	ld a,b
	call BankswitchCommon
	ld b,[hl]
	pop af
	call BankswitchCommon
	ld a,b
	pop bc
	ret

ClearScreenArea:: ; 1692 (0:1692)
; Clear tilemap area cxb at hl.
	ld a, $7f ; blank tile
	ld de, 20 ; screen width
.y
	push hl
	push bc
.x
	ld [hli], a
	dec c
	jr nz, .x
	pop bc
	pop hl
	add hl, de
	dec b
	jr nz, .y
	ret

CopyScreenTileBufferToVRAM:: ; 16a4
; Copy wTileMap to the BG Map starting at b * $100.
; This is done in thirds of 6 rows, so it takes 3 frames.

	ld c, 6

	ld hl, $600 * 0
	ld de, wTileMap + 20 * 6 * 0
	call .setup
	call DelayFrame

	ld hl, $600 * 1
	ld de, wTileMap + 20 * 6 * 1
	call .setup
	call DelayFrame

	ld hl, $600 * 2
	ld de, wTileMap + 20 * 6 * 2
	call .setup
	jp DelayFrame

.setup
	ld a, d
	ld [H_VBCOPYBGSRC+1], a
	call GetRowColAddressBgMap
	ld a, l
	ld [H_VBCOPYBGDEST], a
	ld a, h
	ld [H_VBCOPYBGDEST+1], a
	ld a, c
	ld [H_VBCOPYBGNUMROWS], a
	ld a, e
	ld [H_VBCOPYBGSRC], a
	ret

ClearScreen::
; Clear wTileMap, then wait
; for the bg map to update.
	ld bc, 20 * 18
	inc b
	ld hl, wTileMap
	ld a, $7f
.loop
	ld [hli], a
	dec c
	jr nz, .loop
	dec b
	jr nz, .loop
	jp Delay3
