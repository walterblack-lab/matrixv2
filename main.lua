local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Modules = _G.Matrix_Modules

_G.AutoFarm = false

local Window = Rayfield:CreateWindow({
   Name = "MATRIX HUB | BLOX FRUITS",
   Theme = "DarkBlue",
   ConfigurationSaving = { Enabled = false }
})

local FarmTab = Window:CreateTab("Auto Farm", 4483362458)

-- Segédfüggvény a fegyver elővételéhez
local function equipWeapon()
    local p = game.Players.LocalPlayer
    local backpack = p.Backpack
    local char = p.Character
    -- Megkeressük az első fegyvert (Combat vagy Sword)
    for _, tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            char.Humanoid:EquipTool(tool)
            break
        end
    end
end

FarmTab:CreateToggle({
   Name = "Auto Farm (Starter Island)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then
         task.spawn(function()
            while _G.AutoFarm do
               pcall(function()
                  local target = nil
                  local dist = math.huge
                  for _, v in pairs(workspace.Enemies:GetChildren()) do
                     if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                        local d = (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if d < dist then dist = d; target = v end
                     end
                  end

                  if target then
                     equipWeapon() -- Fegyver kézbe vétele
                     -- ÚJ POZÍCIÓ: Az NPC elé repülünk 2 méterrel, nem a feje fölé
                     Modules.Tween.To(target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2.5), 300)
                     Modules.Net.Remotes.Attack:FireServer()
                  end
               end)
               task.wait(0.1)
            end
         end)
      end
   end,
})

-- System Tab az Unload gombbal
local SystemTab = Window:CreateTab("System", 4483362458)
SystemTab:CreateButton({
   Name = "Destroy Script (Unload)",
   Callback = function()
      _G.AutoFarm = false
      task.wait(0.2)
      Rayfield:Destroy()
   end,
})
