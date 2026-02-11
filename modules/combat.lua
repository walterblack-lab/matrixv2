-- COMBAT MODULE (Final Asset-Based Fix)
local combat = {}
local lp = game.Players.LocalPlayer

function combat.attack(targetNpc)
    local char = lp.Character
    if not char or not targetNpc then return end
    
    -- 1. Fegyver kezelése (A SCAN alapján: 'Combat') [cite: 2026-02-11]
    local tool = char:FindFirstChild("Combat")
    if not tool then
        local bpTool = lp.Backpack:FindFirstChild("Combat")
        if bpTool then 
            char.Humanoid:EquipTool(bpTool)
            tool = bpTool
        end
    end

    -- 2. SEBZÉS KIVÁLTÁSA (A beküldött RE/RegisterAttack útvonalon) [cite: 2026-02-11]
    if tool then
        -- Fizikai ütés animáció
        tool:Activate()
        
        -- Szerver oldali sebzés regisztráció (A te scan eredményed alapján) [cite: 2026-02-11]
        local netPath = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net")
        local registerAttack = netPath:FindFirstChild("RE/RegisterAttack")
        
        if registerAttack then
            -- Meghívjuk a szervert, hogy regisztrálja az ütést
            registerAttack:FireServer()
        end
    end
end

return combat
