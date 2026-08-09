# OTF Player Switcher

**Overworld On the Fly Player Sprite Switcher**

Change your player sprite in real time.

Can also be used to switch Trainer Card Image and Player Back Sprite.

This is an easy way to try out custom sprites or play with different characters.

In Version 1.0 all 6 tile sprites extracted of the rom are used.
The overworld spritesheets contain of 6 x 16x16 sprites in a single .png image.
These files lie in the "sprites" and "battle/trainers" folders of gen1recomp.
This means you can play as any NPC which walks around in the overworld.
*There are no NPCs riding a bike except the biker, so there are not sprites for riding a bike.*
*There are also no NPC backsprites except for the old man, so there are no special backsprites except for giovanni, leaf right now.*

##  Compatible sprite sizes:

* **Overworld:** `16x96px`
* **Front:** `56x56px`
* **Back:** `48x48px`
* **Back:** `32x32px`

## Sprite naming

For example files check the assets folder.

### Overworld 

Use the name of the character, like `leaf`

This is the character you walk around with.

### Front 

Add `_front` to the filename, like `leaf_front`

This is the Image on the trainer card.

### Back 

Add `_back` to the filename, like `leaf_back`

This is the player sprite you see when starting a battle.

## Shortcuts

- <kbd>PageUp</kbd> — Switch to the previous sprite
- <kbd>PageDown</kbd> — Switch to the next sprite

Can be toggled in the mod options menu.

## `hide.lua`

Can be used to hide specific sprites. Extract the file to edit it.
All sprites are commented out which means all are selectable.

Remove `--` to hide this sprite option ingame.

After editing `hide.lua` overwrite `hide.lua` in the `.zip` archive.

To add sprites add them to the `/assets` folder.

To make the changes visible: close the game, remove the mod and install it again.

## OPTIONS

* **CHARACTER SPRITE** — Selects the Character sprites used.
* **HIDE.LUA** — Enables/Disables the hide.lua file.
* **PGUP/PGDN SWITCH** — Enables/Disables the shortcut buttons.

## CREDITS
Leaf Sprites made by MollyChan (https://www.spriters-resource.com/profile/mollychan)
