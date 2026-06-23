; text.asm — PlaceString, TextCommandProcessor, and PrintText.
;
; Source files:  home/text.asm, home/window.asm
; Translated to: x86 NASM, 32-bit protected mode, EBP = GB memory base.
;
; TWO-LEVEL TEXT ENGINE
; ─────────────────────
; Level 1 — TextCommandProcessor (home/text.asm:TextCommandProcessor)
;   Reads a stream of TX_* command bytes. Commands: TX_START writes a string,
;   TX_BOX draws a border, TX_MOVE repositions the cursor, TX_FAR skips a
;   rom-bank reference (flat model: no actual bank switch), TX_END terminates.
;   Register mapping: ESI = command stream ptr (HL), EBX = cursor (BC).
;
; Level 2 — PlaceString (home/text.asm:PlaceString)
;   Renders a '@'-terminated charmap string into the tile buffer.
;   Register mapping: EDX = source ptr (DE, EBP-relative), ESI = cursor (HL),
;   EBX = cursor at terminator on return (BC). EDX points at '@' on return.
;   Control codes $00–$5F are dispatched via the dictionary table.
;
; Inline substitution strings (POKe, TM, PC, …) live in .data (DS-relative)
; and are written by place_flat_str, which bypasses the EBP-relative read.
; By contrast, player/rival names live in WRAM (EBP-relative) and are read
; via the normal [EBP+EDX] mechanism in a local substitution loop.
;
; Build: nasm -f coff -I include/ -I . -o text.o text.asm

bits 32

%include "gb_memmap.inc"
%include "gb_macros.inc"

extern DelayFrame

; ---------------------------------------------------------------------------
; TX_* command bytes (home/macros/scripts/text.asm const_def block)
; ---------------------------------------------------------------------------
TX_START            equ 0x00
TX_RAM              equ 0x01
TX_BCD              equ 0x02
TX_MOVE             equ 0x03
TX_BOX              equ 0x04
TX_LOW              equ 0x05
TX_PROMPT_BUTTON    equ 0x06
TX_SCROLL           equ 0x07
TX_START_ASM        equ 0x08
TX_NUM              equ 0x09
TX_PAUSE            equ 0x0A
TX_SOUND_GET_ITEM_1 equ 0x0B
TX_DOTS             equ 0x0C
TX_WAIT_BUTTON      equ 0x0D
TX_SOUND_PDEX_RATE  equ 0x0E    ; first sound-range command
TX_FAR              equ 0x17
TX_END              equ 0x50    ; text_end / '@' string terminator

; ---------------------------------------------------------------------------
; Charmap control codes ($00–$5F, from constants/charmap.asm)
; ---------------------------------------------------------------------------
CHAR_NULL       equ 0x00   ; <NULL>    debug error
CHAR_PAGE       equ 0x49   ; <PAGE>    Pokedex page break
CHAR_PKMN       equ 0x4A   ; <PKMN>    prints "PK MN"
CHAR_CONT_      equ 0x4B   ; <_CONT>   scroll + pause (_ContText)
CHAR_SCROLL     equ 0x4C   ; <SCROLL>  scroll no pause (_ContTextNoPause)
CHAR_NEXT       equ 0x4E   ; <NEXT>    next line
CHAR_LINE       equ 0x4F   ; <LINE>    second dialogue line
CHAR_TERMINATOR equ 0x50   ; '@'       end of string
CHAR_PARA       equ 0x51   ; <PARA>    paragraph break
CHAR_PLAYER     equ 0x52   ; <PLAYER>  player name
CHAR_RIVAL      equ 0x53   ; <RIVAL>   rival name
CHAR_POKE       equ 0x54   ; '#'       prints "POKe"
CHAR_CONT       equ 0x55   ; <CONT>    scroll + wait
CHAR_DOTS       equ 0x56   ; <...>     six dots ("......")
CHAR_DONE       equ 0x57   ; <DONE>    terminate text engine
CHAR_PROMPT     equ 0x58   ; <PROMPT>  show arrow, wait button
CHAR_TARGET     equ 0x59   ; <TARGET>  battle target name
CHAR_USER       equ 0x5A   ; <USER>    battle user name
CHAR_PC         equ 0x5B   ; <PC>      prints "PC"
CHAR_TM         equ 0x5C   ; <TM>      prints "TM"
CHAR_TRAINER    equ 0x5D   ; <TRAINER> prints "TRAINER"
CHAR_ROCKET     equ 0x5E   ; <ROCKET>  prints "ROCKET"
CHAR_DEXEND     equ 0x5F   ; <DEXEND>  prints "."

