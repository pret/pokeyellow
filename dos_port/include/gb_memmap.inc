; gb_memmap.inc — EBP-relative offsets for the emulated Game Boy address space.
; Source of truth: constants/hardware.inc and the GB memory map specification.
; All offsets are relative to EBP (the base of the 72 KB DPMI allocation).
; See docs/references/pandocs/Memory_Map.md for the authoritative address table.

%ifndef GB_MEMMAP_INC
%define GB_MEMMAP_INC

; ---------------------------------------------------------------------------
; GB address space regions (EBP + offset)
; ---------------------------------------------------------------------------

; VRAM bank 0 — $8000–$9FFF (8 KB)
; Contains tile data (chars) and BG tilemaps. Accessible by CPU except during
; PPU Mode 3 (Drawing). CGB has a second bank (GB_VRAM1 below).
GB_VRAM0        equ 0x8000

; VRAM tile-data sub-regions (pret labels vChars0/1/2). Each is 128 tiles.
; The font is loaded to vFont ($8800); in $8800-signed addressing (LCDC_DEFAULT)
; tile index C ('A'=$80) -> $9000 + sext8(C)*16 = $8800 + (C-$80)*16 = vFont.
; So char codes index tiles directly — a string drops straight into a tilemap.
GB_VCHARS0      equ 0x8000     ; vChars0  — sprite/overworld tiles
GB_VFONT        equ 0x8800     ; vFont / vChars1 — text font (char $80 = 'A')
GB_VCHARS2      equ 0x9000     ; vChars2 / vTileset — tileset, box graphics

; BG tilemap 0 — $9800–$9BFF (1 KB)
; 32x32 tile indices; each byte is an index into the tile data.
; Matches TILEMAP0 (0x9800) in constants/hardware.inc.
GB_TILEMAP0     equ 0x9800

; BG tilemap 1 — $9C00–$9FFF (1 KB)
; Matches TILEMAP1 (0x9C00) in constants/hardware.inc.
GB_TILEMAP1     equ 0x9C00

; WRAM bank 0 — $C000–$CFFF (4 KB)
; Always available. General-purpose work RAM.
GB_WRAM0        equ 0xC000

; Named WRAM symbols (subset needed by translated routines).
; Offsets from pokeyellow.sym (bank 00).
W_SHADOW_OAM        equ 0xC300     ; wShadowOAM — 40 sprites × 4 bytes
W_SHADOW_OAM_END    equ 0xC3A0
W_SHADOW_OAM_SIZE   equ 0xA0       ; 160 bytes
W_TILEMAP           equ 0xC3A0     ; wTileMap — 20×18 screen tile buffer
W_TILEMAP_SIZE      equ 360        ; SCREEN_W_TILES * SCREEN_H_TILES

; WRAM bank 1 — $D000–$DFFF (4 KB)
; On CGB: banks 1–7 are switchable via rWBK ($FF70).
; For now, bank 1 is the only one allocated here. CGB banking TBD.
GB_WRAM1        equ 0xD000

; Echo RAM region — $E000–$FDFF (mirrors $C000–$DDFF)
; The pret source avoids using Echo RAM; not allocated here.
; If a translated routine reads/writes $E000+, redirect to $C000+.
; GB_ECHO        equ 0xE000  ; not allocated — redirect to GB_WRAM0

; OAM — $FE00–$FE9F (160 bytes = 40 sprites × 4 bytes each)
; Format per sprite: Y, X, tile ID, flags. See constants/hardware.inc OAM constants.
GB_OAM          equ 0xFE00
GB_OAM_SIZE     equ 160        ; 40 * 4

; I/O register shadow area — $FF00–$FF7F (128 bytes)
; Holds emulated values of GB I/O registers. Written by game logic;
; read by the software renderer and input handler.
GB_IO           equ 0xFF00

; H-flag shadow — placed at $FF7E (unused by original GB, within our IO block)
; Lazy H-flag storage for DAA/CPL/etc. Only valid immediately before those instructions.
; See docs/register_map.md for the H-flag protocol.
hf_shadow       equ 0xFF7E

; HRAM — $FF80–$FFFE (127 bytes)
; High RAM; used by the game for fast-access variables (see ram/hram.asm).
GB_HRAM         equ 0xFF80
GB_HRAM_SIZE    equ 127

