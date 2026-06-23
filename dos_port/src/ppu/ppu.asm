; ppu.asm — software PPU: scanline BG renderer + OAM compositor.
;
; Renders the 40×25 tile viewport directly into the 320×200 back buffer at
; [EBP + GB_BACKBUF], honoring the I/O register shadows:
;
;   IO_LCDC bit 3 — BG tilemap select   (0 = $9800, 1 = $9C00)
;   IO_LCDC bit 4 — tile data addressing (1 = $8000 unsigned,
;                                          0 = $8800 signed, base $9000)
;   IO_SCX/IO_SCY — background scroll (wraps at 256 px)
;   IO_BGP        — DMG palette: 4 × 2-bit shade, bits 1-0 = color 0
;
; STRATEGY (scanline + decoded tile cache): the whole BG/window tile-data
; region ($8000-$97FF, 384 tiles) is pre-decoded from 2bpp to 8bpp once into
; tile_cache (BGP shade baked in), and re-decoded only when VRAM tile data or
; BGP changes (g_tilecache_dirty / BGP compare). render_bg then builds each
; output scanline by COPYING decoded tile rows (8 bytes/tile) into
; bg_scanline_buf and copying 320 px from the (SCX & 7) fine offset — no
; per-pixel bit decoding in the hot path. Both axes scroll pixel-smooth; the GB
; tilemap wraps at (SCX/8 + col) & 31 and (y + SCY) >> 3 & 31.
;
; 2bpp tile format: each tile row is 2 bytes — byte 0 = low bitplane,
; byte 1 = high bitplane, bit 7 = leftmost pixel.
; color = (hi_bit << 1) | lo_bit.
;
; This is HAL code, not a pret translation — the SM83 register mapping does
; not apply here. EBP is the GB memory base.
;
; Build: nasm -f coff -I include/ -o ppu.o ppu.asm

bits 32

%include "gb_memmap.inc"
%include "gb_macros.inc"

LCDC_BG_MAP_BIT   equ 3        ; rLCDC bit 3: BG tilemap select
LCDC_TILEDATA_BIT equ 4        ; rLCDC bit 4: tile data addressing mode
LCDC_WIN_EN_BIT   equ 5        ; rLCDC bit 5: window enable
LCDC_WIN_MAP_BIT  equ 6        ; rLCDC bit 6: window tilemap select (0=$9800, 1=$9C00)

; ---------------------------------------------------------------------------
; Exported symbols
; ---------------------------------------------------------------------------
global render_bg
global render_window
global render_sprites
global draw_player_marker
global g_player_marker_on
global g_tilecache_dirty

; Player placeholder marker — the player sprite is always at the fixed screen
; center (pret keeps the camera locked on the player and scrolls the BG). Until
; the OAM sprite renderer lands (Phase 1 open item), draw a simple two-tone box
; there so it's obvious where "you" are. Tile (8,8): 16×16 px at (64,64).
PLAYER_MARKER_X    equ 64
PLAYER_MARKER_Y    equ 64
PLAYER_MARKER_SIZE equ 16
PLAYER_MARKER_SHADE equ 3       ; darkest DMG shade for the outline/body
PLAYER_MARKER_INNER equ 0       ; lightest shade for the inner square

; Decoded tile cache: the BG/window tile-data region $8000-$97FF is 0x1800
; bytes = 384 tiles of 16 bytes. Each is pre-decoded once to 8bpp (64 bytes)
; so render_bg copies rows instead of bit-decoding per pixel every frame.
; Stores the RAW 2-bit GB color (0-3), NOT a BGP-mapped shade — the VGA DAC
; does palette mapping (see commit_palette in video.asm), so the cache depends
; only on VRAM tile data and is rebuilt only on g_tilecache_dirty (a palette
; change is just a DAC reprogram, no rebuild).
TILE_CACHE_TILES  equ 384
TILE_CACHE_SIZE   equ TILE_CACHE_TILES * 64

; ---------------------------------------------------------------------------
; DATA (initialized — must start "dirty" so the first frame builds the cache)
; ---------------------------------------------------------------------------
section .data
align 4
g_tilecache_dirty: db 1     ; nonzero → render_bg rebuilds tile_cache this frame

