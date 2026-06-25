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
W_NUM_BAG_ITEMS        equ 0xD31C
W_NUM_BOX_ITEMS        equ 0xD539
W_CURRENT_MENU_ITEM      equ 0xCC26
W_MAX_MENU_ITEM          equ 0xCC28
W_BAG_SAVED_MENU_ITEM    equ 0xCC2C
W_LIST_SCROLL_OFFSET     equ 0xCC36
W_CUR_ITEM               equ 0xCF90
W_WHICH_POKEMON          equ 0xCF91
W_ITEM_QUANTITY          equ 0xCF95
W_MAX_ITEM_QUANTITY      equ 0xCF96
W_LOADED_MON_SPECIES     equ 0xCF97
W_MON_DATA_LOCATION      equ 0xCC49
W_CUR_PARTY_SPECIES      equ 0xCF90
W_CUR_ENEMY_LEVEL        equ 0xD126
W_TEXT_BOX_ID          equ 0xD124
W_PARTY_MON1_MOVES       equ 0xD172
W_PARTY_MON4_MOVES       equ 0xD1F6
W_POKEDEX_OWNED          equ 0xD2F6
W_POKEDEX_SEEN           equ 0xD309
W_CUR_MAP              equ 0xD35D
W_Y_COORD              equ 0xD360
W_X_COORD              equ 0xD361
W_PLAYER_MONEY           equ 0xD346
W_OBTAINED_BADGES        equ 0xD355
W_OBTAINED_HIDDEN_ITEMS_FLAGS equ 0xD6EF
W_TOWN_VISITED_FLAG      equ 0xD70A
W_RIVAL_STARTER          equ 0xD714
W_EVENT_FLAGS            equ 0xD746
W_SURFING_MINIGAME_PIKACHU_HP  equ 0xC5D6
W_SURFING_MINIGAME_RADNESS_MTR equ 0xC5D9
W_SURFING_MINIGAME_RADNESS_SCR equ 0xC5DA
W_SURFING_MINIGAME_TOTAL_SCORE equ 0xC5DC
W_SURFING_MINIGAME_TRICK_FLAGS equ 0xC62F
W_SLOT_MACHINE_SEVEN_AND_BAR_MODE_CHANCE equ 0xCC5B
W_SLOT_MACHINE_WHEEL1_OFFSET equ 0xCD3E
W_SLOT_MACHINE_WHEEL2_OFFSET equ 0xCD3F
W_SLOT_MACHINE_WHEEL3_OFFSET equ 0xCD40
W_SLOT_MACHINE_WHEEL1_BOTTOM_TILE equ 0xCD41
W_SLOT_MACHINE_WHEEL1_MIDDLE_TILE equ 0xCD42
W_SLOT_MACHINE_WHEEL1_TOP_TILE equ 0xCD43
W_SLOT_MACHINE_WHEEL2_BOTTOM_TILE equ 0xCD44
W_SLOT_MACHINE_WHEEL2_MIDDLE_TILE equ 0xCD45
W_SLOT_MACHINE_WHEEL2_TOP_TILE equ 0xCD46
W_SLOT_MACHINE_WHEEL3_BOTTOM_TILE equ 0xCD47
W_SLOT_MACHINE_WHEEL3_MIDDLE_TILE equ 0xCD48
W_SLOT_MACHINE_WHEEL3_TOP_TILE equ 0xCD49
W_SLOT_MACHINE_FLAGS equ 0xCD4C
W_SLOT_MACHINE_WHEEL1_SLIP_COUNTER equ 0xCD4D
W_SLOT_MACHINE_WHEEL2_SLIP_COUNTER equ 0xCD4E
W_SLOT_MACHINE_ALLOW_MATCHES_COUNTER equ 0xD095
W_LOADED_MON_EXP         equ 0xCFA5
W_CUR_SPECIES            equ 0xD0B4
W_MON_H_GROWTH_RATE      equ 0xD0CB   ; corrected: wMonHeader($D0B8)+BASE_GROWTH_RATE($13). Was $D0CA (off-by-one → 4th move byte); only the unwired experience.asm draft consumed it.
W_REMOVE_MON_FROM_BOX  equ 0xCF94
W_MOVE_MON_TYPE          equ 0xCF94
W_PARTY_COUNT            equ 0xD162
W_PARTY_MONS             equ 0xD16A
W_PARTY_MON_OT           equ 0xD272
W_PARTY_MON_NICKS        equ 0xD2B4
W_PARTY_MON_NICKS_END    equ 0xD2F6
W_BOX_COUNT              equ 0xDA7F
W_BOX_MONS               equ 0xDA95
W_BOX_MON1_MOVES         equ 0xDA9D
W_BOX_MON_OT             equ 0xDD29
W_BOX_MON_NICKS          equ 0xDE05
W_BOX_MON_NICKS_END      equ 0xDEE1
W_SAVED_LIST_SCROLL_OFFSET equ 0xD07D
W_LIST_COUNT             equ 0xD129

; ---------------------------------------------------------------------------
; Pokémon data engine — lowercase pret-name aliases (Pokémon data/stats plan).
; CLAUDE.md mandates pret names; the engine drafts (add_mon/load_mon_data/
; calc_stats/…) reference these lowercase labels. Addresses derived from the
; verified anchors above (wCurSpecies $D0B4, wPartyCount $D162) + the struct
; layout in macros/ram.asm. wMonHeader region (no overlaps) added first; the
; loaded/enemy/box/daycare aliases land in Stage 5 once a pokeyellow.sym confirms
; their cross-section addresses.
; ---------------------------------------------------------------------------
wCurSpecies        equ 0xD0B4
wMonHeader         equ 0xD0B8
wMonHIndex         equ 0xD0B8
wMonHBaseStats     equ 0xD0B9
wMonHBaseHP        equ 0xD0B9
wMonHBaseAttack    equ 0xD0BA
wMonHBaseDefense   equ 0xD0BB
wMonHBaseSpeed     equ 0xD0BC
wMonHBaseSpecial   equ 0xD0BD
wMonHTypes         equ 0xD0BE
wMonHType1         equ 0xD0BE
wMonHType2         equ 0xD0BF
wMonHCatchRate     equ 0xD0C0
wMonHBaseEXP       equ 0xD0C1
wMonHSpriteDim     equ 0xD0C2
wMonHFrontSprite   equ 0xD0C3
wMonHBackSprite    equ 0xD0C5
wMonHMoves         equ 0xD0C7
wMonHGrowthRate    equ 0xD0CB
wMonHLearnset      equ 0xD0CC
wCurEnemyLevel     equ 0xD126   ; CalcStat level input
wCurPartySpecies   equ 0xCF90
wWhichPokemon      equ 0xCF91
wMonDataLocation   equ 0xCC49
wPartyCount        equ 0xD162
wPartySpecies      equ 0xD163   ; wPartyCount+1; 6 species + $FF sentinel
wPartyMons         equ 0xD16A
wPartyMonOT        equ 0xD272
wPartyMonNicks     equ 0xD2B4
wPlayerName        equ 0xD157   ; = W_PLAYER_NAME (OT name source)

