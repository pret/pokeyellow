db DEX_ELECTABUZZ ; pokedex id
db 75 ; base hp
db 123 ; base attack
db 67 ; base defense
db 110 ; base speed
db 95 ; base special
db ELECTRIC ; species type 1
db ELECTRIC ; species type 2
db 200 ; catch rate
db 156 ; base exp yield
INCBIN "pic/ymon/electabuzz.pic",0,1 ; 66, sprite dimensions
dw ElectabuzzPicFront
dw ElectabuzzPicBack
; attacks known at lvl 0
db THUNDERBOLT
db BODY_SLAM
db SUBMISSION
db EARTHQUAKE
db 0 ; growth rate
; learnset
	tmlearn 1,5,6,8
	tmlearn 9,10,15
	tmlearn 17,18,19,20,24
	tmlearn 25,26,29,30,31,32
	tmlearn 33,34,35,39,40
	tmlearn 44,45,46
	tmlearn 50,54,55
db 0 ; padding
