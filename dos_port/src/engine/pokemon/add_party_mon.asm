; add_party_mon.asm — _AddPartyMon (Pokémon data/stats plan, Stage 5).
;
; Source: engine/pokemon/add_mon.asm:_AddPartyMon (player, non-battle path).
;
; Adds a new mon to the PLAYER's party (wMonDataLocation low nibble = 0), the
; non-battle gift/normal path. Caller sets wCurPartySpecies and wCurEnemyLevel.
; Writes the party-list entry + the 44-byte party_struct (species, random DVs,
; current HP = max HP, box level/status, types, level-1 moves, OT, experience,
; level, fresh stats). Returns CF set on success, CF clear if the party is full.
;
; DEFERRED (TODO):
;  - Enemy party + wild-caught (wIsInBattle) paths — need wEnemyParty*/wIsInBattle
;    addresses (pending pokeyellow.sym).
;  - WriteMonMoves (level-up learnset): the level-1 base moves are kept (correct
;    for low-level mons); needs the evos_moves audit (Stage 6).
;  - Move PP: written as 0 (needs the Moves table, Stage 6); de still advances 4.
;  - Pokédex owned/seen flags and AskName naming — skipped (no effect on stats).
;  - OT id written as 0 (wPlayerID address pending the sym).
;
; Register map: a=AL, b=BH, c=BL, d=DH, hl=ESI, de=EDX, bc=EBX.

bits 32

%include "gb_memmap.inc"
%include "gb_constants.inc"

extern GetMonHeader
extern CalcStat
extern CalcStats
extern CalcExperience
extern Random_
extern SkipFixedLengthTextEntries
extern CopyData
extern AddNTimes

global _AddPartyMon

section .text

_AddPartyMon:
    mov al, [ebp + wPartyCount]
    inc al
    cmp al, PARTY_LENGTH + 1
    jc .notFull
    ret                              ; party full (ret nc): CF clear
.notFull:
    mov [ebp + wPartyCount], al      ; new count (doubles as hNewPartyLength)

    ; append species: edx = wPartyCount + count -> &wPartySpecies[count-1]
    movzx ecx, al
    lea edx, [wPartyCount + ecx]
    mov al, [ebp + wCurPartySpecies]
    mov [ebp + edx], al
    inc edx
    mov byte [ebp + edx], 0xFF       ; list terminator

    ; OT name slot: esi = wPartyMonOT + (count-1)*NAME_LENGTH
    mov esi, wPartyMonOT
    mov al, [ebp + wPartyCount]
    dec al
    call SkipFixedLengthTextEntries
    mov edx, esi                     ; de = OT dest
    mov esi, wPlayerName
    mov bx, NAME_LENGTH
    call CopyData

    ; esi = wPartyMons + (count-1)*PARTYMON_STRUCT_LENGTH
    mov esi, wPartyMons
    mov al, [ebp + wPartyCount]
    dec al
    mov bx, PARTYMON_STRUCT_LENGTH
    call AddNTimes
    mov edx, esi                     ; de = struct start (write cursor)
    push esi                         ; [S1] struct ptr (for final CalcStats)

    ; species byte (internal index)
    mov al, [ebp + wCurPartySpecies]
    mov [ebp + wCurSpecies], al
    call GetMonHeader
    mov al, [ebp + wMonHeader]
    mov [ebp + edx], al
    inc edx                          ; de = struct+1

    ; random DVs (non-battle): bh = 1st byte, al = 2nd byte
    call Random_
    mov bh, al
    call Random_
    mov esi, [esp]                   ; struct ptr
    add esi, MON_DVS
    mov [ebp + esi], al              ; DV byte 0
    inc esi
    mov [ebp + esi], bh              ; DV byte 1

    ; current HP = max HP: CalcStat(c=1 HP, b=0)
    mov esi, [esp]
    add esi, MON_HP_EXP - 1
    mov bl, 1
    mov bh, 0
    call CalcStat
    mov al, [ebp + H_MULTIPLICAND + 1]
    mov [ebp + edx], al
    inc edx
    mov al, [ebp + H_MULTIPLICAND + 2]
    mov [ebp + edx], al
    inc edx                          ; de = struct+3
    xor al, al
    mov [ebp + edx], al              ; box level 0
    inc edx
    mov [ebp + edx], al              ; status 0
    inc edx                          ; de = struct+5

    ; types + catch rate from wMonHTypes
    mov esi, wMonHTypes
    mov al, [ebp + esi]
    inc esi
    mov [ebp + edx], al              ; type1
    inc edx
    mov al, [ebp + esi]
    inc esi
    mov [ebp + edx], al              ; type2
    inc edx
    mov al, [ebp + esi]
    mov [ebp + edx], al              ; catch rate (de not yet incremented)

    ; level-1 moves from wMonHMoves
    mov esi, wMonHMoves
    mov al, [ebp + esi]
    inc esi
    inc edx                          ; de = struct+8 (MON_MOVES)
    push edx                         ; [S2] moves ptr (for PP)
    mov [ebp + edx], al
    mov al, [ebp + esi]
    inc esi
    inc edx
    mov [ebp + edx], al
    mov al, [ebp + esi]
    inc esi
    inc edx
    mov [ebp + edx], al
    mov al, [ebp + esi]
    inc esi
    inc edx
    mov [ebp + edx], al              ; de = struct+11

    ; OT id (stub 0)
    inc edx
    mov byte [ebp + edx], 0          ; OTID hi (struct+12)
    inc edx
    mov byte [ebp + edx], 0          ; OTID lo (struct+13)

    ; experience = CalcExperience(level)
    push edx                         ; [S3]
    mov al, [ebp + wCurEnemyLevel]
    mov dh, al
    call CalcExperience
    pop edx                          ; [S3]
    inc edx
    mov al, [ebp + H_EXPERIENCE]
    mov [ebp + edx], al              ; exp hi (struct+14)
    inc edx
    mov al, [ebp + H_EXPERIENCE + 1]
    mov [ebp + edx], al
    inc edx
    mov al, [ebp + H_EXPERIENCE + 2]
    mov [ebp + edx], al              ; de = struct+16

    ; zero EVs (NUM_STATS*2 bytes)
    mov bh, NUM_STATS * 2
.evLoop:
    inc edx
    mov byte [ebp + edx], 0
    dec bh
    jnz .evLoop                      ; de = struct+0x1A

    inc edx
    inc edx                          ; de = struct+0x1C
    pop esi                          ; [S2] moves ptr (PP stub doesn't use it; balances)
    ; PP stub: advance de by NUM_MOVES, writing 0 (TODO real PP — Moves table)
    mov bh, NUM_MOVES
.ppStub:
    inc edx
    mov byte [ebp + edx], 0
    dec bh
    jnz .ppStub                      ; de = struct+0x20

    ; level
    inc edx
    mov al, [ebp + wCurEnemyLevel]
    mov [ebp + edx], al              ; struct+MON_LEVEL (0x21)
    inc edx                          ; de = struct+MON_STATS (0x22)

    ; fresh stats
    pop esi                          ; [S1] struct ptr
    add esi, MON_HP_EXP - 1
    mov bh, 0
    call CalcStats
    stc                              ; success
    ret
