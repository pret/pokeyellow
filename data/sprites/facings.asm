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
	db  8,  0, $02, UNDER_GRASS
	db  8,  8, $03, UNDER_GRASS | FACING_END

.WalkingDown:
	db 4 ; #
	db  0,  0, $80, 0
	db  0,  8, $81, 0
	db  8,  0, $82, UNDER_GRASS
	db  8,  8, $83, UNDER_GRASS | FACING_END

.WalkingDown2:
	db 4 ; #
	db  0,  8, $80, OAM_XFLIP
	db  0,  0, $81, OAM_XFLIP
	db  8,  8, $82, OAM_XFLIP | UNDER_GRASS
	db  8,  0, $83, OAM_XFLIP | UNDER_GRASS | FACING_END

.StandingUp:
	db 4 ; #
	db  0,  0, $04, 0
	db  0,  8, $05, 0
	db  8,  0, $06, UNDER_GRASS
	db  8,  8, $07, UNDER_GRASS | FACING_END

.WalkingUp:
	db 4 ; #
	db  0,  0, $84, 0
	db  0,  8, $85, 0
	db  8,  0, $86, UNDER_GRASS
	db  8,  8, $87, UNDER_GRASS | FACING_END

.WalkingUp2:
	db 4 ; #
	db  0,  8, $84, OAM_XFLIP
	db  0,  0, $85, OAM_XFLIP
	db  8,  8, $86, OAM_XFLIP | UNDER_GRASS
	db  8,  0, $87, OAM_XFLIP | UNDER_GRASS | FACING_END

.StandingLeft:
	db 4 ; #
	db  0,  0, $08, 0
	db  0,  8, $09, 0
	db  8,  0, $0a, UNDER_GRASS
	db  8,  8, $0b, UNDER_GRASS | FACING_END

.WalkingLeft:
	db 4 ; #
	db  0,  0, $88, 0
	db  0,  8, $89, 0
	db  8,  0, $8a, UNDER_GRASS
	db  8,  8, $8b, UNDER_GRASS | FACING_END

.StandingRight:
	db 4 ; #
	db  0,  8, $08, OAM_XFLIP
	db  0,  0, $09, OAM_XFLIP
	db  8,  8, $0a, OAM_XFLIP | UNDER_GRASS
	db  8,  0, $0b, OAM_XFLIP | UNDER_GRASS | FACING_END

.WalkingRight:
	db 4 ; #
	db  0,  8, $88, OAM_XFLIP
	db  0,  0, $89, OAM_XFLIP
	db  8,  8, $8a, OAM_XFLIP | UNDER_GRASS
	db  8,  0, $8b, OAM_XFLIP | UNDER_GRASS | FACING_END

.SpecialCase:
	db 9 ; #
	db -4, -4, $00, 0
	db -4,  4, $01, 0
	db -4, 12, $00, OAM_XFLIP
	db  4, -4, $01, 0
	db  4,  4, $02, 0
	db  4, 12, $01, 0
	db 12, -4, $00, OAM_YFLIP | UNDER_GRASS
	db 12,  4, $01, UNDER_GRASS
	db 12, 12, $00, OAM_YFLIP | OAM_XFLIP | UNDER_GRASS | FACING_END
