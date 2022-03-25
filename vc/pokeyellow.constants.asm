INCLUDE "constants.asm"

; These are all the asm constants needed to make the blue_vc patch.

vc_const: MACRO
x = \1
	PRINTLN "00:{04x:x} \1" ; same format as rgblink's .sym file
ENDM

; [FPA 031801 Begin1]
YellowIntroScene14_Index = $e
	vc_const YellowIntroScene14_Index

; [FPA 031801 Begin2]
YellowIntroScene15_Index = $f
	vc_const YellowIntroScene15_Index

; [FPA 001 Begin]
	vc_const "M"
	vc_const "E"
	vc_const "G"
	vc_const "A"
	vc_const "P"
	vc_const "X"
	vc_const "L"
	vc_const "S"
	vc_const "F"
	vc_const MEGA_PUNCH
