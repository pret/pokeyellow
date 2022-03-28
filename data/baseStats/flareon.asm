db DEX_FLAREON ; pokedex id
db 100 ; base hp
db 130 ; base attack
db 95 ; base defense
db 85 ; base speed
db 110 ; base special
db FIRE ; species type 1
db FIRE ; species type 2
db 130 ; catch rate
db 198 ; base exp yield
INCBIN "pic/ymon/flareon.pic",0,1 ; 66, sprite dimensions
dw FlareonPicFront
dw FlareonPicBack
; attacks known at lvl 0
db BODY_SLAM
db SAND_ATTACK
db FIRE_BLAST
db 0
db 0 ; growth rate
; learnset
	tmlearn 6,8
	tmlearn 9,10,15
	tmlearn 20,22
	tmlearn 31,32
	tmlearn 33,34,38,39,40
	tmlearn 44
	tmlearn 50
db 0 ; padding
