set gnutarget coff-go32-exe
file PKMN.EXE
target remote localhost:1234
layout asm

echo \n==============================================\n
echo Testing Center Invariant (Player Sprite Lock)\n
echo ==============================================\n

break *0x168a
commands
    silent
    echo \n[Sprite Render] Register State (Pre-Write):\n
    info registers eax
    echo \nExpected Player Sprite Coordinate at rest:\n
    echo Y-Axis: 92 (0x5c)\n
    echo X-Axis: 152 (0x98)\n
    continue
end

continue
