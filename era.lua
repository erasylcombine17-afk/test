local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

-- ===== СОЗДАЁМ КВАДРАТНУЮ КНОПКУ =====
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui
screenGui.Name = "DropkickGUI"
screenGui.ResetOnSpawn = false

local button = Instance.new("TextButton")
button.Parent = screenGui
button.Size = UDim2.new(0, 80, 0, 80)  -- Квадрат 80x80
button.Position = UDim2.new(0.5, -40, 0.7, 0)  -- По центру внизу
button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
button.BorderSizePixel = 3
button.BorderColor3 = Color3.fromRGB(255, 200, 50)
button.Text = "💥\nKICK"
button.TextColor3 = Color3.new(1, 1, 1)
button.TextSize = 18
button.Font = Enum.Font.GothamBold
button.TextWrapped = true

-- ===== ФУНКЦИЯ ОТБРАСЫВАНИЯ =====
local function kickAll()
    local radius = 25  -- Радиус поражения
    
    for _, target in pairs(Players:GetPlayers()) do
        if target ~= player and target.Character then
            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            local targetHum = target.Character:FindFirstChild("Humanoid")
            
            if targetRoot and targetHum and targetHum.Health > 0 then
                local dist = (targetRoot.Position - root.Position).Magnitude
                if dist <= radius then
                    -- Направление от игрока
                    local direction = (targetRoot.Position - root.Position).Unit
                    
                    -- Отбрасываем с силой 250 и подбрасываем вверх на 60
                    targetRoot.Velocity = direction * 250 + Vector3.new(0, 60, 0)
                    
                    -- Урон (20)
                    targetHum:TakeDamage(20)
                    
                    -- Эффект взрыва
                    local explosion = Instance.new("Explosion")
                    explosion.Parent = workspace
                    explosion.Position = targetRoot.Position
                    explosion.BlastRadius = 3
                    explosion.BlastPressure = 50000
                end
            end
        end
    end
end

-- ===== НАЖАТИЕ НА КНОПКУ =====
button.MouseButton1Click:Connect(function()
    kickAll()
    
    -- Анимация нажатия
    button.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    task.wait(0.1)
    button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
end)

-- ===== ПЕРЕМЕЩЕНИЕ КНОПКИ (ПЕРЕТАСКИВАНИЕ) =====
local dragging = false
local dragStart
local startPos

button.MouseButton1Down:Connect(function()
    dragging = true
    dragStart = Vector2.new(button.AbsolutePosition.X, button.AbsolutePosition.Y)
    startPos = UDim2.new(button.Position.X.Scale, button.Position.X.Offset, 
                         button.Position.Y.Scale, button.Position.Y.Offset)
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if dragging then
        local mouse = player:GetMouse()
        local delta = Vector2.new(mouse.X, mouse.Y) - dragStart
        button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                     startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

print("✅ Кнопка Dropkick создана! Нажимай - все разлетаются!")
player:Chat("💥 Кнопка Dropkick готова! Нажми на красный квадрат!")