; ---------------------------------------------------------------------------
; BSS
; ---------------------------------------------------------------------------
section .bss
align 4
tile_cache:  resb TILE_CACHE_SIZE  ; 384 × 64 = 24 KB of decoded raw-color tile rows
alignb 4
g_player_marker_on: resb 1 ; nonzero → draw_player_marker paints the placeholder
alignb 4
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
alignb 4
; Shared BG/window frame constants (written once per frame)
tiledata_mode:   resd 1    ; 1 = $8000 unsigned, 0 = $8800 signed
; render_bg surface-mirror state
bg_tilemap_base: resd 1    ; BG tilemap base addr ($9800 or $9C00)
bg_scy:          resd 1    ; SCY shadow
bg_scx:          resd 1    ; SCX shadow
sprite_shift_x:  resd 1    ; Dynamic X shift for sprites to align with DOS camera
sprite_shift_y:  resd 1    ; Dynamic Y shift for sprites
; 32-bit DOS position tables for each OAM entry (filled by PrepareOAMData)
global spr_dos_sy, spr_dos_sx, spr_oam_valid
spr_dos_sy:    resd OAM_COUNT  ; signed DOS Y for entry 0..OAM_COUNT-1
spr_dos_sx:    resd OAM_COUNT  ; signed DOS X for entry 0..OAM_COUNT-1
spr_oam_valid: resd 1          ; count of valid entries written this frame (set by PrepareOAMData)

; bg_surface: 384×288 raw-color mirror of wSurroundingTiles.
bg_surface:        resb 384 * 288
alignb 4
; render_window row buffer and scanline state
row_buf:         resb 256  ; decoded 256-px virtual window row (shade 0–3)
win_map_row:     resd 1    ; EBP-relative offset of current window tilemap row
win_fine_y2:     resd 1    ; (WLY & 7) * 2
win_line_ctr:    resd 1    ; WLY — window internal line counter (resets each frame)

; ---------------------------------------------------------------------------
; Code
; ---------------------------------------------------------------------------
section .text

; ---------------------------------------------------------------------------
; render_bg — blit the BG plane from a decoded offscreen surface (Tier 2 step 3).
;
; Instead of re-resolving 48 tiles × 200 scanlines from the VRAM tilemap every
; frame, we decode wSurroundingTiles (48x36 tiles) into bg_surface (384x288)
; every frame, then blit a 320x200 window at the calculated offset.
; ---------------------------------------------------------------------------
render_bg:
    pushad

    ; Tile-data addressing mode (LCDC bit 4): 1 = $8000 unsigned, 0 = $8800 signed
    movzx eax, byte [ebp + IO_LCDC]
    shr eax, LCDC_TILEDATA_BIT
    and eax, 1
    mov [tiledata_mode], eax

    ; sync tile cache if needed
    cmp byte [g_tilecache_dirty], 0
    je .cache_ok
    call rebuild_tile_cache
.cache_ok:

    ; ---- decode wSurroundingTiles (48x36) into bg_surface (384x288) ----
    xor ebx, ebx       ; EBX = tile index 0..1727 (48 * 36)
.decode_loop:
    movzx eax, word [ebp + W_CURRENT_TILE_BLOCK_MAP_VIEW_PTR]
    test eax, eax
    jz .decode_vram

    mov al, [ebp + W_SURROUNDING_TILES + ebx]
    jmp .got_tile

.decode_vram:
    mov eax, ebx
    mov ecx, 48
    xor edx, edx
    div ecx
    and edx, 31
    shl eax, 5
    add eax, edx
    mov ecx, GB_TILEMAP0
    test byte [ebp + IO_LCDC], 1 << 3
    jz .read_vram
    mov ecx, GB_TILEMAP1
.read_vram:
    add eax, ecx
    mov al, [ebp + eax]

.got_tile:
    
    ; get tile cache offset into ESI
    cmp dword [tiledata_mode], 0
    jne .uns
    movsx eax, al
    shl eax, 4
    add eax, 0x9000
    jmp .mode_ok
.uns:
    movzx eax, al
    shl eax, 4
    add eax, GB_VCHARS0
.mode_ok:
    sub eax, GB_VCHARS0
    shl eax, 2
    lea esi, [tile_cache + eax]

    ; Calculate destination in bg_surface
    ; row = EBX / 48, col = EBX % 48
    mov eax, ebx
    mov ecx, 48
    xor edx, edx
    div ecx
    ; EAX = row, EDX = col
    
    ; dest offset = row * 8 * 384 + col * 8
    imul eax, eax, 8 * 384
    lea edi, [bg_surface + eax + edx * 8]
    
    ; copy 8 rows
    mov ecx, 8
