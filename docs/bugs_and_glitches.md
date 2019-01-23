# Bugs and Glitches

These are known bugs and glitches in the original Pokémon Yellow game: code that clearly does not work as intended, or that only works in limited circumstances but has the possibility to fail or crash.

Fixes are written in the `diff` format. If you've used Git before, this should look familiar:

```diff
 this is some code
-delete red - lines
+add green + lines
```


## Contents

- [Options Menu Code Fails to Clear Joypad State on Initialization](#options-menu-code-fails-to-clear-joypad-state-on-initialization)
- [Battle Transitions Fail to Account for Scripted Battles](#battle-transitions-fail-to-account-for-scripted-battles)


## Options Menu Code Fails to Clear Joypad State on Initialization

This bug (or feature!) results in all options being shifted left or right if the respective direction is pressed on the same frame the options menu is opened.
The bug also exists in pokegold and pokecrystal.

**Fix:** Update [engine/menu/options.asm](/engine/menu/options.asm)

```diff
 DisplayOptionMenu_:
 +  call JoypadLowSensitivity
    call InitOptions
```

## Battle Transitions Fail to Account for Scripted Battles

When Oak Catches Pikachu in the Pallet Town cutscenes you don't yet have any Pokemon in Party.
The Battle Transitions code has no error handling for this and reads wPartyMon1HP from wRivalName+6.
This means you can manipulate this first transition to be faster by choosing a default rival name or writing and deleting 6 characters in a custom rival name.
A similar series of bugs appears to exist in pokecrystal.

**Fix:** TBD in [engine/battle/battle_transitions.asm](/engine/battle/battle_transitions.asm)