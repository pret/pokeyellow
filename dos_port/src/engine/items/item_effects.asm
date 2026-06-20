; dos_port/engine/items/item_effects.asm
global Func_d85d
global WakeUpEntireParty
global RestorePPAmount
global ApplyHealingItem
global CureStatusAilment

extern EvosMovesPointerTable
extern wLoadedMon
extern wEvoDataBuffer
extern wCurItem
extern wMaxPP
extern wPPRestoreItem
extern wHPBarNewHP
extern wWereAnyMonsAsleep
extern FarCopyData

; Constants
extern EVOLVE_ITEM
extern MAX_ETHER
extern PP_MASK
extern PP_UP_MASK
extern REVIVE
extern HYPER_POTION
extern MAX_REVIVE
extern MON_MAXHP
extern MON_HP
extern PARTYMON_STRUCT_LENGTH
extern SLP_MASK
extern ANTIDOTE
extern BURN_HEAL
extern ICE_HEAL
extern AWAKENING
extern PARLYZ_HEAL
extern FULL_HEAL
extern PSN
extern BRN
extern FRZ
extern PAR

section .text

; Checks if an evolution stone works on the selected Pokemon
Func_d85d:
    movzx ecx, byte [ebp + wLoadedMon]
    dec ecx
    
    mov esi, EvosMovesPointerTable
    mov eax, ecx
    shl eax, 1 ; add hl, bc * 2
    add esi, eax
    
    mov dx, wEvoDataBuffer
    mov bx, 2
    call FarCopyData
    
    movzx esi, word [ebp + wEvoDataBuffer]
    mov dx, wEvoDataBuffer
    mov bx, 13
    call FarCopyData
    
    mov esi, wEvoDataBuffer
    
.loop:
    mov al, [ebp + esi]
    inc esi
    
    test al, al
    jz .cannotEvolveWithUsedStone
    
    inc esi
    inc esi
    
    cmp al, EVOLVE_ITEM
    jnz .loop
    
    dec esi
    dec esi
    
    mov bl, [ebp + esi]
    mov al, [ebp + wCurItem]
    
    inc esi
    inc esi
    inc esi
    
    cmp al, bl
    jnz .loop
    
    stc
    ret

.cannotEvolveWithUsedStone:
    clc
    ret

; INPUT:
; ESI (HL) = points to status of first pokemon in party
; BL (B) = ~SLP_MASK
; ECX (C) = PARTY_LENGTH
; OUTPUT:
; wWereAnyMonsAsleep set to 1 if any woke up
WakeUpEntireParty:
    movzx edx, word PARTYMON_STRUCT_LENGTH
.loop:
    mov al, [ebp + esi]
    push ax
    and al, SLP_MASK
    jz .notAsleep
    mov al, 1
    mov [ebp + wWereAnyMonsAsleep], al
.notAsleep:
    pop ax
    and al, bl
    mov [ebp + esi], al
    add esi, edx
    dec ecx
    jnz .loop
    ret

; INPUT:
; ESI (HL) = points to move's PP
; [wMaxPP] = max PP of this move
; [wPPRestoreItem] = which item
RestorePPAmount:
    mov al, [ebp + wMaxPP]
    mov bl, al
    mov al, [ebp + wPPRestoreItem]
    cmp al, MAX_ETHER
    jz .fullyRestorePP
    
    mov al, [ebp + esi]
    and al, PP_MASK
    cmp al, bl
    jz .ret
    
    add al, 10
    cmp al, bl
    jnc .storeNewAmount
    mov bl, al
.storeNewAmount:
    mov al, [ebp + esi]
    and al, PP_UP_MASK
    add al, bl
    mov [ebp + esi], al
.ret:
    ret

.fullyRestorePP:
    ; Intentionally reproducing original bug where upper bits are not masked
    mov al, [ebp + esi]
    cmp al, bl
    jz .ret
    jmp .storeNewAmount

; INPUT:
; ESI (HL) = LSB of current HP
; BL (B) = amount to heal
ApplyHealingItem:
    mov al, [ebp + esi]
    add al, bl
    mov [ebp + esi], al
    mov [ebp + wHPBarNewHP], al
    
    dec esi ; point to MSB
    mov al, [ebp + esi]
    mov [ebp + wHPBarNewHP+1], al
    jnc .noCarry
    inc al
    mov [ebp + esi], al
    mov [ebp + wHPBarNewHP+1], al
.noCarry:
    inc esi ; back to LSB
    mov edx, esi
    
    mov ecx, edx
    add ecx, (MON_MAXHP + 1) - (MON_HP + 1) ; ECX points to LSB of max HP
    
    mov al, [ebp + wCurItem]
    cmp al, REVIVE
    jz .setCurrentHPToHalfMaxHP
    
    ; compare current HP with max HP
    mov al, [ebp + ecx] ; LSB of Max HP
    mov bl, al
    mov al, [ebp + edx] ; LSB of Current HP
    sub al, bl
    dec ecx ; point to MSB of Max HP
    dec edx ; point to MSB of Current HP
    mov bl, [ebp + ecx] ; MSB of Max HP
    mov al, [ebp + edx] ; MSB of Current HP
    sbc al, bl
    jnc .setCurrentHPToMaxHp
    
    mov al, [ebp + wCurItem]
    cmp al, HYPER_POTION
    jc .setCurrentHPToMaxHp
    cmp al, MAX_REVIVE
    jz .setCurrentHPToMaxHp
    ret

.setCurrentHPToHalfMaxHP:
    dec ecx ; point to MSB of Max HP
    dec edx ; point to MSB of Current HP
    mov al, [ebp + ecx]
    shr al, 1
    mov [ebp + edx], al
    mov [ebp + wHPBarNewHP+1], al
    inc ecx ; point to LSB
    inc edx ; point to LSB
    mov al, [ebp + ecx]
    rcr al, 1
    mov [ebp + edx], al
    mov [ebp + wHPBarNewHP], al
    ret

.setCurrentHPToMaxHp:
    mov al, [ebp + ecx] ; MSB of Max HP
    mov [ebp + edx], al
    mov [ebp + wHPBarNewHP+1], al
    inc ecx ; LSB
    inc edx ; LSB
    mov al, [ebp + ecx]
    mov [ebp + edx], al
    mov [ebp + wHPBarNewHP], al
    ret

; INPUT:
; ESI (HL) = points to Pokemon's status byte
CureStatusAilment:
    mov al, [ebp + wCurItem]
    mov cl, (1 << PSN)
    cmp al, ANTIDOTE
    jz .checkMonStatus
    mov cl, (1 << BRN)
    cmp al, BURN_HEAL
    jz .checkMonStatus
    mov cl, (1 << FRZ)
    cmp al, ICE_HEAL
    jz .checkMonStatus
    mov cl, SLP_MASK
    cmp al, AWAKENING
    jz .checkMonStatus
    mov cl, (1 << PAR)
    cmp al, PARLYZ_HEAL
    jz .checkMonStatus
    mov cl, 0xff ; FULL_HEAL
.checkMonStatus:
    mov al, [ebp + esi]
    and al, cl
    jz .noEffect
    xor al, al
    mov [ebp + esi], al
    stc
    ret
.noEffect:
    clc
    ret