.row_copy:
    mov eax, [esi]
    mov [edi], eax
    mov eax, [esi + 4]
    mov [edi + 4], eax
    add esi, 8
    add edi, 384
    dec ecx
    jnz .row_copy

    inc ebx
    cmp ebx, 48 * 36
    jb .decode_loop

    ; ---- blit a 320x200 window from bg_surface ----
    ; Check if we are actually in the overworld (view pointer != 0)
    movzx eax, word [ebp + W_CURRENT_TILE_BLOCK_MAP_VIEW_PTR]
    test eax, eax
    jz .not_overworld

    ; The view pointer (wCurrentTileBlockMapViewPointer) identifies the top-left
    ; block of wSurroundingTiles. We subtract it from the map origin (MAP_BORDER)
    ; to find the world block coordinate of bg_surface.
    movzx ecx, byte [ebp + W_CUR_MAP_WIDTH]
    add ecx, MAP_BORDER * 2
    sub eax, W_OVERWORLD_MAP
    xor edx, edx
    div ecx
    ; EAX = view_block_y, EDX = view_block_x
    mov ebx, eax   ; save view_block_y in EBX
    
    ; Xoff = (MAP_BORDER*32 + wXCoord*16 - view_block_x*32) - 160 + walk_offset_x
    mov eax, MAP_BORDER
    sub eax, edx             ; eax = MAP_BORDER - view_block_x
    shl eax, 5               ; * 32
    movzx ecx, byte [ebp + W_X_COORD]
    shl ecx, 4               ; * 16
    add eax, ecx
    sub eax, 160
    
    ; walk_offset_x = X_STEP_VECTOR * (8 - wWalkCounter) * 2 (only if walking)
    movzx ecx, byte [ebp + W_WALK_COUNTER]
    test ecx, ecx
    jz .no_walk_x
    push ebx
    mov ebx, 8
    sub ebx, ecx             ; ebx = 8 - walk_counter
    shl ebx, 1               ; ebx = (8 - walk_counter) * 2
    movsx ecx, byte [ebp + W_SPRITE_PLAYER_X_STEP_VECTOR]
    imul ecx, ebx            ; ecx = step_vector * offset
    add eax, ecx
    pop ebx
.no_walk_x:
    
    ; EAX is now Original_Xoff
    mov [sprite_shift_x], eax
    
    ; Clamp X to 0..64 to stay within bg_surface
    test eax, eax
    jns .x_min_ok
    xor eax, eax
.x_min_ok:
    cmp eax, 64
    jle .x_max_ok
    mov eax, 64
.x_max_ok:
    mov [bg_scx], eax
    
    ; Shift_X = GB_Screen_Abs_X - bg_scx
    mov eax, [sprite_shift_x]
    sub eax, [bg_scx]
    mov [sprite_shift_x], eax
    
    ; Yoff = (MAP_BORDER*32 + wYCoord*16 - view_block_y*32) - 96 + walk_offset_y
    mov eax, MAP_BORDER
    sub eax, ebx             ; eax = MAP_BORDER - view_block_y
    shl eax, 5               ; * 32
    movzx ecx, byte [ebp + W_Y_COORD]
    shl ecx, 4               ; * 16
    add eax, ecx
    sub eax, 96
    
    ; walk_offset_y = Y_STEP_VECTOR * (8 - wWalkCounter) * 2 (only if walking)
    movzx ecx, byte [ebp + W_WALK_COUNTER]
    test ecx, ecx
    jz .no_walk_y
    push ebx
    mov ebx, 8
    sub ebx, ecx             ; ebx = 8 - walk_counter
    shl ebx, 1               ; ebx = (8 - walk_counter) * 2
    movsx ecx, byte [ebp + W_SPRITE_PLAYER_Y_STEP_VECTOR]
    imul ecx, ebx            ; ecx = step_vector * offset
    add eax, ecx
    pop ebx
.no_walk_y:
    
    ; EAX is now Original_Yoff
    mov [sprite_shift_y], eax
    
    ; Clamp Y to 0..88 to stay within bg_surface
    test eax, eax
    jns .y_min_ok
    xor eax, eax
.y_min_ok:
    cmp eax, 88
    jle .y_max_ok
    mov eax, 88
