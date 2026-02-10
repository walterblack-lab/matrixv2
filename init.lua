-- INIT.LUA (walterblack-lab / matrixv2)
_G.Matrix_Modules = {}

local function loadModule(name)
    local url = "https://raw.githubusercontent.com/walterblack-lab/matrixv2/main/modules/" .. name .. ".lua?cache=" .. math.random(1, 9999)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    
    if success then
        _G.Matrix_Modules[name] = result
        print("[MATRIX] Modul betöltve: " .. name)
    else
        warn("[MATRIX] Hiba a modul betöltésekor (" .. name .. "): " .. tostring(result))
    end
end

-- Modulok behúzása (figyelj a kisbetűkre!)
loadModule("tween")
loadModule("net")

-- Ha minden kész, indulhat a fő szkript
task.wait(0.5)
loadstring(game:HttpGet("https://raw.githubusercontent.com/walterblack-lab/matrixv2/main/main.lua?cache=" .. math.random(1, 9999)))()
