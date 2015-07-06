MistEffect_: ; f64ac (3d:64ac)
	ld hl, W_PLAYERBATTSTATUS2
	ld a, [H_WHOSETURN]
	and a
	jr z, .mistEffect
	ld hl, W_ENEMYBATTSTATUS2
.mistEffect
	bit ProtectedByMist, [hl] ; is mon protected by mist?
	jr nz, .mistAlreadyInUse
	set ProtectedByMist, [hl] ; mon is now protected by mist
	callab PlayCurrentMoveAnimation
	ld hl, ShroudedInMistText
	jp PrintText
.mistAlreadyInUse
	ld hl, PrintButItFailedText_
	ld b, BANK(PrintButItFailedText_)
	jp Bankswitch

ShroudedInMistText: ; f64d3 (3d:64d3)
	TX_FAR _ShroudedInMistText
	db "@"
