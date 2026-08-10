# Custom Player Sprite Switcher

**Overworld On-the-Fly Sprite Changer**

<p align="center">
  <img src="https://i.imgur.com/Oj1pFyY.gif" alt="OTF Player Switcher in-game demonstration">
</p>

Change your player sprite in real time.

Can also be used to switch Trainer Card Image and Player Back Sprite.

This is an easy way to try out custom sprites or to play with different characters.
The GIF shows the effect ingame when pressing a shortcut button.

## Features

* Change your overworld player sprite in real time.
* Switch your Trainer Card Image.
* Switch your Player Back Sprite.
* Use custom sprites.
* Play as NPCs.
* Switch sprites using <kbd>PageUp</kbd> and <kbd>PageDown</kbd>.

## Shortcuts

* <kbd>PageUp</kbd> — Switch to the previous sprite
* <kbd>PageDown</kbd> — Switch to the next sprite

Can be toggled in the mod options menu.

---

*Take a sprite sheet and divide it into separate assets to use them ingame.*

<p align="center">
  <img src="https://i.imgur.com/dt420xU.png">
  <img src="https://i.imgur.com/S5Tz8Wa.png">
  <img src="https://i.imgur.com/ilGNNwE.png">
  <img src="https://i.imgur.com/ZpznmkK.png">
</p>

*The ingame colors depend on the coloring used in the options menu.*

<p align="center">
 <img src="https://i.imgur.com/3lLcHPq.png">
</p>

## Mod Options

* **CHARACTER SPRITE** — Selects the Character sprites used.
* **HIDE.LUA** — Enables/Disables the `hide.lua` file, which contains sprites to hide.
* **PGUP/PGDN SWITCH** — Enables/Disables the shortcut buttons.

<p align="center">
  <img src="https://i.imgur.com/EsO5iWQ.png" alt="OTF Player Switcher in-game options">
</p>

## Compatible Sprite Sizes

* **Overworld:** `16x96px`
* **Front:** `56x56px`
* **Back:** `48x48px`
* **Back:** `32x32px`

## Sprite Naming

For example files, check the `assets` folder.

### Overworld

Use the name of the character, like `leaf`.

This is the character you walk around with.

### Front

Add `_front` to the filename, like `leaf_front`.

This is the image on the Trainer Card.

### Back

Add `_back` to the filename, like `leaf_back`.

This is the player sprite you see when starting a battle.

### Adding Sprites

To add sprites, add them to the `assets` folder in the .zip archive..

* To make the changes visible: close the game, remove the mod and install it again.

## `hide.lua`

Can be used to hide specific sprites. Extract the file to edit it.

All sprites are commented out, which means all are selectable.

Remove `--` to hide this sprite option ingame.

For example: if you don't want to swim on land you remove the `--` in front of `"seel",` and `"swimmer",`.

### Editing `hide.lua`

1. Extract `hide.lua` from the `.zip` archive.
2. Edit the file to hide specific sprites.
3. Overwrite `hide.lua` in the `.zip` archive.

* To make the changes visible: close the game, remove the mod and install it again.

## Available Sprites

In Version 1.0, all 6 tile sprites extracted from the ROM are used.

The overworld spritesheets contain 6 X 16x16 sprites in a single `.png` image. These files are located in the `sprites` and `battle/trainers` folders of `gen1recomp`.

This means you can play as any NPC which walks around in the overworld. This also means additional sprites in this format inside the `asset` folder will appear in the mod spritelist.

* agatha
* beauty
* bird
* biker
* blue
* brunette_girl
* bruno
* channeler
* cook
* cooltrainer_f
* cooltrainer_m
* daisy
* fairy
* fisher
* gambler
* gentleman
* giovanni
* girl
* hiker
* koga
* lance
* little_girl
* lorelei
* middle_aged_man
* middle_aged_woman
* monster
* mr_fuji
* oak
* rocket
* rocker
* sailor
* scientist
* seel
* silph_worker_f
* super_nerd
* swimmer
* waiter
* youngster


### Limitations

*There are no NPCs riding a bike except the biker, so there are no sprites for riding a bike.*

*There are also no NPC backsprites in the original rom except for the old man, so there are no special backsprites except for custom ones like Giovanni and Leaf right now.*

*The initial idea of the mod was to change the overworld player sprite.*



## Credits

Leaf Sprites by Molly
