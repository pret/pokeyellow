; sprite_oam.asm — PrepareOAMData: build shadow OAM from sprite state data.
;
; Faithful translation of engine/gfx/sprite_oam.asm:PrepareOAMData (the Yellow
; version), plus GetSpriteScreenXY and Func_4a7b. This replaces the Phase 2
; UpdatePlayerOAM scaffold: instead of hand-writing the player's four OAM
; entries, the engine now iterates all 16 sprite slots in wSpriteStateData1/2,
; looks each visible sprite's pose up in SpriteFacingAndAnimationTable, and
; writes the resulting OBJ entries into wShadowOAM ($C300). The frame pipeline
; (frame.asm DelayFrame) then DMA-copies wShadowOAM into OAM ($FE00) before
; render_sprites composites it.
;
; Only the player slot (0) is populated for now (see overworld.asm), but the
; loop, priority handling, and tile/VRAM-offset logic are the real engine, so
; NPC slots will render as soon as InitMapSprites fills them in.
;
; Sprite state layout (per $10-byte slot):
;   data1+0 picture ID (0 = unused)   data1+2 image index (facing+anim, $ff=hidden)
;   data1+4 Y pixels                  data1+6 X pixels
;   data1+9 facing direction          data2+7 grass priority ($80 bit)
;
; Pret refs: engine/gfx/sprite_oam.asm, data/sprites/facings.asm.
;
; Build: nasm -f coff -I include/ -I . -o sprite_oam.o src/gfx/sprite_oam.asm

bits 32

%include "gb_memmap.inc"
%include "gb_macros.inc"

extern HideSprites
extern spr_dos_sy, spr_dos_sx, spr_oam_valid

global PrepareOAMData

section .bss
dos_base_y_tmp: resd 1      ; per-sprite DOS base Y for extended viewport
dos_base_x_tmp: resd 1      ; per-sprite DOS base X for extended viewport

section .text

; ---------------------------------------------------------------------------
; PrepareOAMData — determine OAM data for visible sprites, write to wShadowOAM.
; Pret ref: engine/gfx/sprite_oam.asm:PrepareOAMData (Yellow).
;
; In:  EBP = GB memory base. Out: wShadowOAM populated. Clobbers caller-saved.
; ---------------------------------------------------------------------------
PrepareOAMData:
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov al, [ebp + W_UPDATE_SPRITES_ENABLED]
    cmp al, 1
    je .updateEnabled
    cmp al, 0xFF                         ; cp -1 / ret nz
    jne .ret
    mov [ebp + W_UPDATE_SPRITES_ENABLED], al    ; stays $ff
    call HideSprites
    jmp .ret

.updateEnabled:
    mov byte [ebp + H_OAM_BUFFER_OFFSET], 0
    xor esi, esi                         ; ESI = current slot byte offset (0,$10,..,$f0)

.spriteLoop:
    mov eax, esi
    mov [ebp + H_SPRITE_OFFSET2], al

    ; picture ID == 0 → slot unused
    mov al, [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_PICTUREID]
    test al, al
    jz .nextSprite

    ; image index; $ff → off-screen (still update adjusted coords, then skip)
    mov al, [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_IMAGEINDEX]
    mov [ebp + W_SAVED_SPRITE_IMAGE_INDEX], al
    cmp al, 0xFF
    jne .visible
    call GetSpriteScreenXY
    jmp .nextSprite

.visible:
    cmp al, 0xA0                         ; unchanging sprite (item ball / boulder)?
    jb .usefacing
    xor al, al                           ; unchanging → table index 0
    jmp .gotIndex
.usefacing:
    and al, 0x0F                         ; facing*4 + anim frame
.gotIndex:
    movzx eax, al
    mov edx, [SpriteFacingAndAnimationTable + eax*4]   ; EDX → facing data block (count byte first)

    ; sprite BG priority = data2 grass-priority bit 7
    mov al, [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_GRASSPRIORITY]
    and al, 0x80
    mov [ebp + H_SPRITE_PRIORITY], al

    call GetSpriteScreenXY

    ; OAM overflow guard: hOAMBufferOffset + count > $a0 → stop (clear rest)
    movzx eax, byte [ebp + H_OAM_BUFFER_OFFSET]
    add al, [edx]
    cmp al, 0xA0
    ja .clearUnused

    ; --- draw the sprite's OAM entries ---
    call Func_4a7b                       ; AL = VRAM base tile from image index
    mov [ebp + W_SAVED_SPRITE_IMAGE_INDEX], al

    ; Compute 32-bit DOS base position for extended 320×200 viewport.
    ; Slot 0 (player): YPIXELS-based (always ≤127, no 8-bit overflow).
    ; Slots 1-15 (NPCs): MAPY/MAPX-based (32-bit, handles full map range).
    test esi, esi
    jnz .dos_base_npc
    movsx eax, byte [ebp + H_SPRITE_SCREEN_Y]
    add eax, 36
    mov [dos_base_y_tmp], eax
    movsx eax, byte [ebp + H_SPRITE_SCREEN_X]
    add eax, 96
    mov [dos_base_x_tmp], eax
    jmp .dos_base_done
