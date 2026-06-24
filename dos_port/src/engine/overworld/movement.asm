; movement.asm — UpdateSprites: per-frame sprite state / walk-animation update.
;
; Faithful translation of:
;   home/update_sprites.asm:UpdateSprites
;   engine/overworld/sprite_collisions.asm:_UpdateSprites
;   engine/overworld/movement.asm:UpdatePlayerSprite / UpdateNonPlayerSprite /
;     InitializeSpriteStatus / InitializeSpriteScreenPosition / Func_5033 /
;     CheckSpriteAvailability / GetTileSpriteStandsOn / UpdateSpriteImage /
;     UpdateSpriteMovementDelay / UpdateSpriteInWalkingAnimation / NotYetMoving /
;     TryWalking / CanWalkOntoTile / Func_5337 / Func_5349 /
;     Func_4e32 / Func_5274
;
; UpdateSprites runs once per overworld-loop iteration. It walks all 16 sprite
; slots: slot 0 → UpdatePlayerSprite (facing + walk animation); slots 1-15 →
; UpdateNonPlayerSprite (full NPC walk state machine: delay countdown, 16-frame
; pixel-step animation, direction selection with UP_DOWN/LEFT_RIGHT constraints,
; tile passability + sprite-collision gating). PrepareOAMData (sprite_oam.asm)
; then turns the image indices into shadow-OAM entries each DelayFrame.
;
; Direction constraint is read from SPRITESTATEDATA2_MOVEMENTBYTE2 (offset 0x1),
; replacing pret's wMapSpriteData/wCurSpriteMovement2 indirection.
; Scripted NPC movement (MOVEMENTBYTE1 < WALK) is a stub — not yet implemented.
;
; Build: nasm -f coff -I include/ -I . -o movement.o src/engine/overworld/movement.asm

bits 32

%include "gb_memmap.inc"
%include "gb_macros.inc"

global UpdateSprites
global MakeNPCFacePlayer

extern IsTilePassable
extern Random_

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
; UpdateNonPlayerSprite — full NPC walk state machine.
; Pret ref: engine/overworld/movement.asm:UpdateNPCSprite.
;
; Status dispatch:
;   0 → InitializeSpriteStatus (first-frame init)
;   1 → CheckSpriteAvailability; if visible and player not walking: direction
;       selection → TryWalking (WALK/STAY) or stub (scripted <WALK)
;   2 → UpdateSpriteMovementDelay (countdown to next walk)
;   3 → UpdateSpriteInWalkingAnimation (pixel-step animation)
;
; Direction constraint (wCurSpriteMovement2 in pret) is read directly from
; SPRITESTATEDATA2_MOVEMENTBYTE2 (offset 0x1). Scripted movement is a stub.
;
; ESI is reloaded from hCurrentSpriteOffset at entry (clobbers the loop's ESI;
; the loop re-derives ESI after the call — see _UpdateSprites above).
; All other registers: caller pushad/popad, so free.
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
    jc .ret                              ; CF=1 → invisible

    ; Re-read status after availability check
    mov al, [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_MOVEMENTSTATUS]
    test al, 0x80                        ; BIT_FACE_PLAYER (bit 7): NPC must face player
    jnz .facePlayer                      ; stub: fall through to NotYetMoving

    ; Freeze NPC if text/font is loaded (dialog open)
    mov bl, [ebp + W_FONT_LOADED]
    test bl, 1 << BIT_FONT_LOADED
    jnz .notYetMoving

    cmp al, 2
    je .updateDelay                      ; status 2 → UpdateSpriteMovementDelay
    cmp al, 3
    je .updateWalk                       ; status 3 → UpdateSpriteInWalkingAnimation
    ; status 1: ready to move
    cmp byte [ebp + W_WALK_COUNTER], 0
    jne .ret                             ; player is walking: don't start new NPC step

    call InitializeSpriteScreenPosition  ; snap screen position to map coords

    ; Check movement type
    mov al, [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_MOVEMENTBYTE1]
    inc al
    jz .randomMovement                   ; STAY (0xFF+1=0) → random (always blocked)
    inc al
    jz .randomMovement                   ; WALK (0xFE+1→0xFF+1=0) → random walk
    ; Scripted movement (MOVEMENTBYTE1 < WALK): not yet implemented — skip
    jmp .ret

.updateDelay:
    call UpdateSpriteMovementDelay
    jmp .ret

.updateWalk:
    call UpdateSpriteInWalkingAnimation
    jmp .ret

.facePlayer:
    call MakeNPCFacePlayer
    jmp .ret

