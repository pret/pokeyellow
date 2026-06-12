; timing.asm — PIT 60 Hz reprogramming, tick ISR, and VBlank sync.
;
; PIT channel 0 is reprogrammed to fire IRQ 0 at ~60 Hz (divisor 19886,
; mode 3 square wave). The ISR increments [tick_count] and sets [tick_flag].
;
; ISR SEGMENT NOTE: a DPMI hardware interrupt may arrive with segment
; registers that are NOT our flat DS (the host provides a locked stack).
; The standard DJGPP technique: read our data selector from a variable via a
; CS override (CS and DS share the same base under DJGPP), then load DS/ES.
;
; PIT frequency math:
;   1,193,182 Hz / 19,886 = 59.999 Hz ≈ 60 Hz
;
; Build: nasm -f coff -I include/ -o timing.o timing.asm

bits 32

%include "gb_memmap.inc"
%include "gb_macros.inc"

PIT_DIVISOR     equ 19886   ; ~60 Hz
PIT_CMD_PORT    equ 0x43    ; PIT command register
PIT_CH0_PORT    equ 0x40    ; PIT channel 0 data
PIT_CMD_CH0_RW  equ 0x36    ; channel 0, lobyte/hibyte, mode 3 (square wave)

PIC_CMD_PORT    equ 0x20    ; master PIC command
PIC_EOI         equ 0x20    ; End-Of-Interrupt command
IRQ0_INT        equ 0x08    ; protected-mode vector for IRQ 0 (PIT)

VGA_STATUS_PORT equ 0x3DA   ; VGA input status register 1
VGA_VSYNC_BIT   equ 3       ; bit 3: 1 = vertical retrace active

; ---------------------------------------------------------------------------
; Exported symbols
; ---------------------------------------------------------------------------
global pit_init
global pit_restore
global wait_vblank
global wait_pit_tick
global tick_count        ; dword: total ticks since pit_init

; ---------------------------------------------------------------------------
; BSS
; ---------------------------------------------------------------------------
section .bss
align 4
tick_count:     resd 1       ; incremented by the ISR at ~60 Hz
orig_irq0_off:  resd 1       ; saved original IRQ0 handler offset
orig_irq0_sel:  resw 1       ; saved original IRQ0 handler selector
tick_flag:      resb 1       ; set by ISR; cleared by wait_pit_tick

; ---------------------------------------------------------------------------
; Data — isr_ds must be in a writable section reachable via CS override.
; Under DJGPP, CS and DS share a base, so [cs:isr_ds] reads this variable.
; ---------------------------------------------------------------------------
section .data
align 4
isr_ds:         dw 0         ; our data selector, stored for the ISR

; ---------------------------------------------------------------------------
; Code
; ---------------------------------------------------------------------------
section .text

; ---------------------------------------------------------------------------
; pit_init — save old IRQ0 vector, install tick ISR, reprogram PIT to 60 Hz
; ---------------------------------------------------------------------------
pit_init:
    push eax
    push ebx
    push ecx
    push edx

    ; Store our data selector where the ISR can reach it via CS override
    mov ax, ds
    mov [isr_ds], ax

    ; Save original protected-mode IRQ0 vector (DPMI fn 0204h)
    ; In: BL = vector. Out: CX = selector, EDX = offset.
    mov ax, 0x0204
    mov bl, IRQ0_INT
    int 0x31
    mov [orig_irq0_off], edx
    mov [orig_irq0_sel], cx

    ; Install our ISR (DPMI fn 0205h): BL = vector, CX = selector, EDX = offset
    mov ax, 0x0205
    mov bl, IRQ0_INT
    mov cx, cs
    mov edx, tick_isr
    int 0x31

    ; Reprogram PIT channel 0: mode 3, lobyte/hibyte, divisor 19886
    mov al, PIT_CMD_CH0_RW
    out PIT_CMD_PORT, al
    mov ax, PIT_DIVISOR
    out PIT_CH0_PORT, al    ; low byte
    mov al, ah
    out PIT_CH0_PORT, al    ; high byte

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

; ---------------------------------------------------------------------------
; pit_restore — restore the BIOS 18.2 Hz divisor and the original IRQ0 vector
; Called from cleanup (entry.asm) before exit.
; ---------------------------------------------------------------------------
pit_restore:
    push eax
    push ebx
    push ecx
    push edx

    ; Divisor 0 = 65536 → 18.2 Hz (BIOS default)
    mov al, PIT_CMD_CH0_RW
    out PIT_CMD_PORT, al
    xor al, al
    out PIT_CH0_PORT, al
    out PIT_CH0_PORT, al

    ; Restore original IRQ0 vector
    mov ax, 0x0205
    mov bl, IRQ0_INT
    mov cx, [orig_irq0_sel]
    mov edx, [orig_irq0_off]
    int 0x31

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

; ---------------------------------------------------------------------------
; tick_isr — IRQ 0 service routine (~60 Hz)
;
; Loads DS/ES from [cs:isr_ds] because the DPMI host does not guarantee our
; data selector in any segment register on entry.
;
; NOTE: we do not chain to the original BIOS/DOS IRQ0 handler, so the DOS
; time-of-day clock is frozen while the game runs (restored on exit by
; pit_restore). Chaining every 3rd tick is a Phase 1 TODO if DOS clock
; accuracy ever matters.
; ---------------------------------------------------------------------------
tick_isr:
    push ds
    push es
    push eax

    mov ax, [cs:isr_ds]     ; CS base == DS base under DJGPP, so this works
    mov ds, ax
    mov es, ax

    inc dword [tick_count]
    mov byte [tick_flag], 1

    ; End-Of-Interrupt to the master PIC
    mov al, PIC_EOI
    out PIC_CMD_PORT, al

    pop eax
    pop es
    pop ds
    iret

; ---------------------------------------------------------------------------
; wait_vblank — spin until the next vertical retrace starts
;   1. Wait for VSync inactive (in case we're mid-retrace)
;   2. Wait for VSync active — that edge is the start of retrace
; ---------------------------------------------------------------------------
wait_vblank:
    push eax
    push edx

    mov dx, VGA_STATUS_PORT
.wait_low:
    in  al, dx
    test al, 1 << VGA_VSYNC_BIT
    jnz .wait_low
.wait_high:
    in  al, dx
    test al, 1 << VGA_VSYNC_BIT
    jz  .wait_high

    pop edx
    pop eax
    ret

; ---------------------------------------------------------------------------
; wait_pit_tick — spin until the ISR sets tick_flag; clear it on wake
; ---------------------------------------------------------------------------
wait_pit_tick:
    push eax
.spin:
    mov al, [tick_flag]
    test al, al
    jz .spin
    mov byte [tick_flag], 0
    pop eax
    ret