.dos_base_npc:
    movsx eax, byte [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_MAPY]
    movsx ecx, byte [ebp + W_Y_COORD]
    sub eax, ecx
    imul eax, 16
    add eax, 32
    mov [dos_base_y_tmp], eax
    movsx eax, byte [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_MAPX]
    movsx ecx, byte [ebp + W_X_COORD]
    sub eax, ecx
    imul eax, 16
    add eax, 96
    mov [dos_base_x_tmp], eax
    ; NPC walk interpolation: if MOVEMENTSTATUS=3 (walking), Func_5349 already advanced
    ; MAPY/MAPX to the destination at walk start. Subtract YSTEP*WALKANIMCOUNTER
    ; to interpolate between source and destination over the 16-frame animation.
    cmp byte [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_MOVEMENTSTATUS], 3
    jne .dos_base_done
    movzx eax, byte [ebp + esi + W_SPRITE_STATE_DATA_2 + SPRITESTATEDATA2_WALKANIMCOUNTER]
    movsx ecx, byte [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_YSTEPVECTOR]
    imul ecx, eax
    sub [dos_base_y_tmp], ecx
    movsx ecx, byte [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_XSTEPVECTOR]
    imul ecx, eax
    sub [dos_base_x_tmp], ecx
.dos_base_done:
    ; Sub-block walk tracking: subtract the player's current walk pixel offset from
    ; NPC dos_base so NPCs scroll in lockstep with the BG during a walk step.
    ; Slot 0 (player) tracks sub-block position via YPIXELS — skip.
    test esi, esi
    jz .no_walk_offset                      ; slot 0 = player
    movzx ecx, byte [ebp + W_WALK_COUNTER]
    test ecx, ecx
    jz .no_walk_offset                      ; not walking
    mov eax, 8
    sub eax, ecx                            ; frames elapsed = 8 - walk_counter
    shl eax, 1                              ; * 2 px/frame
    movsx ecx, byte [ebp + W_SPRITE_PLAYER_Y_STEP_VECTOR]
    imul ecx, eax                           ; walk_offset_y = YSTEP * elapsed * 2
    sub [dos_base_y_tmp], ecx              ; NPC tracks BG vertical scroll
    movsx ecx, byte [ebp + W_SPRITE_PLAYER_X_STEP_VECTOR]
    imul ecx, eax                           ; walk_offset_x = XSTEP * elapsed * 2
    sub [dos_base_x_tmp], ecx             ; NPC tracks BG horizontal scroll
.no_walk_offset:

    movzx edi, byte [ebp + H_OAM_BUFFER_OFFSET]
    add edi, W_SHADOW_OAM                ; EDI = GB offset of shadow-OAM write cursor
    mov ebx, edx                         ; EBX walks the facing data block
    movzx ecx, byte [ebx]                ; entry count
    inc ebx

.tileLoop:
    ; OAM entry index from write cursor: EDI = W_SHADOW_OAM + N*4 at loop top
    mov edx, edi
    sub edx, W_SHADOW_OAM
    shr edx, 2                              ; EDX = OAM entry index 0..39

    ; spr_dos_sy[N] = dos_base_y + signed(tableY)
    movsx eax, byte [ebx]
    add eax, [dos_base_y_tmp]
    mov [spr_dos_sy + edx*4], eax

    ; OAM Y = H_SPRITE_SCREEN_Y + 16 + tableY
    mov al, [ebp + H_SPRITE_SCREEN_Y]
    add al, 0x10
    add al, byte [ebx]
    mov [ebp + edi], al
    inc ebx
    inc edi

    ; spr_dos_sx[N] = dos_base_x + signed(tableX)
    movsx eax, byte [ebx]
    add eax, [dos_base_x_tmp]
    mov [spr_dos_sx + edx*4], eax

    ; OAM X = H_SPRITE_SCREEN_X + 8 + tableX
    mov al, [ebp + H_SPRITE_SCREEN_X]
    add al, 0x08
    add al, byte [ebx]
    mov [ebp + edi], al
    inc ebx
    inc edi
    ; tile = savedImageIndex + tableTile; tiles >= $80 get Pikachu VRAM offset
    mov al, [ebp + W_SAVED_SPRITE_IMAGE_INDEX]
    add al, [ebx]
    cmp al, 0x80
    jb .tileResolved
    add al, [ebp + H_PIKACHU_SPRITE_VRAM_OFFSET]
