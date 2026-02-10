-- MATRIX HUB V6.3 OFFICIAL LOADER
-- User: walterblack-lab | Repository: matrixv2
-- Description: Corrected pathing for raw github content

local base = "https://raw.githubusercontent.com/walterblack-lab/matrixv2/main/"

local function GetFile(path)
    local url = base .. path
    local success, content = pcall(function()
        return game:HttpGet(url)
    end)
    if success and not content:find("404") then
        return content
    end
    return nil
end

-- Loading sequence
local netCode = GetFile("modules/net.lua")
local tweenCode = GetFile("modules/tween.lua")
local mainCode = GetFile("main.lua")

if netCode and tweenCode and mainCode then
    -- Module Initialization
    _G.Matrix_Modules = {
        Net = loadstring(netCode)(),
        Tween = loadstring(tweenCode)()
    }
    -- Execute Main UI
    loadstring(mainCode)()
    print("Matrix Hub: Connection established. UI Loading...")
else
    warn("Matrix Hub: Critical Error! Files not found on GitHub.")
    print("Checked path: " .. base)
    print("Please ensure your folder on GitHub is named 'modules' (lowercase).")
end
