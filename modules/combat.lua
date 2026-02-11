-- COMBAT MODULE (Matrix Hub - Final Stable)
local combat = {}

function combat.attack(targetNpc)
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    
    if hrp and humanoid and targetNpc and targetNpc:FindFirstChild("HumanoidRootPart") then
        -- Kényszerített állapot a repüléshez/helyben maradáshoz
        humanoid:ChangeState(11)
        
        -- NPC-re nézés
        hrp.CFrame = CFrame.lookAt(hrp.Position, targetNpc.HumanoidRootPart.Position)
        hrp.Velocity = Vector3.new(0,0,0)

        -- Ütés
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
            -- Biztonságos távoli hívás
            local net = _G.Matrix_Modules.net
            if net and net.Remotes and net.Remotes.Attack then
                net.Remotes.Attack:FireServer(0)
            end
        end
    end
end

return combat
