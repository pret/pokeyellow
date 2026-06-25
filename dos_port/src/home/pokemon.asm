; pokemon.asm — GetMonHeader (Pokémon data/stats plan).
;
; Source: home/pokemon.asm:GetMonHeader + engine/menus/pokedex.asm:IndexToPokedex.
;
; Copies the 28-byte base-stats record for the internal species index in
; [wCurSpecies] into wMonHeader, then overwrites byte 0 (the dex id) with the
; internal index — matching the original.
;
; DIVERGENCE FROM GB: the data tables (BaseStats, IndexToPokedex) live in the
; program image as flat labels, not in EBP-relative GB memory, so we index them
; directly and `rep movsb` into [ebp+wMonHeader] instead of going through the
; GB CopyData/AddNTimes (which assume EBP-relative source). The fossil/ghost
; special sprite IDs are not handled (no battle sprites in this port yet).
;
; Build: nasm -f coff -I include/ -I . -o pokemon.o pokemon.asm

bits 32

%include "gb_memmap.inc"
%include "gb_constants.inc"

extern BaseStats
extern IndexToPokedex

global GetMonHeader

section .text

GetMonHeader:
    pushad

    ; dex = IndexToPokedex[wCurSpecies - 1]   (internal index -> national dex)
    movzx eax, byte [ebp + wCurSpecies]
    dec eax
    movzx eax, byte [IndexToPokedex + eax]

    ; src = BaseStats + (dex - 1) * BASE_DATA_SIZE
    dec eax
    imul eax, eax, BASE_DATA_SIZE
    lea esi, [BaseStats + eax]        ; flat (program-image) source

    lea edi, [ebp + wMonHeader]       ; flat dest in GB memory
    mov ecx, BASE_DATA_SIZE
    rep movsb

    ; wMonHIndex = wCurSpecies (write internal index back over the dex byte)
    mov al, [ebp + wCurSpecies]
    mov [ebp + wMonHIndex], al

    popad
    ret
