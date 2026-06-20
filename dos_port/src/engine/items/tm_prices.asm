; dos_port/src/items/tm_prices.asm

%include "gb_macros.inc"
%include "gb_memmap.inc"

section .text

global GetMachinePrice
extern TechnicalMachinePrices

%define TM01 0xC9

; -----------------------------------------------------------------------------
; GetMachinePrice
; Input:  [wCurItem] = Item ID of a TM
; Output: Stores the TM price at hItemPrice
; -----------------------------------------------------------------------------
GetMachinePrice:
    mov al, byte [ebp + W_CUR_ITEM]
    sub al, TM01
    jc .done ; HMs are priceless (carry flag set if al < 0xC9)
    
    mov dh, al
    shr al, 1
    movzx ecx, al
    lea esi, [TechnicalMachinePrices]
    add esi, ecx
    
    mov al, byte [esi]
    
    mov cl, dh
    shr cl, 1
    jnc .highNybbleIsPrice
    
    ; swap a
    mov cl, al
    shl cl, 4
    shr al, 4
    or al, cl

.highNybbleIsPrice:
    and al, 0xF0
    mov byte [ebp + H_ITEM_PRICE + 1], al
    mov byte [ebp + H_ITEM_PRICE], 0
    mov byte [ebp + H_ITEM_PRICE + 2], 0

.done:
    ret
