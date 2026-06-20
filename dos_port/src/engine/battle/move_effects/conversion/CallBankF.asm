; ╔══════════════════════════════════════════════════════════╗
; ║              PKMNDOS TRANSLATION MANIFEST               ║
; ╚══════════════════════════════════════════════════════════╝
; queue_id   : 1835
; label      : CallBankF
; source     : engine/battle/move_effects/conversion.asm
; category   : simple
; scratch    : dos_port/scratch/1835__CallBankF.asm
; -----------------------------------------------------------
; target      : dos_port/src/engine/battle/move_effects/conversion/CallBankF.asm
; aggregator  : dos_port/src/engine/battle/move_effects/conversion.asm
; -----------------------------------------------------------
; WORKER NOTES — fill in before calling work_queue complete
; registers   : B→BH
; hflag       : not involved
; bug_tags    : none
; notes       : loaded BANK_PrintButItFailedText_ via EAX to avoid 8-bit relocation error
; ╔══════════════════════════════════════════════════════════╗
; ║  CODE BELOW — do not modify the header above            ║
; ╚══════════════════════════════════════════════════════════╝

extern Bankswitch
extern BANK_PrintButItFailedText_

CallBankF:
    push eax
    mov eax, BANK_PrintButItFailedText_
    mov bh, al
    pop eax
    jmp Bankswitch
