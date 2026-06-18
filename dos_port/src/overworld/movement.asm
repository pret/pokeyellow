; movement.asm — UpdateSprites: per-frame sprite state / walk-animation update.
;
; Faithful translation of:
;   home/update_sprites.asm:UpdateSprites
;   engine/overworld/sprite_collisions.asm:_UpdateSprites
;   engine/overworld/movement.asm:UpdatePlayerSprite / UpdateNonPlayerSprite /
;     InitializeSpriteStatus / InitializeSpriteScreenPosition / Func_5033 /
;     CheckSpriteAvailability / GetTileSpriteStandsOn / UpdateSpriteImage /
;     Func_4e32 / Func_5274
;
; UpdateSprites runs once per overworld-loop iteration. It walks all 16 sprite
; slots: slot 0 → UpdatePlayerSprite (facing + walk animation); slots 1-15 →
; UpdateNonPlayerSprite (static NPCs: screen-position + image index from
; wSpriteStateData1/2, no movement engine yet). PrepareOAMData (sprite_oam.asm)
; then turns the image indices into shadow-OAM entries each DelayFrame.
;
; NPC scope: static NPCs only (MOVEMENTSTATUS 0→1 init, CheckSpriteAvailability,
; InitializeSpriteScreenPosition). Random/scripted NPC movement is deferred.
;
; Build: nasm -f coff -I include/ -I . -o movement.o src/overworld/movement.asm

bits 32

%include "gb_memmap.inc"
%include "gb_macros.inc"

global UpdateSprites

section .text

; ---------------------------------------------------------------------------
; UpdateSprites — gate on wUpdateSpritesEnabled, then run _UpdateSprites.
; Pret ref: home/update_sprites.asm:UpdateSprites (bank-switch omitted).
; All registers preserved.
; ---------------------------------------------------------------------------
UpdateSprites:
    cmp byte [ebp + W_UPDATE_SPRITES_ENABLED], 1
    jne .done
    pushad
    mov byte [ebp + W_UPDATE_SPRITES_ENABLED], 0xFF
    call _UpdateSprites
    mov byte [ebp + W_UPDATE_SPRITES_ENABLED], 1
    popad
.done:
    ret

; ---------------------------------------------------------------------------
; _UpdateSprites — iterate the 16 sprite slots, dispatch each active one.
; Pret ref: engine/overworld/sprite_collisions.asm:_UpdateSprites.
; A slot is active when its data2 image-base-offset field is non-zero.
; ---------------------------------------------------------------------------
_UpdateSprites:
    xor esi, esi                         ; ESI = slot byte offset
.loop:
    mov eax, esi
    mov [ebp + H_CURRENT_SPRITE_OFFSET], al
    mov al, [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_IMAGEBASEOFFSET]
    test al, al
    jz .skip                             ; inactive slot
    test esi, esi
    jnz .npc                             ; slots 1-15 are NPCs/Pikachu
    call UpdatePlayerSprite
    jmp .skip
.npc:
    call UpdateNonPlayerSprite
.skip:
    ; Re-derive ESI from hCurrentSpriteOffset: UpdateNonPlayerSprite reloads ESI
    ; from this field, so we must re-derive rather than trusting the pre-call value.
    movzx esi, byte [ebp + H_CURRENT_SPRITE_OFFSET]
    add esi, 0x10
    cmp esi, 0x100
    jne .loop
    ret

