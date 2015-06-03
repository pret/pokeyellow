FarCopyData:: ; 009d (0:009d)
; Copy bc bytes from a:hl to de.
	ld [wd122+1], a
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, [wd122+1]
	call BankswitchCommon
	call CopyData
	pop af
	call BankswitchCommon
	ret

CopyData:: ; 00b1 (0:00b1)
; Copy bc bytes from hl to de.
	ld a,b
	and a
	jr z, .copybytes
	ld a,c
	and a ; is lower byte 0
	jr z, .loop
	inc b ; if not, increment b as there are <$100 bytes to copy
.loop
	call .copybytes
	dec b
	jr nz,.loop
	ret
	
.copybytes	; 00c1
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .copybytes
	ret

CopyVideoData:: ; 00c8 (0:00c8)
	ld a, [rLCDC]
	bit 7,a ; LCD enabled?
	jp nz, CopyVideoDataLCDEnabled ; if yes, then copy video data
	push hl
	ld h,d
	ld l,e
	pop de
	ld a,b ; save bank
	push af
	swap c
	ld a,$f
	and c
	ld b,a
	ld a,$f0
	and c
	ld c,a
	pop af
	jp FarCopyData
	
CopyVideoDataDouble:: ; 00e3 (0:00e3)
	ld a, [rLCDC]
	bit 7,a ; LCD enabled?
	jp nz, CopyVideoDataDoubleLCDEnabled ; if yes, then copy video data
	push de
	ld d,h
	ld e,l
	ld a,b
	push af ; save bank to switch to
	ld h,$0
	ld l,c
	add hl,hl ; get raw length of bytes to copy
	add hl,hl
	add hl,hl
	ld b,h
	ld c,l
	pop af
	pop hl
	jp FarCopyDataDouble
