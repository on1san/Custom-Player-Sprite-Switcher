
local SCALE_64 = 0.5
local OFFSET_X_64 = 8
local OFFSET_Y_64 = 56

local SCALE_48 = 0.5
local OFFSET_X_48 = 8
local OFFSET_Y_48 = 48

local SCALE_56 = 1
local OFFSET_X_56 = 0
local OFFSET_Y_56 = 0

local SCALE_40 = 1
local OFFSET_X_40 = 11
local OFFSET_Y_40 = 0

local useHideLua = true
local shortcutsEnabled = true

local SPRITE_CONFIG = {
    walk = { suffix = ".png",       id = "SPRITE_RED" },
    bike = { suffix = "_bike.png",  id = "SPRITE_RED_BIKE" }
}

local FRONT_TRAINER_MAP = {
    ["badguy"] = "burglar",
    ["blue"] = "rival3",
    ["brunette_girl"] = "lass",
    ["cook"] = "hiker",
    ["cooltrainer_f"] = "cooltrainerf",
    ["cooltrainer_m"] = "cooltrainerm",
    ["daisy"] = "lass",
    ["girl"] = "lass",
    ["little_girl"] = "lass", 
    ["middle_aged_man"] = "cueball",
    ["middle_aged_woman"] = "lorelei",
    ["mr_fuji"] = "gambler",
    ["oak"] = "prof.oak",
    ["silph_worker_f"] = "lass",
    ["super_nerd"] = "youngster",
    ["waiter"] = "gentleman"
}

local BACK_TRAINER_MAP = {
    ["badguy"] = "burglar",
    ["agatha"] = "agatha", 
    ["beauty"] = "beauty", 
    ["bird"] = "bird", 
    ["biker"] = "biker",
    ["blue"] = "rival3",
    ["brunette_girl"] = "lass",
    ["bruno"] = "bruno",
    ["channeler"] = "channeler",
    ["cook"] = "hiker",
    ["cooltrainer_f"] = "lass",
    ["cooltrainer_m"] = "cooltrainerm",
    ["daisy"] = "lass",
    ["fairy"] = "fairy",
    ["fisher"] = "fisher",
    ["gambler"] = "gambler",
    ["gentleman"] = "gentleman",
    ["girl"] = "lass",
    ["hiker"] = "hiker",
    ["koga"] = "koga",
    ["lance"] = "lance",
    ["little_girl"] = "lass",
    ["lorelei"] = "lorelei",
    ["middle_aged_man"] = "cueball",
    ["middle_aged_woman"] = "lorelei",
    ["monster"] = "monster",
    ["mr_fuji"] = "gambler",
    ["oak"] = "prof.oak",
    ["rocket"] = "rocket",
    ["rocker"] = "rocker",
    ["sailor"] = "sailor",
    ["scientist"] = "scientist",
    ["seel"] = "seel",
    ["silph_worker_f"] = "lass",
    ["super_nerd"] = "youngster",
    ["swimmer"] = "swimmer",
    ["waiter"] = "gentleman",
    ["youngster"] = "youngster"
}

local POKEMON_MAP = {
    ["bird"] = "farfetchd",
    ["monster"] = "kangaskhan",
    ["seel"] = "seel",
    ["fairy"] = "clefairy"
}

local DISPLAY_NAME_MAP = {
    ["middle_aged_woman"] = "Middle Aged (W)",
    ["middle_aged_man"] = "Middle Aged (M)",
	["cooltrainer_f"] = "Cool Trainer (F)",
    ["cooltrainer_m"] = "Cool Trainer (M)",
	["silph_worker_f"] = "Silph Worker (F)",
}

if not love.graphics._custom_hd_registry then
    love.graphics._custom_hd_registry = setmetatable({}, {__mode = "k"})
    love.graphics._custom_hd_paths_data = setmetatable({}, {__mode = "k"})
    love.graphics._custom_hd_paths = {}
end

local hd_registry = love.graphics._custom_hd_registry
local hd_paths_data = love.graphics._custom_hd_paths_data
local hd_paths = love.graphics._custom_hd_paths

