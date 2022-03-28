db DEX_PARASECT ; pokedex id
db 95 ; base hp
db 100 ; base attack
db 100 ; base defense
db 70 ; base speed
db 90 ; base special
db BUG ; species type 1
db GRASS ; species type 2
db 200 ; catch rate
db 128 ; base exp yield
INCBIN "pic/ymon/parasect.pic",0,1 ; 77, sprite dimensions
dw ParasectPicFront
dw ParasectPicBack
; attacks known at lvl 0
db HEADBUTT
db MEGA_DRAIN
db STUN_SPORE
db SPORE
db 0 ; growth rate
; learnset
	tmlearn 3,6,8
	tmlearn 9,10,15
	tmlearn 20,21,22
	tmlearn 28,31,32
	tmlearn 33,34,40
	tmlearn 44
	tmlearn 50,51
db 0 ; padding
