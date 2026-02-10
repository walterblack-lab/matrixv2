local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Modules = _G.Matrix_Modules
_G.AutoFarm = false

local Window = Rayfield:CreateWindow({
   Name = "MATRIX HUBX FRUITS",
   Theme = "Bloom",
   ConfigurationSaving = { Enabled = false }
})

local FarmTab = Window:CreateTab("Auto Farm", 4483362458)

-- SPECIÁLIS ÜTÉS FUNKCIÓ (A te esetedre szabva)
local function forcePunch()
    local p = game.Players.LocalPlayer
    local char = p.Character
    if not char then return end
    
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then
        tool = p.Backpack:FindFirstChild("Combat") or p.Backpack:FindFirstChildOfClass("Tool")
        if tool then char.Humanoid:EquipTool(tool) end
    end
    
    if tool then
        -- 1. Kényszerítjük a fegyvert, hogy "azt higgye", kattintottál
        tool:Activate()
        
        -- 2. Közvetlenül meghívjuk az ütés animációját a Humanoidon keresztül
        local anim = char.Humanoid:LoadAnimation(tool.Animations.Attack) -- Blox Fruits specifikus
        if anim then anim:Play() end
        
        -- 3. Megpróbáljuk a Net modult is, de egy kis késleltetéssel (mint a valódi ütés)
        task.spawn(function()
            task.wait(0.05)
            Modules.Net.Remotes.Attack:FireServer()
        end)
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
                  local lp = game.Players.LocalPlayer
                  local hrp = lp.Character.HumanoidRootPart
                  
                  local target = nil
                  local dist = math.huge
                  for _, v in pairs(workspace.Enemies:GetChildren()) do
                     if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        local d = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
                        if d < dist then dist = d; target = v end
                     end
                  end

                  if target then
                     -- Pozíció: 4.5 méterrel az NPC elé (hogy az ököl biztosan érjen)
                     local targetPos = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4.5)
                     
                     if (hrp.Position - targetPos.p).Magnitude > 6 then
                        Modules.Tween.To(targetPos, 300)
                     else
                        -- MEGÁLLÁS ÉS ÜTÉS
                        Modules.Tween.Stop()
                        hrp.CFrame = targetPos
                        hrp.Velocity = Vector3.new(0,0,0)
                        
                        forcePunch() -- Itt hívjuk meg a javított ütést
                     end
                  end
               end)
               task.wait(0.12) -- Megfelelő ütem a szervernek
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
