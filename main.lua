local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Net = _G.Matrix_Modules.Net
local Tween = _G.Matrix_Modules.Tween

_G.AutoFarm = false

local Window = Rayfield:CreateWindow({
   Name = "MATRIX HUB | BLOX FRUITS",
   LoadingTitle = "Loading matrixv2 modules...",
   Theme = "DarkBlue",
   ConfigurationSaving = { Enabled = false }
})

local FarmTab = Window:CreateTab("Auto Farm", 4483362458)

FarmTab:CreateToggle({
   Name = "Auto Farm Level",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then
         task.spawn(function()
            while _G.AutoFarm do
               pcall(function()
                  -- Keresünk egy banditát a workspace-ben
                  local target = nil
                  for _, v in pairs(workspace.Enemies:GetChildren()) do
                     if v.Name == "Bandit" and v.Humanoid.Health > 0 then
                        target = v
                        break
                     end
                  end

                  if target then
                     -- Repülés az NPC fölé 5 méterrel
                     Tween.To(target.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0), 200)
                     -- Ütés a RegisterAttack remote-tal
                     Net.Remotes.Attack:FireServer()
                  end
               end)
               task.wait()
            end
         end)
      end
   end,
})
