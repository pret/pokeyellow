%macro text_far 1
    db 0x17
    dd %1
%endmacro

%macro text_end 0
    db 0x50
%endmacro