.notYetMoving:
    call NotYetMoving
    jmp .ret

.randomMovement:
    ; GetTileSpriteStandsOn clobbers EBX, ECX, AL.
    ; Random_ clobbers AL, BL. Push EBX around Random call.
    call GetTileSpriteStandsOn          ; EBX = wTileMap offset of lower-left tile under NPC
    push ebx                            ; save tile ptr (BL clobbered by Random_)
    call Random                         ; H_RANDOM_ADD updated; AL = random byte
    pop ebx                             ; restore tile ptr
    ; AL = random value; CL = direction constraint
    movzx ecx, byte [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_MOVEMENTBYTE2]

.determineDirection:
    ; Forced single directions: DOWN=0xD0, UP=0xD1, LEFT=0xD2, RIGHT=0xD3
    cmp cl, NPC_DIR_DOWN
    je .moveDown
    cmp cl, NPC_DIR_UP
    je .moveUp
    cmp cl, NPC_DIR_LEFT
    je .moveLeft
    cmp cl, NPC_DIR_RIGHT
    je .moveRight
    ; Random direction from high 2 bits of AL; apply UP_DOWN/LEFT_RIGHT constraints
    cmp al, NPC_MOVEMENT_UP             ; < 0x40 → try down
    jnc .notRandDown
    cmp cl, LEFT_RIGHT
    je .moveLeft                        ; LEFT_RIGHT constraint → go left instead of down
    jmp .moveDown
.notRandDown:
    cmp al, NPC_MOVEMENT_LEFT           ; 0x40-0x7F → try up
    jnc .notRandUp
    cmp cl, LEFT_RIGHT
    je .moveRight                       ; LEFT_RIGHT → right instead of up
    jmp .moveUp
.notRandUp:
    cmp al, NPC_MOVEMENT_RIGHT          ; 0x80-0xBF → try left
    jnc .notRandLeft
    cmp cl, UP_DOWN
    je .moveUp                          ; UP_DOWN → up instead of left
    jmp .moveLeft
.notRandLeft:                           ; 0xC0-0xFF → try right
    cmp cl, UP_DOWN
    je .moveDown                        ; UP_DOWN → down instead of right
    ; fall through to .moveRight

.moveRight:
    add ebx, 2
    mov cl, byte [ebp + ebx]            ; tile ID at destination
    mov bl, 1                           ; direction bit
    mov ch, SPRITE_FACING_RIGHT         ; = 0x0C
    xor dh, dh                          ; Y step = 0
    mov dl, 1                           ; X step = +1
    call TryWalking
    jmp .ret

.moveLeft:
    sub ebx, 2
    mov cl, byte [ebp + ebx]
    mov bl, 2
    mov ch, SPRITE_FACING_LEFT          ; = 0x08
    xor dh, dh
    mov dl, 0xFF                        ; X step = -1
    call TryWalking
    jmp .ret

.moveDown:
    add ebx, 2*SCREEN_WIDTH
    mov cl, byte [ebp + ebx]
    mov bl, 4
    mov ch, SPRITE_FACING_DOWN          ; = 0x00
    mov dh, 1                           ; Y step = +1
    xor dl, dl
    call TryWalking
    jmp .ret

.moveUp:
    sub ebx, 2*SCREEN_WIDTH
    mov cl, byte [ebp + ebx]
    mov bl, 8
    mov ch, SPRITE_FACING_UP            ; = 0x04
    mov dh, 0xFF                        ; Y step = -1
    xor dl, dl
    call TryWalking
    ; fall through to .ret

.ret:
    ret
.initStatus:
    call InitializeSpriteStatus
    ret

; ---------------------------------------------------------------------------
; Random — update H_RANDOM_ADD/H_RANDOM_SUB, return result in AL.
; Pret ref: home/random.asm (calls Random_ from engine/math/random.asm).
; AL = H_RANDOM_ADD after update. Clobbers AL, BL.
; ---------------------------------------------------------------------------
Random:
    call Random_
    mov al, [ebp + H_RANDOM_ADD]
    ret

; ---------------------------------------------------------------------------
; Func_5337 — set FACINGDIRECTION, YSTEPVECTOR, XSTEPVECTOR for NPC slot ESI.
; Pret ref: engine/overworld/movement.asm:Func_5337.
; In: CH = facing direction, DH = Y step (-1/0/+1 as 0xFF/0x00/0x01), DL = X step.
; ---------------------------------------------------------------------------
Func_5337:
    mov [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_FACINGDIRECTION], ch
    mov [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_YSTEPVECTOR], dh
    mov [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_XSTEPVECTOR], dl
    ret

