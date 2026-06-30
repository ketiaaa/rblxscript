local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "My Hub",
   Icon = 0,
   LoadingTitle = "My Hub",
   LoadingSubtitle = "by ketia",
   Theme = "Default",
   ToggleUIKeybind = "K",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "MyHub"
   },

   KeySystem = false
})

-- ══════════════════════════════
--           TABS
-- ══════════════════════════════

local MainTab = Window:CreateTab("Main", "star")
local PlayerTab = Window:CreateTab("Player", "user")
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

PlayerTab:CreateSlider({
   Name = "Walk Speed",
   Range = {16, 250},
   Increment = 1,
   Suffix = "ws",
   CurrentValue = 16,
   Flag = "WalkSpeed",
   Callback = function(Value)
      local char = game.Players.LocalPlayer.Character
      if char and char:FindFirstChild("Humanoid") then
         char.Humanoid.WalkSpeed = Value
      end
   end,
})

PlayerTab:CreateSlider({
   Name = "Jump Power",
   Range = {50, 500},
   Increment = 10,
   Suffix = "jp",
   CurrentValue = 50,
   Flag = "JumpPower",
   Callback = function(Value)
      local char = game.Players.LocalPlayer.Character
      if char and char:FindFirstChild("Humanoid") then
         char.Humanoid.JumpPower = Value
      end
   end,
})

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