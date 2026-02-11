local tween = {}
local TweenService = game:GetService("TweenService")
local currentTween = nil 

function tween.To(targetCFrame, speed)
    local char = game.Players.LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local dist = (hrp.Position - targetCFrame.Position).Magnitude
    if currentTween ~= nil then 
        currentTween:Cancel() 
        currentTween:Destroy() 
        currentTween = nil
    end
    local info = TweenInfo.new(dist/speed, Enum.EasingStyle.Linear)
    currentTween = TweenService:Create(hrp, info, {CFrame = targetCFrame})
    currentTween:Play()
end

function tween.Stop()
    if currentTween ~= nil then 
        currentTween:Cancel()
        currentTween:Destroy()
        currentTween = nil
    end
end

return tween