; Sprite state data — 16 slots × $10 bytes each, two parallel arrays.
; wSpriteStateData1 ($C100) and wSpriteStateData2 ($C200) — sym-verified.
; The high byte of a pointer in one array +1 reaches the other (the engine
; relies on this; in the flat model we use the explicit base constants).
W_SPRITE_STATE_DATA_1         equ 0xC100 ; wSpriteStateData1 (slot 0 = player)
W_SPRITE_STATE_DATA_2         equ 0xC200 ; wSpriteStateData2
SPRITESTATEDATA_STRUCT_SIZE   equ 0x10
NUM_SPRITE_SLOTS              equ 16

; Player slot (slot 0) field aliases — data1 ($C10x).
; Step vectors are signed bytes (+1/-1/0) read each frame by AdvancePlayerSprite.
W_SPRITE_PLAYER_PICTURE_ID    equ 0xC100 ; wSpritePlayerStateData1PictureID (0 = slot unused)
W_SPRITE_PLAYER_IMAGE_INDEX   equ 0xC102 ; wSpritePlayerStateData1ImageIndex (facing+anim, $ff=hidden)
W_SPRITE_PLAYER_Y_STEP_VECTOR equ 0xC103 ; wSpritePlayerStateData1YStepVector
W_SPRITE_PLAYER_Y_PIXELS      equ 0xC104 ; wSpritePlayerStateData1YPixels (fixed screen Y, $3c)
W_SPRITE_PLAYER_X_STEP_VECTOR equ 0xC105 ; wSpritePlayerStateData1XStepVector
W_SPRITE_PLAYER_X_PIXELS      equ 0xC106 ; wSpritePlayerStateData1XPixels (fixed screen X, $40)
W_SPRITE_PLAYER_INTRA_ANIM    equ 0xC107 ; wSpritePlayerStateData1IntraAnimFrameCounter
W_SPRITE_PLAYER_ANIM_FRAME    equ 0xC108 ; wSpritePlayerStateData1AnimFrameCounter
W_SPRITE_PLAYER_FACING_DIR    equ 0xC109 ; wSpritePlayerStateData1FacingDirection (SPRITE_FACING_*)
; Player slot fields — data2 ($C20x).
W_SPRITE_PLAYER_WALK_ANIM_COUNTER equ 0xC200 ; wSpritePlayerStateData2WalkAnimationCounter
W_SPRITE_PLAYER_GRASS_PRIORITY    equ 0xC207 ; wSpritePlayerStateData2GrassPriority ($80 = under grass)
W_SPRITE_PLAYER_IMAGE_BASE_OFFSET equ 0xC20E ; wSpritePlayerStateData2ImageBaseOffset (player = 1)

; Sprite-engine struct field offsets (within a $10-byte slot).
SPRITESTATEDATA1_PICTUREID            equ 0x0
SPRITESTATEDATA1_MOVEMENTSTATUS       equ 0x1   ; 0=uninit, 1=ready, 2=delayed, 3=walking
SPRITESTATEDATA1_IMAGEINDEX           equ 0x2
SPRITESTATEDATA1_YPIXELS              equ 0x4
SPRITESTATEDATA1_XPIXELS              equ 0x6
SPRITESTATEDATA1_INTRAANIMFRAMECOUNTER equ 0x7
SPRITESTATEDATA1_ANIMFRAMECOUNTER     equ 0x8
SPRITESTATEDATA1_FACINGDIRECTION      equ 0x9
SPRITESTATEDATA1_YSTEPVECTOR          equ 0x3   ; step vector for Y (-1/0/+1 → 0xFF/0x00/0x01)
SPRITESTATEDATA1_XSTEPVECTOR          equ 0x5   ; step vector for X
SPRITESTATEDATA1_YADJUSTED            equ 0xA   ; adjusted Y for collision ((YPIXELS+4+B)&0xF0|C)
SPRITESTATEDATA1_XADJUSTED            equ 0xB   ; adjusted X for collision ((XPIXELS+B)&0xF0|C)
SPRITESTATEDATA1_COLLISIONDATA        equ 0xC   ; collision direction bits (accumulated)
SPRITESTATEDATA1_COLLISIONBITMAP_HI   equ 0xE   ; collision bitmap high byte (slots 8-15)
SPRITESTATEDATA1_COLLISIONBITMAP_LO   equ 0xF   ; collision bitmap low byte (slots 0-7)
SPRITESTATEDATA2_YDISPLACEMENT        equ 0x2   ; Y displacement (init 8)
SPRITESTATEDATA2_XDISPLACEMENT        equ 0x3   ; X displacement (init 8)
SPRITESTATEDATA2_MAPY                 equ 0x4   ; map Y position (metatile units, origin+4)
SPRITESTATEDATA2_MAPX                 equ 0x5   ; map X position (metatile units, origin+4)
SPRITESTATEDATA2_WALKANIMCOUNTER      equ 0x0   ; 8-frame countdown while walking (0=standing)
SPRITESTATEDATA2_MOVEMENTBYTE2        equ 0x1   ; dir constraint from map object (pret unnamed 0x01)
SPRITESTATEDATA2_MOVEMENTDELAY        equ 0x8   ; frames until next random walk attempt (pret 0x08)
SPRITESTATEDATA2_MOVEMENTBYTE1        equ 0x6   ; $ff=STAY, $fe=WALK(random), <$fe=scripted
SPRITESTATEDATA2_GRASSPRIORITY        equ 0x7   ; $80=under grass (set by CheckSpriteAvailability)
SPRITESTATEDATA2_ISTRAINER            equ 0x9   ; 1 if trainer NPC, 0 otherwise (pret: ORIGFACINGDIR)
SPRITESTATEDATA2_TEXTID               equ 0xA   ; text_id stored by InitMapSprites (text_byte & 0x3F)
SPRITESTATEDATA2_IMAGEBASEOFFSET      equ 0xE

BIT_FACE_PLAYER                       equ 7     ; bit 7 of SPRITESTATEDATA1_MOVEMENTSTATUS

NPC_DIALOG_BUF                        equ 0xCB00  ; scratch WRAM for NPC TX command stream (≤256 B)

; NPC movement-byte sentinel values (constants/map_object_constants.asm)
WALK                                   equ 0xFE  ; random movement
STAY                                   equ 0xFF  ; stationary

