; dos_port/src/items/super_rod.asm

%include "gb_macros.inc"
%include "gb_memmap.inc"

section .text

global ReadSuperRodData
global GenerateRandomFishingEncounter

extern Random
extern SuperRodFishingSlots

; -----------------------------------------------------------------------------
; ReadSuperRodData
; -----------------------------------------------------------------------------
ReadSuperRodData:
    mov al, byte [ebp + W_CUR_MAP]
    mov cl, al
    lea esi, [SuperRodFishingSlots]
.loop:
    mov al, byte [esi]
    inc esi
    cmp al, 0xFF
    jz .notfound
    cmp al, cl
    jz .found
    
    add esi, 8
    jmp .loop

.found:
    call GenerateRandomFishingEncounter
    ret

.notfound:
    mov edx, 0
    ret

; -----------------------------------------------------------------------------
; GenerateRandomFishingEncounter
; -----------------------------------------------------------------------------
GenerateRandomFishingEncounter:
    call Random
    cmp al, 0x66
    jc .done
    
    inc esi
    inc esi
    cmp al, 0xB2
    jc .done
    
    inc esi
    inc esi
    cmp al, 0xE5
    jc .done
    
    inc esi
    inc esi

.done:
    mov ch, byte [esi]
    inc esi
    mov dl, byte [esi]
    ret
