task.spawn(function()
    while true do
        task.wait(0.05)

        if healEnabled then
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
                local humanoid = char.Humanoid
                local root = char.HumanoidRootPart

                humanoid.Health = humanoid.MaxHealth

                for _, plr in pairs(game.Players:GetPlayers()) do
                    if plr ~= player and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local targetRoot = plr.Character.HumanoidRootPart
                        local distance = (targetRoot.Position - root.Position).Magnitude

                        if distance <= healRadius then
                            plr.Character.Humanoid.Health = plr.Character.Humanoid.MaxHealth
                        end
                    end
                end
            end
        end
    end
end)
