# OTF Player Switcher

**Overworld On the Fly Player Sprite Switcher**
Change the player sprite in real time.

Can also be used to switch Trainer Card Image and Player Back Sprite.

## Supported Sprites

* **Overworld:** `16x96px`
* **Front:** `56x56px`
* **Back:** `48x48px`
* **Back:** `32x32px`

## Sprite Naming

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

**PageUp & PageDown**

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
