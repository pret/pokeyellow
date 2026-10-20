PikaPicAnimThunderboltPals:
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db 4, %11000000
	db 4, %11100100
	db -1 ; end

PikaPicAnimScript_Unused1: ; unreferenced
	pikapic_loadgfx PikachuBlink1Pic
	pikapic_loadgfx PikachuSmile1Pic
	pikapic_loadgfx PikachuSprite
	pikapic_animation PikaPicAnimBGFrames_1, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_2, $b2, $5, $5
	pikapic_animation PikaPicAnimBGFrames_3, $b6, $5, $5
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript_Blink1:
PikaPicAnimScript_Blink2:
PikaPicAnimScript_Blink3:
	pikapic_setduration 40
	pikapic_loadgfx PikachuBlink1Pic
	pikapic_loadgfx PikachuBlink2GFX
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_6, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry PikachuCry3
	pikapic_looptofinish

PikaPicAnimScript_Excited:
	pikapic_setduration 44
	pikapic_loadgfx PikachuExcited1Pic
	pikapic_loadgfx PikachuExcited2GFX
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_7, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript_EarTwitch:
	pikapic_setduration 80
	pikapic_loadgfx PikachuEarTwitch1Pic
	pikapic_loadgfx PikachuEarTwitch2GFX
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_8, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript_Happy:
	pikapic_setduration 70
	pikapic_loadgfx PikachuHappy1Pic
	pikapic_loadgfx PikachuHappy2GFX
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_9, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript_Sad:
	pikapic_setduration 32
	pikapic_loadgfx PikachuSad1Pic
	pikapic_loadgfx PikachuSad2GFX
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_10, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript_SideBlink:
	pikapic_setduration 50
	pikapic_loadgfx PikachuSideBlink1Pic
	pikapic_loadgfx PikachuSideBlink2GFX
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_11, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry PikachuCry38
	pikapic_looptofinish

PikaPicAnimScript_Jump:
	pikapic_setduration 58
	pikapic_loadgfx PikachuJump1Pic
	pikapic_loadgfx PikachuJump2GFX
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_12, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript_Smile:
	pikapic_setduration 44
	pikapic_loadgfx PikachuSmile1Pic
	pikapic_loadgfx PikachuSmile2GFX
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_13, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript_BackTurn:
	pikapic_setduration 56
	pikapic_loadgfx PikachuBackTurn1Pic
	pikapic_loadgfx PikachuBackTurn2GFX
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_14, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript_Joy:
	pikapic_setduration 56
	pikapic_loadgfx PikachuJoy1Pic
	pikapic_loadgfx PikachuJoy2GFX
	pikapic_loadgfx PikachuJoy3GFX
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_16, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript_Sleep:
	pikapic_setduration 100
	pikapic_loadgfx PikachuSleep1Pic
	pikapic_loadgfx PikachuSleep2GFX
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_17, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript_Bored:
	pikapic_setduration 50
	pikapic_loadgfx PikachuBored1Pic
	pikapic_loadgfx PikachuBored2GFX
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_18, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry PikachuCry25
	pikapic_looptofinish

PikaPicAnimScript_Side:
	pikapic_setduration 50
	pikapic_loadgfx PikachuSide1Pic
	pikapic_loadgfx PikachuSide2GFX
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_19, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript_AngryBolt:
	pikapic_setduration 40
	pikapic_loadgfx PikachuAngryBolt1Pic
	pikapic_loadgfx PikachuAngryBolt2GFX
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_20, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript_FistPump:
	pikapic_setduration 50
	pikapic_loadgfx PikachuFistPump1Pic
	pikapic_loadgfx PikachuFistPump2GFX
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_21, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript_Heart:
	pikapic_setduration 32
	pikapic_loadgfx PikachuHeart1Pic
	pikapic_loadgfx PikachuHeart2GFX
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_22, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript_Mad:
	pikapic_setduration 100
	pikapic_loadgfx PikachuMad1Pic
	pikapic_loadgfx PikachuMad2GFX
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_23, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript_Wink:
	pikapic_setduration 32
	pikapic_loadgfx PikachuWink1GFX
	pikapic_loadgfx PikachuWink2GFX
	pikapic_animation PikaPicAnimBGFrames_5, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_24, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry PikachuCry18
	pikapic_looptofinish

