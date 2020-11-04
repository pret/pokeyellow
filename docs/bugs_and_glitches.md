# Bugs and Glitches

These are sections of the original Pokémon Yellow game code that clearly do not work as intended or only work in limited circumstances.

Fixes are written in the `diff` format. If you've used Git before, this should look familiar:

```diff
 this is some code
-delete red - lines
+add green + lines
```


## Contents

- [Options Menu Code Fails to Clear Joypad State on Initialization](#options-menu-code-fails-to-clear-joypad-state-on-initialization)
- [Battle Transitions Fail to Account for Scripted Battles](#battle-transitions-fail-to-account-for-scripted-battles)
- [wPikachuFollowCommandBuffer can Overflow](#wpikachufollowcommandbuffer-can-overflow)
- [Unexpected Counter Damage](#unexpected-counter-damage)

## Options Menu Code Fails to Clear Joypad State on Initialization

This bug (or feature!) results in all options being shifted left or right if the respective direction is pressed on the same frame the options menu is opened.
The bug also exists in pokegold and pokecrystal.

**Fix:** Update [engine/menus/options.asm](/engine/menus/options.asm)

```diff
  DisplayOptionMenu_:
+
+   call JoypadLowSensitivity
    call InitOptionsMenu
```

## Battle Transitions Fail to Account for Scripted Battles

When Oak Catches Pikachu in the Pallet Town cutscenes you don't yet have any Pokemon in Party.
The Battle Transitions code has no error handling for this and reads wPartyMon1HP from wRivalName+6.
This means you can manipulate this first transition to be faster by choosing a default rival name or writing and deleting 6 characters in a custom rival name.
A similar series of bugs appears to exist in pokecrystal.

**Fix:** TBD in [engine/battle/battle_transitions.asm#L93](/engine/battle/battle_transitions.asm#L93)

## wPikachuFollowCommandBuffer can Overflow

AppendPikachuFollowCommandToBuffer doesn't have any length checking for the buffer of Pikachu commands.
This can be abused to write data into any address past d437, typically by putting pikachu to sleep in the Pewter Center with Jigglypuff.
While in this state, walking down writes 01, up 02, left 03, and right 04.
This bug is generally known as "Pikawalk."
A typical use for this would be to force the in game time to 255:59.

**Fix:** TBD in [engine/pikachu_follow.asm#1165](/engine/pikachu_follow.asm#1165)

## Unexpected Counter Damage

Counter simply doubles the value of wDamage which can hold the last value of damage dealt whether it was from you, your opponent, a switched out opponent, or a player in another battle.
This is because wDamage is used for both the player's damage and opponent's damage, and is not cleared out between switching or battles.

**Fix:** TBD in [engine/battle/core.asm#L4960](/engine/battle/core.asm#L4960)
