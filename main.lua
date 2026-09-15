local GameVersion = require("src.core.GameVersion")
local CURRENT_GAME = GameVersion.get()

return function(mod)
    local target_file = (CURRENT_GAME == "gold" or CURRENT_GAME == "silver" or CURRENT_GAME == "crystal") and "gen2.lua" or "gen1.lua"
    local chunk = mod:read(target_file)
    
    if chunk then
        local load_ok, file_func = pcall(load, chunk)
        
        if load_ok and type(file_func) == "function" then
            local init_script = file_func()
            init_script(mod)
        else
            error("ERROR: " .. target_file .. " could not be compiled. Syntax error?")
        end
    else
        error("ERROR: Could not find " .. target_file .. " in mod folder!")
    end
end