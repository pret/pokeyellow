CeladonMansion1Script: ; 48694 (12:4694)
	call EnableAutoTextBoxDrawing
	ret

CeladonMansion1TextPointers: ; 48697 (12:4697)
	dw CeladonMansion1Text1
	dw CeladonMansion1Text2
	dw CeladonMansion1Text3
	dw CeladonMansion1Text4
	dw CeladonMansion1Text5

CeladonMansion1Text1: ; 486a7 (12:46a7)
	TX_FAR _CeladonMansion1Text1
	TX_ASM
	ld a, MEOWTH
	call PlayCry
	jp TextScriptEnd

CeladonMansion1Text2: ; 486b1 (12:46b1)
	TX_ASM
	callba Func_f1e70
	ld a, [wPikachuHappiness]
	cp 251
	jr c, .asm_485d9
	ld c, 50
	call DelayFrames
	ldpikacry e, PikachuCry23
	callab PlayPikachuSoundClip
.asm_485d9
	jp TextScriptEnd

CeladonMansion1Text3: ; 486b6 (12:46b6)
	TX_FAR _CeladonMansion1Text3
	TX_ASM
	ld a, CLEFAIRY
	call PlayCry
	jp TextScriptEnd

CeladonMansion1Text4: ; 486c0 (12:46c0)
	TX_FAR _CeladonMansion1Text4
	TX_ASM
	ld a, NIDORAN_F
	call PlayCry
	jp TextScriptEnd

CeladonMansion1Text5: ; 486ca (12:46ca)
	TX_FAR _CeladonMansion1Text5
	db "@"
