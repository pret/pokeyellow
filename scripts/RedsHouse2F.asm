RedsHouse2F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, RedsHouse2F_ScriptPointers
	ld a, 0
	call CallFunctionInTable
	ret

RedsHouse2F_ScriptPointers:
	dw RedsHouse2FScript0
	dw RedsHouse2FScript1
	dw RedsHouse2FScript2
	dw RedsHouse2FScript3
	dw RedsHouse2FScript4

RedsHouse2FScript0:
RedsHouse2FScript1:
RedsHouse2FScript2:
RedsHouse2FScript3:
RedsHouse2FScript4:
	ret

RedsHouse2F_TextPointers:

	text_end ; unused