return function(mod)
    local game
    local currentIndex = 1 
    local defaultIndex = 1 
    
    local CHARACTER_LIST = {} 
    local MENU_CHOICES = {}
    
    local originalPlayerPics = nil

    local function formatDisplayName(name)
	if DISPLAY_NAME_MAP[name] then
        return DISPLAY_NAME_MAP[name]
    end
        local cleanName = name:gsub("_", " ")
        cleanName = cleanName:gsub("(%a)([%w]*)", function(first, rest)
            return first:upper() .. rest:lower()
        end)
        return cleanName
    end

    local function getHiddenNames()
        local hiddenMap = {}

        -- HIDE.LUA OFF: completely ignore hide.lua.
        if not useHideLua then
            return hiddenMap
        end

        -- HIDE.LUA ON: read hide.lua and use its returned table
        -- as the list of characters that should be hidden.
        local chunk, err = mod:read("hide.lua")

        if chunk then
            local load_ok, hide_function = pcall(load, chunk)

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

        -- Red must always remain available.
        hiddenMap["red"] = false

        return hiddenMap
    end

    local function loadCharacters()
        local hiddenNames = getHiddenNames()
        local FOLDERS_TO_SCAN = {}

        table.insert(FOLDERS_TO_SCAN, "assets/generated/sprites")
        
        table.insert(FOLDERS_TO_SCAN, mod.path .. "/assets")

        local temp_characters = {}

        for i = #CHARACTER_LIST, 1, -1 do CHARACTER_LIST[i] = nil end
        for i = #MENU_CHOICES, 1, -1 do MENU_CHOICES[i] = nil end

        for _, folderPath in ipairs(FOLDERS_TO_SCAN) do
            local ok, files = pcall(love.filesystem.getDirectoryItems, folderPath)
            
            if ok and type(files) == "table" then
                for _, file in ipairs(files) do
                    if file:match("%.png$") 
                       and not file:match("bike%.png$") 
                       and not file:match("_fish_back%.png$") 
					   and not file:match("_fish_front%.png$") 
					   and not file:match("_fish_side%.png$") 
                       and not file:match("_surf%.png$") 
                       and not file:match("_front%.png$")
                       and not file:match("_back%.png$") then
                        
                        local baseName = file:gsub("%.png$", "")
                        
                        if not hiddenNames[baseName:lower()] then
                            local fullPath = folderPath .. "/" .. file
                            local img_ok, imageData = pcall(love.image.newImageData, fullPath)
                            
                            if img_ok and imageData then
                                if imageData:getWidth() == 16 and imageData:getHeight() == 96 then
                                    local basePath = folderPath .. "/" .. baseName
                                    
                                    table.insert(temp_characters, { 
                                        name = baseName, 
                                        folderPath = folderPath,
                                        basePath = basePath,
                                        displayName = formatDisplayName(baseName)
                                    })
                                end
                            end
                        end
                    end
                end
            end
        end

        table.sort(temp_characters, function(a, b)
            return a.displayName < b.displayName
        end)

        for i, charData in ipairs(temp_characters) do
            table.insert(CHARACTER_LIST, charData)
            table.insert(MENU_CHOICES, { charData.displayName, i })
            
            if charData.name == "red" then
                defaultIndex = i
            end
        end

        if #CHARACTER_LIST > 0 and (currentIndex > #CHARACTER_LIST or not CHARACTER_LIST[currentIndex]) then
            currentIndex = defaultIndex > 0 and defaultIndex or 1
        end
    end

    loadCharacters()

  mod.options:define({
        {
            key = "custom_char_index",
            type = "choice",
            label = "CHARACTER SPRITE",
            default = defaultIndex,
            choices = MENU_CHOICES,
            help = "Choose your character"
        },
        {
            key = "use_hide_lua",
            type = "toggle",
            label = "HIDE.LUA",
            default = useHideLua,
            help = "Toggles hide.lua"
        },
        {
            key = "use_shortcuts",
            type = "toggle",
            label = "PGUP/PGDN SWITCH",
            default = shortcutsEnabled,
            help = "Toggles shortcut"
        }
    })

    local function applyPlayerSprites()
        if not game then return end
        local charInfo = CHARACTER_LIST[currentIndex]
        local fallbackInfo = CHARACTER_LIST[defaultIndex] or charInfo

        if game.data and game.data.sprites then
            local sprites = game.data.sprites
            for key, config in pairs(SPRITE_CONFIG) do
                local spriteData = sprites[config.id]
                if spriteData then
                    local targetPath = nil
                    
                    if charInfo then
                        local testPath = charInfo.basePath .. config.suffix
                        local img_ok, _ = pcall(love.graphics.newImage, testPath)
                        if img_ok then targetPath = testPath end
                    end

                    if not targetPath and fallbackInfo then
                        local fallPath = fallbackInfo.basePath .. config.suffix
                        local img_ok, _ = pcall(love.graphics.newImage, fallPath)
                        if img_ok then targetPath = fallPath end
                    end

                    if targetPath then
                        spriteData.image = targetPath
                    end
                end
            end
        end

        if game.data and game.data.field and game.data.field.playerPics then
            local pPics = game.data.field.playerPics
            
            if not originalPlayerPics then
                originalPlayerPics = {
                    front = pPics.front,
                    back = pPics.back
                }
            end
            
            local function getPicPath(info, isBack)
                if not info then return nil end
                local lowerName = info.name:lower()

                if POKEMON_MAP[lowerName] then
                    local pokeName = POKEMON_MAP[lowerName]
                    local subDir = isBack and "back" or "front"
                    local testPath = "assets/generated/battle/" .. subDir .. "/" .. pokeName .. ".png"
                    
                    local ok, _ = pcall(love.graphics.newImage, testPath)
                    if ok then return testPath end
                    return nil 
                end

                local originalName = info.name
                local mappedName = isBack and (BACK_TRAINER_MAP[lowerName] or originalName) or (FRONT_TRAINER_MAP[lowerName] or originalName)
                
                local modAssetDir = mod.path .. "/assets/"
                local pathsToTry = {}
                
                if isBack then
                    table.insert(pathsToTry, modAssetDir .. originalName .. "_back.png")
                    table.insert(pathsToTry, info.folderPath .. "/" .. originalName .. "_back.png")
                    table.insert(pathsToTry, "assets/generated/battle/back/" .. originalName .. ".png")
                    table.insert(pathsToTry, "assets/generated/trainers/back/" .. originalName .. ".png")
                else
                    table.insert(pathsToTry, modAssetDir .. originalName .. "_front.png")
                    table.insert(pathsToTry, info.folderPath .. "/" .. originalName .. "_front.png")
                    table.insert(pathsToTry, "assets/generated/battle/trainers/" .. originalName .. ".png")
                    table.insert(pathsToTry, "assets/generated/trainers/" .. originalName .. ".png")
                    table.insert(pathsToTry, "assets/generated/battle/front/" .. originalName .. ".png")
                end

                if mappedName ~= originalName then
                    if isBack then
                        table.insert(pathsToTry, modAssetDir .. mappedName .. "_back.png")
                        table.insert(pathsToTry, info.folderPath .. "/" .. mappedName .. "_back.png")
                        table.insert(pathsToTry, "assets/generated/battle/back/" .. mappedName .. ".png")
                        table.insert(pathsToTry, "assets/generated/trainers/back/" .. mappedName .. ".png")
                    else
                        table.insert(pathsToTry, modAssetDir .. mappedName .. "_front.png")
                        table.insert(pathsToTry, info.folderPath .. "/" .. mappedName .. "_front.png")
                        table.insert(pathsToTry, "assets/generated/battle/trainers/" .. mappedName .. ".png")
                        table.insert(pathsToTry, "assets/generated/trainers/" .. mappedName .. ".png")
                        table.insert(pathsToTry, "assets/generated/battle/front/" .. mappedName .. ".png")
                    end
                end
                
                for _, p in ipairs(pathsToTry) do
                    local ok, _ = pcall(love.graphics.newImage, p)
                    if ok then return p end
                end
                
                return nil
            end

            local frontPath = getPicPath(charInfo, false) or getPicPath(fallbackInfo, false) or originalPlayerPics.front
            local backPath = getPicPath(charInfo, true) or getPicPath(fallbackInfo, true) or originalPlayerPics.back

            pPics.front = frontPath
            pPics.back = backPath

            if frontPath then
    local ok, imgData = pcall(love.image.newImageData, frontPath)

    if ok and imgData then
        local width = imgData:getWidth()

        if width == 40 or width == 48 or width == 56 or width == 64 then
            hd_paths[frontPath] = true
        else
            hd_paths[frontPath] = false
        end
    else
        hd_paths[frontPath] = false
    end
