; dos_port/src/util/bcd.asm

%include "gb_macros.inc"
%include "gb_memmap.inc"

section .text

global DivideBCDPredef
global DivideBCDPredef2
global DivideBCDPredef3
global DivideBCDPredef4
global DivideBCD
global AddBCDPredef
global AddBCD
global SubBCDPredef
global SubBCD

DivideBCDPredef:
DivideBCDPredef2:
DivideBCDPredef3:
DivideBCDPredef4:
    extern GetPredefRegisters
    call GetPredefRegisters
    ; Fallthrough

DivideBCD:
    ; Emulate DivideBCD
    mov byte [ebp + H_DIVIDE_BCD_BUFFER], 0
    mov byte [ebp + H_DIVIDE_BCD_BUFFER + 1], 0
    mov byte [ebp + H_DIVIDE_BCD_BUFFER + 2], 0
    mov dh, 1

.mulBy10Loop:
    mov al, byte [ebp + H_DIVIDE_BCD_DIVISOR]
    test al, 0xF0
    jnz .next
    inc dh

    ; Shift divisor left by 1 nibble (multiply by 10 in BCD)
    mov al, byte [ebp + H_DIVIDE_BCD_DIVISOR]
    shl al, 4
    mov bl, al
    mov al, byte [ebp + H_DIVIDE_BCD_DIVISOR + 1]
    mov ch, al
    shr ch, 4
    or bl, ch
    mov byte [ebp + H_DIVIDE_BCD_DIVISOR], bl

    mov bl, al
    shl bl, 4
    mov al, byte [ebp + H_DIVIDE_BCD_DIVISOR + 2]
    mov ch, al
    shr ch, 4
    or bl, ch
    mov byte [ebp + H_DIVIDE_BCD_DIVISOR + 1], bl

    shl al, 4
    mov byte [ebp + H_DIVIDE_BCD_DIVISOR + 2], al
    jmp .mulBy10Loop

.next:
    push dx
    push dx
    call DivideBCD_getNextDigit
    pop dx
    
    mov al, bh
    shl al, 4
    mov byte [ebp + H_DIVIDE_BCD_BUFFER], al
    
    dec dh
    jz .next2

    push dx
    call DivideBCD_divDivisorBy10
    call DivideBCD_getNextDigit
    pop dx

    mov al, byte [ebp + H_DIVIDE_BCD_BUFFER]
    or al, bh
    mov byte [ebp + H_DIVIDE_BCD_BUFFER], al

    dec dh
    jz .next2

    push dx
    call DivideBCD_divDivisorBy10
    call DivideBCD_getNextDigit
    pop dx

    mov al, bh
    shl al, 4
    mov byte [ebp + H_DIVIDE_BCD_BUFFER + 1], al

    dec dh
    jz .next2

    push dx
    call DivideBCD_divDivisorBy10
    call DivideBCD_getNextDigit
    pop dx

    mov al, byte [ebp + H_DIVIDE_BCD_BUFFER + 1]
    or al, bh
    mov byte [ebp + H_DIVIDE_BCD_BUFFER + 1], al

    dec dh
    jz .next2

    push dx
    call DivideBCD_divDivisorBy10
    call DivideBCD_getNextDigit
    pop dx

    mov al, bh
    shl al, 4
    mov byte [ebp + H_DIVIDE_BCD_BUFFER + 2], al

    dec dh
    jz .next2

    push dx
    call DivideBCD_divDivisorBy10
    call DivideBCD_getNextDigit
    pop dx

    mov al, byte [ebp + H_DIVIDE_BCD_BUFFER + 2]
    or al, bh
    mov byte [ebp + H_DIVIDE_BCD_BUFFER + 2], al

