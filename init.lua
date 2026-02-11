-- INIT.LUA (Matrix Hub - Loader)
_G.Matrix_Modules = {}

local baseUrl = "https://raw.githubusercontent.com/walterblack-lab/matrixv2/main/modules/"
local moduleFiles = {
    tween = "tween.lua",
    combat = "combat.lua",
    spy = "spy.lua" -- ÚJ: Most már ezt is betöltjük!
}

local function loadModule(name, fileName)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(baseUrl .. fileName))()
    end)
    
    if success then
        _G.Matrix_Modules[name] = result
        warn("[MATRIX] Module loaded: " .. name)
    else
        warn("[MATRIX] Failed to load module: " .. name .. " | Error: " .. result)
    end
end

-- Összes modul betöltése
for name, file in pairs(moduleFiles) do
    loadModule(name, file)
end

-- Fő script indítása
warn("[MATRIX] Every module ready. Starting Main...")
loadstring(game:HttpGet("https://raw.githubusercontent.com/walterblack-lab/matrixv2/main/main.lua"))()
