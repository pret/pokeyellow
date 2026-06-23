; map_sprites.asm — NPC sprite slot initialization and tile loading.
;
; Faithful translation (pret cross-reference):
;   InitMapSprites      engine/overworld/map_sprites.asm:InitMapSprites /
;                       InitOutsideMapSprites / LoadSpriteSetFromMapHeader
;   LoadNPCSpriteTiles  engine/overworld/map_sprites.asm:LoadMapSpriteTilePatterns /
;                       ReadSpriteSheetData
;
; After LoadMapHeader sets W_OBJECT_DATA_PTR_TEMP to the GB address of the
; sprite_count byte, InitMapSprites:
;   1. Clears NPC slots 1-15 in wSpriteStateData1/2.
;   2. Reads the sprite_count and per-NPC 6/7/8-byte records from the map
;      object binary emitted by gen_map_headers.py.
;   3. Populates PICTUREID, MAPY/MAPX, MOVEMENTBYTE1/2, IMAGEBASEOFFSET,
;      ISTRAINER, and initial MOVEMENTDELAY for each NPC slot.
;   4. Calls LoadNPCSpriteTiles to copy 12 still tiles per unique sprite
;      type to the appropriate VRAM slot (imageBaseOffset-1)*192 from $8000.
;
; LoadNPCSpriteTiles loads both still tiles (→ GB_VCHARS0 slot) and walk tiles
; (→ GB_VFONT slot) from the full 24-tile sprite sheet for each unique NPC type.
;
; Build: nasm -f coff -I include/ -I . -o map_sprites.o src/engine/overworld/map_sprites.asm

bits 32

%include "gb_memmap.inc"
%include "gb_macros.inc"

extern g_tilecache_dirty
extern PrintText
extern DelayFrame
extern LoadCurrentMapView
extern MakeNPCFacePlayer
extern LoadFontTilePatterns
extern LoadPlayerSpriteGraphics
extern HandleDownArrowBlinkTiming

global InitMapSprites
global CheckNPCInteraction

; ---------------------------------------------------------------------------
; Constants
; ---------------------------------------------------------------------------
NPC_TILE_BYTES  equ 12 * TILE_SIZE      ; 192 bytes = 12 tiles per sprite type
TILE_SPC        equ 0x7F               ; blank/space tile (shared with text.asm)
NPC_SLOTS_START equ 1                   ; first NPC slot (slot 0 = player)
NPC_SLOTS_MAX   equ 15                  ; max NPC slots
VRAM_SLOT_START equ 3                   ; imageBaseOffset 1=player 2=Pikachu 3+=NPCs
SPRITE_SET_SIZE equ 12                  ; max unique sprite types per map

; ---------------------------------------------------------------------------
; BSS — per-map sprite deduplication table (reset at each InitMapSprites call)
; ---------------------------------------------------------------------------
section .bss
npc_sprite_set:  resb SPRITE_SET_SIZE   ; sprite IDs in current map (0 = unused)
npc_vram_slots:  resb SPRITE_SET_SIZE   ; imageBaseOffset for each entry

; ---------------------------------------------------------------------------
; NPC sprite tile assets (still poses only; 12 tiles = 192 bytes each)
; Included here so they land in .data and the NpcSpriteAssets table's dd
; pointers resolve to correct flat DS addresses.
; ---------------------------------------------------------------------------
section .data

; NpcSpriteAssets — table of (sprite_id byte, asset_ptr dd) pairs, terminated
; by sprite_id = 0x00.  LoadNPCSpriteTiles scans this to find each sprite's
; source data.  Each asset is the full 384-byte sheet: tiles [0-11] = still,
; tiles [12-23] = walk.
NpcSpriteAssets:
    db 0x03  ; SPRITE_OAK (0x03)
    dd npc_oak
    db 0x0D  ; SPRITE_GIRL (0x0D)
    dd npc_girl
    db 0x2F  ; SPRITE_FISHER (0x2F)
    dd npc_fisher
    db 0x00  ; terminator

%include "assets/npc_oak.inc"
%include "assets/npc_girl.inc"
%include "assets/npc_fisher.inc"

