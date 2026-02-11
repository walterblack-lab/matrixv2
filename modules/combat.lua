-- COMBAT MODULE (Matrix Hub - Blox Fruits)
local combat = {}

function combat.attack(targetNpc)
    local char = game.Players.LocalPlayer.Character
    if not char or not targetNpc then return end
    
    -- NPC-re nézés kényszerítése (hogy a sebzés regisztráljon)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp and targetNpc:FindFirstChild("HumanoidRootPart") then
        hrp.CFrame = CFrame.lookAt(hrp.Position, targetNpc.HumanoidRootPart.Position)
    end

    -- Fizikai ütés és eszköz használata
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        tool:Activate() -- Aktiválja a kardot/ökölt
    end
end

return combat
