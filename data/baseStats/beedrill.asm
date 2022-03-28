db DEX_BEEDRILL ; pokedex id
db 90 ; base hp
db 95 ; base attack
db 75 ; base defense
db 90 ; base speed
db 80 ; base special
db BUG ; species type 1
db POISON ; species type 2
db 255 ; catch rate
db 159 ; base exp yield
INCBIN "pic/ymon/beedrill.pic",0,1 ; 77, sprite dimensions
dw BeedrillPicFront
dw BeedrillPicBack
; attacks known at lvl 0
db PIN_MISSILE
db 0
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn 3,6
	tmlearn 9,10,15
	tmlearn 20,21
	tmlearn 31,32
	tmlearn 33,34,39,40
	tmlearn 44
	tmlearn 50,51
db 0 ; padding
