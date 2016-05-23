RemoveGuardDrink: ; 5a53a (16:653a)
	ld hl, GuardDrinksList
.drinkLoop
	ld a, [hli]
	ld [$ffdb], a
	and a
	ret z
	push hl
	ld b, a
	call IsItemInBag
	pop hl
	jr z, .drinkLoop
	jpba RemoveItemByID

GuardDrinksList: ; 5a552 (16:6552)
	db FRESH_WATER, SODA_POP, LEMONADE, $00
