-- COMBAT MODULE (Blox Fruits Asset Focused)
local combat = {}
local lp = game.Players.LocalPlayer

function combat.attack(targetNpc)
    local char = lp.Character
    if not char or not targetNpc then return end
    
    -- 1. Fegyver kényszerítése (A SCAN alapján: 'Combat') [cite: 2026-02-11]
    local tool = char:FindFirstChild("Combat")
    if not tool then
        local bpTool = lp.Backpack:FindFirstChild("Combat")
        if bpTool then 
            char.Humanoid:EquipTool(bpTool)
            tool = bpTool
        end
    end

    -- 2. SEBZÉS REGISZTRÁLÁSA (A SCAN alapján a pontos Path) [cite: 2026-02-11]
    if tool then
        tool:Activate()
        -- Speciális elérés a perjel miatt
        local netModule = game:GetService("ReplicatedStorage").Modules.Net
        local registerAttack = netModule:FindFirstChild("RE/RegisterAttack")
        
        if registerAttack then
            -- A Blox Fruits szerver ezt az eseményt várja az ütés elfogadásához
            registerAttack:FireServer()
        end
    end
end

return combat
