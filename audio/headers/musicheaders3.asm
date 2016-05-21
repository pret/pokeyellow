Music_TitleScreen:: ; 7c249 (1f:4249)
	dbw ( $C0 | CH0 ), Music_TitleScreen_Ch1
	dbw CH1, Music_TitleScreen_Ch2
	dbw CH2, Music_TitleScreen_Ch3
	dbw CH3, Music_TitleScreen_Ch4

Music_Credits:: ; 7c255 (1f:4255)
	dbw ( $80 | CH0 ), Music_Credits_Ch1
	dbw CH1, Music_Credits_Ch2
	dbw CH2, Music_Credits_Ch3

Music_HallOfFame:: ; 7c25e (1f:425e)
	dbw ( $80 | CH0 ), Music_HallOfFame_Ch1
	dbw CH1, Music_HallOfFame_Ch2
	dbw CH2, Music_HallOfFame_Ch3

Music_OaksLab:: ; 7c267 (1f:4267)
	dbw ( $80 | CH0 ), Music_OaksLab_Ch1
	dbw CH1, Music_OaksLab_Ch2
	dbw CH2, Music_OaksLab_Ch3

Music_JigglypuffSong:: ; 7c270 (1f:4270)
	dbw $40, Music_JigglypuffSong_Ch1
	dbw CH1, Music_JigglypuffSong_Ch2

Music_BikeRiding:: ; 7c276 (1f:4276)
	dbw ( $C0 | CH0 ), Music_BikeRiding_Ch1
	dbw CH1, Music_BikeRiding_Ch2
	dbw CH2, Music_BikeRiding_Ch3
	dbw CH3, Music_BikeRiding_Ch4

Music_Surfing:: ; 7c282 (1f:4282)
	dbw ( $80 | CH0 ), Music_Surfing_Ch1
	dbw CH1, Music_Surfing_Ch2
	dbw CH2, Music_Surfing_Ch3

Music_GameCorner:: ; 7c28b (1f:428b)
	dbw ( $80 | CH0 ), Music_GameCorner_Ch1
	dbw CH1, Music_GameCorner_Ch2
	dbw CH2, Music_GameCorner_Ch3

Music_IntroBattle:: ; 7c294 (1f:4294)
	dbw ( $80 | CH0 ), Music_YellowIntro_Ch1
	dbw CH1, Music_YellowIntro_Ch2
	dbw CH2, Music_YellowIntro_Ch3

; Power Plant, Unknown Dungeon, Rocket HQ
Music_Dungeon1:: ; 7c2a0 (1f:42a0)
	dbw ( $C0 | CH0 ), Music_Dungeon1_Ch1
	dbw CH1, Music_Dungeon1_Ch2
	dbw CH2, Music_Dungeon1_Ch3
	dbw CH3, Music_Dungeon1_Ch4

; Viridian Forest, Seafoam Islands
Music_Dungeon2:: ; 7c2ac (1f:42ac)
	dbw ( $C0 | CH0 ), Music_Dungeon2_Ch1
	dbw CH1, Music_Dungeon2_Ch2
	dbw CH2, Music_Dungeon2_Ch3
	dbw CH3, Music_Dungeon2_Ch4

; Mt. Moon, Rock Tunnel, Victory Road
Music_Dungeon3:: ; 7c2b8 (1f:42b8)
	dbw ( $C0 | CH0 ), Music_Dungeon3_Ch1
	dbw CH1, Music_Dungeon3_Ch2
	dbw CH2, Music_Dungeon3_Ch3
	dbw CH3, Music_Dungeon3_Ch4

Music_CinnabarMansion:: ; 7c2c4 (1f:42c4)
	dbw ( $C0 | CH0 ), Music_CinnabarMansion_Ch1
	dbw CH1, Music_CinnabarMansion_Ch2
	dbw CH2, Music_CinnabarMansion_Ch3
	dbw CH3, Music_CinnabarMansion_Ch4

Music_PokemonTower:: ; 7c2d0 (1f:42d0)
	dbw ( $80 | CH0 ), Music_PokemonTower_Ch1
	dbw CH1, Music_PokemonTower_Ch2
	dbw CH2, Music_PokemonTower_Ch3

Music_SilphCo:: ; 7c2d9 (1f:42d9)
	dbw ( $80 | CH0 ), Music_SilphCo_Ch1
	dbw CH1, Music_SilphCo_Ch2
	dbw CH2, Music_SilphCo_Ch3

Music_MeetEvilTrainer:: ; 7c2e2 (1f:42e2)
	dbw ( $80 | CH0 ), Music_MeetEvilTrainer_Ch1
	dbw CH1, Music_MeetEvilTrainer_Ch2
	dbw CH2, Music_MeetEvilTrainer_Ch3

Music_MeetFemaleTrainer:: ; 7c2eb (1f:42eb)
	dbw ( $80 | CH0 ), Music_MeetFemaleTrainer_Ch1
	dbw CH1, Music_MeetFemaleTrainer_Ch2
	dbw CH2, Music_MeetFemaleTrainer_Ch3

Music_MeetMaleTrainer:: ; 7c2f4 (1f:42f4)
	dbw ( $80 | CH0 ), Music_MeetMaleTrainer_Ch1
	dbw CH1, Music_MeetMaleTrainer_Ch2
	dbw CH2, Music_MeetMaleTrainer_Ch3
