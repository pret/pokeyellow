move_choices: MACRO
	IF _NARG
		db \# ; all args
	ENDC
	db 0 ; end
list_index += 1
ENDM

; move choice modification methods that are applied for each trainer class
TrainerClassMoveChoiceModifications:
	list_start TrainerClassMoveChoiceModifications
	move_choices 1, 2, 3, 5        ; YOUNGSTER
	move_choices 1, 2, 3, 5       ; BUG CATCHER
	move_choices 1, 2, 3, 5       ; LASS
	move_choices 1, 2, 3, 5    ; SAILOR
	move_choices 1, 2, 3, 5       ; JR_TRAINER_M
	move_choices 1, 2, 3, 5       ; JR_TRAINER_F
	move_choices 1, 2, 3 ; POKEMANIAC
	move_choices 1, 2, 3    ; SUPER_NERD
	move_choices 1, 2, 3       ; HIKER
	move_choices 1, 2, 3       ; BIKER
	move_choices 1, 2, 3    ; BURGLAR
	move_choices 1, 2, 3       ; ENGINEER
	move_choices 1, 2, 3, 5    ; UNUSED_JUGGLER
	move_choices 1, 2, 3, 5    ; FISHER
	move_choices 1, 2, 3, 5    ; SWIMMER
	move_choices 1, 2, 3        ; CUE_BALL
	move_choices 1, 2, 3       ; GAMBLER
	move_choices 1, 2, 3, 5    ; BEAUTY
	move_choices 1, 2, 3, 4, 5    ; PSYCHIC_TR
	move_choices 1, 2, 3       ; ROCKER
	move_choices 1, 2, 3       ; JUGGLER
	move_choices 1, 2, 3, 5       ; TAMER
	move_choices 1, 2, 3, 5       ; BIRD_KEEPER
	move_choices 1, 2, 3, 5       ; BLACKBELT
	move_choices 1, 2, 3       ; RIVAL1
	move_choices 1, 2, 3, 4, 5    ; PROF_OAK
	move_choices 1, 2, 3, 4, 5    ; CHIEF
	move_choices 1, 2, 3    ; SCIENTIST
	move_choices 1, 2, 3, 4, 5    ; GIOVANNI
	move_choices 1, 2, 3       ; ROCKET
	move_choices 1, 2, 3, 5    ; COOLTRAINER_M
	move_choices 1, 2, 3, 5    ; COOLTRAINER_F
	move_choices 1, 2, 3, 4, 5       ; BRUNO
	move_choices 1, 2, 3, 5       ; BROCK
	move_choices 1, 2, 3, 4, 5    ; MISTY
	move_choices 1, 2, 3, 4, 5       ; LT_SURGE
	move_choices 1, 2, 3, 4, 5    ; ERIKA
	move_choices 1, 2, 3, 4, 5    ; KOGA
	move_choices 1, 2, 3, 4, 5       ; BLAINE
	move_choices 1, 2, 3, 4, 5       ; SABRINA
	move_choices 1, 2, 3, 5    ; GENTLEMAN
	move_choices 1, 2, 3, 5    ; RIVAL2
	move_choices 1, 2, 3, 4, 5    ; RIVAL3
	move_choices 1, 2, 3, 4, 5 ; LORELEI
	move_choices 1, 2, 3       ; CHANNELER
	move_choices 1, 2, 3, 4, 5       ; AGATHA
	move_choices 1, 2, 3, 4, 5    ; LANCE
	assert_list_length NUM_TRAINERS
