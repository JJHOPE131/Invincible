--// ADVANCED AIM SYSTEM FOR YOUR GAME
--// Snap Aim • Silent Aim • ESP • FOV • Mobile Toggle • R6+R15

---------------------------------------------------------------------
-- SERVICES
---------------------------------------------------------------------
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

---------------------------------------------------------------------
-- SETTINGS
---------------------------------------------------------------------
local enemyFolder = workspace:WaitForChild("Enemies")
local aimbotEnabled = false
local silentAimEnabled = true
local snapSpeed = 1 -- 1 = instant snap
local fovRadius = 150

---------------------------------------------------------------------
-- UI (FOV CIRCLE + MOBILE BUTTON)
---------------------------------------------------------------------
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "AimSystemUI"

-- Mobile Toggle Button
local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0, 150, 0, 60)
button.Position = UDim2.new(0.05, 0, 0.8, 0)
button.Text = "Aimbot OFF"
button.TextScaled = true
button.BackgroundColor3 = Color3.fromRGB(255,50,50)

button.MouseButton1Click:Connect(function()
	aimbotEnabled = not aimbotEnabled
	button.Text = aimbotEnabled and "Aimbot ON" or "Aimbot OFF"
	button.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(50,255,50) or Color3.fromRGB(255,50,50)
end)

-- FOV Circle
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = true
fovCircle.Radius = fovRadius
fovCircle.Thickness = 2
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Filled = false

---------------------------------------------------------------------
-- ESP (BillboardGui)
---------------------------------------------------------------------
local function addESP(enemy)
	if enemy:FindFirstChild("ESP") then return end

	local esp = Instance.new("BillboardGui", enemy)
	esp.Name = "ESP"
	esp.Size = UDim2.new(0, 100, 0, 20)
	esp.AlwaysOnTop = true

	local label = Instance.new("TextLabel", esp)
	label.Size = UDim2.new(1,0,1,0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(255,0,0)
	label.TextScaled = true
	label.Text = enemy.Name
end

for _, enemy in ipairs(enemyFolder:GetChildren()) do
	addESP(enemy)
end

enemyFolder.ChildAdded:Connect(addESP)

---------------------------------------------------------------------
-- FIND NEAREST HEAD (THROUGH WALLS)
---------------------------------------------------------------------
local function getNearestHead()
	local nearest, shortestDist = nil, math.huge
	local mousePos = UserInputService:GetMouseLocation()

	for _, enemy in ipairs(enemyFolder:GetChildren()) do
		local head = enemy:FindFirstChild("Head")
		if head then
			local screenPos = camera:WorldToViewportPoint(head.Position)
			local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude

			if dist < shortestDist then
				shortestDist = dist
				nearest = head
			end
		end
	end
	return nearest
end

---------------------------------------------------------------------
-- SILENT AIM SUPPORT
---------------------------------------------------------------------
local targetForBullets = nil

local function getSilentAimTarget()
	if not aimbotEnabled then return nil end
	return getNearestHead()
end

local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, key)
	if silentAimEnabled and key == "Hit" and tostring(self) == "Mouse" then
		local silentTarget = getSilentAimTarget()
		if silentTarget then
			return silentTarget.CFrame
		end
	end
	return oldIndex(self, key)
end)

---------------------------------------------------------------------
-- AIMBOT LOOP (SNAP + FOV)
---------------------------------------------------------------------
RunService.RenderStepped:Connect(function()
	-- Update FOV circle
	local mousePos = UserInputService:GetMouseLocation()
	fovCircle.Position = mousePos

	if not aimbotEnabled then return end

	local head = getNearestHead()
	if head then
		targetForBullets = head

		-- Snap instantly to head
		camera.CFrame = CFrame.new(camera.CFrame.Position, head.Position)
	end
end)
