; dos_port/src/items/subtract_paid_money.asm

%include "gb_macros.inc"
%include "gb_memmap.inc"

section .text

global SubtractAmountPaidFromMoney_

extern StringCmp
extern SubBCDPredef
extern DisplayTextBoxID

%define MONEY_BOX 5

; -----------------------------------------------------------------------------
; SubtractAmountPaidFromMoney_
; subtracts the amount the player paid from their money
; OUTPUT: carry = 0(success) or 1(fail because there is not enough money)
; -----------------------------------------------------------------------------
SubtractAmountPaidFromMoney_:
    mov edi, W_PLAYER_MONEY
    mov esi, H_MONEY
    mov cl, 3
    call StringCmp
    jc .done
    
    mov edi, W_PLAYER_MONEY + 2
    mov esi, H_MONEY + 2
    mov cl, 3
    call SubBCDPredef
    
    mov byte [ebp + W_TEXT_BOX_ID], MONEY_BOX
    call DisplayTextBoxID
    
    clc
.done:
    ret
