local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Modules = _G.Matrix_Modules
_G.AutoFarm = false

local Window = Rayfield:CreateWindow({
   Name = "MATRIX HUB | BLOX FRUITS",
   Theme = "DarkBlue",
   ConfigurationSaving = { Enabled = false }
})

local FarmTab = Window:CreateTab("Auto Farm", 4483362458)

-- AGRESSZÍV FEGYVER ELŐVÉTEL
local function forceEquip()
    local p = game.Players.LocalPlayer
    local char = p.Character
    if not char or char:FindFirstChildOfClass("Tool") then return end
    
    -- Megkeressük az öklöt (Combat)
    local tool = p.Backpack:FindFirstChild("Combat") or p.Backpack:FindFirstChildOfClass("Tool")
    if tool then
        char.Humanoid:EquipTool(tool)
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
                  local lp = game.Players.LocalPlayer
                  
                  -- NPC Keresés
                  for _, v in pairs(workspace.Enemies:GetChildren()) do
                     if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        local d = (v.HumanoidRootPart.Position - lp.Character.HumanoidRootPart.Position).Magnitude
                        if d < dist then dist = d; target = v end
                     end
                  end

                  if target then
                     forceEquip() -- Fegyver kényszerítése
                     
                     local farmPos = target.HumanoidRootPart.CFrame * CFrame.new(0, 5.5, 0) -- 5.5 méterrel fölé
                     
                     -- CSAK AKKOR MOZDULUNK, HA MESSZE VAN (Megszünteti a rángatást)
                     if (lp.Character.HumanoidRootPart.Position - farmPos.p).Magnitude > 4 then
                        Modules.Tween.To(farmPos, 300)
                        task.wait(0.2)
                     else
                        -- Ha ott vagyunk, megállunk és ÜTÜNK
                        Modules.Tween.Stop()
                        lp.Character.HumanoidRootPart.CFrame = farmPos
                        Modules.Net.Remotes.Attack:FireServer()
                     end
                  end
               end)
               task.wait(0.05) -- Gyors ütési sebesség
            end
         end)
      end
   end,
})

-- System Tab
local SystemTab = Window:CreateTab("System", 4483362458)
SystemTab:CreateButton({
   Name = "Destroy Script (Unload)",
   Callback = function()
      _G.AutoFarm = false
      task.wait(0.2)
      Rayfield:Destroy()
   end,
})
