-- MAIN.LUA (Baganito5 Edition - Total Fix)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local modules = _G.Matrix_Modules

_G.AutoFarm = false

-- Segédfüggvény az NPC kereséshez
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

-- A Farm ciklus, ami a teleportért és ütésért felel
local function startFarm()
    task.spawn(function()
        while _G.AutoFarm do
            local npc = getClosestNPC()
            if npc then
                local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
                local distance = (hrp.Position - npc.HumanoidRootPart.Position).Magnitude
                
                if distance > 12 then
                    -- TELEPORT: Ha messze van, odamegyünk
                    if modules.tween and modules.tween.To then
                        modules.tween.To(npc.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0), 300)
                    end
                else
                    -- ÜTÉS: Ha közel vagyunk, megállunk és támadunk
                    if modules.tween and modules.tween.Stop then modules.tween.Stop() end
                    if modules.combat and modules.combat.attack then
                        modules.combat.attack(npc)
                    end
                end
            end
            task.wait(0.1) -- CPU és RAM kímélés
        end
    end)
end

-- UI Létrehozása
local Window = Rayfield:CreateWindow({
   Name = "MATRIX HUB | STABLE",
   Theme = "Bloom",
   ConfigurationSaving = { Enabled = false }
})

local FarmTab = Window:CreateTab("Auto Farm", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

FarmTab:CreateToggle({
   Name = "Auto Farm",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then 
          startFarm() 
      else 
          if modules.tween and modules.tween.Stop then modules.tween.Stop() end 
      end
   end,
})

SettingsTab:CreateButton({
   Name = "Unload Script",
   Callback = function()
      _G.AutoFarm = false
      if modules.tween and modules.tween.Stop then modules.tween.Stop() end
      Rayfield:Destroy() -- RAM felszabadítása
      _G.Matrix_Modules = nil
   end,
})
