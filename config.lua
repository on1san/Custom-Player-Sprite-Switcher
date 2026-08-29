local Config = {}

-- DEFAULT OPTIONS
Config.DEFAULT_HIDE_NPCS = true
Config.DEFAULT_SHORTCUTS_ENABLED = true

---------------------------------------------------------------

---------------------
-- GEN 1 & 2 FOLDER--
---------------------

Config.BASE_GENERATED = "assets/generated/" -- Rom files
Config.BASE_MOD = "assets/" -- Custom files


-- Specific paths
Config.OVERWORLD_SPRITES = Config.BASE_GENERATED .. "sprites/"
Config.FRONT_SPRITES = Config.BASE_GENERATED .. "battle/trainers/"
Config.FRONT_POKEMON = Config.BASE_GENERATED .. "battle/front/"
Config.BACK_POKEMON = Config.BASE_GENERATED .. "battle/back/"

Config.BACK_SPRITES = Config.BASE_MOD .. "_npcs/"
Config.CUSTOM_CHARS_ROOT = Config.BASE_MOD

------------------------
-- GEN 1 RED DEFAULTS --
------------------------

Config.RED = Config.OVERWORLD_SPRITES .. "red.png"
Config.RED_BIKE = Config.OVERWORLD_SPRITES .. "red_bike.png"
Config.RED_FRONT = Config.BASE_GENERATED .. "trainer_card/red.png"
Config.RED_BACK = Config.BASE_GENERATED .. "battle/redb.png"

Config.RED_FISH_BACK = Config.BASE_GENERATED .. "fx/red_fish_back.png"
Config.RED_FISH_FRONT = Config.BASE_GENERATED .. "fx/red_fish_front.png"
Config.RED_FISH_SIDE = Config.BASE_GENERATED .. "fx/red_fish_side.png"

--------------------------
-- GEN 2 DEFAULTS --
--------------------------

Config.CHRIS = Config.OVERWORLD_SPRITES .. "chris.png"
Config.CHRIS_BIKE = Config.OVERWORLD_SPRITES .. "chris_bike.png"
Config.CHRIS_FRONT = Config.BASE_GENERATED .. "trainer_card/card.png"
Config.CHRIS_BACK = Config.BASE_GENERATED .. "battle/player_back.png"

Config.CHRIS_FISH_BACK = Config.BASE_GENERATED .. "emotes/fishing.png"

--------------------------------------------------------------------------------

Config.KRIS = Config.OVERWORLD_SPRITES .. "kris.png"
Config.KRIS_BIKE = Config.OVERWORLD_SPRITES .. "kris_bike.png"
Config.KRIS_FRONT = Config.BASE_GENERATED .. "trainer_card/card_f.png"
Config.KRIS_BACK = Config.BASE_GENERATED .. "battle/player_back_female.png"

Config.KRIS_FISH_BACK = Config.BASE_GENERATED .. "emotes/fishing_female.png"


--------------------------------------
-- MOD FILE NAMING RULES & SUFFIXES --
--------------------------------------

--Config.SUFFIX_GEN1 = "_bw"
Config.SUFFIX_GEN1 = "_color"
Config.SUFFIX_GEN2 = "_color"

Config.FILE_EXT = ".png"

Config.CUSTOM_CHAR_FILES = {
    "back", 
    "front", 
    "walk", 
    "bike", 
    "fish_back", 
    "fish_front", 
    "fish_side"
}

