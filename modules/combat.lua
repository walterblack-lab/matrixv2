-- COMBAT MODULE (Matrix Hub)
local combat = {}

function combat.attack(targetNpc)
    local char = game.Players.LocalPlayer.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    
    if hrp and humanoid and targetNpc:FindFirstChild("HumanoidRootPart") then
        humanoid:ChangeState(11)
        hrp.CFrame = CFrame.lookAt(hrp.Position, targetNpc.HumanoidRootPart.Position)
        hrp.Velocity = Vector3.new(0,0,0)

        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
            local net = _G.Matrix_Modules.net
            if net and net.Remotes and net.Remotes.Attack then
                net.Remotes.Attack:FireServer(0)
            end
        end
    end
end

return combat
