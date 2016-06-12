RedsHouse2FScript:
	call EnableAutoTextBoxDrawing
	ld hl, RedsHouse2FScriptPointers
	ld a, 0
	call JumpTable
	ret

RedsHouse2FScriptPointers:
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

RedsHouse2FTextPointers:
	db "@"
