--// INVISIBLE AIMBOT (R6 + R15 + MOBILE + SNAP + THRU WALLS)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Folder where enemies/dummies are stored
local enemyFolder = workspace:WaitForChild("Enemies")

local aimbotEnabled = false

------------------------------------------------------------
-- MOBILE BUTTON (ONLY VISIBLE UI)
------------------------------------------------------------
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AimbotUI"

local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0, 150, 0, 60)
button.Position = UDim2.new(0.05, 0, 0.8, 0)
button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
button.Text = "Aimbot OFF"
button.TextScaled = true
button.TextColor3 = Color3.new(1,1,1)

button.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled

    if aimbotEnabled then
        button.Text = "Aimbot ON"
        button.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
    else
        button.Text = "Aimbot OFF"
        button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

------------------------------------------------------------
-- PC KEY TOGGLE (OPTIONAL)
------------------------------------------------------------
UserInputService.InputBegan:Connect(function(key)
    if key.KeyCode == Enum.KeyCode.E then
        aimbotEnabled = not aimbotEnabled

        if aimbotEnabled then
            button.Text = "Aimbot ON"
            button.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        else
            button.Text = "Aimbot OFF"
            button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        end
    end
end)

------------------------------------------------------------
-- FIND NEAREST HEAD THROUGH WALLS
------------------------------------------------------------
local function getNearestHead()
    local nearest = nil
    local shortestDist = math.huge

    for _, enemy in ipairs(enemyFolder:GetChildren()) do
        local head = enemy:FindFirstChild("Head")
        if head then
            local screenPos, visible = camera:WorldToViewportPoint(head.Position)
            local mousePos = UserInputService:GetMouseLocation()

            local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude

            if distance < shortestDist then
                shortestDist = distance
                nearest = head
            end
        end
    end

    return nearest
end

------------------------------------------------------------
-- AIMBOT SNAP (NO UI — INVISIBLE)
------------------------------------------------------------
RunService.RenderStepped:Connect(function()
    if not aimbotEnabled then return end

    local head = getNearestHead()
    if head then
        camera.CFrame = CFrame.new(camera.CFrame.Position, head.Position)
    end
end)
