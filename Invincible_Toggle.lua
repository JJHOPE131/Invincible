local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local toggle = Instance.new("RemoteEvent")
toggle.Name = "ToggleGodMode"
toggle.Parent = ReplicatedStorage

local godMode = {}

Players.PlayerAdded:Connect(function(player)
	godMode[player] = false

	player.CharacterAdded:Connect(function(char)
		local hum = char:WaitForChild("Humanoid")

		hum.HealthChanged:Connect(function(h)
			if godMode[player] then
				hum.Health = hum.MaxHealth
			end
		end)

		task.spawn(function()
			while hum.Parent do
				if godMode[player] then
					hum.MaxHealth = math.huge
					hum.Health = hum.MaxHealth
				end
				task.wait(0.05)
			end
		end)
	end)
end)

toggle.OnServerEvent:Connect(function(player, state)
	godMode[player] = state
end)
