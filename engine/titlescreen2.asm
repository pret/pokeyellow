; Leftover of Red/Blue. Seemingly unused

TitleScroll_WaitBall: ; 3749e (d:749e)
; Wait around for the TitleBall animation to play out.
; hi: speed
; lo: duration
	db $05, $05, 0

TitleScroll_In: ; 374a1 (d:74a1)
; Scroll a TitleMon in from the right.
; hi: speed
; lo: duration
	db $a2, $94, $84, $63, $52, $31, $11, 0

TitleScroll_Out: ; 374a9 (d:74a9)
; Scroll a TitleMon out to the left.
; hi: speed
; lo: duration
	db $12, $22, $32, $42, $52, $62, $83, $93, 0

TitleScroll: ; 374b2 (d:74b2)
	ld a, d

	ld bc, TitleScroll_In
	ld d, $88
	ld e, 0 ; don't animate titleball

	and a
	jr nz, .ok

	ld bc, TitleScroll_Out
	ld d, $00
	ld e, 0 ; don't animate titleball
.ok

_TitleScroll: ; 374c4 (d:74c4)
	ld a, [bc]
	and a
	ret z

	inc bc
	push bc

	ld b, a
	and $f
	ld c, a
	ld a, b
	and $f0
	swap a
	ld b, a

.loop
	ld h, d
	ld l, $48
	call .ScrollBetween

	ld h, $00
	ld l, $88
	call .ScrollBetween

	ld a, d
	add b
	ld d, a

	call GetTitleBallY
	dec c
	jr nz, .loop

	pop bc
	jr _TitleScroll

.ScrollBetween ; 374ec (d:74ec)
.wait
	ld a, [rLY] ; rLY
	cp l
	jr nz, .wait

	ld a, h
	ld [rSCX], a

.wait2
	ld a, [rLY] ; rLY
	cp h
	jr z, .wait2
	ret

TitleBallYTable: ; 374fa (d:74fa)
; OBJ y-positions for the Poke Ball held by Red in the title screen.
; This is really two 0-terminated lists. Initiated with an index of 1.
	db 0, $71, $6f, $6e, $6d, $6c, $6d, $6e, $6f, $71, $74, 0

TitleScreenAnimateBallIfStarterOut: ; 37506 (d:7506)
; Animate the TitleBall if a starter just got scrolled out.
	ld a, [wTitleMonSpecies]
	cp STARTER1
	jr z, .ok
	cp STARTER2
	jr z, .ok
	cp STARTER3
	ret nz
.ok
	ld e, 1 ; animate titleball
	ld bc, TitleScroll_WaitBall
	ld d, 0
	jp _TitleScroll

GetTitleBallY: ; 3751e (d:751e)
; Get position e from TitleBallYTable
	push de
	push hl
	xor a
	ld d, a
	ld hl, TitleBallYTable
	add hl, de
	ld a, [hl]
	pop hl
	pop de
	and a
	ret z
	ld [wOAMBuffer + $28], a
	inc e
	ret
