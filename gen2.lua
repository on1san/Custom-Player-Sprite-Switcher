if not love.graphics._custom_hd_registry then
    love.graphics._custom_hd_registry = setmetatable({}, {__mode = "k"})
    love.graphics._custom_hd_paths_data = setmetatable({}, {__mode = "k"})
    love.graphics._custom_hd_paths = {}
    
    love.graphics._vanilla_card_imgs = setmetatable({}, {__mode = "k"})
    love.graphics._custom_card_cache = {}
end

local hd_registry = love.graphics._custom_hd_registry
local hd_paths_data = love.graphics._custom_hd_paths_data
local hd_paths = love.graphics._custom_hd_paths

local vanilla_card_imgs = love.graphics._vanilla_card_imgs
local custom_card_cache = love.graphics._custom_card_cache

return function(mod)
    local config_chunk = mod:read("config.lua") or mod:read("config")
    if not config_chunk then
        error("MOD-FEHLER: config.lua konnte im Mod-Ordner nicht gefunden werden!")
    end
    local Config = load(config_chunk)()
    
    local CHARACTER_LIST = {} 
    
    local useHideNPCS = Config.DEFAULT_HIDE_NPCS
    local shortcutsEnabled = Config.DEFAULT_SHORTCUTS_ENABLED

    local game
    local currentIndex = 1 
    local defaultIndex = 1 
    local active_card_image = nil 
    
    local MENU_CHOICES = {}
    local pendingMapRefresh = false
    
    -- Overlay Variablen
    local isPickerOverlayOpen = false
    local pickerCooldown = 0
    
    -- Dynamischer Default
    local defaultPlayerName = "chris"
    
    -- ==========================================================
    -- EVENT LISTENER FÜR SKRIPTE UND KÄMPFE
    -- ==========================================================
    local activeScripts = 0
    local inBattle = false

    -- Ein Skript läuft, wenn der Spieler Dialoge liest, Schilder ansieht 
    -- oder eine Zwischensequenz (z.B. Arenaleiter-Start) aktiv ist.
    mod.events:on("script.started", function() activeScripts = activeScripts + 1 end)
    mod.events:on("script.ended", function() activeScripts = math.max(0, activeScripts - 1) end)
    
    -- Ein Kampf findet statt (Trainer, Wildnis, Arenaleiter).
    mod.events:on("battle.started", function() inBattle = true end)
    mod.events:on("battle.ended", function() inBattle = false end)

    local function detectDefaultPlayer()
        local def = "chris"
        if game then
            -- 1. Prüfe direktes Player-Objekt oder Save-Player
            local p = game.player or (game.save and game.save.player)
            if p and p.gender ~= nil then
                if p.gender == 1 or p.gender == "female" or p.gender == "Female" or p.gender == "kris" then
                    def = "kris"
                end
            elseif game.save and game.save.gender ~= nil then
                local g = game.save.gender
                if g == 1 or g == "female" or g == "Female" or g == "kris" then
                    def = "kris"
                end
            end
            
            -- 2. Fallback: Prüfe die vom Spiel geladenen Bildpfade
            if def == "chris" and game.data and game.data.field and game.data.field.playerPics then
                local fPath = game.data.field.playerPics.front or ""
                local bPath = game.data.field.playerPics.back or ""
                if fPath:match("card_f") or fPath:match("kris") or bPath:match("female") or bPath:match("kris") then
                    def = "kris"
                end
            end
        end
        return def
    end

    local function getBasePaths(isKris)
        if isKris then
            return {
                walk = Config.KRIS,
                bike = Config.KRIS_BIKE,
                front = Config.KRIS_FRONT,
                back = Config.KRIS_BACK
            }
        else
            return {
                walk = Config.CHRIS,
                bike = Config.CHRIS_BIKE,
                front = Config.CHRIS_FRONT,
                back = Config.CHRIS_BACK
            }
        end
    end

    local function formatDisplayName(name)
        if Config.DISPLAY_NAME_MAP[name] then return Config.DISPLAY_NAME_MAP[name] end
        local cleanName = name:gsub("_", " ")
        cleanName = cleanName:gsub("(%a)([%w]*)", function(first, rest)
            return first:upper() .. rest:lower()
        end)
        return cleanName
    end

    local function getHiddenNames()
        local hiddenMap = {}
        if not useHideNPCS then return hiddenMap end
        local chunk = mod:read("hide_npcs")
        if chunk then
            local load_ok, hide_function = pcall(loadstring or load, chunk)
            if load_ok and type(hide_function) == "function" then
                local run_ok, list = pcall(hide_function)
                if run_ok and type(list) == "table" then
                    for _, name in ipairs(list) do
                        if type(name) == "string" then
                            hiddenMap[name:lower()] = true
                        end
                    end
                end
            end
        end
        hiddenMap[defaultPlayerName] = false
        return hiddenMap
    end

    local function loadCharacters()
        local hiddenNames = getHiddenNames()
        local temp_characters = {}
        for i = #CHARACTER_LIST, 1, -1 do CHARACTER_LIST[i] = nil end
        for i = #MENU_CHOICES, 1, -1 do MENU_CHOICES[i] = nil end

        local added_custom_names = {}
        
        local items = mod:list("assets")
        if type(items) == "table" then
            for _, dirName in ipairs(items) do
                if not hiddenNames[dirName:lower()] then
                    local relDir = "assets/" .. dirName
                    local info = mod:info(relDir)
                    
                    if info and info.type == "directory" then
                        local relColor = relDir .. "/walk_color.png"
                        local relBw = relDir .. "/walk_bw.png"
                        
                        if mod:info(relColor) or mod:info(relBw) then
                            added_custom_names[dirName:lower()] = true
                            table.insert(temp_characters, { 
                                name = dirName, 
                                folderPath = relDir,
                                displayName = formatDisplayName(dirName),
                                isCustom = true
                            })
                        end
                    end
                end
            end
        end

        if not useHideNPCS then
            for baseName, _ in pairs(Config.FRONT_TRAINER_MAP_GEN2) do
                if not hiddenNames[baseName:lower()] and not added_custom_names[baseName:lower()] then
                    table.insert(temp_characters, { 
                        name = baseName, 
                        folderPath = "assets/generated/sprites",
                        displayName = formatDisplayName(baseName),
                        isCustom = false
                    })
                end
            end
        end

        if not added_custom_names[defaultPlayerName] then
            local dispName = (defaultPlayerName == "kris") and "Kris (Default)" or "Chris (Default)"
            table.insert(temp_characters, { 
                name = defaultPlayerName, 
                folderPath = "assets/generated/sprites",
                displayName = dispName,
                isCustom = false
            })
        end

        table.sort(temp_characters, function(a, b)
            if a.isCustom ~= b.isCustom then
                return not a.isCustom 
            end
            return a.displayName < b.displayName
        end)

        for i, charData in ipairs(temp_characters) do
            table.insert(CHARACTER_LIST, charData)
            table.insert(MENU_CHOICES, { charData.displayName, charData.name })
            if charData.name:lower() == defaultPlayerName and not charData.isCustom then
                defaultIndex = i
            end
        end

        if #CHARACTER_LIST > 0 and (currentIndex > #CHARACTER_LIST or not CHARACTER_LIST[currentIndex]) then
            currentIndex = defaultIndex > 0 and defaultIndex or 1
        end
    end

    local function findIndexByNameAndCustom(name, isCustom)
        if not name then return nil end
        for i, charData in ipairs(CHARACTER_LIST) do
            if charData.name == name then
                if isCustom == nil or charData.isCustom == isCustom then
                    return i
                end
            end
        end
        return nil
    end

    loadCharacters()

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