.y_max_ok:
    mov [bg_scy], eax
    
    ; Shift_Y = GB_Screen_Abs_Y - bg_scy
    mov eax, [sprite_shift_y]
    sub eax, [bg_scy]
    mov [sprite_shift_y], eax
    
    jmp .do_blit

.not_overworld:
    movzx ecx, byte [ebp + IO_SCX]
    mov dword [bg_scx], ecx
    mov dword [sprite_shift_x], 0
    movzx ecx, byte [ebp + IO_SCY]
    mov dword [bg_scy], ecx
    mov dword [sprite_shift_y], 0

.do_blit:

    ; blit 320x200 from bg_surface at (Xoff, Yoff)
    xor edx, edx   ; screen y
.blit_row:
    mov eax, [bg_scy]
    add eax, edx
    
    movzx ecx, word [ebp + W_CURRENT_TILE_BLOCK_MAP_VIEW_PTR]
    test ecx, ecx
    jnz .no_y_wrap
    and eax, 255
.no_y_wrap:

    imul eax, eax, 384
    mov ecx, [bg_scx]
    add eax, ecx
    lea esi, [bg_surface + eax]
    
    mov edi, edx
    imul edi, RENDER_W
    lea edi, [ebp + GB_BACKBUF + edi]

    ; 320 bytes = 80 dwords
    mov ecx, RENDER_W / 4
    rep movsd

    inc edx
    cmp edx, RENDER_H
    jb .blit_row

    popad
    ret

; ---------------------------------------------------------------------------
; rebuild_tile_cache — decode the 384 BG/window tiles ($8000-$97FF) to 8bpp.
;
; Each 16-byte 2bpp tile becomes 64 bytes (8×8) of RAW color (0-3) in
; tile_cache, laid out linearly (tile i at offset i*64). render_bg then copies
; decoded rows instead of bit-decoding per pixel. Both source (VRAM) and dest
; (cache) are contiguous, so a single source pointer / dest pointer suffice.
; No BGP is applied here — the VGA DAC maps color→shade (commit_palette).
;
; Clears g_tilecache_dirty. In: EBP = GB memory base. All registers preserved.
; ---------------------------------------------------------------------------
rebuild_tile_cache:
    pushad

    mov esi, GB_VCHARS0                ; GB offset of the first tile-data byte
    mov edi, tile_cache
    mov edx, TILE_CACHE_TILES * 8      ; total tile rows (8 per tile)
.row_loop:
    mov bl, [ebp + esi]               ; low bitplane
    mov bh, [ebp + esi + 1]           ; high bitplane
    add esi, 2
    mov ecx, 8
.px_loop:
    xor eax, eax
    shl bh, 1
    rcl al, 1
    shl bl, 1
    rcl al, 1
    stosb                             ; tile_cache[..] = raw color 0-3 (ES:[EDI])
    dec ecx
    jnz .px_loop
    dec edx
    jnz .row_loop

    mov byte [g_tilecache_dirty], 0
    popad
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

    ; No OBP unpack: sprite pixels are written as raw palette-indexed values
    ; (4 + color for OBP0, 8 + color for OBP1). commit_palette (video.asm) sets
    ; DAC entries 4-7 / 8-11 to the OBP0/OBP1-mapped DMG shades.

    mov dword [spr_oam_ptr], GB_OAM + (OAM_COUNT - 1) * OAM_ENTRY_SIZE
    mov dword [spr_count], OAM_COUNT

.spriteLoop:
    mov esi, [spr_oam_ptr]
    mov ecx, esi                         ; entry index = (oam_ptr - GB_OAM) >> 2
    sub ecx, GB_OAM
    shr ecx, 2
    cmp ecx, [spr_oam_valid]             ; skip entries PrepareOAMData did not write
    jae .nextSprite
    mov eax, [spr_dos_sy + ecx*4]        ; 32-bit DOS Y set by PrepareOAMData
    add eax, [sprite_shift_y]
    mov [spr_sy], eax
    mov eax, [spr_dos_sx + ecx*4]        ; 32-bit DOS X set by PrepareOAMData
    add eax, [sprite_shift_x]
    mov [spr_sx], eax
    movzx eax, byte [ebp + esi + 2]      ; tile id
    shl eax, 4
    add eax, GB_VCHARS0
    mov [spr_tilebase], eax
    movzx eax, byte [ebp + esi + 3]      ; attributes
    mov [spr_attr], eax

    ; Cull sprites that fall entirely off-screen.
    mov eax, [spr_sy]
    cmp eax, RENDER_H
    jge .nextSprite                      ; top at/below bottom edge
    add eax, 7
    js  .nextSprite                      ; bottom row above top edge
    mov eax, [spr_sx]
    cmp eax, RENDER_W
    jge .nextSprite
    add eax, 7
    js  .nextSprite

    mov dword [spr_row], 0
