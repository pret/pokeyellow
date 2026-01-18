; Far calls to another bank

; There is no difference between `farcall` and `callfar`, except the arbitrary
; order in which they set `b` and `hl` before calling `FarCall`.
; We use the more natural name "farcall" for the more common order.
; The same goes for `farjp` and `jpfar`.

MACRO farcall
	ld b, BANK(\1)
	ld hl, \1
	call Bankswitch
ENDM

MACRO callfar
	ld hl, \1
	ld b, BANK(\1)
	call Bankswitch
ENDM

MACRO farjp
	ld b, BANK(\1)
	ld hl, \1
	jp Bankswitch
ENDM

MACRO jpfar
	ld hl, \1
	ld b, BANK(\1)
	jp Bankswitch
ENDM

MACRO homecall
	ldh a, [hLoadedROMBank]
	push af
	ld a, BANK(\1)
	call BankswitchCommon
	call \1
	pop af
	call BankswitchCommon
ENDM

MACRO homejp
	ldh a, [hLoadedROMBank]
	push af
	ld a, BANK(\1)
	call BankswitchCommon
	call \1
	pop af
	jp BankswitchCommon
ENDM

MACRO homecall_sf ; homecall but save flags by popping into bc instead of af
	ldh a, [hLoadedROMBank]
	push af
	ld a, BANK(\1)
	call BankswitchCommon
	call \1
	pop bc
	ld a, b
	call BankswitchCommon
ENDM

MACRO homejp_sf ; homejp but save flags by popping into bc instead of af
	ldh a, [hLoadedROMBank]
	push af
	ld a, BANK(\1)
	call BankswitchCommon
	call \1
	pop bc
	ld a, b
	jp BankswitchCommon
ENDM

MACRO callfar_ModifyPikachuHappiness
	ld hl, ModifyPikachuHappiness
	ld d, \1
	ld b, BANK(ModifyPikachuHappiness)
	call Bankswitch
ENDM

MACRO farcall_ModifyPikachuHappiness
	ld hl, ModifyPikachuHappiness
	ld b, BANK(ModifyPikachuHappiness)
	ld d, \1
	call Bankswitch
ENDM
