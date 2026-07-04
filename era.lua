-- Dropkick с переключаемой кнопкой и ударом двумя ногами

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- ===== НАСТРОЙКИ =====
local CONFIG = {
    KickForce = 200,        -- Сила отбрасывания
    UpwardForce = 50,       -- Подбрасывание вверх
    Radius = 25,            -- Радиус действия
    Damage = 20,            -- Урон
    Cooldown = 0.3,         -- Задержка между ударами
}

-- ===== СОЗДАЁМ КНОПКУ =====
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui
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

-- ===== ПЕРЕМЕННЫЕ =====
local isActive = false
local cooldownTimer = 0

-- ===== ФУНКЦИЯ УДАРА ДВУМЯ НОГАМИ =====
local function kickWithBothLegs()
    if cooldownTimer > 0 then return end
    
    local kicked = 0
    
    for _, target in pairs(Players:GetPlayers()) do
        if target ~= player and target.Character then
            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            local targetHum = target.Character:FindFirstChild("Humanoid")
            
            if targetRoot and targetHum and targetHum.Health > 0 then
                local dist = (targetRoot.Position - root.Position).Magnitude
                if dist <= CONFIG.Radius then
                    -- Направление от игрока
                    local direction = (targetRoot.Position - root.Position).Unit
                    
                    -- УДАР ДВУМЯ НОГАМИ (два импульса с задержкой)
                    -- Первый удар (левая нога)
                    targetRoot.Velocity = direction * CONFIG.KickForce * 0.7 + Vector3.new(0, CONFIG.UpwardForce * 0.8, 0)
                    
                    -- Второй удар (правая нога) через 0.05 секунды
                    task.spawn(function()
                        task.wait(0.05)
                        if targetRoot and targetRoot.Parent then
                            local direction2 = (targetRoot.Position - root.Position).Unit
                            targetRoot.Velocity = direction2 * CONFIG.KickForce * 0.7 + Vector3.new(0, CONFIG.UpwardForce * 0.8, 0)
                        end
                    end)
                    
                    -- Основная сила (двойной удар)
                    task.spawn(function()
                        task.wait(0.1)
                        if targetRoot and targetRoot.Parent then
                            local direction3 = (targetRoot.Position - root.Position).Unit
                            targetRoot.Velocity = direction3 * CONFIG.KickForce + Vector3.new(0, CONFIG.UpwardForce, 0)
                        end
                    end)
                    
                    -- Урон
                    if CONFIG.Damage > 0 then
                        targetHum:TakeDamage(CONFIG.Damage)
                    end
                    
                    kicked = kicked + 1
                end
            end
        end
    end
    
    -- Кулдаун
    cooldownTimer = CONFIG.Cooldown
    
    return kicked
end

-- ===== ПЕРЕКЛЮЧЕНИЕ КНОПКИ =====
button.MouseButton1Click:Connect(function()
    isActive = not isActive
    
    if isActive then
        button.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        button.BorderColor3 = Color3.fromRGB(100, 255, 100)
        button.Text = "🟢 ВКЛ"
        player:Chat("💥 Dropkick ВКЛЮЧЁН! Бью двумя ногами!")
    else
        button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        button.BorderColor3 = Color3.fromRGB(255, 200, 50)
        button.Text = "🔴 ВЫКЛ"
        player:Chat("❌ Dropkick ВЫКЛЮЧЁН")
    end
end)

-- ===== АВТОМАТИЧЕСКИЕ УДАРЫ =====
RunService.Heartbeat:Connect(function(deltaTime)
    -- Обновляем кулдаун
    if cooldownTimer > 0 then
        cooldownTimer = cooldownTimer - deltaTime
        if cooldownTimer < 0 then cooldownTimer = 0 end
    end
    
    -- Если включено - бьём
    if isActive then
        kickWithBothLegs()
    end
end)

-- ===== ВИЗУАЛЬНЫЙ ЭФФЕКТ ПРИ УДАРЕ (ноги) =====
local function createKickEffect(position)
    -- Создаём след от ног (просто для красоты)
    local part = Instance.new("Part")
    part.Parent = workspace
    part.Shape = Enum.PartType.Block
    part.Size = Vector3.new(2, 0.5, 1)
    part.Position = position
    part.Material = Enum.Material.Neon
    part.BrickColor = BrickColor.new("Bright red")
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 0.5
    game:GetService("Debris"):AddItem(part, 0.3)
    
    -- Второй след (вторая нога)
    task.wait(0.05)
    local part2 = Instance.new("Part")
    part2.Parent = workspace
    part2.Shape = Enum.PartType.Block
    part2.Size = Vector3.new(2, 0.5, 1)
    part2.Position = position + Vector3.new(0, 0, 1)
    part2.Material = Enum.Material.Neon
    part2.BrickColor = BrickColor.new("Bright orange")
    part2.Anchored = true
    part2.CanCollide = false
    part2.Transparency = 0.5
    game:GetService("Debris"):AddItem(part2, 0.3)
end

-- ===== ИНФОРМАЦИЯ =====
print("✅ Dropkick с двумя ногами загружен!")
player:Chat("💥 Нажми на кнопку чтобы включить/выключить!")
player:Chat("🦵 Удар ДВУМЯ НОГАМИ! Сила: 200")

-- Создаём инструкцию на экране
local instruction = Instance.new("TextLabel")
instruction.Parent = screenGui
instruction.Size = UDim2.new(0, 200, 0, 30)
instruction.Position = UDim2.new(0.5, -100, 0.65, 0)
instruction.BackgroundTransparency = 1
instruction.Text = "🦵 Нажми для переключения"
instruction.TextColor3 = Color3.fromRGB(255, 255, 255)
instruction.TextSize = 14
instruction.Font = Enum.Font.Gotham
instruction.TextStrokeTransparency = 0.5
instruction.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
