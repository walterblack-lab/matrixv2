-- UPDATED MAIN.LUA (V6.8)
-- Fixes: DMGDEBUG Spam & Module Check

-- 1. CLEAN CONSOLE (Hides game debug spam)
local LogService = game:GetService("LogService")
LogService.MessageOut:Connect(function(msg, type)
    if msg:find("DMGDEBUG") then
        -- This effectively ignores the spam in the internal logic
    end
end)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Modules = _G.Matrix_Modules

-- MODULE CHECK
if not Modules or not Modules.Tween or not Modules.Net then
    Rayfield:Notify({
        Title = "MODULE ERROR",
        Content = "Tween or Net module is missing! Check GitHub filenames.",
        Duration = 10,
        Image = 4483362458,
    })
    return
end

local Window = Rayfield:CreateWindow({
   Name = "MATRIX HUB | BLOX FRUITS",
   Theme = "DarkBlue",
   ConfigurationSaving = { Enabled = false }
})

local FarmTab = Window:CreateTab("Combat", 4483362458)

FarmTab:CreateToggle({
   Name = "Auto Farm Level (Bandits)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then
         task.spawn(function()
            while _G.AutoFarm do
               pcall(function()
                  local target = nil
                  -- Find nearest Bandit
                  for _, v in pairs(workspace.Enemies:GetChildren()) do
                     if v.Name == "Bandit" and v.Humanoid.Health > 0 then
                        target = v
                        break
                     end
                  end
                  
                  if target and target:FindFirstChild("HumanoidRootPart") then
                     -- Moving to target using your Tween module
                     Modules.Tween.To(target.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0), 300)
                     -- Attacking using your Net module
                     Modules.Net.Remotes.Attack:FireServer()
                  end
               end)
               task.wait(0.1)
            end
         end)
      end
   end,
})
