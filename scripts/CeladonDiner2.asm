Func_f1f31::
	CheckEvent EVENT_GOT_COIN_CASE
	jr nz, .got_item
	ld hl, CeladonDinerText_491a7
	call PrintText
	lb bc, COIN_CASE, 1
	call GiveItem
	jr nc, .bag_full
	SetEvent EVENT_GOT_COIN_CASE
	ld hl, ReceivedCoinCaseText
	call PrintText
	jr .done
.bag_full
	ld hl, CoinCaseNoRoomText
	call PrintText
	jr .done
.got_item
	ld hl, CeladonDinerText_491b7
	call PrintText
.done
	ret

CeladonDinerText_491a7:
	text_far _CeladonDinerText_491a7
	text_end

ReceivedCoinCaseText:
	text_far _ReceivedCoinCaseText
	sound_get_key_item
	text_end

CoinCaseNoRoomText:
	text_far _CoinCaseNoRoomText
	text_end

CeladonDinerText_491b7:
	text_far _CeladonDinerText_491b7
	text_end
