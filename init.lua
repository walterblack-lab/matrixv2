-- INIT.LUA (walterblack-lab)
_G.Matrix_Modules = {}

local function loadModule(name)
    -- Figyelünk a kisbetűs 'modules' mappára!
    local url = "https://raw.githubusercontent.com/walterblack-lab/matrixv2/main/modules/" .. name .. ".lua"
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    
    if success then
        _G.Matrix_Modules[name] = result
        print("Modul betöltve: " .. name)
    else
        warn("Hiba a modul betöltésekor (" .. name .. "): " .. result)
    end
end

-- Modulok betöltése
loadModule("tween")
loadModule("net")

-- Végül a fő kód indítása
loadstring(game:HttpGet("https://raw.githubusercontent.com/walterblack-lab/matrixv2/main/main.lua"))()
