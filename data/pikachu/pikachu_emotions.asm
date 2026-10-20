PikachuEmotion0:
	db $ff

PikachuEmotionExcited:
	pikaemotion_dummy2
	pikaemotion_emotebubble SMILE_BUBBLE
	pikaemotion_pcm PikachuCry35
	pikaemotion_pikapic PikaPicAnimScript_Excited
	db $ff

PikachuEmotionJoy:
	pikaemotion_dummy2
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADEXTRAPIKASPRITES
	pikaemotion_emotebubble HEART_BUBBLE
	pikaemotion_pcm PikachuCry5
	pikaemotion_pikapic PikaPicAnimScript_Joy
	db $ff

PikachuEmotionJump:
	pikaemotion_dummy2
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADEXTRAPIKASPRITES
	pikaemotion_movement PikachuMovementData_FastJump
	pikaemotion_pcm PikachuCry1
	pikaemotion_movement PikachuMovementData_FastJump
	pikaemotion_pikapic PikaPicAnimScript_Jump
	db $ff

PikachuEmotionHappy:
	pikaemotion_dummy2
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADEXTRAPIKASPRITES
	pikaemotion_movement PikachuMovementData_Jump
	pikaemotion_pcm PikachuCry29
	pikaemotion_pikapic PikaPicAnimScript_Happy
	db $ff

PikachuEmotionBlink:
	pikaemotion_dummy2
	pikaemotion_pcm
	pikaemotion_pikapic PikaPicAnimScript_Blink2
	db $ff

PikachuEmotionSmile:
	pikaemotion_dummy2
	pikaemotion_pcm PikachuCry39
	pikaemotion_pikapic PikaPicAnimScript_Smile
	db $ff

PikachuEmotionSad:
	pikaemotion_dummy2
	pikaemotion_pcm PikachuCry31
	pikaemotion_pikapic PikaPicAnimScript_Sad
	db $ff

PikachuEmotionSideBlink:
	pikaemotion_dummy2
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADEXTRAPIKASPRITES
	pikaemotion_pcm
	pikaemotion_movement PikachuMovementData_TurnToSide
	pikaemotion_emotebubble SKULL_BUBBLE
	pikaemotion_pikapic PikaPicAnimScript_SideBlink
	db $ff

PikachuEmotionEarTwitch:
	pikaemotion_dummy2
	pikaemotion_pcm PikachuCry40
	pikaemotion_pikapic PikaPicAnimScript_EarTwitch
	db $ff

PikachuEmotionBackTurn:
	pikaemotion_dummy2
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADEXTRAPIKASPRITES
	pikaemotion_pcm PikachuCry6
	pikaemotion_movement PikachuMovementData_TurnAwayFromPlayer
	pikaemotion_emotebubble SKULL_BUBBLE
	pikaemotion_pikapic PikaPicAnimScript_BackTurn
	db $ff

PikachuEmotionSleep:
	pikaemotion_emotebubble ZZZ_BUBBLE
	pikaemotion_pcm PikachuCry37
	pikaemotion_pikapic PikaPicAnimScript_Sleep
	db $ff

PikachuEmotionBored:
	pikaemotion_dummy2
	pikaemotion_pcm
	pikaemotion_pikapic PikaPicAnimScript_Bored
	db $ff

PikachuEmotionSide:
	pikaemotion_dummy2
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADEXTRAPIKASPRITES
	pikaemotion_movement PikachuMovementData_TurnToSide
	pikaemotion_pikapic PikaPicAnimScript_Side
	db $ff

PikachuEmotionAngryBolt:
	pikaemotion_dummy2
	pikaemotion_emotebubble BOLT_BUBBLE
	pikaemotion_pcm PikachuCry10
	pikaemotion_pikapic PikaPicAnimScript_AngryBolt
	db $ff

PikachuEmotionFistPump:
	pikaemotion_dummy2
	pikaemotion_pcm PikachuCry34
	pikaemotion_pikapic PikaPicAnimScript_FistPump
	db $ff

PikachuEmotionHeart:
	pikaemotion_dummy2
	pikaemotion_pcm PikachuCry33
	pikaemotion_pikapic PikaPicAnimScript_Heart
	db $ff

PikachuEmotionMad:
	pikaemotion_dummy2
	pikaemotion_pcm PikachuCry13
	pikaemotion_pikapic PikaPicAnimScript_Mad
	db $ff

PikachuEmotionWink:
	pikaemotion_dummy2
	pikaemotion_pcm
	pikaemotion_pikapic PikaPicAnimScript_Wink
	db $ff

