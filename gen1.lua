-- =========================================================================
-- gen1.lua (Strictly Gen 1 & Config-Driven)
-- =========================================================================

-- 1. REGISTRY FÜR SKALIERUNG / OFFSETS
if not love.graphics._custom_scale_registry then
    love.graphics._custom_scale_registry = setmetatable({}, {__mode = "k"})
    love.graphics._custom_scale_paths_data = setmetatable({}, {__mode = "k"})
end
local scale_registry = love.graphics._custom_scale_registry
local scale_paths_data = love.graphics._custom_scale_paths_data

local SPRITE_CONFIG = {
    walk =       { kind = "walk",       id = "SPRITE_RED",            vanillaSuffix = ".png" },
    bike =       { kind = "bike",       id = "SPRITE_RED_BIKE",       vanillaSuffix = "_bike.png" },
    fish_back =  { kind = "fish_back",  id = "SPRITE_RED_FISH_BACK",  vanillaSuffix = "_fish_back.png" },
    fish_front = { kind = "fish_front", id = "SPRITE_RED_FISH_FRONT", vanillaSuffix = "_fish_front.png" },
    fish_side =  { kind = "fish_side",  id = "SPRITE_RED_FISH_SIDE",  vanillaSuffix = "_fish_side.png" }
}

-- 2. HILFSFUNKTION FÜR PFAD-ERKENNUNG
local function identifyImageType(filename)
    if type(filename) ~= "string" then return nil end
    
    -- Regel 1: ALLE Back-Sprites (Egal ob _npcs oder Custom Ordner)
    if filename:match("back_bw%.png$") then
        -- Versucht zuerst _npcs Format (z.B. giovanni_back_bw.png)
        local charName = filename:match("([^/]+)_back_bw%.png$")
        if not charName then
            -- Wenn nicht gefunden, versucht es Custom Format (z.B. leaf/back_bw.png)
            charName = filename:match("([^/]+)/back_bw%.png$")
        end
        return "back_sprite_" .. (charName or "unknown")
    end
    
    -- Regel 2: Custom Front-Sprites (aus assets/[charname]/)
    if filename:match("assets/([^/]+)/front_bw%.png$") and not filename:match("assets/_npcs/") then
        return "custom_front"
    end
    
    -- Regel 3: Pokémon Front-Sprites für individuelle Offsets erkennen
    local pokeName = filename:match("assets/generated/battle/front/([^/]+)%.png$")
    if pokeName then
        return "poke_front_" .. pokeName
    end
    
    return nil
end

