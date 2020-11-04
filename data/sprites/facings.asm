SpriteFacingAndAnimationTable:
; This table is used for overworld sprites $1-$9.
	dw .StandingDown  ; facing down, walk animation frame 0
	dw .WalkingDown   ; facing down, walk animation frame 1
	dw .StandingDown  ; facing down, walk animation frame 2
	dw .WalkingDown2  ; facing down, walk animation frame 3
	dw .StandingUp    ; facing up, walk animation frame 0
	dw .WalkingUp     ; facing up, walk animation frame 1
	dw .StandingUp    ; facing up, walk animation frame 2
	dw .WalkingUp2    ; facing up, walk animation frame 3
	dw .StandingLeft  ; facing left, walk animation frame 0
	dw .WalkingLeft   ; facing left, walk animation frame 1
	dw .StandingLeft  ; facing left, walk animation frame 2
	dw .WalkingLeft   ; facing left, walk animation frame 3
	dw .StandingRight ; facing right, walk animation frame 0
	dw .WalkingRight  ; facing right, walk animation frame 1
	dw .StandingRight ; facing right, walk animation frame 2
	dw .WalkingRight  ; facing right, walk animation frame 3
; The rest of this table is used for sprites $a and $b.
; All orientation and animation parameters lead to the same result.
; Used for immobile sprites like items on the ground.
	dw .StandingDown
	dw .StandingDown
	dw .StandingDown
	dw .StandingDown
	dw .StandingDown
	dw .StandingDown
	dw .StandingDown
	dw .StandingDown
	dw .StandingDown
	dw .StandingDown
	dw .StandingDown
	dw .StandingDown
	dw .StandingDown
	dw .StandingDown
	dw .StandingDown
	dw .StandingDown
; special case
	dw .SpecialCase ; pikachu maybe?

; Tables used as a reference to transform OAM data.

; Format:
;	db y, x, attributes, tile index

.StandingDown:
	db 4 ; #
	db  0,  0, $00, 0
	db  0,  8, $01, 0
	db  8,  0, $02, OAMFLAG_CANBEMASKED
	db  8,  8, $03, OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA

.WalkingDown:
	db 4 ; #
	db  0,  0, $80, 0
	db  0,  8, $81, 0
	db  8,  0, $82, OAMFLAG_CANBEMASKED
	db  8,  8, $83, OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA

.WalkingDown2:
	db 4 ; #
	db  0,  8, $80, OAM_HFLIP
	db  0,  0, $81, OAM_HFLIP
	db  8,  8, $82, OAM_HFLIP | OAMFLAG_CANBEMASKED
	db  8,  0, $83, OAM_HFLIP | OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA

.StandingUp:
	db 4 ; #
	db  0,  0, $04, 0
	db  0,  8, $05, 0
	db  8,  0, $06, OAMFLAG_CANBEMASKED
	db  8,  8, $07, OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA

.WalkingUp:
	db 4 ; #
	db  0,  0, $84, 0
	db  0,  8, $85, 0
	db  8,  0, $86, OAMFLAG_CANBEMASKED
	db  8,  8, $87, OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA

.WalkingUp2:
	db 4 ; #
	db  0,  8, $84, OAM_HFLIP
	db  0,  0, $85, OAM_HFLIP
	db  8,  8, $86, OAM_HFLIP | OAMFLAG_CANBEMASKED
	db  8,  0, $87, OAM_HFLIP | OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA

.StandingLeft:
	db 4 ; #
	db  0,  0, $08, 0
	db  0,  8, $09, 0
	db  8,  0, $0a, OAMFLAG_CANBEMASKED
	db  8,  8, $0b, OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA

.WalkingLeft:
	db 4 ; #
	db  0,  0, $88, 0
	db  0,  8, $89, 0
	db  8,  0, $8a, OAMFLAG_CANBEMASKED
	db  8,  8, $8b, OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA

.StandingRight:
	db 4 ; #
	db  0,  8, $08, OAM_HFLIP
	db  0,  0, $09, OAM_HFLIP
	db  8,  8, $0a, OAM_HFLIP | OAMFLAG_CANBEMASKED
	db  8,  0, $0b, OAM_HFLIP | OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA

.WalkingRight:
	db 4 ; #
	db  0,  8, $88, OAM_HFLIP
	db  0,  0, $89, OAM_HFLIP
	db  8,  8, $8a, OAM_HFLIP | OAMFLAG_CANBEMASKED
	db  8,  0, $8b, OAM_HFLIP | OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA

.SpecialCase:
	db 9 ; #
	db -4, -4, $00, 0
	db -4,  4, $01, 0
	db -4, 12, $00, OAM_HFLIP
	db  4, -4, $01, 0
	db  4,  4, $02, 0
	db  4, 12, $01, 0
	db 12, -4, $00, OAM_VFLIP | OAMFLAG_CANBEMASKED
	db 12,  4, $01, OAMFLAG_CANBEMASKED
	db 12, 12, $00, OAM_VFLIP | OAM_HFLIP | OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA
