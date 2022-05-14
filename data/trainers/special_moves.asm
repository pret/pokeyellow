; Yellow entry format:
;	db trainerclass, trainerid
;	repeat { db partymon location, partymon move, move id }
;	db 0

SpecialTrainerMoves:
	db YOUNGSTER, 11
	db 2, 1, BODY_SLAM
	db 2, 2, EARTHQUAKE
	db 0

	db YOUNGSTER, 12
	db 3, 3, FISSURE
	db 3, 4, NO_MOVE
	db 0

	db BUG_CATCHER, 3
	db 1, 1, CONFUSION
	db 0

	db BUG_CATCHER, 4
	db 1, 2, MEGA_DRAIN
	db 0

	db BUG_CATCHER, 6
	db 1, 2, MEGA_DRAIN
	db 0

	db BUG_CATCHER, 8
	db 2, 3, FISSURE
	db 2, 4, NO_MOVE

	db LASS, 5
	db 1, 1, METRONOME
	db 1, 2, HYPNOSIS
	db 1, 3, NO_MOVE
	db 1, 4, NO_MOVE
	db 0

	db JR_TRAINER_M, 5
	db 1, 4, RECOVER
	db 0

	db SUPER_NERD, 1
	db 1, 1, EXPLOSION
	db 2, 1, THUNDERBOLT
	db 0

	db SUPER_NERD, 2
	db 1, 2, THUNDERBOLT
	db 0

	db RIVAL1, 2
	db 1, 3, NO_MOVE
	db 2, 3, NO_MOVE

	db BROCK, 1
	db 3, 2, KARATE_CHOP
	db 0

	db -1 ; end
