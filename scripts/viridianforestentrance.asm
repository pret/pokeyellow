ViridianForestEntranceScript:
	call EnableAutoTextBoxDrawing
	ret

ViridianForestEntranceTextPointers:
	dw ViridianForestEntranceText1
	dw ViridianForestEntranceText2

ViridianForestEntranceText1:
	TX_FAR _ViridianForestEntranceText1
	db "@"

ViridianForestEntranceText2:
	TX_FAR _ViridianForestEntranceText2
	db "@"
