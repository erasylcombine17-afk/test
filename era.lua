-- Простой Dropkick без взрывов и без перетаскивания

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

-- ===== СОЗДАЁМ КВАДРАТНУЮ КНОПКУ (НЕПОДВИЖНУЮ) =====
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui
screenGui.Name = "DropkickGUI"
screenGui.ResetOnSpawn = false

local button = Instance.new("TextButton")
button.Parent = screenGui
button.Size = UDim2.new(0, 80, 0, 80)  -- Квадрат 80x80
button.Position = UDim2.new(0.5, -40, 0.75, 0)  -- По центру внизу
button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
button.BorderSizePixel = 3
button.BorderColor3 = Color3.fromRGB(255, 200, 50)
button.Text = "💥\nKICK"
button.TextColor3 = Color3.new(1, 1, 1)
button.TextSize = 18
button.Font = Enum.Font.GothamBold
button.TextWrapped = true
button.Active = false  -- Запрещаем перетаскивание
button.Draggable = false  -- Запрещаем перетаскивание

-- ===== ФУНКЦИЯ ОТБРАСЫВАНИЯ (БЕЗ ВЗРЫВОВ) =====
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
                    
                    -- ❌ ВЗРЫВОВ НЕТ!
                end
            end
        end
    end
end

-- ===== НАЖАТИЕ НА КНОПКУ =====
button.MouseButton1Click:Connect(function()
    kickAll()
    
    -- Анимация нажатия (мигание)
    button.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    task.wait(0.1)
    button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
end)

print("✅ Кнопка Dropkick создана! Кнопка НЕ двигается!")
player:Chat("💥 Кнопка Dropkick готова! Нажми на красный квадрат!")