---------------------------------------------------------------
--pkmn blue/red/yellow: bird, monster, seel, fairy
--only yellow trainer:  officer_jenny, jessie, james
--only yellow pkmn:     pikachu
Config.FRONT_TRAINER_MAP = {
    ["agatha"] = "agatha",
    ["beauty"] = "beauty",
    ["biker"] = "biker",
    ["blue"] = "rival3",
    ["brunette_girl"] = "lass",
    ["bruno"] = "bruno",
    ["channeler"] = "channeler",
    ["cook"] = "hiker",
    ["cooltrainer_f"] = "cooltrainerf",
    ["cooltrainer_m"] = "cooltrainerm",
    ["daisy"] = "lass",
    ["fisher"] = "fisher",
    ["gambler"] = "gambler",
    ["gentleman"] = "gentleman",
    ["giovanni"] = "giovanni",
    ["girl"] = "lass",
    ["hiker"] = "hiker",
    ["koga"] = "koga",
    ["lance"] = "lance",
    ["little_girl"] = "lass",
    ["lorelei"] = "lorelei",
    ["middle_aged_man"] = "middle_aged_man",
    ["middle_aged_woman"] = "middle_aged_woman",
    ["mr_fuji"] = "gambler",
    ["oak"] = "prof.oak",
    ["red"] = "red",
    ["red_bike"] = "red_bike",
    ["rocker"] = "rocker",
    ["rocket"] = "rocket",
    ["sailor"] = "sailor",
    ["scientist"] = "scientist",
    ["silph_worker_f"] = "lass",
    ["super_nerd"] = "youngster",
    ["swimmer"] = "swimmer",
    ["waiter"] = "gentleman",
    ["youngster"] = "youngster",
--pkmn
    ["bird"] = "farfetchd",
    ["monster"] = "rhydon",
    ["seel"] = "seel",
    ["fairy"] = "clefairy",
-- yellow only --
-- trainer yellow only
    ["james"] = "james",
    ["jessie"] = "jessie",
    ["officer_jenny"] = "officer_jenny",
--pkmn yellow only
    ["pikachu"] = "pikachu"
}

Config.BACK_TRAINER_MAP = {
    ["agatha"] = "agatha",
    ["beauty"] = "beauty",
    ["biker"] = "biker",
    ["blue"] = "rival3",
    ["brunette_girl"] = "lass",
    ["bruno"] = "bruno",
    ["channeler"] = "channeler",
    ["cook"] = "hiker",
    ["cooltrainer_f"] = "cooltrainerf",
    ["cooltrainer_m"] = "cooltrainerm",
    ["daisy"] = "lass",
    ["fisher"] = "fisher",
    ["gambler"] = "gambler",
    ["gentleman"] = "gentleman",
    ["giovanni"] = "giovanni",
    ["girl"] = "lass",
    ["hiker"] = "hiker",
    ["koga"] = "koga",
    ["lance"] = "lance",
    ["little_girl"] = "lass",
    ["lorelei"] = "lorelei",
    ["middle_aged_man"] = "middle_aged_man",
    ["middle_aged_woman"] = "middle_aged_woman",
    ["mr_fuji"] = "gambler",
    ["oak"] = "prof.oak",
    ["red"] = "red",
    ["red_bike"] = "red_bike",
    ["rocker"] = "rocker",
    ["rocket"] = "rocket",
    ["sailor"] = "sailor",
    ["scientist"] = "scientist",
    ["silph_worker_f"] = "lass",
    ["super_nerd"] = "youngster",
    ["swimmer"] = "swimmer",
    ["waiter"] = "gentleman",
    ["youngster"] = "youngster",
--pkmn
    ["bird"] = "farfetchd",
    ["monster"] = "rhydon",
    ["seel"] = "seel",
    ["fairy"] = "clefairy",
-- trainer yellow only
    ["james"] = "james",
    ["jessie"] = "jessie",
    ["officer_jenny"] = "officer_jenny",
--pkmn yellow only
    ["pikachu"] = "pikachu"
}

Config.IS_POKEMON = {
    ["bird"] = true,
    ["monster"] = true,
    ["seel"] = true,
    ["fairy"] = true,
    ["pikachu"] = true
}


-- ==========================================
-- GEN 2 TRAINER MAPS
-- ==========================================