; ---------------------------------------------------------------------------
; Pallet Town NPC text streams (GB charmap encoding, EBP-relative via WRAM copy).
; Format: TX_START(0x00) + inline GB-charset string ending in CHAR_DONE(0x57)
;         or CHAR_TERMINATOR(0x50) followed by TX_END(0x50).
; Pret ref: text/PalletTown.asm
; ---------------------------------------------------------------------------

; Oak: "OAK: Hey! Wait!\nDon't go out!"
; _PalletTownOakHeyWaitDontGoOutText (text_end format → CHAR_TERMINATOR + TX_END)
pallet_oak_text:
    db 0x00                                               ; TX_START
    db 0x8E,0x80,0x8A,0x9C,0x7F                          ; "OAK: "
    db 0x87,0xA4,0xB8,0xE7,0x7F                          ; "Hey! "
    db 0x96,0xA0,0xA8,0xB3,0xE7                          ; "Wait!"
    db 0x4F                                               ; CHAR_LINE
    db 0x83,0xAE,0xAD,0xBE,0x7F                          ; "Don't "
    db 0xA6,0xAE,0x7F                                    ; "go "
    db 0xAE,0xB4,0xB3,0xE7                               ; "out!"
    db 0x50, 0x50                                         ; CHAR_TERMINATOR, TX_END
pallet_oak_text_end:

; Girl: "I'm raising\n#MON too!\nWhen they get\nstrong, they can\nprotect me!"
; _PalletTownGirlText (done format → CHAR_DONE)
pallet_girl_text:
    db 0x00                                               ; TX_START
    db 0x88,0xE5,0x7F                                    ; "I'm "
    db 0xB1,0xA0,0xA8,0xB2,0xA8,0xAD,0xA6               ; "raising"
    db 0x4F                                               ; CHAR_LINE
    db 0x54,0x8C,0x8E,0x8D,0x7F                          ; "#MON "
    db 0xB3,0xAE,0xAE,0xE7                               ; "too!"
    db 0x51                                               ; CHAR_PARA
    db 0x96,0xA7,0xA4,0xAD,0x7F                          ; "When "
    db 0xB3,0xA7,0xA4,0xB8,0x7F                          ; "they "
    db 0xA6,0xA4,0xB3                                    ; "get"
    db 0x4F                                               ; CHAR_LINE
    db 0xB2,0xB3,0xB1,0xAE,0xAD,0xA6,0xF4,0x7F          ; "strong, "
    db 0xB3,0xA7,0xA4,0xB8,0x7F                          ; "they "
    db 0xA2,0xA0,0xAD                                    ; "can"
    db 0x55                                               ; CHAR_CONT
    db 0xAF,0xB1,0xAE,0xB3,0xA4,0xA2,0xB3,0x7F          ; "protect "
    db 0xAC,0xA4,0xE7                                    ; "me!"
    db 0x57, 0x50                                         ; CHAR_DONE, TX_END
pallet_girl_text_end:

; Fisher: "Technology is\nincredible!\nYou can now store\nand recall items\nand #MON as\ndata via PC!"
; _PalletTownFisherText (done format → CHAR_DONE)
pallet_fisher_text:
    db 0x00                                               ; TX_START
    db 0x93,0xA4,0xA2,0xA7,0xAD,0xAE,0xAB,0xAE,0xA6,0xB8,0x7F  ; "Technology "
    db 0xA8,0xB2                                          ; "is"
    db 0x4F                                               ; CHAR_LINE
    db 0xA8,0xAD,0xA2,0xB1,0xA4,0xA3,0xA8,0xA1,0xAB,0xA4,0xE7  ; "incredible!"
    db 0x51                                               ; CHAR_PARA
    db 0x98,0xAE,0xB4,0x7F                               ; "You "
    db 0xA2,0xA0,0xAD,0x7F                               ; "can "
    db 0xAD,0xAE,0xB6,0x7F                               ; "now "
    db 0xB2,0xB3,0xAE,0xB1,0xA4                          ; "store"
    db 0x4F                                               ; CHAR_LINE
    db 0xA0,0xAD,0xA3,0x7F                               ; "and "
    db 0xB1,0xA4,0xA2,0xA0,0xAB,0xAB,0x7F               ; "recall "
    db 0xA8,0xB3,0xA4,0xAC,0xB2                          ; "items"
    db 0x55                                               ; CHAR_CONT
    db 0xA0,0xAD,0xA3,0x7F                               ; "and "
    db 0x54,0x8C,0x8E,0x8D,0x7F                          ; "#MON "
    db 0xA0,0xB2                                          ; "as"
    db 0x55                                               ; CHAR_CONT
    db 0xA3,0xA0,0xB3,0xA0,0x7F                          ; "data "
    db 0xB5,0xA8,0xA0,0x7F                               ; "via "
    db 0x8F,0x82,0xE7                                    ; "PC!"
    db 0x57, 0x50                                         ; CHAR_DONE, TX_END