.tileResolved:
    mov [ebp + edi], al
    inc ebx
    inc edi
    ; attributes
    mov al, [ebx]                        ; table attr byte
    test al, UNDER_GRASS
    jz .skipPriority
    or al, [ebp + H_SPRITE_PRIORITY]     ; OR in the BG-priority bit when under grass
.skipPriority:
    and al, 0xF0                         ; drop engine-internal low bits (UNDER_GRASS/FACING_END)
    test al, OAM_PAL1                    ; bit B_OAM_PAL1 set → CGB high palettes
    jz .obp0
    or al, OAM_HIGH_PALS
.obp0:
    mov [ebp + edi], al
    inc ebx
    inc edi
    dec ecx
    jnz .tileLoop

    ; commit write cursor
    mov eax, edi
    sub eax, W_SHADOW_OAM
    mov [ebp + H_OAM_BUFFER_OFFSET], al

.nextSprite:
    add esi, 0x10
    cmp esi, 0x100
    jne .spriteLoop

.clearUnused:
    ; Clear unused shadow-OAM entries' Y to $a0 (off-screen). Keep the last 4
    ; entries when a ledge-jump / fishing animation owns them.
    mov cl, 0xA0                         ; LOW(wShadowOAMEnd)
    mov al, [ebp + W_MOVEMENT_FLAGS]
    test al, 1 << BIT_LEDGE_OR_FISHING
    jz .clear
    mov cl, 0x90                         ; LOW(wShadowOAMSprite36) — keep 4 entries
.clear:
    movzx eax, byte [ebp + H_OAM_BUFFER_OFFSET]
    cmp al, cl
    jae .ret                             ; ret nc (nothing to clear)
    movzx edi, al
    add edi, W_SHADOW_OAM
.clearLoop:
    mov byte [ebp + edi], 0xA0
    add edi, 4
    mov eax, edi
    sub eax, W_SHADOW_OAM                 ; back to 0-based offset
    cmp al, cl                            ; compare low byte (GB: cp l)
    jne .clearLoop

.ret:
    ; Publish the count of valid OAM entries written this frame.
    ; render_sprites uses this instead of the OAM Y byte to detect active entries
    ; (OAM Y can exceed $A0 due to 8-bit YPIXELS overflow for far NPCs).
    movzx eax, byte [ebp + H_OAM_BUFFER_OFFSET]
    shr eax, 2                          ; byte count / 4 = entry count
    mov [spr_oam_valid], eax
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

; ---------------------------------------------------------------------------
; GetSpriteScreenXY — load the current slot's screen Y/X into hSpriteScreenY/X
; and recompute the adjusted (grid-snapped) Y/X used by collision logic.
; Pret ref: engine/gfx/sprite_oam.asm:GetSpriteScreenXY.
; In: ESI = slot byte offset. Clobbers AL.
; ---------------------------------------------------------------------------
GetSpriteScreenXY:
    mov al, [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_YPIXELS]
    mov [ebp + H_SPRITE_SCREEN_Y], al
    mov al, [ebp + esi + W_SPRITE_STATE_DATA_1 + SPRITESTATEDATA1_XPIXELS]
    mov [ebp + H_SPRITE_SCREEN_X], al
    ; adjusted Y = (Y + 4) & $f0 → data1+$a
    mov al, [ebp + H_SPRITE_SCREEN_Y]
    add al, 4
    and al, 0xF0
    mov [ebp + esi + W_SPRITE_STATE_DATA_1 + 0x0A], al
    ; adjusted X = X & $f0 → data1+$b
    mov al, [ebp + H_SPRITE_SCREEN_X]
    and al, 0xF0
    mov [ebp + esi + W_SPRITE_STATE_DATA_1 + 0x0B], al
    ret

; ---------------------------------------------------------------------------
; Func_4a7b — map the saved image index's high nibble (which sprite) to its
; VRAM base tile (sprite n occupies 12 tiles; sprites $a/$b use only 4).
; Pret ref: engine/gfx/sprite_oam.asm:Func_4a7b.
; In: wSavedSpriteImageIndex. Out: AL = VRAM base tile. Clobbers EAX, ECX.
; ---------------------------------------------------------------------------
Func_4a7b:
    mov al, [ebp + W_SAVED_SPRITE_IMAGE_INDEX]
    ror al, 4                            ; swap a — high nibble = sprite number
    and al, 0x0F
    cmp al, 0x0B
    jne .notFourTileSprite
    mov al, 0x7C                         ; $a*12 + 4
    ret
.notFourTileSprite:
    movzx ecx, al
    imul ecx, ecx, 12
    mov al, cl
    ret

