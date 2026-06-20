%include "gb_memmap.inc"

extern wDamage
extern wBattleMonHP
extern wBattleMonMaxHP
extern wEnemyMonHP
extern wEnemyMonMaxHP
extern wHPBarOldHP
extern wHPBarNewHP
extern wHPBarType
extern hWhoseTurn
extern wPlayerMoveEffect
extern wEnemyMoveEffect

extern UpdateHPBar2
extern DrawPlayerHUDAndHPBar
extern DrawEnemyHUDAndHPBar
extern ReadPlayerMonCurHPAndStatus
extern PrintText

DrainHPEffect_:
	mov esi, wDamage
	mov al, [ebp + esi]
	shr al, 1
	mov [ebp + esi], al
	inc esi
	mov al, [ebp + esi]
	rcr al, 1
	mov [ebp + esi], al
	dec esi
	or al, [ebp + esi]
	jnz .getAttackerHP
	inc esi
	inc byte [ebp + esi]

.getAttackerHP:
	mov esi, wBattleMonHP
	mov edx, wBattleMonMaxHP
	mov al, [ebp + hWhoseTurn]
	test al, al
	jz .addDamageToAttackerHP
	mov esi, wEnemyMonHP
	mov edx, wEnemyMonMaxHP

.addDamageToAttackerHP:
	mov ebx, wHPBarOldHP + 1
	mov al, [ebp + esi]
	mov [ebp + ebx], al
	inc esi
	mov al, [ebp + esi]
	dec ebx
	mov [ebp + ebx], al

	mov al, [ebp + edx]
	dec ebx
	mov [ebp + ebx], al
	inc edx
	mov al, [ebp + edx]
	dec ebx
	mov [ebp + ebx], al

	mov al, [ebp + wDamage + 1]
	mov bh, [ebp + esi]
	add al, bh
	mov [ebp + esi], al
	dec esi
	mov [ebp + wHPBarNewHP], al
	
	mov al, [ebp + wDamage]
	mov bh, [ebp + esi]
	adc al, bh
	mov [ebp + esi], al
	inc esi
	mov [ebp + wHPBarNewHP + 1], al
	jc .capToMaxHP

	mov al, [ebp + esi]
	dec esi
	mov bh, al
	mov al, [ebp + edx]
	dec edx
	sub al, bh
	mov al, [ebp + esi]
	inc esi
	mov bh, al
	mov al, [ebp + edx]
	inc edx
	sbb al, bh
	jnc .next

.capToMaxHP:
	mov al, [ebp + edx]
	mov [ebp + esi], al
	dec esi
	mov [ebp + wHPBarNewHP], al
	dec edx
	mov al, [ebp + edx]
	mov [ebp + esi], al
	inc esi
	mov [ebp + wHPBarNewHP + 1], al
	inc edx

.next:
	mov al, [ebp + hWhoseTurn]
	test al, al
	mov esi, W_TILEMAP + 9 * 20 + 10
	mov al, 1
	jz .next2
	mov esi, W_TILEMAP + 2 * 20 + 2
	xor al, al
.next2:
	mov [ebp + wHPBarType], al
	call UpdateHPBar2
	call DrawPlayerHUDAndHPBar
	call DrawEnemyHUDAndHPBar
	call ReadPlayerMonCurHPAndStatus
	
	mov esi, SuckedHealthText
	mov al, [ebp + hWhoseTurn]
	test al, al
	mov al, [ebp + wPlayerMoveEffect]
	jz .next3
	mov al, [ebp + wEnemyMoveEffect]
.next3:
	cmp al, 0x4B ; DREAM_EATER_EFFECT
	jnz .printText
	mov esi, DreamWasEatenText
.printText:
	jmp PrintText

SuckedHealthText:
	db 0x17
	dw 0
	db 0
	db 0x50

DreamWasEatenText:
	db 0x17
	dw 0
	db 0
	db 0x50
