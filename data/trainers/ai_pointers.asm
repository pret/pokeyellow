TrainerAIPointers:
	table_width 3, TrainerAIPointers
	; one entry per trainer class
	; first byte, number of times (per Pokémon) it can occur
	; next two bytes, pointer to AI subroutine for trainer class
	; subroutines are defined in engine/battle/trainer_ai.asm
	dbw 255, GenericAI
	dbw 255, GenericAI
	dbw 255, GenericAI
	dbw 255, GenericAI
	dbw 255, GenericAI
	dbw 255, GenericAI
	dbw 255, GenericAI
	dbw 255, GenericAI
	dbw 255, GenericAI
	dbw 255, GenericAI
	dbw 255, GenericAI
	dbw 255, GenericAI
	dbw 255, JugglerAI ; unused_juggler
	dbw 255, GenericAI
	dbw 255, GenericAI
	dbw 255, GenericAI
	dbw 255, GenericAI
	dbw 255, GenericAI
	dbw 255, GenericAI
	dbw 255, GenericAI
	dbw 255, JugglerAI ; juggler
	dbw 255, GenericAI
	dbw 255, GenericAI
	dbw 255, GenericAI 
	dbw 255, GenericAI ; rival1
	dbw 255, GenericAI
	dbw 255, GenericAI ; chief
	dbw 255, GenericAI
	dbw 255, BrockAI ; giovanni
	dbw 255, GenericAI
	dbw 255, BrockAI ;cooltrainerm
	dbw 255, BrockAI ;cooltrainerf
	dbw 255, BrockAI ; bruno
	dbw 255, BrockAI ; brock
	dbw 255, BrockAI ; misty
	dbw 255, BrockAI ; surge
	dbw 255, BrockAI ; erika
	dbw 255, BrockAI ; koga
	dbw 255, BrockAI ; blaine
	dbw 255, BrockAI ; sabrina
	dbw 255, GenericAI
	dbw 255, GenericAI ; rival2
	dbw 255, BrockAI ; rival3
	dbw 255, BrockAI ; lorelei
	dbw 255, GenericAI
	dbw 255, BrockAI ; agatha
	dbw 255, BrockAI ; lance
	assert_table_length NUM_TRAINERS
