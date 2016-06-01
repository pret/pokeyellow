Func_f1e30
	CheckEvent EVENT_GOT_TM18
	jr nz, .asm_f1e54
	ld hl, CeladonMart3Text_f1e5b
	call PrintText
	lb bc, TM_18, 1
	call GiveItem
	jr nc, .asm_f1e4f
	SetEvent EVENT_GOT_TM18
	ld hl, CeladonMart3Text_f1e60
	jr .asm_f1e57

.asm_f1e4f
	ld hl, CeladonMart3Text_f1e6b
	jr .asm_f1e57

.asm_f1e54
	ld hl, CeladonMart3Text_f1e66
.asm_f1e57
	call PrintText
	ret

CeladonMart3Text_f1e5b:
	TX_FAR _TM18PreReceiveText
	db "@"

CeladonMart3Text_f1e60:
	TX_FAR _ReceivedTM18Text
	TX_SFX_ITEM
	db "@"

CeladonMart3Text_f1e66:
	TX_FAR _TM18ExplanationText
	db "@"

CeladonMart3Text_f1e6b:
	TX_FAR _TM18NoRoomText
	db "@"
