db DEX_MAGMAR ; pokedex id
db 75 ; base hp
db 100 ; base attack
db 67 ; base defense
db 105 ; base speed
db 125 ; base special
db FIRE ; species type 1
db FIRE ; species type 2
db 200 ; catch rate
db 167 ; base exp yield
INCBIN "pic/ymon/magmar.pic",0,1 ; 66, sprite dimensions
dw MagmarPicFront
dw MagmarPicBack
; attacks known at lvl 0
db BODY_SLAM
db ICE_PUNCH
db THUNDERBOLT
db FIRE_BLAST
db 0 ; growth rate
; learnset
	tmlearn 1,5,6,8
	tmlearn 9,10,15
	tmlearn 17,18,19,20
	tmlearn 24,29,30,31
	tmlearn 32,34,35,38
	tmlearn 40,44,46
	tmlearn 50,54
db 0 ; padding
