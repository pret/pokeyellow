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

homecall_jump: MACRO
	ldh a, [hLoadedROMBank]
	push af
	ld a, BANK(\1)
	call BankswitchCommon
	call \1
	pop af
	jp BankswitchCommon
ENDM

homecall_jump_sf: MACRO
	ldh a, [hLoadedROMBank]
	push af
	ld a, BANK(\1)
	call BankswitchCommon
	call \1
	pop bc
	ld a, b
	jp BankswitchCommon
ENDM

homecall_sf: MACRO ; homecall but save flags by popping into bc instead of af
	ldh a, [hLoadedROMBank]
	push af
	ld a, BANK(\1)
	call BankswitchCommon
	call \1
	pop bc
	ld a, b
	call BankswitchCommon
ENDM

switchbank: MACRO
	ld a, BANK(\1)
	call BankswitchCommon
ENDM

callbs: MACRO
	ld a, BANK(\1)
	call BankswitchCommon
	call \1
ENDM

calladb_ModifyPikachuHappiness: MACRO
	ld hl, ModifyPikachuHappiness
	ld d, \1
	ld b, BANK(ModifyPikachuHappiness)
	call Bankswitch
ENDM

callabd_ModifyPikachuHappiness: MACRO
	ld hl, ModifyPikachuHappiness
	ld b, BANK(ModifyPikachuHappiness)
	ld d, \1
	call Bankswitch
ENDM
