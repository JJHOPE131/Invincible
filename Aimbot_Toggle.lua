--// REAL AIMBOT FOR YOUR OWN GAME (R6 + R15 HEADLOCK)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Toggle keybind
local aimbotEnabled = false
local toggleKey = Enum.KeyCode.E  -- press E to toggle

-- Change this to your enemy folder!
local enemyFolder = workspace.Enemies

---------------------------------------------------------------------

-- Find closest enemy head
local function getClosestEnemy()
    local closest = nil
    local shortestDist = math.huge

    for _, enemy in ipairs(enemyFolder:GetChildren()) do
        local head = enemy:FindFirstChild("Head")
        if head then
            local screenPos, visible = camera:WorldToViewportPoint(head.Position)
            if visible then
                local mousePos = UserInputService:GetMouseLocation()
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude

                if dist < shortestDist then
                    closest = head
                    shortestDist = dist
                end
            end
        end
    end

    return closest
end

---------------------------------------------------------------------

-- Toggle aimbot on key press
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == toggleKey then
        aimbotEnabled = not aimbotEnabled
        if aimbotEnabled then
            print("Aimbot Enabled")
        else
            print("Aimbot Disabled")
        end
    end
end)

---------------------------------------------------------------------

-- Main aimbot loop
RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local targetHead = getClosestEnemy()
        if targetHead then
            -- Smooth aim
            local targetPos = targetHead.Position
            local currentCFrame = camera.CFrame

            camera.CFrame = currentCFrame:Lerp(
                CFrame.new(currentCFrame.Position, targetPos),
                0.25 -- smoothness (change 0.1–0.5)
            )
        end
    end
end)
