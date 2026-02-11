-- MAIN.LUA (Matrix Hub - Precise & Stable Auto-Farm)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local modules = _G.Matrix_Modules

-- Ablak létrehozása
local Window = Rayfield:CreateWindow({
   Name = "MATRIX HUB | PRO",
   LoadingTitle = "Matrix Hub Loading...",
   LoadingSubtitle = "by WalterBlack",
   ConfigurationSaving = { Enabled = false }
})

local FarmTab = Window:CreateTab("Auto Farm")
local SpyTab = Window:CreateTab("Debug Spy")
local SettingsTab = Window:CreateTab("Settings")

-- Spy modul összekötése a UI-val
local logLabel = SpyTab:CreateLabel("Status: Ready")
if modules and modules.spy then
    modules.spy.init(logLabel)
    modules.spy.log("Spy connected to UI")
end

_G.AutoFarm = false
_G.SelectedWeapon = "Melee"
local currentTarget = nil

-- Célpont keresése (NPC szűréssel)
local function getClosestNPC()
    if currentTarget and currentTarget:FindFirstChild("Humanoid") and currentTarget.Humanoid.Health > 0 then
        return currentTarget
    end

    local target, dist = nil, math.huge
    local enemiesFolder = workspace:FindFirstChild("Enemies")
    
    if enemiesFolder then
        for _, enemy in pairs(enemiesFolder:GetChildren()) do
            local humanoid = enemy:FindFirstChild("Humanoid")
            local hrp = enemy:FindFirstChild("HumanoidRootPart")
            
            if humanoid and hrp and humanoid.Health > 0 then
                local d = (hrp.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then
                    dist = d
                    target = enemy
                end
            end
        end
    end
    
    currentTarget = target
    return target
end

-- Farm Logika
local function startFarm()
    task.spawn(function()
        while _G.AutoFarm do
            local npc = getClosestNPC()
            
            if npc and npc:FindFirstChild("HumanoidRootPart") then
                local myHrp = game.Players.LocalPlayer.Character.HumanoidRootPart
                local targetHrp = npc.HumanoidRootPart
                local distance = (myHrp.Position - targetHrp.Position).Magnitude
                
                if distance > 3.5 then
                    -- Mozgás az NPC-hez (Tween)
                    if modules.spy then modules.spy.log("Teleporting to: " .. npc.Name) end
                    modules.tween.To(targetHrp.CFrame * CFrame.new(0, 0, 1.5), 300)
                else
                    -- Ütés fázis
                    if modules.spy then modules.spy.log("Target reached! Attacking...") end
                    modules.tween.Stop()
                    modules.combat.attack(npc, _G.SelectedWeapon)
                    task.wait(0.05) -- Gyors ütési tempó
                end
            else
                if modules.spy then modules.spy.log("Waiting for NPC...") end
                currentTarget = nil
            end
            task.wait(0.1)
        end
    end)
end

-- UI Elemeinek létrehozása
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
      _G.AutoFarm
