local Net = {}
local RS = game:GetService("ReplicatedStorage")

Net.Remotes = {
    Attack = RS.Modules.Net["RE/RegisterAttack"],
    StartQuest = RS.Modules.Net["RF/StartSubclassQuest"],
    QuestUpdate = RS.Remotes.QuestUpdate
}

return Net
