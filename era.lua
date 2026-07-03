--[[
    DROPKICK SCRIPT v1.0
    Отбрасывает игроков при ударе
    Активация: нажмите G
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- Настройки
local SETTINGS = {
    KickForce = 250,        -- Сила отбрасывания
    KickRadius = 15,        -- Радиус действия
    UpwardForce = 60,       -- Сила подбрасывания вверх
    DamageAmount = 25,      -- Урон (0 - отключить)
    Cooldown = 0.5,         -- Задержка между ударами
    EffectEnabled = true,   -- Визуальные эффекты
    SoundEnabled = true     -- Звук удара
}

local cooldown = false

-- Функция создания эффекта
local function createEffect(position)
    if not SETTINGS.EffectEnabled then return end
    
    local explosion = Instance.new("Explosion")
    explosion.Parent = workspace
    explosion.Position = position
    explosion.BlastRadius = 5
    explosion.BlastPressure = 50000
    
    -- Добавляем частицы (звёздочки)
    for i = 1, 8 do
        local part = Instance.new("Part")
        part.Parent = workspace
        part.Shape = Enum.PartType.Ball
        part.Size = Vector3.new(0.5, 0.5, 0.5)
        part.Position = position + Vector3.new(
            math.random(-3, 3),
            math.random(-2, 4),
            math.random(-3, 3)
        )
        part.Velocity = Vector3.new(
            math.random(-40, 40),
            math.random(40, 100),
            math.random(-40, 40)
        )
        part.Material = Enum.Material.Neon
        part.BrickColor = BrickColor.new("Bright yellow")
        part.CanCollide = false
        game:GetService("Debris"):AddItem(part, 2)
    end
end

-- Функция отбрасывания
local function kickPlayer(target)
    if cooldown then return end
    if not target or not target.Character then return end
    
    local targetChar = target.Character
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    local targetHumanoid = targetChar:FindFirstChild("Humanoid")
    
    if not targetRoot or not targetHumanoid then return end
    if targetHumanoid.Health <= 0 then return end
    
    -- Направление удара
    local direction = (targetRoot.Position - root.Position).Unit
    
    -- Применяем силу
    targetRoot.Velocity = direction * SETTINGS.KickForce + Vector3.new(0, SETTINGS.UpwardForce, 0)
    
    -- Наносим урон
    if SETTINGS.DamageAmount > 0 then
        targetHumanoid:TakeDamage(SETTINGS.DamageAmount)
    end
    
    -- Эффекты
    createEffect(targetRoot.Position)
    
    -- Звук (используем встроенный)
    if SETTINGS.SoundEnabled then
        local sound = Instance.new("Sound")
        sound.Parent = targetRoot
        sound.SoundId = "rbxassetid://9120385555" -- Звук удара
        sound.Volume = 0.7
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 1)
    end
    
    cooldown = true
    task.wait(SETTINGS.Cooldown)
    cooldown = false
end

-- Поиск ближайшего игрока
local function getNearestPlayer()
    local nearest = nil
    local minDist = SETTINGS.KickRadius
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local dist = (plr.Character.HumanoidRootPart.Position - root.Position).Magnitude
            if dist < minDist then
                nearest = plr
                minDist = dist
            end
        end
    end
    
    return nearest
end

-- Активация по клавише G
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.G then
        local target = getNearestPlayer()
        if target then
            kickPlayer(target)
        end
    end
end)

-- Авто-режим (включить/выключить через /autokick)
local autoMode = false
local autoCooldown = 0

game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("OnMessageDoneFiltering").OnClientEvent:Connect(function(msg)
    if msg.FromSpeaker == player.Name and msg.Message:lower() == "/autokick" then
        autoMode = not autoMode
        player:Chat("Auto-kick: " .. (autoMode and "ON" or "OFF"))
    end
end)

-- Авто-кик в фоне
RunService.Heartbeat:Connect(function(deltaTime)
    if not autoMode then return end
    
    autoCooldown = autoCooldown + deltaTime
    if autoCooldown < SETTINGS.Cooldown then return end
    autoCooldown = 0
    
    local target = getNearestPlayer()
    if target then
        kickPlayer(target)
    end
end)

-- Создание GUI
local function createGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = player.PlayerGui
    
    local frame = Instance.new("Frame")
    frame.Parent = screenGui
    frame.Size = UDim2.new(0, 180, 0, 200)
    frame.Position = UDim2.new(0.02, 0, 0.3, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frame.BackgroundTransparency = 0.15
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.fromRGB(100, 100, 150)
    
    local title = Instance.new("TextLabel")
    title.Parent = frame
    title.Size = UDim2.new(1, 0, 0.2, 0)
    title.BackgroundTransparency = 1
    title.Text = "💥 DROPKICK"
    title.TextColor3 = Color3.fromRGB(255, 200, 50)
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    
    local kickBtn = Instance.new("TextButton")
    kickBtn.Parent = frame
    kickBtn.Size = UDim2.new(0.9, 0, 0.2, 0)
    kickBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
    kickBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    kickBtn.Text = "🔨 KICK"
    kickBtn.TextColor3 = Color3.new(1, 1, 1)
    kickBtn.Font = Enum.Font.GothamBold
    
    kickBtn.MouseButton1Click:Connect(function()
        local target = getNearestPlayer()
        if target then kickPlayer(target) end
    end)
    
    local autoBtn = Instance.new("TextButton")
    autoBtn.Parent = frame
    autoBtn.Size = UDim2.new(0.9, 0, 0.2, 0)
    autoBtn.Position = UDim2.new(0.05, 0, 0.5, 0)
    autoBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 150)
    autoBtn.Text = "🔄 AUTO: OFF"
    autoBtn.TextColor3 = Color3.new(1, 1, 1)
    autoBtn.Font = Enum.Font.GothamBold
    
    autoBtn.MouseButton1Click:Connect(function()
        autoMode = not autoMode
        autoBtn.Text = "🔄 AUTO: " .. (autoMode and "ON" or "OFF")
        autoBtn.BackgroundColor3 = autoMode and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(50, 50, 150)
    end)
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Parent = frame
    closeBtn.Size = UDim2.new(0.2, 0, 0.08, 0)
    closeBtn.Position = UDim2.new(0.8, 0, 0.01, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.Font = Enum.Font.GothamBold
    
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
end

-- Запуск GUI
task.wait(0.5)
createGUI()

-- Информация в чат
player:Chat("✅ Dropkick загружен! Нажми G для удара, /autokick для авто-режима")
