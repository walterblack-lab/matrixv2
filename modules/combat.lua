-- COMBAT MODULE (Pro Framework Attack)
local combat = {}
local lp = game.Players.LocalPlayer

-- Elérjük a játék belső harci rendszerét
local CombatFramework = require(lp.PlayerScripts.CombatFramework)
local CombatFrameworkLib = debug.getupvalues(CombatFramework)[2]

function combat.attack(targetNpc, weaponType)
    local char = lp.Character
    if not char or not targetNpc then return end
    
    -- Tool kézbevétele [cite: 2026-02-10]
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool or (tool and tool.ToolTip ~= weaponType) then
        local bpTool = lp.Backpack:FindFirstChild(weaponType) or lp.Backpack:FindFirstChildOfClass("Tool")
        if bpTool then char.Humanoid:EquipTool(bpTool) end
    end

    -- AZ ÜTÉS LÉNYEGE:
    -- A játék belső függvényét hívjuk meg, ami a sebzésért felelős
    -- Ez kikerüli a kattintás-szűrést
    pcall(function()
        CombatFrameworkLib.activeController:attack()
    end)
    
    -- Ha a fenti nem futna le, a Remote-ot is toljuk neki
    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RigControllerEvent", true)
    if remote then
        remote:FireServer("WeaponClick")
    end
end

return combat
