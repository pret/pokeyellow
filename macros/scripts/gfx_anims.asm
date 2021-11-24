; pic + oam animations

frame: MACRO
	db \1
x = \2
IF _NARG > 2
REPT _NARG - 2
x |= \3 << 1
	shift
ENDR
ENDC
	db x
ENDM

	const_def -1, -1

	const endanim_command ; $ff
endanim: MACRO
	db endanim_command
ENDM

	const dorestart_command ; $fe
dorestart: MACRO
	db dorestart_command
ENDM

	const dorepeat_command ; $fd
dorepeat: MACRO
	db dorepeat_command
	db \1 ; command offset to jump to
ENDM

	const delanim_command ; $fc
delanim: MACRO
; Removes the object from the screen, as opposed to `endanim` which just stops all motion
	db delanim_command
ENDM
