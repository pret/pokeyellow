; dos_port/engine/menus/save.asm
global CalcCheckSum
global SaveMainData

extern EnableSRAM
extern DisableSRAM
extern CopyData
extern rRAMB
extern wPlayerName
extern sPlayerName
extern NAME_LENGTH
extern wMainDataStart
extern wMainDataEnd
extern sMainData
extern wSpriteDataStart
extern wSpriteDataEnd
extern sSpriteData
extern wBoxDataStart
extern wBoxDataEnd
extern sCurBoxData
extern hTileAnimations
extern sTileAnimations
extern sGameData
extern sGameDataEnd
extern sMainDataCheckSum

section .text

; Check Sum (result[1 byte] is complemented)
; INPUT:
; ESI (HL) = data pointer
; CX (BC) = length
; OUTPUT:
; AL (A) = checksum
CalcCheckSum:
    movzx ecx, cx
    test ecx, ecx
    jz .done_empty
    
    xor dl, dl
.loop:
    mov al, [ebp + esi]
    inc esi
    add dl, al
    dec ecx
    jnz .loop
    
    mov al, dl
    not al
    ret
.done_empty:
    xor al, al
    not al
    ret

; Saves main data arrays to SRAM
SaveMainData:
    call EnableSRAM
    
    mov al, 1 ; BANK("Save Data")
    mov [ebp + rRAMB], al
    
    mov esi, wPlayerName
    mov dx, sPlayerName
    mov bx, NAME_LENGTH
    call CopyData
    
    mov esi, wMainDataStart
    mov dx, sMainData
    mov bx, wMainDataEnd - wMainDataStart
    call CopyData
    
    mov esi, wSpriteDataStart
    mov dx, sSpriteData
    mov bx, wSpriteDataEnd - wSpriteDataStart
    call CopyData
    
    mov esi, wBoxDataStart
    mov dx, sCurBoxData
    mov bx, wBoxDataEnd - wBoxDataStart
    call CopyData
    
    mov al, [ebp + hTileAnimations]
    mov [ebp + sTileAnimations], al
    
    mov esi, sGameData
    mov cx, sGameDataEnd - sGameData
    call CalcCheckSum
    
    mov [ebp + sMainDataCheckSum], al
    
    call DisableSRAM
    ret