; ---------------------------------------------------------------------------
; Func_5349 — advance MAPY and MAPX by the step vectors at walk start.
; Pret ref: engine/overworld/movement.asm:Func_5349.
; In: DH = Y step, DL = X step, ESI = slot byte offset.
; ---------------------------------------------------------------------------
Func_5349:
    mov al, dh
    add [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_MAPY], al
    mov al, dl
    add [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_MAPX], al
    ret

; ---------------------------------------------------------------------------
; TryWalking — attempt to walk the NPC one metatile in a chosen direction.
; Pret ref: engine/overworld/movement.asm:TryWalking.
;
; In:  CL = tile ID at destination (from wTileMap), BL = direction bit (1/2/4/8),
;      CH = facing direction, DH = Y step, DL = X step, ESI = slot byte offset.
; Out: CF=0 → walk started (WALKANIMCOUNTER=16, MOVEMENTSTATUS=3);
;      CF=1 → blocked (CanWalkOntoTile already set MOVEMENTSTATUS=2, random delay).
; Clobbers: EAX, ECX, EDX (stack-saved around CanWalkOntoTile).
; ---------------------------------------------------------------------------
TryWalking:
    call Func_5337                      ; write facing+step vectors to sprite state
    ; CanWalkOntoTile uses DH/DL (reads but does not modify them).
    ; ESI (slot offset) is preserved by CanWalkOntoTile.
    call CanWalkOntoTile                ; CF=1 → blocked
    jc .ret
    call Func_5349                      ; update MAPY/MAPX to destination (walk start)
    mov byte [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_WALKANIMCOUNTER], 16
    mov byte [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_MOVEMENTSTATUS], 3
    call UpdateSpriteImage
    clc
.ret:
    ret

; ---------------------------------------------------------------------------
; CanWalkOntoTile — passability + sprite-collision check for NPC movement.
; Pret ref: engine/overworld/movement.asm:CanWalkOntoTile.
;
; In:  CL = tile ID at destination, BL = direction bit (1/2/4/8),
;      DH = Y step, DL = X step, ESI = slot byte offset.
; Out: CF=0 → passable; CF=1 → blocked (MOVEMENTSTATUS=2 + random delay set).
; Clobbers: EAX, ECX.  EBX (BL direction bit) and EDX preserved.
; ---------------------------------------------------------------------------
CanWalkOntoTile:
    ; If scripted movement (MOVEMENTBYTE1 < WALK=0xFE), always allow
    mov al, [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_MOVEMENTBYTE1]
    cmp al, WALK
    jnc .checkTile
    clc
    ret

.checkTile:
    push esi                            ; IsTilePassable clobbers ESI
    call IsTilePassable                 ; CL = tile ID; CF=1 if blocked
    pop esi
    jc .impassable

    ; STAY sentinel (MOVEMENTBYTE1 == 0xFF): never actually walk
    mov al, [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_MOVEMENTBYTE1]
    inc al                              ; 0xFF+1=0 (ZF)
    jz .impassable

    ; Y displacement bounds — prevents unlimited north/west roaming from start position.
    ; YDISPLACEMENT starts at 8 (set in InitializeSpriteStatus).
    ; Moving north (DH=0xFF): must have YDISPLACEMENT > 0.
    ; Moving south (DH=0x01): always allowed (Yellow bug-fix: no upper bound).
    movzx eax, byte [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_YDISPLACEMENT]
    test dh, dh
    jz .checkXDisp                      ; DH=0: not moving vertically
    js .moveNorth                       ; DH=0xFF (bit 7 set): moving north
    ; moving south: increment displacement, no upper bound (Yellow fix)
    add al, 1
    mov [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_YDISPLACEMENT], al
    jmp .checkXDisp
.moveNorth:
    sub al, 1                           ; YDISPLACEMENT - 1; CF=1 if was 0 → blocked
    jc .impassable
    mov [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_YDISPLACEMENT], al

.checkXDisp:
    movzx eax, byte [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_XDISPLACEMENT]
    test dl, dl
    jz .detectCollision
    js .moveWest
    ; moving east: always allowed
    add al, 1
    mov [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_XDISPLACEMENT], al
    jmp .detectCollision
.moveWest:
    sub al, 1
    jc .impassable
    mov [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_XDISPLACEMENT], al

