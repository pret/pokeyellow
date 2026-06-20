%include "gb_memmap.inc"
%include "gb_macros.inc"

extern wPlayerBattleStatus2
extern hWhoseTurn
extern wEnemyBattleStatus2
extern PlayCurrentMoveAnimation
extern PrintText
extern DelayFrames
extern PrintButItFailedText_
extern _GettingPumpedText

GETTING_PUMPED equ 2

section .text
global FocusEnergyEffect_
global GettingPumpedText

FocusEnergyEffect_:
	mov esi, wPlayerBattleStatus2
	mov al, byte [ebp + hWhoseTurn]
	test al, al
	jz .notEnemy
	mov esi, wEnemyBattleStatus2
.notEnemy:
	bt dword [ebp + esi], GETTING_PUMPED
	jc .alreadyUsing
	bts dword [ebp + esi], GETTING_PUMPED
	call PlayCurrentMoveAnimation
	mov esi, GettingPumpedText
	jmp PrintText
.alreadyUsing:
	mov cl, 50
	call DelayFrames
	jmp PrintButItFailedText_

GettingPumpedText:
    db 0x0A ; TX_PAUSE
    db 0x17 ; TX_FAR
    dd _GettingPumpedText
    db 0x50 ; TX_END