pallet_fisher_text_end:

; PalletTownTextTable — (flat_ptr, size) pairs indexed by text_id.
; Terminated by a null entry. CheckNPCInteraction copies the selected entry
; to NPC_DIALOG_BUF in WRAM before calling PrintText.
PalletTownTextTable:
    dd pallet_oak_text,    pallet_oak_text_end    - pallet_oak_text
    dd pallet_girl_text,   pallet_girl_text_end   - pallet_girl_text
    dd pallet_fisher_text, pallet_fisher_text_end - pallet_fisher_text
    dd 0, 0

; ---------------------------------------------------------------------------
; Code
; ---------------------------------------------------------------------------
section .text

; ---------------------------------------------------------------------------
; InitMapSprites — populate NPC sprite slots from the map's object data.
; Pret ref: engine/overworld/map_sprites.asm:InitMapSprites (outside maps path).
;
; Prerequisites: LoadMapHeader must have run; it sets W_OBJECT_DATA_PTR_TEMP to
; the GB address of the sprite_count byte in the map_object binary.
;
; All registers preserved (pushad/popad).
; ---------------------------------------------------------------------------
InitMapSprites:
    pushad

    ; --- Clear NPC slots 1-15 in wSpriteStateData1 and wSpriteStateData2 ---
    lea edi, [ebp + W_SPRITE_STATE_DATA_1 + 0x10]  ; slot 1 onward
    xor al, al
    mov ecx, NPC_SLOTS_MAX * 0x10      ; 15 * 16 = 240 bytes
    rep stosb
    lea edi, [ebp + W_SPRITE_STATE_DATA_2 + 0x10]
    mov ecx, NPC_SLOTS_MAX * 0x10
    rep stosb

    ; --- Clear per-call sprite deduplication table ---
    mov edi, npc_sprite_set
    xor al, al
    mov ecx, SPRITE_SET_SIZE * 2       ; sprite_set + vram_slots = 24 bytes
    rep stosb

    ; --- Read sprite_count from W_OBJECT_DATA_PTR_TEMP ---
    movzx esi, word [ebp + W_OBJECT_DATA_PTR_TEMP]   ; ESI = GB addr of sprite_count
    movzx ecx, byte [ebp + esi]
    inc esi                             ; advance past sprite_count byte
    test ecx, ecx
    jz .done                            ; no NPCs on this map

    ; EBX = current slot byte offset within wSpriteStateData1/2 (slot N at N*0x10)
    ; EDX = next available imageBaseOffset (starts at VRAM_SLOT_START = 3)
    ; ESI = read pointer into GB map object binary (already past sprite_count)
    ; ECX = NPC count remaining
    mov ebx, 0x10                       ; start at slot 1 (0x10)
    mov edx, VRAM_SLOT_START            ; next_vram_slot = 3

