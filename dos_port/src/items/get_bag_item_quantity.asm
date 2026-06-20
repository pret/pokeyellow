; dos_port/src/items/get_bag_item_quantity.asm

%include "gb_macros.inc"
%include "gb_memmap.inc"

section .text

global GetQuantityOfItemInBag
extern GetPredefRegisters

; -----------------------------------------------------------------------------
; GetQuantityOfItemInBag
;
; In: BH (b) = item ID
; Out: BH (b) = how many of that item are in the bag
; -----------------------------------------------------------------------------
GetQuantityOfItemInBag:
    call GetPredefRegisters
    mov esi, W_NUM_BAG_ITEMS
.loop:
    inc esi
    mov al, byte [ebp + esi]
    inc esi
    cmp al, 0xFF
    jz .notInBag
    cmp al, bh
    jnz .loop
    
    ; Found the item, load its quantity into BH
    mov al, byte [ebp + esi]
    mov bh, al
    ret

.notInBag:
    mov bh, 0
    ret
