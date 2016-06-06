VBlank:: ; 1de5 (0:1de5)

	push af
	push bc
	push de
	push hl

	ld a, [rVBK] ; vram bank
	push af
	xor a
	ld [rVBK], a ; reset vram bank to 0

	ld a, [H_LOADEDROMBANK]
	ld [wVBlankSavedROMBank], a

	ld a, [hSCX]
	ld [rSCX], a
	ld a, [hSCY]
	ld [rSCY], a

	ld a, [wDisableVBlankWYUpdate]
	and a
	jr nz, .ok
	ld a, [hWY]
	ld [rWY], a
.ok

	call AutoBgMapTransfer
	call VBlankCopyBgMap
	call RedrawRowOrColumn
	call VBlankCopy
	call VBlankCopyDouble
	call UpdateMovingBgTiles
	call $ff80 ; hOAMDMA
	ld a, BANK(PrepareOAMData)
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	call PrepareOAMData

	; VBlank-sensitive operations end.
	call TrackPlayTime ; keep track of time played

	call Random
	call ReadJoypad

	ld a, [H_VBLANKOCCURRED]
	and a
	jr z, .skipZeroing
	xor a
	ld [H_VBLANKOCCURRED], a

.skipZeroing
	ld a, [H_FRAMECOUNTER]
	and a
	jr z, .skipDec
	dec a
	ld [H_FRAMECOUNTER], a
.skipDec

	call FadeOutAudio

	callbs Music_DoLowHealthAlarm
	callbs Audio1_UpdateMusic

	call SerialFunction

	ld a, [wVBlankSavedROMBank]
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a

	pop af
	ld [rVBK],a

	pop hl
	pop de
	pop bc
	pop af
	reti


DelayFrame:: ; 1e64 (0:1e64)
; Wait for the next vblank interrupt.
; As a bonus, this saves battery.

NOT_VBLANKED EQU 1

	ld a, NOT_VBLANKED
	ld [H_VBLANKOCCURRED], a
.halt
	halt
	ld a, [H_VBLANKOCCURRED]
	and a
	jr nz, .halt
	ret
