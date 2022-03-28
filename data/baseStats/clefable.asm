db DEX_CLEFABLE ; pokedex id
db 95 ; base hp
db 85 ; base attack
db 90 ; base defense
db 80 ; base speed
db 100 ; base special
db NORMAL ; species type 1
db NORMAL ; species type 2
db 1 ; catch rate
db 129 ; base exp yield
INCBIN "pic/ymon/clefable.pic",0,1 ; 66, sprite dimensions
dw ClefablePicFront
dw ClefablePicBack
; attacks known at lvl 0
db BODY_SLAM
db PSYCHIC_M
db SING
db BLIZZARD
db 4 ; growth rate
; learnset
	tmlearn 1,5,6,8
	tmlearn 9,10,11,12,13,14,15
	tmlearn 17,18,19,20,22,24
	tmlearn 25,29,30,31,32
	tmlearn 33,34,35,38,40
	tmlearn 44,45,46
	tmlearn 49,50,54,55
db 0 ; padding
