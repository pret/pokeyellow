_Multiply:
	ld a, $8
	ld b, a
	xor a
	ld [H_PRODUCT], a
	ld [H_MULTIPLYBUFFER], a
	ld [H_MULTIPLYBUFFER+1], a
	ld [H_MULTIPLYBUFFER+2], a
	ld [H_MULTIPLYBUFFER+3], a
.multiplyLoop
	ld a, [H_MULTIPLIER]
	srl a
	ld [H_MULTIPLIER], a
	jr nc, .smallMultiplier ; less than $80
; code to possibly multiply the multiplicand by 2 and divide the multiplier by 2?
	ld a, [H_MULTIPLYBUFFER+3]
	ld c, a
	ld a, [H_MULTIPLICAND+2]
	add c
	ld [H_MULTIPLYBUFFER+3], a
	ld a, [H_MULTIPLYBUFFER+2]
	ld c, a
	ld a, [H_MULTIPLICAND+1]
	adc c
	ld [H_MULTIPLYBUFFER+2], a
	ld a, [H_MULTIPLYBUFFER+1]
	ld c, a
	ld a, [H_MULTIPLICAND]
	adc c
	ld [H_MULTIPLYBUFFER+1], a
	ld a, [H_MULTIPLYBUFFER]
	ld c, a
	ld a, [H_PRODUCT]
	adc c
	ld [H_MULTIPLYBUFFER], a
.smallMultiplier
	dec b
	jr z, .done
	ld a, [H_MULTIPLICAND+2]
	sla a
	ld [H_MULTIPLICAND+2], a
	ld a, [H_MULTIPLICAND+1]
	rl a
	ld [H_MULTIPLICAND+1], a
	ld a, [H_MULTIPLICAND]
	rl a
	ld [H_MULTIPLICAND], a
	ld a, [H_PRODUCT]
	rl a
	ld [H_PRODUCT], a
	jr .multiplyLoop
.done
	ld a, [H_MULTIPLYBUFFER+3]
	ld [H_PRODUCT+3], a
	ld a, [H_MULTIPLYBUFFER+2]
	ld [H_PRODUCT+2], a
	ld a, [H_MULTIPLYBUFFER+1]
	ld [H_PRODUCT+1], a
	ld a, [H_MULTIPLYBUFFER]
	ld [H_PRODUCT], a
	ret

_Divide:
	xor a
	ld [H_DIVIDEBUFFER], a
	ld [H_DIVIDEBUFFER+1], a
	ld [H_DIVIDEBUFFER+2], a
	ld [H_DIVIDEBUFFER+3], a
	ld [H_DIVIDEBUFFER+4], a
	ld a, $9
	ld e, a
.asm_f6680
	ld a, [H_DIVIDEBUFFER]
	ld c, a
	ld a, [H_DIVIDEND+1]
	sub c
	ld d, a
	ld a, [H_DIVISOR]
	ld c, a
	ld a, [H_DIVIDEND]
	sbc c
	jr c, .asm_f669b
	ld [H_DIVIDEND], a
	ld a, d
	ld [H_DIVIDEND+1], a
	ld a, [H_DIVIDEBUFFER+4]
	inc a
	ld [H_DIVIDEBUFFER+4], a
	jr .asm_f6680
.asm_f669b
	ld a, b
	cp $1
	jr z, .done
	ld a, [H_DIVIDEBUFFER+4]
	sla a
	ld [H_DIVIDEBUFFER+4], a
	ld a, [H_DIVIDEBUFFER+3]
	rl a
	ld [H_DIVIDEBUFFER+3], a
	ld a, [H_DIVIDEBUFFER+2]
	rl a
	ld [H_DIVIDEBUFFER+2], a
	ld a, [H_DIVIDEBUFFER+1]
	rl a
	ld [H_DIVIDEBUFFER+1], a
	dec e
	jr nz, .asm_f66d1
	ld a, $8
	ld e, a
	ld a, [H_DIVIDEBUFFER]
	ld [H_DIVISOR], a
	xor a
	ld [H_DIVIDEBUFFER], a
	ld a, [H_DIVIDEND+1]
	ld [H_DIVIDEND], a
	ld a, [H_DIVIDEND+2]
	ld [H_DIVIDEND+1], a
	ld a, [H_DIVIDEND+3]
	ld [H_DIVIDEND+2], a
.asm_f66d1
	ld a, e
	cp $1
	jr nz, .asm_f66d7
	dec b
.asm_f66d7
	ld a, [H_DIVISOR]
	srl a
	ld [H_DIVISOR], a
	ld a, [H_DIVIDEBUFFER]
	rr a
	ld [H_DIVIDEBUFFER], a
	jr .asm_f6680
.done
	ld a, [H_DIVIDEND+1]
	ld [H_REMAINDER], a
	ld a, [H_DIVIDEBUFFER+4]
	ld [H_QUOTIENT+3], a
	ld a, [H_DIVIDEBUFFER+3]
	ld [H_QUOTIENT+2], a
	ld a, [H_DIVIDEBUFFER+2]
	ld [H_QUOTIENT+1], a
	ld a, [H_DIVIDEBUFFER+1]
	ld [H_QUOTIENT], a
	ret
