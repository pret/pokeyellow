; dos_port/engine/menus/pc.asm
global RemoveItemByID

extern wBagItems
extern hItemToRemoveID
extern hItemToRemoveIndex
extern wItemQuantity
extern wWhichPokemon
extern wNumBagItems
extern RemoveItemFromInventory

section .text

; removes one of the specified item ID [hItemToRemoveID] from bag (if existent)
RemoveItemByID:
    mov esi, wBagItems
    mov bl, [ebp + hItemToRemoveID]
    xor al, al
    mov [ebp + hItemToRemoveIndex], al

.loop:
    mov al, [ebp + esi]
    inc esi
    
    cmp al, 0xff ; -1 terminator
    jz .done
    
    cmp al, bl
    jz .foundItem
    
    ; inc hl (skip quantity byte)
    inc esi
    
    mov al, [ebp + hItemToRemoveIndex]
    inc al
    mov [ebp + hItemToRemoveIndex], al
    jmp .loop

.foundItem:
    mov al, 1
    mov [ebp + wItemQuantity], al
    mov al, [ebp + hItemToRemoveIndex]
    mov [ebp + wWhichPokemon], al
    
    mov esi, wNumBagItems
    jmp RemoveItemFromInventory

.done:
    ret
