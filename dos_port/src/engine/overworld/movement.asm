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
; Build: nasm -f coff -I include/ -I . -o movement.o src/engine/overworld/movement.asm

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
; Clobbers AL, CL, EDX, EBX, ECX.
; ---------------------------------------------------------------------------
CheckSpriteAvailability:
    ; IsObjectHidden stub: no toggleable objects yet — always visible.
    mov al, [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_MOVEMENTBYTE1]
    cmp al, WALK
    jb .skipXYVisibility                 ; scripted movement: always show, skip range test
    ; Y range test — DOS 320×200 viewport.
    ; MAPY = actual_tile_y + 4 (origin+4). Player screen y = 96.
    ; Visible range: actual delta ∈ [−6,+6] + 1-tile buffer → MAPY ∈ [wYCoord−3, wYCoord+11].
    ; 32-bit signed comparison prevents byte underflow when wYCoord < 3.
    movzx edx, byte [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_MAPY]
    movzx eax, byte [ebp + W_Y_COORD]
    lea ecx, [eax - 3]
    cmp ecx, edx
    jg  .spriteInvisible                 ; MAPY < wYCoord−3 → off top of screen
    lea ecx, [eax + 11]
    cmp ecx, edx
    jl  .spriteInvisible                 ; MAPY > wYCoord+11 → off bottom of screen
    ; X range test — DOS 320×200 viewport.
    ; MAPX = actual_tile_x + 4 (origin+4). Player screen x = 160.
    ; Visible range: actual delta ∈ [−10,+9] + 1-tile buffer → MAPX ∈ [wXCoord−7, wXCoord+14].
    movzx edx, byte [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_MAPX]
    movzx eax, byte [ebp + W_X_COORD]
    lea ecx, [eax - 7]
    cmp ecx, edx
    jg  .spriteInvisible                 ; MAPX < wXCoord−7 → off left of screen
    lea ecx, [eax + 14]
    cmp ecx, edx
    jl  .spriteInvisible                 ; MAPX > wXCoord+14 → off right of screen
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
    ; DOS W_TILEMAP is shifted by 4 tiles (X and Y) relative to the screen.
    ; Player is at screen (20, 12). In W_TILEMAP this is (24, 16).
    ; Game Boy screen Y=8 maps to W_TILEMAP Y=17 (bottom-left) -> offset = +9
    mov al, [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_YPIXELS]
    add al, 4
    and al, 0xF8
    movsx ecx, al
    sar ecx, 3                           ; ECX = Game Boy screenYtile
    add ecx, 9                           ; ECX = W_TILEMAP Y
    
    ; Game Boy screen X=8 maps to W_TILEMAP X=24 -> offset = +16
    mov al, [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_XPIXELS]
    movsx ebx, al
    sar ebx, 3                           ; EBX = Game Boy screenXtile
    add ebx, 16                          ; EBX = W_TILEMAP X
    
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
    ; lower-left BG tile the sprite stands on; >= $60 → text box
    mov al, [ebp + W_TILEMAP + PLAYER_STANDING_ROW * SCREEN_TILES_W + PLAYER_STANDING_COL]
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
; SetSpriteCollisionValues
; Pret ref: engine/overworld/sprite_collisions.asm:SetSpriteCollisionValues
; In:  AL = step vector (0x00=standing, 0x01=moving+, 0xFF=moving-)
; Out: BL = pixel bias (0x00 or 0xFF); CL = nibble bias (0x00, 0x07, or 0x09)
; Clobbers: AL, BL, CL
; ---------------------------------------------------------------------------
SetSpriteCollisionValues:
    test al, al
    jz   .zero
    mov  cl, 9
    cmp  al, 0xFF
    je   .setbl            ; step=-1 → BL=0xFF, CL=9
    mov  cl, 7
    xor  al, al            ; step=+1 → BL=0, CL=7
.setbl:
    mov  bl, al
    ret
.zero:
    xor  bl, bl
    xor  cl, cl
    ret

