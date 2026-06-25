; frame.asm — DelayFrame / DelayFrames / Delay3 and the per-frame pipeline.
;
; Source: home/vblank.asm:DelayFrame, home/delay.asm:DelayFrames
;
; In the GB, the VBlank ISR handles shadow-register commits, auto-BG transfer,
; and OAM DMA every frame. In the DOS port these are folded into DelayFrame so
; that any call to DelayFrame (the standard "yield one frame" primitive) triggers
; a full render + input update, matching the original VBlank-driven timing.
;
; do_bg_transfer copies the 20×18 wTileMap software buffer into the physical
; 32-wide GB tilemap at the destination set by hAutoBGTransferDest (high byte
; only, low byte always 0). Handles the 1 KB wrap-around boundary so callers
; can set destinations at row 8 ($9900) or row 24 ($9B00) inside tilemap 0.
;
; Build: nasm -f coff -I include/ -o frame.o frame.asm

bits 32

%include "gb_memmap.inc"
%include "gb_macros.inc"

extern wait_vblank
extern wait_pit_tick
extern commit_palette
extern render_bg
extern render_window
extern render_sprites
extern draw_player_marker
extern present
extern joypad_update
extern pad_quit
extern cleanup
extern PrepareOAMData
%ifdef DEBUG_NPC_WALK
extern DumpNpcLog       ; dump NPC walk-decision log to NPCLOG.BIN on quit
%endif

global DelayFrame
global DelayFrames
global Delay3

section .text

; ---------------------------------------------------------------------------
; DelayFrame — sync to 60 Hz, run full per-frame pipeline.
;
; Mirrors what the GB VBlank ISR does:
;   commit shadow registers → auto-BG transfer → redraw exposed row/col
;   → joypad update → BG render → blit → check host-quit
;
; Out: all registers preserved. May call cleanup+exit if Esc was pressed.
; ---------------------------------------------------------------------------
DelayFrame:
    pushad
    call wait_vblank
    call wait_pit_tick
    call commit_shadow_regs
    call commit_palette         ; map BGP/OBP0/OBP1 → DAC (raw-index render)
    call do_bg_transfer
    call update_oam             ; PrepareOAMData → shadow OAM, then DMA to OAM
    call joypad_update
    call render_bg
    call render_sprites         ; composite OAM sprites over BG
    ; DIVERGENCE FROM GB HARDWARE (intentional): on real DMG/CGB, OBJ sprites
    ; draw OVER the window layer, so the GB order is BG → window → sprites. We
    ; deliberately invert that here (window LAST, over sprites) because the
    ; window layer in this port is only ever the bottom dialog/menu box (WY=152),
    ; and that box must occlude NPCs standing under it. The artifact this guards
    ; against is port-specific: our extended 40×25 player-centered viewport shows
    ; far more of the map than the GB's 20×18 screen, exposing NPCs in the bottom
    ; rows that the original camera never placed under the textbox. The player
    ; sprite sits at screen center (well above WY=152), so it is never occluded.
    call render_window          ; composite window layer (textbox/menu) OVER sprites
    call draw_player_marker     ; legacy placeholder (no-op unless explicitly enabled)
    call present
    cmp byte [pad_quit], 0
    je .done
    call cleanup
%ifdef DEBUG_NPC_WALK
    call DumpNpcLog             ; writes NPCLOG.BIN, then exits (never returns)
%endif
    mov ax, 0x4C00
    int 0x21
.done:
    popad
    ret

; ---------------------------------------------------------------------------
; update_oam — build shadow OAM (PrepareOAMData) and DMA it into OAM ($FE00).
;
; Mirrors the GB VBlank ISR steps PrepareOAMData + hDMARoutine. Gated on
; wUpdateSpritesEnabled so non-gameplay screens (e.g. the title, which writes
; its own shadow OAM) are not force-copied into OAM until the overworld enables
; sprite updates. In: EBP = GB memory base. All registers preserved.
; ---------------------------------------------------------------------------
update_oam:
    cmp byte [ebp + W_UPDATE_SPRITES_ENABLED], 1
    jne .done
    call PrepareOAMData
    pushad
    lea esi, [ebp + W_SHADOW_OAM]
    lea edi, [ebp + GB_OAM]
    mov ecx, W_SHADOW_OAM_SIZE
    rep movsb
    popad
