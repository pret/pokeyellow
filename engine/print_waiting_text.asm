PrintWaitingText: ; 4b89 (1:4b89)
	coord hl, 3, 10
	lb bc, 1, 11
	ld a, [wIsInBattle]
	and a
	jr z, .asm_4b9a
	call TextBoxBorder
	jr .asm_4b9d
.asm_4b9a
	call CableClub_TextBoxBorder
.asm_4b9d
	coord hl, 4, 11
	ld de, WaitingText
	call PlaceString
	ld c, 50
	jp DelayFrames

WaitingText: ; 4bab (1:4bab)
	db "Waiting...!@"