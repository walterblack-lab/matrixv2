--[[
    MATRIX HUB - BLOX FRUITS (walterblack-lab edition)
    Optimized for Solara & Baganito5
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Modules = _G.Matrix_Modules -- Feltételezve, hogy a betöltő scripted már definiálta

local Window = Rayfield:CreateWindow({
   Name = "MATRIX HUB | BLOX FRUITS",
   Theme = "DarkBlue",
   ConfigurationSaving = { Enabled = false }
})

local FarmTab = Window:CreateTab("Auto Farm", 4483362458)

-- VÁLTOZÓK
_G.AutoFarm = false
local lp = game.Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- SEGÉDFÜGGVÉNY: A legközelebbi ellenség megkeresése
local function getClosestNPC()
    local target = nil
    local dist = math.huge
    if not workspace:FindFirstChild("Enemies") then return nil end
    
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            local d = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
            if d < dist then
                dist = d
                target = v
            end
        end
    end
    return target
end

-- FŐ CIKLUS (Combat & Farm)
local function startFarm()
    task.spawn(function()
        while _G.AutoFarm do
            local success, err = pcall(function()
                local npc = getClosestNPC()
                
                if npc then
                    local npcHrp = npc.HumanoidRootPart
                    -- Pozíció az NPC felett (idiothamgurger stílus)
                    local targetPos = npcHrp.CFrame * CFrame.new(0, 5, 0)
                    local distance = (hrp.Position - targetPos.Position).Magnitude

                    if distance > 10 then
                        -- TÁVOLI MOZGÁS: Itt használjuk a Tweent
                        Modules.Tween.To(targetPos, 300)
                    else
                        -- KÖZELHARC: Itt állítjuk le a Tweent a fagyás elkerülésére
                        Modules.Tween.Stop()
                        
                        -- 1. ÁLLAPOT: Hazudjuk azt a szervernek, hogy a földön futunk
                        char.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
                        
                        -- 2. LOOKAT: Kényszerítjük, hogy az NPC-re nézzen (Kritikus a sebzéshez!)
                        hrp.CFrame = CFrame.lookAt(targetPos.Position, npcHrp.Position)
                        
                        -- 3. STABILIZÁLÁS: Velocity nullázása (Hogy ne rángasson az animáció)
                        hrp.Velocity = Vector3.new(0,0,0)

                        -- 4. TÁMADÁS: Fegyvervétel és ütés
                        local tool = char:FindFirstChildOfClass("Tool")
                        if not tool then
                            local combat = lp.Backpack:FindFirstChild("Combat") or lp.Backpack:FindFirstChildOfClass("Tool")
                            if combat then char.Humanoid:EquipTool(combat) end
                        else
                            tool:Activate()
                            -- A hálózati esemény hívása a Matrix modulodon keresztül
                            Modules.Net.Remotes.Attack:FireServer(0)
                        end
                    end
                end
            end)
            if not success then warn("Farm Error: " .. err) end
            task.wait(0.05) -- Gyors frissítés
        end
    end)
end

-- UI TOGGLE
FarmTab:CreateToggle({
   Name = "Auto Farm (Baganito5 Mode)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then
         startFarm()
      else
         Modules.Tween.Stop()
      end
   end,
})

Rayfield:Notify({
   Title = "Matrix Hub Betöltve",
   Content = "Üdv, Baganito5! A Solara optimalizált farm készen áll.",
   Duration = 5
})
