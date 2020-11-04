IsTilePassable::
; sets carry if tile is passable, resets carry otherwise
	homecall_sf _IsTilePassable
	ret

FarCopyDataDouble::
; Expand bc bytes of 1bpp image data
; from a:de to 2bpp data at hl.
	ld [wFarCopyDataSavedROMBank], a
	ldh a, [hLoadedROMBank]
	push af
	ld a, [wFarCopyDataSavedROMBank]
	call BankswitchCommon
	ld a, h ; swap hl and de
	ld h, d
	ld d, a
	ld a, l
	ld l, e
	ld e, a
	ld a, b
	and a
	jr z, .eightbitcopyamount
	ld a, c
	and a ; multiple of $100
	jr z, .expandloop ; if so, do not increment b because the first instance of dec c results in underflow
.eightbitcopyamount
	inc b
.expandloop
	ld a, [de]
	inc de
	ld [hli], a
	ld [hli], a
	dec c
	jr nz, .expandloop
	dec b
	jr nz, .expandloop
	pop af
	call BankswitchCommon
	ret

CopyVideoData::
; Wait for the next VBlank, then copy c 2bpp
; tiles from b:de to hl, 8 tiles at a time.
; This takes c/8 frames.

	ldh a, [hAutoBGTransferEnabled]
	push af
	xor a ; disable auto-transfer while copying
	ldh [hAutoBGTransferEnabled], a

	ldh a, [hLoadedROMBank]
	push af

	ld a, b
	call BankswitchCommon

	ld a, e
	ldh [hVBlankCopySource], a
	ld a, d
	ldh [hVBlankCopySource + 1], a

	ld a, l
	ldh [hVBlankCopyDest], a
	ld a, h
	ldh [hVBlankCopyDest + 1], a

.loop
	ld a, c
	cp 8
	jr nc, .keepgoing

.done
	ldh [hVBlankCopySize], a
	call DelayFrame
	pop af
	call BankswitchCommon
	pop af
	ldh [hAutoBGTransferEnabled], a
	ret

.keepgoing
	ld a, 8
	ldh [hVBlankCopySize], a
	call DelayFrame
	ld a, c
	sub 8
	ld c, a
	jr .loop

CopyVideoDataDouble::
; Wait for the next VBlank, then copy c 1bpp
; tiles from b:de to hl, 8 tiles at a time.
; This takes c/8 frames.
	ldh a, [hAutoBGTransferEnabled]
	push af
	xor a ; disable auto-transfer while copying
	ldh [hAutoBGTransferEnabled], a
	ldh a, [hLoadedROMBank]
	push af

	ld a, b
	call BankswitchCommon

	ld a, e
	ldh [hVBlankCopyDoubleSource], a
	ld a, d
	ldh [hVBlankCopyDoubleSource + 1], a

	ld a, l
	ldh [hVBlankCopyDoubleDest], a
	ld a, h
	ldh [hVBlankCopyDoubleDest + 1], a

.loop
	ld a, c
	cp 8
	jr nc, .keepgoing

.done
	ldh [hVBlankCopyDoubleSize], a
	call DelayFrame
	pop af
	call BankswitchCommon
	pop af
	ldh [hAutoBGTransferEnabled], a
	ret

.keepgoing
	ld a, 8
	ldh [hVBlankCopyDoubleSize], a
	call DelayFrame
	ld a, c
	sub 8
	ld c, a
	jr .loop

FillMemory::
	push af
	ld a, b
	and a
	jr z, .eightbitcopyamount
	ld a, c
	and a
	jr z, .mulitpleof0x100
.eightbitcopyamount
	inc b
.mulitpleof0x100
	pop af
.loop
	ld [hli], a
	dec c
	jr nz, .loop
	dec b
	jr nz, .loop
	ret

GetFarByte::
; get a byte from a:hl
; and return it in a
	push bc
	ld b, a
	ldh a, [hLoadedROMBank]
	push af
	ld a, b
	call BankswitchCommon
	ld b, [hl]
	pop af
	call BankswitchCommon
	ld a, b
	pop bc
	ret

ClearScreenArea::
; Clear tilemap area cxb at hl.
	ld a, " " ; blank tile
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

CopyScreenTileBufferToVRAM::
; Copy wTileMap to the BG Map starting at b * $100.
; This is done in thirds of 6 rows, so it takes 3 frames.

	ld c, 6

	ld hl, $600 * 0
	decoord 0, 6 * 0
	call .setup
	call DelayFrame

	ld hl, $600 * 1
	decoord 0, 6 * 1
	call .setup
	call DelayFrame

	ld hl, $600 * 2
	decoord 0, 6 * 2
	call .setup
	jp DelayFrame

.setup
	ld a, d
	ldh [hVBlankCopyBGSource+1], a
	call GetRowColAddressBgMap
	ld a, l
	ldh [hVBlankCopyBGDest], a
	ld a, h
	ldh [hVBlankCopyBGDest+1], a
	ld a, c
	ldh [hVBlankCopyBGNumRows], a
	ld a, e
	ldh [hVBlankCopyBGSource], a
	ret

ClearScreen::
; Clear wTileMap, then wait
; for the bg map to update.
	ld bc, 20 * 18
	inc b
	hlcoord 0, 0
	ld a, " "
.loop
	ld [hli], a
	dec c
	jr nz, .loop
	dec b
	jr nz, .loop
	jp Delay3
