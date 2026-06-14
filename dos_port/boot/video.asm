; video.asm — VGA mode 13h initialisation, test pattern, and 2× blit.
;
; Mode 13h: 320×200, 256 indexed colors, linear framebuffer at 0xA0000.
; Under DPMI, INT 10h is reflected to the real-mode BIOS automatically.
;
; ADDRESSING NOTE: DS base is not linear 0 under DJGPP. All VGA framebuffer
; access goes through [vga_base], computed at init as 0xA0000 - ds_base.
; This requires the 4 GB DS limit set by setup_flat_access (entry.asm) —
; the offset wraps modulo 2^32 and lands on linear 0xA0000.
;
; 2× blit strategy: GB back buffer is 160×144. At 2× that is 320×288, taller
; than the 200-line screen. We blit the first 100 GB rows (= 200 VGA rows).
; The bottom 44 GB rows are clipped. Revisit in Phase 5 (letterbox option).
;
; Build: nasm -f coff -I include/ -o video.o video.asm

bits 32

%include "gb_memmap.inc"
%include "gb_macros.inc"

extern ds_base           ; entry.asm — linear base of DS selector
extern tick_count        ; timing.asm — incremented at ~60 Hz by the PIT ISR

; ---------------------------------------------------------------------------
; Exported symbols
; ---------------------------------------------------------------------------
global video_init
global present           ; 2× blit: GB back buffer → VGA framebuffer
global draw_tick_band    ; visible PIT tick indicator (top screen band)

; ---------------------------------------------------------------------------
; BSS
; ---------------------------------------------------------------------------
section .bss
align 4
vga_base:   resd 1       ; DS-relative address of the VGA framebuffer

; ---------------------------------------------------------------------------
; Data
; ---------------------------------------------------------------------------
section .data
align 4

; Bootstrap test palette: four 64-entry ramps (blue, green, yellow, gray).
; Confirms the DAC ports work. Replaced by the real game palette in Phase 5.
test_palette:
%assign _i 0
%rep 64
    db (_i),    0,    0     ; ramp 0–63: blue-ish (R channel ramp actually; see note)
    %assign _i _i+1
%endrep
%assign _i 0
%rep 64
    db 0,    (_i),    0     ; ramp 64–127: green
    %assign _i _i+1
%endrep
%assign _i 0
%rep 64
    db (_i), (_i),    0     ; ramp 128–191: yellow
    %assign _i _i+1
%endrep
%assign _i 0
%rep 64
    db (_i), (_i), (_i)    ; ramp 192–255: gray
    %assign _i _i+1
%endrep
; Note: port 0x3C9 write order is R, G, B — so ramp 0 is actually red.
; Cosmetic only; this palette exists just to verify the DAC.

