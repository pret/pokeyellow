; joypad.asm — INT 9h keyboard ISR → emulated GB joypad state.
;
; Hooks IRQ 1 (protected-mode vector 9) via DPMI, reads scancodes from port
; 0x60, and maintains two pressed-state nibbles in GB bit order:
;
;   pad_dpad    bit 0=Right  1=Left  2=Up    3=Down    (1 = held)
;   pad_buttons bit 0=A      1=B     2=Select 3=Start  (1 = held)
;
; Key mapping:
;   Arrow keys        → D-pad      (both E0-prefixed and numpad scancodes)
;   X                 → A
;   Z                 → B
;   Right Shift / Tab → Select
;   Enter             → Start
;   Esc               → sets [pad_quit] (host-side quit, not a GB button)
;
; joypad_update (called once per frame) composes the IO_JOYP shadow from
; these nibbles using the select bits the game last wrote to rJOYP:
; bit 4 low selects the D-pad nibble, bit 5 low selects the buttons nibble,
; and pressed keys read as 0 (GB joypad lines are active-low).
;
; ISR NOTE: we do NOT chain to the BIOS INT 9 handler, so DOS keyboard
; buffering is dead while the game runs (keys can't leak into the DOS prompt).
; joypad_restore puts the original vector back on exit. Same [cs:var] DS
; recovery technique as the PIT ISR (see boot/timing.asm).
;
; Build: nasm -f coff -I include/ -o joypad.o joypad.asm

bits 32

%include "gb_memmap.inc"
%include "gb_macros.inc"

KBD_INT         equ 0x09    ; protected-mode vector for IRQ 1
KBD_DATA_PORT   equ 0x60
PIC_CMD_PORT    equ 0x20
PIC_EOI         equ 0x20

; Scancodes (set 1, make codes; break = make | 0x80)
SC_EXT          equ 0xE0    ; extended-key prefix
SC_UP           equ 0x48
SC_DOWN         equ 0x50
SC_LEFT         equ 0x4B
SC_RIGHT        equ 0x4D
SC_X            equ 0x2D
SC_Z            equ 0x2C
SC_ENTER        equ 0x1C
SC_RSHIFT       equ 0x36
SC_TAB          equ 0x0F
SC_ESC          equ 0x01

; GB joypad bit positions (match constants/hardware.inc rJOYP semantics)
PAD_RIGHT_BIT   equ 0
PAD_LEFT_BIT    equ 1
PAD_UP_BIT      equ 2
PAD_DOWN_BIT    equ 3
PAD_A_BIT       equ 0
PAD_B_BIT       equ 1
PAD_SELECT_BIT  equ 2
PAD_START_BIT   equ 3

JOYP_GET_DPAD   equ 0x10    ; rJOYP bit 4 low → D-pad nibble selected
JOYP_GET_BTN    equ 0x20    ; rJOYP bit 5 low → buttons nibble selected

; ---------------------------------------------------------------------------
; Exported symbols
; ---------------------------------------------------------------------------
global joypad_init
global joypad_restore
global joypad_update
global pad_dpad             ; byte: D-pad held state (1 = pressed)
global pad_buttons          ; byte: button held state (1 = pressed)
global pad_quit             ; byte: nonzero once Esc is pressed

; ---------------------------------------------------------------------------
; BSS
; ---------------------------------------------------------------------------
section .bss
align 4
orig_irq1_off:  resd 1
orig_irq1_sel:  resw 1
pad_dpad:       resb 1
pad_buttons:    resb 1
pad_quit:       resb 1
ext_pending:    resb 1      ; set when an E0 prefix byte was just received

; ---------------------------------------------------------------------------
; Data — reachable from the ISR via CS override (CS base == DS base, DJGPP)
; ---------------------------------------------------------------------------
section .data
align 4
kisr_ds:        dw 0

; ---------------------------------------------------------------------------
; Code
; ---------------------------------------------------------------------------
section .text

; ---------------------------------------------------------------------------
; joypad_init — save the original IRQ1 vector and install kbd_isr
; ---------------------------------------------------------------------------
joypad_init:
    push eax
    push ebx
    push ecx
    push edx

    mov ax, ds
    mov [kisr_ds], ax

    ; Save original protected-mode IRQ1 vector (DPMI fn 0204h)
    mov ax, 0x0204
    mov bl, KBD_INT
    int 0x31
    mov [orig_irq1_off], edx
    mov [orig_irq1_sel], cx

    ; Install kbd_isr (DPMI fn 0205h)
    mov ax, 0x0205
    mov bl, KBD_INT
    mov cx, cs
    mov edx, kbd_isr
    int 0x31

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

; ---------------------------------------------------------------------------
; joypad_restore — put the original IRQ1 vector back (call before exit)
; ---------------------------------------------------------------------------
joypad_restore:
    push eax
    push ebx
    push ecx
    push edx

    mov ax, 0x0205
    mov bl, KBD_INT
    mov cx, [orig_irq1_sel]
    mov edx, [orig_irq1_off]
    int 0x31

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

; ---------------------------------------------------------------------------
; kbd_isr — IRQ 1 handler: read scancode, update pad state, EOI
; ---------------------------------------------------------------------------
kbd_isr:
    push ds
    push es
    push eax
    push ebx

    mov ax, [cs:kisr_ds]
    mov ds, ax
    mov es, ax

    in  al, KBD_DATA_PORT

    cmp al, SC_EXT
    jne .not_prefix
    mov byte [ext_pending], 1
    jmp .eoi
.not_prefix:
    mov byte [ext_pending], 0   ; consume prefix state (arrows decode the same
                                ; with or without E0, so it isn't needed yet)

    ; BL = make code, BH = 0 for press / nonzero for release
    mov bl, al
    and bl, 0x7F
    mov bh, al
    and bh, 0x80

    ; --- D-pad ---
    cmp bl, SC_RIGHT
    jne .chk_left
    mov al, 1 << PAD_RIGHT_BIT
    jmp .apply_dpad
.chk_left:
    cmp bl, SC_LEFT
    jne .chk_up
    mov al, 1 << PAD_LEFT_BIT
    jmp .apply_dpad
.chk_up:
    cmp bl, SC_UP
    jne .chk_down
    mov al, 1 << PAD_UP_BIT
    jmp .apply_dpad
.chk_down:
    cmp bl, SC_DOWN
    jne .chk_a
    mov al, 1 << PAD_DOWN_BIT
    jmp .apply_dpad

    ; --- Buttons ---
.chk_a:
    cmp bl, SC_X
    jne .chk_b
    mov al, 1 << PAD_A_BIT
    jmp .apply_btn
.chk_b:
    cmp bl, SC_Z
    jne .chk_start
    mov al, 1 << PAD_B_BIT
    jmp .apply_btn
.chk_start:
    cmp bl, SC_ENTER
    jne .chk_sel1
    mov al, 1 << PAD_START_BIT
    jmp .apply_btn
.chk_sel1:
    cmp bl, SC_RSHIFT
    je .sel
    cmp bl, SC_TAB
    jne .chk_esc
.sel:
    mov al, 1 << PAD_SELECT_BIT
    jmp .apply_btn

    ; --- Host quit ---
.chk_esc:
    cmp bl, SC_ESC
    jne .eoi
    test bh, bh
    jnz .eoi                    ; quit on press, ignore release
    mov byte [pad_quit], 1
    jmp .eoi

.apply_dpad:
    test bh, bh
    jnz .release_dpad
    or  [pad_dpad], al
    jmp .eoi
.release_dpad:
    not al
    and [pad_dpad], al
    jmp .eoi

.apply_btn:
    test bh, bh
    jnz .release_btn
    or  [pad_buttons], al
    jmp .eoi
.release_btn:
    not al
    and [pad_buttons], al

.eoi:
    mov al, PIC_EOI
    out PIC_CMD_PORT, al

    pop ebx
    pop eax
    pop es
    pop ds
    iret

; ---------------------------------------------------------------------------
; joypad_update — compose the IO_JOYP shadow from the held-state nibbles
;
; Called once per frame from the main loop. Respects the select bits the
; game last wrote to rJOYP (bits 4/5, active low) and presents pressed keys
; as 0 in bits 0–3, matching real GB joypad reads. Unused high bits read 1.
;
; In:  EBP = GB memory base. All registers preserved.
; ---------------------------------------------------------------------------
joypad_update:
    push eax
    push ebx

    mov al, [ebp + IO_JOYP]
    or  al, 0xCF                ; start with all input lines released (1)

    test al, JOYP_GET_DPAD      ; bit 4 low → D-pad selected
    jnz .no_dpad
    mov bl, [pad_dpad]
    not bl
    or  bl, 0xF0
    and al, bl
.no_dpad:
    test al, JOYP_GET_BTN       ; bit 5 low → buttons selected
    jnz .no_btn
    mov bl, [pad_buttons]
    not bl
    or  bl, 0xF0
    and al, bl
.no_btn:
    mov [ebp + IO_JOYP], al

    ; Build hJoyHeld in GB joypad byte format (active HIGH):
    ;   bit 7=Down  6=Up  5=Left  4=Right  (pad_dpad shifted up by 4)
    ;   bit 3=Start 2=Select 1=B  0=A      (pad_buttons as-is, same bit order)
    movzx eax, byte [pad_dpad]   ; bits 3=Down,2=Up,1=Left,0=Right
    shl al, 4                    ; → bits 7=Down,6=Up,5=Left,4=Right
    or  al, [pad_buttons]        ; merge A/B/Select/Start in low nibble
    mov [ebp + H_JOY_HELD], al

    pop ebx
    pop eax
    ret
