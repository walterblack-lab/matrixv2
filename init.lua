-- MAIN.LUA (UNLOAD FUNKCIÓVAL)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local modules = _G.Matrix_Modules

_G.AutoFarm = false

local Window = Rayfield:CreateWindow({
   Name = "MATRIX HUB | BLOX FRUITS",
   Theme = "Bloom", 
   ConfigurationSaving = { Enabled = false }
})

local FarmTab = Window:CreateTab("Auto Farm", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458) -- Új fül a beállításoknak

-- A farm ciklus (a korábbi stabil verzió)
local function startFarm()
    task.spawn(function()
        while _G.AutoFarm do
            local npc = getClosestNPC() -- (Feltételezzük, hogy a függvény itt van)
            if npc then
                local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
                if (hrp.Position - npc.HumanoidRootPart.Position).Magnitude > 12 then
                    modules.tween.To(npc.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0), 300)
                else
                    modules.tween.Stop()
                    modules.combat.attack(npc)
                end
            end
            task.wait(0.1)
        end
    end)
end

-- UNLOAD FUNKCIÓ
local function UnloadScript()
    _G.AutoFarm = false -- Farm leállítása
    if modules.tween then modules.tween.Stop() end -- Tween takarítása
    
    Rayfield:Destroy() -- GUI törlése
    _G.Matrix_Modules = nil -- Modulok referenciáinak törlése a RAM-ból
    
    print("[MATRIX] Script sikeresen unloadolva. RAM felszabadítva.")
end

SettingsTab:CreateButton({
   Name = "Unload Script",
   Callback = function()
      UnloadScript()
   end,
})

FarmTab:CreateToggle({
   Name = "Auto Farm",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then startFarm() else modules.tween.Stop() end
   end,
})
