local player = game.Players.LocalPlayer
local healing = false

local healAmount = 5
local healDelay = 1

local gui = Instance.new("ScreenGui", game.CoreGui)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,220,0,220)
frame.Position = UDim2.new(0,250,0.5,-100)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)

local healBtn = Instance.new("TextButton", frame)
healBtn.Size = UDim2.new(0,180,0,40)
healBtn.Position = UDim2.new(0,20,0,10)
healBtn.Text = "Heal OFF"

local amountLabel = Instance.new("TextLabel", frame)
amountLabel.Size = UDim2.new(0,180,0,30)
amountLabel.Position = UDim2.new(0,20,0,60)
amountLabel.Text = "HP: "..healAmount

local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size = UDim2.new(0,180,0,30)
speedLabel.Position = UDim2.new(0,20,0,130)
speedLabel.Text = "Delay: "..healDelay

local plus1 = Instance.new("TextButton", frame)
plus1.Size = UDim2.new(0,50,0,30)
plus1.Position = UDim2.new(0,150,0,95)
plus1.Text = "+HP"

local minus1 = Instance.new("TextButton", frame)
minus1.Size = UDim2.new(0,50,0,30)
minus1.Position = UDim2.new(0,20,0,95)
minus1.Text = "-HP"

local plus2 = Instance.new("TextButton", frame)
plus2.Size = UDim2.new(0,50,0,30)
plus2.Position = UDim2.new(0,150,0,165)
plus2.Text = "+SPD"

local minus2 = Instance.new("TextButton", frame)
minus2.Size = UDim2.new(0,50,0,30)
minus2.Position = UDim2.new(0,20,0,165)
minus2.Text = "-SPD"

healBtn.MouseButton1Click:Connect(function()
    healing = not healing
    healBtn.Text = healing and "Heal ON" or "Heal OFF"
end)

plus1.MouseButton1Click:Connect(function()
    healAmount += 5
    amountLabel.Text = "HP: "..healAmount
end)

minus1.MouseButton1Click:Connect(function()
    healAmount = math.max(1, healAmount - 5)
    amountLabel.Text = "HP: "..healAmount
end)

plus2.MouseButton1Click:Connect(function()
    healDelay += 0.5
    speedLabel.Text = "Delay: "..healDelay
end)

minus2.MouseButton1Click:Connect(function()
    healDelay = math.max(0.1, healDelay - 0.5)
    speedLabel.Text = "Delay: "..healDelay
end)

task.spawn(function()
    while true do
        task.wait(healDelay)
        if healing then
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") then
                local hum = char.Humanoid
                hum.Health = math.min(hum.MaxHealth, hum.Health + healAmount)
            end
        end
    end
end)
