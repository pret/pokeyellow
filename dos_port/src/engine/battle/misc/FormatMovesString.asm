; ╔══════════════════════════════════════════════════════════╗
; ║              PKMNDOS TRANSLATION MANIFEST               ║
; ╚══════════════════════════════════════════════════════════╝
; queue_id   : 1744
; label      : FormatMovesString
; source     : engine/battle/misc.asm
; category   : simple
; scratch    : dos_port/scratch/1744__FormatMovesString.asm
; -----------------------------------------------------------
; target      : dos_port/src/engine/battle/misc/FormatMovesString.asm
; aggregator  : dos_port/src/engine/battle/misc.asm
; -----------------------------------------------------------
; WORKER NOTES — fill in before calling work_queue complete
; registers   : HL->ESI for move array and name buf, DE->EDX for out string, B->BH
; hflag       : not involved
; bug_tags    : none
; notes       : used EDX for DE ptr; mapped '@' to 0x50, '<NEXT>' to 0x4E based on text.asm
; ╔══════════════════════════════════════════════════════════╗
; ║  CODE BELOW — do not modify the header above            ║
; ╚══════════════════════════════════════════════════════════╝

extern wMoves
extern wMovesString
extern wNameListIndex
extern BANK_MoveNames
extern wPredefBank
extern MOVE_NAME
extern wNameListType
extern GetName
extern wNameBuffer
extern wNumMovesMinusOne
extern NUM_MOVES

global FormatMovesString
section .text

FormatMovesString:
    mov esi, wMoves
    mov edx, wMovesString
    mov bh, 0
.printMoveNameLoop:
    mov al, [ebp + esi]
    inc esi
    test al, al
    jz .printDashLoop
    push esi
    mov [ebp + wNameListIndex], al
    mov eax, BANK_MoveNames
    mov [ebp + wPredefBank], al
    mov eax, MOVE_NAME
    mov [ebp + wNameListType], al
    call GetName
    mov esi, wNameBuffer
.copyNameLoop:
    mov al, [ebp + esi]
    inc esi
    cmp al, 0x50 ; '@'
    jz .doneCopyingName
    mov [ebp + edx], al
    inc edx
    jmp .copyNameLoop
.doneCopyingName:
    mov al, bh
    mov [ebp + wNumMovesMinusOne], al
    inc bh
    mov al, 0x4E ; '<NEXT>'
    mov [ebp + edx], al
    inc edx
    pop esi
    mov cl, bh
    mov eax, NUM_MOVES
    cmp cl, al
    jz .done
    jmp .printMoveNameLoop
.printDashLoop:
    mov al, '-'
    mov [ebp + edx], al
    inc edx
    inc bh
    mov cl, bh
    mov eax, NUM_MOVES
    cmp cl, al
    jz .done
    mov al, 0x4E ; '<NEXT>'
    mov [ebp + edx], al
    inc edx
    jmp .printDashLoop
.done:
    mov al, 0x50 ; '@'
    mov [ebp + edx], al
    ret