CHAR_FIRST_GLYPH equ 0x60  ; first renderable character

SCREEN_W_TILES  equ 20     ; SCREEN_WIDTH in tile units

; Message box geometry (data/text_boxes.asm: MESSAGE_BOX entry = 0,12,19,17)
; Top-left coord(0,12), lower-right coord(19,17): width=20, height=6,
; interior width=18, interior height=4 (B=4, C=18 for TextBoxBorder).
MSG_BOX_ESI     equ W_TILEMAP + 12 * SCREEN_W_TILES   ; tile buf at (0,12)
MSG_BOX_HEIGHT  equ 4      ; interior rows (B)
MSG_BOX_WIDTH   equ 18     ; interior columns (C)
MSG_TEXT_EBX    equ W_TILEMAP + 14 * SCREEN_W_TILES + 1  ; cursor at (1,14)

; Box-drawing tile codes (constants/charmap.asm $79-$7F)
BOX_TL   equ 0x79
BOX_H    equ 0x7A
BOX_TR   equ 0x7B
BOX_V    equ 0x7C
BOX_BL   equ 0x7D
BOX_BR   equ 0x7E
TILE_SPC equ 0x7F   ; space

; PAD bits (from joypad.asm)
PAD_A_BIT   equ 0
PAD_B_BIT   equ 1

; ---------------------------------------------------------------------------
; Exports
; ---------------------------------------------------------------------------
global TextBoxBorder
global PlaceString
global PlaceNextChar
global PrintLetterDelay
global TextCommandProcessor
global PrintText
global PrintText_NoBox

; ---------------------------------------------------------------------------
; External
; ---------------------------------------------------------------------------
extern pad_buttons   ; joypad.asm — button held state (bit 0=A, bit 1=B)

; ---------------------------------------------------------------------------
; .data — inline substitution strings in DS (flat, not EBP-relative).
; These are read by place_flat_str, not through [EBP+n].
; All strings use charmap.asm codes; '$50' = CHAR_TERMINATOR.
; ---------------------------------------------------------------------------
section .data
align 4

; "POKe" for the '#' charmap code ($54)
str_poke:   db 0x8F,0x8E,0x8A,0xBA, CHAR_TERMINATOR  ; P O K e(accent)
; "PC"
str_pc:     db 0x8F,0x82, CHAR_TERMINATOR              ; P C
; "TM"
str_tm:     db 0x93,0x8C, CHAR_TERMINATOR              ; T M
; "TRAINER"
str_trainer: db 0x93,0x91,0x80,0x88,0x8D,0x84,0x91, CHAR_TERMINATOR
; "ROCKET"
str_rocket: db 0x91,0x8E,0x82,0x8A,0x84,0x93, CHAR_TERMINATOR
; "......" (two ellipsis glyphs, charmap $75)
str_dots6:  db 0x75,0x75, CHAR_TERMINATOR
; "<PK><MN>" (charmap $E1, $E2)
str_pkmn:   db 0xE1,0xE2, CHAR_TERMINATOR
; "." for <DEXEND>
str_dot:    db 0xE8, CHAR_TERMINATOR
; "Enemy " (for TARGET/USER fallback context)
str_enemy:  db 0x84,0xAD,0xA4,0xAC,0xB8,0x7F, CHAR_TERMINATOR

; One-byte sentinel used by CHAR_DONE to signal TX_END to TextCommandProcessor
done_sentinel: db TX_END

; ---------------------------------------------------------------------------
; .text
; ---------------------------------------------------------------------------
section .text

; ---------------------------------------------------------------------------
; place_flat_str — write '@'-terminated DS string to tile buffer at ESI.
;
; Reads from EAX (flat DS address), writes glyphs ($60+) to [EBP+ESI].
; Control codes below CHAR_FIRST_GLYPH in the substitution strings are skipped.
; In:  EAX = flat DS ptr to '@'-terminated string
;      ESI = tile buffer write position (EBP-relative)
; Out: EAX advanced past '@', ESI advanced past last written glyph.
;      ECX clobbered.
; ---------------------------------------------------------------------------
place_flat_str:
.loop:
    movzx ecx, byte [eax]
    cmp cl, CHAR_TERMINATOR
    je .done
    cmp cl, CHAR_FIRST_GLYPH
    jb .skip
    mov [ebp + esi], cl
    inc esi
