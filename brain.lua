local Event = game:GetService("ReplicatedStorage").Events.PadUpgraded
firesignal(Event.OnClientEvent, 
    workspace.MainGame.Plots.Plot2.Pads["6"],
    3
)