farcall: MACRO
	ld b, BANK(\1)
	ld hl, \1
	call Bankswitch
ENDM

callfar: MACRO
	ld hl, \1
	ld b, BANK(\1)
	call Bankswitch
ENDM

farjp: MACRO
	ld b, BANK(\1)
	ld hl, \1
	jp Bankswitch
ENDM

jpfar: MACRO
	ld hl, \1
	ld b, BANK(\1)
	jp Bankswitch
ENDM

homecall: MACRO
	ldh a, [hLoadedROMBank]
	push af
	ld a, BANK(\1)
	call BankswitchCommon
	call \1
	pop af
	call BankswitchCommon
ENDM
