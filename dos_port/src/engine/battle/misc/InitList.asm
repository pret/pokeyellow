; ╔══════════════════════════════════════════════════════════╗
; ║              PKMNDOS TRANSLATION MANIFEST               ║
; ╚══════════════════════════════════════════════════════════╝
; queue_id   : 1745
; label      : InitList
; source     : engine/battle/misc.asm
; category   : simple
; scratch    : dos_port/scratch/1745__InitList.asm
; -----------------------------------------------------------
; target      : dos_port/src/engine/battle/misc/InitList.asm
; aggregator  : dos_port/src/engine/battle/misc.asm
; -----------------------------------------------------------
; WORKER NOTES — fill in before calling work_queue complete
; registers   : A->AL, BC->BX, DE->DX, HL->ESI
; hflag       : not involved
; bug_tags    : none
; notes       : Used EAX to extract L and H from ESI. Used 32-bit relocations for externs to satisfy COFF.
; ╔══════════════════════════════════════════════════════════╗
; ║  CODE BELOW — do not modify the header above            ║
; ╚══════════════════════════════════════════════════════════╝

extern wInitListType
extern INIT_ENEMYOT_LIST
extern wEnemyPartyCount
extern wEnemyMonOT
extern ENEMYOT_NAME
extern INIT_PLAYEROT_LIST
extern wPartyCount
extern PLAYEROT_NAME
extern INIT_MON_LIST
extern wItemList
extern MonsterNames
extern MONSTER_NAME
extern INIT_BAG_ITEM_LIST
extern ItemNames
extern ITEM_NAME
extern wNameListType
extern wListPointer
extern wUnusedNamePointer
extern ItemPrices
extern wItemPrices

W_NUM_BAG_ITEMS equ 0xD31C
W_PARTY_MON_OT equ 0xD272

InitList:
    mov al, byte [ebp + wInitListType]
    
    mov ebx, INIT_ENEMYOT_LIST
    cmp al, bl
    jne .notEnemy
    mov esi, wEnemyPartyCount
    mov edx, wEnemyMonOT
    mov ebx, ENEMYOT_NAME
    mov al, bl
    jmp .done
.notEnemy:
    mov ebx, INIT_PLAYEROT_LIST
    cmp al, bl
    jne .notPlayer
    mov esi, wPartyCount
    mov edx, W_PARTY_MON_OT
    mov ebx, PLAYEROT_NAME
    mov al, bl
    jmp .done
.notPlayer:
    mov ebx, INIT_MON_LIST
    cmp al, bl
    jne .notMonster
    mov esi, wItemList
    mov edx, MonsterNames
    mov ebx, MONSTER_NAME
    mov al, bl
    jmp .done
.notMonster:
    mov ebx, INIT_BAG_ITEM_LIST
    cmp al, bl
    jne .notBag
    mov esi, W_NUM_BAG_ITEMS
    mov edx, ItemNames
    mov ebx, ITEM_NAME
    mov al, bl
    jmp .done
.notBag:
    mov esi, wItemList
    mov edx, ItemNames
    mov ebx, ITEM_NAME
    mov al, bl
.done:
    mov byte [ebp + wNameListType], al
    
    mov eax, esi
    mov byte [ebp + wListPointer], al
    shr eax, 8
    mov byte [ebp + wListPointer + 1], al
    
    mov al, dl
    mov byte [ebp + wUnusedNamePointer], al
    mov al, dh
    mov byte [ebp + wUnusedNamePointer + 1], al
    
    mov ebx, ItemPrices
    mov al, bl
    mov byte [ebp + wItemPrices], al
    mov al, bh
    mov byte [ebp + wItemPrices + 1], al
    ret
