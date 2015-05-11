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
