; divide hMoney by hDivideBCDDivisor
; return output in hDivideBCDQuotient (same as hDivideBCDDivisor)
; used only to halve player money upon losing a fight
DivideBCDPredef:: ; f5a4 (3:75a4)
DivideBCDPredef2::
DivideBCDPredef3:: ; only used function
DivideBCDPredef4::
	call GetPredefRegisters

DivideBCD:: ; f5a8 (3:75a8)
	xor a
	ld [hDivideBCDBuffer], a
	ld [hDivideBCDBuffer + 1], a
	ld [hDivideBCDBuffer + 2], a
	ld d, $1
.asm_f5b0
	ld a, [hDivideBCDDivisor]
	and $f0
	jr nz, .asm_f5e1
	inc d
	ld a, [hDivideBCDDivisor]
	swap a
	and $f0
	ld b, a
	ld a, [hDivideBCDDivisor + 1]
	swap a
	ld [hDivideBCDDivisor + 1], a
	and $f
	or b
	ld [hDivideBCDDivisor], a
	ld a, [hDivideBCDDivisor + 1]
	and $f0
	ld b, a
	ld a, [hDivideBCDDivisor + 2]
	swap a
	ld [hDivideBCDDivisor + 2], a
	and $f
	or b
	ld [hDivideBCDDivisor + 1], a
	ld a, [hDivideBCDDivisor + 2]
	and $f0
	ld [hDivideBCDDivisor + 2], a
	jr .asm_f5b0
.asm_f5e1
	push de
	push de
	call DivideBCD_f686
	pop de
	ld a, b
	swap a
	and $f0
	ld [hDivideBCDBuffer], a
	dec d
	jr z, .asm_f642
	push de
	call DivideBCD_f65d
	call DivideBCD_f686
	pop de
	ld a, [hDivideBCDBuffer]
	or b
	ld [hDivideBCDBuffer], a
	dec d
	jr z, .asm_f642
	push de
	call DivideBCD_f65d
	call DivideBCD_f686
	pop de
	ld a, b
	swap a
	and $f0
	ld [hDivideBCDBuffer + 1], a
	dec d
	jr z, .asm_f642
	push de
	call DivideBCD_f65d
	call DivideBCD_f686
	pop de
	ld a, [hDivideBCDBuffer + 1]
	or b
	ld [hDivideBCDBuffer + 1], a
	dec d
	jr z, .asm_f642
	push de
	call DivideBCD_f65d
	call DivideBCD_f686
	pop de
	ld a, b
	swap a
	and $f0
	ld [hDivideBCDBuffer + 2], a
	dec d
	jr z, .asm_f642
	push de
	call DivideBCD_f65d
	call DivideBCD_f686
	pop de
	ld a, [hDivideBCDBuffer + 2]
	or b
	ld [hDivideBCDBuffer + 2], a
.asm_f642
	ld a, [hDivideBCDBuffer]
	ld [hDivideBCDQuotient], a
	ld a, [hDivideBCDBuffer + 1]
	ld [hDivideBCDQuotient + 1], a
	ld a, [hDivideBCDBuffer + 2]
	ld [hDivideBCDQuotient + 2], a
	pop de
	ld a, $6
	sub d
	and a
	ret z
.asm_f654
	push af
	call DivideBCD_f65d
	pop af
	dec a
	jr nz, .asm_f654
	ret

DivideBCD_f65d: ; f65d (3:765d)
	ld a, [hDivideBCDDivisor + 2]
	swap a
	and $f
	ld b, a
	ld a, [hDivideBCDDivisor + 1]
	swap a
	ld [hDivideBCDDivisor + 1], a
	and $f0
	or b
	ld [hDivideBCDDivisor + 2], a
	ld a, [hDivideBCDDivisor + 1]
	and $f
	ld b, a
	ld a, [hDivideBCDDivisor]
	swap a
	ld [hDivideBCDDivisor], a
	and $f0
	or b
	ld [hDivideBCDDivisor + 1], a
	ld a, [hDivideBCDDivisor]
	and $f
	ld [hDivideBCDDivisor], a
	ret

DivideBCD_f686: ; f686 (3:7686)
	ld bc, $3
.asm_f689
	ld de, hMoney
	ld hl, hDivideBCDDivisor
	push bc
	call StringCmp
	pop bc
	ret c
	inc b
	ld de, hMoney + 2
	ld hl, hDivideBCDDivisor + 2
	push bc
	call SubBCD
	pop bc
	jr .asm_f689


AddBCDPredef:: ; f6a3 (3:76a3)
	call GetPredefRegisters

AddBCD:: ; f6a6 (3:76a6)
	and a
	ld b, c
.add
	ld a, [de]
	adc [hl]
	daa
	ld [de], a
	dec de
	dec hl
	dec c
	jr nz, .add
	jr nc, .done
	ld a, $99
	inc de
.fill
	ld [de], a
	inc de
	dec b
	jr nz, .fill
.done
	ret


SubBCDPredef:: ; f6bc (3:76bc)
	call GetPredefRegisters

SubBCD:: ; f6bf (3:76bf)
	and a
	ld b, c
.sub
	ld a, [de]
	sbc [hl]
	daa
	ld [de], a
	dec de
	dec hl
	dec c
	jr nz, .sub
	jr nc, .done
	ld a, $00
	inc de
.fill
	ld [de], a
	inc de
	dec b
	jr nz, .fill
	scf
.done
	ret