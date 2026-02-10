local Net = {}
local RS = game:GetService("ReplicatedStorage")

Net.Remotes = {
    Attack = RS:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterAttack"),
    Quest = RS:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/StartSubclassQuest")
}

return Net
