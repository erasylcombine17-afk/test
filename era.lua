local player = game.Players.LocalPlayer
local speedEnabled = false
local speedValue = 50

local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui

local main = Instance.new("Frame")
main.Parent = gui
main.Size = UDim2.new(0,220,0,140)
main.Position = UDim2.new(0,20,0.5,-70)
main.BackgroundColor3 = Color3.fromRGB(40,40,40)

local toggle = Instance.new("TextButton")
toggle.Parent = main
toggle.Size = UDim2.new(0,180,0,40)
toggle.Position = UDim2.new(0,20,0,10)
toggle.Text = "Speed OFF"
toggle.TextScaled = true
toggle.BackgroundColor3 = Color3.fromRGB(255,50,50)

local speedText = Instance.new("TextLabel")
speedText.Parent = main
speedText.Size = UDim2.new(0,180,0,30)
speedText.Position = UDim2.new(0,20,0,60)
speedText.Text = "Speed: "..speedValue
speedText.TextScaled = true
speedText.BackgroundColor3 = Color3.fromRGB(60,60,60)
speedText.TextColor3 = Color3.new(1,1,1)

local minus = Instance.new("TextButton")
minus.Parent = main
minus.Size = UDim2.new(0,50,0,30)
minus.Position = UDim2.new(0,20,0,100)
minus.Text = "-"
minus.TextScaled = true

local plus = Instance.new("TextButton")
plus.Parent = main
plus.Size = UDim2.new(0,50,0,30)
plus.Position = UDim2.new(0,150,0,100)
plus.Text = "+"
plus.TextScaled = true

local function updateSpeed()
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = speedEnabled and speedValue or 16
    end
    speedText.Text = "Speed: "..speedValue
end

toggle.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled

    if speedEnabled then
        toggle.Text = "Speed ON"
        toggle.BackgroundColor3 = Color3.fromRGB(50,255,50)
    else
        toggle.Text = "Speed OFF"
        toggle.BackgroundColor3 = Color3.fromRGB(255,50,50)
    end

    updateSpeed()
end)

plus.MouseButton1Click:Connect(function()
    speedValue = speedValue + 5
    updateSpeed()
end)

minus.MouseButton1Click:Connect(function()
    if speedValue > 16 then
        speedValue = speedValue - 5
    end
    updateSpeed()
end)

player.CharacterAdded:Connect(function()
    task.wait(1)
    updateSpeed()
end)
