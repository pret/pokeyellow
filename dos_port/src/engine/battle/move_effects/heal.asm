%include "gb_memmap.inc"
%include "gb_macros.inc"


extern hWhoseTurn
extern wBattleMonHP
extern wBattleMonMaxHP
extern wPlayerMoveNum
extern wEnemyMonHP
extern wEnemyMonMaxHP
extern wEnemyMoveNum
extern wBattleMonStatus
extern wEnemyMonStatus
extern wHPBarMaxHP
extern wHPBarOldHP
extern wHPBarNewHP
extern wHPBarType
extern PlayCurrentMoveAnimation
extern EffectCallBattleCore
extern UpdateHPBar2
extern DrawHUDsAndHPBars
extern DelayFrames
extern PrintButItFailedText_
extern PrintText
extern StartedSleepingEffect
extern FellAsleepBecameHealthyText
extern RegainedHealthText

MOVE_REST equ 44

section .text
global HealEffect_

HealEffect_:
	mov al, [ebp + hWhoseTurn]
	test al, al
	mov edi, wBattleMonHP
	mov esi, wBattleMonMaxHP
	mov al, [ebp + wPlayerMoveNum]
	jz .healEffect
	mov edi, wEnemyMonHP
	mov esi, wEnemyMonMaxHP
	mov al, [ebp + wEnemyMoveNum]

.healEffect:
	mov bh, al

; BUG(cosmetic): most significant bytes comparison is ignored
; causes the move to miss if max HP is 255 or 511 points higher than the current HP — pret ref: engine/battle/move_effects/heal.asm:HealEffect_
%if BUG_FIX_LEVEL >= 2
	mov ah, [ebp + edi]
	cmp ah, [ebp + esi]
	jne .notMaxHp
	mov ah, [ebp + edi + 1]
	cmp ah, [ebp + esi + 1]
	je .failed
.notMaxHp:
	inc edi
	inc esi
%else
	mov al, [ebp + edi]
	cmp al, [ebp + esi]
	inc edi
	inc esi
	mov al, [ebp + edi]
	sbb al, [ebp + esi]
	jz .failed
%endif

	mov al, bh
	cmp al, 156 ; REST
	jne .healHP

	push esi
	push edi
	push eax
	mov bl, 50
	call DelayFrames
	mov esi, wBattleMonStatus
	mov al, [ebp + hWhoseTurn]
	test al, al
	jz .restEffect
	mov esi, wEnemyMonStatus

.restEffect:
	mov al, [ebp + esi]
	test al, al
	mov byte [ebp + esi], 2
	mov esi, StartedSleepingEffect
	jz .printRestText
	mov esi, FellAsleepBecameHealthyText

.printRestText:
	call PrintText
	pop eax
	pop edi
	pop esi

.healHP:
	mov al, [ebp + esi]
	dec esi
	mov [ebp + wHPBarMaxHP], al
	mov bl, al
	mov al, [ebp + esi]
	mov [ebp + wHPBarMaxHP+1], al
	mov bh, al

	test al, al
	jz .gotHPAmountToHeal

	shr bh, 1
	rcr bl, 1

.gotHPAmountToHeal:
	mov al, [ebp + edi]
	mov [ebp + wHPBarOldHP], al
	add al, bl
	mov [ebp + edi], al
	mov [ebp + wHPBarNewHP], al
	dec edi
	mov al, [ebp + edi]
	mov [ebp + wHPBarOldHP+1], al
	adc al, bh
	mov [ebp + edi], al
	mov [ebp + wHPBarNewHP+1], al

	inc esi
	inc edi
	mov al, [ebp + edi]
	dec edi
	sub al, [ebp + esi]
	dec esi
	mov al, [ebp + edi]
	sbb al, [ebp + esi]
	jc .playAnim

	mov al, [ebp + esi]
	inc esi
	mov [ebp + edi], al
	mov [ebp + wHPBarNewHP+1], al
	inc edi
	mov al, [ebp + esi]
	mov [ebp + edi], al
	mov [ebp + wHPBarNewHP], al

.playAnim:
	mov esi, PlayCurrentMoveAnimation
	call EffectCallBattleCore
	mov al, [ebp + hWhoseTurn]
	test al, al
	mov esi, W_TILEMAP + 9 * SCREEN_WIDTH + 10
	mov al, 1
	jz .updateHPBar
	mov esi, W_TILEMAP + 2 * SCREEN_WIDTH + 2
	xor al, al

.updateHPBar:
	mov [ebp + wHPBarType], al
	call UpdateHPBar2
	mov esi, DrawHUDsAndHPBars
	call EffectCallBattleCore
	mov esi, RegainedHealthText
	jmp PrintText

.failed:
	mov bl, 50
	call DelayFrames
	mov esi, PrintButItFailedText_
	jmp EffectCallBattleCore


extern _StartedSleepingEffect
StartedSleepingEffect:
	db 0x17 ; TX_FAR
	dd _StartedSleepingEffect
	db 0x50 ; TX_END

extern _FellAsleepBecameHealthyText
FellAsleepBecameHealthyText:
	db 0x17
	dd _FellAsleepBecameHealthyText
	db 0x50

extern _RegainedHealthText
RegainedHealthText:
	db 0x17
	dd _RegainedHealthText
	db 0x50

