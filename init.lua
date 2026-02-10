-- MATRIX HUB V7.0 - CACHE BUSTER & QUEST UPDATE
local username = "walterblack-lab"
local repo = "matrixv2"
local base = "https://raw.githubusercontent.com/"..username.."/"..repo.."/main/"

-- DMGDEBUG szűrő (hogy ne lásd a spammelést)
game:GetService("LogService").MessageOut:Connect(function(msg)
    if msg:find("DMGDEBUG") then return end
end)

local function Load(path)
    -- A véletlen szám a végén kényszeríti a frissítést
    local url = base .. path .. "?nocache=" .. math.random(1, 10000)
    local success, content = pcall(function() return game:HttpGet(url) end)
    
    if success and not content:find("404") then
        local func, err = loadstring(content)
        if func then return func() else warn("Hiba: " .. err) end
    end
    warn("Matrix Error: Meg mindig nem erem el -> " .. path)
    return nil
end

_G.Matrix_Modules = {
    Net = Load("modules/net.lua"),
    Tween = Load("modules/tween.lua")
}

if _G.Matrix_Modules.Net and _G.Matrix_Modules.Tween then
    Load("main.lua")
    print("Matrix Hub V7: Sikeres betoltes frissitve!")
end
