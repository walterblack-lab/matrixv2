-- MAIN.LUA (Matrix Hub - Final Asset-Locked Edition)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local modules = _G.Matrix_Modules

local Window = Rayfield:CreateWindow({
   Name = "MATRIX HUB | PRO",
   LoadingTitle = "Matrix Hub Loading...",
   LoadingSubtitle = "by WalterBlack",
   ConfigurationSaving = { Enabled = false }
})

local FarmTab = Window:CreateTab("Auto Farm")
local SpyTab = Window:CreateTab("Debug Spy")
local SettingsTab = Window:CreateTab("Settings")

-- Spy összekötése
local logLabel = SpyTab:CreateLabel("Status: Ready")
if modules and modules.spy then
    modules.spy.init(logLabel)
    modules.spy.log("Systems Online")
end

_G.AutoFarm = false
local currentTarget = nil

-- Célpont kereső függvény
local function getClosestNPC()
    if currentTarget and currentTarget:FindFirstChild("Humanoid") and currentTarget.Humanoid.Health > 0 then
        return currentTarget
    end
    local target, dist = nil, math.huge
    local enemiesFolder = workspace:FindFirstChild("Enemies")
    if enemiesFolder then
        for _, enemy in pairs(enemiesFolder:GetChildren()) do
            if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                local d = (enemy.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then dist = d; target = enemy end
            end
