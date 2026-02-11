-- COMBAT MODULE (Matrix Hub - Full Stable)
local combat = {}

function combat.attack(targetNpc)
    local char = game.Players.LocalPlayer.Character
    if not char or not targetNpc then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local tool = char:FindFirstChildOfClass("Tool")
    
    if hrp and targetNpc:FindFirstChild("HumanoidRootPart") then
        -- Kényszerített NPC-re nézés (Y tengely rögzítésével, hogy ne dőljön el a karakter)
        local targetPos = targetNpc.HumanoidRootPart.Position
        hrp.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z))
        
        -- Csak akkor ütünk, ha van a kezünkben valami (kard/ököl)
        if tool then
            tool:Activate()
        end
    end
end

return combat
