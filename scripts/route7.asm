Route7Script: ; 480eb (12:40eb)
	call EnableAutoTextBoxDrawing
	ret

Route7TextPointers: ; 480ef (12:40ef)
	dw Route7Text1

Route7Text1: ; 480f1 (12:40f1)
	TX_FAR _Route7Text1
	db "@"
