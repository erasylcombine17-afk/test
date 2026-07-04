local Players = game:GetService("Players")
local player = Players.LocalPlayer

local healEnabled = false
local healAmount = 5
local healRadius = 5

local healButton = Instance.new("TextButton")
healButton.Parent = main
healButton.Size = UDim2.new(0,180,0,40)
healButton.Position = UDim2.new(0,20,0,140)
healButton.Text = "Healing OFF"
healButton.TextScaled = true
healButton.BackgroundColor3 = Color3.fromRGB(255,50,50)

main.Size = UDim2.new(0,220,0,190)

healButton.MouseButton1Click:Connect(function()
    healEnabled = not healEnabled

    if healEnabled then
        healButton.Text = "Healing ON"
        healButton.BackgroundColor3 = Color3.fromRGB(50,255,50)
    else
        healButton.Text = "Healing OFF"
        healButton.BackgroundColor3 = Color3.fromRGB(255,50,50)
    end
end)

task.spawn(function()
    while true do
        task.wait(1)

        if healEnabled then
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
                local humanoid = char.Humanoid
                local root = char.HumanoidRootPart

                humanoid.Health = math.min(humanoid.MaxHealth, humanoid.Health + healAmount)

                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= player and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local targetRoot = plr.Character.HumanoidRootPart
                        local distance = (targetRoot.Position - root.Position).Magnitude

                        if distance <= healRadius then
                            local targetHum = plr.Character.Humanoid
                            targetHum.Health = math.min(targetHum.MaxHealth, targetHum.Health + healAmount)
                        end
                    end
                end
            end
        end
    end
end)