Config.FRONT_TRAINER_MAP_GEN2 = {
    ["cal"] = "cal", --default
    ["beauty"] = "beauty",
    ["bill"] = "bill",
    ["biker"] = "biker",
    ["blaine"] = "blaine",
    ["black_belt"] = "blackbelt_t",
    ["blue"] = "blue",
    ["brock"] = "brock",
    ["bruno"] = "bruno",
    ["bug_catcher"] = "bug_catcher",
    ["bugsy"] = "bugsy",
    ["chuck"] = "chuck",
    ["clair"] = "clair",
    ["clerk"] = "clerk",
    ["cooltrainer_f"] = "cooltrainerf",
    ["cooltrainer_m"] = "cooltrainerm",
    ["daisy"] = "daisy",
    ["elder"] = "sage",
    ["elm"] = "elm",
    ["erika"] = "erika",
    ["falkner"] = "falkner",
    ["fisher"] = "fisher",
    ["fishing_guru"] = "fishing_guru",
    ["gentleman"] = "gentleman",
    ["gramps"] = "gramps",
    ["granny"] = "granny",
    ["gym_guide"] = "gym_guide",
    ["janine"] = "janine",
    ["jasmine"] = "jasmine",
    ["kimono_girl"] = "kimono_girl",
    ["koga"] = "koga",
    ["kurt"] = "kurt",
    ["lance"] = "champion",
    ["lass"] = "lass",
    ["link_receptionist"] = "link_receptionist",
    ["misty"] = "misty",
    ["mom"] = "mom",
    ["morty"] = "morty",
    ["oak"] = "pokemon_prof",
    ["officer"] = "officer",
    ["pharmacist"] = "burglar",
    ["pokefan_f"] = "pokefanf",
    ["pokefan_m"] = "pokefanm",
    ["pryce"] = "pryce",
    ["red"] = "red",
    ["receptionist"] = "receptionist",
    ["reds_mom"] = "reds_mom",
    ["rival"] = "rival1",
    ["rocker"] = "guitarist",
    ["rocket"] = "gruntm",
    ["rocket_girl"] = "gruntf",
    ["sabrina"] = "sabrina",
    ["sage"] = "sage",
    ["sailor"] = "sailor",
    ["scientist"] = "scientist",
    ["super_nerd"] = "super_nerd",
    ["surf"] = "surf",
    ["surfing_pikachu"] = "surfing_pikachu",
    ["surge"] = "lt_surge",
    ["swimmer_girl"] = "swimmerf",
    ["swimmer_guy"] = "swimmerm",
    ["teacher"] = "teacher",
    ["twin"] = "twins",
    ["whitney"] = "whitney",
    ["youngster"] = "youngster",
---------------------------------------------------
    
--unfinished / unused
    
--["gameboy_kid"] = "gameboy_kid",
--["captain"] = "captain",
--["karen"] = "karen",
--["nurse"] = "nurse",
--["will"] = "will",
--["unused_guy"] = "unused_guy",

}

Config.BACK_TRAINER_MAP_GEN2 = {
    ["cal"] = "cal", --default
    ["beauty"] = "beauty",
    ["bill"] = "bill",
    ["biker"] = "biker",
    ["blaine"] = "blaine",
    ["black_belt"] = "black_belt",
    ["blue"] = "blue",
    ["brock"] = "brock",
    ["bruno"] = "bruno",
    ["bug_catcher"] = "bug_catcher",
    ["bugsy"] = "bugsy",
    ["chuck"] = "chuck",
    ["clair"] = "clair",
    ["clerk"] = "clerk",
    ["cooltrainer_f"] = "cooltrainer_f",
    ["cooltrainer_m"] = "cooltrainer_m",
    ["daisy"] = "daisy",
    ["elder"] = "elder",
    ["elm"] = "elm",
    ["erika"] = "erika",
    ["falkner"] = "falkner",
    ["fisher"] = "fisher",
    ["fishing_guru"] = "fishing_guru",
    ["gentleman"] = "gentleman",
    ["gramps"] = "gramps",
    ["granny"] = "granny",
    ["gym_guide"] = "gym_guide",
    ["janine"] = "janine",
    ["jasmine"] = "jasmine",
    ["kimono_girl"] = "kimono_girl",
    ["koga"] = "koga",
    ["kurt"] = "kurt",
    ["lance"] = "lance",
    ["lass"] = "lass",
    ["link_receptionist"] = "link_receptionist",
    ["misty"] = "misty",
    ["mom"] = "mom",
    ["morty"] = "morty",
    ["oak"] = "oak",
    ["officer"] = "officer",
    ["pharmacist"] = "pharmacist",
    ["pokefan_f"] = "pokefan_f",
    ["pokefan_m"] = "pokefan_m",
    ["pryce"] = "pryce",
    ["red"] = "red",
    ["receptionist"] = "receptionist",
    ["reds_mom"] = "reds_mom",
    ["rival"] = "rival",
    ["rocker"] = "rocker",
    ["rocket"] = "rocket",
    ["rocket_girl"] = "rocket_girl",
    ["sabrina"] = "sabrina",
    ["sage"] = "sage",
    ["sailor"] = "sailor",
    ["scientist"] = "scientist",
    ["super_nerd"] = "super_nerd",
    ["surf"] = "surf",
    ["surfing_pikachu"] = "surfing_pikachu",
    ["surge"] = "surge",
    ["swimmer_girl"] = "swimmer_girl",
    ["swimmer_guy"] = "swimmer_guy",
    ["teacher"] = "teacher",
    ["twin"] = "twin",
    ["whitney"] = "whitney",
    ["youngster"] = "youngster",
---------------------------------------------------

--unfinished / unused
    
--["gameboy_kid"] = "gameboy_kid",
--["captain"] = "captain",
--["karen"] = "karen",
--["nurse"] = "nurse",
--["will"] = "will",
--["unused_guy"] = "unused_guy",

}


