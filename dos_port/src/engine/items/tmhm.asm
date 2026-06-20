%include "dos_port/include/gb_memmap.inc"

SECTION .text

global CheckIfMoveIsKnown

; checks if the mon in [wWhichPokemon] already knows the move in [wMoveNum]
CheckIfMoveIsKnown:
	mov al, [ebp + wWhichPokemon]
	mov esi, wPartyMon1Moves
	mov cx, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	mov al, [ebp + wMoveNum]
	mov bh, al
	mov cl, NUM_MOVES
.loop:
	mov al, [ebp + esi]
	inc esi
	cmp al, bh
	je .alreadyKnown
	dec cl
	jnz .loop
	test al, al
	clc
	ret
.alreadyKnown:
	mov esi, AlreadyKnowsText
	call PrintText
	stc
	ret

AlreadyKnowsText:
	; text_far _AlreadyKnowsText
	; text_end
	ret