; NPC direction constraint values (movement byte 2 / pret wMapSpriteData byte 0)
; constants/map_object_constants.asm: ANY_DIR=0x00, UP_DOWN=0x01, LEFT_RIGHT=0x02
; Forced single-direction: DOWN=0xD0, UP=0xD1, LEFT=0xD2, RIGHT=0xD3, NONE=0xFF
NPC_DIR_ANY     equ 0x00   ; any random direction (pret: ANY_DIR)
NPC_DIR_UPDOWN  equ 0x01   ; constrained to up/down only (pret: UP_DOWN)
NPC_DIR_LR      equ 0x02   ; constrained to left/right only (pret: LEFT_RIGHT)
NPC_DIR_DOWN    equ 0xD0   ; forced down (pret: DOWN)
NPC_DIR_UP      equ 0xD1   ; forced up
NPC_DIR_LEFT    equ 0xD2   ; forced left
NPC_DIR_RIGHT   equ 0xD3   ; forced right
NPC_DIR_NONE    equ 0xFF   ; STAY NPC (no movement constraint)
UP_DOWN         equ NPC_DIR_UPDOWN
LEFT_RIGHT      equ NPC_DIR_LR

; NPC random movement direction thresholds (high 2 bits of hRandomAdd)
; constants/sprite_data_constants.asm
NPC_MOVEMENT_DOWN    equ 0x00   ; hRandomAdd in [0x00,0x3F] → go down
NPC_MOVEMENT_UP      equ 0x40   ; hRandomAdd in [0x40,0x7F] → go up
NPC_MOVEMENT_LEFT    equ 0x80   ; hRandomAdd in [0x80,0xBF] → go left
NPC_MOVEMENT_RIGHT   equ 0xC0   ; hRandomAdd in [0xC0,0xFF] → go right

; Named WRAM symbols (subset needed by translated routines).
; Offsets from pokeyellow.sym (bank 00).
W_SHADOW_OAM        equ 0xC300     ; wShadowOAM — 40 sprites × 4 bytes
W_SHADOW_OAM_END    equ 0xC3A0
W_SHADOW_OAM_SIZE   equ 0xA0       ; 160 bytes
W_TILEMAP           equ 0xC3A0     ; wTileMap — 40×25 screen tile buffer
W_TILEMAP_SIZE      equ 1000       ; SCREEN_TILES_W * SCREEN_TILES_H

; WRAM bank 1 — $D000–$DFFF (4 KB)
; On CGB: banks 1–7 are switchable via rWBK ($FF70).
; For now, bank 1 is the only one allocated here. CGB banking TBD.
GB_WRAM1        equ 0xD000

; Echo RAM region — $E000–$FDFF
; The pret source never addresses this range, so we use it for expanded
; DOS-port-only buffers (wSurroundingTiles, wOverworldMap, redraw scratch,
; wTileMapBackup2) that grew beyond their original WRAM0/1 slots.
; All addresses are within the DPMI allocation (EBP + 0xE000 is valid).
GB_ECHO             equ 0xE000

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
; All offsets verified from pokeyellow.sym (bank 00).
H_DOWN_ARROW_COUNT1      equ 0xFF86     ; hDownArrowBlinkCount1 — frame countdown (ON→OFF phase)
H_DOWN_ARROW_COUNT2      equ 0xFF87     ; hDownArrowBlinkCount2 — compat; 1 in 60 Hz blink mode
H_SOFT_RESET             equ 0xFF8A     ; hSoftReset
; 0xFF8B is a UNION of hMapStride / hNorthSouthConnectionStripWidth / hPreviousTileset
H_MAP_STRIDE             equ 0xFF8B     ; hMapStride (= map block row stride = width + 2*MAP_BORDER)
H_PREVIOUS_TILESET       equ 0xFF8B     ; hPreviousTileset (HRAM union with hMapStride)
; 0xFF8C is a UNION of hMapWidth / hNorthSouthConnectedMapWidth
H_MAP_WIDTH              equ 0xFF8C     ; hMapWidth (= wCurMapWidth, stored for row-copy inner loop)
H_SERIAL_CONN_STATUS     equ 0xFFAA     ; hSerialConnectionStatus
H_SCX                    equ 0xFFAE     ; hSCX — shadow of rSCX
H_SCY                    equ 0xFFAF     ; hSCY — shadow of rSCY
H_WY                     equ 0xFFB0     ; hWY  — shadow of rWY
H_LOADED_ROM_BANK        equ 0xFFB8     ; hLoadedROMBank
H_AUTO_BG_TRANSFER_EN    equ 0xFFBA     ; hAutoBGTransferEnabled
H_AUTO_BG_TRANSFER_DEST  equ 0xFFBC     ; hAutoBGTransferDest (2 bytes, lo/hi)
H_REDRAW_MAP_VIEW_ROW_OFFSET equ 0xFFBE ; hRedrawMapViewRowOffset
H_FRAME_COUNTER          equ 0xFFD5     ; hFrameCounter
H_VBLANK_OCCURRED        equ 0xFFD6     ; hVBlankOccurred
H_TILE_ANIMATIONS        equ 0xFFD7     ; hTileAnimations
H_REDRAW_ROW_COL_MODE    equ 0xFFD0     ; hRedrawRowOrColumnMode
H_REDRAW_ROW_COL_DEST    equ 0xFFD1     ; hRedrawRowOrColumnDest
H_UI_LAYOUT_FLAGS        equ 0xFFFA     ; hUILayoutFlags

BIT_SINGLE_SPACED_LINES  equ 2          ; hUILayoutFlags bit (gfx_constants.asm)

; Joypad HRAM ($FFB1-$FFB7) — order confirmed by hram.asm + H_SCX=$FFAE anchor
H_JOY_PRESSED            equ 0xFFB3     ; hJoyPressed — buttons just pressed this frame
H_JOY_HELD               equ 0xFFB4     ; hJoyHeld    — buttons currently held

