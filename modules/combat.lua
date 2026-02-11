-- COMBAT MODULE (Final Attack Speed)
local combat = {}

function combat.attack(targetNpc, weaponType)
    local char = game.Players.LocalPlayer.Character
    if not char or not targetNpc then return end
    
    -- Auto-Equip (Backpack-ből elővétel)
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool or (tool and tool.ToolTip ~= weaponType) then
        local bpTool = game.Players.LocalPlayer.Backpack:FindFirstChild(weaponType) or game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
        if bpTool then char.Humanoid:EquipTool(bpTool) end
    end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp and targetNpc:FindFirstChild("HumanoidRootPart") then
        -- NPC-re nézés
        hrp.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(targetNpc.HumanoidRootPart.Position.X, hrp.Position.Y, targetNpc.HumanoidRootPart.Position.Z))
        
        -- Gyors egymásutáni ütések (Spam)
        if tool then
            tool:Activate()
        end
    end
end

return combat
