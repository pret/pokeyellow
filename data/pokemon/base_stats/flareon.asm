	db DEX_FLAREON ; pokedex id

	db 100, 130,  95,  85, 110
	;   hp  atk  def  spd  spc

	db FIRE, FIRE ; type
	db 1 ; catch rate
	db 198 ; base exp

	INCBIN "gfx/pokemon/front/flareon.pic", 0, 1 ; sprite dimensions
	dw FlareonPicFront, FlareonPicBack

	db FLAMETHROWER, DIG, BODY_SLAM, SAND_ATTACK ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   \
	     RAGE,         SOLARBEAM,    MIMIC,        DOUBLE_TEAM,  REFLECT,	   \      
		 BIDE,         FIRE_BLAST,   SWIFT,        SKULL_BASH,   REST,         \
		 SUBSTITUTE,   STRENGTH
	; end

	db 0 ; padding