; Named HRAM variables (subset needed by translated routines).
; Offsets from pokeyellow.sym (bank 00).
H_SOFT_RESET             equ 0xFF8A     ; hSoftReset
H_SERIAL_CONN_STATUS     equ 0xFFAA     ; hSerialConnectionStatus
H_SCX                    equ 0xFFAE     ; hSCX — shadow of rSCX
H_SCY                    equ 0xFFAF     ; hSCY — shadow of rSCY
H_WY                     equ 0xFFB0     ; hWY  — shadow of rWY
H_LOADED_ROM_BANK        equ 0xFFB8     ; hLoadedROMBank
H_AUTO_BG_TRANSFER_EN    equ 0xFFBA     ; hAutoBGTransferEnabled
H_AUTO_BG_TRANSFER_DEST  equ 0xFFBC     ; hAutoBGTransferDest (2 bytes, lo/hi)
H_FRAME_COUNTER          equ 0xFFD5     ; hFrameCounter
H_VBLANK_OCCURRED        equ 0xFFD6     ; hVBlankOccurred
H_TILE_ANIMATIONS        equ 0xFFD7     ; hTileAnimations
H_UI_LAYOUT_FLAGS        equ 0xFFFA     ; hUILayoutFlags

BIT_SINGLE_SPACED_LINES  equ 2          ; hUILayoutFlags bit (gfx_constants.asm)

; Joypad HRAM ($FFB1-$FFB7) — order confirmed by hram.asm + H_SCX=$FFAE anchor
H_JOY_PRESSED            equ 0xFFB3     ; hJoyPressed — buttons just pressed this frame
H_JOY_HELD               equ 0xFFB4     ; hJoyHeld    — buttons currently held

; Named WRAM symbols (beyond the text-engine subset)
; Addresses from pokeyellow.sym layout (TODO: verify when ROM build is available).
W_PLAYER_NAME            equ 0xD158     ; wPlayerName — 11 bytes, '@'-terminated
W_RIVAL_NAME             equ 0xD34A     ; wRivalName  — 11 bytes, '@'-terminated

; IE register shadow — $FFFF (1 byte)
; Emulated Interrupt Enable register. Not functionally used by the DOS port
; (interrupts are handled by the PIT ISR and input handler directly).
GB_IE           equ 0xFFFF

; VRAM bank 1 (CGB only) — placed at offset $10000 (past the 64 KB GB window)
; The allocation in entry.asm requests 72 KB (0x12000) to cover this.
; CGB tile attribute data and extra tile graphics live here.
GB_VRAM1        equ 0x10000
GB_VRAM1_SIZE   equ 0x2000     ; 8 KB

; Back buffer — 160x144 pixels, 8bpp (one byte per pixel, palette index)
; Placed just after VRAM bank 1. The renderer writes here; present() blits to VGA.
; Size: 160 * 144 = 23040 bytes
GB_BACKBUF      equ 0x12000
GB_BACKBUF_SIZE equ 23040      ; 160 * 144

; ---------------------------------------------------------------------------
; I/O register shadow offsets (EBP + IO_* = emulated register byte)
; Named to match constants/hardware.inc for cross-reference.
; ---------------------------------------------------------------------------

; Joypad ($FF00) — read-only from game; written by our INT 9h handler
IO_JOYP         equ 0xFF00     ; rJOYP

; Serial ($FF01/$FF02) — isolated; network HAL not yet implemented
IO_SB           equ 0xFF01     ; rSB  — TODO-HW: network HAL (Phase 4)
IO_SC           equ 0xFF02     ; rSC  — TODO-HW: network HAL (Phase 4)

; Divider / Timer — not translated; PIT-based main loop handles timing
IO_DIV          equ 0xFF04     ; rDIV  — not emulated (read returns 0)
IO_TIMA         equ 0xFF05     ; rTIMA — TODO-HW: not emulated
IO_TMA          equ 0xFF06     ; rTMA  — TODO-HW: not emulated
IO_TAC          equ 0xFF07     ; rTAC  — TODO-HW: not emulated

; Audio ($FF10–$FF26) — not yet implemented
IO_APU_BASE     equ 0xFF10     ; rAUD1SWEEP — TODO-HW: audio HAL (Phase 3)

