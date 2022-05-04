	db DEX_SEAKING ; pokedex id

	db  80,  92,  65,  68,  80
	;   hp  atk  def  spd  spc

	db WATER, WATER ; type
	db 30 ; catch rate
	db 170 ; base exp

	INCBIN "gfx/pokemon/front/seaking.pic", 0, 1 ; sprite dimensions
	dw SeakingPicFront, SeakingPicBack

	db BUBBLEBEAM, HORN_DRILL, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        HORN_DRILL,   BODY_SLAM,	   TAKE_DOWN,    DOUBLE_EDGE,  \
		 BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     HYPER_BEAM,   \
		 RAGE,         MIMIC,        DOUBLE_TEAM,  BIDE,         SWIFT,        \
		 SKULL_BASH,   REST,         SUBSTITUTE,   SURF
	; end

	db 0 ; padding
