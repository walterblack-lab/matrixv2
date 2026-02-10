local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Modules = _G.Matrix_Modules
_G.AutoFarm = false

local Window = Rayfield:CreateWindow({
   Name = "MATRIX HUB | BLOX FRUITS",
   Theme = "Amethyst",
   ConfigurationSaving = { Enabled = false }
})

local FarmTab = Window:CreateTab("Auto Farm", 4483362458)

-- SPECIÁLIS ÜTÉS FUNKCIÓ
local function superAttack()
    local p = game.Players.LocalPlayer
    local char = p.Character
    if not char then return end
    
    -- Fegyver kézbevétele
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then
        tool = p.Backpack:FindFirstChild("Combat") or p.Backpack:FindFirstChildOfClass("Tool")
        if tool then char.Humanoid:EquipTool(tool) end
    end
    
    if tool then
        -- 1. Direkt aktiválás
        tool:Activate()
        -- 2. Egérkattintás szimulálása a virtuális felhasználóval
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
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
                     -- Pozíció: 5.2 méter (kicsit közelebb, mint eddig)
                     local targetPos = target.HumanoidRootPart.CFrame * CFrame.new(0, 5.2, 0)
                     
                     -- Távolság-alapú mozgás (ha 6 méteren belül vagyunk, NEM teleportálunk többet)
                     if (hrp.Position - targetPos.p).Magnitude > 6 then
                        Modules.Tween.To(targetPos, 300)
                     else
                        -- CSAK ITT ÁLLUNK MEG ÉS ÜTÜNK (nincs több mozgás parancs!)
                        hrp.CFrame = targetPos
                        hrp.Velocity = Vector3.new(0,0,0)
                        
                        superAttack() -- Aktiváljuk a "szimulált" kattintást
                        Modules.Net.Remotes.Attack:FireServer()
                     end
                  end
               end)
               task.wait(0.1) -- Hagyunk időt az animációnak!
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
