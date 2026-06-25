; move_mon.asm — CalcStats / CalcStat (Pokémon data/stats plan).
;
; Source: home/move_mon.asm:CalcStats, CalcStat (pret/pokeyellow).
;
; Stat formula (per stat): (((Base + IV) * 2 + ceil(sqrt(statExp))/4) * Level)/100
;   then + Level + 10 for HP, or + 5 for the others; capped at MAX_STAT_VALUE (999).
;
; Register map: a=AL, b=BH, c=BL, d=DH, e=DL, hl=ESI, de=EDX, bc=EBX.
; GB memory at [EBP+addr]; HRAM math scratch via H_MULTIPLICAND/H_PRODUCT/etc.
; The big-endian 2-byte result is left in H_MULTIPLICAND+1 (high) / +2 (low),
; exactly as the original, so CalcStats can copy it straight to [de].
;
; Build: nasm -f coff -I include/ -I . -o move_mon.o move_mon.asm

bits 32

%include "gb_memmap.inc"
%include "gb_constants.inc"

extern Multiply
extern Divide

global CalcStats
global CalcStat

MAX_STAT_HIGH   equ (MAX_STAT_VALUE >> 8) & 0xFF    ; HIGH(999) = 0x03
MAX_STAT_LOW    equ MAX_STAT_VALUE & 0xFF            ; LOW(999)  = 0xE7

section .text

; calculates all 5 stats of the current mon and writes them to [de] (2 bytes each)
; In: BH (b) = consider stat exp?; ESI (hl) = base ptr to stat exp values;
;     EDX (de) = destination pointer (GB address).
CalcStats:
    mov bl, 0                       ; c = 0
.statsLoop:
    inc bl                          ; inc c
    call CalcStat
    mov al, [ebp + H_MULTIPLICAND + 1]   ; stat high byte
    mov [ebp + edx], al
    inc edx
    mov al, [ebp + H_MULTIPLICAND + 2]   ; stat low byte
    mov [ebp + edx], al
    inc edx
    cmp bl, NUM_STATS
    jne .statsLoop
    ret

; calculates stat c of the current mon
; In: BL (c) = stat (HP=1,Atk=2,Def=3,Spd=4,Spc=5); BH (b) = consider stat exp?;
;     ESI (hl) = base ptr to stat exp ([hl+2c-1] and [hl+2c]).
; Out: result in H_MULTIPLICAND+1/+2 (big-endian). ESI/EDX/EBX preserved.
CalcStat:
    push esi
    push edx
    push ebx
    mov al, bh                      ; ld a, b
    mov dh, al                      ; ld d, a  (consider-stat-exp flag)
    push esi                        ; push hl
    mov esi, wMonHeader             ; ld hl, wMonHeader
    mov bh, 0                       ; ld b, 0
    movzx ecx, bx                   ; add hl, bc
    add esi, ecx
    mov al, [ebp + esi]             ; ld a, [hl]  base stat value
    mov dl, al                      ; ld e, a
    pop esi                         ; pop hl  (stat exp base ptr)
    push esi                        ; push hl
    shl bl, 1                       ; sla c   (c *= 2)
    mov al, dh                      ; ld a, d
    test al, al                     ; and a   (consider stat exp?)
    jz .statExpDone
    movzx ecx, bx                   ; add hl, bc  (skip to stat exp value)
    add esi, ecx
.statExpLoop:                       ; ceil(sqrt(statExp)) in b
    xor al, al
    mov [ebp + H_MULTIPLICAND], al
    mov [ebp + H_MULTIPLICAND + 1], al
    inc bh                          ; inc b
    mov al, bh
    cmp al, 0xFF
    je .statExpDone
    mov [ebp + H_MULTIPLICAND + 2], al   ; b
    mov [ebp + H_MULTIPLIER], al         ; b
    call Multiply                   ; b*b -> product
    mov al, [ebp + esi]             ; ld a, [hld]  (stat exp low byte)
    dec esi
    mov dh, al                      ; ld d, a
    mov al, [ebp + H_PRODUCT + 3]
    sub al, dh                      ; sub d        (sets borrow)
    mov al, [ebp + esi]             ; ld a, [hli]  (stat exp high byte; mov/inc keep CF)
    inc esi
    mov dh, al                      ; ld d, a
    mov al, [ebp + H_PRODUCT + 2]
    sbb al, dh                      ; sbc d        (test b^2 < statExp)
    jc .statExpLoop
.statExpDone:
    shr bl, 1                       ; srl c   (back to stat number)
    pop esi                         ; pop hl  (stat exp base ptr)
    push ebx                        ; push bc
    mov ebx, MON_DVS - (MON_HP_EXP - 1)  ; ld bc, $0B
    movzx ecx, bx                   ; add hl, bc  -> hl = MON_DVS
    add esi, ecx
    pop ebx                         ; pop bc  (stat number back in c/BL)
    mov al, bl                      ; ld a, c
    cmp al, 2
    je .getAttackIV
    cmp al, 3
    je .getDefenseIV
    cmp al, 4
    je .getSpeedIV
    cmp al, 5
    je .getSpecialIV