.skip:
    inc eax
    jmp .loop
.done:
    ret

; ---------------------------------------------------------------------------
; TextBoxBorder — draw a BL-wide x BH-tall bordered text box at ESI.
;
; Source: home/text.asm:TextBoxBorder
; In:  ESI = top-left tile-buffer offset (HL, EBP-relative)
;      BL  = interior width (C), BH = interior height (B)
; Out: ESI preserved. EBX preserved (BH/BL unchanged on return).
;      EDI clobbered.
; ---------------------------------------------------------------------------
TextBoxBorder:
    push esi
    push ebx

    movzx ecx, bl       ; ECX = interior width
    movzx edx, bh       ; EDX = interior height (rows of middle)
    lea edi, [ebp + esi]

    ; top row: box_tl + box_h*width + box_tr
    mov byte [edi], BOX_TL
    call .fill_h
    mov byte [edi + ecx + 1], BOX_TR
    add edi, SCREEN_W_TILES

    ; middle rows: box_v + space*width + box_v (EDX times)
.mid:
    mov byte [edi], BOX_V
    push eax
    mov al, TILE_SPC
    call .fill_chars
    pop eax
    mov byte [edi + ecx + 1], BOX_V
    add edi, SCREEN_W_TILES
    dec edx
    jnz .mid

    ; bottom row: box_bl + box_h*width + box_br
    mov byte [edi], BOX_BL
    call .fill_h
    mov byte [edi + ecx + 1], BOX_BR

    pop ebx
    pop esi
    ret

.fill_h:
    push eax
    mov al, BOX_H
    call .fill_chars
    pop eax
    ret

; Fill ECX copies of AL starting at [edi+1]. Preserves EDI and ECX.
.fill_chars:
    push ecx
    push edi
    inc edi
.fc_loop:
    mov [edi], al
    inc edi
    dec ecx
    jnz .fc_loop
    pop edi
    pop ecx
    ret

; ---------------------------------------------------------------------------
; PrintLetterDelay — wait per-character delay based on the text speed setting.
; Pret ref: home/print_text.asm:PrintLetterDelay.
;
; Reads delay frame count from wOptions bits 3-0 (TEXT_DELAY_FAST/MEDIUM/SLOW = 1/3/5).
; Exits early if A or B is held. No-op if BIT_TEXT_DELAY is not set in
; wLetterPrintingDelayFlags (TextCommandProcessor sets it) or if BIT_NO_TEXT_DELAY
; is set in wStatusFlags5 (cutscenes, auto-scroll).
; All registers preserved.
; ---------------------------------------------------------------------------
PrintLetterDelay:
    push eax
    push ecx
    movzx eax, byte [ebp + W_STATUS_FLAGS_5]
    test al, (1 << BIT_NO_TEXT_DELAY)          ; cutscene/auto-scroll: skip delay
    jnz .done
    movzx eax, byte [ebp + W_LETTER_PRINTING_DELAY]
    test al, (1 << BIT_TEXT_DELAY)             ; delay enabled by TextCommandProcessor?
    jz .done
    movzx ecx, byte [ebp + H_JOY_HELD]
    test cl, PAD_A | PAD_B
    jnz .one_frame                             ; button held: skip to one-frame exit
    test al, (1 << BIT_FAST_TEXT_DELAY)        ; use wOptions speed or fixed 1-frame?
    jz .one_frame
    movzx ecx, byte [ebp + W_OPTIONS]
    and cl, TEXT_DELAY_MASK                    ; isolate speed bits (1, 3, or 5)
    jz .done                                   ; speed 0: instant (not used in practice)
    jmp .count_down
.one_frame:
    mov cl, 1
.count_down:
    call DelayFrame                            ; renders frame + updates H_JOY_HELD
    movzx eax, byte [ebp + H_JOY_HELD]
    test al, PAD_A | PAD_B
    jnz .done                                  ; button held: abort remaining delay
    dec cl
    jnz .count_down
.done:
    pop ecx
    pop eax
    ret

