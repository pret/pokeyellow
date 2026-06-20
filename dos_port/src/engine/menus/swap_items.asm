; dos_port/engine/menus/swap_items.asm
global HandleItemListSwapping

extern wListMenuID
extern wListPointer
extern wCurrentMenuItem
extern wListScrollOffset
extern wMenuItemToSwap
extern hSwapItemID
extern hSwapItemQuantity
extern wListCount
extern wMaxMenuItem
extern DisplayListMenuIDLoop
extern DelayFrames
extern ITEMLISTMENU

section .text

HandleItemListSwapping:
    mov al, [ebp + wListMenuID]
    cmp al, ITEMLISTMENU
    jnz DisplayListMenuIDLoop

    push esi

    movzx esi, word [ebp + wListPointer]
    inc esi

    mov bl, [ebp + wCurrentMenuItem]
    mov al, [ebp + wListScrollOffset]
    add al, bl
    add al, al
    movzx ecx, al
    add esi, ecx
    
    mov al, [ebp + esi]
    
    mov dl, al
    pop esi
    mov al, dl
    
    inc al
    jz DisplayListMenuIDLoop
    
    mov al, [ebp + wMenuItemToSwap]
    test al, al
    jnz .swapItems
    
    mov al, [ebp + wCurrentMenuItem]
    inc al
    mov bl, al
    mov al, [ebp + wListScrollOffset]
    add al, bl
    mov [ebp + wMenuItemToSwap], al
    
    mov cl, 20
    call DelayFrames
    jmp DisplayListMenuIDLoop

.swapItems:
    mov al, [ebp + wCurrentMenuItem]
    inc al
    mov bl, al
    mov al, [ebp + wListScrollOffset]
    add al, bl
    mov bl, al
    
    mov al, [ebp + wMenuItemToSwap]
    cmp al, bl
    jz DisplayListMenuIDLoop
    
    dec al
    mov [ebp + wMenuItemToSwap], al
    
    mov cl, 20
    call DelayFrames
    
    push esi
    push dx
    
    movzx esi, word [ebp + wListPointer]
    inc esi
    
    mov edx, esi
    
    mov bl, [ebp + wCurrentMenuItem]
    mov al, [ebp + wListScrollOffset]
    add al, bl
    add al, al
    movzx ecx, al
    add esi, ecx
    
    mov al, [ebp + wMenuItemToSwap]
    add al, al
    movzx ecx, al
    add edx, ecx
    
    mov bl, [ebp + edx]
    mov al, [ebp + esi]
    inc esi
    cmp al, bl
    jz .swapSameItemType
    
    mov [ebp + hSwapItemID], al
    mov al, [ebp + esi]
    dec esi
    mov [ebp + hSwapItemQuantity], al
    
    mov al, [ebp + edx]
    mov [ebp + esi], al
    inc esi
    
    inc edx
    mov al, [ebp + edx]
    mov [ebp + esi], al
    
    mov al, [ebp + hSwapItemQuantity]
    mov [ebp + edx], al
    
    dec edx
    mov al, [ebp + hSwapItemID]
    mov [ebp + edx], al
    
    xor al, al
    mov [ebp + wMenuItemToSwap], al
    
    pop dx
    pop esi
    jmp DisplayListMenuIDLoop

.swapSameItemType:
    inc edx
    mov al, [ebp + esi]
    mov bl, al
    mov al, [ebp + edx]
    add al, bl
    cmp al, 100
    jc .combineItemSlots
    
    sub al, 99
    mov [ebp + edx], al
    mov al, 99
    mov [ebp + esi], al
    jmp .done

.combineItemSlots:
    mov [ebp + esi], al
    
    movzx esi, word [ebp + wListPointer]
    dec byte [ebp + esi]
    
    mov al, [ebp + esi]
    mov [ebp + wListCount], al
    
    cmp al, 1
    jnz .skipSettingMaxMenuItemID
    mov [ebp + wMaxMenuItem], al
.skipSettingMaxMenuItemID:
    dec edx
    mov esi, edx
    add esi, 2
    
.moveItemsUpLoop:
    mov al, [ebp + esi]
    inc esi
    mov [ebp + edx], al
    
    inc edx
    
    inc al
    jz .afterMovingItemsUp
    
    mov al, [ebp + esi]
    inc esi
    mov [ebp + edx], al
    
    inc edx
    jmp .moveItemsUpLoop
    
.afterMovingItemsUp:
    xor al, al
    mov [ebp + wListScrollOffset], al
    mov [ebp + wCurrentMenuItem], al

.done:
    xor al, al
    mov [ebp + wMenuItemToSwap], al
    
    pop dx
    pop esi
    jmp DisplayListMenuIDLoop
