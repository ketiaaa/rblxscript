local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Pressure Wash Incremental",
   Icon = 0,
   LoadingTitle = "Pressure Wash Incremental",
   LoadingSubtitle = "by tia",
   Theme = "Default",
   ToggleUIKeybind = "K",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Pressure Wash Incremental"
   },

   KeySystem = false
})

-- ══════════════════════════════
--           REMOTES
-- ══════════════════════════════

local spawnEvent = game:GetService("ReplicatedStorage").Remotes.SpawnDirtClient
local washEvent = game:GetService("ReplicatedStorage").Remotes.WashDirt
local updateEvent = game:GetService("ReplicatedStorage").Remotes.UpdateWashingStatus
local upgradeEvent = game:GetService("ReplicatedStorage").Remotes.BuyUpgrade
local rebirthEvent = game:GetService("ReplicatedStorage").Remotes.RequestRebirth
local soapEvent = game:GetService("ReplicatedStorage").Remotes.ClickSoapBottle
local padEvent = game:GetService("ReplicatedStorage").Remotes.BuyPad
local pressureEvent = game:GetService("ReplicatedStorage").Remotes.AddPressure
local tierEvent = game:GetService("ReplicatedStorage").Remotes.RequestTierAdvance

local dirtQueue = {}

spawnEvent.OnClientEvent:Connect(function(uuid, dirtType, ...)
   table.insert(dirtQueue, uuid)
end)

-- ══════════════════════════════
--           TABS
-- ══════════════════════════════

local MainTab = Window:CreateTab("Main", "star")
local PlayerTab = Window:CreateTab("Player", "user")
local EngineerTab = Window:CreateTab("Engineer", "wrench")
local MiscTab = Window:CreateTab("Misc", "settings")

-- ══════════════════════════════
--        MAIN TAB
-- ══════════════════════════════

MainTab:CreateSection("Info")

MainTab:CreateParagraph({
   Title = "Welcome!",
   Content = "Use the tabs above to navigate. Press K to toggle the UI."
})

-- ══════════════════════════════
--        PLAYER TAB
-- ══════════════════════════════

PlayerTab:CreateSection("Movement")

PlayerTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "InfJump",
   Callback = function(Value)
      _G.InfJump = Value
   end,
})

game:GetService("UserInputService").JumpRequest:Connect(function()
   if _G.InfJump then
      local char = game.Players.LocalPlayer.Character
      if char and char:FindFirstChild("Humanoid") then
         char.Humanoid:ChangeState("Jumping")
      end
   end
end)

PlayerTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Flag = "Noclip",
   Callback = function(Value)
      _G.Noclip = Value
   end,
})

game:GetService("RunService").Stepped:Connect(function()
   if _G.Noclip then
      local char = game.Players.LocalPlayer.Character
      if char then
         for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
               part.CanCollide = false
            end
         end
      end
   end
end)

PlayerTab:CreateSection("Auto Wash")

PlayerTab:CreateToggle({
   Name = "Auto Wash",
   CurrentValue = false,
   Flag = "AutoWash",
   Callback = function(Value)
      _G.AutoWash = Value
      Rayfield:Notify({
         Title = "Auto Wash",
         Content = Value and "Auto Wash enabled!" or "Auto Wash disabled.",
         Duration = 3,
         Image = Value and "check" or "x"
      })
   end,
})

task.spawn(function()
   while true do
      task.wait(0.05)
      if _G.AutoWash and #dirtQueue > 0 then
         local uuid = table.remove(dirtQueue, 1)
         washEvent:FireServer(uuid)
      end
   end
end)

PlayerTab:CreateSection("Dirt Upgrades")

PlayerTab:CreateToggle({
   Name = "Auto Buy Spawn Rate",
   CurrentValue = false,
   Flag = "AutoSpawnRate",
   Callback = function(Value)
      _G.AutoSpawnRate = Value
   end,
})

PlayerTab:CreateToggle({
   Name = "Auto Buy Dirt Value",
   CurrentValue = false,
   Flag = "AutoDirtValue",
   Callback = function(Value)
      _G.AutoDirtValue = Value
   end,
})

PlayerTab:CreateToggle({
   Name = "Auto Buy Dirt Amount",
   CurrentValue = false,
   Flag = "AutoDirtAmount",
   Callback = function(Value)
      _G.AutoDirtAmount = Value
   end,
})

