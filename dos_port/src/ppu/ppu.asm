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
global render_sprites
global draw_player_marker
global g_player_marker_on

; Player placeholder marker — the player sprite is always at the fixed screen
; center (pret keeps the camera locked on the player and scrolls the BG). Until
; the OAM sprite renderer lands (Phase 1 open item), draw a simple two-tone box
; there so it's obvious where "you" are. Tile (8,8): 16×16 px at (64,64).
PLAYER_MARKER_X    equ 64
PLAYER_MARKER_Y    equ 64
PLAYER_MARKER_SIZE equ 16
PLAYER_MARKER_SHADE equ 3       ; darkest DMG shade for the outline/body
PLAYER_MARKER_INNER equ 0       ; lightest shade for the inner square

; ---------------------------------------------------------------------------
; BSS
; ---------------------------------------------------------------------------
section .bss
align 4
g_player_marker_on: resb 1 ; nonzero → draw_player_marker paints the placeholder
align 4
obp_tab:     resb 8        ; OBP0 shades in [0..3], OBP1 shades in [4..7]
spr_oam_ptr: resd 1        ; GB-relative offset of the current OAM entry
spr_count:   resd 1        ; OAM entries left to process
spr_sx:      resd 1        ; sprite left screen X (signed)
spr_sy:      resd 1        ; sprite top screen Y (signed)
spr_tilebase: resd 1       ; GB-relative address of the sprite's tile data
spr_attr:    resd 1        ; OAM attribute byte
spr_row:     resd 1        ; current sprite row 0..7
spr_rowbase: resd 1        ; GB-relative back-buffer offset of the current row
spr_lo:      resb 1        ; low bitplane of the current tile row
spr_hi:      resb 1        ; high bitplane of the current tile row
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

; ---------------------------------------------------------------------------
; render_sprites — composite the 40 OAM sprites over the back buffer.
;
; Emulates DMG OBJ rendering (8×8 mode, LCDC_OBJ_8): for each visible sprite,
; blit its 8×8 tile from the OBJ tile area ($8000, unsigned addressing) honoring
; X/Y flip, the OBP0/OBP1 palette, color-0 transparency, and the BG-priority bit
; (attr bit 7 → draw only over BG shade 0; correct under the standard BGP=$E4).
; Reads OAM from $FE00. Call after render_bg, before present.
;
; Simplifications vs. hardware: sprites are drawn in reverse OAM order so a lower
; index ends up on top (handles the index tiebreak, not the smaller-X-wins rule),
; and the 10-sprites-per-scanline limit is not enforced. 8×16 OBJ size (LCDC
; bit 2) is not handled — Pokémon overworld/menus use 8×8.
;
; In:  EBP = GB memory base. All registers preserved.
; ---------------------------------------------------------------------------
render_sprites:
    pushad
    test byte [ebp + IO_LCDC], LCDCF_OBJ_ON
    jz .done

    ; Unpack OBP0 → obp_tab[0..3], OBP1 → obp_tab[4..7].
    movzx eax, byte [ebp + IO_OBP0]
    xor edx, edx
.unpack0:
    mov ebx, eax
    and ebx, 3
    mov [obp_tab + edx], bl
    shr eax, 2
    inc edx
    cmp edx, 4
    jb .unpack0
    movzx eax, byte [ebp + IO_OBP1]
.unpack1:
    mov ebx, eax
    and ebx, 3
    mov [obp_tab + edx], bl
    shr eax, 2
    inc edx
    cmp edx, 8
    jb .unpack1

    mov dword [spr_oam_ptr], GB_OAM + (OAM_COUNT - 1) * OAM_ENTRY_SIZE
    mov dword [spr_count], OAM_COUNT

.spriteLoop:
    mov esi, [spr_oam_ptr]
    movzx eax, byte [ebp + esi]          ; Y (screen Y + 16)
    sub eax, OAM_Y_OFS
    mov [spr_sy], eax
    movzx eax, byte [ebp + esi + 1]      ; X (screen X + 8)
    sub eax, OAM_X_OFS
    mov [spr_sx], eax
    movzx eax, byte [ebp + esi + 2]      ; tile id
    shl eax, 4
    add eax, GB_VCHARS0
    mov [spr_tilebase], eax
    movzx eax, byte [ebp + esi + 3]      ; attributes
    mov [spr_attr], eax

    ; Cull sprites that fall entirely off-screen.
    mov eax, [spr_sy]
    cmp eax, SCREEN_H
    jge .nextSprite                      ; top at/below bottom edge
    add eax, 7
    js  .nextSprite                      ; bottom row above top edge
    mov eax, [spr_sx]
    cmp eax, SCREEN_W
    jge .nextSprite
    add eax, 7
    js  .nextSprite

    mov dword [spr_row], 0