.rowLoop:
    mov eax, [spr_sy]
    add eax, [spr_row]                   ; py
    js  .rowNext                         ; row above the screen
    cmp eax, RENDER_H
    jge .rowNext
    imul ecx, eax, RENDER_W
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

    ; pixel = palette base + color: OBP0 → 4+color, OBP1 → 8+color. The DAC
    ; (commit_palette) maps 4-7 / 8-11 to the OBP0/OBP1-mapped DMG shades.
    lea ebx, [eax + 4]
    test byte [spr_attr], OAM_PAL1
    jz .pal0
    lea ebx, [eax + 8]
.pal0:

    mov eax, [spr_sx]
    add eax, esi                         ; px
    js  .colNext
    cmp eax, RENDER_W
    jge .colNext
    mov ecx, [spr_rowbase]
    add ecx, eax                         ; back-buffer offset (GB-relative)
    test byte [spr_attr], OAM_PRIO
    jz .writePx
    cmp byte [ebp + ecx], 0              ; behind BG: only over BG color 0
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
; render_window — composite the GB window layer over the back buffer.
;
; The window is a non-scrolling BG-like plane that overlays the main BG from
; screen position (WX-7, WY) downward. It is enabled by LCDC bit 5 (and the
; BG/Window master enable, LCDC bit 0). LCDC bit 6 selects its tilemap
; ($9800 vs $9C00). Tile data addressing follows LCDC bit 4, identical to the
; BG. BGP applies — the window is fully opaque (color 0 is NOT transparent).
;
; WLY — window internal line counter:
;   WLY starts at 0 each frame and increments once for every scanline on which
;   the window is drawn (cur_y >= WY). It is NOT the same as LY. WLY is what
;   indexes the window tilemap row, so if the window becomes visible only at
;   screen row 72, the first window tilemap row (WLY=0) maps there — not row 9.
;   This prevents visual drift when the window starts mid-frame. The implementation
;   stores WLY in win_line_ctr (BSS) and increments it after each active scanline.
;
; Call after render_bg and before render_sprites.
; In:  EBP = GB memory base. All registers preserved.
; ---------------------------------------------------------------------------
render_window:
    pushad

    ; Exit if LCDC bit 5 (window enable) is clear.
    test byte [ebp + IO_LCDC], 1 << LCDC_WIN_EN_BIT
    jz .done
    ; GLITCH: LCDC bit 0 is the DMG BG+Window master enable — if clear, both
    ; the BG and window are disabled (screen shows BGP color 0 only on DMG).
    test byte [ebp + IO_LCDC], 1
    jz .done

    ; No BGP unpack: the window writes raw color (0-3) like the BG; the DAC
    ; (commit_palette) maps it via BGP — the window shares the BG palette.

    ; Cache tile data addressing mode (shared LCDC bit 4).
    movzx eax, byte [ebp + IO_LCDC]
    shr eax, LCDC_TILEDATA_BIT
    and eax, 1
    mov [tiledata_mode], eax

    ; Reset WLY for this frame.
    mov dword [win_line_ctr], 0

    movzx ebx, byte [ebp + IO_WY]     ; EBX = WY (window top edge, screen-Y units)

    xor ecx, ecx                       ; cur_y = 0

.scanline_loop:
    ; Skip scanlines above the window's vertical trigger.
    cmp ecx, ebx                       ; cur_y < WY?
    jb .next_scanline

    ; ── Decode one window tile row (32 tiles) into row_buf ──────────────────

    ; fine_y2 = (WLY & 7) * 2
    mov edx, [win_line_ctr]
    mov eax, edx
    and eax, 7
    shl eax, 1
    mov [win_fine_y2], eax

    ; map_row = window_tilemap_base + (WLY >> 3) * 32
    shr edx, 3
    shl edx, 5
    test byte [ebp + IO_LCDC], 1 << LCDC_WIN_MAP_BIT
    jz .winmap0
    add edx, GB_TILEMAP1
    jmp .winmap_done
