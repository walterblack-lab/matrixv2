-- MAIN.LUA (Modular Spy Edition)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local modules = _G.Matrix_Modules

-- Spy inicializálása [cite: 2026-02-10]
local Window = Rayfield:CreateWindow({ Name = "MATRIX HUB | PRO", Theme = "Bloom" })
local FarmTab = Window:CreateTab("Auto Farm")
local SpyTab = Window:CreateTab("Debug Spy")
local SettingsTab = Window:CreateTab("Settings")

-- Spy modul összekötése a UI-val
local logLabel = SpyTab:CreateLabel("Status: Initializing...")
if modules.spy then
    modules.spy.init(logLabel)
end

_G.AutoFarm = false
_G.SelectedWeapon = "Melee"
local currentTarget = nil

-- Unload gomb (Mindig itt lesz!) [cite: 2026-02-09, 2026-02-10]
SettingsTab:CreateButton({
   Name = "Unload Script",
   Callback = function()
      _G.AutoFarm = false
      if modules.tween then modules.tween.Stop() end
      Rayfield:Destroy()
      _G.Matrix_Modules = nil
   end,
})

-- Farm logika a Spy-al kiegészítve [cite: 2026-02-10]
local function getClosestNPC()
    if currentTarget and currentTarget:FindFirstChild("Humanoid") and currentTarget.Humanoid.Health > 0 then
        return currentTarget
    end
    modules.spy.log("Searching for target...")
    local target, dist = nil, math.huge
    local enemies = workspace:FindFirstChild("Enemies") or workspace
    for _, v in pairs(enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            local d = (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then dist = d; target = v end
        end
    end
    currentTarget = target
    return target
end

local function startFarm()
    task.spawn(function()
        while _G.AutoFarm do
            local npc = getClosestNPC()
            if npc then
                local dist = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - npc.HumanoidRootPart.Position).Magnitude
                if dist > 4 then
                    modules.spy.log("Moving to " .. npc.Name .. " (" .. math.floor(dist) .. "m)")
                    modules.tween.To(npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3), 300)
                else
                    modules.tween.Stop()
                    modules.combat.attack(npc, _G.SelectedWeapon)
                end
            end
            task.wait(0.05)
        end
    end)
end

-- UI elemek (Dropdown, Toggle) maradnak...
-- (Itt a korábbi dropdown és toggle kódja jön)
