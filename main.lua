-- MAIN.LUA (Matrix Hub - Asset Final)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local modules = _G.Matrix_Modules

local Window = Rayfield:CreateWindow({ Name = "MATRIX HUB | PRO", Theme = "Bloom" })
local FarmTab = Window:CreateTab("Auto Farm")
local SpyTab = Window:CreateTab("Debug Spy")
local SettingsTab = Window:CreateTab("Settings")

local logLabel = SpyTab:CreateLabel("Status: Ready")
if modules.spy then modules.spy.init(logLabel) end

_G.AutoFarm = false

local function getClosestNPC()
    local target, dist = nil, math.huge
    local enemiesFolder = workspace:FindFirstChild("Enemies")
    if enemiesFolder then
        for _, enemy in pairs(enemiesFolder:GetChildren()) do
            if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                local d = (enemy.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then dist = d; target = enemy end
            end
        end
    end
    return target
end

local function startFarm()
    task.spawn(function()
        while _G.AutoFarm do
            local npc = getClosestNPC()
            if npc then
                local myHrp = game.Players.LocalPlayer.Character.HumanoidRootPart
                local targetHrp = npc.HumanoidRootPart
                local distance = (myHrp.Position - targetHrp.Position).Magnitude
                
                -- Célzás
                myHrp.CFrame = CFrame.lookAt(myHrp.Position, Vector3.new(targetHrp.Position.X, myHrp.Position.Y, targetHrp.Position.Z))

                if distance > 3.5 then
                    modules.tween.To(targetHrp.CFrame * CFrame.new(0, 0, 2.8), 300)
                else
                    modules.tween.Stop()
                    -- ÜTÉS (Most már a javított combat.lua-val) [cite: 2026-02-11]
                    modules.combat.attack(npc)
                end
            end
            task.wait(0.01)
        end
    end)
end

FarmTab:CreateToggle({
   Name = "Start Auto Farm (Combat Style)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then startFarm() else modules.tween.Stop() end
   end,
})

SettingsTab:CreateButton({
   Name = "Unload Script",
   Callback = function()
      _G.AutoFarm = false
      modules.tween.Stop()
      Rayfield:Destroy()
      _G.Matrix_Modules = nil
   end,
})
