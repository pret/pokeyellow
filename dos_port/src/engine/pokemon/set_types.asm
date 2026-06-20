%include "include/gb_memmap.inc"

SECTION .text

global SetPartyMonTypes

extern GetPredefRegisters
extern GetMonHeader

extern wPokedexNum
extern wCurSpecies
extern wMonHType1
extern wMonHType2
extern MON_TYPE

; updates the types of a party mon (pointed to in ESI) to the ones of the mon specified in [wPokedexNum]
SetPartyMonTypes:
    call GetPredefRegisters
    
    ; ld bc, MON_TYPE
    ; add hl, bc
    ; Optimized into single LEA instruction, taking 2 cycles instead of an ADD
    lea esi, [esi + MON_TYPE]

    ; ld a, [wPokedexNum]
    mov al, [ebp + wPokedexNum]

    ; ld [wCurSpecies], a
    mov [ebp + wCurSpecies], al

    ; push hl
    push esi

    ; call GetMonHeader
    call GetMonHeader

    ; pop hl
    pop esi

    ; ld a, [wMonHType1]
    mov al, [ebp + wMonHType1]

    ; ld [hli], a
    mov [ebp + esi], al
    inc esi

    ; ld a, [wMonHType2]
    mov al, [ebp + wMonHType2]

    ; ld [hl], a
    mov [ebp + esi], al

    ret