; ---------------------------------------------------------------------------
; manual_text_scroll — copy current dialog box to window layer and wait for A/B.
;
; Copies wTileMap rows 12-17 (6 rows × 20 tiles) to GB_TILEMAP1 rows 0-5, pads
; cols 20-31 with TILE_SPC, sets H_WY=152 / IO_WX=87 so the window renders centered
; then polls until A or B is pressed (release-then-press cycle to avoid sticky input).
; Called at CHAR_PARA, CHAR_CONT, CHAR_DONE control codes inside PlaceString.
; All registers preserved (pushad/popad).
; ---------------------------------------------------------------------------
manual_text_scroll:
    pushad
    ; Copy wTileMap rows 12-17 to GB_TILEMAP1 rows 0-5.
    ; wTileMap rows: 20 tiles wide (SCREEN_W_TILES).
    ; GB_TILEMAP1 rows: 32 tiles wide (TILEMAP_W) — pad cols 20-31 with TILE_SPC.
    mov ecx, 6
    lea esi, [ebp + W_TILEMAP + 12 * SCREEN_W_TILES]
    lea edi, [ebp + GB_TILEMAP1]
.copy_row:
    push ecx
    push edi
    mov ecx, SCREEN_W_TILES
    rep movsb
    mov al, TILE_SPC
    mov ecx, TILEMAP_W - SCREEN_W_TILES     ; 12 filler tiles
    rep stosb
    pop edi
    pop ecx
    add edi, TILEMAP_W                      ; next GB_TILEMAP1 row
    dec ecx
    jnz .copy_row
    ; Enable window at bottom of 320×200 viewport; center 160px box in 320px width.
    mov byte [ebp + H_WY], 152
    mov byte [ebp + IO_WX], 87            ; WX-7=80 → x=80..239 centers 160px in 320px
    ; Release cycle: wait until A/B is no longer held (avoids re-triggering on held button).
.mts_release:
    call DelayFrame
    test byte [ebp + H_JOY_HELD], PAD_A | PAD_B
    jnz .mts_release
    ; Press cycle: wait for A or B press.
.mts_press:
    call DelayFrame
    test byte [ebp + H_JOY_HELD], PAD_A | PAD_B
    jz .mts_press
    popad
    ret

; ---------------------------------------------------------------------------
; scroll_text_up — stub for ScrollTextUpOneLine.
; Phase 2: no-op (no visual scroll).
; ---------------------------------------------------------------------------
scroll_text_up:
    ret

; ---------------------------------------------------------------------------
; PlaceString — render '@'-terminated charmap string at tile buffer position.
;
; Source: home/text.asm:PlaceString / PlaceNextChar
; In:  EDX = source string (EBP-relative, DE)
;      ESI = tile buffer write position (EBP-relative, HL)
; Out: EBX = tile buf position at '@' terminator (BC)
;      ESI = restored to line start (HL restored by pop on return)
;      EDX = pointing at '@' terminator
;      EAX clobbered
; ---------------------------------------------------------------------------
PlaceString:
    push esi                    ; SM83: push hl (save line start)

PlaceNextChar:
    movzx eax, byte [ebp + edx]

    ; --- Terminator '@' ($50) ---
    cmp al, CHAR_TERMINATOR
    jne .not_term
    mov ebx, esi               ; BC = current cursor
    pop esi                    ; restore HL = line start
    ret

    ; --- <NEXT> ($4E): advance one or two rows ---
.not_term:
    cmp al, CHAR_NEXT
    jne .not_next
    pop esi                    ; restore line start
    add esi, SCREEN_W_TILES    ; +1 row
    test byte [ebp + H_UI_LAYOUT_FLAGS], 1 << BIT_SINGLE_SPACED_LINES
    jnz .next_push
    add esi, SCREEN_W_TILES    ; double-spaced: +2 rows total
.next_push:
    push esi
    jmp .advance

    ; --- <LINE> ($4F): cursor to (1,16) ---
.not_next:
    cmp al, CHAR_LINE
    jne .not_line
    pop esi
    mov esi, W_TILEMAP + 16 * SCREEN_W_TILES + 1
    push esi
    jmp .advance

    ; --- Control codes $00–$5F (excluding $4E/$4F/$50 already handled) ---
