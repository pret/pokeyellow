ViridianCityScript: ; 1902a (6:502a)
	call EnableAutoTextBoxDrawing
	ld hl, ViridianCityScriptPointers
	ld a, [W_VIRIDIANCITYCURSCRIPT]
	call JumpTable
	ret

ViridianCityScriptPointers: ; 19037 (6:5037)
	dw ViridianCityScript0  ; 1904d
	dw ViridianCityScript1  ; 19054
	dw ViridianCityScript2  ; 19057
	dw ViridianCityScript3  ; 190ca
	dw ViridianCityScript4  ; 19104
	dw ViridianCityScript5  ; 1913f
	dw ViridianCityScript6  ; 1909d
	dw ViridianCityScript7  ; 19191
	dw ViridianCityScript8  ; 191a7
	dw ViridianCityScript9  ; 191cf
	dw ViridianCityScript10 ; 191f9

ViridianCityScript0:
	dr $1904d,$19054
ViridianCityScript1:  ; 19054
	dr $19054,$19057
ViridianCityScript2:  ; 19057
	dr $19057,$1909d
ViridianCityScript6:  ; 1909d
	dr $1909d,$190ca
ViridianCityScript3:  ; 190ca
	dr $190ca,$19104
ViridianCityScript4:  ; 19104
	dr $19104,$1913f
ViridianCityScript5:  ; 1913f
	dr $1913f,$19191
ViridianCityScript7:  ; 19191
	dr $19191,$191a7
ViridianCityScript8:  ; 191a7
	dr $191a7,$191cf
ViridianCityScript9:  ; 191cf
	dr $191cf,$191f9
ViridianCityScript10: ; 191f9
	dr $191f9,$19213

ViridianCityTextPointers:
	dr $19213,$192f5