.next2:
    mov al, byte [ebp + H_DIVIDE_BCD_BUFFER]
    mov byte [ebp + H_DIVIDE_BCD_QUOTIENT], al
    mov al, byte [ebp + H_DIVIDE_BCD_BUFFER + 1]
    mov byte [ebp + H_DIVIDE_BCD_QUOTIENT + 1], al
    mov al, byte [ebp + H_DIVIDE_BCD_BUFFER + 2]
    mov byte [ebp + H_DIVIDE_BCD_QUOTIENT + 2], al

    pop dx
    mov al, 6
    sub al, dh
    test al, al
    jz .done

.divResultBy10loop:
    push ax
    call DivideBCD_divDivisorBy10
    pop ax
    dec al
    jnz .divResultBy10loop

.done:
    ret

DivideBCD_divDivisorBy10:
    mov al, byte [ebp + H_DIVIDE_BCD_DIVISOR + 2]
    mov bl, al
    shr bl, 4
    
    mov al, byte [ebp + H_DIVIDE_BCD_DIVISOR + 1]
    mov ch, al
    shl ch, 4
    or bl, ch
    mov byte [ebp + H_DIVIDE_BCD_DIVISOR + 2], bl

    mov bl, al
    shr bl, 4
    
    mov al, byte [ebp + H_DIVIDE_BCD_DIVISOR]
    mov ch, al
    shl ch, 4
    or bl, ch
    mov byte [ebp + H_DIVIDE_BCD_DIVISOR + 1], bl

    shr al, 4
    mov byte [ebp + H_DIVIDE_BCD_DIVISOR], al
    ret

DivideBCD_getNextDigit:
    mov cx, 3
    xor bh, bh ; 'b' in SM83, mapped to BH
.loop_getnext:
    ; Compare StringCmp (hMoney vs hDivideBCDDivisor)
    ; we will just do a manual compare since we don't want to call external StringCmp if not needed,
    ; but let's call it to be safe, StringCmp is probably elsewhere.
    ; Wait, StringCmp is in predefs or util. We can just call it!
    mov edx, H_MONEY
    mov esi, H_DIVIDE_BCD_DIVISOR
    push cx
    extern StringCmp
    call StringCmp
    pop cx
    jc .done_getnext ; ret c

    inc bh
    mov edx, H_MONEY + 2
    mov esi, H_DIVIDE_BCD_DIVISOR + 2
    push cx
    call SubBCD
    pop cx
    jmp .loop_getnext
.done_getnext:
    ret

AddBCDPredef:
    extern GetPredefRegisters
    call GetPredefRegisters
    ; Fallthrough

AddBCD:
    ; AddBCD adds [hl] to [de] for c bytes.
    ; ESI = hl, EDX = de, CL = c
    test al, al ; clear carry
    mov ch, cl  ; b = c (CH used as B)
.add:
    mov al, [ebp + edx]
    mov bl, [ebp + esi]
    
    ; Add with carry
    ; Wait! x86 has AAA/DAA.
    ; AL is the destination. We do adc, then daa.
    adc al, bl
    daa
    
    mov [ebp + edx], al
    dec edx
    dec esi
    dec cl
    jnz .add
    jnc .done
    
    mov al, 0x99
    inc edx
.fill:
    mov [ebp + edx], al
    inc edx
    dec ch
    jnz .fill
.done:
    ret


SubBCDPredef:
    call GetPredefRegisters
    ; Fallthrough

SubBCD:
    ; SubBCD subtracts [hl] from [de] for c bytes.
    ; ESI = hl, EDX = de, CL = c
    test al, al ; clear carry
    mov ch, cl  ; b = c
.sub_loop:
    mov al, [ebp + edx]
    mov bl, [ebp + esi]
    
    sbc al, bl
    das
    
    mov [ebp + edx], al
    dec edx
    dec esi
    dec cl
    jnz .sub_loop
    jnc .done_sub
    
    mov al, 0x00
    inc edx
.fill_sub:
    mov [ebp + edx], al
    inc edx
    dec ch
    jnz .fill_sub
    stc ; set carry
.done_sub:
    ret
