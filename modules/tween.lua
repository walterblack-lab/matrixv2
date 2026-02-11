-- TWEEN MODULE (FIXED)
local tween = {}
local TweenService = game:GetService("TweenService")
local currentTween = nil 

function tween.To(targetCFrame, speed)
    local char = game.Players.LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local dist = (char.HumanoidRootPart.Position - targetCFrame.Position).Magnitude
    if currentTween then currentTween:Cancel(); currentTween:Destroy() end
    
    currentTween = TweenService:Create(char.HumanoidRootPart, TweenInfo.new(dist/speed, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    currentTween:Play()
end

function tween.Stop()
    -- JAVÍTÁS: Csak akkor Destroy, ha létezik a tween!
    if currentTween ~= nil then 
        currentTween:Cancel()
        currentTween:Destroy()
        currentTween = nil
    end
end

return tween
