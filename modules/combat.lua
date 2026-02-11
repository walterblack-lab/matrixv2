-- COMBAT MODULE (Final Clicker)
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

    -- Pontos célzás
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp and targetNpc:FindFirstChild("HumanoidRootPart") then
        hrp.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(targetNpc.HumanoidRootPart.Position.X, hrp.Position.Y, targetNpc.HumanoidRootPart.Position.Z))
        
        -- KATTINTÁS SZIMULÁLÁSA
        -- Ez váltja ki a sebzést, amit a log "out of radius"-nak hitt
        VirtualUser:CaptureController()
        VirtualUser:Button1Down(Vector2.new(100, 100), workspace.CurrentCamera.CFrame)
        if tool then tool:Activate() end
    end
end

return combat