; Sprite-engine HRAM temporaries (PrepareOAMData / _UpdateSprites) — sym-verified.
H_SPRITE_OFFSET2             equ 0xFF8F ; hSpriteOffset2 (current slot offset in PrepareOAMData loop)
H_OAM_BUFFER_OFFSET          equ 0xFF90 ; hOAMBufferOffset (write cursor into wShadowOAM)
H_SPRITE_SCREEN_X            equ 0xFF91 ; hSpriteScreenX
H_SPRITE_SCREEN_Y            equ 0xFF92 ; hSpriteScreenY
H_TILE_PLAYER_STANDING_ON    equ 0xFF93 ; hTilePlayerStandingOn
H_SPRITE_PRIORITY            equ 0xFF94 ; hSpritePriority (BG-priority bit for current sprite)
H_PRODUCT                equ 0xFF95 ; hProduct (4 bytes)
H_ITEM_PRICE           equ 0xFF8B
H_MONEY                equ 0xFF9F
H_EXPERIENCE             equ 0xFF96 ; (3 bytes, overlaps hProduct+1)
H_MULTIPLICAND           equ 0xFF96 ; hMultiplicand (3 bytes, overlaps hProduct+1)
H_MULTIPLIER             equ 0xFF99 ; hMultiplier (1 byte)
H_DIVIDEND               equ 0xFF95 ; hDividend (4 bytes, overlaps hProduct)
H_DIVISOR                equ 0xFF99 ; hDivisor (1 byte, overlaps hMultiplier)
H_QUOTIENT               equ 0xFF95 ; hQuotient (4 bytes, overlaps hProduct)
H_REMAINDER              equ 0xFF99 ; hRemainder (1 byte, overlaps hMultiplier)
H_DIVIDE_BUFFER          equ 0xFF9A
H_MONEY                  equ 0xFF9F
H_DIVIDE_BCD_DIVISOR     equ 0xFFA2
H_DIVIDE_BCD_QUOTIENT    equ 0xFFA2
H_DIVIDE_BCD_BUFFER      equ 0xFFA5
H_RANDOM_ADD             equ 0xFFD3
H_RANDOM_SUB             equ 0xFFD4
H_CURRENT_SPRITE_OFFSET      equ 0xFFDA ; hCurrentSpriteOffset (_UpdateSprites loop index)
H_PIKACHU_SPRITE_VRAM_OFFSET equ 0xFFFC ; hPikachuSpriteVRAMOffset (added to tile id $80+; 0 for now)

; Named WRAM symbols — all addresses verified from pokeyellow.sym.

; Audio/sound (low WRAM0 — $C0EE+)
W_NEW_SOUND_ID               equ 0xC0EE ; wNewSoundID
W_AUDIO_ROM_BANK             equ 0xC0EF ; wAudioROMBank
W_AUDIO_SAVED_ROM_BANK       equ 0xC0F0 ; wAudioSavedROMBank

; Misc WRAM ($CC–$CFC range)
W_UNUSED_FLAG                equ 0xCC5B ; wUnusedFlag

; Title-screen state ($CD3D)
W_TITLE_SCREEN_SCENE         equ 0xCD3D ; wTitleScreenScene (byte; +1 = timer)
W_TITLE_SCREEN_TIMER         equ 0xCD3E ; wTitleScreenTimer

; Name buffers (WRAM1) — sym-verified
W_PLAYER_NAME                equ 0xD157 ; wPlayerName — 11 bytes, '@'-terminated
W_RIVAL_NAME                 equ 0xD349 ; wRivalName  — 11 bytes, '@'-terminated

; Tile-map save/restore buffers — relocated to echo RAM ($E000+) to avoid
; overlapping pret WRAM1 symbols.  All via constants; no hardcoded addresses
; in translated code.
; Layout in echo RAM ($E000–$F167, all within the DPMI allocation):
;   $E000  wSurroundingTiles / wTileMapBackup   1728 B ($6C0) → $E6BF
;   $E800  wOverworldMap                        2048 B ($800) → $EFFF
;   $F000  wTileMapBackup2                      1000 B ($3E8) → $F3E7
W_TILEMAP_BACKUP             equ 0xE000 ; wTileMapBackup (= wSurroundingTiles, see below)
W_TILEMAP_BACKUP2            equ 0xF000 ; wTileMapBackup2 (1000 B)

; Overworld surrounding-tiles buffer (alias for wTileMapBackup)
; 48×36 = 1728 bytes; DrawTileBlock writes here before crop to wTileMap.
W_SURROUNDING_TILES          equ 0xE000 ; wSurroundingTiles = wTileMapBackup

; Overworld map block buffer (2048 bytes)
W_OVERWORLD_MAP              equ 0xE800 ; wOverworldMap
W_OVERWORLD_MAP_SIZE         equ 0x800  ; wOverworldMapEnd − wOverworldMap (2048 bytes)

; Turn-delay state (pret: wCheckFor180DegreeTurn / wPlayerLastStopDirection)
; W_CHECK_FOR_TURN=1 means "first direction press changes facing only; walk starts on hold".
; Reset to 0 on the first press (so subsequent frames in same direction walk).
; Restored to 1 when no direction is held (.noDirection path).
W_CHECK_FOR_TURN             equ 0xCADD ; wCheckFor180DegreeTurn (1=check next press)
W_PLAYER_LAST_STOP_DIRECTION equ 0xCFAE ; wPlayerLastStopDirection (dir held when player last stopped)

; Walk/sprite state
W_FONT_LOADED                equ 0xCFC3 ; wFontLoaded (bit BIT_FONT_LOADED set while text font is in VRAM)
W_WALK_COUNTER               equ 0xCFC4 ; wWalkCounter
W_TILE_IN_FRONT_OF_PLAYER    equ 0xCFC5 ; wTileInFrontOfPlayer (collision check result)
W_AUDIO_FADE_OUT             equ 0xCFC6 ; wAudioFadeOutControl
W_UPDATE_SPRITES_ENABLED     equ 0xCFCA ; wUpdateSpritesEnabled

; Sprite-engine scratch WRAM — sym-verified.
W_GRASS_TILE                 equ 0xD534 ; wGrassTile (tile ID treated as tall grass; $ff = none)
W_SAVED_SPRITE_IMAGE_INDEX   equ 0xD5CC ; wSavedSpriteImageIndex (PrepareOAMData scratch / VRAM base tile)
W_MOVEMENT_FLAGS             equ 0xD735 ; wMovementFlags
; Bit indices for W_MOVEMENT_FLAGS (pret: constants/ram_constants.asm)
BIT_STANDING_ON_DOOR         equ 0     ; set by warp arrival; triggers auto-walk-off
BIT_EXITING_DOOR             equ 1     ; set by PlayerStepOutFromDoor (door tile); player is auto-walking off door
BIT_STANDING_ON_WARP         equ 2     ; edge-detect: 1 = player was on a warp tile last step
; bits 3–5 unused in Yellow
BIT_LEDGE_OR_FISHING         equ 6
BIT_SPINNING                 equ 7

; Bit indices for W_STATUS_FLAGS_5 (pret: constants/ram_constants.asm)
BIT_DISABLE_JOYPAD           equ 5     ; input suppressed; CountDownIgnoreInputBitReset clears it
BIT_SCRIPTED_MOVEMENT_STATE  equ 7     ; simulated joypad active (door exit / scripted walk)