.detectCollision:
    ; Run collision detection to populate COLLISIONDATA for direction check.
    ; Must save/restore wUpdateSpritesEnabled (pret pattern).
    movzx eax, byte [ebp + W_UPDATE_SPRITES_ENABLED]
    push eax
    mov byte [ebp + W_UPDATE_SPRITES_ENABLED], 0xFF
    call DetectCollisionBetweenSprites  ; preserves EBX, ECX, EDX, ESI, EDI
    pop eax
    mov [ebp + W_UPDATE_SPRITES_ENABLED], al
    ; BL = direction bit (preserved through DetectCollisionBetweenSprites)
    mov al, [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_COLLISIONDATA]
    test al, bl
    jnz .impassable

    clc
    ret

.impassable:
    ; Set status=2 (delayed), zero step vectors, assign random delay.
    mov byte [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_MOVEMENTSTATUS], 2
    mov byte [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_YSTEPVECTOR], 0
    mov byte [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_XSTEPVECTOR], 0
    call Random                         ; AL = H_RANDOM_ADD (clobbers AL, BL)
    and al, 0x7F                        ; random 0–127 frames
    mov [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_MOVEMENTDELAY], al
    stc
    ret

; ---------------------------------------------------------------------------
; UpdateSpriteMovementDelay — decrement inter-walk delay, transition to status 1.
; Pret ref: engine/overworld/movement.asm:UpdateSpriteMovementDelay.
; In: ESI = slot byte offset. Clobbers AL.
; Falls through to NotYetMoving when ready.
; ---------------------------------------------------------------------------
UpdateSpriteMovementDelay:
    mov al, [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_MOVEMENTBYTE1]
    cmp al, WALK
    jnc .tickCounter                    ; WALK or STAY: decrement counter
    ; Scripted: clear delay immediately → ready to move
    mov byte [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_MOVEMENTDELAY], 0
    jmp .moving

.tickCounter:
    mov al, [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_MOVEMENTDELAY]
    dec al
    mov [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_MOVEMENTDELAY], al
    jnz NotYetMoving                    ; still waiting: freeze animation

.moving:
    mov byte [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_MOVEMENTSTATUS], 1
    ; fall through to NotYetMoving

; ---------------------------------------------------------------------------
; NotYetMoving — reset NPC animation counter and refresh image index.
; Pret ref: engine/overworld/movement.asm:NotYetMoving.
; Called whenever the NPC's visual state needs refreshing but position doesn't change.
; In: ESI = slot byte offset. Clobbers AL.
; ---------------------------------------------------------------------------
NotYetMoving:
    mov byte [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_ANIMFRAMECOUNTER], 0
    call UpdateSpriteImage
    ret

; ---------------------------------------------------------------------------
; MakeNPCFacePlayer — turn NPC at slot ESI to face the player.
; Pret ref: engine/overworld/movement.asm:MakeNPCFacePlayer.
;
; Reads W_SPRITE_PLAYER_FACING_DIR and XORs with 0x04 to invert:
;   DOWN(0x00)↔UP(0x04), LEFT(0x08)↔RIGHT(0x0C).
; Clears BIT_FACE_PLAYER (bit 7) from MOVEMENTSTATUS.
; In: ESI = slot byte offset. All registers preserved.
; ---------------------------------------------------------------------------
MakeNPCFacePlayer:
    push eax
    movzx eax, byte [ebp + W_SPRITE_PLAYER_FACING_DIR]
    xor al, 0x04                ; invert facing direction
    mov [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_FACINGDIRECTION], al
    and byte [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_MOVEMENTSTATUS], ~(1 << BIT_FACE_PLAYER)
    call NotYetMoving           ; reset anim counter and update image index
    pop eax
    ret

; ---------------------------------------------------------------------------
; UpdateSpriteInWalkingAnimation — advance one frame of NPC pixel-step walk.
; Pret ref: engine/overworld/movement.asm:UpdateSpriteInWalkingAnimation.
;
; Per-frame: advance anim counters (Func_5274); YPIXELS+=YSTEP; XPIXELS+=XSTEP;
; decrement WALKANIMCOUNTER. When counter reaches 0:
;   WALK/STAY → random delay (0–127) + status=2; clear step vectors.
;   scripted  → status=1 (ready for next scripted step).
;
; In: ESI = slot byte offset (H_CURRENT_SPRITE_OFFSET set by outer loop).
; Clobbers AL, DL (from Func_5274).
; ---------------------------------------------------------------------------
UpdateSpriteInWalkingAnimation:
    call Func_5274                      ; advance intra-anim and anim-frame counters

    ; YPIXELS += YSTEPVECTOR
    mov al, [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_YSTEPVECTOR]
    add [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_YPIXELS], al

    ; XPIXELS += XSTEPVECTOR
    mov al, [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_XSTEPVECTOR]
    add [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_XPIXELS], al

    ; Decrement walk animation counter; if still > 0, animation continues
    mov al, [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_WALKANIMCOUNTER]
    dec al
    mov [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_WALKANIMCOUNTER], al
    jnz .animRunning

    ; Walk finished: check if random (WALK/STAY) or scripted
    mov al, [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_MOVEMENTBYTE1]
    cmp al, WALK
    jnc .initNextCounter                ; WALK or STAY → random inter-walk delay

    ; Scripted: immediately ready for next scripted step
    mov byte [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_MOVEMENTSTATUS], 1
    ret

