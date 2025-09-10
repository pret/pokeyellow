ModifyPikachuHappiness::
	ld a, d
	cp PIKAHAPPY_GYMLEADER
	jr z, .checkanywhereinparty
	cp PIKAHAPPY_WALKING
	jr z, .checkanywhereinparty
	push de
	callfar IsThisPartyMonStarterPikachu
	pop de
	ret nc
	jr .proceed

.checkanywhereinparty
	push de
	callfar IsStarterPikachuAliveInOurParty
	pop de
	ret nc

.proceed
	push de
	; Divide [wPikachuHappiness] by 100.  Hold the integer part in e.
	ld e, $0
	ld a, [wPikachuHappiness]
	cp 100
	jr c, .wPikachuHappiness_div_100
	inc e
	cp 200
	jr c, .wPikachuHappiness_div_100
	inc e
.wPikachuHappiness_div_100
	; Get the (d, e) entry from HappinessChangeTable.
	ld c, d
	dec c
	ld b, $0
	ld hl, HappinessChangeTable
	add hl, bc
	add hl, bc
	add hl, bc
	ld d, $0
	add hl, de
	ld a, [hl]
	; If [hl] is positive, take min(0xff, [hl] + [wPikachuHappiness]).
	; If [hl] is negative, take max(0x00, [hl] + [wPikachuHappiness]).
	; Inexplicably, we're using 100 as the threshold for comparison.
	cp 100
	ld a, [wPikachuHappiness]
	jr nc, .negative
	add [hl]
	jr nc, .okay
	ld a, -1
	jr .okay

.negative
	add [hl]
	jr c, .okay
	xor a
.okay
	ld [wPikachuHappiness], a

	; Restore d and get the d'th entry in PikachuMoods.
	pop de
	dec d
	ld hl, PikachuMoods
	ld e, d
	ld d, $0
	add hl, de
	ld a, [hl]
	ld b, a
	; Modify Pikachu's mood
	cp $80
	jr z, .done
	ld a, [wPikachuMood]
	jr c, .decreased
	cp b
	jr nc, .done
	ld a, [wd49b]
	and a
	jr nz, .done
	jr .update_mood

.decreased
	cp b
	jr c, .done
.update_mood
	ld a, b
	ld [wPikachuMood], a
.done
	ret

HappinessChangeTable:
	; Increase
	db   5, 3, 2 ; Gained a level
	db   5, 3, 2 ; HP restore
	db   1, 1, 0 ; Used X item
	db   3, 2, 1 ; Challenged Gym Leader
	db   1, 1, 0 ; Teach TM/HM
	db   2, 1, 1 ; Walking around
	; Decrease
	db  -3, -3, -5 ; Deposited
	db  -1, -1, -1 ; Fainted in battle
	db  -5, -5, -10 ; Fainted due to Poison outside of battle
	db  -5, -5, -10 ; Fainted to opponent at least 30 levels higher
	db -10, -10, -20 ; Traded away

PikachuMoods:
	; Increase
	db $8a           ; Gained a level
	db $83           ; HP restore
	db $80           ; Teach TM/HM
	db $80           ; Challenged Gym Leader
	db $94           ; Unknown (d = 5)
	db $80           ; Unknown (d = 6)
	; Decrease
	db $62           ; Deposited
	db $6c           ; Fainted
	db $62           ; Unknown (d = 9)
	db $6c           ; Unknown (d = 10)
	db $00           ; Unknown (d = 11)