; Map-tileset copies
W_UNUSED_CUR_MAP_TILESET_COPY equ 0xD118 ; wUnusedCurMapTilesetCopy
W_WALK_BIKE_SURF_STATE_COPY  equ 0xD119 ; wWalkBikeSurfStateCopy

; Joypad/input control
W_JOY_IGNORE                 equ 0xCCB7 ; wJoyIgnore — button mask; bits set suppress those inputs
W_SIMULATED_JOYPAD_STATES_END equ 0xCC5B ; wSimulatedJoypadStatesEnd — PAD_* byte queued by scripts
W_SIMULATED_JOYPAD_STATES_INDEX equ 0xCC84 ; wSimulatedJoypadStatesIndex — steps remaining (0=done)
W_IGNORE_INPUT_COUNTER       equ 0xD139 ; wIgnoreInputCounter — counts down 30→0; clears BIT_DISABLE_JOYPAD

; Current-map script flags
W_CURRENT_MAP_SCRIPT_FLAGS   equ 0xD125 ; wCurrentMapScriptFlags

; Letter-printing delay and text speed options (text engine)
; Pret ref: constants/ram_constants.asm, engine/menus/main_menu.asm:InitOptions
W_OPTIONS                    equ 0xD354 ; wOptions — bits 3-0 = text speed
W_LETTER_PRINTING_DELAY      equ 0xD357 ; wLetterPrintingDelayFlags

; wLetterPrintingDelayFlags bit indices
BIT_FAST_TEXT_DELAY          equ 0      ; 1=read speed from wOptions; 0=always 1 frame/char
BIT_TEXT_DELAY               equ 1      ; 1=delay enabled; TextCommandProcessor sets this per session

; wStatusFlags5 bit for text delay suppression
BIT_NO_TEXT_DELAY            equ 6      ; 1=skip all per-char delay (cutscenes, auto-scroll)

; wOptions text speed values (pret ref: constants/ram_constants.asm TEXT_DELAY_*)
TEXT_DELAY_FAST              equ 1      ; 1 frame per character
TEXT_DELAY_MEDIUM            equ 3      ; 3 frames per character (default)
TEXT_DELAY_SLOW              equ 5      ; 5 frames per character
TEXT_DELAY_MASK              equ 0x0F   ; bits 3-0 of wOptions hold text speed

; Current map identity
W_CUR_MAP                    equ 0xD35D ; wCurMap (1 byte)
W_CURRENT_TILE_BLOCK_MAP_VIEW_PTR equ 0xD35E ; wCurrentTileBlockMapViewPointer (2 bytes)
W_Y_COORD                    equ 0xD360 ; wYCoord (player map Y, in tiles)
W_X_COORD                    equ 0xD361 ; wXCoord (player map X, in tiles)
W_Y_BLOCK_COORD              equ 0xD362 ; wYBlockCoord
W_X_BLOCK_COORD              equ 0xD363 ; wXBlockCoord
W_D433                       equ 0xD433 ; wd433 — Pikachu collision direction (set by sprite collision engine)
W_LAST_MAP                   equ 0xD364 ; wLastMap

; Fixed map header (wCurMapHeader = wCurMapTileset at $D366)
; This is a contiguous 10-byte region that LoadMapHeader copies into from the ROM header.
; Layout: tileset(1) + height(1) + width(1) + dataptr(2) + textptr(2) + scriptptr(2) + connections(1)
W_CUR_MAP_HEADER             equ 0xD366 ; wCurMapHeader (start of fixed header copy target)
W_CUR_MAP_TILESET            equ 0xD366 ; wCurMapTileset (= wCurMapHeader first byte)
W_CUR_MAP_HEIGHT             equ 0xD367 ; wCurMapHeight
W_CUR_MAP_WIDTH              equ 0xD368 ; wCurMapWidth
W_CUR_MAP_DATA_PTR           equ 0xD369 ; wCurMapDataPtr (2 bytes, LE)
W_CUR_MAP_TEXT_PTR           equ 0xD36B ; wCurMapTextPtr (2 bytes, LE)
W_CUR_MAP_SCRIPT_PTR         equ 0xD36D ; wCurMapScriptPtr (2 bytes, LE)
W_CUR_MAP_CONNECTIONS        equ 0xD36F ; wCurMapConnections (NORTH|SOUTH|WEST|EAST bits)
W_CUR_MAP_HEADER_END         equ 0xD370 ; wCurMapHeaderEnd (byte after connections)
W_CUR_MAP_HEADER_SIZE        equ W_CUR_MAP_HEADER_END - W_CUR_MAP_HEADER  ; = 10 bytes

; Connection-strip headers (each 11 bytes: map, strip-src, strip-dst, length, map-width, Y-align, X-align, view-ptr)
W_NORTH_CONNECTED_MAP        equ 0xD370 ; wNorthConnectedMap ($FF = none)
W_SOUTH_CONNECTED_MAP        equ 0xD37B ; wSouthConnectedMap
W_WEST_CONNECTED_MAP         equ 0xD386 ; wWestConnectedMap
W_EAST_CONNECTED_MAP         equ 0xD391 ; wEastConnectedMap

; Sprite/object data
W_SPRITE_SET_ID              equ 0xD3A7 ; wSpriteSetID
W_OBJECT_DATA_PTR_TEMP       equ 0xD3A8 ; wObjectDataPointerTemp (2 bytes)

