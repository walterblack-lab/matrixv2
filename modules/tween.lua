-- TWEEN MODULE (Matrix Hub - Ultra-Low RAM Edition)
local tween = {}

local TweenService = game:GetService("TweenService")
local lp = game.Players.LocalPlayer
local currentTween = nil -- Egy változóban tartjuk a tween-t, hogy újrahasznosítsuk

function tween.To(targetCFrame, speed)
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local duration = distance / speed
    
    -- Meglévő mozgás megállítása és takarítása (Memory Leak elleni védelem)
    if currentTween then
        currentTween:Cancel()
        currentTween:Destroy() -- Ez törli ki a RAM-ból a régi objektumot
        currentTween = nil
    end
    
    local info = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    
    -- Új tween létrehozása
    currentTween = TweenService:Create(hrp, info, {CFrame = targetCFrame})
    
    -- Automatikus takarítás, ha a mozgás befejeződött
    currentTween.Completed:Connect(function()
        if currentTween then
            currentTween:Destroy()
            currentTween = nil
        end
    end)
    
    currentTween:Play()
end

function tween.Stop()
    if currentTween then
        currentTween:Cancel()
        currentTween:Destroy()
        currentTween = nil
    end
end

return tween