PikaPicAnimScript_2Hearts:
	pikapic_setduration 44
	pikapic_loadgfx Pikachu2Hearts1Pic
	pikapic_loadgfx Pikachu2Hearts2GFX
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_25, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript_Love:
	pikapic_setduration 50
	pikapic_loadgfx PikachuLove1Pic
	pikapic_loadgfx PikachuLove2GFX
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_26, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript_Bucket:
	pikapic_setduration 40
	pikapic_loadgfx PikachuBucket1Pic
	pikapic_loadgfx PikachuBucket2GFX
	pikapic_loadgfx PikachuBucket3GFX
	pikapic_loadgfx PikachuBucket4GFX
	pikapic_loadgfx PikachuBucket5GFX
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_27, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry PikachuCry20
	pikapic_looptofinish

PikaPicAnimScript_Scared:
	pikapic_setduration 40
	pikapic_loadgfx PikachuScared1GFX
	pikapic_loadgfx PikachuScared2GFX
	pikapic_animation PikaPicAnimBGFrames_5, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_28, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript_Confused:
	pikapic_setduration 70
	pikapic_loadgfx PikachuConfused1GFX
	pikapic_loadgfx PikachuConfused2GFX
	pikapic_animation PikaPicAnimBGFrames_5, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_29, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript_HeadShake:
	pikapic_setduration 60
	pikapic_loadgfx PikachuHeadShake1GFX
	pikapic_loadgfx PikachuHeadShake2GFX
	pikapic_animation PikaPicAnimBGFrames_5, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_30, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript_Lightning:
	pikapic_setduration 50
	pikapic_loadgfx PikachuLightning1Pic
	pikapic_loadgfx PikachuLightning2GFX
	pikapic_loadgfx PikachuLightning3GFX
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_31, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_writebyte 13
	pikapic_waitbgmap
	pikapic_thunderbolt
	pikapic_ret

PikaPicAnimScript_Unused2: ; unreferenced
	pikapic_waitbgmap
PikaPicAnimScript_WakeUp:
	pikapic_setduration 100
	pikapic_loadgfx PikachuSleep1Pic
	pikapic_loadgfx PikachuSleep2GFX
	pikapic_loadgfx PikachuWakeUp1GFX
	pikapic_loadgfx PikachuWakeUp2GFX
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_32, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript_Surprised:
	pikapic_setduration 30
	pikapic_loadgfx PikachuSurprised1Pic
	pikapic_loadgfx PikachuSurprised2GFX
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_33, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

PikaPicAnimScript_Cry:
	pikapic_setduration 64
	pikapic_loadgfx PikachuCry1Pic
	pikapic_loadgfx PikachuCry2GFX
	pikapic_animation PikaPicAnimBGFrames_4, $80, $0, $0
	pikapic_animation PikaPicAnimBGFrames_34, $99, $0, $0
	pikapic_waitbgmap
	pikapic_cry
	pikapic_looptofinish

MACRO pikapicanimgfx
	IF _NARG == 2
	\2_id::
		db \1  ; size (-1 if compressed)
		dba \2 ; pointer
	ELSE
		db \1 ; size
		dbw \2, \3 ; bank, address
	ENDC
ENDM