end

            if backPath then
                local ok, imgData = pcall(love.image.newImageData, backPath)
                if ok and imgData:getWidth() > 40 and not backPath:find("assets/generated", 1, true) then
                    hd_paths[backPath] = true
                else
                    hd_paths[backPath] = false
                end
            end
        end
    end

    local function syncSavedOptions()
        if game and game.save and game.save.options and game.save.options.custom_char_index then
            currentIndex = game.save.options.custom_char_index
        else
            local opt_ok, val = pcall(mod.options.get, mod.options, "custom_char_index")
            if opt_ok and val ~= nil and val >= 1 and val <= #CHARACTER_LIST then
                currentIndex = val
            end
        end
        
        pcall(function() mod.options:set("custom_char_index", currentIndex) end)
        
        local short_ok, short_val = pcall(mod.options.get, mod.options, "use_shortcuts")
        if short_ok and short_val ~= nil then shortcutsEnabled = short_val end
        
      local hide_ok, hide_val = pcall(mod.options.get, mod.options, "use_hide_lua")
        if hide_ok and hide_val ~= nil and useHideLua ~= hide_val then
            useHideLua = hide_val
            loadCharacters()
        end
        
        applyPlayerSprites()
    end

    local GameModule = require("src.core.Game")
    if not GameModule._charSwitcherHooked then
        local inner = GameModule.keypressed
        function GameModule:keypressed(key)
            local top = self.stack and self.stack:top()
            if shortcutsEnabled and not (top and top.onKeyPressed) then
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
                    
                    if game and game.save and game.save.options then
                        game.save.options.custom_char_index = currentIndex
                    end
                    pcall(function() mod.options:set("custom_char_index", currentIndex) end)
                    
                    return 
                end
            end
            return inner(self, key)
        end
        GameModule._charSwitcherHooked = true
    end

    mod.events:on("mod.options_changed", function(payload)
        if payload and payload.mod == mod.id then
            if payload.key == "custom_char_index" then
                currentIndex = payload.value

                if game and game.save and game.save.options then
                    game.save.options.custom_char_index = currentIndex
                end

                applyPlayerSprites()

            elseif payload.key == "use_shortcuts" then
                shortcutsEnabled = payload.value

            elseif payload.key == "use_hide_lua" then
                useHideLua = payload.value

                loadCharacters()

                applyPlayerSprites()
            end
        end
    end)

    mod.events:on("game.ready", function(ev)
        game = ev.game
        syncSavedOptions()
    end)
    mod.events:on("save.loaded", function() syncSavedOptions() end)
    mod.events:on("save.created", function() syncSavedOptions() end)

    if not love.graphics._hdNewImageHooked then
        love.graphics._hdNewImageHooked = true
        
        local orig_newImageData = love.image.newImageData
        love.image.newImageData = function(filename, ...)
            local id = orig_newImageData(filename, ...)
            if type(filename) == "string" and hd_paths[filename] then
                hd_paths_data[id] = true
            end
            return id
        end

        local orig_newImage = love.graphics.newImage
        love.graphics.newImage = function(data, ...)
            local img = orig_newImage(data, ...)
            if type(data) == "string" and hd_paths[data] then
                hd_registry[img] = true
            elseif type(data) == "userdata" and data.typeOf and data:typeOf("ImageData") and hd_paths_data[data] then
                hd_registry[img] = true
            end
            return img
        end
        
        local orig_draw = love.graphics.draw
        love.graphics.draw = function(drawable, ...)
            if hd_registry[drawable] then
                local w = drawable:getWidth()
                local c_scale, c_x, c_y = 1.0, 0, 0
                
               if w == 56 then
				c_scale = SCALE_56
				c_x = OFFSET_X_56
				c_y = OFFSET_Y_56

			elseif w == 40 then
				c_scale = SCALE_40
				c_x = OFFSET_X_40
				c_y = OFFSET_Y_40

			elseif w == 64 then
				c_scale = SCALE_64
				c_x = OFFSET_X_64
				c_y = OFFSET_Y_64

			elseif w == 48 then
				c_scale = SCALE_48
				c_x = OFFSET_X_48
				c_y = OFFSET_Y_48
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