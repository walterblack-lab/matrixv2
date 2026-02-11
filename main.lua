-- MAIN.LUA (Safe Execution)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local modules = _G.Matrix_Modules

-- Ellenőrizzük, hogy a modulok tényleg ott vannak-e
if not modules or not modules.combat or not modules.tween then
    warn("[MATRIX ERROR] Modulok hiányoznak a main indításakor!")
    return
end

_G.AutoFarm = false

local Window = Rayfield:CreateWindow({
   Name = "MATRIX HUB | BLOX FRUITS",
   Theme = "Bloom",
   ConfigurationSaving = { Enabled = false }
})

local FarmTab = Window:CreateTab("Auto Farm", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- NPC Kereső (ez fontos, hogy létezzen a startFarm előtt!)
local function getClosestNPC()
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return nil end
    
    local target = nil
    local dist = math.huge
    local myPos = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if not myPos then return nil end

    for _, v in pairs(enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            local d = (v.HumanoidRootPart.Position - myPos.Position).Magnitude
            if d < dist then
                dist = d
                target = v
            end
        end
    end
    return target
end

local function startFarm()
    task.spawn(function()
        while _G.AutoFarm do
            local npc = getClosestNPC()
            if npc and modules.tween and modules.combat then
                local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
                local dist = (hrp.Position - npc.HumanoidRootPart.Position).Magnitude
                
                if dist > 15 then
                    modules.tween.To(npc.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0), 300)
                else
                    modules.tween.Stop()
                    modules.combat.attack(npc)
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
      if Value then startFarm() else if modules.tween then modules.tween.Stop() end end
   end,
})

SettingsTab:CreateButton({
   Name = "Unload Script",
   Callback = function()
      _G.AutoFarm = false
      if modules.tween then modules.tween.Stop() end
      Rayfield:Destroy()
      _G.Matrix_Modules = nil
   end,
})