; DMG shade palette: entries 0–3, written after the ramps so the BG
; renderer's shade indices (0 = lightest … 3 = darkest) look like a real
; Game Boy. 6-bit RGB. Full 256-entry game palette layout is Phase 5.
dmg_palette:
    db 38, 47,  3       ; shade 0 — lightest  (#9bbc0f DMG green, 6-bit)
    db 34, 43,  3       ; shade 1 — light     (#8bac0f)
    db 12, 24, 12       ; shade 2 — dark      (#306230)
    db  3, 14,  3       ; shade 3 — darkest   (#0f380f)

; ---------------------------------------------------------------------------
; Code
; ---------------------------------------------------------------------------
section .text

; ---------------------------------------------------------------------------
; video_init — set VGA mode 13h, load test palette, draw test pattern
; ---------------------------------------------------------------------------
video_init:
    push eax
    push ecx
    push edx
    push esi

    ; Compute DS-relative framebuffer address (wraps via 4 GB limit)
    mov eax, VGA_FRAMEBUF
    sub eax, [ds_base]
    mov [vga_base], eax

    ; Set VGA mode 13h via BIOS (reflected to real mode by the DPMI host)
    mov ax, 0x0013
    int 0x10

    ; Load palette through the VGA DAC:
    ;   port 0x3C8 = write index (auto-increments after each RGB triple)
    ;   port 0x3C9 = R, G, B data (6-bit, 0–63)
    mov dx, 0x3C8
    xor al, al
    out dx, al

    mov dx, 0x3C9
    mov esi, test_palette
    mov ecx, 256 * 3
.pal_loop:
    lodsb
    out dx, al
    loop .pal_loop

    ; Overwrite entries 0–3 with the DMG shade palette (BG renderer output)
    mov dx, 0x3C8
    xor al, al
    out dx, al
    mov dx, 0x3C9
    mov esi, dmg_palette
    mov ecx, 4 * 3
.dmg_loop:
    lodsb
    out dx, al
    loop .dmg_loop

    call draw_test_pattern

    pop esi
    pop edx
    pop ecx
    pop eax
    ret

; ---------------------------------------------------------------------------
; draw_test_pattern — diagonal color gradient across the full screen
; color = (row + col) & 0xFF. Confirms framebuffer addressing + palette.
; ---------------------------------------------------------------------------
draw_test_pattern:
    push eax
    push ebx
    push ecx
    push edx
    push edi

    mov edi, [vga_base]
    xor ebx, ebx            ; EBX = row
.row_loop:
    xor edx, edx            ; EDX = column
.px_loop:
    lea eax, [ebx + edx]    ; color = row + col
    stosb                   ; AL → [ES:EDI], EDI++
    inc edx
    cmp edx, VGA_W
    jb .px_loop
    inc ebx
    cmp ebx, VGA_H
    jb .row_loop

    pop edi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

; ---------------------------------------------------------------------------
; draw_tick_band — fill the top 4 screen rows with color = tick_count & 0xFF
;
; Called once per frame from the main loop. Because tick_count increments at
; ~60 Hz, the band visibly cycles through the palette — a moving band proves
; the PIT ISR is firing. (A static band means the ISR is dead.)
; ---------------------------------------------------------------------------
draw_tick_band:
    push eax
    push ecx
    push edi

    mov edi, [vga_base]
    mov eax, [tick_count]
    ; AL = low byte of tick count = palette index that cycles at 60 Hz
    mov ecx, VGA_W * 4      ; top 4 rows
    rep stosb

    pop edi
    pop ecx
    pop eax
    ret

; ---------------------------------------------------------------------------
; present — 2× nearest-neighbor blit from GB back buffer to VGA framebuffer
;
; Reads:  [EBP + GB_BACKBUF] — 160×144 8bpp pixels
; Writes: [vga_base] — 320×200 8bpp
;
; For each of the first 100 GB rows, write 2 VGA rows with each pixel doubled.
; EBP must be valid (set by alloc_gb_memory before the frame loop).
; ---------------------------------------------------------------------------
present:
    push eax
    push ecx
    push esi
    push edi

    lea esi, [ebp + GB_BACKBUF]
    mov edi, [vga_base]

    mov ecx, 100                ; 100 GB rows → 200 VGA rows

.blit_row:
    ; VGA row 2N: 160 GB pixels, each written twice
    push esi
    push ecx
    mov ecx, SCREEN_W
.row1_px:
    mov al, [esi]
    inc esi
    mov [edi],     al
    mov [edi + 1], al
    add edi, 2
    dec ecx
    jnz .row1_px
    pop ecx
    pop esi                     ; rewind ESI to start of this GB row

    ; VGA row 2N+1: same GB row again (row doubling)
    push ecx
    mov ecx, SCREEN_W
.row2_px:
    mov al, [esi]
    inc esi
    mov [edi],     al
    mov [edi + 1], al
    add edi, 2
    dec ecx
    jnz .row2_px
    pop ecx
    ; ESI now points at the next GB row; EDI at the next VGA row pair

    dec ecx
    jnz .blit_row

    pop edi
    pop esi
    pop ecx
    pop eax
    ret
