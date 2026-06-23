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
	mov byte [ebp + esi], al
	inc esi
	mov byte [ebp + esi], al
	dec al
	mov byte [ebp + wCriticalHitOrOHKO], al
	mov esi, wBattleMonSpeed + 1
	mov edi, wEnemyMonSpeed + 1
	mov al, byte [ebp + hWhoseTurn]
	test al, al
	jz .compareSpeed
	mov esi, wEnemyMonSpeed + 1
	mov edi, wBattleMonSpeed + 1
.compareSpeed:
	mov al, byte [ebp + edi]
	dec edi
	mov bh, al
	mov al, byte [ebp + esi]
	dec esi
	sub al, bh
	mov al, byte [ebp + edi]
	mov bh, al
	mov al, byte [ebp + esi]
	sbb al, bh
	jc .userIsSlower
	mov esi, wDamage
	mov al, 0xff
	mov byte [ebp + esi], al
	inc esi
	mov byte [ebp + esi], al
	mov al, 0x02
	mov byte [ebp + wCriticalHitOrOHKO], al
	ret
.userIsSlower:
	mov al, 0x01
	mov byte [ebp + wMoveMissed], al
	ret
