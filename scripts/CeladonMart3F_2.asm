Func_f1e30::
	CheckEvent EVENT_GOT_TM18
	jr nz, .got_item
	ld hl, TM18PreReceiveText
	call PrintText
	lb bc, TM_COUNTER, 1
	call GiveItem
	jr nc, .bag_full
	SetEvent EVENT_GOT_TM18
	ld hl, ReceivedTM18Text
	jr .done
.bag_full
	ld hl, TM18NoRoomText
	jr .done
.got_item
	ld hl, TM18ExplanationText
.done
	call PrintText
	ret

TM18PreReceiveText:
	text_far _TM18PreReceiveText
	text_end

ReceivedTM18Text:
	text_far _ReceivedTM18Text
	sound_get_item_1
	text_end

TM18ExplanationText:
	text_far _TM18ExplanationText
	text_end

TM18NoRoomText:
	text_far _TM18NoRoomText
	text_end