.done:
    ret

; ---------------------------------------------------------------------------
; commit_shadow_regs — copy H_SCX/H_SCY/H_WY → IO_SCX/IO_SCY/IO_WY.
; Mirrors the GB VBlank ISR shadow-register commit.
; In: EBP = GB memory base. All registers preserved.
; ---------------------------------------------------------------------------
commit_shadow_regs:
    push eax
    inc byte [ebp + IO_DIV]     ; advance emulated DIV counter (~16384 Hz on GB; 1/frame is enough for RNG entropy)
    mov al, [ebp + H_SCX]
    mov [ebp + IO_SCX], al
    mov al, [ebp + H_SCY]
    mov [ebp + IO_SCY], al
    mov al, [ebp + H_WY]
    mov [ebp + IO_WY], al
    pop eax
    ret

; ---------------------------------------------------------------------------
; do_bg_transfer — copy wTileMap (20×18) into the physical GB tilemap.
;
; Uses hAutoBGTransferDest high byte as the tilemap destination (low byte = 0,
; so the dest is always 256-byte aligned). Copies 20 bytes per screen row,
; skips the 12-byte padding to the next 32-wide tilemap row, and wraps at
; the 1 KB boundary so destinations like $9B00 (row 24) work correctly.
;
; (Stage A Note: Gated on H_AUTO_BG_TRANSFER_EN, which the overworld sets to 0.
; Inert in the overworld now that the native renderer drops the torus, but kept
; because text/menu code may use it later.)
;
; In: EBP = GB memory base. All registers preserved.
; ---------------------------------------------------------------------------
do_bg_transfer:
    pushad
    cmp byte [ebp + H_AUTO_BG_TRANSFER_EN], 0
    je .done

    ; EDI = GB tilemap destination (high byte only, low byte = 0)
    movzx edi, byte [ebp + H_AUTO_BG_TRANSFER_DEST + 1]
    shl edi, 8                        ; edi = GB address (e.g. $9B00)

    ; EAX = flat pointer to the 1 KB tilemap boundary
    mov eax, edi
    and eax, 0xFC00
    add eax, 0x400                    ; eax = GB address of end of this 1 KB tilemap
    add eax, ebp                      ; eax = flat ptr to tilemap end

    add edi, ebp                      ; edi = flat ptr to tilemap dest
    lea esi, [ebp + W_TILEMAP]        ; esi = flat ptr to wTileMap

    mov edx, SCREEN_TILES_H           ; 18 rows
.row:
    mov ecx, SCREEN_TILES_W           ; 20 bytes per row
    rep movsb
    add edi, TILEMAP_W - SCREEN_TILES_W  ; skip 12 padding bytes to next tilemap row
    cmp edi, eax                      ; past end of 1 KB tilemap?
    jb .no_wrap
    sub edi, 0x400                    ; wrap back to tilemap start
.no_wrap:
    dec edx
    jnz .row
.done:
    popad
    ret

; ---------------------------------------------------------------------------
; DelayFrames — wait BL (C register) frames.
; In:  BL = frame count. Out: BL = 0. Other registers preserved.
; ---------------------------------------------------------------------------
DelayFrames:
    test bl, bl
    jz .done
.loop:
    call DelayFrame
    dec bl
    jnz .loop
.done:
    ret

; ---------------------------------------------------------------------------
; Delay3 — wait exactly 3 frames (tail-call into DelayFrames).
; Matches home/delay.asm:Delay3. All registers preserved.
; ---------------------------------------------------------------------------
Delay3:
    push ebx
    mov bl, 3
    call DelayFrames
    pop ebx
    ret
