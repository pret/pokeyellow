Func_f1ad2::
	CheckAndSetEvent EVENT_GOT_POTION_SAMPLE
	jr nz, .got_item
	ld hl, Route1ViridianMartSampleText
	call PrintText
	lb bc, POTION, 1
	call GiveItem
	jr nc, .bag_full
	ld hl, Route1Text_1cae8
	jr .done
.bag_full
	ld hl, Route1Text_1caf3
	jr .done
.got_item
	ld hl, Route1Text_1caee
.done
	call PrintText
	ret

Route1ViridianMartSampleText:
	text_far _Route1ViridianMartSampleText
	text_end

Route1Text_1cae8:
	text_far _Route1Text_1cae8
	sound_get_item_1
	text_end

Route1Text_1caee:
	text_far _Route1Text_1caee
	text_end

Route1Text_1caf3:
	text_far _Route1Text_1caf3
	text_end

Func_f1b0f::
	ld hl, Route1Text_f1b16
	call PrintText
	ret

Route1Text_f1b16:
	text_far _Route1Text2
	text_end

Func_f1b1b::
	ld hl, Route1Text_f1b22
	call PrintText
	ret

Route1Text_f1b22:
	text_far _Route1Text3
	text_end