; ---------------------------------------------------------------------------
; DetectCollisionBetweenSprites
; Pret ref: engine/overworld/sprite_collisions.asm:DetectCollisionBetweenSprites
; Reads H_CURRENT_SPRITE_OFFSET to identify sprite i (current slot). Loops all
; 16 slots j, writing YADJUSTED/XADJUSTED/COLLISIONDATA/COLLISIONBITMAP into
; sprite i's SPRITESTATEDATA1. No-op when all NPC PictureIDs are 0 (every j
; exits at the "slot unused" check), so this is safe to call before NPCs exist.
; All registers clobbered; caller (UpdateSprites) wraps with pushad/popad.
; ---------------------------------------------------------------------------
DetectCollisionBetweenSprites:
    push ebx
    push ecx
    push edx
    push esi
    push edi
    sub  esp, 12        ; [esp+0]=adj_dist, [esp+4]=thr_i_y, [esp+8]=thr_i_x

    ; ESI = base of sprite i's data1
    movzx esi, byte [ebp + H_CURRENT_SPRITE_OFFSET]
    add   esi, W_SPRITE_STATE_DATA_1

    ; Return early if slot i is unused
    mov   al, byte [ebp + esi + SPRITESTATEDATA1_PICTUREID]
    test  al, al
    jz    .done

    ; Compute i.YAdj = (YPixels+4+B)&0xF0 | C
    movzx eax, byte [ebp + esi + SPRITESTATEDATA1_YSTEPVECTOR]
    call  SetSpriteCollisionValues
    movzx eax, byte [ebp + esi + SPRITESTATEDATA1_YPIXELS]
    add   al, 4
    add   al, bl
    and   al, 0xF0
    or    al, cl
    mov   byte [ebp + esi + SPRITESTATEDATA1_YADJUSTED], al

    ; Compute i.XAdj = (XPixels+B)&0xF0 | C
    movzx eax, byte [ebp + esi + SPRITESTATEDATA1_XSTEPVECTOR]
    call  SetSpriteCollisionValues
    movzx eax, byte [ebp + esi + SPRITESTATEDATA1_XPIXELS]
    add   al, bl
    and   al, 0xF0
    or    al, cl
    mov   byte [ebp + esi + SPRITESTATEDATA1_XADJUSTED], al

    ; Clear COLLISIONDATA and the three bytes that follow (0x0C–0x0F)
    mov  dword [ebp + esi + SPRITESTATEDATA1_COLLISIONDATA], 0

    xor  edx, edx           ; DL=j=0; DH=direction accumulator (reset each j)

.loop_j:
    xor  dh, dh

    ; EDI = base of sprite j's data1  (j * 0x10 + W_SPRITE_STATE_DATA_1)
    movzx edi, dl
    shl   edi, 4
    add   edi, W_SPRITE_STATE_DATA_1

    ; Skip if j == i
    cmp   edi, esi
    je    .next_j

    ; Skip if j's slot is unused
    mov   al, byte [ebp + edi + SPRITESTATEDATA1_PICTUREID]
    test  al, al
    jz    .next_j

    ; Skip if j is offscreen (IMAGEINDEX == 0xFF)
    movzx eax, byte [ebp + edi + SPRITESTATEDATA1_IMAGEINDEX]
    cmp   al, 0xFF
    je    .next_j

    ; --- Y axis ---
    ; Compute j.YAdj = (j.YPixels+4+B)&0xF0 | C
    movzx eax, byte [ebp + edi + SPRITESTATEDATA1_YSTEPVECTOR]
    call  SetSpriteCollisionValues
    movzx eax, byte [ebp + edi + SPRITESTATEDATA1_YPIXELS]
    add   al, 4
    add   al, bl
    and   al, 0xF0
    or    al, cl               ; AL = j.YAdj

    ; |j.YAdj - i.YAdj|; CF = (j.YAdj < i.YAdj) preserved through negate
    sub   al, byte [ebp + esi + SPRITESTATEDATA1_YADJUSTED]
    jnc   .y_pos
    not   al
    inc   al                   ; abs(); x86 inc/not don't touch CF
.y_pos:
    ; Accumulate Y direction into DH[1:0].
    ; SM83: push af; rl c; pop af; ccf; rl c — x86 equivalent via setc/shl/or:
    ; DH[1]=CF (i.Y>j.Y → 1), DH[0]=!CF (j.Y>=i.Y → 1).
    setc  ch
    shl   dh, 1
    or    dh, ch
    shl   dh, 1
    xor   ch, 1
    or    dh, ch               ; DH[1:0] = CF_y : !CF_y

    ; threshold_i_y: low nibble of i.YAdj == 0 → 7, else 9
    mov   ch, byte [ebp + esi + SPRITESTATEDATA1_YADJUSTED]
    and   ch, 0x0F
    mov   bl, 7
    jz    .tiy_done
    mov   bl, 9
.tiy_done:
    sub   al, bl               ; AL = |diffY| - thr_i_y
    mov   byte [esp + 0], al   ; adj_dist = |diffY| - thr_i_y
    mov   byte [esp + 4], bl   ; save thr_i_y for direction axis selection
    jc    .check_x             ; |diffY| < thr_i_y: Y axis clear, check X

    ; Check j's Y threshold (j's step vector determines 7 or 9)
    movzx eax, byte [ebp + edi + SPRITESTATEDATA1_YSTEPVECTOR]
    test  al, al
    mov   bl, 7
    jz    .tjy_done
    mov   bl, 9
