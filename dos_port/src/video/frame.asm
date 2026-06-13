; frame.asm — DelayFrame / DelayFrames translated from SM83 to x86.
;
; Source: home/vblank.asm:DelayFrame, home/delay.asm:DelayFrames
;
; SM83 DelayFrame sets hVBlankOccurred = NOT_VBLANKED, halts until the VBlank
; interrupt clears it. In the DOS port, that maps to: sync to VGA vblank, then
; wait for the 60 Hz PIT tick. Main-thread only (spins on hardware the renderer
; uses). Both routines preserve all registers — they are bare cooperative yields.
;
; Build: nasm -f coff -I include/ -o frame.o frame.asm

bits 32

%include "gb_memmap.inc"
%include "gb_macros.inc"

extern wait_vblank
extern wait_pit_tick

global DelayFrame
global DelayFrames

section .text

; ---------------------------------------------------------------------------
; DelayFrame — block until the next 60 Hz frame boundary.
; Out: all registers preserved.
; ---------------------------------------------------------------------------
DelayFrame:
    pushad
    call wait_vblank
    call wait_pit_tick
    popad
    ret

; ---------------------------------------------------------------------------
; DelayFrames — wait BL (C register) frames.
; In:  BL = frame count. Out: BL = 0. Other registers preserved.
; ---------------------------------------------------------------------------
DelayFrames:
    test bl, bl
    jz .done
.loop:
    call DelayFrame
    dec bl
    jnz .loop
.done:
    ret
