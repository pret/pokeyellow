PrintWaitingText::
	hlcoord 3, 10
	lb bc, 1, 11
	ld a, [wIsInBattle]
	and a
	jr z, .asm_4b9a
	call TextBoxBorder
	jr .asm_4b9d
.asm_4b9a
	call CableClub_TextBoxBorder
.asm_4b9d
	hlcoord 4, 11
	ld de, WaitingText
	call PlaceString
	ld c, 50
	jp DelayFrames

WaitingText:
	db "Waiting...!@"
