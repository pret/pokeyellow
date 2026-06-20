# Source: https://glitchcity.wiki/wiki/Pok%C3%A9mon_Yellow_predefined_functions_list

This is a list of Pokémon Yellow (/wiki/Pok%C3%A9mon_Yellow) predefined functions. All values are in hexadecimal (/wiki/Hexadecimal).

Some values that are stated "Nonfunctional" and "Softlock" may do something when certain conditions are met.

## Executing predefined functions
## 

## Hacked ROM
## 
Predefined functions can be executed with TheZZAZZGlitch (https://forums.glitchcity.info/index.php?action=profile;u=1199)'s debug Pokémon Yellow by using the "Debug" item (known as "31337" in earlier ROMs), which can be withdrawn from the player's PC at the beginning of the game or added as item 1 with the GameShark (/wiki/GameShark) code 012C1DD3.

In at least the latest revision, one must use the debug item, select "Miscellaneous", scroll down to "Predef [7 heal]", adjust the value with right (ID +01h) and/or left (ID+10h) and press A to run the predefined function.

## List of predefined functions
## 
00: Shows in-battle HUD for exactly 5 frames

01 - 03: Nonfunctional

04: Writes random garbage to tile graphics. Effect is cosmetic.

05 - 06: Nonfunctional

07: Instant Pokemon Center (no animation, but HP and PP refilled and status restored to normal)

08: Nonfunctional

09: Softlock

0A: Softlock

0B - 0C: Nonfunctional

0D - 0E: Softlock

0F: Initialises Player Data (Party, items, badges only)

10 - 17: Nonfunctional

18: Initialises Player Data

19 - 1A: Nonfunctional

1B: First PKMN learns move named &lt;insert first item in bag here&gt;, but doesn't actually work

1C - 1E: Nonfunctional

1F: Poison screen flash, no sound effect or health decrease

20: Disables Up and Down button input, menus included. (Curious.)

21: Vertical screen shake

22 - 23: Nonfunctional

24: Horizontal screen shake

25: Softlock

26 - 28: Nonfunctional

29: Pokedex menu

2A: Nonfunctional

2B: Saves the game to SRAM0

2C: Battle start, works

2D: Nonfunctional

2E: Draws the 8 badges on the Trainer menu for 5 frames (uses the tileset of the loaded map)

2F: Trade, nonfunctional

30: Plays the battle transition

31: Small amounts of tile corruption, text to be specific.

32: Plays the Intro. Returns to the overworld when finished, but does not reload graphics. Any NPCs onscreen will show on-screen during intro.

33: Nonfunctional

34: Flashes the screen indefinitely.

35: Nonfunctional

36: First page of first pokemon's stats

37: Second page of first pokemon's stats

38: Functional trade

39 - 3A: Nonfunctional

3B: All tiles and sound filled with garbage.

3C: Cut, working

3D: Pokedex data... of Hitmonchan.

3E: Nonfunctional

3F: Working save

40: Hangs for exactly 15 frames

41 - 45: Nonfunctional

46: Softlock

47: Nonfunctional

48: Softlock

49: Heals opponent in battle, outside of battle HUD replaced with text

4A: Hitmonchan's Nest page

4B: Nonfunctional

4C: Displays Emotion Bubble. Replaces text tiles 2, 3, 4, and 5 with "Trainer spotted you!" bubble.

4D: Nonfunctional

4E: "Nickname?" for Hitmonchan

4F: Softlock

50: Saves to SRAM2

51: Nonfunctional

52: Goes to a white screen and forcibly loads the save file, gives "file data is destroyed!" message if one does not exist. Pokemon and item data is loaded correctly however the tileset for the map is not changed if the save was in a different map.

53: Saves to SRAM1

54: "Wanna trade CLEFAIRY for MR.MIME?"

55: Enter Hall of Fame, then credits. Works, but then dumps you back into whatever state you were in before calling. Does not reload graphics.

56: Professor Oak's Rating

57: Softlock

58 - 5A: Nonfunctional

5B: First item used Strength, functional

5C - 60: Nonfunctional

61: Elevator menu with invalid floors. The menu may display mart items. If inside an Elevator after selecting an option, the elevator will move after exiting the menu but you will exit to a glitched map.

62: If you caught 0 kinds of pokemon, get item 0x00.

63 - 81: Softlock

82: Nonfunctional

83 - 8C: Softlock

8D: Small screen corruption, then softlock

8E - 8F: Softlock

90: Nonfunctional

91: Softlock

92: Text Box full of "BLUE" and whitespace

93: Screen fills with second tile of "GYM" and crash.

94: Nonfunctional

95 - 98: Softlock

99: Nonfunctional

9A - 9F: Softlock

A0: Nonfunctional

A1: Softlock

A2: "[]5 error." where [] = tile 25

A3 - A5: Softlock

A6: Nonfunctional

A7: Text box similar to 92 but filled with "LAPRAS" instead of "BLUE".

A8: Nonfunctional

A9: Softlock

AA: Nonfunctional

AB: Battle HUD appears, then "It's not very effective..." appears

AC: See 92

AD: Softlock

AE: Nonfunctional

AF: 3TRAINERPOKe (that always turns into a Rhydon, not due to the Rhydon trap (/wiki/Rhydon_trap)) was caught!

B0: Text scramble, then crash

B1 - B5: Softlock

B6: Pops all text boxes

B7 - FF: Softlock/Nonfunctional

Retrieved from "https://glitchcity.wiki/wiki/Pokémon_Yellow_predefined_functions_list?oldid=31118 (https://glitchcity.wiki/wiki/Pokémon_Yellow_predefined_functions_list?oldid=31118)"