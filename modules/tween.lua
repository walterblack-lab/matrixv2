local TweenModule = {}
local TS = game:GetService("TweenService")
local currentTween = nil

function TweenModule.To(targetCFrame, speed)
    local char = game.Players.LocalPlayer.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Ha már fut egy repülés, megállítjuk
    if currentTween then currentTween:Cancel() end
    
    local dist = (hrp.Position - targetCFrame.p).Magnitude
    local info = TweenInfo.new(dist/speed, Enum.EasingStyle.Linear)
    currentTween = TS:Create(hrp, info, {CFrame = targetCFrame})
    
    currentTween:Play()
    return currentTween
end

function TweenModule.Stop()
    if currentTween then currentTween:Cancel() end
end

return TweenModule
