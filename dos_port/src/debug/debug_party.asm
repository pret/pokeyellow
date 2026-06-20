; dos_port/src/debug/debug_party.asm

%include "gb_macros.inc"
%include "gb_memmap.inc"

section .text

global SetDebugNewGameParty
global PrepareNewGameDebug
extern AddPartyMon
extern AddItemToInventory

%define BIT_EARTHBADGE 7
%define SURF 57
%define FLY 19
%define CUT 15
%define STRENGTH 70

%define SNORLAX 132
%define PERSIAN 113
%define JIGGLYPUFF 100
%define STARTER_PIKACHU 84

%define RIVAL_STARTER_JOLTEON 135
%define NUM_POKEMON 151

%define EVENT_GOT_POKEDEX 37

; -----------------------------------------------------------------------------
; SetDebugNewGameParty
; -----------------------------------------------------------------------------
SetDebugNewGameParty:
    lea esi, [DebugNewGameParty]

.loop:
    mov al, byte [esi]
    cmp al, 0xFF
    jz .done
    
    mov byte [ebp + W_CUR_PARTY_SPECIES], al
    inc esi
    
    mov al, byte [esi]
    mov byte [ebp + W_CUR_ENEMY_LEVEL], al
    inc esi
    
    push esi ; Save ESI across AddPartyMon
    call AddPartyMon
    pop esi
    
    jmp .loop
.done:
    ret

; -----------------------------------------------------------------------------
; PrepareNewGameDebug
; -----------------------------------------------------------------------------
PrepareNewGameDebug:
    ; W_MON_DATA_LOCATION = 0
    mov byte [ebp + W_MON_DATA_LOCATION], 0

    ; Fly anywhere
    mov byte [ebp + W_TOWN_VISITED_FLAG], 0xFF
    mov byte [ebp + W_TOWN_VISITED_FLAG + 1], 0xFF

    ; Get all badges except Earth Badge
    mov byte [ebp + W_OBTAINED_BADGES], ~(1 << BIT_EARTHBADGE)

    call SetDebugNewGameParty

    ; Pikachu gets Surf
    mov byte [ebp + W_PARTY_MON4_MOVES + 2], SURF

    ; Snorlax gets four HM moves
    mov byte [ebp + W_PARTY_MON1_MOVES + 0], FLY
    mov byte [ebp + W_PARTY_MON1_MOVES + 1], CUT
    mov byte [ebp + W_PARTY_MON1_MOVES + 2], SURF
    mov byte [ebp + W_PARTY_MON1_MOVES + 3], STRENGTH

    ; Get some debug items
    lea esi, [DebugNewGameItemsList]
.items_loop:
    mov al, byte [esi]
    cmp al, 0xFF
    jz .items_end
    
    mov byte [ebp + W_CUR_ITEM], al
    inc esi
    mov al, byte [esi]
    inc esi
    mov byte [ebp + W_ITEM_QUANTITY], al
    
    push esi
    mov esi, W_NUM_BAG_ITEMS
    call AddItemToInventory ; Note: AddItemToInventory takes ESI=inventory ptr
    pop esi
    
    jmp .items_loop

.items_end:
    ; Complete the Pokédex
    mov edi, W_POKEDEX_OWNED
    call DebugSetPokedexEntries
    mov edi, W_POKEDEX_SEEN
    call DebugSetPokedexEntries
    
    ; SetEvent EVENT_GOT_POKEDEX
    ; Event 37 is byte 4, bit 5
    or byte [ebp + W_EVENT_FLAGS + (EVENT_GOT_POKEDEX / 8)], (1 << (EVENT_GOT_POKEDEX % 8))

    ; Rival chose Jolteon
    mov byte [ebp + W_RIVAL_STARTER], RIVAL_STARTER_JOLTEON
    mov byte [ebp + W_RIVAL_STARTER + 1], NUM_POKEMON
    mov byte [ebp + W_RIVAL_STARTER + 2], STARTER_PIKACHU

    ; Give max money
    mov byte [ebp + W_PLAYER_MONEY], 0x99
    mov byte [ebp + W_PLAYER_MONEY + 1], 0x99
    mov byte [ebp + W_PLAYER_MONEY + 2], 0x99
    
    ret

; -----------------------------------------------------------------------------
; DebugSetPokedexEntries
; Fills the Pokedex buffer at EDI.
; -----------------------------------------------------------------------------
DebugSetPokedexEntries:
    mov ecx, NUM_POKEMON / 8
.loop:
    mov byte [ebp + edi], 0xFF
    inc edi
    dec ecx
    jnz .loop
    
    mov byte [ebp + edi], (1 << (NUM_POKEMON % 8)) - 1
    ret

section .data

DebugNewGameParty:
    db SNORLAX, 80
    db PERSIAN, 80
    db JIGGLYPUFF, 15
    db STARTER_PIKACHU, 5
    db 0xFF ; end (-1)

; Debug items. We only use numeric values here.
%define MASTER_BALL 1
%define TOWN_MAP 4
%define BICYCLE 6
%define FULL_RESTORE 17
%define ESCAPE_ROPE 29
%define RARE_CANDY 40
%define SECRET_KEY 65
%define CARD_KEY 74
%define FULL_HEAL 52
%define REVIVE 53
%define FRESH_WATER 60
%define S_S_TICKET 69
%define LIFT_KEY 76
%define PP_UP 49

DebugNewGameItemsList:
    db MASTER_BALL, 99
    db TOWN_MAP, 1
    db BICYCLE, 1
    db FULL_RESTORE, 99
    db ESCAPE_ROPE, 99
    db RARE_CANDY, 99
    db SECRET_KEY, 1
    db CARD_KEY, 1
    db FULL_HEAL, 99
    db REVIVE, 99
    db FRESH_WATER, 99
    db S_S_TICKET, 1
    db LIFT_KEY, 1
    db PP_UP, 99
    db 0xFF ; end (-1)