; Map object header (follows connections in object data)
W_MAP_BACKGROUND_TILE        equ 0xD3AC ; wMapBackgroundTile (border block ID for wOverworldMap)
W_NUMBER_OF_WARPS            equ 0xD3AD ; wNumberOfWarps
W_WARP_ENTRIES               equ 0xD3AE ; wWarpEntries (MAX_WARP_EVENTS * 4 bytes max)
W_DESTINATION_WARP_ID        equ 0xD42E ; wDestinationWarpID ($FF = don't update coords)

; Sign/BG event data
W_NUM_SIGNS                  equ 0xD4AF ; wNumSigns
W_SIGN_COORDS                equ 0xD4B0 ; wSignCoords (MAX_BG_EVENTS * 2 bytes: Y, X pairs)
W_SIGN_TEXT_IDS              equ 0xD4D0 ; wSignTextIDs (MAX_BG_EVENTS bytes)

MAX_WARP_EVENTS              equ 32
MAX_BG_EVENTS                equ 16
MAX_OBJECT_EVENTS            equ 16

; Special-warp step offsets (incremented as the block-map pointer crosses
; block boundaries; faithful bookkeeping, not yet consumed by warp logic).
W_Y_OFFSET_SINCE_LAST_SPECIAL_WARP equ 0xD4E1 ; wYOffsetSinceLastSpecialWarp
W_X_OFFSET_SINCE_LAST_SPECIAL_WARP equ 0xD4E2 ; wXOffsetSinceLastSpecialWarp

; Edge detection thresholds (height*2 / width*2) — used by CheckMapConnections
W_CURRENT_MAP_HEIGHT_2       equ 0xD523 ; wCurrentMapHeight2 = wCurMapHeight * 2
W_CURRENT_MAP_WIDTH_2        equ 0xD524 ; wCurrentMapWidth2 = wCurMapWidth * 2

; Map-view VRAM pointer and player facing
W_MAP_VIEW_VRAM_POINTER      equ 0xD525 ; wMapViewVRAMPointer (Stage A Note: dropped/unused after native renderer)
W_PLAYER_MOVING_DIRECTION    equ 0xD527 ; wPlayerMovingDirection (PLAYER_DIR_*)
W_PLAYER_DIRECTION           equ 0xD529 ; wPlayerDirection (PLAYER_DIR_*)

; Active tileset WRAM (set from tileset header by LoadTilesetHeader)
; LoadTilesetHeader copies 11 bytes here from the tileset header table,
; then reads the 12th byte (animations) to hTileAnimations.
W_TILESET_BANK               equ 0xD52A ; wTilesetBank (1 byte)
W_TILESET_BLOCKS_PTR         equ 0xD52B ; wTilesetBlocksPtr (2 bytes, LE)
W_TILESET_GFX_PTR            equ 0xD52D ; wTilesetGfxPtr   (2 bytes, LE)
W_TILESET_COLLISION_PTR      equ 0xD52F ; wTilesetCollisionPtr (2 bytes, LE; passable-tile list)
W_TILESET_TALKING_OVER_TILES equ 0xD531 ; wTilesetTalkingOverTiles (3 bytes: counter tiles)
W_TILESET_GRASS_TILE         equ 0xD534 ; (overlaps wGrassTile — handled by LoadTilesetHeader)
; NOTE: wTilesetGrassTile ($D534) is the same address as wGrassTile.
; LoadTilesetHeader copies it as part of the 11-byte block.
W_TILESET_HEADER_COPY_SIZE   equ 11     ; bytes copied from tileset header to wTilesetBank
W_TILESET_HEADER_FULL_SIZE   equ 12     ; full tileset header entry size (11 + animations)

; Walk/bike/surf state
W_WALK_BIKE_SURF_STATE       equ 0xD6FF ; wWalkBikeSurfState

; Status flags (game-state bitfields)
W_STATUS_FLAGS_1             equ 0xD727 ; wStatusFlags1
W_STATUS_FLAGS_2             equ 0xD72B ; wStatusFlags2
W_STATUS_FLAGS_3             equ 0xD72C ; wStatusFlags3
W_STATUS_FLAGS_4             equ 0xD72D ; wStatusFlags4
W_STATUS_FLAGS_5             equ 0xD72F ; wStatusFlags5
W_STATUS_FLAGS_6             equ 0xD731 ; wStatusFlags6
W_STATUS_FLAGS_7             equ 0xD732 ; wStatusFlags7
W_ELITE4_FLAGS               equ 0xD733 ; wElite4Flags

; Screen-area size constant (used by save/restore functions).
SCREEN_AREA              equ SCREEN_TILES_W * SCREEN_TILES_H  ; 40 * 25 = 1000

; pret-compatible name aliases (hardware.inc uses SCREEN_WIDTH/HEIGHT, TILEMAP_WIDTH)
SCREEN_WIDTH             equ SCREEN_TILES_W                   ; 40
SCREEN_HEIGHT            equ SCREEN_TILES_H                   ; 25
TILEMAP_WIDTH            equ TILEMAP_W                        ; 32

; Overworld map geometry (constants/gfx_constants.asm + map_data_constants.asm)
BLOCK_WIDTH              equ 4           ; tiles per map block, X
BLOCK_HEIGHT             equ 4           ; tiles per map block, Y
SCREEN_BLOCK_WIDTH       equ 12          ; blocks visible per screen row
SCREEN_BLOCK_HEIGHT      equ 9           ; blocks visible per screen column
SURROUNDING_WIDTH        equ SCREEN_BLOCK_WIDTH  * BLOCK_WIDTH   ; 48 tiles wide
SURROUNDING_HEIGHT       equ SCREEN_BLOCK_HEIGHT * BLOCK_HEIGHT  ; 36 tiles tall
MAP_BORDER               equ 6           ; block-unit border around map in wOverworldMap

; Player movement direction bits (constants/sprite_data_constants.asm wPlayerDirection)
PLAYER_DIR_RIGHT         equ 1
PLAYER_DIR_LEFT          equ 2
PLAYER_DIR_DOWN          equ 4
PLAYER_DIR_UP            equ 8

; Sprite facing direction values (constants/sprite_data_constants.asm SPRITE_FACING_*)
SPRITE_FACING_DOWN       equ 0x00
SPRITE_FACING_UP         equ 0x04
SPRITE_FACING_LEFT       equ 0x08
SPRITE_FACING_RIGHT      equ 0x0C

; Dialog ▼ advance arrow (home/window.asm:HandleDownArrowBlinkTiming)
CHAR_DOWN_ARROW          equ 0xEE       ; '▼' charmap code (constants/charmap.asm)
ARROW_ON_FRAMES          equ 30         ; frames ▼ stays visible  (0.5 s at 60 Hz)
ARROW_OFF_FRAMES         equ 8          ; frames ▼ stays hidden   (0.13 s at 60 Hz)
DIALOG_ARROW_TILEMAP_OFFSET equ 4 * 32 + 18  ; GB_TILEMAP1 row 4, col 18 = offset 146

; hJoyHeld bit positions (constants/hardware.inc B_PAD_*; active-high in hJoyHeld)
PAD_A                    equ 1 << 0      ; B_BTN_A    = 0 (button byte low nibble)
PAD_B                    equ 1 << 1      ; B_BTN_B    = 1
PAD_SELECT               equ 1 << 2      ; B_BTN_SELECT = 2
PAD_START                equ 1 << 3      ; B_BTN_START  = 3
PAD_RIGHT                equ 1 << 4      ; B_PAD_RIGHT = 4
PAD_LEFT                 equ 1 << 5      ; B_PAD_LEFT  = 5
PAD_UP                   equ 1 << 6      ; B_PAD_UP    = 6
PAD_DOWN                 equ 1 << 7      ; B_PAD_DOWN  = 7

; Map object NPC flags (constants/map_object_constants.asm)
TRAINER_FLAG             equ 0x40        ; 1 << BIT_TRAINER
ITEM_FLAG                equ 0x80        ; 1 << BIT_ITEM

; RedrawRowOrColumn modes (constants/gfx_constants.asm)
REDRAW_COL               equ 1
REDRAW_ROW               equ 2

; LCDC bits the OBJ renderer reads (constants/hardware.inc)
LCDCF_OBJ_ON             equ 1 << 1      ; B_LCDC_OBJS  = 1 (sprites enabled)
LCDCF_OBJ_SIZE           equ 1 << 2      ; B_LCDC_OBJ_SIZE = 2 (0 = 8×8, 1 = 8×16)

; OAM attribute byte bits (constants/hardware.inc)
OAM_PRIO                 equ 1 << 7      ; OBJ drawn below BG colors 1-3
OAM_YFLIP                equ 1 << 6
OAM_XFLIP                equ 1 << 5
OAM_PAL1                 equ 1 << 4      ; DMG: 0 = OBP0, 1 = OBP1
B_OAM_PAL1               equ 4           ; bit position of the OBP select bit

; SpriteFacingAndAnimationTable attribute markers (constants/oam_constants.asm).
; These are engine-internal bits in the facing tables, NOT hardware OAM bits.
BIT_SPRITE_UNDER_GRASS   equ 1           ; tile drawn with BG priority when in grass
UNDER_GRASS              equ 1 << BIT_SPRITE_UNDER_GRASS  ; $02
FACING_END               equ 1 << 0      ; $01 — last OAM entry of a facing block
; CGB: OAM palette numbers %100-%111 select OBP1 (constants/oam_constants.asm).
OAM_HIGH_PALS            equ 1 << 2      ; $04

; Player/sprite logic constants.
MAP_TILESET_SIZE         equ 0x60        ; tile IDs >= $60 are text-box tiles, not map tiles
BIT_FONT_LOADED          equ 0           ; wFontLoaded bit 0
BIT_SPINNING             equ 7           ; wMovementFlags (constants/ram_constants.asm)
BIT_LEDGE_OR_FISHING     equ 6           ; wMovementFlags (constants/ram_constants.asm)
PLAYER_DIR_BIT_RIGHT     equ 0
PLAYER_DIR_BIT_LEFT      equ 1
PLAYER_DIR_BIT_DOWN      equ 2
PLAYER_DIR_BIT_UP        equ 3

; ROM-window area for embedded overworld assets.
; The unused ROM bank-switch window ($4000–$7FFF) is repurposed to hold asset data
; that faithful routines (LoadTilesetTilePatternData, DrawTileBlock, LoadTileBlockMap,
; LoadMapHeader, LoadTilesetHeader) read via pointers stored in WRAM.
OW_GFX_GBADDR            equ 0x4000     ; overworld tileset 2bpp → vTileset ($9000)
OW_BLOCKS_GBADDR         equ 0x4600     ; overworld blockset (.bst, 128 blocks × 16 tile-IDs)
OW_PALLET_BLK_GBADDR     equ 0x4E00     ; PalletTown.blk (10×9 = 90 block IDs)
OW_MAP_GBADDR            equ OW_PALLET_BLK_GBADDR ; legacy alias (Phase 2 scaffold)
OW_COLL_GBADDR           equ 0x4F00     ; Overworld_Coll passable-tile list ($FF-terminated)
; Map block data for each map. Connection strip src pointers index into these.
OW_ROUTE1_BLK_GBADDR     equ 0x5000     ; Route1.blk  (10×18 = 180 block IDs)
OW_ROUTE21_BLK_GBADDR    equ 0x5200     ; Route21.blk (10×45 = 450 block IDs)
; Map headers, tileset header, and object data — generated by gen_map_headers.py.
; Loaded to ROM window at boot; LoadMapHeader reads from [EBP + these addresses].
OW_TILESET_HDR_GBADDR    equ 0x5400     ; OVERWORLD tileset header (12 bytes)
OW_MAP_HEADERS_GBADDR    equ 0x540C     ; base for map header + object data blobs
; Per-map header addresses are defined in assets/map_headers.inc as
; OW_MAP_HDR_PALLET_TOWN, OW_MAP_HDR_ROUTE_1, etc.
; Additional map block data — packed into unused ROM bank-0 area (0x1000-0x3FFF).
; Generated by tools/gen_overworld_assets.py; addresses match LoadOverworldAssets copies.
OW_VIRIDIAN_CITY_BLK_GBADDR   equ 0x1000  ; ViridianCity.blk  (20×18 = 360 bytes)
OW_PEWTER_CITY_BLK_GBADDR     equ 0x1168  ; PewterCity.blk    (20×18 = 360 bytes)
OW_CERULEAN_CITY_BLK_GBADDR   equ 0x12D0  ; CeruleanCity.blk  (20×18 = 360 bytes)
OW_LAVENDER_TOWN_BLK_GBADDR   equ 0x1438  ; LavenderTown.blk  (10×9  = 90  bytes)
OW_VERMILION_CITY_BLK_GBADDR  equ 0x1492  ; VermilionCity.blk (20×18 = 360 bytes)
OW_CELADON_CITY_BLK_GBADDR    equ 0x15FA  ; CeladonCity.blk   (25×18 = 450 bytes)
OW_FUCHSIA_CITY_BLK_GBADDR    equ 0x17BC  ; FuchsiaCity.blk   (20×18 = 360 bytes)
OW_CINNABAR_ISLAND_BLK_GBADDR equ 0x1924  ; CinnabarIsland.blk(10×9  = 90  bytes)
OW_SAFFRON_CITY_BLK_GBADDR    equ 0x197E  ; SaffronCity.blk   (20×18 = 360 bytes)
OW_ROUTE_2_BLK_GBADDR         equ 0x1AE6  ; Route2.blk        (10×36 = 360 bytes)
OW_ROUTE_3_BLK_GBADDR         equ 0x1C4E  ; Route3.blk        (35×9  = 315 bytes)
OW_ROUTE_4_BLK_GBADDR         equ 0x1D89  ; Route4.blk        (45×9  = 405 bytes)
OW_ROUTE_5_BLK_GBADDR         equ 0x1F1E  ; Route5.blk        (10×18 = 180 bytes)
OW_ROUTE_6_BLK_GBADDR         equ 0x1FD2  ; Route6.blk        (10×18 = 180 bytes)
OW_ROUTE_7_BLK_GBADDR         equ 0x2086  ; Route7.blk        (10×9  = 90  bytes)
OW_ROUTE_8_BLK_GBADDR         equ 0x20E0  ; Route8.blk        (30×9  = 270 bytes)
OW_ROUTE_9_BLK_GBADDR         equ 0x21EE  ; Route9.blk        (30×9  = 270 bytes)
OW_ROUTE_10_BLK_GBADDR        equ 0x22FC  ; Route10.blk       (10×36 = 360 bytes)
OW_ROUTE_11_BLK_GBADDR        equ 0x2464  ; Route11.blk       (30×9  = 270 bytes)
OW_ROUTE_12_BLK_GBADDR        equ 0x2572  ; Route12.blk       (10×54 = 540 bytes)
OW_ROUTE_13_BLK_GBADDR        equ 0x278E  ; Route13.blk       (30×9  = 270 bytes)
OW_ROUTE_14_BLK_GBADDR        equ 0x289C  ; Route14.blk       (10×27 = 270 bytes)
OW_ROUTE_15_BLK_GBADDR        equ 0x29AA  ; Route15.blk       (30×9  = 270 bytes)
OW_ROUTE_16_BLK_GBADDR        equ 0x2AB8  ; Route16.blk       (20×9  = 180 bytes)
OW_ROUTE_17_BLK_GBADDR        equ 0x2B6C  ; Route17.blk       (10×72 = 720 bytes)
OW_ROUTE_18_BLK_GBADDR        equ 0x2E3C  ; Route18.blk       (25×9  = 225 bytes)
OW_ROUTE_19_BLK_GBADDR        equ 0x2F1D  ; Route19.blk       (10×27 = 270 bytes)
OW_ROUTE_20_BLK_GBADDR        equ 0x302B  ; Route20.blk       (50×9  = 450 bytes)
OW_ROUTE_22_BLK_GBADDR        equ 0x31ED  ; Route22.blk       (20×9  = 180 bytes)
OW_ROUTE_24_BLK_GBADDR        equ 0x32A1  ; Route24.blk       (10×18 = 180 bytes)
OW_ROUTE_25_BLK_GBADDR        equ 0x3355  ; Route25.blk       (30×9  = 270 bytes)
OW_ROUTE_23_BLK_GBADDR        equ 0x3463  ; Route23.blk       (10×72 = 720 bytes)
OW_INDIGO_PLATEAU_BLK_GBADDR  equ 0x36F3  ; IndigoPlateau.blk (10×9  = 90  bytes)
; Shared slot for the currently-active indoor map's block data.
; LoadWarpDestination copies the target map's blk to this address before calling LoadMapHeader.
; Largest indoor map is ~540 bytes; slot ends well before VRAM at 0x8000.
INDOOR_BLK_GBADDR             equ 0x7600  ; current indoor map blk (shared, dynamic)
FIRST_INDOOR_MAP_ID           equ 0x25    ; REDS_HOUSE_1F — first map using INDOOR_BLK_GBADDR

; Connection-strip header field offsets (added to W_{NORTH,SOUTH,WEST,EAST}_CONNECTED_MAP;
; struct is 11 bytes — see map_connection_struct in macros/ram.asm).
CONN_STRIP_SRC           equ 1          ; ConnectionStripSrc  (dw) — src in connected map's blocks
CONN_STRIP_DEST          equ 3          ; ConnectionStripDest (dw) — dest in wOverworldMap border
CONN_STRIP_LENGTH        equ 5          ; ConnectionStripLength (db)
CONN_MAP_WIDTH           equ 6          ; ConnectedMapWidth (db)
CONN_Y_ALIGN             equ 7          ; ConnectedMapYAlignment (db)
CONN_X_ALIGN             equ 8          ; ConnectedMapXAlignment (db)
CONN_VIEW_PTR            equ 9          ; ConnectedMapViewPointer (dw)
CONN_HEADER_SIZE         equ 11         ; total connection header struct size

; Connection direction bits (constants/map_data_constants.asm)
CONNECTION_NORTH         equ 1 << 3     ; bit 3 = $08
CONNECTION_SOUTH         equ 1 << 2     ; bit 2 = $04
CONNECTION_WEST          equ 1 << 1     ; bit 1 = $02
CONNECTION_EAST          equ 1 << 0     ; bit 0 = $01

; Map IDs (constants/map_constants.asm — subset for implemented maps)
MAP_ID_PALLET_TOWN       equ 0x00
MAP_ID_ROUTE_1            equ 0x0C
MAP_ID_ROUTE_21           equ 0x20
MAP_NO_CONNECTION         equ 0xFF       ; sentinel: no connected map in this direction

; IE register shadow — $FFFF (1 byte)
; Emulated Interrupt Enable register. Not functionally used by the DOS port
; (interrupts are handled by the PIT ISR and input handler directly).
GB_IE           equ 0xFFFF

; VRAM bank 1 (CGB only) — placed at offset $10000 (past the 64 KB GB window)
; The allocation in entry.asm requests 72 KB (0x12000) to cover this.
; CGB tile attribute data and extra tile graphics live here.
GB_VRAM1        equ 0x10000
GB_VRAM1_SIZE   equ 0x2000     ; 8 KB

; Back buffer — 320×200 pixels, 8bpp (one byte per pixel, palette index)
; Placed just after VRAM bank 1. The tile-blitter writes here; present() copies to VGA.
; Size: 320 * 200 = 64000 bytes
GB_BACKBUF      equ 0x12000
GB_BACKBUF_SIZE equ 64000      ; RENDER_W * RENDER_H

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

; Logical GB screen dimensions (game-code uses these for tile addressing).
; NOTE: SCREEN_W/H are logical pixel dimensions; RENDER_W/H are the actual
; back-buffer/VGA dimensions (320×200 native, no scaling).
SCREEN_W        equ 160        ; logical pixels (kept for game-logic comparisons)
SCREEN_H        equ 144        ; logical pixels
SCREEN_TILES_W  equ 40         ; viewport width in tiles (= RENDER_W / TILE_WIDTH)
SCREEN_TILES_H  equ 25         ; viewport height in tiles (= RENDER_H / TILE_HEIGHT)

; Player standing tile in wTileMap — derived from render_sprites +36/+96 shift and
; the Pallet Town view pointer (bg_scy=32, bg_scx=32 → sprite feet at bg_surface Y=143).
PLAYER_STANDING_ROW equ 17     ; wTileMap row containing player's feet
PLAYER_STANDING_COL equ 24     ; wTileMap col containing player's feet

; Native render dimensions (back buffer and VGA output)
RENDER_W        equ 320        ; back buffer / VGA width in pixels
RENDER_H        equ 200        ; back buffer / VGA height in pixels
RENDER_TILES_W  equ 40         ; RENDER_W / TILE_WIDTH
RENDER_TILES_H  equ 25         ; RENDER_H / TILE_HEIGHT

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

; Tile-blitter writes directly to a 320×200 back buffer; present() is a
; straight rep movsd of 16,000 dwords.  No scaling, no letterbox.

%endif ; GB_MEMMAP_INC
