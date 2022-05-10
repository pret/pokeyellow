	db DEX_VENONAT ; pokedex id

	db  60,  55,  50,  65,  65
	;   hp  atk  def  spd  spc

	db BUG, POISON ; type
	db 255 ; catch rate
	db 75 ; base exp

	INCBIN "gfx/pokemon/front/venonat.pic", 0, 1 ; sprite dimensions
	dw VenonatPicFront, VenonatPicBack

	db TOXIC, PSYBEAM, STUN_SPORE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  RAGE,         GIGA_DRAIN,   \
	     SOLARBEAM,    PSYCHIC_M,    MIMIC,        DOUBLE_TEAM,  REFLECT,      \
	     BIDE,         REST,         PSYWAVE,      SUBSTITUTE,   FLASH
	; end

	db 0 ; padding
