-- COMBAT MODULE (Spy Integrated)
local combat = {}
local spy = _G.Matrix_Modules.spy -- Spy modul elérése [cite: 2026-02-10]

function combat.attack(targetNpc, weaponType)
    local lp = game.Players.LocalPlayer
    local char = lp.Character
    if not char or not targetNpc then return end
    
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool or (tool and tool.ToolTip ~= weaponType) then
        spy.log("Equipping: " .. weaponType)
        local bpTool = lp.Backpack:FindFirstChild(weaponType) or lp.Backpack:FindFirstChildOfClass("Tool")
        if bpTool then char.Humanoid:EquipTool(bpTool) end
    end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp and targetNpc:FindFirstChild("HumanoidRootPart") then
        hrp.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(targetNpc.HumanoidRootPart.Position.X, hrp.Position.Y, targetNpc.HumanoidRootPart.Position.Z))
        
        -- Remote ellenőrzés logolással [cite: 2026-02-10]
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RigControllerEvent", true)
        if remote then
            spy.log("Attacking " .. targetNpc.Name .. " (Remote OK)")
            remote:FireServer("WeaponClick")
        else
            spy.log("ERROR: RigControllerEvent MISSING!")
        end
        
        if tool then tool:Activate() end
    end
end

return combat
