RedsHouse2FScript: ; 5c0b0 (17:40b0)
	call EnableAutoTextBoxDrawing
	ld hl, RedsHouse2FScriptPointers
	ld a, 0
	call JumpTable
	ret

RedsHouse2FScriptPointers: ; 5c0bc (17:40bc)
	dw RedsHouse2FScript0
	dw RedsHouse2FScript1
	dw RedsHouse2FScript2
	dw RedsHouse2FScript3
	dw RedsHouse2FScript4

RedsHouse2FScript0: ; 5c0ce (17:40ce)
RedsHouse2FScript1: ; 5c0ce (17:40ce)
RedsHouse2FScript2: ; 5c0ce (17:40ce)
RedsHouse2FScript3: ; 5c0ce (17:40ce)
RedsHouse2FScript4: ; 5c0ce (17:40ce)
	ret

RedsHouse2FTextPointers: ; 5c0cf (17:40cf)
	db "@"
