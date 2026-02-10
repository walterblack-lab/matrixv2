local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Modules = _G.Matrix_Modules
_G.AutoFarm = false

local Window = Rayfield:CreateWindow({
   Name = "MATRIX HUB | BLOX FRUITS",
   Theme = "DarkBlue",
   ConfigurationSaving = { Enabled = false }
})

local FarmTab = Window:CreateTab("Auto Farm", 4483362458)

local function equipWeapon()
    local p = game.Players.LocalPlayer
    local char = p.Character
    if not char or char:FindFirstChildOfClass("Tool") then return end
    local tool = p.Backpack:FindFirstChild("Combat") or p.Backpack:FindFirstChildOfClass("Tool")
    if tool then char.Humanoid:EquipTool(tool) end
end

FarmTab:CreateToggle({
   Name = "Auto Farm (Starter Island)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then
         task.spawn(function()
            while _G.AutoFarm do
               local success, err = pcall(function()
                  local lp = game.Players.LocalPlayer
                  local char = lp.Character
                  local hrp = char.HumanoidRootPart
                  
                  -- NPC keresés
                  local target = nil
                  local dist = math.huge
                  for _, v in pairs(workspace.Enemies:GetChildren()) do
                     if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        local d = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
                        if d < dist then dist = d; target = v end
                     end
                  end

                  if target then
                     equipWeapon()
                     -- TÁVOLSÁG: 5.5 méterrel az NPC fölé
                     local targetPos = target.HumanoidRootPart.CFrame * CFrame.new(0, 5.5, 0)
                     
                     -- MOZGÁS: Csak ha messze vagyunk (megszünteti a rángatást)
                     if (hrp.Position - targetPos.p).Magnitude > 5 then
                        Modules.Tween.To(targetPos, 300)
                        task.wait(0.3) -- Hagyunk időt a megérkezésre
                     else
                        -- FIXÁLÁS: Egy helyben tartunk, nem rángatunk
                        hrp.Velocity = Vector3.new(0,0,0)
                        hrp.CFrame = targetPos
                        
                        -- TÁMADÁS: Gyors, de nem akasztja meg a motort
                        Modules.Net.Remotes.Attack:FireServer()
                     end
                  end
               end)
               task.wait(0.05) -- Ez a sebesség az ideális a szervernek
            end
         end)
      end
   end,
})

local SystemTab = Window:CreateTab("System", 4483362458)
SystemTab:CreateButton({
   Name = "Destroy Script (Unload)",
   Callback = function()
      _G.AutoFarm = false
      task.wait(0.2)
      Rayfield:Destroy()
   end,
})
