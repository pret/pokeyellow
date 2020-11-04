SpriteFacingAndAnimationTable:
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
	dw SpriteSpecialCase ; pikachu maybe?

.StandingDown:
	db $04
; Sprite OAM Parameters
	db $00, $00, $00, $00                                      ; top left
	db $00, $08, $01, $00                                      ; top right
	db $08, $00, $02, OAMFLAG_CANBEMASKED                      ; bottom left
	db $08, $08, $03, OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA  ; bottom right

.WalkingDown:
	db $04
; Sprite OAM Parameters
	db $00, $00, $80, $00                                      ; top left
	db $00, $08, $81, $00                                      ; top right
	db $08, $00, $82, OAMFLAG_CANBEMASKED                      ; bottom left
	db $08, $08, $83, OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA  ; bottom right

.WalkingDown2:
	db $04
; Sprite OAM Parameters
	db $00, $08, $80, OAM_HFLIP                                           ; top left
	db $00, $00, $81, OAM_HFLIP                                           ; top right
	db $08, $08, $82, OAM_HFLIP | OAMFLAG_CANBEMASKED                     ; bottom left
	db $08, $00, $83, OAM_HFLIP | OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA ; bottom right

.StandingUp:
	db $04
; Sprite OAM Parameters
	db $00, $00, $04, $00                                      ; top left
	db $00, $08, $05, $00                                      ; top right
	db $08, $00, $06, OAMFLAG_CANBEMASKED                      ; bottom left
	db $08, $08, $07, OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA  ; bottom right

.WalkingUp:
	db $04
; Sprite OAM Parameters
	db $00, $00, $84, $00                                      ; top left
	db $00, $08, $85, $00                                      ; top right
	db $08, $00, $86, OAMFLAG_CANBEMASKED                      ; bottom left
	db $08, $08, $87, OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA  ; bottom right

.WalkingUp2:
	db $04
; Sprite OAM Parameters
	db $00, $08, $84, OAM_HFLIP                                           ; top left
	db $00, $00, $85, OAM_HFLIP                                           ; top right
	db $08, $08, $86, OAM_HFLIP | OAMFLAG_CANBEMASKED                     ; bottom left
	db $08, $00, $87, OAM_HFLIP | OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA ; bottom right

.StandingLeft:
	db $04
; Sprite OAM Parameters
	db $00, $00, $08, $00                                      ; top left
	db $00, $08, $09, $00                                      ; top right
	db $08, $00, $0a, OAMFLAG_CANBEMASKED                      ; bottom left
	db $08, $08, $0b, OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA  ; bottom right

.WalkingLeft:
	db $04
; Sprite OAM Parameters
	db $00, $00, $88, $00                                      ; top left
	db $00, $08, $89, $00                                      ; top right
	db $08, $00, $8a, OAMFLAG_CANBEMASKED                      ; bottom left
	db $08, $08, $8b, OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA  ; bottom right

.StandingRight:
	db $04
; Sprite OAM Parameters
	db $00, $08, $08, OAM_HFLIP                                           ; top left
	db $00, $00, $09, OAM_HFLIP                                           ; top right
	db $08, $08, $0a, OAM_HFLIP | OAMFLAG_CANBEMASKED                     ; bottom left
	db $08, $00, $0b, OAM_HFLIP | OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA ; bottom right

.WalkingRight:
	db $04
; Sprite OAM Parameters
	db $00, $08, $88, OAM_HFLIP                                           ; top left
	db $00, $00, $89, OAM_HFLIP                                           ; top right
	db $08, $08, $8a, OAM_HFLIP | OAMFLAG_CANBEMASKED                     ; bottom left
	db $08, $00, $8b, OAM_HFLIP | OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA ; bottom right

SpriteSpecialCase:
	db $09
; Sprite OAM Parameters
	db -$4, -$4, $00, $00
	db -$4, $04, $01, $00
	db -$4, $0c, $00, OAM_HFLIP
	db $04, -$4, $01, $00
	db $04, $04, $02, $00
	db $04, $0c, $01, $00
	db $0c, -$4, $00, OAM_VFLIP | OAMFLAG_CANBEMASKED
	db $0c, $04, $01, OAMFLAG_CANBEMASKED
	db $0c, $0c, $00, OAM_VFLIP | OAM_HFLIP | OAMFLAG_CANBEMASKED | OAMFLAG_ENDOFDATA