Config.DISPLAY_NAME_MAP = {
    ["middle_aged_woman"] = "Middle Aged (W)",
    ["middle_aged_man"] = "Middle Aged (M)",
    ["cooltrainer_f"] = "Cool Trainer (F)",
    ["cooltrainer_m"] = "Cool Trainer (M)",
    ["silph_worker_f"] = "Silph Worker (F)",
    ["swimmer_girl"] = "Swimmer (F)",
    ["swimmer_guy"] = "Swimmer (M)",
    ["pokefan_f"] = "Pokefan (F)",
    ["pokefan_m"] = "Pokefan (M)",
    ["rocket"] = "Rocket (M)",
    ["rocket_girl"] = "Rocket (F)",
}

Config.POKEMON_FRONT_OFFSETS = {
    ["rhydon"]    = { x = 0, y = -1 },
    ["clefairy"]  = { x = 6, y = 10 },
    ["farfetchd"] = { x = 2, y = 6 },
    ["seel"]      = { x = 2, y = 3 }
}

Config.NPC_BACK_OFFSET = { x = 8, y = 48 }

return Config


-- =========================================================================
-- DIRECTORY STRUCTURE OVERVIEW
-- =========================================================================
--
-- 1. YOUR MOD DIRECTORY (Physical Mod Folder)
-- custom files
--
-- Your Mod Directory/
-- L__ assets/                               <-- Config.BASE_MOD 
--     |
--     |-- _npcs/                            <-- NPC Overrides
--     |   |-- giovanni_back_bw.png          <-- [Charname]_[Typ]_[Suffix].png
--     |   L__ giovanni_back_color.png
--     |
--     L__ leaf/                             <-- Custom Character Folder (Ordnername = Charname)
--         |                                 <-- [Typ]_[Suffix].png
--         |-- back_bw.png                   
--         |-- back_color.png                
--         |-- front_bw.png                  
--         |-- front_color.png               
--         |-- walk_bw.png                   
--         |-- walk_color.png                
--         |-- bike_bw.png                   
--         |-- bike_color.png                
--         |-- fish_back_bw.png              
--         |-- fish_front_bw.png             
--         |-- fish_side_bw.png              
--         L__ fish_color.png           
--
-- -------------------------------------------------------------------------
--
-- 2. BASE ENGINE / ROM DIRECTORY (Virtual/Engine Folder)
-- script fallback if no mod override is found
--
-- Base Engine/
-- L__ assets/generated/                     <-- Config.BASE_GENERATED 
--     |
--     |-- battle/
--     |   |-- front/                        <-- Config.FRONT_POKEMON (Pokemon front sprites)
--     |   |   |-- abra.png                  <-- (Example)
--     |   |   L__ bulbasaur.png
--     |   |
--     |   |-- back/                         <-- Config.BACK_POKEMON (Pokemon back sprites)
--     |   |   |-- abrab.png                 <-- (Notice the 'b' suffix for back sprites!)
--     |   |   L__ bulbasaurb.png
--     |   |
--     |   |-- trainers/                     <-- Config.FRONT_SPRITES (Original trainer fronts)
--     |   |   |-- agatha.png                <-- (Example)
--     |   |   L__ beauty.png
--     |   |
--     |   L__ redb.png                      <-- Config.RED_BACK (Player back sprite is in battle root)
--     |
--     |-- sprites/                          <-- Config.OVERWORLD_SPRITES
--     |   |-- agatha.png                    <-- (Example: overworld walking sprite)
--     |   |-- beauty.png
--     |   L__ red.png                       <-- Config.RED
--     |
--     |-- trainer_card/                     <-- (GEN 1 ROMs)
--     |   L__ red.png                       <-- Config.RED_FRONT
--     |
--     L__ trainer_card/                     <-- (GEN 2 ROMs)
--         L__ card.png                      <-- Config.CHRIS_FRONT
--
-- =========================================================================