INCLUDE "constants.asm"

; These are all the asm constants needed to make the blue_vc patch.

vc_const: MACRO
x = \1
	PRINTLN "00:{04x:x} \1" ; same format as rgblink's .sym file
ENDM

; [FPA 031801 Begin1]
YellowIntroScene14val = $e
	vc_const YellowIntroScene14val

; [FPA 031801 Begin2]
YellowIntroScene15val = $f
	vc_const YellowIntroScene15val
