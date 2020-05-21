INCLUDE "macros/asm_macros.asm"
INCLUDE "macros/data_macros.asm"
INCLUDE "macros/text_macros.asm"
INCLUDE "macros/audio_macros.asm"
INCLUDE "macros/event_macros.asm"

SHADE_BLACK EQU %11
SHADE_DARK  EQU %10
SHADE_LIGHT EQU %01
SHADE_WHITE EQU %00

setpal: MACRO
	ld a, \1 << 6 | \2 << 4 | \3 << 2 | \4
ENDM

setpalBGP: MACRO
	setpal SHADE_BLACK, SHADE_DARK, SHADE_LIGHT, SHADE_WHITE
ENDM

setpalOBP: MACRO
	setpal SHADE_BLACK, SHADE_DARK, SHADE_WHITE, SHADE_WHITE
ENDM

homecall_jump: MACRO
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, BANK(\1)
	call BankswitchCommon
	call \1
	pop af
	jp BankswitchCommon
	ENDM

homecall_jump_sf: MACRO
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, BANK(\1)
	call BankswitchCommon
	call \1
	pop bc
	ld a,b
	jp BankswitchCommon
	ENDM

homecall_sf: MACRO ; homecall but save flags by popping into bc instead of af
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, BANK(\1)
	call BankswitchCommon
	call \1
	pop bc
	ld a,b
	call BankswitchCommon
	ENDM

switchbank: MACRO
	ld a, BANK(\1)
	call BankswitchCommon
	ENDM

callbs: MACRO
	ld a, BANK(\1)
	call BankswitchCommon
	call \1
	ENDM

calladb_ModifyPikachuHappiness: MACRO
	ld hl, ModifyPikachuHappiness
	ld d, \1
	ld b, BANK(ModifyPikachuHappiness)
	call Bankswitch
	ENDM

callabd_ModifyPikachuHappiness: MACRO
	ld hl, ModifyPikachuHappiness
	ld b, BANK(ModifyPikachuHappiness)
	ld d, \1
	call Bankswitch
	ENDM

sine_wave: MACRO
; \1: amplitude

x = 0
	rept $20
	; Round up.
	dw (sin(x) + (sin(x) & $ff)) >> 8
x = x + (\1) * $40000
	endr
ENDM

ANIM_OBJ_INDEX           EQUS "wAnimatedObject0Index - wAnimatedObject0"
ANIM_OBJ_FRAME_SET       EQUS "wAnimatedObject0FramesetID - wAnimatedObject0"
ANIM_OBJ_CALLBACK        EQUS "wAnimatedObject0AnimSeqID - wAnimatedObject0"
ANIM_OBJ_TILE            EQUS "wAnimatedObject0TileID - wAnimatedObject0"
ANIM_OBJ_X_COORD         EQUS "wAnimatedObject0XCoord - wAnimatedObject0"
ANIM_OBJ_Y_COORD         EQUS "wAnimatedObject0YCoord - wAnimatedObject0"
ANIM_OBJ_X_OFFSET        EQUS "wAnimatedObject0XOffset - wAnimatedObject0"
ANIM_OBJ_Y_OFFSET        EQUS "wAnimatedObject0YOffset - wAnimatedObject0"
ANIM_OBJ_DURATION        EQUS "wAnimatedObject0Duration - wAnimatedObject0"
ANIM_OBJ_DURATION_OFFSET EQUS "wAnimatedObject0DurationOffset - wAnimatedObject0"
ANIM_OBJ_FRAME_IDX       EQUS "wAnimatedObject0FrameIndex - wAnimatedObject0"
ANIM_OBJ_FIELD_B EQU $b
ANIM_OBJ_FIELD_C EQU $c
ANIM_OBJ_FIELD_D EQU $d
ANIM_OBJ_FIELD_E EQU $e
ANIM_OBJ_FIELD_F EQU $f