; HP IV = LSB of the other four IVs
    push ebx
    mov al, [ebp + esi]             ; Atk IV byte (DV byte 0)
    rol al, 4                       ; swap a
    and al, 1
    shl al, 1
    shl al, 1
    shl al, 1
    mov bh, al
    mov al, [ebp + esi]             ; Def IV (byte 0 low nibble); hl++
    inc esi
    and al, 1
    shl al, 1
    shl al, 1
    add al, bh
    mov bh, al
    mov al, [ebp + esi]             ; Spd IV (byte 1 high nibble)
    rol al, 4                       ; swap a
    and al, 1
    shl al, 1
    add al, bh
    mov bh, al
    mov al, [ebp + esi]             ; Spc IV (byte 1 low nibble)
    and al, 1
    add al, bh                      ; HP IV
    pop ebx
    jmp .calcStatFromIV
.getAttackIV:
    mov al, [ebp + esi]
    rol al, 4                       ; swap a
    and al, 0x0F
    jmp .calcStatFromIV
.getDefenseIV:
    mov al, [ebp + esi]
    and al, 0x0F
    jmp .calcStatFromIV
.getSpeedIV:
    inc esi
    mov al, [ebp + esi]
    rol al, 4                       ; swap a
    and al, 0x0F
    jmp .calcStatFromIV
.getSpecialIV:
    inc esi
    mov al, [ebp + esi]
    and al, 0x0F
.calcStatFromIV:
    mov dh, 0                       ; ld d, 0
    add al, dl                      ; add e   (IV + Base)
    mov dl, al                      ; ld e, a
    jnc .noCarry
    inc dh                          ; de = Base + IV
.noCarry:
    shl dl, 1
    rcl dh, 1                       ; de = (Base + IV) * 2
    shr bh, 1
    shr bh, 1                       ; b = ceil(sqrt(statExp)) / 4
    mov al, bh
    add al, dl                      ; add e
    jnc .noCarry2
    inc dh
.noCarry2:
    mov [ebp + H_MULTIPLICAND + 2], al
    mov al, dh
    mov [ebp + H_MULTIPLICAND + 1], al
    xor al, al
    mov [ebp + H_MULTIPLICAND], al
    mov al, [ebp + wCurEnemyLevel]
    mov [ebp + H_MULTIPLIER], al
    call Multiply                   ; * Level
    mov al, [ebp + H_MULTIPLICAND]
    mov [ebp + H_DIVIDEND], al
    mov al, [ebp + H_MULTIPLICAND + 1]
    mov [ebp + H_DIVIDEND + 1], al
    mov al, [ebp + H_MULTIPLICAND + 2]
    mov [ebp + H_DIVIDEND + 2], al
    mov al, 0x64
    mov [ebp + H_DIVISOR], al
    mov bh, 3                       ; b = 3-byte dividend
    call Divide                     ; / 100
    mov al, bl                      ; ld a, c
    cmp al, 1
    mov al, 5                       ; +5 for non-HP
    jne .notHPStat
    mov al, [ebp + wCurEnemyLevel]  ; HP: + Level first
    mov bh, al
    mov al, [ebp + H_MULTIPLICAND + 2]
    add al, bh
    mov [ebp + H_MULTIPLICAND + 2], al
    jnc .noCarry3
    mov al, [ebp + H_MULTIPLICAND + 1]
    inc al
    mov [ebp + H_MULTIPLICAND + 1], al
.noCarry3:
    mov al, 10                      ; +10 for HP
.notHPStat:
    mov bh, al
    mov al, [ebp + H_MULTIPLICAND + 2]
    add al, bh
    mov [ebp + H_MULTIPLICAND + 2], al
    jnc .noCarry4
    mov al, [ebp + H_MULTIPLICAND + 1]
    inc al
    mov [ebp + H_MULTIPLICAND + 1], al
.noCarry4:
    mov al, [ebp + H_MULTIPLICAND + 1]   ; overflow check (>999)
    cmp al, MAX_STAT_HIGH + 1
    jnc .overflow
    cmp al, MAX_STAT_HIGH
    jc .noOverflow
    mov al, [ebp + H_MULTIPLICAND + 2]
    cmp al, MAX_STAT_LOW + 1
    jc .noOverflow
.overflow:
    mov al, MAX_STAT_HIGH
    mov [ebp + H_MULTIPLICAND + 1], al
    mov al, MAX_STAT_LOW
    mov [ebp + H_MULTIPLICAND + 2], al
.noOverflow:
    pop ebx
    pop edx
    pop esi
    ret
