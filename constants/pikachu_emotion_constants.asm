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

dpikapic: MACRO
	db (\1_id - PikaPicAnimPointers) / 2
ENDM

dpikaemotion: MACRO
	db (\1_id - PikachuEmotionTable) / 2
ENDM

ldpikaemotion: MACRO
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
pikaemotion_dummy1: MACRO
	db PIKAEMOTION_DUMMY1
ENDM

pikaemotion_printtext: MACRO
	db PIKAEMOTION_PRINTTEXT
	dw \1
ENDM

pikaemotion_pcm: MACRO
	db PIKAEMOTION_PLAYPCMSOUNDCLIP
IF _NARG > 0
	dpikacry \1
ELSE
	db $ff
ENDC
ENDM

pikaemotion_emotebubble: MACRO
	db PIKAEMOTION_DOEMOTIONBUBBLE
	db \1
ENDM

pikaemotion_movement: MACRO
	db PIKAEMOTION_4
	dw \1
ENDM

pikaemotion_pikapic: MACRO
	db PIKAEMOTION_5
	dpikapic \1
ENDM

pikaemotion_subcmd: MACRO
	db PIKAEMOTION_SUBCMD
	db \1
ENDM

pikaemotion_delay: MACRO
	db PIKAEMOTION_DELAYFRAMES
	db \1
ENDM

pikaemotion_dummy2: MACRO
	db PIKAEMOTION_DUMMY2
ENDM

pikaemotion_9: MACRO
	db PIKAEMOTION_9
ENDM

pikaemotion_dummy3: MACRO
	db PIKAEMOTION_DUMMY3
ENDM

pikacry_def: MACRO
\1_id::
	dba \1
ENDM

dpikacry: MACRO
	db (\1_id - PikachuCriesPointerTable) / 3
ENDM

ldpikacry: MACRO
	ld \1, (\2_id - PikachuCriesPointerTable) / 3
ENDM

pikacry: MACRO
	ldpikacry a, \1
ENDM


	const_def
	const pikapic_nop_command
pikapic_nop: MACRO
	db pikapic_nop_command
ENDM

	const pikapic_writebyte_command
pikapic_writebyte: MACRO
	db pikapic_writebyte_command
	db \1
ENDM

	const pikapic_loadgfx_command
pikapic_loadgfx: MACRO
	db pikapic_loadgfx_command
	db (\1_id - PikaPicAnimGFXHeaders) / 4
ENDM

	const pikapic_animation_command
pikapic_animation: MACRO
	; frameset pointer, starting vtile, y offset, x offset
	db pikapic_animation_command
	db (\1_id - PikaPicAnimBGFramesPointers) / 2
	db 0, \2, \3, \4
ENDM

	const pikapic_nop4_command
pikapic_nop4: MACRO
	db pikapic_nop4_command
ENDM

	const pikapic_nop5_command
pikapic_nop5: MACRO
	db pikapic_nop5_command
ENDM

	const pikapic_waitbgmapeleteobject_command
pikapic_waitbgmapeleteobject: MACRO
	db pikapic_waitbgmapeleteobject_command
	db \1
ENDM

	const pikapic_nop7_command
pikapic_nop7: MACRO
	db pikapic_nop7_command
ENDM

	const pikapic_nop8_command
pikapic_nop8: MACRO
	db pikapic_nop8_command
ENDM

	const pikapic_jump_command
pikapic_jump: MACRO ; 9
	db pikapic_jump_command
	dw \1
ENDM

	const pikapic_setduration_command
pikapic_setduration: MACRO ; a
	db pikapic_setduration_command
	dw \1
ENDM

	const pikapic_cry_command
pikapic_cry: MACRO ; b
	db pikapic_cry_command
IF _NARG == 0
	db $ff
else
	dpikacry \1
	endc
ENDM

	const pikapic_thunderbolt_command
pikapic_thunderbolt: MACRO ; c
	db pikapic_thunderbolt_command
ENDM

	const pikapic_waitbgmap_command
pikapic_waitbgmap: MACRO ; d
	db pikapic_waitbgmap_command
ENDM

	const pikapic_ret_command
pikapic_ret: MACRO ; e
	db pikapic_ret_command
ENDM

pikapic_looptofinish: MACRO
.loop\@
	pikapic_waitbgmap
	pikapic_jump .loop\@
ENDM
