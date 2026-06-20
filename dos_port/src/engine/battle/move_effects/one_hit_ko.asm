%include "gb_memmap.inc"
%include "gb_macros.inc"

extern wDamage
extern wCriticalHitOrOHKO
extern wBattleMonSpeed
extern wEnemyMonSpeed
extern hWhoseTurn
extern wMoveMissed

section .text
global OneHitKOEffect_

OneHitKOEffect_:
	mov esi, wDamage
	xor al, al
	mov [ebp + esi], al
	inc esi
	mov [ebp + esi], al
	dec al
	mov [ebp + wCriticalHitOrOHKO], al
	mov esi, wBattleMonSpeed + 1
	mov edi, wEnemyMonSpeed + 1
	mov al, [ebp + hWhoseTurn]
	and al, al
	jz .compareSpeed
	mov esi, wEnemyMonSpeed + 1
	mov edi, wBattleMonSpeed + 1
.compareSpeed:
	mov al, [ebp + edi]
	dec edi
	mov bl, al
	mov al, [ebp + esi]
	dec esi
	sub al, bl
	mov al, [ebp + edi]
	mov bl, al
	mov al, [ebp + esi]
	sbb al, bl
	jc .userIsSlower
	mov esi, wDamage
	mov al, 0xff
	mov [ebp + esi], al
	inc esi
	mov [ebp + esi], al
	mov al, 0x2
	mov [ebp + wCriticalHitOrOHKO], al
	ret
.userIsSlower:
	mov al, 0x1
	mov [ebp + wMoveMissed], al
	ret