PlayerTab:CreateToggle({
   Name = "Auto Buy Double Dirt Density",
   CurrentValue = false,
   Flag = "AutoDoubleDirtDensity",
   Callback = function(Value)
      _G.AutoDoubleDirtDensity = Value
   end,
})

PlayerTab:CreateToggle({
   Name = "Auto Buy Expand Spray Radius",
   CurrentValue = false,
   Flag = "AutoExpandSprayRadius",
   Callback = function(Value)
      _G.AutoExpandSprayRadius = Value
   end,
})

PlayerTab:CreateToggle({
   Name = "Auto Buy Boost Spawn Rate",
   CurrentValue = false,
   Flag = "AutoBoostSpawnRate",
   Callback = function(Value)
      _G.AutoBoostSpawnRate = Value
   end,
})

task.spawn(function()
   while true do
      task.wait(0.5)
      if _G.AutoSpawnRate then
         upgradeEvent:FireServer("SpawnRate", false)
      end
      if _G.AutoDirtValue then
         upgradeEvent:FireServer("DirtValue", true)
      end
      if _G.AutoDirtAmount then
         upgradeEvent:FireServer("DirtAmount", false)
      end
      if _G.AutoDoubleDirtDensity then
      upgradeEvent:FireServer("DoubleDirtDensity", false)
      end
      if _G.AutoExpandSprayRadius then
      upgradeEvent:FireServer("ExpandSprayRadius", false)
      end
      if _G.AutoBoostSpawnRate then
      upgradeEvent:FireServer("BoostSpawnRate", false)
      end
   end
end)

PlayerTab:CreateSection("Soap Bottle")

PlayerTab:CreateToggle({
   Name = "Auto Click Soap Bottle",
   CurrentValue = false,
   Flag = "AutoSoap",
   Callback = function(Value)
      _G.AutoSoap = Value
   end,
})

task.spawn(function()
   while true do
      task.wait(0.2)
      if _G.AutoSoap then
         soapEvent:FireServer()
      end
   end
end)

PlayerTab:CreateSection("Soap Upgrades")

PlayerTab:CreateToggle({
   Name = "Auto Buy Double Rebirth Value",
   CurrentValue = false,
   Flag = "AutoDoubleRebirthValue",
   Callback = function(Value)
      _G.AutoDoubleRebirthValue = Value
   end,
})

PlayerTab:CreateToggle({
   Name = "Auto Buy Double Dirt Value",
   CurrentValue = false,
   Flag = "AutoDoubleDirtValue",
   Callback = function(Value)
      _G.AutoDoubleDirtValue = Value
   end,
})

PlayerTab:CreateToggle({
   Name = "Auto Buy Autoclick",
   CurrentValue = false,
   Flag = "AutoBuyAutoclick",
   Callback = function(Value)
      _G.AutoBuyAutoclick = Value
   end,
})

task.spawn(function()
   while true do
      task.wait(0.5)
      if _G.AutoDoubleRebirthValue then
         upgradeEvent:FireServer("DoubleRebirthValue", false)
      end
      if _G.AutoDoubleDirtValue then
         upgradeEvent:FireServer("DoubleDirtValue", false)
      end
      if _G.AutoBuyAutoclick then
         upgradeEvent:FireServer("Autoclick", false)
      end
   end
end)

-- ══════════════════════════════
--        ENGINEER TAB
-- ══════════════════════════════

EngineerTab:CreateSection("Engineer Upgrades")

EngineerTab:CreateToggle({
   Name = "Auto Buy Engineer Work Speed",
   CurrentValue = false,
   Flag = "AutoEngineerWorkSpeed",
   Callback = function(Value)
      _G.AutoEngineerWorkSpeed = Value
   end,
})

task.spawn(function()
   while true do
      task.wait(0.5)
      if _G.AutoEngineerWorkSpeed then
         upgradeEvent:FireServer("EngineerWorkSpeed", false)
      end
   end
end)

EngineerTab:CreateSection("Pressure Upgrades")

EngineerTab:CreateToggle({
   Name = "Auto Buy Double Rebirth Value",
   CurrentValue = false,
   Flag = "AutoPressureDoubleRebirth",
   Callback = function(Value)
      _G.AutoPressureDoubleRebirth = Value
   end,
})