; ---------------------------------------------------------------------------
; UpdateNonPlayerSprite — static NPC screen-position + image-index update.
; Pret ref: engine/overworld/movement.asm:UpdateNonPlayerSprite.
;
; Scope: static NPCs only (MOVEMENTBYTE1 = STAY). Movement engine deferred.
;
; ESI is reloaded from hCurrentSpriteOffset at entry (clobbers the loop's ESI;
; the loop re-derives ESI after the call — see .skip above).
; All other registers: caller is UpdateSprites which pushad/popad, so free.
; ---------------------------------------------------------------------------
UpdateNonPlayerSprite:
    movzx esi, byte [ebp + H_CURRENT_SPRITE_OFFSET]
    ; hTilePlayerStandingOn = (imageBaseOffset - 1) << 4 (VRAM tile-group high nibble).
    ; Func_4a7b reads this to find the sprite's tile base: group * 12.
    mov al, [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_IMAGEBASEOFFSET]
    dec al
    ror al, 4                            ; nibble swap: (N-1) → (N-1)*16
    mov [ebp + H_TILE_PLAYER_STANDING_ON], al
    mov al, [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_MOVEMENTSTATUS]
    test al, al
    jz .initStatus                       ; status 0 → first-frame init
    call CheckSpriteAvailability
    jc .ret                              ; CF=1 → invisible, done
    cmp byte [ebp + W_WALK_COUNTER], 0
    jne .ret                             ; mid-walk → sprite-shift loop handles pixel motion
    call InitializeSpriteScreenPosition  ; standing: snap screen position to map coords
.ret:
    ret
.initStatus:
    call InitializeSpriteStatus
    ret

; ---------------------------------------------------------------------------
; InitializeSpriteStatus — first-frame NPC init.
; Pret ref: engine/overworld/movement.asm:InitializeSpriteStatus.
; Sets MOVEMENTSTATUS=1 (ready), IMAGEINDEX=$ff (invisible), YDISPLACEMENT/
; XDISPLACEMENT=8, then computes initial screen position.
; In: ESI = slot byte offset. Clobbers AL.
; ---------------------------------------------------------------------------
InitializeSpriteStatus:
    mov byte [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_MOVEMENTSTATUS], 1
    mov byte [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_IMAGEINDEX], 0xFF
    mov byte [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_YDISPLACEMENT], 8
    mov byte [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_XDISPLACEMENT], 8
    call InitializeSpriteScreenPosition
    ret

; ---------------------------------------------------------------------------
; InitializeSpriteScreenPosition — compute screen Y/X from map coords.
; Pret ref: engine/overworld/movement.asm:InitializeSpriteScreenPosition.
;
; YPixels = Func_5033(MAPY - wYCoord) - 4
; XPixels = Func_5033(MAPX - wXCoord)
;
; Func_5033 reads CF from the preceding sub instruction — they must be adjacent.
; In: ESI = slot byte offset. Clobbers AL.
; ---------------------------------------------------------------------------
InitializeSpriteScreenPosition:
    mov al, [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_MAPY]
    sub al, [ebp + W_Y_COORD]           ; CF = 1 if MAPY < wYCoord (NPC above player)
    call Func_5033                       ; AL = signed (MAPY-wYCoord)*16
    sub al, 4
    mov [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_YPIXELS], al
    mov al, [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_MAPX]
    sub al, [ebp + W_X_COORD]           ; CF = 1 if MAPX < wXCoord
    call Func_5033                       ; AL = signed (MAPX-wXCoord)*16
    mov [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_XPIXELS], al
    ret

; ---------------------------------------------------------------------------
; Func_5033 — signed 8-bit multiply by 16 (nibble swap with sign extension).
; Pret ref: engine/overworld/movement.asm:Func_5033.
; Equivalent to SM83 `swap a` with sign handling: a * 16 mod 256.
; In: AL = value, CF = sign (1 if value is negative = wrapped subtraction).
; Out: AL = AL * 16 mod 256 (signed). Clobbers AL.
; ---------------------------------------------------------------------------
Func_5033:
    jnc .positive
    not al                               ; ones complement
    inc al                               ; two's complement negate: AL = -AL
    ror al, 4                            ; nibble swap = *16 mod 256
    not al
    inc al                               ; negate result: AL = -((-orig)*16) = orig*16
    ret
.positive:
    ror al, 4                            ; nibble swap = *16 mod 256 for AL < 16
    ret

