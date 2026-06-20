# Source: https://glitchcity.wiki/wiki/Guides:SRAM_Glitch_ACE_Setups_(EN_Yellow)

This page serves as a repository for a method to quickly build an advanced ACE setup, starting from a fresh save file. This method can be used for the English release of Yellow. It is part of the TimoVM's Gen 1 ACE setups (/wiki/Guides:TimoVM%27s_gen_1_ACE_setups) set of guides.

The methods described here were heavily inspired by previous SRAM glitch setups developed by Evie (Chickasaurus GL), as well existing setups intended to be used for the Japanese releases.

 | (/wiki/File:Warning.png)

 | This guide has been deprecated. A faster and improved version of this guide can now be found at Guides:SRAM Glitch ACE Setups v2 (/wiki/Guides:SRAM_Glitch_ACE_Setups_v2).

The contents of this guide are demonstrated in the following video:

 | 

 
 
 
 Pokémon Yellow - Using glitches to quickly set up a versatile cheat engine
 Load video
 
 YouTube
 
 
 
 YouTube might collect personal data. Privacy Policy (https://www.youtube.com/howyoutubeworks/user-settings/privacy/)
 
 Continue
 Dismiss
 
 
 

 

 | YouTube video by TimoVM (https://www.youtube.com/watch?v=fCJsr6UQv7E)

## Contents
## 

- 1 Overview (#Overview)

- 2 Preparation (#Preparation)

- 2.1 Step 1: Starting a new game and setting up SRAM glitch (#Step_1:_Starting_a_new_game_and_setting_up_SRAM_glitch)

- 2.1.1 A quick note on the effects of SRAM glitch (#A_quick_note_on_the_effects_of_SRAM_glitch)

- 2.1.2 A quick note regarding unterminated name items (#A_quick_note_regarding_unterminated_name_items)

- 2.2 Step 2: Reaching Celadon City and enabling Fly (#Step_2:_Reaching_Celadon_City_and_enabling_Fly)

- 2.2.1 Setting up a pokémon that can use Fly (#Setting_up_a_pokémon_that_can_use_Fly)

- 2.3 Step 3: Assembling an item code in Celadon City (#Step_3:_Assembling_an_item_code_in_Celadon_City)

- 3 Nickname Writer Install (#Nickname_Writer_Install)

- 3.1 A note on using ACE (#A_note_on_using_ACE)

- 3.2 Note: unterminated name items in Eevee's room (#Note:_unterminated_name_items_in_Eevee's_room)

- 3.3 Step 4: Setting up Infinite Eevee mode (#Step_4:_Setting_up_Infinite_Eevee_mode)

- 3.4 Step 5: Setting up 4F to execute item codes (#Step_5:_Setting_up_4F_to_execute_item_codes)

- 3.5 Step 6: Setting up the Nickname Writer (#Step_6:_Setting_up_the_Nickname_Writer)

- 4 Clean-up (#Clean-up)

- 4.1 Step 7: Using the nickname writer (#Step_7:_Using_the_nickname_writer)

- 4.2 Step 8: Returning the game state to normal (#Step_8:_Returning_the_game_state_to_normal)

- 4.3 Additional applications of the Nickname Writer (#Additional_applications_of_the_Nickname_Writer)

- 5 Addendum: raw text transcripts of nickname codes (#Addendum:_raw_text_transcripts_of_nickname_codes)

- 5.1 Infinite Eevee Mode Nickname (#Infinite_Eevee_Mode_Nickname)

- 5.2 4F Bootstrap Nicknames (#4F_Bootstrap_Nicknames)

- 5.3 Nickname Writer (#Nickname_Writer)

- 6 Addendum: technical explanation of the setup (#Addendum:_technical_explanation_of_the_setup)

- 6.1 Nickname Converter Item Code (#Nickname_Converter_Item_Code)

- 6.1.1 Explanation (#Explanation)

- 6.1.2 Raw Assembly (#Raw_Assembly)

- 6.2 Infinite Eevee Nickname (#Infinite_Eevee_Nickname)

- 6.2.1 Explanation (#Explanation_2)

- 6.2.2 Raw Assembly (#Raw_Assembly_2)

- 6.3 4F Boostrap Nicknames (#4F_Boostrap_Nicknames)

- 6.3.1 Raw Assembly (#Raw_Assembly_3)

- 6.4 Using 4F (#Using_4F)

- 6.4.1 Explanation (#Explanation_3)

- 6.4.2 Raw Assembly (#Raw_Assembly_4)

- 6.5 Nickname Writer (#Nickname_Writer_2)

- 6.5.1 Explanation (#Explanation_4)

- 6.5.2 Raw Assembly (#Raw_Assembly_5)

- 6.6 Cleanup Code (new save) (#Cleanup_Code_(new_save))

- 6.6.1 Explanation (#Explanation_5)

- 6.6.2 Raw Assembly (#Raw_Assembly_6)

## Overview
## 
This page is intended to guide you through the process of installing an Arbitrary Code Execution (ACE) setup on the English release of pokémon Yellow. During this, we will be installing a small program that allows you to quickly and easily enter codes to trigger arbitrary effects, such as giving any pokémon or item.

This guide works both for cartridge and Virtual Console versions. In order to follow this guide, you must start from a fresh save file. The full install procedure should take around 60 minutes, depending on how fast you are at entering text.

In this guide, you will set up an ACE environment through the following process:

- Preparation, which focuses on setting up the required material for the setup.

- Nickname Writer Install, which focuses on installing a small, versatile program that can be used to trigger arbitrary effects.

- Clean-up, which focuses on using the Nickname Writer to clear away any and all side effects of the setup.
If you encounter any issues when going through this guide or would like to provide feedback, please contact TimoVM on the Glitch City Research Institute Discord (https://discord.gg/EA7jxJ6).

## Preparation
## 
The following things are needed to build the ACE setup:

- we need to erase any previous saved data to set up SRAM glitch, a unique glitched state that enables a multitude of secondary glitches.

- we need to reach Celadon City.

- we need to enable the use of Fly and have a pokémon that can use it.

- Using all of the above, you need to assemble a basic item code.
If you are looking to set up ACE on an existing save file that you do not wish to erase, please follow this link (/wiki/Guides:Safari_Escape_Underflow_ACE_Setups_(EN_Yellow)) to an alternative guide.

## Step 1: Starting a new game and setting up SRAM glitch
## 
First, we need to set up SRAM glitch.

- Clear all saved data by pressing UP + SELECT + B on the title screen and confirming that you want to erase all saved data. (This needs to be done even if no save data is present).

- Start up the game and go through the intro. Name your character and rival anything you want.

- Open the start menu, and select "Save".

- Select "Yes" in the "Yes/No" dialog box. At a very precise moment, power off or reset the console.

- Soft resetting (/wiki/Reset) (holding Start+Select+A+B) will not work, as the game prevents soft resets while it is saving.

- The timing to power off or reset is after the "Yes/No" dialog box has disappeared, but before the text changes to "Saving..." (Yellow).

- The time window between those two visual cues is around 20 frames (depending somewhat on the version and the circumstances), but the window to successfully perform this glitch is only 4 frames.

- Reload the game. If you can continue the game and can open the pokémon menu, you have successfully set up SRAM glitch and can continue with the guide. Otherwise, repeat the process from the start, erasing the save in the process.

## A quick note on the effects of SRAM glitch
## 
Thanks to clearing out the previous save using UP + SELECT + B, which fills saved data with $FF values, we will reload with a party consisting of 255 ($FF) pokémon. There are, however, quite a number of side effects due to this:

- Having 255 party pokémon makes us unable to enter battle without heavy side effects.

- It is not recommended to look at the summaries of any of our party pokémon.

- Thanks to having 255 party pokémon, we are able to swap pokémon beyond the 6th party slot.

- Every few steps, the game will act as if at least one party pokémon is poisoned. This effect can be freely ignored and has no harmful effect.
At the end of the guide, codes are provided that fix this glitched state and allow you to resume normal game progression.

## A quick note regarding unterminated name items
## 
Certain glitch items lack a proper string terminator. When you select them, either by pressing A or select when highlighting them in the bag, these items will crash the game. On the Virtual Console releases, this has a possibility of erasing your save. When you see any item with an unusually long glitched name, please make sure to not use either of these buttons to select them.

In certain maps, such as Celadon City, opening the item bag or scrolling the item bag to display an unterminated name item will cause the game to seemingly freeze. You can cause the game to safely resume by tapping B regularly until the game continues.

In the Celadon City map, unterminated name items can be made safe to handle as long as at least one tree is visible on the upper row of the map while the start screen is opened. Under these circumstances, unterminated name items can be safely selected with A or SELECT. This will also ensure that you do not need to tap B multiple times in order to scroll through unterminated name items, but certain items may still require a single B press to scroll through.

During the guide, care is taken to ensure that we'll stand on these safe spots when using the item bag as much as possible.

## Step 2: Reaching Celadon City and enabling Fly
## 
With SRAM glitch active, we'll warp to Celadon City and make sure that we can use Fly.

 | Place to stand

 | (/wiki/File:MasterBallLocationY.png)

- Go downstairs and exit your house to Pallet Town. (This registers Pallet Town as a Fly location, preventing a possible crash at a later point in the guide.)

- Go back inside your house and take a single step to the right, so you end up at the location indicated by the screenshot above.

- Open the party menu and swap the 2nd party pokémon with the 10th pokémon. This sets the amount of pokémon caught in the pokédex to 152, as well as setting the amount of items in the bag to 255.

- Open the item bag and scroll down to the 36th item slot. This will be a Master Ball with quantity x0 (see screenshots below).

- Toss a total of 250 items from this Master Ball, for a final quantity of 6. (When tossing, you can press down to underflow the amount of items to be tossed from 0 to 255, then press down 5 more times.)

- Exit your house. Thanks to changing the item quantity, you will exit to Celadon City.

 | Slot #36

 | (/wiki/File:MasterBallMenuENY.png)

## Setting up a pokémon that can use Fly
## 
In order to assemble the required item code, we need a pokémon that knows Fly and we need the necessary badge to be able to use it.

 | Potion location

 | (/wiki/File:PotionLocationINTY.png)

- From the right entrance of the Celadon Dept. Store, walk as follows:

- 6 steps right

- 4 steps up

- 6 steps right

- 4 steps up

- You are now at the spot indicated by the above screenshot on the left. At this spot, the item in the 35th item slot will have turned into a Potion x0, as indicated by the below screenshots.

- Using Select, swap this Potion x0 to the 29th item slot. Check your trainer card, you should now have the third and fifth badges, allowing you to use both Surf and Fly.

- In the 39th item slot, you'll find a TM23 x64 stack. Toss 45 items from this stack until you get a TM23 x19 stack, then swap it to the 7th item slot. This will alter party pokemon #11's data and allow it to use Fly.

- Finally, open the party menu, select the 11th party pokémon and have it use fly. Fly directly to Celadon City. If it doesn't have fly, make sure that the TM23 x19 stack is located in item slot #7.

- It is now safe to save the game.

 | Slot #35

 | (/wiki/File:PotionMenuENY.png)

## Step 3: Assembling an item code in Celadon City
## 
While standing in front of the Celadon City Pokémon Center, take 3 steps right, 5 steps up, 11 steps left and finally 3 steps up to reach the following spot. Make sure to bring a pokémon with Fly/Teleport.

 | Place to stand

 | (/wiki/File:ThunderstoneLocationY.png)

While standing on this spot, open your item bag and keep scrolling down until you find a Thunderstone x0 item stack, located at item slot #35 as indicated by the below screenshot. We will use this spot to orient ourselves for the next section.

 | Slot #35

 | (/wiki/File:ThunderstoneMenuENY.png)

By walking left or right, you can increment or decrement the item ID in slot #35. By walking up and down we can alternate between an item quantity of x0 and x1. We can safely swap the contents of item slot #35 with other item slots, as long as we use Fly/Teleport afterwards to restore the map back to normal. We can use this to collect all the items we need for the item code. slot #33 will always contain a bicycle, you can safely use this to speed up the process. 

For every item in the following table, head to the Thunderstone x0 spot, follow the instructions to obtain an item stack, then Fly back to Celadon and head back to the same spot to obtain the next item stack. It is heavily recommended to save after every time you fly back to the Celadon City Pokémon Center.

During the entire process, make sure to not swap two item stacks that have the same item. This will cause both item stacks to merge, resulting in glitches as side effects. When this happens, you can reset the game to restore the game back to normal.

 | Item location
 | Item ID
 | Item quantity
 | How to acquire

 | (/wiki/File:MaxPotionLocationY.png)
 | Max Potion
 | x105
 | At the Thunderstone spot, walk 16 steps to the left to get Max Potion x0. Toss 99 from the stack, then toss another 52 from the stack, then swap to slot #6.

 | (/wiki/File:ThunderstoneLocationY.png)
 | Thunderstone
 | x05
 | Go to the Thunderstone spot to get Thunderstone x0. Toss 251 from the stack, then swap to slot #8. (Make sure to preserve the x19 item stack in slot #7 so you can still use Fly)

 | (/wiki/File:TM22LocationY.png)
 | TM22
 | x42
 | At the Thunderstone spot, swap the Thunderstone with the TM23 x64 stack 4 slots below, then toss 63 TM23s. Walk 1 step up and 1 step left to get TM22 x0. Toss 214 from the stack, then swap to slot #9.

 | (/wiki/File:GreatBallLocationY.png)
 | Great Ball
 | x135
 | At the Thunderstone spot, walk 30 steps to the left to get Great Ball x0. Toss 99 from the stack, then toss an additional 22 from the stack to reach x135, then swap to slot #10.

 | (/wiki/File:AntidoteLocationY.png)
 | Antidote
 | x48
 | At the Thunderstone spot, walk 22 steps to the left to get Antidote x0. Toss 208 from the stack, then swap to slot #11.

 | (/wiki/File:PokeBallLocationY.png)
 | Poké Ball
 | x134
 | At the Thunderstone spot, walk 29 steps to the left to get Poké Ball x0. Toss 99 from the stack, then toss an additional 23 from the stack to reach x134, then swap to slot #12.

 | (/wiki/File:HyperPotionLocationY.png)
 | Hyper Potion
 | x44
 | At the Thunderstone spot, walk 15 steps to the left to get Hyper Potion x0. Toss 212 from the stack, then swap to slot #13.

 | (/wiki/File:SuperPotionLocationY.png)
 | Super Potion
 | x32
 | At the Thunderstone spot, walk 14 steps to the left to get Super Potion x0. Toss 224 from the stack, then swap to slot #14.

 | (/wiki/File:TM44LocationY.png)
 | TM44
 | x201
 | At the Thunderstone spot, swap the Thunderstone with the TM23 x64 stack 4 slots below, then toss 63 TM23s. Walk 2 steps down, 12 steps right, 5 steps down and then 9 steps right to get TM44 x0. Toss 55 from the stack, then swap to slot #15.

 | (/wiki/File:CalciumLocationY.png)
 | Calcium
 | x243
 | At the Thunderstone spot, walk 6 steps to the right to get Calcium x0. Toss 13 from the stack, then swap to slot #16.

 | (/wiki/File:TM14LocationY.png)
 | TM14
 | x213
 | At the Thunderstone spot, swap the Thunderstone with the TM23 x64 stack 4 slots below, then toss 63 TM23s. Walk 1 step up and 9 steps left to get TM14 x0. Toss 43 from the stack, then swap to slot #17.

After flying back to Celadon city, we will verify if all items have been successfully collected.

- Before opening the bag, walk 5 steps to the right from the entrance of the pokémon center. This will ensure that we can open the item bag without issues.

- Open the item bag and swap the TM14 x213 stack located in slot #17 to the item stack in slot #7. This will remove the ability to fly, but is required to complete the item code.

- Next, make sure your item bag looks as follows:

 | Item slot
 | Item ID
 | Item Quantity

 | Slot #6
 | Max Potion
 | x105

 | Slot #7
 | TM14
 | x213

 | Slot #8
 | Thunderstone
 | x05

 | Slot #9
 | TM22
 | x42

 | Slot #10
 | Great Ball
 | x135

 | Slot #11
 | Antidote
 | x48

 | Slot #12
 | Poké Ball
 | x134

 | Slot #13
 | Hyper Potion
 | x44

 | Slot #14
 | Super Potion
 | x32

 | Slot #15
 | TM44
 | x201

 | Slot #16
 | Calcium
 | x243

After assembling this item code, head to the Celadon Mansion penthouse, which is the room where you can pick up the gift Eevee. Do not pick up this Eevee yet, make sure to save before continuing.

## Nickname Writer Install
## 
Now that we have an item code ready, we'll finally be using it to set up an ACE environment. Placing a specific item stack in item slot #41 allows us to activate what is known as "Map Script ACE", which will then execute the item code to trigger effects based on the nicknames of the pokémon in the active box.

We will be using this in three stages:

- First we will alter a value in memory so that we can continuously keep picking up Eevee's while we remain on the same map.

- Next we will give ourselves a glitch item that, when used, will execute ACE starting from the sixth item slot. This allows us to execute ACE without needing to rely on Map Script ACE.

- Finally, we will set up a short program that uses the nickname screen to quickly and easily write programs of arbitrary size, effectively giving us a flexible ACE environment.
It is recommended to not save the game until the Nickname Writer program is installed. 

## A note on using ACE
## 
The first generation of pokémon games, especially the Virtual console releases, are vulnerable to certain crashes wiping the save file. As a protective measure, make sure to open the trainer card to display Red's sprite on screen right before using ACE of any kind. Loading any sprite switches the current active sram bank, offering a measure of safety against game crashes.

## Note: unterminated name items in Eevee's room
## 
Within this room, no safe spots exist that allow unterminated name items to be safely handled. Please make sure to not press a or select on unterminated items while in this room.

## Step 4: Setting up Infinite Eevee mode
## 
First, we'll use Map Script ACE to make sure that we can pick up as many Eevee as we want.

 | Nickname

 | (/wiki/File:InfiniteEeveeY.png)

- Pick up an Eevee and nickname it so that its name matches the above screenshot on the left. It will be sent to the current active box.

- Open the item bag. Swap the Calcium x243 with the contents of item slot #41, which should contain X Defend x86. This will activate Map Script ACE.

- Close the start menu. If everything went all right, Eevee's poké ball will have reappeared.

- Open the item bag. Swap the X Defend x86 that was previously in item slot #41 with the Calcium x243. This will deactivate Map Script ACE.

 | Slot #41

 | (/wiki/File:MapScriptMenuENY.png)

## Step 5: Setting up 4F to execute item codes
## 
Next, we'll be entering a list of three nicknames that gives us the glitch item named "4F" and the necessary bootstrap. This ensures that using 4F will activate the item code.

 | List of nicknames

 | (/wiki/File:WsmBootstrap.png)

- Pick up Eevees and enter the nicknames in the above screenshot one by one. The nicknames from this list needs to be entered in this exact order from the top to the bottom.

- Open the item bag. Swap the Calcium x243 with the contents of item slot #41, which should contain X Defend x86. This will activate Map Script ACE.

- Close the start menu. If everything went all right, the CANCEL buttons in the first three slots have been removed and the first item was replaced with a glitch item named "4F"

- Open the item bag. Swap the X Defend x86 that was previously in item slot #41 with the Calcium x243. This will deactivate Map Script ACE.

- Finally, verify that 4F works by using it. If the game doesn't crash, 4F was set up correctly.

 | Slot #41

 | (/wiki/File:MapScriptMenuENY.png)

## Step 6: Setting up the Nickname Writer
## 

- Next, we'll be entering a list of thirteen nicknames. This will form a small program that, when activated using 4F, will allow us to easily write large amount of arbitrary code using the nickname screen.

 | List of nicknames

 | (/wiki/File:NicknameWriterY.png)

- Pick up Eevees and enter the nicknames in the above screenshot one by one. The nicknames from this list needs to be entered in this exact order from the top to the bottom.

- Once all nicknames have been entered, look at your trainer card, then use 4F. This should open a screen in which you're asked to enter a pokémon's nickname

- For now, press START to end writing the nickname. This should display the main menu, a number should be written on screen.

- Press SELECT to exit the Nickname Writer safely.

## Clean-up
## 
Congratulations! The fact that you've made it this far means you've correctly set up the Nickname Writer. In this section we're going to enter an additional six nicknames to achieve the following effects:

- Alter 4F's bootstrap, so that the item code is no longer required for the Nickname Writer to function.

- Remove the side-effects of the setup, such as removing the inventory underflow effect and clearing out the current active box.
Along the way we'll also show how to use the Nickname Writer.

## Step 7: Using the nickname writer
## 
From this point onward, whenever you use the ACE item, you should be able to open the nickname writer. Please make sure to keep note of the following:

- Since the Nickname Writer works independently of the current active box, you can change the current active box however much you like.

- When writing data, the Nickname Writer will overwrite enemy party data. While this does not have any effect outside of battle, it is recommended to not use the Nickname Writer in battle.
The program works as follows:

- The program opens the nickname screen and asks you to input a nickname.

- This nickname then gets converted to a sequence of five bytes.

- All five bytes are written starting from the starting location

- The program displays a glitched overworld view, along with a checksum (sum of all written byte values) towards the top right of the screen to confirm that you correctly entered the code. If the printed checksum doesn't match the expected checksum, you made a mistake entering a code. The glitched overworld view is temporary and will not affect your game.

- Afterwards, it waits for the user to decide what to do.
During the input phase, the controls are as follows:

- Press A for the program to ask for a new nickname and convert that to the next five bytes to be written.

- Press B to go back one byte at a time. The checksum will automatically be overwritten by the value written at the current selected address, giving you a measure of how far back you're going. If a name is incorrect, press B five times before pressing A, entering the nickname again to overwrite the incorrect nickname.

- Press START to immediately start executing the newly written program. Only do this when you've finished writing everything.

- Press SELECT to safely quit the Nickname Writer, without executing the newly written code.

 | Write mode
 | Input mode

 | (/wiki/File:RB_Name_writer_write_mode.png)

 | (/wiki/File:RB_Name_writer_input_mode.png)

 | Enter nickname, press select to switch between uppercase/lowercase
 | Checksum ("4E", in this case) is displayed as a hex value on the top right quadrant

## Step 8: Returning the game state to normal
## 
At this point, there are certain side effects that have been introduced by the setup:

- By picking up Eevee, we have flagged its poké ball as "obtained"

- The current active box is filled with nicknamed Eevees

- The item pack currently has 255 items

- The item code is currently still required to run the Nickname Writer

- We currently have two badges set as obtained

- Our pokédex currently has 152 pokémon species caught, preventing the story from continuing

- Setting up SRAM glitch has given us a party of 255 pokémon

- We are currently located in the Celadon Pokémon center, while we need to return to Pallet Town to pick up the starter pokémon
We will be removing all these side effect using the Nickname Writer. The nicknames we need to enter will be generated by the Nickname Converter webtool (https://timovm.github.io/NicknameConverter/). Simply open the link, copy paste one of the two codes below into the converter, then press the "Run" button to display the list of nicknames.

When using the Nickname Writer, the generated nicknames need to be entered from top to bottom.

Codes to be used with the Nickname Converter webtool (https://timovm.github.io/NicknameConverter/)

 | Code

 | 21 AD D5 CB AE
AF EA 55 D3 21
7F DA 22 3D 22
AF 01 26 00 21
F6 D2 22 0D 20
FC 2E B0 22 22
23 23 22 22 EA
62 D1 EA 1C D3
01 01 59 CD 3F
3E 21 65 DA 36
69 23 36 D6 C9

Once all nicknames have been entered and verified, you can press START during input mode to execute the code.

This will activate the following effects:

- Reset the state of Eevee's poké ball, allowing it to be picked up again at a later point

- Empty the current active box

- Resets the bag, removing all items aside from 4F and removing the inventory underflow state

- Rewire 4F so that it can activate the Nickname Writer independently of the item code

- Reset all badges

- Reset all Pokédex flags

- Removes all party pokémon

- Alters the exit of the poké center to lead out to Pallet Town
From this point onward, you can exit the penthouse and continue the story as normal.

## Additional applications of the Nickname Writer
## 
The Nickname Writer allows you to easily write and execute arbitrary payloads. You can either make and execute your own codes, or head to the Nickname Writer codes (/wiki/Guides:Nickname_Writer_Codes) page. This page contains a collection of assembly for nickname codes that can be used for a variety of common purposes such as editing pokémon and items, editing player stats, resetting legendaries etc..

Nickname Writer Codes (/wiki/Guides:Nickname_Writer_Codes)

## Addendum: raw text transcripts of nickname codes
## 
These are provided as an alternative in case images fail to load.

## Infinite Eevee Mode Nickname
## 

 | Nickname

 | C l l U&nbsp;: V&nbsp;:&nbsp;; W&nbsp;;

## 4F Bootstrap Nicknames
## 

 | List of nicknames

 | g . y x ] , k Mn * Pk
* ( u z z , , . ] ,
w v u v U l k Mn Pk X

## Nickname Writer
## 

 | List of nicknames

 | a b v v ) l l C d d
j&nbsp;? ) V t v v v l Mn
q p y y ] z y p g F
v u j&nbsp;? t K K b c c
R j j m v w w P P p
l l M v V V u l&nbsp;: ♀
P x w v v W M m m w
A B r q x Pk z g g h
i z , [ o w o x w x
( ) ) ) ) , , ] ] .
j&nbsp;! U&nbsp;?&nbsp;? u w v u Mn
a Pk * t * A S j s t
r p P W [&nbsp;:&nbsp;:&nbsp;;&nbsp;:&nbsp;;

## Addendum: technical explanation of the setup
## 

## Nickname Converter Item Code
## 

## Explanation
## 
The item code itself consists of two components. The first 10 items are used to write a program that takes text characters from the nicknames of characters currently within the active box, converts them, then writes the resulting values to unused memory starting from $D66A. 

Pairs of text characters are converted to single values through a [(2a + b)%256] formula, where a is the value of the first character and b the value of the second. text terminators are skipped, the code will stop and execute the newly written code once it either reads a $00 value or if values are being read past $DEFF.

11 69 D6 ld de, UNUSED_MEMORY ; Memory between $D669 and $D6EE goes unused
D5 push de
21 05 DE ld hl, wBoxNicks
.loop
2A ldi a, (hl)
03 inc bc ; Filler, no effect on flags
87 add a
0B dec bc ; Filler, compensates previous inc bc, no effect on flags
30 04 jp nc, .notChar ; Aside from space (should not be used), "add a" will only give nc if value read is not a text char
86 add a, (hl)
12 ld (de), a
2C inc l ; Affects z flag
13 inc de
.notChar
20 F4 jp nz, .loop ; Loop unless l rolled over to $00 or value read was $00
C9 ret ; Due to previous push de, this ret will cause execution to resume from $D66A onward, immediately running the newly written code

The last item, the Calcium, simply form a pointer to $F327. Due to echo RAM this address is equivalent to $D327, which correspond to item #6's item ID, the start of the item code. By replacing the map script pointer with this item, we can redirect the map script routine to execute the item code instead. This routine is executed on every frame, as long as the start menu isn't open.

## Raw Assembly
## 
11 69 Max Potion x105
D6 D5 TM14 x213
21 05 Thunderstone x05
DE 2A TM22 x42
03 87 Great Ball x135
0B 30 Antidote x48
04 86 Poké Ball x134
12 2C Hyper Potion x44
13 20 Super Potion x32
F4 C9 TM44 x201

27 F3 Calcium x243

## Infinite Eevee Nickname
## 

## Explanation
## 
The Infinite Eevee mode nickname writes $00 to the lower byte of wMissableObjectList, causing a misalignment in how the game applies NPC disappearance, causing Eevee's pokéball to stay permanently visible until the game is reset or the player leaves the Celadon Mansion penthouse.

AF xor a ; a = $00
EA CD D5 ld (wMissableObjectList), a ; Misaligns which objects are made invisible
C9 ret

## Raw Assembly
## 
AF EA CD D5 C9

## 4F Boostrap Nicknames
## 
This set of nicknames, when converted, will modify item #1's ID to be 4F and writes a bootstrap so that using it will lead to execution of the item code from $D327 onward. It requires the presence of the Infinite Eevee Mode Nickname (see previous section) to properly return.

21 1D D3 ld hl, wBagItems ; item #1's ID
36 59 ld (hl), $59 ; 4F's item ID
7C ld a, h ; a = $D3 
21 66 DA ld hl, 4F_Execution_Pointer +2
32 ldd (hl), a
3E 27 ld a, $27
22 ldi (hl), a
36 C3 ld (hl), $C3
; The contents of the first nickname (see previous section) are written right after this, ensuring safe return.

## Raw Assembly
## 
21 1D D3 36 59
7C 21 66 DA 32
3E 27 32 36 C3

## Using 4F
## 

## Explanation
## 
Using 4F, an invalid item, will cause the game to index the item effects table out of bounds, leading to an invalid execution pointer. For 4F, this causes the game to execute code from $FA64 onward. Due to echo RAM, this address is equivalent to $DA64. Thanks to the bootstrap that was applied earlier, this will then cause the game to jump to $D327, corresponding to the start of the item code.

C3 27 D3 jp ITEM_6_ID

## Raw Assembly
## 
C3 27 D3

## Nickname Writer
## 

## Explanation
## 
The Nickname Writer is a small program that, using nicknames as input, is able to write arbitrary amounts of custom code relatively quickly. It first request a nickname as input, then converts that data to custom code, then displays a checksum of the written data and finally asks the player to provide additional input.

The value of the checksum is calculated by [($80 + the sum of all written values)%256]. Custom code is buffered and executed within enemy party data. Due to how it calls DisplayNameRaterScreen, it will also nickname a party pokémon corresponding to the item slot that 4F currently occupies.

SECTION "Main", ROM0
Main:
 LOAD "NickWriter", WRAMX[wRoute18Gate1FCurScript + 0x01]
NickWriter:
 ld de, wEnemyMon1HPExp&nbsp;; location written to
 push de
.newMail
 push de
 ld hl, AskName + 0x39&nbsp;; Prepares data and calls DisplayNamingScreen
 call RemovePokemon + 0x03&nbsp;; sets b to 01, then jumps to Bankswitch, calling b:hl
 ld c, 0x80&nbsp;; Ensure checksum consistency
 ld hl, wStringBuffer&nbsp;; Address where new name gets written to
 pop de&nbsp;; Continue writing from last saved de
.newChar
 ld a, (hli)
 add a
 jp nc, .terminator&nbsp;; If blank space as first character of pair, only terminator $50 will result in a nc result
 add a, (hl)
 ld (de), a
 inc de
 inc hl
 add a, c&nbsp;; Current checksum total is buffered in c
 ld (de), a
 ld c, a
 jp .newChar
.terminator
push de
 ld hl, wTileMap + 0x60&nbsp;; Corresponds to screen tile
 ld c, 0x01&nbsp;; How many bytes printed as numbers?
 call PrintBCDNumber.loop
.numLoop
 dec l
 set 7, (hl)
 jp nz, .numLoop&nbsp;; Repeat until hl == 0xC400
.inputLoop
 call JoypadLowSensitivity&nbsp;; Halt execution until frame has passed, get joypad status and store result in hJoy5
 ld a, (hJoy5)
 and 0x0F&nbsp;; Set z flag if A, B, START, SELECT not pressed
 jp z, .inputLoop
 rra&nbsp;; Is A pressed? If yes, set c flag
 pop de
 jr c, .newMail
 dec de
 rra&nbsp;; Is B pressed? If yes, set c flag
 jr c, .terminator
 rra&nbsp;; Is SELECT pressed? If yes, set c flag
 pop hl&nbsp;; pop starting address to hl
 ret c&nbsp;; If SELECT pressed, simply return to normal operations
 jp hl&nbsp;; If START pressed, jump to hl to execute newly written code
.end

## Raw Assembly
## 
 11 B4 D8 D5 D5 
 21 95 62 CD 17
 39 0E 80 21 4A
 CF D1 2A 87 30
 09 86 12 13 23
 81 12 4F 18 F3
 D5 21 00 C4 0E
 01 CD BF 13 2D
 CB FE 20 FB CD
 1E 38 F0 B5 E6
 0F 28 F7 1F D1
 38 CB 1B 1F 38
 E1 1F E1 D8 E9

## Cleanup Code (new save)
## 

## Explanation
## 
This code cleans up every negative side effect brought on by the setup and allows the player to continue the story as intended, with the exception of 4F being added to the item bag, enabling use of the Nickname Writer.

The negative effects targeted are:

- By picking up Eevee, we have flagged its poké ball as "obtained"

- The current active box is filled with nicknamed Eevees

- The item pack currently has 255 items

- The item code is currently still required to run the Nickname Writer

- We currently have two badges set as obtained

- Our pokédex currently has 152 pokémon species caught, preventing the story from continuing

- Setting up SRAM glitch has given us a party of 255 pokémon

- We are currently located in the Celadon Pokémon center, while we need to return to Pallet Town to pick up the starter pokémon
21 AD D5 ld hl, $D5AD ; Part of wMissableObjectFlags
CB AE res 5, (hl) ; Reenable Eevee's poké ball
AF xor a ; a = $00
EA 55 D3 ld (wObtainedBadges), a ; Reset badges
21 7F DA ld hl, wBoxCount
22 ldi (hl), a ; Set amount of pokémon in box to 0
3D dec a ; a = $FF
22 ldi (hl), a ; Add proper terminator to wBoxSpecies
AF xor a ; a = $00
01 26 00 ld bc, 0026
21 F6 D2 ld hl, wPokedexOwned
.loop
22 ldi (hl), a
0D dec c
20 FC jp nz, .loop ; Fully clear all Pokédex flags
2E B0 ld l, $B0 ; hl = $D3B0, within wWarpEntries
22 ldi (hl), a
22 ldi (hl), a
23 inc hl
23 inc hl
22 ldi (hl), a
22 ldi (hl), a ; Changes first two warp tiles to lead to Pallet Town instead
EA 62 D1 ld (wPartyCount), a ; Set amount of pokémon in party to 0
EA 1C D3 ld (wNumBagItems), a ; Set amount of items to 0
01 01 59 ld bc, $5901
CD 3F 3E call GiveItem ; Gives c amount of b item, giving 1 copy of 4F.
21 65 DA ld hl, $DA65 ; Part of 4F bootstrap
36 69 ld (hl), $69
23 inc hl
36 D6 ld (hl), $D6 ; 4F now redirects directly to Nickname Writer
C9 ret

## Raw Assembly
## 
21 AD D5 CB AE
AF EA 55 D3 21
7F DA 22 3D 22
AF 01 26 00 21
F6 D2 22 0D 20
FC 2E B0 22 22
23 23 22 22 EA
62 D1 EA 1C D3
01 01 59 CD 3F
3E 21 65 DA 36
69 23 36 D6 C9

Retrieved from "https://glitchcity.wiki/wiki/Guides:SRAM_Glitch_ACE_Setups_(EN_Yellow)?oldid=47718 (https://glitchcity.wiki/wiki/Guides:SRAM_Glitch_ACE_Setups_(EN_Yellow)?oldid=47718)"