.slot_loop:
    ; Read sprite_id byte
    movzx eax, byte [ebp + esi]
    inc esi
    mov [ebp + ebx + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_PICTUREID], al
    mov byte [ebp + ebx + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_MOVEMENTSTATUS], 0
    mov byte [ebp + ebx + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_FACINGDIRECTION], SPRITE_FACING_DOWN

    ; Save sprite_id (AL) and count (ECX) — FindOrAssignVramSlot may clobber ECX
    push eax
    push ecx

    ; Read mapy
    movzx eax, byte [ebp + esi]
    inc esi
    mov [ebp + ebx + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_MAPY], al

    ; Read mapx
    movzx eax, byte [ebp + esi]
    inc esi
    mov [ebp + ebx + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_MAPX], al

    ; Read mov_byte (STAY=0xFF / WALK=0xFE / scripted=<0xFE)
    movzx eax, byte [ebp + esi]
    inc esi
    mov [ebp + ebx + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_MOVEMENTBYTE1], al

    ; Read dir_byte (0x00=ANY / 0x01=UP_DOWN / 0x02=LEFT_RIGHT / 0xFF=NONE)
    movzx eax, byte [ebp + esi]
    inc esi
    mov [ebp + ebx + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_MOVEMENTBYTE2], al

    ; Set initial movement delay (30 frames before first walk attempt)
    mov byte [ebp + ebx + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_MOVEMENTDELAY], 30

    ; Read text_byte; check for trainer (TRAINER_FLAG = 0x40)
    movzx eax, byte [ebp + esi]
    inc esi
    xor edi, edi                        ; is_trainer = 0
    test al, TRAINER_FLAG
    jz .not_trainer
    mov edi, 1                          ; is_trainer = 1
    add esi, 2                          ; skip trainer_class + trainer_num bytes
.not_trainer:
    test al, ITEM_FLAG
    jz .not_item
    inc esi                             ; skip item_id byte (items handled by text engine, Phase 3+)
.not_item:
    ; Store text_id = text_byte & 0x3F (lower 6 bits: trainer/item flags are high bits)
    push eax
    and al, 0x3F
    mov [ebp + ebx + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_TEXTID], al
    pop eax
    mov [ebp + ebx + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_ISTRAINER], edi  ; EDI=0 or 1

    ; Assign or look up a VRAM slot for this sprite type
    pop ecx
    pop eax                             ; AL = sprite_id
    push ecx
    call FindOrAssignVramSlot           ; In: AL=sprite_id, EDX=next_slot. Out: AL=imageBaseOffset
    mov [ebp + ebx + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_IMAGEBASEOFFSET], al

    pop ecx
    add ebx, 0x10                       ; advance to next slot
    dec ecx
    jnz .slot_loop

.slots_done:
    call LoadNPCSpriteTiles

.done:
    popad
    ret

; ---------------------------------------------------------------------------
; FindOrAssignVramSlot — VRAM deduplication for NPC sprite types.
; Pret ref: engine/overworld/map_sprites.asm:GetSpriteImageBaseOffset (logic).
;
; In:  AL  = sprite_id
;      EDX = next available imageBaseOffset (caller-owned, updated on assign)
; Out: AL  = imageBaseOffset for this sprite_id
;      EDX = updated (incremented if a new slot was assigned)
; Clobbers: ESI, ECX
; ---------------------------------------------------------------------------
FindOrAssignVramSlot:
    push esi
    push ecx
    mov esi, 0                          ; index into npc_sprite_set
