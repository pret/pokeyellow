Route7_Script:
	call EnableAutoTextBoxDrawing
	ret

Route7_TextPointers:
	dw Route7Text1

Route7Text1:
	TX_FAR _Route7Text1
	db "@"
