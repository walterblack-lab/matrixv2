-- COMBAT MODULE (Pro Client-Side Clicker)
local combat = {}
local VirtualUser = game:GetService("VirtualUser") -- Ez szimulálja a fizikai egérkattintást

function combat.attack(targetNpc, weaponType)
    local char = game.Players.LocalPlayer.Character
    if not char or not targetNpc or not targetNpc:FindFirstChild("HumanoidRootPart") then return end
    
    local tool = char:FindFirstChildOfClass("Tool")
    -- Auto-Equip (Hogy neked ne kelljen elővenni)
    if not tool or (tool and tool.ToolTip ~= weaponType) then
        local bpTool = game.Players.LocalPlayer.Backpack:FindFirstChild(weaponType) or game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
        if bpTool then char.Humanoid:EquipTool(bpTool) end
    end

    -- NPC-re nézés (LookAt) - Fontos, hogy a karakter arccal az NPC felé álljon
    local hrp = char.HumanoidRootPart
    hrp.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(targetNpc.HumanoidRootPart.Position.X, hrp.Position.Y, targetNpc.HumanoidRootPart.Position.Z))

    -- EGÉRKATTINTÁS SZIMULÁLÁSA
    -- Ez pontosan azt csinálja, amit te az ujjaddal az egéren
    if tool then
        -- Meghívjuk a VirtualUser-t, ami "lenyomja" a bal egérgombot a játékablakban
        VirtualUser:Button1Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        tool:Activate() -- Elindítja az animációt is
    end
end

return combat
