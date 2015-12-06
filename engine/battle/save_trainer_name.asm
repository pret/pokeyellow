SaveTrainerName: ; 27dff (9:7dff)
	ld hl,TrainerNamePointers
	ld a,[wTrainerClass]
	dec a
	ld c,a
	ld b,0
	add hl,bc
	add hl,bc
	ld a,[hli]
	ld h,[hl]
	ld l,a
	ld de,wcd6d
.CopyCharacter
	ld a,[hli]
	ld [de],a
	inc de
	cp "@"
	jr nz,.CopyCharacter
	ret

TrainerNamePointers: ; 27e19 (9:7e19)
; what is the point of these?
	dw YoungsterName
	dw BugCatcherName
	dw LassName
	dw wTrainerName
	dw JrTrainerMName
	dw JrTrainerFName
	dw PokemaniacName
	dw SuperNerdName
	dw wTrainerName
	dw wTrainerName
	dw BurglarName
	dw EngineerName
	dw JugglerXName
	dw wTrainerName
	dw SwimmerName
	dw wTrainerName
	dw wTrainerName
	dw BeautyName
	dw wTrainerName
	dw RockerName
	dw JugglerName
	dw wTrainerName
	dw wTrainerName
	dw BlackbeltName
	dw wTrainerName
	dw ProfOakName
	dw ChiefName
	dw ScientistName
	dw wTrainerName
	dw RocketName
	dw CooltrainerMName
	dw CooltrainerFName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName

YoungsterName: ; 27e77 (9:7e77)
	db "YOUNGSTER@"
BugCatcherName: ; 27e81 (9:7e81)
	db "BUG CATCHER@"
LassName: ; 27e8d (9:7e8d)
	db "LASS@"
JrTrainerMName: ; 27e92 (9:7e92)
	db "JR.TRAINER♂@"
JrTrainerFName: ; 27e9e (9:7e9e)
	db "JR.TRAINER♀@"
PokemaniacName: ; 27eaa (9:7eaa)
	db "POKéMANIAC@"
SuperNerdName: ; 27eb5 (9:7eb5)
	db "SUPER NERD@"
BurglarName: ; 27ec0 (9:7ec0)
	db "BURGLAR@"
EngineerName: ; 27ec8 (9:7ec8)
	db "ENGINEER@"
JugglerXName: ; 27ed1 (9:7ed1)
	db "JUGGLER@"
SwimmerName: ; 27ed9 (9:7ed9)
	db "SWIMMER@"
BeautyName: ; 27ee1 (9:7ee1)
	db "BEAUTY@"
RockerName: ; 27ee8 (9:7ee8)
	db "ROCKER@"
JugglerName: ; 27eef (9:7eef)
	db "JUGGLER@"
BlackbeltName: ; 27ef7 (9:7ef7)
	db "BLACKBELT@"
ProfOakName: ; 27f01 (9:7f01)
	db "PROF.OAK@"
ChiefName: ; 27f0a (9:7f0a)
	db "CHIEF@"
ScientistName: ; 27f10 (9:7f10)
	db "SCIENTIST@"
RocketName: ; 27f1a (9:7f1a)
	db "ROCKET@"
CooltrainerMName: ; 27f21 (9:7f21)
	db "COOLTRAINER♂@"
CooltrainerFName: ; 27f2e (9:7f2e)
	db "COOLTRAINER♀@"
