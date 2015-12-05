StartSlotMachine: ; 37ed1 (d:7ed1)
	ld a, [wHiddenObjectFunctionArgument]
	cp $fd
	jr z, .printOutOfOrder
	cp $fe
	jr z, .printOutToLunch
	cp $ff
	jr z, .printSomeonesKeys
	callba AbleToPlaySlotsCheck
	ld a, [wCanPlaySlots]
	and a
	ret z
	ld a, [wLuckySlotHiddenObjectIndex]
	ld b, a
	ld a, [wHiddenObjectIndex]
	inc a
	cp b
	jr z, .match
	ld a, 253
	jr .next
.match
	ld a, 250
.next
	ld [wSlotMachineSevenAndBarModeChance], a
	ld a, [H_LOADEDROMBANK]
	ld [wSlotMachineSavedROMBank], a
	call PromptUserToPlaySlots
	ret
.printOutOfOrder
	tx_pre_id GameCornerOutOfOrderText
	jr .printText
.printOutToLunch
	tx_pre_id GameCornerOutToLunchText
	jr .printText
.printSomeonesKeys
	tx_pre_id GameCornerSomeonesKeysText
.printText
	push af
	call EnableAutoTextBoxDrawing
	pop af
	call PrintPredefTextID
	ret

GameCornerOutOfOrderText: ; 37f1d (d:7f1d)
	TX_FAR _GameCornerOutOfOrderText
	db "@"

GameCornerOutToLunchText: ; 37f22 (d:7f22)
	TX_FAR _GameCornerOutToLunchText
	db "@"

GameCornerSomeonesKeysText: ; 37f27 (d:7f27)
	TX_FAR _GameCornerSomeonesKeysText
	db "@"
