Func_f1c03::
	ld hl, SchoolText_f1c0a
	call PrintText
	ret

SchoolText_f1c0a:
	text_far _SchoolText3
	text_end

Func_f1c0f::
	ld hl, SchoolText_f1c16
	call PrintText
	ret

SchoolText_f1c16:
	text_far _SchoolText2
	text_end
