; entry.asm — DPMI entry point, GB memory allocation, command-line parsing,
; and the main 60 Hz frame loop.
;
; The DJGPP coff-go32-exe stub handles DPMI setup before jumping here.
; By the time 'start' executes we are in 32-bit protected mode, BUT:
;
;   IMPORTANT: the DS/CS selectors have their base at the program image,
;   NOT at linear address 0. Raw linear addresses (VGA 0xA0000, DPMI
;   allocation results, PSP segment*16) must be biased by -ds_base before
;   use as DS-relative offsets. We also raise the DS limit to 4 GB
;   (DPMI fn 0008h) so the biased offsets don't fault — this is exactly
;   what DJGPP's __djgpp_nearptr_enable() does.
;
; Build: nasm -f coff -I include/ -I . -o entry.o entry.asm

bits 32

%include "gb_memmap.inc"
%include "gb_macros.inc"

; Total GB allocation: 64 KB address space + 8 KB CGB VRAM1 + back buffer
GB_TOTAL_SIZE   equ GB_BACKBUF + GB_BACKBUF_SIZE    ; 0x17A00 (96768 bytes)

; ---------------------------------------------------------------------------
; External symbols from other boot modules
; ---------------------------------------------------------------------------
extern video_init        ; boot/video.asm
extern pit_init          ; boot/timing.asm
extern pit_restore       ; boot/timing.asm
extern joypad_init       ; src/input/joypad.asm
extern joypad_restore    ; src/input/joypad.asm
extern Init              ; src/init/init.asm — power-on init

; ---------------------------------------------------------------------------
; Exported symbols
; ---------------------------------------------------------------------------
global start
global ds_base           ; linear base address of our DS selector
global bug_fix_level     ; runtime BUG_FIX_LEVEL (0/1/2), set from command line
global cleanup           ; called by frame.asm when pad_quit is set

; ---------------------------------------------------------------------------
; BSS (zeroed by the stub before start)
; ---------------------------------------------------------------------------
section .bss
align 4
ds_base:        resd 1       ; linear base of DS (for linear→offset bias)
gb_mem_base:    resd 1       ; DS-relative base of the GB allocation (= EBP)
dpmi_handle:    resd 1       ; DPMI memory block handle (SI:DI), for fn 0502h
bug_fix_level:  resb 1       ; runtime bug fix level (0=none, 1=critical, 2=all)

; ---------------------------------------------------------------------------
; Data
; ---------------------------------------------------------------------------
section .data
align 4

; Command-line argument tokens (matched case-sensitively as typed)
arg_fixall:   db '/FIXALL',  0
arg_fixcrit:  db '/FIXCRIT', 0

; ---------------------------------------------------------------------------
; Code
; ---------------------------------------------------------------------------
section .text

; ---------------------------------------------------------------------------
; start — program entry point
; ---------------------------------------------------------------------------
start:
    call setup_flat_access   ; get DS base, raise DS/SS limit to 4 GB
    call parse_cmdline       ; set bug_fix_level from /FIXALL or /FIXCRIT
    call alloc_gb_memory     ; EBP = DS-relative base of GB address space

    ; Zero-initialise the entire GB allocation (mimics GB power-up state)
    lea edi, [ebp]
    mov ecx, GB_TOTAL_SIZE / 4
    xor eax, eax
    rep stosd

    call video_init          ; set VGA mode 13h
    call pit_init            ; reprogram PIT to ~60 Hz, install tick ISR
    call joypad_init         ; hook IRQ 1 (keyboard) → GB joypad state

    call Init                ; power-on init → title screen (runs game loop)
    ; Execution reaches here only if Init returns without exiting via pad_quit.
    call cleanup
    mov ax, 0x4C00
    int 0x21