; ---------------------------------------------------------------------------
; CheckSpriteAvailability — visibility test for one NPC slot.
; Pret ref: engine/overworld/movement.asm:CheckSpriteAvailability.
;
; Stubs: IsObjectHidden / hIsToggleableObjectOff (always visible — no predef yet).
; Scripted movement (MOVEMENTBYTE1 < WALK) skips X/Y range tests.
; Calls UpdateSpriteImage and sets GRASSPRIORITY when wWalkCounter == 0.
;
; In: ESI = slot byte offset, hTilePlayerStandingOn = VRAM tile group byte.
; Out: CF = 1 → invisible (IMAGEINDEX set to $ff); CF = 0 → visible.
; Clobbers AL, BL, CL, EBX, ECX.
; ---------------------------------------------------------------------------
CheckSpriteAvailability:
    ; IsObjectHidden stub: no toggleable objects yet — always visible.
    mov al, [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_MOVEMENTBYTE1]
    cmp al, WALK
    jb .skipXYVisibility                 ; scripted movement: always show, skip range test
    ; Y range test: visible when wYCoord < MAPY <= wYCoord + SCREEN_HEIGHT/2-1 (8)
    mov bl, [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_MAPY]
    mov al, [ebp + W_Y_COORD]
    cmp al, bl
    je  .skipYVisibility                 ; wYCoord == MAPY → same row, visible
    jae .spriteInvisible                 ; wYCoord >= MAPY → NPC above screen region
    add al, SCREEN_HEIGHT / 2 - 1       ; 8 (metatile rows to bottom of visible area)
    cmp al, bl
    jb  .spriteInvisible                 ; wYCoord+8 < MAPY → NPC below screen region
.skipYVisibility:
    ; X range test: visible when wXCoord < MAPX <= wXCoord + SCREEN_WIDTH/2-1 (9)
    mov bl, [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_MAPX]
    mov al, [ebp + W_X_COORD]
    cmp al, bl
    je  .skipXYVisibility
    jae .spriteInvisible                 ; wXCoord >= MAPX → left of screen region
    add al, SCREEN_WIDTH / 2 - 1        ; 9 (metatile columns to right of visible area)
    cmp al, bl
    jb  .spriteInvisible                 ; wXCoord+9 < MAPX → right of screen region
.skipXYVisibility:
    ; Text-box tile check: if any of the 4 tiles the sprite stands on is a text-box
    ; tile (ID >= MAP_TILESET_SIZE / $60), the sprite is obscured → invisible.
    call GetTileSpriteStandsOn           ; EBX = wTileMap offset of lower-left tile
    mov al, [ebp + ebx]                  ; BL tile (lower-left)
    cmp al, MAP_TILESET_SIZE
    jae .spriteInvisible
    mov al, [ebp + ebx + 1]             ; BR tile (lower-right)
    cmp al, MAP_TILESET_SIZE
    jae .spriteInvisible
    mov al, [ebp + ebx - SCREEN_WIDTH]  ; TL tile (upper-left)
    cmp al, MAP_TILESET_SIZE
    jae .spriteInvisible
    mov al, [ebp + ebx - SCREEN_WIDTH + 1] ; TR tile (upper-right)
    cmp al, MAP_TILESET_SIZE
    jb  .spriteVisible                   ; TR tile is a map tile → sprite visible
.spriteInvisible:
    mov byte [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_IMAGEINDEX], 0xFF
    stc
    ret
.spriteVisible:
    mov cl, al                           ; CL = TR tile (grass comparison below)
    cmp byte [ebp + W_WALK_COUNTER], 0
    jne .done                            ; player mid-walk: don't update image/grass yet
    call UpdateSpriteImage               ; set IMAGEINDEX = animFrame + facing + tileGroup
    mov al, [ebp + W_GRASS_TILE]
    cmp al, cl
    mov al, 0
    jne .notInGrass
    mov al, OAM_PRIO                     ; $80 = draw NPC under grass overlay
.notInGrass:
    mov [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_GRASSPRIORITY], al
.done:
    clc
    ret

