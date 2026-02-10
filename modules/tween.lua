local TweenModule = {}
local TS = game:GetService("TweenService")

function TweenModule.To(targetCFrame, speed)
    local char = game.Players.LocalPlayer.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local dist = (hrp.Position - targetCFrame.p).Magnitude
    local info = TweenInfo.new(dist/speed, Enum.EasingStyle.Linear)
    local tween = TS:Create(hrp, info, {CFrame = targetCFrame})
    
    -- NoClip aktiválása
    task.spawn(function()
        local connection
        connection = game:GetService("RunService").Stepped:Connect(function()
            if _G.AutoFarm then
                for _, v in pairs(char:GetChildren()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            else
                connection:Disconnect()
            end
        end)
    end)
    
    tween:Play()
    return tween
end

return TweenModule