; LCD Control ($FF40) — read by software renderer
IO_LCDC         equ 0xFF40     ; rLCDC — TODO-HW: renderer reads this
IO_STAT         equ 0xFF41     ; rSTAT — TODO-HW: renderer writes mode bits
IO_SCY          equ 0xFF42     ; rSCY  — TODO-HW: renderer
IO_SCX          equ 0xFF43     ; rSCX  — TODO-HW: renderer
IO_LY           equ 0xFF44     ; rLY   — TODO-HW: renderer emulates scanline counter
IO_LYC          equ 0xFF45     ; rLYC  — TODO-HW: renderer
IO_DMA          equ 0xFF46     ; rDMA  — TODO-HW: OAM DMA (software emulated)
IO_BGP          equ 0xFF47     ; rBGP  — DMG palette mapping
IO_OBP0         equ 0xFF48     ; rOBP0 — DMG sprite palette 0
IO_OBP1         equ 0xFF49     ; rOBP1 — DMG sprite palette 1
IO_WY           equ 0xFF4A     ; rWY   — TODO-HW: renderer
IO_WX           equ 0xFF4B     ; rWX   — TODO-HW: renderer

; CGB registers — palette, VRAM bank, WRAM bank, HDMA
IO_VBK          equ 0xFF4F     ; rVBK  — VRAM bank select (CGB)
IO_BGPI         equ 0xFF68     ; rBGPI — BG palette index (CGB)
IO_BGPD         equ 0xFF69     ; rBGPD — BG palette data (CGB)
IO_OBPI         equ 0xFF6A     ; rOBPI — OBJ palette index (CGB)
IO_OBPD         equ 0xFF6B     ; rOBPD — OBJ palette data (CGB)
IO_WBK          equ 0xFF70     ; rWBK  — WRAM bank select (CGB)

; ---------------------------------------------------------------------------
; Derived geometry constants (for PPU and renderer use)
; ---------------------------------------------------------------------------

; Tile dimensions (from constants/hardware.inc)
TILE_WIDTH      equ 8
TILE_HEIGHT     equ 8
TILE_SIZE       equ 16         ; 2 bits/pixel × 8×8 = 16 bytes per tile

; Screen dimensions (from constants/hardware.inc SCREEN_* constants)
SCREEN_W        equ 160        ; pixels
SCREEN_H        equ 144        ; pixels
SCREEN_TILES_W  equ 20         ; tiles (160/8)
SCREEN_TILES_H  equ 18         ; tiles (144/8)

; Tilemap dimensions
TILEMAP_W       equ 32         ; tiles (256/8)
TILEMAP_H       equ 32         ; tiles (256/8)
TILEMAP_AREA    equ 1024       ; 32*32 bytes

; OAM entry layout (from constants/hardware.inc OAMA_* offsets)
OAM_Y_OFS       equ 16         ; subtract to get real screen Y
OAM_X_OFS      equ 8          ; subtract to get real screen X
OAM_ENTRY_SIZE  equ 4          ; bytes per sprite entry
OAM_COUNT       equ 40

; VGA output geometry (Mode 13h, 320x200)
VGA_W           equ 320
VGA_H           equ 200
VGA_FRAMEBUF    equ 0xA0000    ; linear address of VGA framebuffer (flat DS)

; 2x blit letterbox: (200 - 144*2) / 2 = (200 - 288) / 2 => negative, so clip
; With 2x scale: GB 160x144 -> 320x288, which is taller than 200.
; Crop: show rows 0..199 of the 288-row scaled image (clips bottom 88 rows = 44 GB rows).
; Alternatively, scale to fit width: 320/160 = 2x; crop height to 200/2 = 100 GB rows.
; Decision: render all 144 GB rows, blit 2x but only display top 200 pixels.
; The bottom 88 pixels (44 GB rows) are off-screen — this is acceptable for now.
; TODO: revisit with a 1.5x or letterbox strategy in Phase 5.
VGA_BLIT_SCALE  equ 2
VGA_BLIT_XOFS   equ 0          ; centered: (320 - 160*2) / 2 = 0
VGA_BLIT_YOFS   equ 0          ; no letterbox (see note above)

%endif ; GB_MEMMAP_INC