PikachuEmotion2Hearts:
	pikaemotion_dummy2
	pikaemotion_emotebubble HEART_BUBBLE
	pikaemotion_pcm PikachuCry33
	pikaemotion_pikapic PikaPicAnimScript_2Hearts
	db $ff

PikachuEmotionLove:
	pikaemotion_dummy2
	pikaemotion_emotebubble HEART_BUBBLE
	pikaemotion_pcm PikachuCry5
	pikaemotion_pikapic PikaPicAnimScript_Love
	db $ff

PikachuEmotionBucket:
	pikaemotion_dummy2
	pikaemotion_emotebubble FISH_BUBBLE
	pikaemotion_pcm
	pikaemotion_pikapic PikaPicAnimScript_Bucket
	db $ff

PikachuEmotionScared:
	pikaemotion_dummy2
	pikaemotion_pcm PikachuCry4
	pikaemotion_pikapic PikaPicAnimScript_Scared
	db $ff

PikachuEmotionConfused:
	pikaemotion_dummy2
	pikaemotion_pcm PikachuCry19
	pikaemotion_pikapic PikaPicAnimScript_Confused
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_SHOWMAPVIEW
	db $ff

PikachuEmotionHeadShake:
	pikaemotion_dummy2
	pikaemotion_emotebubble EXCLAMATION_BUBBLE
	pikaemotion_pcm
	pikaemotion_pikapic PikaPicAnimScript_HeadShake
	db $ff

PikachuEmotionLightning:
	pikaemotion_dummy2
	pikaemotion_emotebubble BOLT_BUBBLE
	pikaemotion_pcm PikachuCry35
	pikaemotion_pikapic PikaPicAnimScript_Lightning
	db $ff

PikachuEmotionWakeUp:
	pikaemotion_dummy2
	pikaemotion_emotebubble ZZZ_BUBBLE
	pikaemotion_pcm PikachuCry37
	pikaemotion_pikapic PikaPicAnimScript_WakeUp
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_SHOWMAPVIEW
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_CHECKPEWTERCENTER
	db $ff

PikachuEmotionSurprised:
	pikaemotion_dummy2
	pikaemotion_pcm PikachuCry9
	pikaemotion_pikapic PikaPicAnimScript_Surprised
	db $ff

PikachuEmotionCry:
	pikaemotion_dummy2
	pikaemotion_pcm PikachuCry15
	pikaemotion_pikapic PikaPicAnimScript_Cry
	db $ff

PikachuEmotionJoy2:
	pikaemotion_pcm PikachuCry5
	pikaemotion_pikapic PikaPicAnimScript_Joy
	db $ff

PikachuEmotionLove2:
	pikaemotion_9
	pikaemotion_emotebubble HEART_BUBBLE
	pikaemotion_pcm PikachuCry5
	pikaemotion_pikapic PikaPicAnimScript_Love
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_SHOWMAPVIEW
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADFONT
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_CHECKLAVENDERTOWER
	db $ff

PikachuEmotionConfused2:
	pikaemotion_pcm PikachuCry19
	pikaemotion_pikapic PikaPicAnimScript_Confused
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_SHOWMAPVIEW
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_CHECKBILLSHOUSE
	db $ff

PikachuEmotionConfused3:
	pikaemotion_pcm PikachuCry26
	pikaemotion_pikapic PikaPicAnimScript_Confused
	db $ff

PikachuMovementData_TurnAwayFromPlayer:
	db $00
	db $39,  2 - 1
	db $3e, 31 - 1
	db $3f

PikachuMovementData_TurnToSide:
	db $00
	db $39,  1 - 1
	db $3e, 31 - 1
	db $3f

PikachuMovementData_FastJump:
	db $00
	db $3c, 8 - 1, (2 << 4) | (16 - 1)
	db $3c, 8 - 1, (2 << 4) | (16 - 1)
	db $3f

PikachuMovementData_Spin:
	db $3b, 32 - 1, 4 - 1
	db $3f

PikachuMovementData_Jump:
	db $00
	db $3c, 16 - 1, (1 << 4) | (16 - 1)
	db $3c, 16 - 1, (1 << 4) | (16 - 1)
	db $3f

PikachuMovementData_fd238: ; unused
	db $00
	db $05, 8 - 1
	db $39, 1 - 1
	db $05, 8 - 1
	db $06, 8 - 1
	db $39, 1 - 1
	db $06, 8 - 1
	db $08, 8 - 1
	db $39, 1 - 1
	db $08, 8 - 1
	db $07, 8 - 1
	db $39, 1 - 1
	db $07, 8 - 1
	db $3f