.tjy_done:
    mov   al, byte [esp + 0]   ; adj_dist
    sub   al, bl
    jz    .check_x             ; exactly 0: border collision, still check X
    jnc   .next_j              ; > 0: too far apart

.check_x:
    ; --- X axis ---
    movzx eax, byte [ebp + edi + SPRITESTATEDATA1_XSTEPVECTOR]
    call  SetSpriteCollisionValues
    movzx eax, byte [ebp + edi + SPRITESTATEDATA1_XPIXELS]
    add   al, bl
    and   al, 0xF0
    or    al, cl               ; AL = j.XAdj

    sub   al, byte [ebp + esi + SPRITESTATEDATA1_XADJUSTED]
    jnc   .x_pos
    not   al
    inc   al
.x_pos:
    setc  ch
    shl   dh, 1
    or    dh, ch
    shl   dh, 1
    xor   ch, 1
    or    dh, ch               ; DH[3:2] = CF_x : !CF_x

    mov   ch, byte [ebp + esi + SPRITESTATEDATA1_XADJUSTED]
    and   ch, 0x0F
    mov   bl, 7
    jz    .tix_done
    mov   bl, 9
.tix_done:
    sub   al, bl
    mov   byte [esp + 0], al
    mov   byte [esp + 8], bl   ; save thr_i_x
    jc    .collision

    movzx eax, byte [ebp + edi + SPRITESTATEDATA1_XSTEPVECTOR]
    test  al, al
    mov   bl, 7
    jz    .tjx_done
    mov   bl, 9
.tjx_done:
    mov   al, byte [esp + 0]
    sub   al, bl
    jz    .collision
    jnc   .next_j

.collision:
    ; --- Pikachu special case: i==player (slot 0) AND j==pikachu (slot 15) ---
    cmp   esi, W_SPRITE_STATE_DATA_1
    jne   .standard_col
    mov   byte [ebp + W_D433], 0
    cmp   dl, 15
    jne   .standard_col
    ; Pikachu path: set wd433, skip COLLISIONDATA update
    mov   al, byte [esp + 8]   ; thr_i_x
    mov   bl, byte [esp + 4]   ; thr_i_y
    cmp   bl, al               ; thr_i_y vs thr_i_x
    jc    .pika_ybits
    mov   bl, 0x0C             ; thr_i_y >= thr_i_x: select DH[3:2] = X direction
    jmp   .pika_apply
.pika_ybits:
    mov   bl, 0x03             ; thr_i_y < thr_i_x:  select DH[1:0] = Y direction
.pika_apply:
    mov   al, dh
    and   al, bl
    mov   byte [ebp + W_D433], al
    jmp   .update_bitmap

.standard_col:
    ; Select direction bits from DH based on which axis threshold is larger.
    ; Larger threshold → that axis drives the collision direction.
    mov   al, byte [esp + 4]   ; thr_i_y
    mov   bl, byte [esp + 8]   ; thr_i_x
    cmp   al, bl
    jc    .use_ybits
    mov   bl, 0x0C             ; thr_i_y >= thr_i_x → X bits DH[3:2]
    jmp   .apply_col
.use_ybits:
    mov   bl, 0x03             ; thr_i_y < thr_i_x  → Y bits DH[1:0]
.apply_col:
    mov   al, dh
    and   al, bl
    or    al, byte [ebp + esi + SPRITESTATEDATA1_COLLISIONDATA]
    mov   byte [ebp + esi + SPRITESTATEDATA1_COLLISIONDATA], al

.update_bitmap:
    ; Set bit j in the 16-bit collision bitmap at [0x0E:0x0F] (MSB:LSB).
    ; Slots 0–7 → bit in LO byte (0x0F); slots 8–15 → bit in HI byte (0x0E).
    mov   cl, dl
    and   cl, 0x07
    mov   al, 1
    shl   al, cl               ; AL = 1 << (j & 7)
    test  dl, 0x08
    jnz   .bit_hi
    or    byte [ebp + esi + SPRITESTATEDATA1_COLLISIONBITMAP_LO], al
    jmp   .next_j
.bit_hi:
    or    byte [ebp + esi + SPRITESTATEDATA1_COLLISIONBITMAP_HI], al

.next_j:
    inc   dl
    cmp   dl, 16
    jl    .loop_j

.done:
    add   esp, 12
    pop   edi
    pop   esi
    pop   edx
    pop   ecx
    pop   ebx
    ret
