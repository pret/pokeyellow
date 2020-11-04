TrashCanRandom:
	ld d, 0
	ld hl, .Jumptable
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call JumpToAddress
	ld e, a
	ld d, 0
	ret

.Jumptable:
	dw .zero
	dw .one
	dw .two
	dw .three
	dw .four

.zero
.one
	ld a, 0
	ret

.two
	call Random
	and $1
	ret

.three ; should return to a, instead returns to b
	call Random
	swap a
	cp 1 * $ff / 3
	ld b, 0
	ret c
	cp 2 * $ff / 3
	ld b, 1
	ret c
	ld b, 2
	ret

.four
	call Random
	and $3
	ret

Yellow_SampleSecondTrashCan:
	ld hl, GymTrashCans3c
	ld a, [wGymTrashCanIndex]
	ld c, a
	ld b, 0
	ld a, 9
	call AddNTimes
	call AddNTimes ; ????
	ld a, [hli]
	ldh [hGymTrashCanRandNumMask], a
	ld e, a
	push hl
	call TrashCanRandom
	pop hl
	add hl, de
	add hl, de
	ld a, [hli]
	ld [wSecondLockTrashCanIndex], a
	ld a, [hl]
	ld [wSecondLockTrashCanIndex + 1], a
	ret

GymTrashCans3c:
; First byte: number of trashcan entries
; Following four byte pairs: indices for the second trash can.
; BUG: Rows that have 3 trashcan entries are sampled incorrectly.
; The sampling occurs by taking a random number and seeing which
; third of the range 0-255 the number falls in.  However, it returns
; that value to the wrong register, so the result is never used.
; Instead of using an offset in [0,1,2], the offset is instead
; in the full range 0-255.  This results in truly random behavior.
	db 4
	db  1,3,   3,1,   1,-1,  3,-1
	db 3
	db  0,2,   2,4,   4,0,  -1,-1
	db 4
	db  1,5,   5,1,   1,-1,  5,-1
	db 3
	db  0,4,   4,6,   6,0,  -1,-1
	db 4
	db  1,3,   3,1,   5,5,   7,7
	db 3
	db  2,4,   4,8,   8,2,  -1,-1
	db 3
	db  3,7,   7,9,   9,3,  -1,-1
	db 4
	db  4,8,   6,10,  8,4,  10,6
	db 3
	db  5,7,   7,11, 11,5,  -1,-1
	db 3
	db  6,10, 10,12, 12,6,  -1,-1
	db 4
	db  7,9,   9,7,  11,13, 13,11
	db 3
	db  8,10, 10,14, 14,8,  -1,-1
	db 4
	db  9,13, 13,9,   9,-1, 13,-1
	db 3
	db 10,12, 12,14, 14,10, -1,-1
	db 4
	db 11,13, 13,11, 11,-1, 13,-1
