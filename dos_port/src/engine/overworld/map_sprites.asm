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
; Walking leg animation (tiles 0x80-0x8B in vChars1) is deferred to Phase 3.
; All WALK NPCs use still tiles only; animFrameCounter is held at 0.
;
; Build: nasm -f coff -I include/ -I . -o map_sprites.o src/engine/overworld/map_sprites.asm

bits 32

%include "gb_memmap.inc"
%include "gb_macros.inc"

extern g_tilecache_dirty

global InitMapSprites

; ---------------------------------------------------------------------------
; Constants
; ---------------------------------------------------------------------------
NPC_TILE_BYTES  equ 12 * TILE_SIZE      ; 192 bytes = 12 tiles per sprite type
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
; source data.
NpcSpriteAssets:
    db 0x03  ; SPRITE_OAK (0x03)
    dd npc_oak_still
    db 0x0D  ; SPRITE_GIRL (0x0D)
    dd npc_girl_still
    db 0x2F  ; SPRITE_FISHER (0x2F)
    dd npc_fisher_still
    db 0x00  ; terminator

%include "assets/npc_oak_still.inc"
%include "assets/npc_girl_still.inc"
%include "assets/npc_fisher_still.inc"

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
    mov [ebp + ebx + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_ISTRAINER], edi  ; EDI=0 or 1; bytes 0xA-0xC are free

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
    mov ecx, NPC_TILE_BYTES             ; 192 bytes
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
