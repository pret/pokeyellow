PrinterSerial::
	homecall PrinterSerial_
	ret

SerialFunction::
	ld a, [wPrinterConnectionOpen]
	bit 0, a
	ret z
	ld a, [wPrinterOpcode]
	and a
	ret nz
	ld hl, wOverworldMap + 650
	inc [hl]
	ld a, [hl]
	cp $6
	ret c
	xor a
	ld [hl], a
	ld a, $0c
	ld [wPrinterOpcode], a
	ld a, $88
	ldh [rSB], a
	ld a, $1
	ldh [rSC], a
	ld a, START_TRANSFER_INTERNAL_CLOCK
	ldh [rSC], a
	ret

; causes the text box to close without waiting for a button press after displaying text
DisableWaitingAfterTextDisplay::
	ld a, $01
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ret