EngineerTab:CreateToggle({
   Name = "Auto Buy Double Dirt Value",
   CurrentValue = false,
   Flag = "AutoPressureDoubleDirt",
   Callback = function(Value)
      _G.AutoPressureDoubleDirt = Value
   end,
})

EngineerTab:CreateToggle({
   Name = "Auto Buy Increase Pressure Value",
   CurrentValue = false,
   Flag = "AutoIncreasePressureValue",
   Callback = function(Value)
      _G.AutoIncreasePressureValue = Value
   end,
})

task.spawn(function()
   while true do
      task.wait(1)
      if _G.AutoPressureDoubleRebirth then
         pressureEvent:FireServer("Pressure_DoubleRebirthValue", false)
         task.wait(1)
      end
      if _G.AutoPressureDoubleDirt then
         pressureEvent:FireServer("Pressure_DoubleDirtValue", false)
         task.wait(1)
      end
      if _G.AutoIncreasePressureValue then
         pressureEvent:FireServer("Pressure_IncreasePressureValue", false)
         task.wait(1)
      end
   end
end)

-- ══════════════════════════════
--        MISC TAB
-- ══════════════════════════════

MiscTab:CreateSection("Utilities")

MiscTab:CreateButton({
   Name = "Rejoin Game",
   Callback = function()
      local TeleportService = game:GetService("TeleportService")
      TeleportService:Teleport(game.PlaceId, game.Players.LocalPlayer)
   end,
})

MiscTab:CreateButton({
   Name = "Copy Username",
   Callback = function()
      local name = game.Players.LocalPlayer.Name
      setclipboard(name)
      Rayfield:Notify({
         Title = "Copied!",
         Content = "Username copied: " .. name,
         Duration = 3,
         Image = "clipboard"
      })
   end,
})

MiscTab:CreateSection("Rebirth")

MiscTab:CreateButton({
   Name = "Rebirth",
   Callback = function()
      rebirthEvent:FireServer(false)
      Rayfield:Notify({
         Title = "Rebirth",
         Content = "Rebirth requested!",
         Duration = 3,
         Image = "refresh-cw"
      })
   end,
})

MiscTab:CreateToggle({
   Name = "Auto Rebirth",
   CurrentValue = false,
   Flag = "AutoRebirth",
   Callback = function(Value)
      _G.AutoRebirth = Value
   end,
})

task.spawn(function()
   while true do
      task.wait(1)
      if _G.AutoRebirth then
         rebirthEvent:FireServer(false)
      end
   end
end)

MiscTab:CreateSection("Tier Advance")

MiscTab:CreateToggle({
   Name = "Auto Tier Advance",
   CurrentValue = false,
   Flag = "AutoTierAdvance",
   Callback = function(Value)
      _G.AutoTierAdvance = Value
   end,
})

task.spawn(function()
   while true do
      task.wait(1)
      if _G.AutoTierAdvance then
         tierEvent:FireServer(true)
      end
   end
end)

MiscTab:CreateSection("Buy Pads")

MiscTab:CreateToggle({
   Name = "Auto Buy All Pads (Tree 1-1 to 1-20)",
   CurrentValue = false,
   Flag = "AutoBuyPads",
   Callback = function(Value)
      _G.AutoBuyPads = Value
   end,
})

task.spawn(function()
   while true do
      task.wait(0.5)
      if _G.AutoBuyPads then
         for i = 1, 20 do
            padEvent:FireServer("Tree1-" .. i)
            task.wait(0.1)
         end
      end
   end
end)

MiscTab:CreateSection("Anti AFK")

MiscTab:CreateToggle({
   Name = "Anti AFK",
   CurrentValue = false,
   Flag = "AntiAFK",
   Callback = function(Value)
      _G.AntiAFK = Value
   end,
})

game:GetService("Players").LocalPlayer.Idled:Connect(function()
   if _G.AntiAFK then
      game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
      task.wait(1)
      game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
   end
end)

-- ══════════════════════════════
--         DONE
-- ══════════════════════════════

Rayfield:Notify({
   Title = "Hub Loaded",
   Content = "Welcome, " .. game.Players.LocalPlayer.Name .. "!",
   Duration = 5,
   Image = "check"
})

Rayfield:LoadConfiguration()