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
    mov al, byte [ebp + hWhoseTurn]
    and al, al
    mov edi, wBattleMonHP
    mov esi, wBattleMonMaxHP
    mov al, byte [ebp + wPlayerMoveNum]
    jz .healEffect
    mov edi, wEnemyMonHP
    mov esi, wEnemyMonMaxHP
    mov al, byte [ebp + wEnemyMoveNum]
.healEffect:
    mov bh, al
    mov al, byte [ebp + edi]
    cmp al, byte [ebp + esi]
    inc edi
    inc esi
    mov al, byte [ebp + edi]
    sbb al, byte [ebp + esi]
    jz .failed
    mov al, bh
    cmp al, MOVE_REST
    jnz .healHP
    push esi
    push edi
    pushfd
    push eax
    
    mov cl, 50
    call DelayFrames
    
    mov esi, wBattleMonStatus
    mov al, byte [ebp + hWhoseTurn]
    and al, al
    jz .restEffect
    mov esi, wEnemyMonStatus
.restEffect:
    mov al, byte [ebp + esi]
    and al, al
    mov byte [ebp + esi], 2 ; clear status and set number of turns asleep to 2
    mov esi, StartedSleepingEffect
    jz .printRestText
    mov esi, FellAsleepBecameHealthyText
.printRestText:
    call PrintText
    
    pop eax
    popfd
    pop edi
    pop esi
    
.healHP:
    mov al, byte [ebp + esi]
    dec esi
    mov byte [ebp + wHPBarMaxHP], al
    mov cl, al
    mov al, byte [ebp + esi]
    mov byte [ebp + wHPBarMaxHP+1], al
    mov bh, al
    jz .gotHPAmountToHeal
    shr bh, 1
    rcr cl, 1
.gotHPAmountToHeal:
    mov al, byte [ebp + edi]
    mov byte [ebp + wHPBarOldHP], al
    add al, cl
    mov byte [ebp + edi], al
    mov byte [ebp + wHPBarNewHP], al
    dec edi
    mov al, byte [ebp + edi]
    mov byte [ebp + wHPBarOldHP+1], al
    adc al, bh
    mov byte [ebp + edi], al
    mov byte [ebp + wHPBarNewHP+1], al
    inc esi
    inc edi
    mov al, byte [ebp + edi]
    dec edi
    sub al, byte [ebp + esi]
    dec esi
    mov al, byte [ebp + edi]
    sbb al, byte [ebp + esi]
    jc .playAnim
    mov al, byte [ebp + esi]
    inc esi
    mov byte [ebp + edi], al
    mov byte [ebp + wHPBarNewHP+1], al
    inc edi
    mov al, byte [ebp + esi]
    mov byte [ebp + edi], al
    mov byte [ebp + wHPBarNewHP], al
.playAnim:
    mov esi, PlayCurrentMoveAnimation
    call EffectCallBattleCore
    mov al, byte [ebp + hWhoseTurn]
    and al, al
    mov esi, W_TILEMAP + 9 * SCREEN_WIDTH + 10
    mov al, 1
    jz .updateHPBar
    mov esi, W_TILEMAP + 2 * SCREEN_WIDTH + 2
    xor al, al
.updateHPBar:
    mov byte [ebp + wHPBarType], al
    call UpdateHPBar2
    mov esi, DrawHUDsAndHPBars
    call EffectCallBattleCore
    mov esi, RegainedHealthText
    jmp PrintText
.failed:
    mov cl, 50
    call DelayFrames
    mov esi, PrintButItFailedText_
    jmp EffectCallBattleCore


extern _StartedSleepingEffect
StartedSleepingEffect:
    db 0x0A ; TX_PAUSE
    db 0x17 ; TX_FAR
    dd _StartedSleepingEffect
    db 0x50 ; TX_END


extern _FellAsleepBecameHealthyText
FellAsleepBecameHealthyText:
    db 0x0A ; TX_PAUSE
    db 0x17 ; TX_FAR
    dd _FellAsleepBecameHealthyText
    db 0x50 ; TX_END


extern _RegainedHealthText
RegainedHealthText:
    db 0x0A ; TX_PAUSE
    db 0x17 ; TX_FAR
    dd _RegainedHealthText
    db 0x50 ; TX_END