.scan:
    cmp esi, SPRITE_SET_SIZE
    jge .assign                         ; table full (shouldn't happen for ≤12 maps)
    movzx ecx, byte [npc_sprite_set + esi]
    test cl, cl
    jz .assign                          ; empty slot → sprite not seen before
    cmp cl, al
    je .found
    inc esi
    jmp .scan
.found:
    ; Return cached imageBaseOffset for this sprite_id
    movzx eax, byte [npc_vram_slots + esi]
    pop ecx
    pop esi
    ret
.assign:
    ; New sprite type — record it and assign next_vram_slot
    cmp esi, SPRITE_SET_SIZE
    jge .overflow
    mov [npc_sprite_set + esi], al
    mov [npc_vram_slots  + esi], dl
.overflow:
    mov al, dl                          ; return assigned (or last valid) slot
    inc edx                             ; next_vram_slot++
    pop ecx
    pop esi
    ret

; ---------------------------------------------------------------------------
; LoadNPCSpriteTiles — copy still tiles for each unique sprite type to VRAM.
; Pret ref: engine/overworld/map_sprites.asm:LoadMapSpriteTilePatterns /
;            ReadSpriteSheetData.
;
; Iterates npc_sprite_set; for each non-zero entry, looks up the source asset
; in NpcSpriteAssets and copies NPC_TILE_BYTES (192) bytes to:
;   [EBP + GB_VCHARS0 + (imageBaseOffset - 1) * NPC_TILE_BYTES]
;
; Sets g_tilecache_dirty = 1 after any copy.
; All registers preserved (push/pop).
; ---------------------------------------------------------------------------
LoadNPCSpriteTiles:
    push eax
    push ebx
    push ecx
    push esi
    push edi

    mov ebx, 0                          ; sprite_set index
.tile_loop:
    cmp ebx, SPRITE_SET_SIZE
    jge .done
    movzx eax, byte [npc_sprite_set + ebx]
    test al, al
    jz .done                            ; end of used entries

    ; Compute VRAM destination flat address:
    ;   edi = EBP + GB_VCHARS0 + (imageBaseOffset - 1) * NPC_TILE_BYTES
    movzx ecx, byte [npc_vram_slots + ebx]
    dec ecx                             ; (imageBaseOffset - 1)
    imul ecx, NPC_TILE_BYTES            ; * 192
    lea edi, [ebp + ecx + GB_VCHARS0]  ; flat addr in GB VRAM

    ; Look up asset source for this sprite_id (AL)
    mov esi, NpcSpriteAssets
.asset_scan:
    movzx ecx, byte [esi]
    test cl, cl
    jz .next_sprite                     ; sprite not in table (no asset loaded)
    cmp cl, al
    je .found_asset
    add esi, 5                          ; skip 1-byte id + 4-byte ptr
    jmp .asset_scan
.found_asset:
    mov esi, [esi + 1]                  ; load flat asset pointer (the dd value)
    ; Still tiles [0-11] → GB_VCHARS0 + (imageBaseOffset-1)*NPC_TILE_BYTES
    mov ecx, NPC_TILE_BYTES
    rep movsb
    ; Walk tiles [12-23] → GB_VFONT + (imageBaseOffset-1)*NPC_TILE_BYTES.
    ; These share GB_VFONT with the text font; LoadFontTilePatterns must be called
    ; before any PrintText call, and LoadNPCSpriteTiles after, to swap correctly.
    ; Safe for ≤6 unique NPC types per map (96 font tiles = 6 × 16-tile slots).
    movzx ecx, byte [npc_vram_slots + ebx]
    dec ecx
    imul ecx, NPC_TILE_BYTES
    lea edi, [ebp + ecx + GB_VFONT]
    mov ecx, NPC_TILE_BYTES
    rep movsb
    mov byte [g_tilecache_dirty], 1

.next_sprite:
    inc ebx
    jmp .tile_loop

.done:
    pop edi
    pop esi
    pop ecx
    pop ebx
    pop eax
    ret

; ---------------------------------------------------------------------------
; CheckNPCInteraction — check if an NPC is one block in front of the player;
; if so, make it face the player, copy its dialog to WRAM, and run PrintText.
;
; Pret ref: home/overworld.asm:IsSpriteOrSignInFrontOfPlayer (block-coord variant).
; Called from OverworldLoop when A is pressed and W_WALK_COUNTER == 0.
;
; Detection: NPC in front iff (MAPY - 4) == W_Y_COORD + dy
;                         AND (MAPX - 4) == W_X_COORD + dx
; where (dy,dx) = (-1,0) SPRITE_FACING_UP, (+1,0) DOWN, (0,-1) LEFT, (0,+1) RIGHT.
;
; Text data from PalletTownTextTable (flat .data ptr + size) is copied to
; NPC_DIALOG_BUF in WRAM (EBP-relative). PrintText reads the TX stream from there.
;
; After PrintText (or on CHAR_DONE within PrintText), the window is already shown
; at H_WY=152 by manual_text_scroll. This function hides the window (H_WY=200),
; restores the BG, and returns AL=1 (NPC found) or AL=0 (nothing found).
;
; All registers preserved (pushad/popad). Returns AL in EAX after popad.
; ---------------------------------------------------------------------------
; Dialog-box Y constants (wTileMap rows 12-17 → GB_TILEMAP1 rows 0-5, WY=152 in 320×200).
DIALOG_TILEMAP_ROW      equ 12
DIALOG_TILEMAP_ROWS     equ 6

CheckNPCInteraction:
    pushad

    ; Compute target block coordinates from player facing direction.
    ; W_Y_COORD and W_X_COORD are raw block coords; MAPY/MAPX are raw+4.
    ; Target MAPY = W_Y_COORD + 4 + dy; target MAPX = W_X_COORD + 4 + dx.
    movzx ebx, byte [ebp + W_Y_COORD]
    add bl, 4                               ; adjust for MAPY offset (+4)
    movzx ecx, byte [ebp + W_X_COORD]
    add cl, 4                               ; adjust for MAPX offset (+4)

    movzx eax, byte [ebp + W_SPRITE_PLAYER_FACING_DIR]
    cmp al, SPRITE_FACING_UP
    je .face_up
    cmp al, SPRITE_FACING_DOWN
    je .face_down
    cmp al, SPRITE_FACING_LEFT
    je .face_left
    ; SPRITE_FACING_RIGHT (0x0C) or default
    inc cl                                  ; MAPX + 1 (block to the right)
    jmp .scan
.face_up:
    dec bl                                  ; MAPY - 1 (block to the north)
    jmp .scan
.face_down:
    inc bl                                  ; MAPY + 1 (block to the south)
    jmp .scan
.face_left:
    dec cl                                  ; MAPX - 1 (block to the west)

.scan:
    ; BL = target_mapy, CL = target_mapx
    ; Scan NPC slots 1-15 (slot 0 = player).
    mov esi, 0x10                           ; slot byte offset starts at slot 1

.slot_loop:
    cmp esi, 0x100
    jge .not_found

    ; Skip inactive slots (IMAGEBASEOFFSET == 0 means slot is unused).
    movzx eax, byte [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_IMAGEBASEOFFSET]
    test al, al
    jz .next_slot

    ; Compare MAPY and MAPX.
    movzx eax, byte [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_MAPY]
    cmp al, bl
    jne .next_slot
    movzx eax, byte [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_MAPX]
    cmp al, cl
    je .found_npc
.next_slot:
    add esi, 0x10
    jmp .slot_loop

.found_npc:
    ; ── Found: NPC at target block ──────────────────────────────────────────

    ; Set H_TILE_PLAYER_STANDING_ON so UpdateSpriteImage picks this NPC's VRAM slot.
    ; UpdateSprites leaves H_TILE_PLAYER_STANDING_ON = last-slot value after the loop;
    ; that would cause the wrong sprite tiles (e.g. Fisher's) for any earlier NPC.
    movzx eax, byte [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_IMAGEBASEOFFSET]
    dec al
    ror al, 4                           ; (imageBaseOffset-1)*16 → high nibble for UpdateSpriteImage
    mov [ebp + H_TILE_PLAYER_STANDING_ON], al

    ; Make NPC face player (sets facing, clears BIT_FACE_PLAYER, refreshes image).
    call MakeNPCFacePlayer

    ; Freeze NPC movement during dialog.
    or byte [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_MOVEMENTSTATUS], (1 << BIT_FACE_PLAYER)

    ; Look up text_id → text data pointer and size from PalletTownTextTable.
    movzx eax, byte [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_TEXTID]
    lea edx, [eax * 8]                      ; 8 bytes per entry (dd ptr + dd size)
    mov edi, [PalletTownTextTable + edx]    ; flat DS ptr to text stream
    test edi, edi
    jz .dialog_done                         ; null entry: no text for this id

    mov ecx, [PalletTownTextTable + edx + 4]  ; byte count
    cmp ecx, 256
    jge .dialog_done                        ; safety: never copy more than 256 bytes

    ; Copy text stream from flat .data to NPC_DIALOG_BUF in WRAM (EBP-relative).
    mov esi, edi                            ; flat src ptr
    lea edi, [ebp + NPC_DIALOG_BUF]
    rep movsb

    ; Set W_FONT_LOADED to freeze UpdateSprites NPC movement during dialog.
    or byte [ebp + W_FONT_LOADED], (1 << BIT_FONT_LOADED)

    ; Restore font glyphs to GB_VFONT before text rendering (walk tiles share it).
    call LoadFontTilePatterns

    ; Call PrintText with ESI = EBP-relative address of NPC_DIALOG_BUF.
    mov esi, NPC_DIALOG_BUF
    call PrintText
    ; PrintText calls manual_text_scroll at CHAR_PARA/CHAR_CONT/CHAR_DONE,
    ; which shows the dialog (copies tiles to GB_TILEMAP1, H_WY=152) and waits.
    ; For text_end format (Oak): no final scroll inside PrintText; show + wait here.
    call .show_dialog_and_wait

.dialog_done:
    ; Hide window and clear font-loaded flag.
    mov byte [ebp + H_WY], RENDER_H     ; 200 = off-screen in 320×200 viewport
    and byte [ebp + W_FONT_LOADED], ~(1 << BIT_FONT_LOADED)

    ; Reload NPC and player walk tiles into GB_VFONT (font was loaded for dialog).
    call LoadNPCSpriteTiles
    call LoadPlayerSpriteGraphics

    ; Restore the BG: rebuild wSurroundingTiles for current player position.
    call LoadCurrentMapView
    call DelayFrame

    ; Signal caller that NPC interaction occurred.
    mov dword [esp + 28], 1                 ; overwrite saved EAX slot in pushad frame
    popad
    ret

.not_found:
    xor eax, eax
    mov dword [esp + 28], 0
    popad
    ret

; ── local helper: copy current wTileMap dialog rows to window layer, wait A/B ──
.show_dialog_and_wait:
    ; Copy wTileMap rows 12-17 to GB_TILEMAP1 rows 0-5 (window layer source).
    push ecx
    push esi
    push edi
    mov ecx, DIALOG_TILEMAP_ROWS
    lea esi, [ebp + W_TILEMAP + DIALOG_TILEMAP_ROW * 20]
    lea edi, [ebp + GB_TILEMAP1]
.sdw_row:
    push ecx
    push edi
    mov ecx, 20                             ; 20 tiles from wTileMap
    rep movsb
    mov al, TILE_SPC
    mov ecx, 12                             ; pad cols 20-31 with space
    rep stosb
    pop edi
    pop ecx
    add edi, 32                             ; next GB_TILEMAP1 row (32 wide)
    dec ecx
    jnz .sdw_row
    mov byte [ebp + H_WY], 152             ; show window at bottom of 320×200 viewport
    mov byte [ebp + IO_WX], 87            ; WX-7=80 → center 160px dialog in 320px wide buffer
    ; Place ▼ arrow and init blink counters; save existing state to restore after.
    movzx ecx, byte [ebp + H_DOWN_ARROW_COUNT1]
    push ecx
    movzx ecx, byte [ebp + H_DOWN_ARROW_COUNT2]
    push ecx
    mov byte [ebp + H_DOWN_ARROW_COUNT1], ARROW_ON_FRAMES
    mov byte [ebp + H_DOWN_ARROW_COUNT2], 1
    mov esi, GB_TILEMAP1 + DIALOG_ARROW_TILEMAP_OFFSET
    mov byte [ebp + esi], CHAR_DOWN_ARROW
    ; Release: wait until A/B not held.
.sdw_release:
    call DelayFrame
    test byte [ebp + H_JOY_HELD], PAD_A | PAD_B
    jnz .sdw_release
    ; Press: wait for A or B; blink ▼ each frame.
.sdw_press:
    call DelayFrame
    call HandleDownArrowBlinkTiming
    test byte [ebp + H_JOY_HELD], PAD_A | PAD_B
    jz .sdw_press
    ; Clear arrow, restore blink state.
    mov byte [ebp + GB_TILEMAP1 + DIALOG_ARROW_TILEMAP_OFFSET], TILE_SPC
    pop ecx
    mov [ebp + H_DOWN_ARROW_COUNT2], cl
    pop ecx
    mov [ebp + H_DOWN_ARROW_COUNT1], cl
    pop edi
    pop esi
    pop ecx
    ret
