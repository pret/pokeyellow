; OAM flags used by this game
OAMFLAG_ENDOFDATA   EQU %00000001 ; pseudo OAM flag, only used by game logic
OAMFLAG_CANBEMASKED EQU %00000010 ; pseudo OAM flag, only used by game logic
OAMFLAG_VFLIPPED    EQU %00100000 ; OAM flag flips the sprite vertically.
; Used for making left facing sprites face right and to alternate between left and right foot animation when walking up or down

; OAM attribute flags
OAM_HFLIP EQU %00100000 ; horizontal flip
OAM_VFLIP EQU %01000000 ; vertical flip

frame: MACRO
	db \1
x = \2
REPT _NARG +- 2
x = x | (\3 << 1)
	shift
endr
	db x
	endm

delanim EQUS "db $fc"
dorepeat EQUS "db $fd,"
dorestart EQUS "db $fe"
endanim EQUS "db $ff"
