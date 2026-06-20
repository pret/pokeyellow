%include "dos_port/include/gb_memmap.inc"

SECTION .text

global DecrementPP
global DecrementPP_DecrementPP

; after using a move, decrement pp in battle and (if not transformed?) in party
DecrementPP:
	; ld a, [de]
	movzx edx, dx
	mov al, [ebp + edx]

	; cp STRUGGLE
	; STRUGGLE is a constant
	cmp al, STRUGGLE
	je .done

	; ld hl, wPlayerBattleStatus1
	mov esi, wPlayerBattleStatus1

	; ld a, [hli]
	mov al, [ebp + esi]
	inc esi

	; and (1 << STORING_ENERGY) | (1 << THRASHING_ABOUT) | (1 << ATTACKING_MULTIPLE_TIMES)
	test al, (1 << STORING_ENERGY) | (1 << THRASHING_ABOUT) | (1 << ATTACKING_MULTIPLE_TIMES)
	jnz .done

	; bit USING_RAGE, [hl]
	; USING_RAGE is a bit index, we use test al, (1 << USING_RAGE)
	mov al, [ebp + esi]
	test al, (1 << USING_RAGE)
	jnz .done

	; ld hl, wBattleMonPP
	mov esi, wBattleMonPP

	; call .DecrementPP
	call DecrementPP_DecrementPP

	; ld a, [wPlayerBattleStatus3]
	mov al, [ebp + wPlayerBattleStatus3]

	; bit TRANSFORMED, a
	test al, (1 << TRANSFORMED)
	jnz .done

	; ld hl, wPartyMon1PP
	mov esi, wPartyMon1PP

	; ld a, [wPlayerMonNumber]
	mov al, [ebp + wPlayerMonNumber]

	; ld bc, PARTYMON_STRUCT_LENGTH
	mov cx, PARTYMON_STRUCT_LENGTH

	; call AddNTimes
	; Since we don't know if AddNTimes is ported directly or if we should inline it,
	; we'll call it. But inlining is also very easy:
	; ESI += AL * CX
	; Let's just call the AddNTimes ported function.
	call AddNTimes

DecrementPP_DecrementPP:
	; ld a, [wPlayerMoveListIndex]
	mov al, [ebp + wPlayerMoveListIndex]

	; ld c, a
	; ld b, 0
	; add hl, bc
	movzx ecx, al
	add esi, ecx

	; dec [hl]
	dec byte [ebp + esi]

.done:
	ret
