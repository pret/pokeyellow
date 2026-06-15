; video.asm — VGA mode 13h initialisation, test pattern, and frame present.
;
; Mode 13h: 320×200, 256 indexed colors, linear framebuffer at 0xA0000.
; Under DPMI, INT 10h is reflected to the real-mode BIOS automatically.
;
; ADDRESSING NOTE: DS base is not linear 0 under DJGPP. All VGA framebuffer
; access goes through [vga_base], computed at init as 0xA0000 - ds_base.
; This requires the 4 GB DS limit set by setup_flat_access (entry.asm) —
; the offset wraps modulo 2^32 and lands on linear 0xA0000.
;
; present() copies the 320×200 tile-blitter back buffer to VGA via rep movsd.
; No scaling, no letterbox — the back buffer matches VGA dimensions exactly.
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
global present           ; copy 320×200 back buffer → VGA framebuffer
global draw_tick_band    ; visible PIT tick indicator (top screen band)
global commit_palette    ; map BGP/OBP0/OBP1 → DAC entries 0-11 (raw-index render)

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

; Last BGP/OBP0/OBP1 committed to the DAC. Init to 0xFF so the first
; commit_palette call always reprograms (no valid GB palette reads as 0xFFFFFF).
align 4
pal_shadow:
    db 0xFF, 0xFF, 0xFF

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
; commit_palette — map GB BGP/OBP0/OBP1 → VGA DAC entries 0-11.
;
; The PPU renderer writes RAW GB color indices into the back buffer:
;   BG/window color 0-3 → DAC 0-3
;   OBP0 sprite color   → DAC 4-7
;   OBP1 sprite color   → DAC 8-11
; This routine programs those 12 DAC entries from dmg_palette using the current
; GB palette registers, so a BGP/OBP fade/flash is just a DAC reprogram — no
; tile re-decode. DAC entry (base + c) = dmg_palette[(reg >> 2c) & 3].
;
; Skipped when BGP/OBP0/OBP1 are unchanged since the last commit (pal_shadow).
; Called once per frame from DelayFrame (after wait_vblank). IO_BGP/OBP0/OBP1
; are three consecutive GB registers ($FF47-$FF49).
;
; In: EBP = GB memory base. All registers preserved.
; ---------------------------------------------------------------------------
commit_palette:
    pushad

    ; Skip if the three palette registers are unchanged.
    mov al, [ebp + IO_BGP]
    cmp al, [pal_shadow]
    jne .reprogram
    mov al, [ebp + IO_OBP0]
    cmp al, [pal_shadow + 1]
    jne .reprogram
    mov al, [ebp + IO_OBP1]
    cmp al, [pal_shadow + 2]
    je .done

.reprogram:
    mov al, [ebp + IO_BGP]
    mov [pal_shadow], al
    mov al, [ebp + IO_OBP0]
    mov [pal_shadow + 1], al
    mov al, [ebp + IO_OBP1]
    mov [pal_shadow + 2], al

    ; DAC write index = 0 (auto-increments after each RGB triple).
    mov dx, 0x3C8
    xor al, al
    out dx, al
    mov dx, 0x3C9                  ; DAC data port

    lea esi, [ebp + IO_BGP]        ; 3 consecutive regs: BGP, OBP0, OBP1
    mov ebx, 3                     ; palette register count
.reg_loop:
    movzx ebp, byte [esi]          ; reg value (EBP free — saved by pushad)
    inc esi
    mov ecx, 4                     ; 4 colors per palette
.color_loop:
    mov eax, ebp
    and eax, 3                     ; shade index 0-3 for this color
    lea edi, [dmg_palette + eax*2]
    add edi, eax                   ; edi = dmg_palette + 3*shade
    mov al, [edi]                  ; R
    out dx, al
    mov al, [edi + 1]              ; G
    out dx, al
    mov al, [edi + 2]              ; B
    out dx, al
    shr ebp, 2
    dec ecx
    jnz .color_loop
    dec ebx
    jnz .reg_loop

.done:
    popad
    ret

; ---------------------------------------------------------------------------
; present — copy 320×200 back buffer to VGA framebuffer
;
; Reads:  [EBP + GB_BACKBUF] — 320×200 8bpp pixels (raw-index PPU output)
; Writes: [vga_base] — VGA linear framebuffer (Mode 13h)
;
; Single rep movsd of 16,000 dwords.  No scaling, no letterbox.
; ---------------------------------------------------------------------------
present:
    push ecx
    push esi
    push edi

    lea esi, [ebp + GB_BACKBUF]
    mov edi, [vga_base]
    mov ecx, RENDER_W * RENDER_H / 4      ; 16,000 dwords
    rep movsd

    pop edi
    pop esi
    pop ecx
    ret