.not_line:
    cmp al, CHAR_FIRST_GLYPH
    jae .glyph                 ; $60+ = renderable glyph

    ; Dispatch control codes
    cmp al, CHAR_NULL
    je .handle_null            ; $00
    cmp al, CHAR_PAGE
    je .handle_stub            ; $49 — page break (stub)
    cmp al, CHAR_PKMN
    je .handle_pkmn            ; $4A
    cmp al, CHAR_CONT_
    je .handle_scroll_cont     ; $4B — _ContText (stub)
    cmp al, CHAR_SCROLL
    je .handle_scroll_cont     ; $4C — _ContTextNoPause (stub)
    cmp al, CHAR_PARA
    je .handle_para            ; $51
    cmp al, CHAR_PLAYER
    je .handle_player          ; $52
    cmp al, CHAR_RIVAL
    je .handle_rival           ; $53
    cmp al, CHAR_POKE
    je .handle_poke            ; $54
    cmp al, CHAR_CONT
    je .handle_cont            ; $55
    cmp al, CHAR_DOTS
    je .handle_dots6           ; $56
    cmp al, CHAR_DONE
    je .handle_done            ; $57
    cmp al, CHAR_PROMPT
    je .handle_prompt          ; $58
    ; $59 TARGET, $5A USER: battle-engine stubs
    cmp al, CHAR_PC
    je .handle_pc              ; $5B
    cmp al, CHAR_TM
    je .handle_tm              ; $5C
    cmp al, CHAR_TRAINER
    je .handle_trainer         ; $5D
    cmp al, CHAR_ROCKET
    je .handle_rocket          ; $5E
    cmp al, CHAR_DEXEND
    je .handle_dexend          ; $5F
    jmp .advance               ; unknown control code: skip

    ; --- Renderable glyph ---
.glyph:
    mov [ebp + esi], al
    inc esi
    call PrintLetterDelay
    jmp .advance

.advance:
    inc edx
    jmp PlaceNextChar

; ── Control code handlers ──────────────────────────────────────────────────

.handle_null:
    ; <NULL> ($00): debug error terminator — stop silently
    mov ebx, esi
    pop esi
    ret

.handle_stub:
    ; <PAGE> ($49): complex scroll/page — stub, just advance
    jmp .advance

.handle_pkmn:
    ; <PKMN> ($4A): prints "PK MN" glyphs ($E1,$E2)
    push eax
    mov eax, str_pkmn
    call place_flat_str
    pop eax
    jmp .advance

.handle_scroll_cont:
    ; <_CONT>/$4B and <SCROLL>/$4C: scroll text up two lines (stub)
    call scroll_text_up
    call scroll_text_up
    pop esi
    mov esi, W_TILEMAP + 16 * SCREEN_W_TILES + 1
    push esi
    jmp .advance

.handle_para:
    ; <PARA> ($51): paragraph break — clear text area, position at (1,14).
    ; Full implementation needs ClearScreenArea + DelayFrames + manual scroll.
    ; Phase 2 stub: just reposition cursor to dialogue line start.
    call manual_text_scroll
    pop esi
    mov esi, W_TILEMAP + 14 * SCREEN_W_TILES + 1
    push esi
    jmp .advance

.handle_player:
    ; <PLAYER> ($52): insert player name from wPlayerName (EBP+W_PLAYER_NAME)
    push edx
    mov edx, W_PLAYER_NAME
.player_loop:
    movzx eax, byte [ebp + edx]
    cmp al, CHAR_TERMINATOR
    je .player_done
    cmp al, CHAR_FIRST_GLYPH
    jb .player_next
    mov [ebp + esi], al
    inc esi
.player_next:
    inc edx
    jmp .player_loop
.player_done:
    pop edx
    jmp .advance

.handle_rival:
    ; <RIVAL> ($53): insert rival name from wRivalName (EBP+W_RIVAL_NAME)
    push edx
    mov edx, W_RIVAL_NAME
.rival_loop:
    movzx eax, byte [ebp + edx]
    cmp al, CHAR_TERMINATOR
    je .rival_done
    cmp al, CHAR_FIRST_GLYPH
    jb .rival_next
    mov [ebp + esi], al
    inc esi
.rival_next:
    inc edx
    jmp .rival_loop
.rival_done:
    pop edx
    jmp .advance

.handle_poke:
    ; '#' ($54): prints "POKe"
    push eax
    mov eax, str_poke
    call place_flat_str
    pop eax
    jmp .advance

