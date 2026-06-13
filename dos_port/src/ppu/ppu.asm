; ppu.asm — software PPU: BG tile decoder and tilemap renderer.
;
; Renders the 160×144 background layer into the back buffer at
; [EBP + GB_BACKBUF], honoring the I/O register shadows:
;
;   IO_LCDC bit 3 — BG tilemap select   (0 = $9800, 1 = $9C00)
;   IO_LCDC bit 4 — tile data addressing (1 = $8000 unsigned,
;                                          0 = $8800 signed, base $9000)
;   IO_SCX/IO_SCY — background scroll (wraps at 256 px)
;   IO_BGP        — DMG palette: 4 × 2-bit shade, bits 1-0 = color 0
;
; STRATEGY (row buffer): for each of the 144 screen rows, decode the full
; 256-pixel virtual BG row (32 tiles) into row_buf, then copy 160 bytes
; starting at SCX. The wrap at x=256 becomes at most two straight copies —
; no per-pixel masking in the hot path.
;
; 2bpp tile format (see docs/references/pandocs/Tile_Data.md): each tile row
; is 2 bytes — byte 0 = low bitplane, byte 1 = high bitplane, bit 7 = leftmost
; pixel. color = (hi_bit << 1) | lo_bit.
;
; This is HAL code, not a pret translation — the SM83 register mapping does
; not apply here. EBP is still the GB memory base and must not be touched.
;
; TODO (Phase 1, later): window layer, OAM sprites, CGB attributes (VRAM
; bank 1 tile fetch, palette/flip bits from the $9800 mirror in bank 1).
;
; Build: nasm -f coff -I include/ -o ppu.o ppu.asm

bits 32

%include "gb_memmap.inc"
%include "gb_macros.inc"

LCDC_BG_MAP_BIT   equ 3        ; rLCDC bit 3: BG tilemap select
LCDC_TILEDATA_BIT equ 4        ; rLCDC bit 4: tile data addressing mode

; ---------------------------------------------------------------------------
; Exported symbols
; ---------------------------------------------------------------------------
global render_bg

; ---------------------------------------------------------------------------
; BSS
; ---------------------------------------------------------------------------
section .bss
align 4
row_buf:    resb 256       ; one decoded 256-px virtual BG row (shade 0–3)
bgp_tab:    resb 4         ; BGP unpacked: bgp_tab[color] = shade
cur_y:      resd 1         ; current screen row (0–143)
map_row:    resd 1         ; EBP-relative offset of current tilemap row
fine_y2:    resd 1         ; (sy & 7) * 2 — byte offset of the tile row pair
tiledata_mode: resd 1      ; 1 = $8000 unsigned, 0 = $8800 signed

; ---------------------------------------------------------------------------
; Code
; ---------------------------------------------------------------------------
section .text

; ---------------------------------------------------------------------------
; render_bg — render the full 160×144 BG layer into [EBP + GB_BACKBUF]
;
; In:  EBP = GB memory base (reads VRAM, tilemaps, IO shadows through it)
; Out: back buffer filled with shade indices 0–3. All registers preserved.
; ---------------------------------------------------------------------------
render_bg:
    pushad

    ; Unpack BGP into bgp_tab: shade for color c = (BGP >> c*2) & 3
    movzx eax, byte [ebp + IO_BGP]
    mov ecx, 4
    xor edx, edx
.bgp_loop:
    mov ebx, eax
    and ebx, 3
    mov [bgp_tab + edx], bl
    shr eax, 2
    inc edx
    loop .bgp_loop

    ; Cache tile data mode (LCDC bit 4)
    movzx eax, byte [ebp + IO_LCDC]
    shr eax, LCDC_TILEDATA_BIT
    and eax, 1
    mov [tiledata_mode], eax

    mov dword [cur_y], 0

.row_loop:
    ; sy = (cur_y + SCY) & 0xFF
    mov eax, [cur_y]
    movzx edx, byte [ebp + IO_SCY]
    add eax, edx
    and eax, 0xFF

    ; fine_y2 = (sy & 7) * 2
    mov edx, eax
    and edx, 7
    add edx, edx
    mov [fine_y2], edx

    ; map_row = tilemap_base + (sy >> 3) * 32
    shr eax, 3
    shl eax, 5
    test byte [ebp + IO_LCDC], 1 << LCDC_BG_MAP_BIT
    jz .map0
    add eax, GB_TILEMAP1
    jmp .map_done
.map0:
    add eax, GB_TILEMAP0
.map_done:
    mov [map_row], eax

    call decode_row             ; fill row_buf from the 32 tiles of this row

    ; Copy 160 px from row_buf starting at SCX into the back buffer row,
    ; splitting at the 256-px wrap if needed.
    mov eax, [cur_y]
    imul edi, eax, SCREEN_W
    lea edi, [ebp + GB_BACKBUF + edi]   ; EDI = back buffer row

    movzx esi, byte [ebp + IO_SCX]      ; ESI = start offset in row_buf
    mov ecx, 256
    sub ecx, esi                        ; bytes until wrap
    cmp ecx, SCREEN_W
    jbe .split_copy

    ; No wrap: single 160-byte copy
    lea esi, [row_buf + esi]
    mov ecx, SCREEN_W
    rep movsb
    jmp .row_done

.split_copy:
    ; First segment: row_buf[SCX .. 255], then wrap to row_buf[0 ..]
    lea esi, [row_buf + esi]
    mov edx, SCREEN_W
    sub edx, ecx                        ; EDX = remainder after the wrap
    rep movsb
    mov esi, row_buf
    mov ecx, edx
    rep movsb

.row_done:
    inc dword [cur_y]
    cmp dword [cur_y], SCREEN_H
    jb .row_loop

    popad
    ret

; ---------------------------------------------------------------------------
; decode_row — decode the 32 tiles of the current tilemap row into row_buf
;
; In:  [map_row]  = EBP-relative offset of the tilemap row (32 tile IDs)
;      [fine_y2]  = (sy & 7) * 2
;      [tiledata_mode], [bgp_tab] already set up
;      EBP = GB memory base
; Clobbers: EAX, EBX, ECX, EDX, ESI, EDI
; ---------------------------------------------------------------------------
decode_row:
    mov edi, row_buf
    xor esi, esi                ; ESI = tile column 0–31

.tile_loop:
    ; Fetch tile ID from the tilemap
    mov eax, [map_row]
    add eax, esi
    movzx eax, byte [ebp + eax]

    ; Resolve tile data address per LCDC bit 4
    cmp dword [tiledata_mode], 0
    jne .unsigned_mode
    ; $8800 signed mode: addr = $9000 + sext8(id) * 16
    movsx eax, al
    shl eax, 4
    add eax, 0x9000
    jmp .addr_done
.unsigned_mode:
    ; $8000 unsigned mode: addr = $8000 + id * 16
    shl eax, 4
    add eax, GB_VRAM0
.addr_done:
    add eax, [fine_y2]

    ; Fetch the bitplane pair for this tile row
    mov bl, [ebp + eax]         ; BL = low bitplane
    mov bh, [ebp + eax + 1]     ; BH = high bitplane

    ; Decode 8 pixels, bit 7 (leftmost) first
    mov ecx, 8
.px_loop:
    xor eax, eax
    shl bh, 1                   ; high bit → CF
    rcl al, 1                   ; AL = hi_bit
    shl bl, 1
    rcl al, 1                   ; AL = (hi << 1) | lo
    mov al, [bgp_tab + eax]     ; apply BGP: color → shade
    stosb
    loop .px_loop

    inc esi
    cmp esi, TILEMAP_W
    jb .tile_loop
    ret
