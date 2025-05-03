
-- Full Apex Hub Script with Quest Features and Kill Aura
local ApexHub = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local Title = Instance.new("TextLabel")

-- Insert GUI into PlayerGui
ApexHub.Name = "ApexHub"
ApexHub.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ApexHub.ResetOnSpawn = false

-- Main GUI styling
Main.Name = "Main"
Main.Parent = ApexHub
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.Position = UDim2.new(0.3, 0, 0.2, 0)
Main.Size = UDim2.new(0, 400, 0, 500)
Main.BorderSizePixel = 0

-- Title
Title.Name = "Title"
Title.Parent = Main
Title.Text = "🚀 Apex Hub"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 24
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- Function Button Creator
local function createButton(text, order, callback)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, 50 + (order * 40))
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.Parent = Main
    btn.MouseButton1Click:Connect(callback)
end

-- FPS Boost
local function optimizePerformance()
    -- FPS optimization logic (example)
    print("[FPS Boost] Optimizing performance...")
    -- Add your FPS boost optimization code here
end

-- Auto Farm Function
local function autoFarm()
    -- Auto Farm logic to collect bonds and win
    print("[Auto Farm] Starting to collect bonds and win the game...")
    -- Add your Auto Farm logic here
end

-- Auto Loot Function
local function autoLoot()
    -- Auto Loot logic to collect loot items
    print("[Auto Loot] Collecting loot items...")
    -- Add your Auto Loot logic here
end

-- Auto Quest Completion
local function autoCompleteQuest()
    local player = game.Players.LocalPlayer
    local character = player.Character
    local questProgress = {["Collect 10 Bonds"] = 0, ["Defeat 5 Enemies"] = 0}

    -- Function to track collection of items
    local function trackCollection()
        for _, item in pairs(workspace:GetChildren()) do
            if item:IsA("Part") and item.Name == "Bond" then
                -- Collect bond and increase progress
                local bondPosition = item.Position
                character.HumanoidRootPart.CFrame = CFrame.new(bondPosition)
                wait(0.5)
                item:Destroy()  
                questProgress["Collect 10 Bonds"] = questProgress["Collect 10 Bonds"] + 1
                print("[Auto Quest] Collected a bond. Progress: " .. questProgress["Collect 10 Bonds"] .. "/10")
            end
        end
    end

    -- Function to track defeating enemies
    local function trackDefeatingEnemies()
        for _, npc in pairs(workspace:GetChildren()) do
            if npc:IsA("Model") and npc.Name == "Enemy" then
                local enemyPosition = npc.PrimaryPart.Position
                character.HumanoidRootPart.CFrame = CFrame.new(enemyPosition)
                wait(0.5)
                npc:Destroy()  
                questProgress["Defeat 5 Enemies"] = questProgress["Defeat 5 Enemies"] + 1
                print("[Auto Quest] Defeated an enemy. Progress: " .. questProgress["Defeat 5 Enemies"] .. "/5")
            end
        end
    end

    -- Loop to track quests progress
    while true do
        if questProgress["Collect 10 Bonds"] < 10 then
            trackCollection()
        end

        if questProgress["Defeat 5 Enemies"] < 5 then
            trackDefeatingEnemies()
        end

        if questProgress["Collect 10 Bonds"] == 10 then
            print("[Auto Quest] Completed 'Collect 10 Bonds' quest!")
            questProgress["Collect 10 Bonds"] = "Completed"
        end

        if questProgress["Defeat 5 Enemies"] == 5 then
            print("[Auto Quest] Completed 'Defeat 5 Enemies' quest!")
            questProgress["Defeat 5 Enemies"] = "Completed"
        end

        wait(5)  
    end
end

-- Kill Aura: Automatically damages nearby enemies
local function killAura()
    local player = game.Players.LocalPlayer
    local character = player.Character
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local damageRadius = 10  
    local damageAmount = 50  

    local function applyDamage(enemy)
        if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") then
            local humanoid = enemy:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                humanoid:TakeDamage(damageAmount)
                print("[Kill Aura] Damaged enemy: " .. enemy.Name)
            end
        end
    end

    while true do
        for _, enemy in pairs(workspace:GetChildren()) do
            if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") then
                local enemyHumanoidRootPart = enemy:FindFirstChild("HumanoidRootPart")
                if enemyHumanoidRootPart then
                    local distance = (humanoidRootPart.Position - enemyHumanoidRootPart.Position).Magnitude
                    if distance <= damageRadius then
                        applyDamage(enemy)
                    end
                end
            end
        end
        wait(1)  
    end
end

-- Add buttons for all features
createButton("Optimize Performance (FPS Boost)", 14, optimizePerformance)
createButton("Start Auto Farm (Collect Bonds & Win)", 15, autoFarm)
createButton("Start Auto Loot (Collect Loot Items)", 16, autoLoot)
createButton("Start Auto Quest Completion", 17, autoCompleteQuest)
createButton("Activate Kill Aura", 20, killAura)

print("✅ Apex Hub fully loaded with all features!")
