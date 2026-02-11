-- MAIN.LUA (Matrix Hub - Pro Fast Attack Edition)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local modules = _G.Matrix_Modules

local Window = Rayfield:CreateWindow({
   Name = "MATRIX",
   LoadingTitle = "Matrix Hub Loading...",
   LoadingSubtitle = "by WalterBlack",
   ConfigurationSaving = { Enabled = false }
})

local FarmTab = Window:CreateTab("Auto Farm")
local SpyTab = Window:CreateTab("Debug Spy")

_G.AutoFarm = false

-- PRO LOGIC: Belső keretrendszer elérése (debug upvalues)
local function getCombatController()
    local success, result = pcall(function()
        local framework = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework)
        local controller = debug.getupvalues(framework)[2]
        return controller.activeController
    end)
    return success and result or nil
end

-- Tényleges sebzés regisztráció
local function executeFastAttack()
    local controller = getCombatController()
    if controller then
        controller:attack() -- Animáció és belső logika
        game:GetService("ReplicatedStorage").Modules.Net["RE/RegisterAttack"]:FireServer(0.125) -- Sebzés
    end
end

local function getClosestNPC()
    local target, dist = nil, math.huge
    local enemies = workspace:FindFirstChild("Enemies")
    if enemies then
        for _, enemy in pairs(enemies:GetChildren()) do
            if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                local d = (enemy.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then dist = d; target = enemy end
            end
        end
    end
    return target
end

local
