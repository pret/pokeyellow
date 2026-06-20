%include "dos_port/include/gb_memmap.inc"

SECTION .text

global ReadJoypad_
global _Joypad
global DiscardButtonPresses
global TrySoftReset

ReadJoypad_:
	mov al, [ebp + hDisableJoypadPolling]
	test al, al
	jnz .done

	mov al, 1 << 5
	mov [ebp + IO_JOYP], al
	mov al, [ebp + IO_JOYP]
	mov al, [ebp + IO_JOYP]
	not al
	and al, 0x0F
	shl al, 4
	mov bh, al

	mov al, 1 << 4
	mov [ebp + IO_JOYP], al
	mov al, [ebp + IO_JOYP]
	mov al, [ebp + IO_JOYP]
	mov al, [ebp + IO_JOYP]
	mov al, [ebp + IO_JOYP]
	mov al, [ebp + IO_JOYP]
	mov al, [ebp + IO_JOYP]
	not al
	and al, 0x0F
	or al, bh
	mov [ebp + hJoyInput], al

	mov al, (1 << 4) | (1 << 5)
	mov [ebp + IO_JOYP], al
.done:
	ret

_Joypad:
	mov al, [ebp + hJoyInput]
	mov bh, al
	and al, PAD_BUTTONS | PAD_UP
	cmp al, PAD_BUTTONS
	je TrySoftReset

	mov al, [ebp + hJoyLast]
	mov dl, al
	xor al, bh
	mov dh, al
	and al, dl
	mov [ebp + hJoyReleased], al
	mov al, dh
	and al, bh
	mov [ebp + hJoyPressed], al
	mov al, bh
	mov [ebp + hJoyLast], al

	mov al, [ebp + wStatusFlags5]
	test al, 1 << BIT_DISABLE_JOYPAD
	jnz DiscardButtonPresses

	mov al, [ebp + hJoyLast]
	mov [ebp + hJoyHeld], al

	mov al, [ebp + wJoyIgnore]
	test al, al
	jz .done_ignore

	not al
	mov bh, al
	mov al, [ebp + hJoyHeld]
	and al, bh
	mov [ebp + hJoyHeld], al
	mov al, [ebp + hJoyPressed]
	and al, bh
	mov [ebp + hJoyPressed], al
.done_ignore:
	ret

DiscardButtonPresses:
	xor al, al
	mov [ebp + hJoyHeld], al
	mov [ebp + hJoyPressed], al
	mov [ebp + hJoyReleased], al
	ret

TrySoftReset:
	call DelayFrame

	mov al, 0x30
	mov [ebp + IO_JOYP], al

	dec byte [ebp + hSoftReset]
	jz SoftReset

	jmp Joypad
