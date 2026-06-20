%include "dos_port/include/gb_memmap.inc"

SECTION .text

global GetPredefPointer

GetPredefPointer:
	; save hl (esi)
	mov eax, esi
	mov [ebp + wPredefHL + 1], al
	shr eax, 8
	mov [ebp + wPredefHL], al

	; save de (dx)
	mov [ebp + wPredefDE], dh
	mov [ebp + wPredefDE + 1], dl

	; save bc (bx)
	mov [ebp + wPredefBC], bh
	mov [ebp + wPredefBC + 1], bl

	; PredefPointers lookup
	mov al, [ebp + wPredefID]
	movzx ecx, al
	lea ecx, [ecx + ecx*2]

	lea edi, [PredefPointers + ecx]

	; get bank of predef routine
	mov al, [edi]
	mov [ebp + wPredefBank], al

	; get pointer
	mov al, [edi + 1]
	mov ah, [edi + 2]
	movzx esi, ax

	ret

; We leave the include here to be assembled if needed,
; or it can be resolved by the linker.
; %include "data/predef_pointers.asm"
