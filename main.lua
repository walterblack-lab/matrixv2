local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Modules = _G.Matrix_Modules
_G.AutoFarm = false

local Window = Rayfield:CreateWindow({
   Name = "MATRIX HUB | BLOX FRUITS",
   Theme = "DarkBlue",
   ConfigurationSaving = { Enabled = false }
})

local FarmTab = Window:CreateTab("Auto Farm", 4483362458)

-- MEGBÍZHATÓ FEGYVER ELŐVÉTEL
local function equipWeapon()
    local p = game.Players.LocalPlayer
    local char = p.Character
    if not char then return end
    if char:FindFirstChildOfClass("Tool") then return end
    
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
         -- 1. CIKLUS: MOZGÁS (Lassabb, hogy ne rángasson)
         task.spawn(function()
            while _G.AutoFarm do
               pcall(function()
                  local target = nil
                  local dist = math.huge
                  local lp = game.Players.LocalPlayer
                  
                  for _, v in pairs(workspace.Enemies:GetChildren()) do
                     if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        local d = (v.HumanoidRootPart.Position - lp.Character.HumanoidRootPart.Position).Magnitude
                        if d < dist then dist = d; target = v end
                     end
                  end

                  if target then
                     equipWeapon()
                     local targetPos = target.HumanoidRootPart.CFrame * CFrame.new(0, 6, 0) -- 6 méterrel fölé
                     
                     -- CSAK AKKOR TELEPORTÁLUNK, HA MESSZE VAGYUNK
                     if (lp.Character.HumanoidRootPart.Position - targetPos.p).Magnitude > 8 then
                        Modules.Tween.To(targetPos, 300)
                     else
                        -- Ha ott vagyunk, csak finoman korrigálunk, nem rángatunk
                        Modules.Tween.Stop()
                        lp.Character.HumanoidRootPart.CFrame = lp.Character.HumanoidRootPart.CFrame:Lerp(targetPos, 0.1)
                     end
                  end
               end)
               task.wait(0.5) -- Ritkább pozíció frissítés = Sima ütés
            end
         end)

         -- 2. CIKLUS: TÁMADÁS (Ez pörög ezerrel)
         task.spawn(function()
            while _G.AutoFarm do
               pcall(function()
                  Modules.Net.Remotes.Attack:FireServer()
               end)
               task.wait(0.01) -- Brutál gyors ütés
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
