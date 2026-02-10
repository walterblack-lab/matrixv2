-- MAIN.LUA (Matrix Hub - Letisztult & Profi)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local modules = _G.Matrix_Modules

_G.AutoFarm = false

local Window = Rayfield:CreateWindow({
   Name = "MATRIX HUB | BLOX FRUITS",
   Theme = "Bloom", 
   ConfigurationSaving = { Enabled = false }
})

local FarmTab = Window:CreateTab("Auto Farm", 4483362458)

-- Segédfüggvény az NPC kereséshez
local function getClosestNPC()
    local target = nil
    local dist = math.huge
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return nil end
    
    for _, v in pairs(enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            local d = (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then
                dist = d
                target = v
            end
        end
    end
    return target
end

-- Farm ciklus
local function startFarm()
    task.spawn(function()
        while _G.AutoFarm do
            local npc = getClosestNPC()
            if npc then
                local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
                local dist = (hrp.Position - npc.HumanoidRootPart.Position).Magnitude
                
                if dist > 10 then
                    -- Teleportálás a tween modullal
                    if modules.tween then 
                        modules.tween.To(npc.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0), 300) 
                    end
                else
                    -- Harc a combat modullal
                    if modules.tween then modules.tween.Stop() end
                    if modules.combat then modules.combat.attack(npc) end
                end
            end
            task.wait(0.05) -- RAM barát késleltetés
        end
    end)
end

FarmTab:CreateToggle({
   Name = "Auto Farm (Baganito5 Edition)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then startFarm() else if modules.tween then modules.tween.Stop() end end
   end,
})
