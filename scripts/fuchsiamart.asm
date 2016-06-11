FuchsiaMartScript:
	call EnableAutoTextBoxDrawing
	ret

FuchsiaMartTextPointers:
	dw FuchsiaMartText1
	dw FuchsiaMartText2
	dw FuchsiaMartText3

FuchsiaMartText2:
	TX_FAR _FuchsiaMartText2
	db "@"

FuchsiaMartText3:
	TX_FAR _FuchsiaMartText3
	db "@"
