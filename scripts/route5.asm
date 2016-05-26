Route5Script: ; 556c6 (15:56c6)
	jp EnableAutoTextBoxDrawing

Route5TextPointers: ; 556c9 (15:56c9)
	dw Route5Text1

Route5Text1: ; 556cb (15:56cb)
	TX_FAR _Route5Text1
	db "@"
