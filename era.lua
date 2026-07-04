local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

local healing = false
local healAmount = 5
local healDelay = 1

local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0,220,0,220)
frame.Position = UDim2.new(0,250,0.5,-100)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)

local dragging = false
local dragStart
local startPos

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

frame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

local healBtn = Instance.new("TextButton", frame)
healBtn.Size = UDim2.new(0,180,0,40)
healBtn.Position = UDim2.new(0,20,0,10)
healBtn.Text = "Heal OFF"

local amountLabel = Instance.new("TextLabel", frame)
amountLabel.Size = UDim2.new(0,180,0,30)
amountLabel.Position = UDim2.new(0,20,0,60)
amountLabel.Text = "HP: "..healAmount

local hpBox = Instance.new("TextBox", frame)
hpBox.Size = UDim2.new(0,180,0,30)
hpBox.Position = UDim2.new(0,20,0,95)
hpBox.Text = tostring(healAmount)
hpBox.PlaceholderText = "Введите HP"

local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size = UDim2.new(0,180,0,30)
speedLabel.Position = UDim2.new(0,20,0,130)
speedLabel.Text = "Delay: "..healDelay

local delayBox = Instance.new("TextBox", frame)
delayBox.Size = UDim2.new(0,180,0,30)
delayBox.Position = UDim2.new(0,20,0,165)
delayBox.Text = tostring(healDelay)
delayBox.PlaceholderText = "Введите Delay"

healBtn.MouseButton1Click:Connect(function()
	healing = not healing
	healBtn.Text = healing and "Heal ON" or "Heal OFF"
end)

hpBox.FocusLost:Connect(function()
	local value = tonumber(hpBox.Text)
	if value and value > 0 then
		healAmount = value
		amountLabel.Text = "HP: "..healAmount
	else
		hpBox.Text = tostring(healAmount)
	end
end)

delayBox.FocusLost:Connect(function()
	local value = tonumber(delayBox.Text)
	if value and value > 0 then
		healDelay = value
		speedLabel.Text = "Delay: "..healDelay
	else
		delayBox.Text = tostring(healDelay)
	end
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
