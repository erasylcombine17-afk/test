sectionFun:Button("🦵 Удар двумя ногами", function()
    pcall(function()
        -- ===== БЕССМЕРТИЕ =====
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.MaxHealth = math.huge
            hum.Health = math.huge
        end
        
        -- ===== СКРИПТ УДАРА ДВУМЯ НОГАМИ =====
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local LocalPlayer = Players.LocalPlayer
        local root = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        
        local CONFIG = {
            KickForce = 200,
            UpwardForce = 55,
            Radius = 30,
            Cooldown = 0.25,
        }
        
        -- Создаём кнопку
        local screenGui = Instance.new("ScreenGui")
        screenGui.Parent = LocalPlayer.PlayerGui
        screenGui.Name = "DropkickGUI"
        screenGui.ResetOnSpawn = false
        
        local button = Instance.new("TextButton")
        button.Parent = screenGui
        button.Size = UDim2.new(0, 90, 0, 90)
        button.Position = UDim2.new(0.5, -45, 0.75, 0)
        button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        button.BorderSizePixel = 3
        button.BorderColor3 = Color3.fromRGB(255, 200, 50)
        button.Text = "🔴 ВЫКЛ"
        button.TextColor3 = Color3.new(1, 1, 1)
        button.TextSize = 16
        button.Font = Enum.Font.GothamBold
        button.TextWrapped = true
        button.Active = false
        button.Draggable = false
        
        local isActive = false
        local cooldownTimer = 0
        
        -- Удар двумя ногами
        local function kickWithBothLegs()
            if cooldownTimer > 0 then return end
            
            for _, target in pairs(Players:GetPlayers()) do
                if target ~= LocalPlayer and target.Character then
                    local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                    local targetHum = target.Character:FindFirstChild("Humanoid")
                    
                    if targetRoot and targetHum and targetHum.Health > 0 then
                        local dist = (targetRoot.Position - root.Position).Magnitude
                        if dist <= CONFIG.Radius then
                            local direction = (targetRoot.Position - root.Position).Unit
                            
                            -- Первый удар (левая нога)
                            targetRoot.Velocity = direction * CONFIG.KickForce * 0.6 + Vector3.new(0, CONFIG.UpwardForce * 0.7, 0)
                            
                            -- Второй удар (правая нога)
                            task.spawn(function()
                                task.wait(0.04)
                                if targetRoot and targetRoot.Parent then
                                    local direction2 = (targetRoot.Position - root.Position).Unit
                                    targetRoot.Velocity = direction2 * CONFIG.KickForce * 0.8 + Vector3.new(0, CONFIG.UpwardForce * 0.8, 0)
                                end
                            end)
                            
                            -- Третий удар (двойной)
                            task.spawn(function()
                                task.wait(0.09)
                                if targetRoot and targetRoot.Parent then
                                    local direction3 = (targetRoot.Position - root.Position).Unit
                                    targetRoot.Velocity = direction3 * CONFIG.KickForce + Vector3.new(0, CONFIG.UpwardForce, 0)
                                end
                            end)
                        end
                    end
                end
            end
            
            cooldownTimer = CONFIG.Cooldown
        end
        
        -- Переключение кнопки
        button.MouseButton1Click:Connect(function()
            isActive = not isActive
            
            if isActive then
                button.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
                button.BorderColor3 = Color3.fromRGB(100, 255, 100)
                button.Text = "🟢 ВКЛ"
            else
                button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                button.BorderColor3 = Color3.fromRGB(255, 200, 50)
                button.Text = "🔴 ВЫКЛ"
            end
        end)
        
        -- Авто-удары
        RunService.Heartbeat:Connect(function(deltaTime)
            if cooldownTimer > 0 then
                cooldownTimer = cooldownTimer - deltaTime
                if cooldownTimer < 0 then cooldownTimer = 0 end
            end
            
            if isActive then
                kickWithBothLegs()
            end
        end)
        
        Window:Notification("🦵 Удар двумя ногами", "Включите кнопку на экране!", "Success", 3)
    end)
end)
