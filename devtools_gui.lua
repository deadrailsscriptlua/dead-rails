
-- DevTools GUI v2 (One Panel, Full Features)
-- Use with: loadstring(game:HttpGet("https://raw.githubusercontent.com/youruser/yourrepo/main/devtools_gui.lua"))()

pcall(function()
    local player = game.Players.LocalPlayer
    local mouse = player:GetMouse()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local hrp = character:WaitForChild("HumanoidRootPart")

    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)

    local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    gui.Name = "DevToolsGui"

    local frame = Instance.new("Frame", gui)
    frame.Name = "DevToolsFrame"
    frame.Size = UDim2.new(0, 300, 0, 480)
    frame.Position = UDim2.new(0, 20, 0.5, -240)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

    local status = Instance.new("TextLabel", frame)
    status.Size = UDim2.new(1, 0, 0, 30)
    status.Position = UDim2.new(0, 0, 1, -30)
    status.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    status.TextColor3 = Color3.new(1,1,1)
    status.Text = "Status: Ready"
    status.Font = Enum.Font.SourceSans
    status.TextSize = 16

    local y = 0
    local function createBtn(text, callback)
        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(1, 0, 0, 35)
        btn.Position = UDim2.new(0, 0, 0, y)
        y = y + 40
        btn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
        btn.Text = text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 18
        btn.MouseButton1Click:Connect(callback)
    end

    function setStatus(text)
        status.Text = "Status: " .. text
    end

    createBtn("Collect Bonds", function()
        setStatus("Collecting Bonds")
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("TouchTransmitter") and v.Parent.Name:lower():find("bond") then
                firetouchinterest(hrp, v.Parent, 0)
                firetouchinterest(hrp, v.Parent, 1)
            end
        end
    end)

    createBtn("Complete Quests", function()
        setStatus("Doing Quests")
        for _, p in pairs(workspace:GetDescendants()) do
            if p:IsA("ProximityPrompt") and p.Name:lower():find("quest") then
                fireproximityprompt(p)
            end
        end
    end)

    local god = false
    createBtn("Godmode", function(btn)
        god = not god
        if god then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
        else
            humanoid.MaxHealth = 100
            humanoid.Health = 100
        end
        setStatus("Godmode: " .. tostring(god))
    end)

    local noclip = false
    createBtn("Noclip", function(btn)
        noclip = not noclip
        setStatus("Noclip: " .. tostring(noclip))
    end)

    game:GetService("RunService").Stepped:Connect(function()
        if noclip then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)

    createBtn("Auto Win", function()
        setStatus("Triggering Win")
        local remote = game.ReplicatedStorage:FindFirstChild("CompleteQuest")
        if remote and remote:IsA("RemoteEvent") then
            for i = 1, 5 do
                remote:FireServer("AutoComplete", i)
                wait(0.2)
            end
        end
    end)

    local afk = false
    createBtn("AFK Mode", function()
        afk = not afk
        if afk then
            spawn(function()
                while afk do
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "W", false, game)
                    wait(1)
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, "W", false, game)
                    wait(3)
                end
            end)
        end
        setStatus("AFK: " .. tostring(afk))
    end)

    createBtn("Teleport: Spawn", function()
        hrp.CFrame = CFrame.new(Vector3.new(0, 10, 0))
        setStatus("Teleported to Spawn")
    end)

    createBtn("Toggle ESP (Players)", function()
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                local box = Instance.new("BoxHandleAdornment", plr.Character)
                box.Size = Vector3.new(3, 6, 2)
                box.Color3 = Color3.new(1,0,0)
                box.Transparency = 0.5
                box.AlwaysOnTop = true
                box.Adornee = plr.Character:FindFirstChild("HumanoidRootPart")
            end
        end
        setStatus("ESP On")
    end)

    if player.UserId == 123456789 then
        createBtn("ADMIN: Kill All", function()
            for _,plr in pairs(game.Players:GetPlayers()) do
                if plr.Character and plr ~= player then
                    plr.Character:BreakJoints()
                end
            end
            setStatus("Killed all")
        end)
    end

    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightShift then
            frame.Visible = not frame.Visible
        end
    end)
end)
