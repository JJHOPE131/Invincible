-- LOCAL CLIENT BUTTON FOR GODMODE
-- Works with the ServerScript in ServerScriptService
-- Toggle ON/OFF GodMode

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- RemoteEvent created by server script
local toggleEvent = ReplicatedStorage:WaitForChild("ToggleGodMode")

local GODMODE = false

----------------------------------------------------
-- GUI SETUP (mobile + PC friendly)
----------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 260, 0, 90)  -- Big for mobile
button.Position = UDim2.new(0.5, -130, 0, 40) -- Center top
button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
button.BorderSizePixel = 3
button.BorderColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.SourceSansBold
button.TextColor3 = Color3.new(1,1,1)
button.TextScaled = true
button.Text = "God Mode: OFF"
button.Parent = gui

----------------------------------------------------
-- BUTTON TOGGLE LOGIC
----------------------------------------------------
button.MouseButton1Click:Connect(function()
    GODMODE = not GODMODE

    -- Update button text
    button.Text = "God Mode: " .. (GODMODE and "ON" or "OFF")

    -- Tell server to enable/disable GodMode
    toggleEvent:FireServer(GODMODE)
end)