.winmap0:
    add edx, GB_TILEMAP0
.winmap_done:
    mov [win_map_row], edx

    push ecx                            ; save scanline counter — decode_win_row clobbers ECX
    call decode_win_row                ; fill row_buf[0..255] from the 32 window tiles
    pop ecx                            ; restore scanline counter

    ; ── Copy visible window pixels into the back buffer ─────────────────────

    ; wx_adj = WX - 7: signed screen X of the window's left column.
    movzx edx, byte [ebp + IO_WX]
    sub edx, 7                         ; EDX = wx_adj (signed)

    ; EDI = start of this back-buffer row.
    push ecx
    imul ecx, ecx, RENDER_W
    lea edi, [ebp + GB_BACKBUF + ecx]
    pop ecx

    test edx, edx
    js .win_left_clip

    ; wx_adj >= 0: copy row_buf[0..] → backbuf[wx_adj..RENDER_W-1].
    cmp edx, RENDER_W
    jge .win_inc_ctr                   ; window entirely off the right edge
    lea esi, [row_buf]
    push ecx
    mov ecx, RENDER_W
    sub ecx, edx                       ; pixels to reach the right edge
    cmp ecx, 256
    jbe .do_right_copy
    mov ecx, 256                       ; clamp — row_buf holds only 256 decoded px
.do_right_copy:                        ; (32 tiles); never read past it into BSS
    add edi, edx                       ; advance dest to screen_x_start
    rep movsb
    pop ecx
    jmp .win_inc_ctr

.win_left_clip:
    ; wx_adj < 0: skip the first -wx_adj pixels of row_buf, copy into backbuf[0..].
    neg edx                            ; EDX = number of leading columns to clip
    lea esi, [row_buf + edx]
    push ecx
    mov ecx, RENDER_W
    mov eax, 256
    sub eax, edx                       ; bytes remaining in row_buf after the clip
    cmp ecx, eax
    jbe .do_left_copy
    mov ecx, eax                       ; clamp — never read past row_buf end
.do_left_copy:
    rep movsb
    pop ecx

.win_inc_ctr:
    inc dword [win_line_ctr]

.next_scanline:
    inc ecx
    ; Bound at SCREEN_H (144), the GB logical screen height — NOT RENDER_H (200).
    ; Pokémon parks the window at WY=144 to hide it on the 144-px GB screen; our
    ; taller 320×200 viewport would otherwise paint the parked (uninitialized)
    ; window over rows 144–199. Limiting the window to the GB-logical area keeps
    ; the park semantics. (A textbox for the full 200-px viewport is future
    ; window-layer work — see TODO.md.)
    cmp ecx, SCREEN_H
    jb .scanline_loop

.done:
    popad
    ret

; ---------------------------------------------------------------------------
; decode_win_row — decode the 32 window tiles of the current row into row_buf
;
; In:  [win_map_row] = GB tilemap row base address
;      [win_fine_y2] = (WLY & 7) * 2
;      [tiledata_mode] set by render_window preamble. Stores raw color 0-3.
; Clobbers: EAX, EBX, ECX, EDX, ESI, EDI
; ---------------------------------------------------------------------------
decode_win_row:
    mov edi, row_buf
    xor esi, esi                       ; tile column 0..31

.wrow_tile:
    mov eax, [win_map_row]
    add eax, esi
    movzx eax, byte [ebp + eax]       ; tile_id

    cmp dword [tiledata_mode], 0
    jne .wrow_unsigned
    movsx eax, al
    shl eax, 4
    add eax, 0x9000
    jmp .wrow_addr_ok
.wrow_unsigned:
    shl eax, 4
    add eax, GB_VRAM0
.wrow_addr_ok:
    add eax, [win_fine_y2]

    mov bl, [ebp + eax]
    mov bh, [ebp + eax + 1]

    mov ecx, 8
.wrow_px:
    xor eax, eax
    shl bh, 1
    rcl al, 1
    shl bl, 1
    rcl al, 1
    stosb                              ; raw color 0-3 (DAC maps via BGP)
    dec ecx
    jnz .wrow_px

    inc esi
    cmp esi, TILEMAP_W
    jb .wrow_tile
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
    imul edi, edx, RENDER_W
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
    imul edi, edx, RENDER_W
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
