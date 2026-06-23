%include "gb_memmap.inc"
%include "gb_macros.inc"

extern Bankswitch
extern _LightScreenProtectedText
extern _ReflectGainedArmorText

global EffectCallBattleCore
EffectCallBattleCore:
    mov bh, 0
    jmp Bankswitch

global LightScreenProtectedText
LightScreenProtectedText:
    db 0x17
    dd _LightScreenProtectedText
    db 0x50

global ReflectGainedArmorText
ReflectGainedArmorText:
    db 0x17 ; TX_FAR
    dd _ReflectGainedArmorText
    db 0x50 ; TX_END