.handle_cont:
    ; <CONT> ($55): ContText — scroll two lines, reposition at (1,16)
    call manual_text_scroll
    call scroll_text_up
    call scroll_text_up
    pop esi
    mov esi, W_TILEMAP + 16 * SCREEN_W_TILES + 1
    push esi
    jmp .advance

.handle_dots6:
    ; <......> ($56): prints "......"
    push eax
    mov eax, str_dots6
    call place_flat_str
    pop eax
    jmp .advance

.handle_done:
    ; <DONE> ($57): end the text command stream.
    ; Restores the PlaceString stack frame and points EDX at a TX_END sentinel
    ; so TextCommandProcessor exits on the next iteration.
    pop esi                         ; restore line start
    mov edx, done_sentinel          ; EDX = flat ptr to TX_END byte
    ; EBX = cursor (unchanged: wherever the last glyph landed)
    ; Return to TextCommandProcessor via a normal PlaceString return path,
    ; but with EDX = flat address (not EBP-relative).
    ; TextCommandProcessor checks EDX for the TX_END byte via [ebp+esi] —
    ; to handle this correctly, we set ESI = done_sentinel - ebp so that
    ; [ebp+esi] == done_sentinel[0] == TX_END.
    ; Simpler: we just RET from PlaceString and let TextCommandProcessor
    ; use the .done_text flag below. But the cleanest approach is to set
    ; EDX in a way .cmd_start will read TX_END next.
    ; Phase 2 choice: use a well-known EBP-relative address for the sentinel.
    ; We store TX_END at [EBP + CHAR_DONE_SENTINEL_OFS].
    ; For now, RET from PlaceString; TextCommandProcessor will get TX_END
    ; via the sentinel byte at DONE_SENTINEL_WRAM (set up by text_engine_init).
    ; Since we pop esi above, EBX holds the cursor, EDX is tricky.
    ; Pragmatic Phase 2 solution: the caller (TextCommandProcessor .cmd_start)
    ; will read EDX+1 as the next stream position. We set EDX so that
    ; [ebp + (EDX+1)] is not valid and TextCommandProcessor terminates.
    ; The cleanest way is: set ESI = done_sentinel_wram (EBP-relative) so
    ; TextCommandProcessor reads TX_END from there. But we've already returned
    ; from PlaceString by the time TextCommandProcessor uses ESI.
    ;
    ; Correct solution: do NOT return from PlaceString here. Instead, jump
    ; directly into TextCommandProcessor's .done label. This requires exporting
    ; or forward-referencing .done. Use a shared label trick:
    ; We set a global flag [text_engine_done] = 1 and return normally,
    ; then check the flag in TextCommandProcessor after PlaceString returns.
    ;
    ; Simplest correct implementation: place TX_END in a scratch WRAM byte,
    ; set EDX = that WRAM offset, and return normally. TextCommandProcessor
    ; reads EDX as the next stream start, but EDX is a string position used
    ; only by PlaceString — it's irrelevant once PlaceString returns.
    ;
    ; Actually: TextCommandProcessor .cmd_start sets ESI = EDX + 1 (past '@').
    ; If we make EDX = done_sentinel_wram (EBP-relative, pointing at TX_END),
    ; then ESI = done_sentinel_wram + 1, and the next .next_cmd reads
    ; [ebp + done_sentinel_wram + 1] = garbage. That's wrong too.
    ;
    ; FINAL correct approach: store TX_END at DONE_SENTINEL_WRAM and at
    ; DONE_SENTINEL_WRAM+1, making both bytes TX_END. Set EDX = DONE_SENTINEL_WRAM.
    ; Then .cmd_start does mov esi, EDX; inc esi → esi = DONE_SENTINEL_WRAM+1,
    ; and .next_cmd reads [ebp + DONE_SENTINEL_WRAM+1] = TX_END → done. ✓
    ;
    ; This is set up by text_engine_init (called once at startup).
    mov edx, DONE_SENTINEL_WRAM
    ret

.handle_prompt:
    ; <PROMPT> ($58): show down-arrow and wait for A or B button.
    ; Phase 2 stub: just continue (no blocking wait).
    call manual_text_scroll
    jmp .advance

.handle_pc:
    push eax
    mov eax, str_pc
    call place_flat_str
    pop eax
    jmp .advance

.handle_tm:
    push eax
    mov eax, str_tm
    call place_flat_str
    pop eax
    jmp .advance

