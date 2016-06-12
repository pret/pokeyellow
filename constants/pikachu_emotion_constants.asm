dpikapic: macro
	db (\1_id - PikaPicAnimPointers) / 2
	endm

ldpikapic: macro
	ld \1, (\2_id - PikaPicAnimPointers) / 2
	endm

dpikaemotion: macro
	db (\1_id - PikachuEmotionTable) / 2
	endm

ldpikaemotion: macro
	ld \1, (\2_id - PikachuEmotionTable) / 2
	endm

dpikaanim: macro
	db (\1_id - PikaPicAnimBGFramesPointers) / 2
	endm

pikaframeend EQUS "db $e0"
pikaframe: macro
	db (\1_id - PikaPicTilemapPointers) / 2, \2
	endm

pikaframedelay EQUS "db 0,"

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


; Macros for commands
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
\1_id:: dba \1
endm

dpikacry: MACRO
	db (\1_id - PikachuCriesPointerTable) / 3
	endm

ldpikacry: MACRO
	ld \1, (\2_id - PikachuCriesPointerTable) / 3
	ENDM

pikacry: MACRO
	ldpikacry a, \1
	endm


	enum_start
	enum pikapic_nop_command
pikapic_nop: macro
	db pikapic_nop_command
	endm

	enum pikapic_writebyte_command
pikapic_writebyte: macro
	db pikapic_writebyte_command, \1
	endm

	enum pikapic_loadgfx_command
pikapic_loadgfx: macro
	db pikapic_loadgfx_command, (\1_id - PikaPicAnimGFXHeaders) / 4
	endm

	enum pikapic_animation_command
pikapic_animation: macro
	; frameset pointer, starting vtile, y offset, x offset
	db pikapic_animation_command
	dpikaanim \1
	db 0, \2, \3, \4
	endm

	enum pikapic_nop4_command
pikapic_nop4: macro
	db pikapic_nop4_command
	endm

	enum pikapic_nop5_command
pikapic_nop5: macro
	db pikapic_nop5_command
	endm

	enum pikapic_waitbgmapeleteobject_command
pikapic_waitbgmapeleteobject: macro
	db pikapic_waitbgmapeleteobject_command, \1
	endm

	enum pikapic_nop7_command
pikapic_nop7: macro
	db pikapic_nop7_command
	endm

	enum pikapic_nop8_command
pikapic_nop8: macro
	db pikapic_nop8_command
	endm

	enum pikapic_jump_command
pikapic_jump: macro ; 9
	dbw pikapic_jump_command, \1
	endm

	enum pikapic_setduration_command
pikapic_setduration: macro ; a
	dbw pikapic_setduration_command, \1
	endm

	enum pikapic_cry_command
pikapic_cry: macro ; b
	db pikapic_cry_command
IF _NARG == 0
	db $ff
else
	dpikacry \1
	endc
	endm

	enum pikapic_thunderbolt_command
pikapic_thunderbolt: macro ; c
	db pikapic_thunderbolt_command
	endm

	enum pikapic_waitbgmap_command
pikapic_waitbgmap: macro ; d
	db pikapic_waitbgmap_command
	endm

	enum pikapic_ret_command
pikapic_ret: macro ; e
	db pikapic_ret_command
	endm

pikapic_looptofinish: macro
.loop\@
	pikapic_waitbgmap
	pikapic_jump .loop\@
	endm