return function(mod)
    -- 3. CONFIG LADEN
    local config_chunk = mod:read("Config.lua")
    if not config_chunk then error("Fehler: Config.lua konnte nicht gefunden werden!") end
    local Config = assert(load(config_chunk))()

    -- 4. STATE VARIABLEN
    local currentIndex = 1 
    local defaultIndex = 1 
    local CHARACTER_LIST = {} 
    local MENU_CHOICES = {}
    local originalPlayerPics = nil
    local game = nil
    
    -- NEU: Variable für den aktuellen Hide_NPCs Status aus der Config
    local useHideNPCS = Config.DEFAULT_HIDE_NPCS

    -- 5. HILFSFUNKTIONEN FÜR DAS MENÜ
    local function formatDisplayName(name)
        if Config.DISPLAY_NAME_MAP and Config.DISPLAY_NAME_MAP[name] then 
            return Config.DISPLAY_NAME_MAP[name] 
        end
        local cleanName = name:gsub("_", " ")
        cleanName = cleanName:gsub("(%a)([%w]*)", function(first, rest)
            return first:upper() .. rest:lower()
        end)
        return cleanName
    end

    local function getHiddenNames()
        local hiddenMap = {}
        -- ÄNDERUNG: Nutzt jetzt den lokalen State und liest hide.lua immer aus, 
        -- blockiert aber nicht direkt die Funktion
        local chunk = mod:read("hide.lua")
        if chunk then
            local load_ok, hide_function = pcall(loadstring or load, chunk)
            if load_ok and type(hide_function) == "function" then
                local run_ok, list = pcall(hide_function)
                if run_ok and type(list) == "table" then
                    for _, name in ipairs(list) do
                        if type(name) == "string" then hiddenMap[name:lower()] = true end
                    end
                end
            end
        end
        
        -- ÄNDERUNG: Red darf niemals in die Blacklist, er ist geschützt
        hiddenMap["red"] = false 
        return hiddenMap
    end

    local function loadCharacters()
        local hiddenNames = getHiddenNames()
        local temp_characters = {}
        local seen_characters = {}

        for i = #CHARACTER_LIST, 1, -1 do CHARACTER_LIST[i] = nil end
        for i = #MENU_CHOICES, 1, -1 do MENU_CHOICES[i] = nil end

        -- A) Custom-Sprites scannen
        local customItems = mod:list(Config.BASE_MOD)
        if customItems then
            for _, folderName in ipairs(customItems) do
                local info = mod:info(Config.BASE_MOD .. folderName)
                if info and info.type == "directory" and folderName ~= "_npcs" and folderName ~= "generated" then
                    local baseName = folderName
                    if baseName and not hiddenNames[baseName:lower()] then
                        local internalName = "custom_" .. baseName
                        if not seen_characters[internalName] then
                            local walkPath = mod.assets:path(Config.BASE_MOD .. baseName .. "/walk" .. Config.SUFFIX_GEN1 .. Config.FILE_EXT)
                            if pcall(love.image.newImageData, walkPath) then
                                seen_characters[internalName] = true
                                table.insert(temp_characters, { 
                                    name = baseName, 
                                    isCustom = true,
                                    displayName = formatDisplayName(baseName)
                                })
                            end
                        end
                    end
                end
            end
        end

        -- B) Vanilla-Sprites scannen
        -- ÄNDERUNG: Wenn useHideNPCS aktiv ist, wird dieser ganze Block übersprungen!
        if not useHideNPCS then
            for id, spriteDef in mod.content.sprites:each() do
                local file = spriteDef.image
                if type(file) == "string" then
                    if file:match("%.png$") 
                       and not file:match("bike%.png$") 
                       and not file:match("_fish") 
                       and not file:match("_surf%.png$") then
                        
                        local baseName = file:match("([^/]+)%.png$")
                        if baseName and not hiddenNames[baseName:lower()] then
                            local internalName = "vanilla_" .. baseName
                            if spriteDef.walker or spriteDef.frames == 6 then
                                if not seen_characters[internalName] then
                                    seen_characters[internalName] = true
                                    table.insert(temp_characters, { 
                                        name = baseName, 
                                        isCustom = false,
                                        displayName = formatDisplayName(baseName)
                                    })
                                end
                            end
                        end
                    end
                end
            end
        end
        
        -- ÄNDERUNG: Zwingt Red (Standard-Sprite) in die Liste, falls er fehlt 
        -- (passiert, wenn Vanilla-Sprites in Schritt B übersprungen wurden)
        if not seen_characters["vanilla_red"] then
            table.insert(temp_characters, { 
                name = "red", 
                isCustom = false,
                displayName = "Red (Default)"
            })
            seen_characters["vanilla_red"] = true
        end

        table.sort(temp_characters, function(a, b)
            -- Zuerst nach Kategorie sortieren (Vanilla = false, Custom = true)
            if a.isCustom ~= b.isCustom then
                return not a.isCustom 
            end
            -- Innerhalb der Kategorie alphabetisch sortieren
            return a.displayName < b.displayName
        end)

        for i, charData in ipairs(temp_characters) do
            table.insert(CHARACTER_LIST, charData)
            table.insert(MENU_CHOICES, { charData.displayName, i })
            if charData.name == "red" and not charData.isCustom then defaultIndex = i end
        end

        if #CHARACTER_LIST > 0 and (currentIndex > #CHARACTER_LIST or not CHARACTER_LIST[currentIndex]) then
            currentIndex = defaultIndex > 0 and defaultIndex or 1
        end
    end
    
    loadCharacters()

    -- ÄNDERUNG: hide_npcs in das Gen 1 Optionsmenü integriert
    mod.options:define({
        {
            key = "hide_npcs",
            type = "toggle",
            label = "HIDE VANILLA NPCS",
            default = Config.DEFAULT_HIDE_NPCS,
            help = "Toggles standard NPCs off to show custom sprites only"
        },
        {
            key = "use_shortcuts",
            type = "toggle",
            label = "PGUP/PGDN SWITCH",
            default = Config.DEFAULT_SHORTCUTS_ENABLED,
            help = "Toggles shortcut"
        }
    })

    -- 6. BILDER LADEN & ANWENDEN
    local function applyPlayerSprites()
        if not game then return end
        local charInfo = CHARACTER_LIST[currentIndex]
        local fallbackInfo = CHARACTER_LIST[defaultIndex] or charInfo

        -- === A: ALLE WELT-NPCS ÜBERSCHREIBEN ===
        if game.data and game.data.sprites then
            local sprites = game.data.sprites
            for id, spriteData in pairs(sprites) do
                local vanillaSprite = mod.content.sprites:get(id)
                if vanillaSprite and type(vanillaSprite.image) == "string" then
                    local baseName = vanillaSprite.image:match("([^/]+)%.png$")
                    if baseName then
                        local overridePath = Config.BACK_SPRITES .. baseName .. "_walk" .. Config.SUFFIX_GEN1 .. Config.FILE_EXT
                        local infoFile = mod:info(overridePath)
                        if infoFile and infoFile.type == "file" then
                            spriteData.image = mod.assets:path(overridePath)
                        end
                    end
                end
            end

            -- === B: AUSGEWÄHLTEN SPIELER ÜBERSCHREIBEN (Overworld) ===
            for key, config in pairs(SPRITE_CONFIG) do
                local spriteData = sprites[config.id]
                if spriteData then
                    local targetPath = nil
                    
                    if charInfo.isCustom then
                        local customPath = Config.BASE_MOD .. charInfo.name .. "/" .. config.kind .. Config.SUFFIX_GEN1 .. Config.FILE_EXT
                        if pcall(love.graphics.newImage, mod.assets:path(customPath)) then targetPath = mod.assets:path(customPath) end
                    else
                        local npcOverride = Config.BACK_SPRITES .. charInfo.name .. "_" .. config.kind .. Config.SUFFIX_GEN1 .. Config.FILE_EXT
                        if pcall(love.graphics.newImage, mod.assets:path(npcOverride)) then
                            targetPath = mod.assets:path(npcOverride)
                        else
                            local dir = (config.kind:match("fish")) and (Config.BASE_GENERATED .. "fx/") or Config.OVERWORLD_SPRITES
                            local vanillaPath = dir .. charInfo.name .. config.vanillaSuffix
                            if pcall(love.graphics.newImage, vanillaPath) then targetPath = vanillaPath end
                        end
                    end

                    if targetPath then spriteData.image = targetPath end
                end
            end
        end

        -- === C: BATTLE SPRITES ÜBERSCHREIBEN (Front & Back) ===
        if game.data and game.data.field and game.data.field.playerPics then
            local pPics = game.data.field.playerPics
            if not originalPlayerPics then originalPlayerPics = { front = pPics.front, back = pPics.back } end
            
            local function getBattlePic(info, isBack)
                if not info then return nil end
                local kind = isBack and "back" or "front"
                
                if info.isCustom then
                    local customPath = Config.BASE_MOD .. info.name .. "/" .. kind .. Config.SUFFIX_GEN1 .. Config.FILE_EXT
                    if pcall(love.graphics.newImage, mod.assets:path(customPath)) then return mod.assets:path(customPath) end
                    return nil
                end

                local lowerName = info.name:lower()
                local mappedName = isBack and (Config.BACK_TRAINER_MAP[lowerName] or lowerName) or (Config.FRONT_TRAINER_MAP[lowerName] or lowerName)

                if Config.IS_POKEMON[lowerName] then
                    local subDir = isBack and Config.BACK_POKEMON or Config.FRONT_POKEMON
                    local pokeSuffix = isBack and "b" .. Config.FILE_EXT or Config.FILE_EXT
                    local pokePath = subDir .. mappedName .. pokeSuffix
                    if pcall(love.graphics.newImage, pokePath) then return pokePath end
                    return nil 
                end

                local npcOverride = Config.BACK_SPRITES .. lowerName .. "_" .. kind .. Config.SUFFIX_GEN1 .. Config.FILE_EXT
                if pcall(love.graphics.newImage, mod.assets:path(npcOverride)) then return mod.assets:path(npcOverride) end
                
                if mappedName ~= lowerName then
                    local mappedOverride = Config.BACK_SPRITES .. mappedName .. "_" .. kind .. Config.SUFFIX_GEN1 .. Config.FILE_EXT
                    if pcall(love.graphics.newImage, mod.assets:path(mappedOverride)) then return mod.assets:path(mappedOverride) end
                end

                if isBack then
                    if mappedName == "red" then return Config.RED_BACK end
                else
                    if mappedName == "red" then return Config.RED_FRONT end
                    local vanillaFront = Config.FRONT_SPRITES .. mappedName .. Config.FILE_EXT
                    if pcall(love.graphics.newImage, vanillaFront) then return vanillaFront end
                end
                return nil
            end

            pPics.front = getBattlePic(charInfo, false) or getBattlePic(fallbackInfo, false) or originalPlayerPics.front
            pPics.back = getBattlePic(charInfo, true) or getBattlePic(fallbackInfo, true) or originalPlayerPics.back
        end
    end

    local function syncSavedOptions()
        -- ÄNDERUNG: Optionen direkt vom Ladevorgang aktualisieren
        local short_ok, short_val = pcall(mod.options.get, mod.options, "use_shortcuts")
        if short_ok and short_val ~= nil then Config.DEFAULT_SHORTCUTS_ENABLED = short_val end
        
        local hide_ok, hide_val = pcall(mod.options.get, mod.options, "hide_npcs")
        if hide_ok and hide_val ~= nil then useHideNPCS = hide_val end

        -- Die Charaktere direkt mit den richtigen Hide_NPC Einstellungen laden
        loadCharacters()

        local saved_name = mod.save:get("custom_char_name")
        
        local found = false
        if type(saved_name) == "string" then
            for i, charData in ipairs(CHARACTER_LIST) do
                if charData.name == saved_name then
                    currentIndex = i
                    found = true
                    break
                end
            end
        end

        if not found then
            currentIndex = defaultIndex > 0 and defaultIndex or 1
        end
        
        applyPlayerSprites()
    end

    -- 8. HOOKS & EVENTS 
    local GameModule = require("src.core.Game")
    if not GameModule._charSwitcherHooked then
        local inner = GameModule.keypressed
        function GameModule:keypressed(key)
            local top = self.stack and self.stack:top()
            if Config.DEFAULT_SHORTCUTS_ENABLED and not (top and top.onKeyPressed) then
                if key == "pagedown" or key == "pageup" then
                    if #CHARACTER_LIST == 0 then return inner(self, key) end
                    
                    if key == "pagedown" then
                        currentIndex = currentIndex + 1
                        if currentIndex > #CHARACTER_LIST then currentIndex = 1 end
                    elseif key == "pageup" then
                        currentIndex = currentIndex - 1
                        if currentIndex < 1 then currentIndex = #CHARACTER_LIST end
                    end
                    
                    applyPlayerSprites()
                    
                    mod.save:set("custom_char_name", CHARACTER_LIST[currentIndex].name)
                    
                    return
                end
            end
            return inner(self, key)
        end
        GameModule._charSwitcherHooked = true
    end

    mod.events:on("mod.options_changed", function(payload)
        if payload and payload.mod == mod.id then
            if payload.key == "use_shortcuts" then
                Config.DEFAULT_SHORTCUTS_ENABLED = payload.value
            elseif payload.key == "hide_npcs" then
                -- ÄNDERUNG: Die Liste und die Sprites live aktualisieren
                useHideNPCS = payload.value
                
                -- Aktuellen Namen merken, damit man nicht automatisch auf "red" springt
                local currentName = CHARACTER_LIST[currentIndex] and CHARACTER_LIST[currentIndex].name
                loadCharacters()
                
                local found = false
                for i, charData in ipairs(CHARACTER_LIST) do
                    if charData.name == currentName then
                        currentIndex = i
                        found = true
                        break
                    end
                end
                if not found then
                    currentIndex = defaultIndex > 0 and defaultIndex or 1
                end
                
                applyPlayerSprites()
            end
        end
    end)

    -- 7.5 CUSTOM SCREEN FÜR CHARAKTERAUSWAHL
    mod.content.screens:register("CharacterPicker", {
        new = function(game)
            local Font = mod.ui.Font
            local self = { game = game } -- isOpaque fehlt absichtlich, damit es ein Overlay bleibt

            function self:update(dt)
                local changed = false
                
                if game.input:wasPressed("right") or game.input:wasPressed("down") then
                    currentIndex = currentIndex + 1
                    if currentIndex > #CHARACTER_LIST then currentIndex = 1 end
                    changed = true
                elseif game.input:wasPressed("left") or game.input:wasPressed("up") then
                    currentIndex = currentIndex - 1
                    if currentIndex < 1 then currentIndex = #CHARACTER_LIST end
                    changed = true
                end

                if game.input:wasPressed("a") or game.input:wasPressed("b") then
                    game.stack:pop()
                end

                if changed then
                    applyPlayerSprites()
                    mod.save:set("custom_char_name", CHARACTER_LIST[currentIndex].name)
                end
            end

            function self:draw()
                Font.drawBox(0, 0, 20, 5)
                Font.draw("CHARACTER:", 10, 10)
                
                local charName = CHARACTER_LIST[currentIndex] and CHARACTER_LIST[currentIndex].displayName or "Unknown"
                Font.draw(charName, 10, 24)
            end

            return self
        end
    })

    mod.hooks:wrap("ui.start_menu.items", function(next, game, items)
        mod.ui.insertBefore(items, "MODS", {
            label = "CHARACTER",
            onSelect = function() 
                mod.ui.push(game, "CharacterPicker") 
            end,
        })
        return next(game, items)
    end)

    mod.events:on("game.ready", function(ev)
        game = ev.game
        syncSavedOptions()
    end)
    mod.events:on("save.loaded", function() syncSavedOptions() end)
    mod.events:on("save.created", function() syncSavedOptions() end)

    -- =====================================================================
    -- 9. RENDER HOOKS (Intelligente Skalierung nach Dateipfad & Höhe)
    -- =====================================================================
    if not love.graphics._scaleHooked then
        love.graphics._scaleHooked = true
        
        local orig_newImageData = love.image.newImageData
        love.image.newImageData = function(filename, ...)
            local id = orig_newImageData(filename, ...)
            local imgType = identifyImageType(filename)
            if imgType then scale_paths_data[id] = imgType end
            return id
        end

        local orig_newImage = love.graphics.newImage
        love.graphics.newImage = function(data, ...)
            local img = orig_newImage(data, ...)
            if type(data) == "string" then
                local imgType = identifyImageType(data)
                if imgType then scale_registry[img] = imgType end
            elseif type(data) == "userdata" and data.typeOf and data:typeOf("ImageData") and scale_paths_data[data] then
                scale_registry[img] = scale_paths_data[data]
            end
            return img
        end
        
        local orig_draw = love.graphics.draw
        love.graphics.draw = function(drawable, ...)
            local imgType = scale_registry[drawable]
            
            if imgType then
                local c_scale, c_x, c_y = 1.0, 0, 0
                
              -- Regel 1: Alle Back-Sprites (NPC und Custom)
                if imgType:match("^back_sprite_") then
                    c_scale = 0.5
                    
                    if Config.NPC_BACK_OFFSET then
                        c_x = Config.NPC_BACK_OFFSET.x or 0
                        c_y = Config.NPC_BACK_OFFSET.y or 0
                    end
                
                -- Regel 2: Custom Front-Sprites (aus assets/[charname]) mit Breite 40
                elseif imgType == "custom_front" then
					c_x = -1
				
                    if drawable:getWidth() == 40 then
                        c_x = 13
                    end
                    
                -- Regel 3: Dynamische Pokémon-Offsets aus der Config laden
                elseif imgType:match("^poke_front_") then
                    local pokeName = imgType:gsub("poke_front_", "")
                    
                    if Config.POKEMON_FRONT_OFFSETS and Config.POKEMON_FRONT_OFFSETS[pokeName] then
                        c_x = Config.POKEMON_FRONT_OFFSETS[pokeName].x or 0
                        c_y = Config.POKEMON_FRONT_OFFSETS[pokeName].y or 0
                    end
                end
                
                if c_scale ~= 1.0 or c_x ~= 0 or c_y ~= 0 then
                    local arg1 = select(1, ...)
                    if type(arg1) == "userdata" and arg1.typeOf and arg1:typeOf("Quad") then
                        local quad = arg1
                        local x, y, r, sx, sy, ox, oy, kx, ky = select(2, ...)
                        local new_sx = (sx or 1) * c_scale
                        local new_sy = (sy or 1) * c_scale
                        local new_x = (x or 0) + c_x
                        local new_y = (y or 0) + c_y
                        return orig_draw(drawable, quad, new_x, new_y, r or 0, new_sx, new_sy, ox, oy, kx, ky)
                    elseif type(arg1) == "userdata" and arg1.typeOf and arg1:typeOf("Transform") then
                        local t = arg1:clone()
                        t:translate(c_x, c_y)
                        t:scale(c_scale, c_scale)
                        return orig_draw(drawable, t)
                    else
                        local x, y, r, sx, sy, ox, oy, kx, ky = ...
                        local new_sx = (sx or 1) * c_scale
                        local new_sy = (sy or 1) * c_scale
                        local new_x = (x or 0) + c_x
                        local new_y = (y or 0) + c_y
                        return orig_draw(drawable, new_x, new_y, r or 0, new_sx, new_sy, ox, oy, kx, ky)
                    end
                end
            end
            
            return orig_draw(drawable, ...)
        end
    end
end