.initNextCounter:
    call Random                         ; AL = H_RANDOM_ADD
    and al, 0x7F                        ; random 0–127 frames
    mov [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_MOVEMENTDELAY], al
    mov byte [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_MOVEMENTSTATUS], 2
    mov byte [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_YSTEPVECTOR], 0
    mov byte [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_XSTEPVECTOR], 0
    ret

.animRunning:
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
    ; Y range test — movement-safe wTileMap zone.
    ; GetTileSpriteStandsOn: row = (MAPY-wYCoord)*2+9. wTileMap has 25 rows (0-24).
    ; Movement adds ±2 rows, so feet row must be in [2,22]: MAPY ∈ [wYCoord-3, wYCoord+6].
    ; (Player at PLAYER_STANDING_ROW=17; 4 safe blocks south, 8 safe blocks north.)
    ; 32-bit signed comparison prevents byte underflow when wYCoord < 3.
    movzx edx, byte [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_MAPY]
    movzx eax, byte [ebp + W_Y_COORD]
    lea ecx, [eax - 3]
    cmp ecx, edx
    jg  .spriteInvisible                 ; MAPY < wYCoord-3 → off top / unsafe north
    lea ecx, [eax + 6]
    cmp ecx, edx
    jl  .spriteInvisible                 ; MAPY > wYCoord+6 → unsafe south (out-of-map reads)
    ; X range test — movement-safe wTileMap zone.
    ; col = (MAPX-wXCoord)*2+16. Movement adds ±2 cols, so col must be in [2,37]:
    ; MAPX ∈ [wXCoord-7, wXCoord+10].
    movzx edx, byte [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_MAPX]
    movzx eax, byte [ebp + W_X_COORD]
    lea ecx, [eax - 7]
    cmp ecx, edx
    jg  .spriteInvisible                 ; MAPX < wXCoord-7 → off left / unsafe west
    lea ecx, [eax + 10]
    cmp ecx, edx
    jl  .spriteInvisible                 ; MAPX > wXCoord+10 → unsafe east (out-of-map reads)
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
; Computes the lower-left wTileMap entry of the 2×2 block the NPC occupies.
; Uses MAPY/MAPX (block coordinates) instead of YPIXELS/XPIXELS so the result
; is always correct regardless of when InitializeSpriteScreenPosition last ran.
;
; Formula (derived from MAPY/MAPX with +4 offset vs W_Y_COORD/W_X_COORD):
;   row = (MAPY - W_Y_COORD)*2 + 9    (player foot row=17; MAPY has +4 bias)
;   col = (MAPX - W_X_COORD)*2 + 16   (player foot col=24; MAPX has +4 bias)
;   EBX = W_TILEMAP + row*SCREEN_WIDTH + col
;
; In: ESI = slot byte offset. Out: EBX = wTileMap offset. Clobbers AL, ECX, EBX.
; ---------------------------------------------------------------------------
GetTileSpriteStandsOn:
    movsx ecx, byte [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_MAPY]
    movsx eax, byte [ebp + W_Y_COORD]
    sub ecx, eax                         ; ECX = MAPY - W_Y_COORD (= delta_blocks + 4)
    add ecx, ecx                         ; ECX = (MAPY - W_Y_COORD) * 2
    add ecx, 9                           ; ECX = wTileMap row

    movsx ebx, byte [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_MAPX]
    movsx eax, byte [ebp + W_X_COORD]
    sub ebx, eax                         ; EBX = MAPX - W_X_COORD (= delta_blocks + 4)
    add ebx, ebx                         ; EBX = (MAPX - W_X_COORD) * 2
    add ebx, 16                          ; EBX = wTileMap col

    imul ecx, ecx, SCREEN_WIDTH          ; row * 40
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
; Omissions vs pret: the spinning-tile path is inert (wMovementFlags stays 0).
; Everything else (text-box detection, DetectCollisionBetweenSprites, facing
; from wPlayerMovingDirection, moving vs. standing animation, grass priority)
; is faithful.
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
    call DetectCollisionBetweenSprites

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
