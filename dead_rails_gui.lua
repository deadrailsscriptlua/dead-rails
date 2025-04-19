
-- dead_rails_gui.lua
local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local CoreGui = game:GetService("StarterGui")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")

local Cooldown = 0.1
local TrackCount = 1
local BondCount = 0
local TrackPassed = false
local FoundLobby = false
local AFK = false
local AutoFarm = false

-- Bind Remotes
local CreateParty = RS:WaitForChild("Shared"):WaitForChild("CreatePartyClient")
local CollectBond = RS:WaitForChild("Packages"):WaitForChild("ActivateObjectClient")

-- UI Setup
local ScreenGui = Instance.new("ScreenGui", plr:WaitForChild("PlayerGui"))
ScreenGui.Name = "DeadRailsAutoGui"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 200, 0, 160)
Main.Position = UDim2.new(0, 20, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.BackgroundTransparency = 0.1

local function createButton(name, yPos, callback)
	local btn = Instance.new("TextButton", Main)
	btn.Size = UDim2.new(1, -10, 0, 35)
	btn.Position = UDim2.new(0, 5, 0, yPos)
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
	btn.MouseButton1Click:Connect(callback)
end

createButton("Toggle AFK", 5, function()
	AFK = not AFK
	hrp.Anchored = AFK
	print("AFK is now", AFK)
end)

createButton("Toggle AutoFarm", 45, function()
	AutoFarm = not AutoFarm
	print("AutoFarm is now", AutoFarm)
end)

createButton("Force Teleport to Lobby", 85, function()
	TeleportService:Teleport(116495829188952, plr)
end)

createButton("Close", 125, function()
	ScreenGui:Destroy()
end)

-- Place ID Check
task.spawn(function()
	while task.wait(Cooldown) do
		if not AutoFarm then continue end

		if game.PlaceId == 116495829188952 then -- LOBBY
			if not FoundLobby then
				for _, v in pairs(WS.TeleportZones:GetChildren()) do
					if v.Name == "TeleportZone" and v:FindFirstChild("BillboardGui") and v.BillboardGui.StateLabel.Text == "Waiting for players..." then
						print("Lobby Found! Joining...")
						hrp.CFrame = v.ZoneContainer.CFrame
						FoundLobby = true
						task.wait(1)
						CreateParty:FireServer({["maxPlayers"] = 1})
					end
				end
			end

		elseif game.PlaceId == 70876832253163 then -- TRACK
			local StartingTrack = WS:FindFirstChild("RailSegments"):FindFirstChild("RailSegment")
			local Items = WS:FindFirstChild("RuntimeItems")

			if not StartingTrack or not Items then return end
			hrp.Anchored = AFK

			while task.wait(Cooldown) and AutoFarm do
				if not TrackPassed then
					print("Teleporting to track", TrackCount)
					hrp.CFrame = StartingTrack.Guide.CFrame + Vector3.new(0, 250, 0)
					TrackPassed = true
				end

				if StartingTrack:FindFirstChild("NextTrack") and StartingTrack.NextTrack.Value then
					StartingTrack = StartingTrack.NextTrack.Value
					TrackCount += 1
				else
					TeleportService:Teleport(116495829188952, plr)
					break
				end

				for _, item in pairs(Items:GetChildren()) do
					if item.Name == "Bond" or item.Name == "BondCalculated" then
						coroutine.wrap(function()
							for i = 1, 100 do
								pcall(function()
									item.Part.CFrame = hrp.CFrame
								end)
							end
							CollectBond:FireServer(item)
						end)()

						if item.Name == "Bond" then
							item.Name = "BondCalculated"
							BondCount += 1
							print("Collected bond:", BondCount)
						end
					end
				end

				if not Items:FindFirstChild("Bond") then
					TrackPassed = false
				end
			end
		end
	end
end)