local function getPicPath(info, picType)
        if not info then return nil end

        if info.isCustom then
            local searchType = picType
            if searchType == "card" then searchType = "front" end
            
            local relColor = info.folderPath .. "/" .. searchType .. "_color.png"
            local relBw = info.folderPath .. "/" .. searchType .. "_bw.png"
            
            if picType == "front" and not mod:info(relColor) then
                local altColor = info.folderPath .. "/card_color.png"
                if mod:info(altColor) then return mod.assets:path(altColor) end
            end
            
            if mod:info(relColor) then return mod.assets:path(relColor) end
            if mod:info(relBw) then return mod.assets:path(relBw) end
            
            -- NEU: Wenn kein Custom-Bild existiert, zwingen wir den Code,
            -- das korrekte Vanilla-Bild zu laden, statt auf den Spielstand zurückzufallen!
            if picType == "back" then
                if info.name:lower() == "kris" then return Config.KRIS_BACK end
                if info.name:lower() == "chris" then return Config.CHRIS_BACK end
            end
        else
            local basePaths = getBasePaths(defaultPlayerName == "kris")
            
            if picType == "card" then
                return basePaths.front
            elseif picType == "front" then
                if info.name == defaultPlayerName then return nil end
                local mappedName = Config.FRONT_TRAINER_MAP_GEN2[info.name] or info.name
                return Config.FRONT_SPRITES .. mappedName .. Config.FILE_EXT
            elseif picType == "back" then
                if info.name == defaultPlayerName then return basePaths.back end
                local mappedName = Config.BACK_TRAINER_MAP_GEN2[info.name] or info.name
                
                local relColor = Config.BACK_SPRITES .. mappedName .. "_back_color.png"
                local relBw = Config.BACK_SPRITES .. mappedName .. "_back_bw.png"
                
                if mod:info(relColor) then return mod.assets:path(relColor) end
                if mod:info(relBw) then return mod.assets:path(relBw) end
                
                -- NEU: Verhindert auch hier das falsche Fallback auf den Standard-Charakter
                if info.name:lower() == "kris" then return Config.KRIS_BACK end
                if info.name:lower() == "chris" then return Config.CHRIS_BACK end
                
                return basePaths.back
            elseif picType == "walk" then
                return Config.OVERWORLD_SPRITES .. info.name .. Config.FILE_EXT
            elseif picType == "bike" then
                return Config.OVERWORLD_SPRITES .. info.name .. "_bike" .. Config.FILE_EXT
            end
        end
        
        return nil
    end





    local function getCharAndFallback()
        local charInfo = CHARACTER_LIST[currentIndex]
        local fallbackInfo = { 
            name = defaultPlayerName, 
            folderPath = "assets/generated/sprites", 
            isCustom = false
        }
        for _, char in ipairs(CHARACTER_LIST) do
            if char.name:lower() == defaultPlayerName then
                fallbackInfo = char
                break
            end
        end
        return charInfo, fallbackInfo
    end

    local trainerCardScreenDef = {
        new = function(game, opts)
            local TrainerCard = require("src.ui.gen2.TrainerCard")
            
            local newOpts = opts or {}
            local base = (game.data.gen2MenuGfx or {}).trainerCard or {}
            local gfx = {}
            for k, v in pairs(base) do gfx[k] = v end
            
            local detectedKris = (detectDefaultPlayer() == "kris")
            local basePaths = getBasePaths(detectedKris)
            gfx.card = basePaths.front
            newOpts.menuGfx = { trainerCard = gfx }

            local instance = TrainerCard.new(game, newOpts)
            local charInfo = getCharAndFallback()
            
            if charInfo.isCustom and instance.card then
                instance.card.palette = nil 
                instance.card.paletteFor = nil
            end
            
            local function drawCustomOverlay()
                local charInfo, fallbackInfo = getCharAndFallback()
                
                if charInfo.isCustom then return end
                
                local mappedName = Config.FRONT_TRAINER_MAP_GEN2[charInfo.name] or charInfo.name
                local frontPath = Config.FRONT_SPRITES .. mappedName .. Config.FILE_EXT
                
                if not frontPath then return end
                
                if not custom_card_cache[frontPath] then
                    local ok, img = pcall(love.graphics.newImage, frontPath)
                    if ok then
                        custom_card_cache[frontPath] = img
                    else
                        return
                    end
                end
                
                local overlayImage = custom_card_cache[frontPath]
                if overlayImage then
                    love.graphics.push("all")
                    love.graphics.setColor(1, 1, 1, 1)
                    love.graphics.draw(overlayImage, 96, 32)
                    love.graphics.pop()
                end
            end
            
            local orig_draw = instance.draw
            if orig_draw then
                instance.draw = function(self, ...)
                    orig_draw(self, ...)
                    drawCustomOverlay()
                end
            end
            
            local orig_render = instance.render
            if orig_render then
                instance.render = function(self, ...)
                    orig_render(self, ...)
                    drawCustomOverlay()
                end
            end
            
            return instance
        end,
    }

    mod.content.screens:register("Gen2TrainerCard", trainerCardScreenDef)
    mod.content.screens:register("TrainerCard", trainerCardScreenDef)

    mod.hooks:wrap("player.sprite", function(next, path, ctx)
        path = next(path, ctx)
        if ctx.demo then return path end
        
        local charInfo, fallbackInfo = getCharAndFallback()
        
        local picType = nil
        if ctx.kind == "trainer_card" then
            picType = "front"
        elseif ctx.side == "back" then
            picType = "back"
        end
        
        if picType then
            local customPath = getPicPath(charInfo, picType) or getPicPath(fallbackInfo, picType)
            if customPath then
                local isGenerated = customPath:find("assets/generated", 1, true) ~= nil
                
                if picType ~= "card" then
                    hd_paths[customPath] = not isGenerated
                end
                
                -- Erkennt zuverlässig, ob es sich um Kris handelt
                local isFemaleBack = customPath:match("kris") or customPath:match("female") or customPath:match("player_back_female") or customPath:match("_f_") or customPath:match("_f%.png$")
                
                -- ctx.trueColor zwingt die Engine, das Bild so zu lassen, wie es ist.
                -- Das machen wir NUR bei Custom-Bildern und bei Kris. Chris erhält 'nil'.
                if customPath:match("_color%.png$") or (charInfo.isCustom and not isGenerated) or (picType == "back" and isFemaleBack) then
                    ctx.trueColor = true
                else
                    ctx.trueColor = nil
                end
                
                return customPath
            end
        end
        
        return path
    end)

    local function applyPlayerSprites(isLiveUpdate)
        if not game then return end
        local charInfo, fallbackInfo = getCharAndFallback()

        local cardPath = getPicPath(charInfo, "card") or getPicPath(fallbackInfo, "card")
        if cardPath then
            if not custom_card_cache[cardPath] then
                local ok, new_img = pcall(love.graphics.newImage, cardPath)
                if ok then custom_card_cache[cardPath] = new_img end
            end
            active_card_image = custom_card_cache[cardPath]
        else
            active_card_image = nil
        end

        local walkPath = getPicPath(charInfo, "walk") or getPicPath(fallbackInfo, "walk")
        local isWalkTrueColor = charInfo.isCustom or (walkPath and walkPath:match("_color%.png$") ~= nil)

        local bikePath = getPicPath(charInfo, "bike") or getPicPath(fallbackInfo, "bike")
        local isBikeTrueColor = charInfo.isCustom or (bikePath and bikePath:match("_color%.png$") ~= nil)

        if game.data then
            if game.data.gen2Sprites then
                local sprites = game.data.gen2Sprites
                
                for _, pid in ipairs({"SPRITE_CHRIS", "SPRITE_KRIS"}) do
                    if sprites[pid] and walkPath then
                        hd_paths[walkPath] = charInfo.isCustom
                        sprites[pid].trueColor = isWalkTrueColor
                        sprites[pid].image = walkPath
                    end
                end
                
                for _, pid in ipairs({"SPRITE_CHRIS_BIKE", "SPRITE_KRIS_BIKE"}) do
                    if sprites[pid] and bikePath then
                        hd_paths[bikePath] = charInfo.isCustom
                        sprites[pid].trueColor = isBikeTrueColor
                        sprites[pid].image = bikePath
                    end
                end
            end
        end

        if game.data and game.data.field and game.data.field.playerPics then
            local pPics = game.data.field.playerPics
            
            local backPath = getPicPath(charInfo, "back") or getPicPath(fallbackInfo, "back")
            if backPath then
                hd_paths[backPath] = (not backPath:find("assets/generated", 1, true))
                pPics.back = backPath
            end
            
            local frontPath = getPicPath(charInfo, "front") or getPicPath(fallbackInfo, "front")
            if frontPath then
                hd_paths[frontPath] = (not frontPath:find("assets/generated", 1, true))
                pPics.front = frontPath
            end
        end

        if isLiveUpdate then
            pendingMapRefresh = true
        end
    end

    local function syncSavedOptions()
        local detected = detectDefaultPlayer()
        if detected ~= defaultPlayerName then
            defaultPlayerName = detected
            loadCharacters()
        end

        local saved_name = mod.save:get("custom_char_name")
        local saved_is_custom = mod.save:get("custom_char_is_custom")
        
        if saved_is_custom == false or saved_is_custom == nil then
            if saved_name == "chris" or saved_name == "kris" then
                if saved_name ~= defaultPlayerName then
                    saved_name = defaultPlayerName
                    mod.save:set("custom_char_name", saved_name)
                    mod.save:set("custom_char_is_custom", false)
                end
            end
        end
        
        local foundIndex = findIndexByNameAndCustom(saved_name, saved_is_custom)
        if foundIndex then
            currentIndex = foundIndex
        else
            currentIndex = defaultIndex > 0 and defaultIndex or 1
        end

        local short_ok, short_val = pcall(mod.options.get, mod.options, "use_shortcuts")
        if short_ok and short_val ~= nil then shortcutsEnabled = short_val end
        
        local hide_ok, hide_val = pcall(mod.options.get, mod.options, "hide_npcs")
        if hide_ok and hide_val ~= nil and useHideNPCS ~= hide_val then
            useHideNPCS = hide_val
            loadCharacters()
        end
        applyPlayerSprites(false)

        if mod.world then
            local currentMap = mod.world:current()
            if currentMap and currentMap.mapId then
                mod.world:invalidateMap(currentMap.mapId)
            end
        end
    end

    local GameModule = require("src.core.Game")
    if not GameModule._charSwitcherHookedGen2 then
        local orig_keypressed = GameModule.keypressed
        function GameModule:keypressed(key)
            local top = self.stack and self.stack:top()
            local isBlocked = false
            
            -- Blockiere sofort, wenn ein Skript (Dialog) oder ein Kampf läuft
            if activeScripts > 0 or inBattle then
                isBlocked = true
            end
            
            if top then
                -- 1. Normale Menüs (Startmenü, PC, Optionen etc.)
                if top.onKeyPressed or top.isOpaque or top.items or top.options or top.menu or top.list or top.cursorY then 
                    isBlocked = true 
                end
                
                -- 2. Textboxen (Dialoge), falls diese die Skript-Engine umgehen
                if top.text or top.lines or top.isTextBox or top.textConst then
                    isBlocked = true
                end
                
                -- 3. Kampfanimationen (BattleTransition) und Kampf-States (BattleState)
                if top.battle or top.enemy or top.transition or top.style or top.trainerId then
                    isBlocked = true
                end
            end

            -- Wenn die Steuerung nicht blockiert ist, erlaube den Charakter-Wechsel
            if shortcutsEnabled and not isBlocked then
                local isMoving = false
                local ok, ow = pcall(require, "src.world.OverworldController")
                if ok and ow and ow.player then
                    isMoving = ow.player.moving 
                end

                if not isMoving and (key == "pagedown" or key == "pageup") then
                    if #CHARACTER_LIST == 0 then return orig_keypressed(self, key) end
                    
                    if key == "pageup" then
                        currentIndex = currentIndex + 1
                        if currentIndex > #CHARACTER_LIST then currentIndex = 1 end
                    elseif key == "pagedown" then
                        currentIndex = currentIndex - 1
                        if currentIndex < 1 then currentIndex = #CHARACTER_LIST end
                    end
                    
                    applyPlayerSprites(true)
                    
                    if CHARACTER_LIST[currentIndex] then
                        mod.save:set("custom_char_name", CHARACTER_LIST[currentIndex].name)
                        mod.save:set("custom_char_is_custom", CHARACTER_LIST[currentIndex].isCustom)
                    end
                    
                    return 
                end
            end
            if orig_keypressed then return orig_keypressed(self, key) end
        end
        GameModule._charSwitcherHookedGen2 = true
    end

    -- ==========================================================
    -- OVERLAY HOOKS (Eingaben, Steuerung & Rendering)
    -- ==========================================================

    local isPickerOverlayOpen = false
    local pickerCooldown = 0

    mod.hooks:wrap("core.update", function(next, gameObj, dt)
        
        if isPickerOverlayOpen then
            if pickerCooldown > 0 then
                pickerCooldown = pickerCooldown - 1
            else
                local changed = false
                
                if gameObj.input:wasPressed("right") or gameObj.input:wasPressed("down") then
                    currentIndex = currentIndex + 1
                    if currentIndex > #CHARACTER_LIST then currentIndex = 1 end
                    changed = true
                elseif gameObj.input:wasPressed("left") or gameObj.input:wasPressed("up") then
                    currentIndex = currentIndex - 1
                    if currentIndex < 1 then currentIndex = #CHARACTER_LIST end
                    changed = true
                end

                if gameObj.input:wasPressed("a") or gameObj.input:wasPressed("b") or gameObj.input:wasPressed("start") then
                    isPickerOverlayOpen = false
                end

                if changed then
                    pickerCooldown = 20 
                    applyPlayerSprites(true)
                    
                    if CHARACTER_LIST[currentIndex] then
                        mod.save:set("custom_char_name", CHARACTER_LIST[currentIndex].name)
                        mod.save:set("custom_char_is_custom", CHARACTER_LIST[currentIndex].isCustom)
                    end
                end
            end
        end

        local hideInput = isPickerOverlayOpen or pendingMapRefresh
        local orig_isDown = gameObj.input.isDown
        local orig_wasPressed = gameObj.input.wasPressed

        if hideInput then
            gameObj.input.isDown = function(self, btn) return false end
            gameObj.input.wasPressed = function(self, btn) return false end
        end

        next(gameObj, dt)

        if hideInput then
            gameObj.input.isDown = orig_isDown
            gameObj.input.wasPressed = orig_wasPressed
        end
        
        if pendingMapRefresh then
            if mod.world then
                local currentMap = mod.world:current()
                if currentMap and currentMap.mapId then
                    mod.world:invalidateMap(currentMap.mapId)
                    mod.world:warpTo(currentMap.mapId, currentMap.x, currentMap.y, currentMap.facing)
                end
            end
            pendingMapRefresh = false
        end
    end)

    mod.hooks:wrap("render.hud", function(next, gameObj, viewport)
        next(gameObj, viewport)
        
        if isPickerOverlayOpen then
            love.graphics.push()
            love.graphics.translate(viewport.gameX, viewport.gameY)
            love.graphics.scale(viewport.scale)
            
            local Font = mod.ui.Font
            Font.drawBox(0, 0, 20, 5)
            Font.draw("SELECT CHARACTER:", 10, 12)
            local charName = CHARACTER_LIST[currentIndex] and CHARACTER_LIST[currentIndex].displayName or "Unknown"
            Font.draw(charName, 10, 24)
            
            love.graphics.pop()
        end
    end)

    mod.hooks:wrap("ui.start_menu.items", function(next, gameObj, items)
        mod.ui.insertBefore(items, "OPTION", {
            label = "OW CHAR",
            onSelect = function() 
                gameObj.stack:pop() 
                isPickerOverlayOpen = true 
                pickerCooldown = 15
            end,
        })
        return next(gameObj, items)
    end)

    -- ==========================================================
    -- INITIALISIERUNG
    -- ==========================================================

    mod.events:on("game.ready", function(ev)
        game = ev.game
        syncSavedOptions()
    end)
    
    mod.events:on("save.loaded", function() syncSavedOptions() end)
    mod.events:on("save.created", function() syncSavedOptions() end)

    mod.events:on("mod.options_changed", function(payload)
        if payload and payload.mod == mod.id then
            if payload.key == "custom_char_index" then
                local idx = findIndexByNameAndCustom(payload.value)
                if idx then currentIndex = idx end
                if game and game.save and game.save.options then
                    game.save.options.custom_char_index = payload.value
                end
                applyPlayerSprites(true)
            elseif payload.key == "use_shortcuts" then
                shortcutsEnabled = payload.value
            elseif payload.key == "hide_npcs" then
                useHideNPCS = payload.value
                loadCharacters()
                applyPlayerSprites(true)
            end
        end
    end)

    if not love.graphics._hdNewImageHookedGen2 then
        love.graphics._hdNewImageHookedGen2 = true
        
       local orig_newImage = love.graphics.newImage
        love.graphics.newImage = function(data, ...)
            local img
            
            if type(data) == "string" then
                local isVanillaCard = data:match("card%.png$") or data:match("card_f%.png$") or 
                                      data:match("trainer_card/card%.png$") or data:match("trainer_card/card_f%.png$") or 
                                      data:match("trainer_card\\card%.png$") or data:match("trainer_card\\card_f%.png$")
                
                -- Prüft streng, ob es sich um Kris oder einen weiblichen Custom-Sprite handelt
                local isFemaleBack = data:match("player_back_female") or (data:match("_back_bw%.png$") and (data:match("kris") or data:match("female") or data:match("_f_")))
                
                -- Die Blaue Farbe wird NUR bei Kris angewendet
                if isFemaleBack then
                    local ok, imgData = pcall(love.image.newImageData, data)
                    if ok then
                        imgData:mapPixel(function(x, y, r, g, b, a)
                            if a > 0.1 then
                                if r > 0.1 and r < 0.5 and g > 0.1 and g < 0.5 and b > 0.1 and b < 0.5 then
                                    return 56/255, 40/255, 248/255, a
                                elseif r >= 0.5 and r < 0.95 and g >= 0.5 and g < 0.95 and b >= 0.5 and b < 0.95 then
                                    return 216/255, 136/255, 112/255, a
                                end
                            end
                            return r, g, b, a
                        end)
                        img = orig_newImage(imgData, ...)
                    else
                        img = orig_newImage(data, ...)
                    end
                else
                    -- Chris wird unangetastet geladen!
                    img = orig_newImage(data, ...)
                end
                
                if isVanillaCard then
                    vanilla_card_imgs[img] = true
                end
                
                if hd_paths[data] then
                    hd_registry[img] = true
                end
            elseif type(data) == "userdata" and data.typeOf and data:typeOf("ImageData") and hd_paths_data[data] then
                img = orig_newImage(data, ...)
                hd_registry[img] = true
            else
                img = orig_newImage(data, ...)
            end
            return img
        end
        
        local orig_draw = love.graphics.draw
        love.graphics.draw = function(drawable, ...)
            
            if active_card_image and type(drawable) == "userdata" and drawable.typeOf and drawable:typeOf("Image") and vanilla_card_imgs[drawable] then
                drawable = active_card_image
            end

            if hd_registry[drawable] then
                local c_scale = 1.0
                local c_x = 0
                local c_y = 0

                local w = drawable:getWidth()
                if w == 48 then
                    c_x = Config.NPC_BACK_OFFSET_GEN2 and Config.NPC_BACK_OFFSET_GEN2.x or 0
                    c_y = Config.NPC_BACK_OFFSET_GEN2 and Config.NPC_BACK_OFFSET_GEN2.y or 0
                end

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
            return orig_draw(drawable, ...)
        end
    end
end
