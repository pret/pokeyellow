; returns whether the player is standing on a door tile in carry
IsPlayerStandingOnDoorTile: ; 1a609 (6:6609)
	push de
	ld hl, DoorTileIDPointers
	ld a, [wCurMapTileset]
	ld de, $3
	call IsInArray
	pop de
	jr nc, .notStandingOnDoor
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	aCoord 8, 9 ; a = lower left background tile under player's sprite
	ld b, a
.loop
	ld a, [hli]
	and a
	jr z, .notStandingOnDoor
	cp b
	jr nz, .loop
	scf
	ret
.notStandingOnDoor
	and a
	ret

DoorTileIDPointers: ; 1a7a8 (6:67a8)
	dbw OVERWORLD,   OverworldDoorTileIDs
	dbw FOREST,      ForestDoorTileIDs
	dbw MART,        MartDoorTileIDs
	dbw HOUSE,       HouseDoorTileIDs
	dbw FOREST_GATE, TilesetMuseumDoorTileIDs
	dbw MUSEUM,      TilesetMuseumDoorTileIDs
	dbw GATE,        TilesetMuseumDoorTileIDs
	dbw SHIP,        ShipDoorTileIDs
	dbw LOBBY,       LobbyDoorTileIDs
	dbw MANSION,     MansionDoorTileIDs
	dbw LAB,         LabDoorTileIDs
	dbw FACILITY,    FacilityDoorTileIDs
	dbw PLATEAU,     PlateauDoorTileIDs
	dbw INTERIOR,    InteriorDoorTileIDs
	db $ff

OverworldDoorTileIDs: ; 1a654 (6:6654)
	db $1B,$58,$00

ForestDoorTileIDs: ; 1a657 (6:6657)
	db $3a,$00

MartDoorTileIDs: ; 1a659 (6:6659)
	db $5e,$00

HouseDoorTileIDs: ; 1a65b (6:665b)
	db $54,$00

TilesetMuseumDoorTileIDs: ; 1a65d (6:665d)
	db $3b,$00

ShipDoorTileIDs: ; 1a65f (6:665f)
	db $1e,$00

LobbyDoorTileIDs: ; 1a7e0 (6:67e0)
	db $1c,$38,$1a,$00

MansionDoorTileIDs: ; 1a7e4 (6:67e4)
	db $1a,$1c,$53,$00

LabDoorTileIDs: ; 1a7e8 (6:67e8)
	db $34,$00

FacilityDoorTileIDs: ; 1a7ea (6:67ea)
	db $43,$58,$1b,$00

PlateauDoorTileIDs: ; 1a7ee (6:67ee)
	db $3b,$1b,$00

InteriorDoorTileIDs: ; 1a7f1 (6:67f1)
	db $04,$15,$00
