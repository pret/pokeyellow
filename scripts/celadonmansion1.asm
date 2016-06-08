CeladonMansion1Script:
	call EnableAutoTextBoxDrawing
	ret

CeladonMansion1TextPointers:
	dw CeladonMansion1Text1
	dw CeladonMansion1Text2
	dw CeladonMansion1Text3
	dw CeladonMansion1Text4
	dw CeladonMansion1Text5

CeladonMansion1Text1:
	TX_FAR _CeladonMansion1Text1
	TX_ASM
	ld a, MEOWTH
	call PlayCry
	jp TextScriptEnd

CeladonMansion1Text2:
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

CeladonMansion1Text3:
	TX_FAR _CeladonMansion1Text3
	TX_ASM
	ld a, CLEFAIRY
	call PlayCry
	jp TextScriptEnd

CeladonMansion1Text4:
	TX_FAR _CeladonMansion1Text4
	TX_ASM
	ld a, NIDORAN_F
	call PlayCry
	jp TextScriptEnd

CeladonMansion1Text5:
	TX_FAR _CeladonMansion1Text5
	db "@"
