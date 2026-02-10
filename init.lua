-- MATRIX HUB V6.5
-- Repo: walterblack-lab/matrixv2

local raw = "https://raw.githubusercontent.com/walterblack-lab/matrixv2/main/"

-- Biztonságos betöltés: ha nincs meg a fájl, szól a konzol
local function Load(file)
    local success, content = pcall(function() return game:HttpGet(raw .. file) end)
    if success and not content:find("404") then
        return loadstring(content)()
    end
    warn("Matrix Error: Nem talalhato a fajl -> " .. file)
    return nil
end

-- Előbb a motorokat töltjük be
_G.Matrix_Modules = {
    Net = Load("modules/net.lua"),
    Tween = Load("modules/tween.lua")
}

-- Ha a motorok készen állnak, jöhet a menü
if _G.Matrix_Modules.Net and _G.Matrix_Modules.Tween then
    Load("main.lua")
end
