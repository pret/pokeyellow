%include "dos_port/include/gb_memmap.inc"

SECTION .text

global FlagActionPredef
global FlagAction

FlagActionPredef:
	call GetPredefRegisters
	; fallthrough
FlagAction:
	push esi
	push edx
	push ebx

	; calculate bitmask in dl
	mov al, cl
	and al, 7
	mov dl, 1
	push ecx
	mov cl, al
	shl dl, cl
	pop ecx

	; byte offset
	mov al, cl
	shr al, 3
	movzx eax, al
	add esi, eax

	; check action in bh
	mov al, bh
	test al, al
	jz .reset
	cmp al, FLAG_TEST
	je .read

.set:
	mov al, [ebp + esi]
	or al, dl
	mov [ebp + esi], al
	jmp .done

.reset:
	mov al, dl
	not al
	and al, [ebp + esi]
	mov [ebp + esi], al
	jmp .done

.read:
	mov al, dl
	and al, [ebp + esi]

.done:
	pop ebx
	pop edx
	pop esi
	mov cl, al
	ret