.handle_trainer:
    push eax
    mov eax, str_trainer
    call place_flat_str
    pop eax
    jmp .advance

.handle_rocket:
    push eax
    mov eax, str_rocket
    call place_flat_str
    pop eax
    jmp .advance

.handle_dexend:
    ; <DEXEND> ($5F): prints "." and terminates PlaceString
    push eax
    mov eax, str_dot
    call place_flat_str
    pop eax
    mov ebx, esi
    pop esi
    ret

; ---------------------------------------------------------------------------
; text_engine_init — write TX_END sentinel to GB memory for CHAR_DONE.
;
; Must be called once at startup after EBP is established.
; Writes two TX_END bytes at DONE_SENTINEL_WRAM so <DONE> terminates cleanly.
; In:  EBP = GB memory base.
; Out: all registers preserved.
; ---------------------------------------------------------------------------
DONE_SENTINEL_WRAM  equ GB_WRAM0 + 0x0F0   ; two bytes reserved for <DONE> sentinel

global text_engine_init

text_engine_init:
    push eax
    mov al, TX_END
    mov byte [ebp + DONE_SENTINEL_WRAM],     al
    mov byte [ebp + DONE_SENTINEL_WRAM + 1], al
    pop eax
    ret

; ---------------------------------------------------------------------------
; TextCommandProcessor — execute a TX_* command stream.
;
; Source: home/text.asm:TextCommandProcessor / NextTextCommand
; In:  ESI = command stream ptr (HL, EBP-relative)
;      EBX = tile buffer cursor (BC, EBP-relative)
; Out: ESI = past the TX_END byte
;      EBX = cursor at last position written
; Clobbers: EAX, ECX, EDX.
; ---------------------------------------------------------------------------
TextCommandProcessor:
    push eax
    push ecx
    push edx
    ; Pret ref: home/text.asm:TextCommandProcessor — save delay flags, enable delay.
    ; PrintLetterDelay gates on BIT_TEXT_DELAY; TextCommandProcessor sets it for the
    ; duration of this text session and restores the original value at TX_END.
    movzx eax, byte [ebp + W_LETTER_PRINTING_DELAY]
    push eax                                    ; save original wLetterPrintingDelayFlags
    or al, (1 << BIT_TEXT_DELAY)
    mov [ebp + W_LETTER_PRINTING_DELAY], al

.next_cmd:
    movzx eax, byte [ebp + esi]
    inc esi                         ; ESI now points to operands / next command

    cmp al, TX_END                  ; $50
    je .done

    cmp al, TX_FAR                  ; $17: far-bank text — skip 3 bytes in flat model
    je .cmd_far

    cmp al, TX_SOUND_PDEX_RATE      ; $0E+: sound command — no audio yet
    jae .cmd_skip0                  ; zero-byte operand skip

    cmp al, TX_START
    je .cmd_start
    cmp al, TX_RAM
    je .cmd_skip2
    cmp al, TX_BCD
    je .cmd_skip3
    cmp al, TX_MOVE
    je .cmd_move
    cmp al, TX_BOX
    je .cmd_box
    cmp al, TX_LOW
    je .cmd_low
    cmp al, TX_PROMPT_BUTTON
    je .cmd_wait_btn
    cmp al, TX_SCROLL
    je .cmd_scroll
    ; TX_START_ASM ($08): can't translate inline ASM; skip silently
    cmp al, TX_START_ASM
    je .cmd_skip0
    cmp al, TX_NUM
    je .cmd_skip3                   ; skip 2-byte addr + 1 byte format = 3
    cmp al, TX_PAUSE
    je .cmd_skip0
    ; TX_SOUND_GET_ITEM_1 ($0B): TODO-HW: audio
    cmp al, TX_SOUND_GET_ITEM_1
    je .cmd_skip0
    cmp al, TX_DOTS
    je .cmd_skip1                   ; skip 1-byte count
    cmp al, TX_WAIT_BUTTON
    je .cmd_wait_btn
    jmp .next_cmd                   ; unknown command: skip

.done:
    pop eax
    mov [ebp + W_LETTER_PRINTING_DELAY], al    ; restore saved wLetterPrintingDelayFlags
    pop edx
    pop ecx
    pop eax
    ret