; ---------------------------------------------------------------------------
; GetTileSpriteStandsOn — wTileMap pointer for the tile under the sprite.
; Pret ref: engine/overworld/movement.asm:GetTileSpriteStandsOn.
;
; Returns the lower-left tile of the 2×2-tile block the sprite occupies:
;   c = ((YPixels+4) & $f8) >> 1   (= screenYtile * 4)
;   e = (XPixels >> 3) + SCREEN_WIDTH
;   EBX = W_TILEMAP + 5*c + e      (= wTileMap + 20*(screenYtile+1) + screenXtile)
;
; In: ESI = slot byte offset. Out: EBX = W_TILEMAP-relative offset. Clobbers AL, ECX, EBX.
; ---------------------------------------------------------------------------
GetTileSpriteStandsOn:
    ; DOS W_TILEMAP is exactly the 40x25 screen.
    ; Game Boy screen Y=8 maps to DOS screen Y=13 (bottom-left) -> offset = +5
    mov al, [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_YPIXELS]
    add al, 4
    and al, 0xF8
    movsx ecx, al
    sar ecx, 3                           ; ECX = Game Boy screenYtile
    add ecx, 5                           ; ECX = DOS screenYtile
    
    ; Game Boy screen X=8 maps to DOS screen X=20 -> offset = +12
    mov al, [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_XPIXELS]
    movsx ebx, al
    sar ebx, 3                           ; EBX = Game Boy screenXtile
    add ebx, 12                          ; EBX = DOS screenXtile
    
    ; EBX = W_TILEMAP + 40 * screenYtile + screenXtile
    imul ecx, ecx, SCREEN_WIDTH
    add ebx, ecx
    add ebx, W_TILEMAP
    ret

; ---------------------------------------------------------------------------
; UpdateSpriteImage — compute and store IMAGEINDEX for the current NPC slot.
; Pret ref: engine/overworld/movement.asm:UpdateSpriteImage.
;
; imageIndex = animFrameCounter + facingDirection + hTilePlayerStandingOn
; In: ESI = slot byte offset, hTilePlayerStandingOn set by UpdateNonPlayerSprite.
; Clobbers AL.
; ---------------------------------------------------------------------------
UpdateSpriteImage:
    mov al, [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_ANIMFRAMECOUNTER]
    add al, [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_FACINGDIRECTION]
    add al, [ebp + H_TILE_PLAYER_STANDING_ON]
    mov [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_IMAGEINDEX], al
    ret

; ---------------------------------------------------------------------------
; UpdatePlayerSprite — set the player's facing/image index and walk animation.
; Pret ref: engine/overworld/movement.asm:UpdatePlayerSprite.
;
; Omissions vs pret: DetectCollisionBetweenSprites is a stub (no NPCs yet), and
; the spinning-tile path is inert (wMovementFlags stays 0). Everything else
; (text-box detection, facing from wPlayerMovingDirection, the moving vs.
; standing animation, and grass priority) is faithful.
; ---------------------------------------------------------------------------
UpdatePlayerSprite:
    ; walk-animation counter (data2+0): nonzero locks the sprite hidden
    mov al, [ebp + W_SPRITE_PLAYER_WALK_ANIM_COUNTER]
    test al, al
    jz .checkTextBox
    cmp al, 0xFF
    je .disable
    dec al
    mov [ebp + W_SPRITE_PLAYER_WALK_ANIM_COUNTER], al
    jmp .disable

.checkTextBox:
    ; lower-left BG tile the sprite stands on (coord 20,13); >= $60 → text box
    mov al, [ebp + W_TILEMAP + 13 * SCREEN_TILES_W + 20]
    mov [ebp + H_TILE_PLAYER_STANDING_ON], al
    cmp al, MAP_TILESET_SIZE
    jb .lowerLeftIsMapTile
.disable:
    mov byte [ebp + W_SPRITE_PLAYER_IMAGE_INDEX], 0xFF
    ret

.lowerLeftIsMapTile:
    call DetectCollisionBetweenSprites   ; stub (no NPCs)

    mov al, [ebp + W_WALK_COUNTER]
    test al, al
    jnz .moving

    ; standing: derive facing from wPlayerMovingDirection
    mov al, [ebp + W_PLAYER_MOVING_DIRECTION]
    test al, PLAYER_DIR_DOWN
    jz .checkUp
    mov dl, SPRITE_FACING_DOWN
    jmp .setFacing
