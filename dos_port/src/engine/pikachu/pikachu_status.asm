; dos_port/engine/pikachu/pikachu_status.asm
global IsStarterPikachuAliveInOurParty
global IsThisBoxMonStarterPikachu
global IsThisPartyMonStarterPikachu
global UpdatePikachuMoodAfterBattle
global CheckPikachuStatusCondition

extern wPartySpecies
extern wPartyMon1OTID
extern wPartyMonOT
extern wPlayerID
extern wPlayerName
extern wPartyMon2
extern wPartyMon1
extern wPartyMon1HP
extern wBoxMon1
extern wBoxMon2
extern wBoxMonOT
extern wWhichPokemon
extern wPikachuMood
extern wPartyCount
extern AddNTimes

; Assume constants
extern STARTER_PIKACHU
extern NAME_LENGTH_JP
extern NAME_LENGTH

section .text

IsStarterPikachuAliveInOurParty:
    mov esi, wPartySpecies
    mov edx, wPartyMon1OTID
    mov ecx, wPartyMonOT
    
    push esi
.loop:
    pop esi
    mov al, [ebp + esi]
    push esi
    inc al
    jz .noPlayerPikachu
    
    cmp al, STARTER_PIKACHU + 1
    jnz .curMonNotPlayerPikachu
    
    ; check OT ID
    mov esi, edx
    mov al, [ebp + wPlayerID]
    cmp al, [ebp + esi]
    jnz .curMonNotPlayerPikachu
    inc esi
    mov al, [ebp + wPlayerID + 1]
    cmp al, [ebp + esi]
    jnz .curMonNotPlayerPikachu
    
    ; check OT Name
    push dx
    push cx
    
    mov esi, wPlayerName
    mov dh, NAME_LENGTH_JP
.nameCompareLoop:
    dec dh
    jz .sameOT
    mov al, [ebp + ecx]
    inc ecx
    cmp al, [ebp + esi]
    inc esi
    jz .nameCompareLoop
    
    pop cx
    pop dx

.curMonNotPlayerPikachu:
    movzx eax, word (wPartyMon2 - wPartyMon1)
    add edx, eax
    movzx eax, word NAME_LENGTH
    add ecx, eax
    jmp .loop

.sameOT:
    pop cx
    pop dx
    
    mov esi, edx
    movzx eax, word (wPartyMon1HP - wPartyMon1OTID)
    add esi, eax
    
    mov al, [ebp + esi]
    inc esi
    or al, [ebp + esi]
    jz .noPlayerPikachu
    
    pop esi
    stc
    ret

.noPlayerPikachu:
    pop esi
    clc
    ret

IsThisBoxMonStarterPikachu:
    mov esi, wBoxMon1
    mov bx, wBoxMon2 - wBoxMon1
    mov dx, wBoxMonOT
    jmp IsThisMonStarterPikachu

IsThisPartyMonStarterPikachu:
    mov esi, wPartyMon1
    mov bx, wPartyMon2 - wPartyMon1
    mov dx, wPartyMonOT

IsThisMonStarterPikachu:
    mov al, [ebp + wWhichPokemon]
    call AddNTimes
    
    mov al, [ebp + esi]
    cmp al, STARTER_PIKACHU
    jnz .notPlayerPikachu
    
    movzx ecx, word (wPartyMon1OTID - wPartyMon1)
    add esi, ecx
    
    mov al, [ebp + wPlayerID]
    cmp al, [ebp + esi]
    jnz .notPlayerPikachu
    inc esi
    mov al, [ebp + wPlayerID + 1]
    cmp al, [ebp + esi]
    jnz .notPlayerPikachu
    
    mov esi, edx ; dx contains OT
    mov al, [ebp + wWhichPokemon]
    mov bx, NAME_LENGTH
    call AddNTimes
    
    mov edx, wPlayerName
    mov bl, NAME_LENGTH_JP

.loopName:
    dec bl
    jz .isPlayerPikachu
    mov al, [ebp + edx]
    inc edx
    cmp al, [ebp + esi]
    inc esi
    jz .loopName

.notPlayerPikachu:
    clc
    ret

.isPlayerPikachu:
    stc
    ret

UpdatePikachuMoodAfterBattle:
    push dx
    call IsStarterPikachuAliveInOurParty
    pop dx
    jnc .ret_nc
    
    mov al, dh
    cmp al, 128
    mov al, [ebp + wPikachuMood]
    jc .d_less_than_128
    
    cmp al, dh
    jc .load_d_into_mood
    ret

.d_less_than_128:
    cmp al, dh
    jc .ret_nc
.load_d_into_mood:
    mov al, dh
    mov [ebp + wPikachuMood], al
.ret_nc:
    ret

CheckPikachuStatusCondition:
    xor al, al
    mov [ebp + wWhichPokemon], al
    mov esi, wPartyCount
.loop_status:
    inc esi
    mov al, [ebp + esi]
    cmp al, 0xff
    jz .noAilment
    
    push esi
    call IsThisPartyMonStarterPikachu
    pop esi
    jnc .next
    
    mov al, [ebp + wWhichPokemon]
    push esi
    mov esi, wPartyMon1HP
    mov bx, wPartyMon2 - wPartyMon1
    call AddNTimes
    
    mov al, [ebp + esi]
    inc esi
    or al, [ebp + esi]
    mov dh, al
    inc esi
    mov al, [ebp + esi] ; status
    pop esi
    
    test al, al
    jnz .hasAilment
    jmp .noAilment

.next:
    mov al, [ebp + wWhichPokemon]
    inc al
    mov [ebp + wWhichPokemon], al
    jmp .loop_status

.hasAilment:
    stc
    ret
.noAilment:
    clc
    ret