.rowLoop:
    mov eax, [spr_sy]
    add eax, [spr_row]                   ; py
    js  .rowNext                         ; row above the screen
    cmp eax, SCREEN_H
    jge .rowNext
    imul ecx, eax, SCREEN_W
    add ecx, GB_BACKBUF
    mov [spr_rowbase], ecx

    ; srcrow = yflip ? 7 - row : row
    mov edx, [spr_row]
    test byte [spr_attr], OAM_YFLIP
    jz .noYFlip
    mov edx, 7
    sub edx, [spr_row]
.noYFlip:
    mov eax, [spr_tilebase]
    lea eax, [eax + edx * 2]
    mov dl, [ebp + eax]
    mov [spr_lo], dl
    mov dl, [ebp + eax + 1]
    mov [spr_hi], dl

    xor esi, esi                         ; col = 0..7
.colLoop:
    ; bit index = xflip ? col : 7 - col
    mov ecx, esi
    test byte [spr_attr], OAM_XFLIP
    jnz .haveBit
    mov ecx, 7
    sub ecx, esi
.haveBit:
    movzx eax, byte [spr_lo]
    shr eax, cl
    and eax, 1
    movzx ebx, byte [spr_hi]
    shr ebx, cl
    and ebx, 1
    lea eax, [eax + ebx * 2]             ; color 0..3
    test eax, eax
    jz .colNext                          ; color 0 = transparent

    ; shade = obp_tab[(pal1 ? 4 : 0) + color]
    mov ebx, eax
    test byte [spr_attr], OAM_PAL1
    jz .pal0
    add ebx, 4
.pal0:
    movzx ebx, byte [obp_tab + ebx]

    mov eax, [spr_sx]
    add eax, esi                         ; px
    js  .colNext
    cmp eax, SCREEN_W
    jge .colNext
    mov ecx, [spr_rowbase]
    add ecx, eax                         ; back-buffer offset (GB-relative)
    test byte [spr_attr], OAM_PRIO
    jz .writePx
    cmp byte [ebp + ecx], 0              ; behind BG: only over BG shade 0
    jne .colNext
.writePx:
    mov [ebp + ecx], bl
.colNext:
    inc esi
    cmp esi, 8
    jb .colLoop

.rowNext:
    inc dword [spr_row]
    cmp dword [spr_row], 8
    jb .rowLoop

.nextSprite:
    sub dword [spr_oam_ptr], OAM_ENTRY_SIZE
    dec dword [spr_count]
    jnz .spriteLoop

.done:
    popad
    ret

; ---------------------------------------------------------------------------
; draw_player_marker — paint the player placeholder into the back buffer.
;
; No-op unless g_player_marker_on is set (so it only shows in the overworld,
; not the title screen). Draws a PLAYER_MARKER_SIZE square of the darkest shade
; with a half-size lighter square inset, centered on the fixed player screen
; position. Call after render_bg, before present.
;
; In:  EBP = GB memory base. All registers preserved.
; ---------------------------------------------------------------------------
draw_player_marker:
    cmp byte [g_player_marker_on], 0
    jz .ret
    pushad

    ; Outer square: PLAYER_MARKER_SIZE × PLAYER_MARKER_SIZE of the body shade.
    mov edx, PLAYER_MARKER_Y
    mov ecx, PLAYER_MARKER_SIZE                  ; rows remaining
.outer_row:
    imul edi, edx, SCREEN_W
    lea edi, [ebp + GB_BACKBUF + edi + PLAYER_MARKER_X]
    push ecx
    mov ecx, PLAYER_MARKER_SIZE
    mov al, PLAYER_MARKER_SHADE
    rep stosb
    pop ecx
    inc edx
    dec ecx
    jnz .outer_row

    ; Inner square: half size, inset by a quarter, in the lighter shade.
    mov edx, PLAYER_MARKER_Y + PLAYER_MARKER_SIZE / 4
    mov ecx, PLAYER_MARKER_SIZE / 2
.inner_row:
    imul edi, edx, SCREEN_W
    lea edi, [ebp + GB_BACKBUF + edi + PLAYER_MARKER_X + PLAYER_MARKER_SIZE / 4]
    push ecx
    mov ecx, PLAYER_MARKER_SIZE / 2
    mov al, PLAYER_MARKER_INNER
    rep stosb
    pop ecx
    inc edx
    dec ecx
    jnz .inner_row

    popad
.ret:
    ret
