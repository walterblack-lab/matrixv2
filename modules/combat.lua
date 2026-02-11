-- COMBAT MODULE (Force Click Edition)
local combat = {}
local VirtualUser = game:GetService("VirtualUser")

function combat.attack(targetNpc, weaponType)
    local lp = game.Players.LocalPlayer
    local char = lp.Character
    if not char or not targetNpc then return end
    
    -- Auto-Equip
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool or (tool and tool.ToolTip ~= weaponType) then
        local bpTool = lp.Backpack:FindFirstChild(weaponType) or lp.Backpack:FindFirstChildOfClass("Tool")
        if bpTool then char.Humanoid:EquipTool(bpTool) end
    end

    -- NPC-re nézés (Y tengely fixálva, hogy ne boruljon fel)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp and targetNpc:FindFirstChild("HumanoidRootPart") then
        local targetPos = targetNpc.HumanoidRootPart.Position
        hrp.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z))
        
        -- KATTINTÁS SZIMULÁLÁSA (Ugyanaz, amit te csinálsz kézzel)
        VirtualUser:CaptureController()
        VirtualUser:ClickButton1(Vector2.new(850, 500)) -- A képernyő közepére kattint
        
        if tool then 
            tool:Activate() 
        end
    end
end

return combat
