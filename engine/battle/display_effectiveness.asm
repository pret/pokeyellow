DisplayEffectiveness: ; 2fd25 (b:7d25)
	ld a, [wDamageMultipliers]
	and a, $7F
	cp a, $0A
	ret z
	ld hl, SuperEffectiveText
	jr nc, .done
	ld hl, NotVeryEffectiveText
.done
	jp PrintText

SuperEffectiveText: ; 2fd38 (b:7d38)
	TX_FAR _SuperEffectiveText
	db "@"

NotVeryEffectiveText: ; 2fd3d (b:7d3d)
	TX_FAR _NotVeryEffectiveText
	db "@"
