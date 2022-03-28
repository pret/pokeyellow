db DEX_PIDGEOT ; pokedex id
db 83 ; base hp
db 80 ; base attack
db 75 ; base defense
db 91 ; base speed
db 70 ; base special
db NORMAL ; species type 1
db FLYING ; species type 2
db 145 ; catch rate
db 172 ; base exp yield
INCBIN "pic/ymon/pidgeot.pic",0,1 ; 77, sprite dimensions
dw PidgeotPicFront
dw PidgeotPicBack
; attacks known at lvl 0
db QUICK_ATTACK
db FLY
db RAZOR_WIND
db SAND_ATTACK
db 3 ; growth rate
; learnset
	tmlearn 2,4,6
	tmlearn 9,10,15
	tmlearn 20
	tmlearn 31,32
	tmlearn 33,34,39
	tmlearn 43,44
	tmlearn 50,52
db 0 ; padding
