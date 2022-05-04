	db DEX_KABUTOPS ; pokedex id

	db  80, 115, 105,  80,  70
	;   hp  atk  def  spd  spc

	db ROCK, WATER ; type
	db 1 ; catch rate
	db 201 ; base exp

	INCBIN "gfx/pokemon/front/kabutops.pic", 0, 1 ; sprite dimensions
	dw KabutopsPicFront, KabutopsPicBack

	db DIG, BLIZZARD, BODY_SLAM, HYDRO_PUMP ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm RAZOR_WIND,   SWORDS_DANCE, MEGA_KICK,    TOXIC,        BODY_SLAM,    \
	     TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     \
	     BLIZZARD,     HYPER_BEAM,   SUBMISSION,   SEISMIC_TOSS, GIGA_DRAIN,   \
		 RAGE,         MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         \
		 SKULL_BASH,   REST,         SUBSTITUTE,   CUT,          SURF
	; end

	db 0 ; padding
