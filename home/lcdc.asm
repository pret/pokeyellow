LCDC:: ; 15ac (0:15ac)
	push af
	ld a,[hLCDCPointer] ; doubles as enabling byte
	and a
	jr z,.noLCDCInterrupt
	push hl
	ld a,[rLY]
	ld l,a
	ld h,$c7
	ld h,[hl] ; h != not part of pointer
	ld a,[hLCDCPointer]
	ld l,a
	ld a,h
	ld h,$ff
	ld [hl],a
	pop hl
.noLCDCInterrupt
	pop af
	reti