PikaPicAnimGFXHeaders:
	pikapicanimgfx  1, $39, NULL              ; 00
	pikapicanimgfx -1, PikachuBlink1Pic       ; 01
	pikapicanimgfx  5, PikachuBlink2GFX       ; 02
	pikapicanimgfx -1, PikachuExcited1Pic     ; 03
	pikapicanimgfx 10, PikachuExcited2GFX     ; 04
	pikapicanimgfx -1, PikachuEarTwitch1Pic   ; 05
	pikapicanimgfx  6, PikachuEarTwitch2GFX   ; 06
	pikapicanimgfx -1, PikachuHappy1Pic       ; 07
	pikapicanimgfx 20, PikachuHappy2GFX       ; 08
	pikapicanimgfx -1, PikachuSad1Pic         ; 09
	pikapicanimgfx  4, PikachuSad2GFX         ; 0a
	pikapicanimgfx -1, PikachuSideBlink1Pic   ; 0b
	pikapicanimgfx  4, PikachuSideBlink2GFX   ; 0c
	pikapicanimgfx -1, PikachuJump1Pic         ; 0d
	pikapicanimgfx 25, PikachuJump2GFX         ; 0e
	pikapicanimgfx -1, PikachuSmile1Pic       ; 0f
	pikapicanimgfx 10, PikachuSmile2GFX       ; 00
	pikapicanimgfx -1, PikachuBackTurn1Pic    ; 11
	pikapicanimgfx  6, PikachuBackTurn2GFX    ; 12
	pikapicanimgfx -1, PikachuJoy1Pic         ; 13
	pikapicanimgfx 25, PikachuJoy2GFX         ; 14
	pikapicanimgfx 25, PikachuJoy3GFX         ; 15
	pikapicanimgfx -1, PikachuSleep1Pic       ; 16
	pikapicanimgfx 25, PikachuSleep2GFX       ; 17
	pikapicanimgfx -1, PikachuBored1Pic       ; 18
	pikapicanimgfx 25, PikachuBored2GFX       ; 19
	pikapicanimgfx -1, PikachuSide1Pic        ; 1a
	pikapicanimgfx 25, PikachuSide2GFX        ; 1b
	pikapicanimgfx -1, PikachuAngryBolt1Pic   ; 1c
	pikapicanimgfx 25, PikachuAngryBolt2GFX   ; 1d
	pikapicanimgfx -1, PikachuFistPump1Pic    ; 1e
	pikapicanimgfx 25, PikachuFistPump2GFX    ; 1f
	pikapicanimgfx -1, PikachuHeart1Pic       ; 20
	pikapicanimgfx 25, PikachuHeart2GFX       ; 21
	pikapicanimgfx -1, PikachuMad1Pic         ; 22
	pikapicanimgfx 25, PikachuMad2GFX         ; 23
	pikapicanimgfx 25, PikachuWink1GFX        ; 24
	pikapicanimgfx 25, PikachuWink2GFX        ; 25
	pikapicanimgfx -1, Pikachu2Hearts1Pic     ; 26
	pikapicanimgfx 25, Pikachu2Hearts2GFX     ; 27
	pikapicanimgfx -1, PikachuLove1Pic        ; 28
	pikapicanimgfx 25, PikachuLove2GFX        ; 29
	pikapicanimgfx -1, PikachuBucket1Pic      ; 2a
	pikapicanimgfx 25, PikachuBucket2GFX      ; 2b
	pikapicanimgfx 25, PikachuBucket3GFX      ; 2c
	pikapicanimgfx 25, PikachuBucket4GFX      ; 2d
	pikapicanimgfx 25, PikachuBucket5GFX      ; 2e
	pikapicanimgfx 25, PikachuScared1GFX      ; 2f
	pikapicanimgfx 25, PikachuScared2GFX      ; 30
	pikapicanimgfx 25, PikachuConfused1GFX    ; 31
	pikapicanimgfx 25, PikachuConfused2GFX    ; 32
	pikapicanimgfx 25, PikachuHeadShake1GFX   ; 33
	pikapicanimgfx 25, PikachuHeadShake2GFX   ; 34
	pikapicanimgfx -1, PikachuLightning1Pic   ; 35
	pikapicanimgfx 25, PikachuLightning2GFX   ; 36
	pikapicanimgfx 25, PikachuLightning3GFX   ; 37
	pikapicanimgfx 25, PikachuWakeUp1GFX      ; 38
	pikapicanimgfx 25, PikachuWakeUp2GFX      ; 39
	pikapicanimgfx -1, PikachuSurprised1Pic   ; 3a
	pikapicanimgfx 25, PikachuSurprised2GFX   ; 3b
	pikapicanimgfx -1, PikachuCry1Pic         ; 3c
	pikapicanimgfx 25, PikachuCry2GFX         ; 3d
	pikapicanimgfx 24, PikachuSprite          ; 3e