; ---------------------------------------------------------------------------
; SpriteFacingAndAnimationTable — 33 pointers to facing/animation OAM blocks.
; Pret ref: data/sprites/facings.asm. Original is a dw table of 16-bit GB
; addresses; here it is a dd table of absolute label addresses, indexed *4.
;
; Each block: db count, then count × (db Yofs, Xofs, tile, attributes).
; Indices 0-15 are facing*4 + anim frame for overworld sprites $1-$9;
; 16-31 (all StandingDown) are for the immobile sprites $a/$b; 32 is Pikachu.
; ---------------------------------------------------------------------------
section .rodata

SpriteFacingAndAnimationTable:
    dd .StandingDown, .WalkingDown,  .StandingDown, .WalkingDown2   ; facing down
    dd .StandingUp,   .WalkingUp,    .StandingUp,   .WalkingUp2     ; facing up
    dd .StandingLeft, .WalkingLeft,  .StandingLeft, .WalkingLeft    ; facing left
    dd .StandingRight,.WalkingRight, .StandingRight,.WalkingRight   ; facing right
    ; sprites $a/$b (immobile) — every orientation maps to StandingDown
    dd .StandingDown, .StandingDown, .StandingDown, .StandingDown
    dd .StandingDown, .StandingDown, .StandingDown, .StandingDown
    dd .StandingDown, .StandingDown, .StandingDown, .StandingDown
    dd .StandingDown, .StandingDown, .StandingDown, .StandingDown
    dd .SpecialCase                                                 ; Pikachu

.StandingDown:
    db 4
    db  0,  0, 0x00, 0
    db  0,  8, 0x01, 0
    db  8,  0, 0x02, UNDER_GRASS
    db  8,  8, 0x03, UNDER_GRASS | FACING_END
.WalkingDown:
    db 4
    db  0,  0, 0x80, 0
    db  0,  8, 0x81, 0
    db  8,  0, 0x82, UNDER_GRASS
    db  8,  8, 0x83, UNDER_GRASS | FACING_END
.WalkingDown2:
    db 4
    db  0,  8, 0x80, OAM_XFLIP
    db  0,  0, 0x81, OAM_XFLIP
    db  8,  8, 0x82, OAM_XFLIP | UNDER_GRASS
    db  8,  0, 0x83, OAM_XFLIP | UNDER_GRASS | FACING_END
.StandingUp:
    db 4
    db  0,  0, 0x04, 0
    db  0,  8, 0x05, 0
    db  8,  0, 0x06, UNDER_GRASS
    db  8,  8, 0x07, UNDER_GRASS | FACING_END
.WalkingUp:
    db 4
    db  0,  0, 0x84, 0
    db  0,  8, 0x85, 0
    db  8,  0, 0x86, UNDER_GRASS
    db  8,  8, 0x87, UNDER_GRASS | FACING_END
.WalkingUp2:
    db 4
    db  0,  8, 0x84, OAM_XFLIP
    db  0,  0, 0x85, OAM_XFLIP
    db  8,  8, 0x86, OAM_XFLIP | UNDER_GRASS
    db  8,  0, 0x87, OAM_XFLIP | UNDER_GRASS | FACING_END
.StandingLeft:
    db 4
    db  0,  0, 0x08, 0
    db  0,  8, 0x09, 0
    db  8,  0, 0x0A, UNDER_GRASS
    db  8,  8, 0x0B, UNDER_GRASS | FACING_END
.WalkingLeft:
    db 4
    db  0,  0, 0x88, 0
    db  0,  8, 0x89, 0
    db  8,  0, 0x8A, UNDER_GRASS
    db  8,  8, 0x8B, UNDER_GRASS | FACING_END
.StandingRight:
    db 4
    db  0,  8, 0x08, OAM_XFLIP
    db  0,  0, 0x09, OAM_XFLIP
    db  8,  8, 0x0A, OAM_XFLIP | UNDER_GRASS
    db  8,  0, 0x0B, OAM_XFLIP | UNDER_GRASS | FACING_END
.WalkingRight:
    db 4
    db  0,  8, 0x88, OAM_XFLIP
    db  0,  0, 0x89, OAM_XFLIP
    db  8,  8, 0x8A, OAM_XFLIP | UNDER_GRASS
    db  8,  0, 0x8B, OAM_XFLIP | UNDER_GRASS | FACING_END
.SpecialCase:
    db 9
    db -4, -4, 0x00, 0
    db -4,  4, 0x01, 0
    db -4, 12, 0x00, OAM_XFLIP
    db  4, -4, 0x01, 0
    db  4,  4, 0x02, 0
    db  4, 12, 0x01, 0
    db 12, -4, 0x00, OAM_YFLIP | UNDER_GRASS
    db 12,  4, 0x01, UNDER_GRASS
    db 12, 12, 0x00, OAM_YFLIP | OAM_XFLIP | UNDER_GRASS | FACING_END
