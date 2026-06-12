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
; Build: nasm -f coff -I include/ -o entry.o entry.asm

bits 32

%include "gb_memmap.inc"
%include "gb_macros.inc"

; Total GB allocation: 64 KB address space + 8 KB CGB VRAM1 + back buffer
GB_TOTAL_SIZE   equ GB_BACKBUF + GB_BACKBUF_SIZE    ; 0x17A00 (96768 bytes)

; ---------------------------------------------------------------------------
; External symbols from other boot modules
; ---------------------------------------------------------------------------
extern video_init        ; boot/video.asm
extern draw_tick_band    ; boot/video.asm — visible PIT tick indicator
extern pit_init          ; boot/timing.asm
extern pit_restore       ; boot/timing.asm
extern wait_vblank       ; boot/timing.asm
extern wait_pit_tick     ; boot/timing.asm

; ---------------------------------------------------------------------------
; Exported symbols
; ---------------------------------------------------------------------------
global start
global ds_base           ; linear base address of our DS selector
global bug_fix_level     ; runtime BUG_FIX_LEVEL (0/1/2), set from command line

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

    call video_init     ; set VGA mode 13h, draw test pattern
    call pit_init       ; reprogram PIT to ~60 Hz, install tick ISR

.frame_loop:
    call wait_vblank        ; sync to VGA vertical retrace (port 0x3DA bit 3)
    call wait_pit_tick      ; wait for the PIT ISR tick flag
    call update_stub        ; game logic (stub)
    call render_stub        ; render to back buffer (stub)
    call present_stub       ; blit back buffer → VGA (stub; test pattern stays)
    call draw_tick_band     ; visible tick counter: top band cycles color at 60 Hz

    ; Exit on keypress: INT 21h AH=0Bh (check stdin status), AL=FF if key waiting
    mov ah, 0x0B
    int 0x21
    test al, al
    jz .frame_loop

    call cleanup
    mov ax, 0x4C00      ; DOS exit, code 0
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
    ; CX:DX = 32-bit base (16-bit halves)
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

    ; Raise SS limit too if SS is a different selector (under DJGPP SS == DS,
    ; but don't assume). Setting the same selector twice is harmless.
    mov ax, 0x0008
    mov bx, ss
    mov cx, 0xFFFF
    mov dx, 0xFFFF
    int 0x31
    ; ignore CF here: if SS == DS it already succeeded above

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

.fail:
    mov ax, 0x4C02      ; exit code 2: DPMI segment setup failed
    int 0x21

; ---------------------------------------------------------------------------
; alloc_gb_memory — allocate GB_TOTAL_SIZE bytes via DPMI fn 0501h
;
; DPMI fn 0501h: allocate memory block
;   In:  BX:CX = size in bytes (16-bit halves!)
;   Out: BX:CX = linear base address, SI:DI = handle
;
; On return: EBP = DS-relative base (linear - ds_base) of the allocation.
; ---------------------------------------------------------------------------
alloc_gb_memory:
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov ax, 0x0501
    mov ebx, GB_TOTAL_SIZE >> 16        ; size high word
    mov ecx, GB_TOTAL_SIZE & 0xFFFF     ; size low word
    int 0x31
    jc .alloc_failed

    ; Save handle (SI:DI) for potential fn 0502h free
    movzx eax, si
    shl eax, 16
    movzx edx, di
    or  eax, edx
    mov [dpmi_handle], eax

    ; Combine BX:CX → linear base, bias by -ds_base → DS-relative offset
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
    mov ax, 0x4C01      ; exit code 1: DPMI memory allocation failed
    int 0x21

; ---------------------------------------------------------------------------
; parse_cmdline — scan the DOS command line in the PSP for /FIXALL or /FIXCRIT
; Sets [bug_fix_level]: 0 (default), 1 (/FIXCRIT), or 2 (/FIXALL).
;
; INT 21h fn 62h returns the real-mode PSP segment in BX.
; Command line: length byte at PSP+0x80, text at PSP+0x81 (not terminated).
; PSP linear address = segment * 16; bias by -ds_base for DS-relative access.
; Requires setup_flat_access to have run first (4 GB DS limit).
; ---------------------------------------------------------------------------
parse_cmdline:
    push eax
    push ebx
    push ecx
    push esi
    push edi

    mov byte [bug_fix_level], BUG_FIX_LEVEL ; compile-time default

    ; Get PSP segment
    mov ah, 0x62
    int 0x21            ; BX = PSP segment

    ; DS-relative address of command line text
    movzx eax, bx
    shl eax, 4
    sub eax, [ds_base]
    lea esi, [eax + 0x81]   ; ESI = command line text
    movzx ecx, byte [eax + 0x80] ; ECX = command line length
    test ecx, ecx
    jz .done

    ; Look for /FIXALL first (more specific level wins if both present)
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
; find_token — search for a null-terminated token in a buffer
; In:  ESI = buffer, ECX = buffer length, EDI = null-terminated token
; Out: ZF set if found, clear if not. ESI/ECX/EDI preserved.
; ---------------------------------------------------------------------------
find_token:
    push eax
    push ebx
    push ecx
    push esi
    push edi

    ; Token length → EBX
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
    xor eax, eax        ; sets ZF
    jmp .out
.not_found:
    or eax, 1           ; clears ZF
.out:
    pop edi
    pop esi
    pop ecx
    pop ebx
    pop eax
    ret

; ---------------------------------------------------------------------------
; cleanup — restore PIT + IRQ0 vector and return to text mode
; ---------------------------------------------------------------------------
cleanup:
    push eax

    call pit_restore    ; restore 18.2 Hz divisor + original IRQ0 handler

    ; Restore 80x25 color text mode
    mov ax, 0x0003
    int 0x10

    ; DPMI memory block is reclaimed by the host at process exit;
    ; explicit fn 0502h free is unnecessary here.

    pop eax
    ret

; ---------------------------------------------------------------------------
; Stub routines — replaced as translation progresses
; ---------------------------------------------------------------------------
update_stub:
    ret

render_stub:
    ret

present_stub:
    ret
