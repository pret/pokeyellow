%include "gb_memmap.inc"
%include "gb_macros.inc"

extern hWhoseTurn
extern wPlayerMoveNum
extern wBattleMonMaxHP
extern wEnemyMoveNum
extern wEnemyMonMaxHP
extern wDamage
extern wBattleMonHP
extern wHPBarMaxHP
extern wHPBarOldHP
extern wHPBarNewHP
extern wTileMap
extern wHPBarType
extern predef_UpdateHPBar2
extern PrintText
extern _HitWithRecoilText

STRUGGLE equ 0xA5

global RecoilEffect_
RecoilEffect_:
    mov al, [ebp + hWhoseTurn]
    and al, al
    mov al, [ebp + wPlayerMoveNum]
    mov esi, wBattleMonMaxHP
    jz .recoilEffect
    mov al, [ebp + wEnemyMoveNum]
    mov esi, wEnemyMonMaxHP

.recoilEffect:
    mov dh, al
    mov al, [ebp + wDamage]
    mov bh, al
    mov al, [ebp + wDamage + 1]
    mov bl, al
    shr bh, 1
    rcr bl, 1
    mov al, dh
    cmp al, STRUGGLE
    jz .gotRecoilDamage
    shr bh, 1
    rcr bl, 1

.gotRecoilDamage:
    mov al, bh
    or al, bl
    jnz .updateHP
    inc bl

.updateHP:
    mov al, [ebp + esi]
    inc esi
    mov [ebp + wHPBarMaxHP + 1], al
    mov al, [ebp + esi]
    mov [ebp + wHPBarMaxHP], al
    
    push ebx
    mov ebx, wBattleMonHP
    sub ebx, wBattleMonMaxHP
    add esi, ebx
    pop ebx
    
    mov al, [ebp + esi]
    mov [ebp + wHPBarOldHP], al
    sub al, bl
    mov [ebp + esi], al
    dec esi
    mov [ebp + wHPBarNewHP], al
    
    mov al, [ebp + esi]
    mov [ebp + wHPBarOldHP + 1], al
    sbb al, bh
    mov [ebp + esi], al
    mov [ebp + wHPBarNewHP + 1], al
    jnc .getHPBarCoords
    
    xor al, al
    mov [ebp + esi], al
    inc esi
    mov [ebp + esi], al
    mov esi, wHPBarNewHP
    mov [ebp + esi], al
    inc esi
    mov [ebp + esi], al

.getHPBarCoords:
    mov esi, wTileMap + 9 * 20 + 10
    mov al, [ebp + hWhoseTurn]
    and al, al
    mov al, 1
    jz .updateHPBar
    mov esi, wTileMap + 2 * 20 + 2
    xor al, al

.updateHPBar:
    mov [ebp + wHPBarType], al
    call predef_UpdateHPBar2
    mov esi, HitWithRecoilText
    jmp PrintText

global HitWithRecoilText
HitWithRecoilText:
    db 0x17 ; TX_FAR
    dd _HitWithRecoilText
    db 0x50 ; TX_END
