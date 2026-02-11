-- MAIN.LUA (Matrix Hub - Ultra Stable Edition)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local modules = _G.Matrix_Modules

-- Ablak létrehozása (Notifications nélkül a stabilitásért)
local Window = Rayfield:CreateWindow({
   Name = "MATRIX HUB | PRO",
   LoadingTitle = "Matrix Hub Loading...",
   LoadingSubtitle = "by WalterBlack",
   ConfigurationSaving = { Enabled = false }
})

local FarmTab = Window:CreateTab("Auto Farm")
local SpyTab = Window:CreateTab("Debug Spy")
local SettingsTab = Window:CreateTab("Settings")

-- SPY INICIALIZÁLÁSA (Nagyon fontos a sorrend!)
local logLabel = SpyTab:CreateLabel("Status: Ready")
if modules and modules.spy then
    modules.spy.init(logLabel)
    modules.spy.log("Spy connected to UI")
end

_G.AutoFarm = false
_G.SelectedWeapon = "Melee"

-- FUNKCIÓK (Ide rakjuk a logikát, hogy ne zavarja a UI-t)
local function startFarm()
    task.spawn(function()
        while _G.AutoFarm do
            -- Itt hívjuk meg a modulokat
            pcall(function()
                local npc = workspace:FindFirstChild("Enemies") -- Egyszerűsített keresés teszthez
                if npc then
                    modules.spy.log("Target found: " .. npc.Name)
                end
            end)
            task.wait(1)
        end
    end)
end

-- UI ELEMEK LÉTREHOZÁSA
FarmTab:CreateDropdown({
   Name = "Weapon Type",
   Options = {"Melee", "Sword", "Blox Fruit"},
   CurrentOption = {"Melee"},
   Callback = function(Option) _G.SelectedWeapon = Option[1] end,
})

FarmTab:CreateToggle({
   Name = "Start Auto Farm",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then startFarm() end
      if modules.spy then modules.spy.log("Farm Toggle: " .. tostring(Value)) end
   end,
})

SettingsTab:CreateButton({
   Name = "Unload Script",
   Callback = function()
      _G.AutoFarm = false
      Rayfield:Destroy()
      _G.Matrix_Modules = nil
   end,
})