; ---------------------------------------------------------------------------
; setup_flat_access — fetch DS linear base and raise segment limits to 4 GB
;
; DPMI fn 0006h: get segment base address  (BX=selector → CX:DX = base)
; DPMI fn 0008h: set segment limit         (BX=selector, CX:DX = limit)
;
; With limit = 0xFFFFFFFF, DS-relative offsets wrap modulo 4 GB, so
; (linear - ds_base) reaches any linear address — the DJGPP nearptr model.
; ---------------------------------------------------------------------------
setup_flat_access:
    push eax
    push ebx
    push ecx
    push edx

    ; Get DS base
    mov ax, 0x0006
    mov bx, ds
    int 0x31
    jc  .fail
    movzx eax, cx
    shl eax, 16
    mov ax, dx
    mov [ds_base], eax

    ; Raise DS limit to 4 GB
    mov ax, 0x0008
    mov bx, ds
    mov cx, 0xFFFF
    mov dx, 0xFFFF
    int 0x31
    jc  .fail

    ; Alias ES to DS — rep movsb / rep stosb writes go to ES:EDI.
    ; If ES is a separate LDT entry it still has the original small limit;
    ; rep movsb to the GB allocation (above the original segment top) would
    ; then write to the wrong linear address silently instead of faulting.
    mov ax, ds
    mov es, ax

    ; Raise SS limit (harmless if SS == DS)
    mov ax, 0x0008
    mov bx, ss
    mov cx, 0xFFFF
    mov dx, 0xFFFF
    int 0x31

    ; Normalize SS to DS selector — [EBP+disp] uses SS by default.
    ; If SS base ≠ DS base, every EBP-relative GB access hits the wrong memory.
    mov ax, 0x0006
    mov bx, ss
    int 0x31
    movzx eax, cx
    shl eax, 16
    mov ax, dx
    sub eax, [ds_base]
    jz .ss_ok
    mov edx, eax
    mov ax, ds
    mov ss, ax
    add esp, edx
.ss_ok:

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

.fail:
    mov ax, 0x4C02
    int 0x21

; ---------------------------------------------------------------------------
; alloc_gb_memory — allocate GB_TOTAL_SIZE bytes via DPMI fn 0501h
; ---------------------------------------------------------------------------
alloc_gb_memory:
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov ax, 0x0501
    mov ebx, GB_TOTAL_SIZE >> 16
    mov ecx, GB_TOTAL_SIZE & 0xFFFF
    int 0x31
    jc .alloc_failed

    movzx eax, si
    shl eax, 16
    movzx edx, di
    or  eax, edx
    mov [dpmi_handle], eax

    movzx eax, bx
    shl eax, 16
    movzx ecx, cx
    or  eax, ecx
    sub eax, [ds_base]
    mov [gb_mem_base], eax

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax

    mov ebp, [gb_mem_base]
    ret

.alloc_failed:
    mov ax, 0x4C01
    int 0x21

; ---------------------------------------------------------------------------
; parse_cmdline — scan DOS command line for /FIXALL or /FIXCRIT
; ---------------------------------------------------------------------------
parse_cmdline:
    push eax
    push ebx
    push ecx
    push esi
    push edi

    mov byte [bug_fix_level], BUG_FIX_LEVEL

    mov ah, 0x62
    int 0x21

    movzx eax, bx
    shl eax, 4
    sub eax, [ds_base]
    lea esi, [eax + 0x81]
    movzx ecx, byte [eax + 0x80]
    test ecx, ecx
    jz .done

    mov edi, arg_fixall
    call find_token
    jnz .try_fixcrit
    mov byte [bug_fix_level], 2
    jmp .done

.try_fixcrit:
    mov edi, arg_fixcrit
    call find_token
    jnz .done
    mov byte [bug_fix_level], 1

.done:
    pop edi
    pop esi
    pop ecx
    pop ebx
    pop eax
    ret

; ---------------------------------------------------------------------------
; find_token — search for null-terminated token in buffer
; In:  ESI = buffer, ECX = length, EDI = token. Out: ZF set if found.
; ---------------------------------------------------------------------------
find_token:
    push eax
    push ebx
    push ecx
    push esi
    push edi

    mov ebx, edi
.tok_len:
    cmp byte [ebx], 0
    je .tok_len_done
    inc ebx
    jmp .tok_len
.tok_len_done:
    sub ebx, edi

.scan_loop:
    cmp ecx, ebx
    jl .not_found
    push ecx
    push esi
    push edi
    mov ecx, ebx
    repe cmpsb
    pop edi
    pop esi
    pop ecx
    je .found
    inc esi
    dec ecx
    jmp .scan_loop

.found:
    xor eax, eax
    jmp .out
.not_found:
    or eax, 1
.out:
    pop edi
    pop esi
    pop ecx
    pop ebx
    pop eax
    ret

; ---------------------------------------------------------------------------
; cleanup — restore PIT, IRQ0, IRQ1 and return to text mode
; ---------------------------------------------------------------------------
cleanup:
    push eax
    call joypad_restore
    call pit_restore
    mov ax, 0x0003
    int 0x10
    pop eax
    ret

