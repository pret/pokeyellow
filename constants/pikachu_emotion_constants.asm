; pikachu happiness modifiers
	const_def 1
	const PIKAHAPPY_LEVELUP
	const PIKAHAPPY_USEDITEM
	const PIKAHAPPY_USEDXITEM
	const PIKAHAPPY_GYMLEADER
	const PIKAHAPPY_USEDTMHM
	const PIKAHAPPY_WALKING
	const PIKAHAPPY_DEPOSITED
	const PIKAHAPPY_FAINTED
	const PIKAHAPPY_PSNFNT
	const PIKAHAPPY_CARELESSTRAINER
	const PIKAHAPPY_TRADE

MACRO dpikapic
	db (\1_id - PikaPicAnimPointers) / 2
ENDM

MACRO dpikaemotion
	db (\1_id - PikachuEmotionTable) / 2
ENDM

MACRO ldpikaemotion
	ld \1, (\2_id - PikachuEmotionTable) / 2
ENDM

; Starter Pikachu emotion commands constants

	const_def
	const PIKAEMOTION_DUMMY1
	const PIKAEMOTION_PRINTTEXT
	const PIKAEMOTION_PLAYPCMSOUNDCLIP
	const PIKAEMOTION_DOEMOTIONBUBBLE
	const PIKAEMOTION_4
	const PIKAEMOTION_5
	const PIKAEMOTION_SUBCMD
	const PIKAEMOTION_DELAYFRAMES
	const PIKAEMOTION_DUMMY2
	const PIKAEMOTION_9
	const PIKAEMOTION_DUMMY3

	const_def
	const PIKAEMOTION_SUBCMD_LOADEXTRAPIKASPRITES
	const PIKAEMOTION_SUBCMD_LOADFONT
	const PIKAEMOTION_SUBCMD_SHOWMAPVIEW
	const PIKAEMOTION_SUBCMD_WAITBUTTONPRESS
	const PIKAEMOTION_SUBCMD_CHECKPEWTERCENTER
	const PIKAEMOTION_SUBCMD_CHECKLAVENDERTOWER
	const PIKAEMOTION_SUBCMD_CHECKBILLSHOUSE

	const_def
	const PIKASTEPDIR_DOWN
	const PIKASTEPDIR_UP
	const PIKASTEPDIR_LEFT
	const PIKASTEPDIR_RIGHT
	const PIKASTEPDIR_DOWN_LEFT
	const PIKASTEPDIR_DOWN_RIGHT
	const PIKASTEPDIR_UP_LEFT
	const PIKASTEPDIR_UP_RIGHT


; MACROs for commands
MACRO pikaemotion_dummy1
	db PIKAEMOTION_DUMMY1
ENDM

MACRO pikaemotion_printtext
	db PIKAEMOTION_PRINTTEXT
	dw \1
ENDM

MACRO pikaemotion_pcm
	db PIKAEMOTION_PLAYPCMSOUNDCLIP
	IF _NARG > 0
		dpikacry \1
	ELSE
		db $ff
	ENDC
ENDM

MACRO pikaemotion_emotebubble
	db PIKAEMOTION_DOEMOTIONBUBBLE
	db \1
ENDM

MACRO pikaemotion_movement
	db PIKAEMOTION_4
	dw \1
ENDM

MACRO pikaemotion_pikapic
	db PIKAEMOTION_5
	dpikapic \1
ENDM

MACRO pikaemotion_subcmd
	db PIKAEMOTION_SUBCMD
	db \1
ENDM

MACRO pikaemotion_delay
	db PIKAEMOTION_DELAYFRAMES
	db \1
ENDM

MACRO pikaemotion_dummy2
	db PIKAEMOTION_DUMMY2
ENDM

MACRO pikaemotion_9
	db PIKAEMOTION_9
ENDM

MACRO pikaemotion_dummy3
	db PIKAEMOTION_DUMMY3
ENDM

MACRO pikacry_def
\1_id::
	dba \1
ENDM

MACRO dpikacry
	db (\1_id - PikachuCriesPointerTable) / 3
ENDM

MACRO ldpikacry
	ld \1, (\2_id - PikachuCriesPointerTable) / 3
ENDM

MACRO pikacry
	ldpikacry a, \1
ENDM


	const_def
	const pikapic_nop_command
MACRO pikapic_nop
	db pikapic_nop_command
ENDM

	const pikapic_writebyte_command
MACRO pikapic_writebyte
	db pikapic_writebyte_command
	db \1
ENDM

	const pikapic_loadgfx_command
MACRO pikapic_loadgfx
	db pikapic_loadgfx_command
	db (\1_id - PikaPicAnimGFXHeaders) / 4
ENDM

	const pikapic_animation_command
MACRO pikapic_animation
	; frameset pointer, starting vtile, y offset, x offset
	db pikapic_animation_command
	db (\1_id - PikaPicAnimBGFramesPointers) / 2
	db 0, \2, \3, \4
ENDM

	const pikapic_nop4_command
MACRO pikapic_nop4
	db pikapic_nop4_command
ENDM

	const pikapic_nop5_command
MACRO pikapic_nop5
	db pikapic_nop5_command
ENDM

	const pikapic_waitbgmapeleteobject_command
MACRO pikapic_waitbgmapeleteobject
	db pikapic_waitbgmapeleteobject_command
	db \1
ENDM

	const pikapic_nop7_command
MACRO pikapic_nop7
	db pikapic_nop7_command
ENDM

	const pikapic_nop8_command
MACRO pikapic_nop8
	db pikapic_nop8_command
ENDM

	const pikapic_jump_command
MACRO pikapic_jump ; 9
	db pikapic_jump_command
	dw \1
ENDM

	const pikapic_setduration_command
MACRO pikapic_setduration ; a
	db pikapic_setduration_command
	dw \1
ENDM

	const pikapic_cry_command
MACRO pikapic_cry ; b
	db pikapic_cry_command
	IF _NARG == 0
		db $ff
	else
		dpikacry \1
	endc
ENDM

	const pikapic_thunderbolt_command
MACRO pikapic_thunderbolt ; c
	db pikapic_thunderbolt_command
ENDM

	const pikapic_waitbgmap_command
MACRO pikapic_waitbgmap ; d
	db pikapic_waitbgmap_command
ENDM

	const pikapic_ret_command
MACRO pikapic_ret ; e
	db pikapic_ret_command
ENDM

MACRO pikapic_looptofinish
.loop\@
	pikapic_waitbgmap
	pikapic_jump .loop\@
ENDM
