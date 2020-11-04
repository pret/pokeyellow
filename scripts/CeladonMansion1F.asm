CeladonMansion1F_Script:
	call EnableAutoTextBoxDrawing
	ret

CeladonMansion1F_TextPointers:
	dw CeladonMansion1Text1
	dw CeladonMansion1Text2
	dw CeladonMansion1Text3
	dw CeladonMansion1Text4
	dw CeladonMansion1Text5

CeladonMansion1Text1:
	text_far _CeladonMansion1Text1
	text_asm
	ld a, MEOWTH
	call PlayCry
	jp TextScriptEnd

CeladonMansion1Text2:
	text_asm
	farcall Func_f1e70
	ld a, [wPikachuHappiness]
	cp 251
	jr c, .asm_485d9
	ld c, 50
	call DelayFrames
	ldpikacry e, PikachuCry23
	callfar PlayPikachuSoundClip
.asm_485d9
	jp TextScriptEnd

CeladonMansion1Text3:
	text_far _CeladonMansion1Text3
	text_asm
	ld a, CLEFAIRY
	call PlayCry
	jp TextScriptEnd

CeladonMansion1Text4:
	text_far _CeladonMansion1Text4
	text_asm
	ld a, NIDORAN_F
	call PlayCry
	jp TextScriptEnd

CeladonMansion1Text5:
	text_far _CeladonMansion1Text5
	text_end