; --- TX_START ($00): render '@'-terminated string at cursor ---
.cmd_start:
    ; ESI = source string (EBP-relative), EBX = cursor
    mov edx, esi        ; EDX (DE) = source string
    mov esi, ebx        ; ESI (HL) = cursor
    call PlaceString
    ; After PlaceString: EBX = cursor at '@', ESI = line start, EDX = ptr to '@'
    mov esi, edx
    inc esi             ; ESI = past '@' = next command
    jmp .next_cmd

; --- TX_FAR ($17): far-bank text. Flat model: just skip bank byte, read inline. ---
.cmd_far:
    ; Operands: addr_lo, addr_hi, bank. In flat model we skip bank (1 byte)
    ; and treat [addr_hi:addr_lo] as an EBP-relative pointer to a nested
    ; command stream. For Phase 2, skip all 3 bytes safely.
    ; TODO: implement inline far-text when ROM data is staged in EBP space.
    add esi, 3
    jmp .next_cmd

; --- TX_MOVE ($03): set cursor to new tile-buffer address ---
.cmd_move:
    movzx ebx, byte [ebp + esi]    ; lo byte of new cursor addr
    inc esi
    movzx ecx, byte [ebp + esi]    ; hi byte
    inc esi
    shl ecx, 8
    or  ebx, ecx                   ; EBX = new cursor (BC in SM83)
    jmp .next_cmd

; --- TX_BOX ($04): draw a text box ---
.cmd_box:
    ; Operands: addr_lo, addr_hi, b_height, c_width
    movzx eax, byte [ebp + esi]    ; lo of tile buf destination
    inc esi
    movzx ecx, byte [ebp + esi]    ; hi
    inc esi
    shl ecx, 8
    or  eax, ecx                   ; EAX = tile buf dest
    movzx ecx, byte [ebp + esi]    ; B = height
    inc esi
    movzx edx, byte [ebp + esi]    ; C = width
    inc esi
    shl ecx, 8
    or  ecx, edx                   ; ECX[15:8]=height, ECX[7:0]=width = EBX for TextBoxBorder
    push esi                        ; save stream ptr
    push ebx                        ; save cursor
    mov esi, eax                    ; ESI = tile buf pos
    mov ebx, ecx                    ; BH = height, BL = width
    call TextBoxBorder
    pop ebx                         ; restore cursor
    pop esi                         ; restore stream ptr
    jmp .next_cmd

; --- TX_LOW ($05): cursor to coord(1,16) ---
.cmd_low:
    mov ebx, W_TILEMAP + 16 * SCREEN_W_TILES + 1
    jmp .next_cmd

; --- TX_PROMPT_BUTTON ($06) / TX_WAIT_BUTTON ($0D): wait for button (stub) ---
.cmd_wait_btn:
    call manual_text_scroll
    jmp .next_cmd

; --- TX_SCROLL ($07): scroll text up two lines ---
.cmd_scroll:
    call scroll_text_up
    call scroll_text_up
    mov ebx, W_TILEMAP + 16 * SCREEN_W_TILES + 1
    jmp .next_cmd

; --- Operand-skip helpers ---
.cmd_skip3:
    inc esi
.cmd_skip2:
    inc esi
.cmd_skip1:
    inc esi
.cmd_skip0:
    jmp .next_cmd

; ---------------------------------------------------------------------------
; PrintText — display a text-command stream in the standard message box.
;
; Source: home/window.asm:PrintText / PrintText_NoCreatingTextBox
; Draws the MESSAGE_BOX border (interior 18×4 at tile coord (0,12)),
; positions the cursor at (1,14), then runs TextCommandProcessor.
;
; In:  ESI = text command stream (HL, EBP-relative)
; Out: ESI = past TX_END. EBX = final cursor. EAX,ECX,EDX clobbered.
; ---------------------------------------------------------------------------
PrintText:
    push esi            ; SM83: push hl

    ; Draw the dialogue box: TextBoxBorder at coord(0,12), 18 wide x 4 tall
    mov esi, MSG_BOX_ESI
    mov bh, MSG_BOX_HEIGHT
    mov bl, MSG_BOX_WIDTH
    call TextBoxBorder  ; preserves ESI and EBX

    pop esi             ; SM83: pop hl — restore command stream ptr

PrintText_NoBox:
    ; SM83: bccoord 1, 14
    mov ebx, MSG_TEXT_EBX
    jmp TextCommandProcessor   ; tail call
