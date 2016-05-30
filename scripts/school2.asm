Func_f1c03:
	ld hl, SchoolText_f1c0a
	call PrintText
	ret

SchoolText_f1c0a:
	TX_FAR _SchoolText3
	db "@"

Func_f1c0f:
	ld hl, SchoolText_f1c16
	call PrintText
	ret

SchoolText_f1c16:
	TX_FAR _SchoolText2
	db "@"
