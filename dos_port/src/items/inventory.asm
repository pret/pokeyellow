; dos_port/src/items/inventory.asm

%include "gb_macros.inc"
%include "gb_memmap.inc"

section .text

global AddItemToInventory_
global RemoveItemFromInventory_

%define BAG_ITEM_CAPACITY 20
%define PC_ITEM_CAPACITY  50

; -----------------------------------------------------------------------------
; AddItemToInventory_
;
; INPUT:
; ESI = address of inventory (either W_NUM_BAG_ITEMS or W_NUM_BOX_ITEMS)
; [W_CUR_ITEM] = item ID
; [W_ITEM_QUANTITY] = item quantity
; OUTPUT:
; sets carry flag if successful, clears carry flag if unsuccessful
; -----------------------------------------------------------------------------
AddItemToInventory_:
    push bx
    push dx
    push edi

    mov al, byte [ebp + W_ITEM_QUANTITY]
    mov ch, al ; CH = item quantity
    
    mov edi, esi ; EDI = base of inventory
    
    mov dh, PC_ITEM_CAPACITY
    cmp esi, W_NUM_BAG_ITEMS
    jnz .checkIfInventoryFull
    mov dh, BAG_ITEM_CAPACITY
    
.checkIfInventoryFull:
    mov al, byte [ebp + esi]
    sub al, dh
    mov dh, al ; dh = [hl] - capacity (if < 0, there is room)
    
    inc esi
    mov al, byte [ebp + esi]
    test al, al
    jz .addNewItem

.notAtEndOfInventory:
    mov al, byte [ebp + esi]
    inc esi
    mov bh, al ; BH = current item ID
    mov al, byte [ebp + W_CUR_ITEM]
    cmp al, bh
    jz .increaseItemQuantity
    
    inc esi
.addAnotherStackOfItem:
    mov al, byte [ebp + esi]
    cmp al, 0xFF
    jnz .notAtEndOfInventory

.addNewItem:
    mov esi, edi ; Restore HL (inventory base)
    mov al, dh
    test al, al
    jz .fail ; if dh == 0, there is no room. Wait, original is `and a \ jr z, .done` which means dh == 0 -> full!
    
    ; There is room
    mov al, byte [ebp + esi]
    inc al
    mov byte [ebp + esi], al
    
    ; a = new item index
    movzx ecx, al
    dec ecx
    shl ecx, 1
    
    ; address to store the item = esi + 1 + ecx
    lea edx, [esi + 1 + ecx]
    
    mov al, byte [ebp + W_CUR_ITEM]
    mov byte [ebp + edx], al
    inc edx
    
    mov al, byte [ebp + W_ITEM_QUANTITY]
    mov byte [ebp + edx], al
    inc edx
    
    mov byte [ebp + edx], 0xFF
    jmp .success

.increaseItemQuantity:
    mov al, byte [ebp + W_ITEM_QUANTITY]
    mov bl, al ; BL = quantity to add
    mov al, byte [ebp + esi] ; AL = existing quantity
    add al, bl
    cmp al, 100
    jc .storeNewQuantity
    
    ; New quantity >= 100
    sub al, 99
    mov byte [ebp + W_ITEM_QUANTITY], al
    
    mov al, dh
    test al, al
    jz .fail ; no room for new slot
    
    mov al, 99
    mov byte [ebp + esi], al
    inc esi
    jmp .addAnotherStackOfItem

.storeNewQuantity:
    mov byte [ebp + esi], al
    jmp .success

.fail:
    clc
    jmp .done

.success:
    stc

.done:
    mov al, ch
    mov byte [ebp + W_ITEM_QUANTITY], al
    
    pop edi
    pop dx
    pop bx
    ret

; -----------------------------------------------------------------------------
; RemoveItemFromInventory_
;
; INPUT:
; ESI = address of inventory (either W_NUM_BAG_ITEMS or W_NUM_BOX_ITEMS)
; [W_WHICH_POKEMON] = index of item to remove
; [W_ITEM_QUANTITY] = quantity to remove
; -----------------------------------------------------------------------------
RemoveItemFromInventory_:
    push bx
    push dx
    push edi
    
    mov edi, esi ; save inventory base
    
    inc esi
    movzx eax, byte [ebp + W_WHICH_POKEMON]
    shl eax, 1
    add esi, eax
    
    inc esi ; ESI = address of quantity byte of the item
    mov al, byte [ebp + W_ITEM_QUANTITY]
    mov cl, al ; CL = quantity being removed
    
    mov al, byte [ebp + esi]
    sub al, cl
    mov byte [ebp + esi], al
    mov byte [ebp + W_MAX_ITEM_QUANTITY], al
    
    test al, al
    jnz .skipMovingUpSlots
    
    ; quantity is 0, remove the slot and shift up
    dec esi ; ESI = address of the item ID of the emptied slot
    lea edx, [esi + 2] ; EDX = address of the slot following the emptied one

.loop:
    mov al, byte [ebp + edx]
    inc edx
    mov byte [ebp + esi], al
    inc esi
    cmp al, 0xFF
    jnz .loop
    
    ; update menu info
    mov byte [ebp + W_LIST_SCROLL_OFFSET], 0
    mov byte [ebp + W_CURRENT_MENU_ITEM], 0
    mov byte [ebp + W_BAG_SAVED_MENU_ITEM], 0
    mov byte [ebp + W_SAVED_LIST_SCROLL_OFFSET], 0
    
    mov al, byte [ebp + edi] ; EDI = inventory base
    dec al
    mov byte [ebp + edi], al
    mov byte [ebp + W_LIST_COUNT], al
    
    cmp al, 2
    jc .skipMovingUpSlots
    mov byte [ebp + W_MAX_MENU_ITEM], al

.skipMovingUpSlots:
    pop edi
    pop dx
    pop bx
    ret