.checkUp:
    test al, PLAYER_DIR_UP
    jz .checkLeft
    mov dl, SPRITE_FACING_UP
    jmp .setFacing
.checkLeft:
    test al, PLAYER_DIR_LEFT
    jz .checkRight
    mov dl, SPRITE_FACING_LEFT
    jmp .setFacing
.checkRight:
    test al, PLAYER_DIR_RIGHT
    jz .notMoving
    mov dl, SPRITE_FACING_RIGHT
.setFacing:
    mov [ebp + W_SPRITE_PLAYER_FACING_DIR], dl
    ; if the text font is loaded, treat as standing (reload pose only)
    mov al, [ebp + W_FONT_LOADED]
    test al, 1 << BIT_FONT_LOADED
    jz .moving

.notMoving:
    mov byte [ebp + W_SPRITE_PLAYER_INTRA_ANIM], 0
    mov byte [ebp + W_SPRITE_PLAYER_ANIM_FRAME], 0
    call Func_4e32
    jmp .grassPriority

.moving:
    mov al, [ebp + W_MOVEMENT_FLAGS]
    test al, 1 << BIT_SPINNING
    jnz .grassPriority
    call Func_5274
    call Func_4e32

.grassPriority:
    ; under-grass BG priority if the standing tile is the tileset's grass tile
    mov al, [ebp + H_TILE_PLAYER_STANDING_ON]
    mov cl, al
    mov al, [ebp + W_GRASS_TILE]
    cmp al, cl
    mov al, 0
    jne .storeGrass
    mov al, OAM_PRIO
.storeGrass:
    mov [ebp + W_SPRITE_PLAYER_GRASS_PRIORITY], al
    ret

; ---------------------------------------------------------------------------
; Func_4e32 — image index = anim frame counter + facing direction.
; Pret ref: engine/overworld/movement.asm:Func_4e32.
; ---------------------------------------------------------------------------
Func_4e32:
    mov al, [ebp + W_SPRITE_PLAYER_ANIM_FRAME]
    add al, [ebp + W_SPRITE_PLAYER_FACING_DIR]
    mov [ebp + W_SPRITE_PLAYER_IMAGE_INDEX], al
    ret

; ---------------------------------------------------------------------------
; Func_5274 — advance the current sprite's walk-animation counters.
; Pret ref: engine/overworld/movement.asm:Func_5274.
; intra-anim counter ticks 0->3 each call; every 4th tick advances the anim
; frame counter 0->3 (16 ticks = a full 4-frame walk cycle).
; In: hCurrentSpriteOffset = slot byte offset.
; ---------------------------------------------------------------------------
Func_5274:
    movzx eax, byte [ebp + H_CURRENT_SPRITE_OFFSET]
    mov dl, [ebp + eax + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_INTRAANIMFRAMECOUNTER]
    inc dl
    and dl, 0x03
    mov [ebp + eax + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_INTRAANIMFRAMECOUNTER], dl
    jnz .done                            ; ret nz — only roll the frame every 4th tick
    mov dl, [ebp + eax + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_ANIMFRAMECOUNTER]
    inc dl
    and dl, 0x03
    mov [ebp + eax + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_ANIMFRAMECOUNTER], dl
.done:
    ret

; ---------------------------------------------------------------------------
; DetectCollisionBetweenSprites — TODO: sprite-sprite collision (Phase 2 next).
; Pret ref: engine/overworld/sprite_collisions.asm. Stub: with only the player
; slot populated there is nothing to collide with. Clears the player's
; collision-direction byte to keep downstream logic well-defined.
; ---------------------------------------------------------------------------
DetectCollisionBetweenSprites:
    mov byte [ebp + W_SPRITE_STATE_DATA_1 + 0x0C], 0  ; player slot collision dir
    ret
