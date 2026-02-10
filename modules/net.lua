local Net = {}
local RS = game:GetService("ReplicatedStorage")

Net.Remotes = {
    Attack = RS.Modules.Net["RE/RegisterAttack"],
    Quest = RS.Modules.Net["RF/StartSubclassQuest"]
}

return Net
