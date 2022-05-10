	db DEX_ELECTABUZZ ; pokedex id

	db  75, 123,  67, 110,  95
	;   hp  atk  def  spd  spc

	db ELECTRIC, ELECTRIC ; type
	db 1 ; catch rate
	db 156 ; base exp

	INCBIN "gfx/pokemon/front/electabuzz.pic", 0, 1 ; sprite dimensions
	dw ElectabuzzPicFront, ElectabuzzPicBack

	db THUNDERBOLT, BODY_SLAM, SUBMISSION, EARTHQUAKE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  HYPER_BEAM,   SUBMISSION,   COUNTER,      SEISMIC_TOSS, \
	     RAGE,         THUNDERBOLT,  THUNDER,      EARTHQUAKE,   PSYCHIC_M,    \    
		 TELEPORT,     MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         \        
		 METRONOME,    SWIFT,        SKULL_BASH,   REST,         THUNDER_WAVE, \
		 PSYWAVE,      SUBSTITUTE,   STRENGTH,     FLASH
	; end

	db 0 ; padding
