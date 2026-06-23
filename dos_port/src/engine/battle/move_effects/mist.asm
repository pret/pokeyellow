%include "gb_memmap.inc"
%include "gb_macros.inc"

extern PlayCurrentMoveAnimation
extern PrintText
extern PrintButItFailedText_
extern _ShroudedInMistText
extern wPlayerBattleStatus2
extern hWhoseTurn
extern wEnemyBattleStatus2

section .text
global MistEffect_
global ShroudedInMistText

PROTECTED_BY_MIST equ 1

MistEffect_:
    mov esi, wPlayerBattleStatus2
    mov al, byte [ebp + hWhoseTurn]
    and al, al
    jz .mistEffect
    mov esi, wEnemyBattleStatus2
.mistEffect:
    test byte [ebp + esi], (1 << PROTECTED_BY_MIST)
    jnz .mistAlreadyInUse
    or byte [ebp + esi], (1 << PROTECTED_BY_MIST)
    call PlayCurrentMoveAnimation
    mov esi, ShroudedInMistText
    jmp PrintText
.mistAlreadyInUse:
    jmp PrintButItFailedText_

ShroudedInMistText:
	db 0x17 ; text_far
	dd _ShroudedInMistText
	db 0x50 ; text_end
