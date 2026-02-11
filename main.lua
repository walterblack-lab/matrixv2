-- MAIN.LUA (Fixing the "Nil" issue)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local modules = _G.Matrix_Modules

-- Ellenőrzés: Kiírjuk a konzolba, mit lát a script
print("[MATRIX] Modulok állapota:")
for i, v in pairs(modules) do print(" - Modul betöltve: " .. i) end

_G.AutoFarm = false

local Window = Rayfield:CreateWindow({
   Name = "MATRIX HUB | BLOX FRUITS",
   Theme = "Bloom",
   ConfigurationSaving = { Enabled = false }
})

local FarmTab = Window:CreateTab("Auto Farm", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- NPC Kereső
local function getClosestNPC()
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return nil end
    local target, dist = nil, math.huge
    local char = game.Players.LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    
    for _, v in pairs(enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            local d = (v.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
            if d < dist then dist = d; target = v end
        end
    end
    return target
end

local function startFarm()
    task.spawn(function()
        while _G.AutoFarm do
            local npc = getClosestNPC()
            if npc then
                -- BIZTONSÁGI ELLENŐRZÉS: Csak akkor hívjuk, ha létezik a függvény
                if modules.tween and modules.tween.To then
                    modules.tween.To(npc.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0), 300)
                else
                    warn("[MATRIX] A Tween modul vagy a .To függvény hiányzik!")
                end
                
                -- Itt jönne az ütés, ha a teleport már kész
                if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - npc.HumanoidRootPart.Position).Magnitude < 15 then
                    if modules.combat and modules.combat.attack then
                        modules.combat.attack(npc)
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end

FarmTab:CreateToggle({
   Name = "Auto Farm",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then startFarm() else if modules.tween and modules.tween.Stop then modules.tween.Stop() end end
   end,
})
