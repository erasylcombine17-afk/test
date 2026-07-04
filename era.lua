-- FULL DELTA GUI SCRIPT
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera

local flying = false
local noclip = false
local flySpeed = 50
local bv

local keys = {
	W=false,A=false,S=false,D=false,
	Space=false,Shift=false
}

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,270,0,260)
frame.Position = UDim2.new(0.75,0,0.1,0)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.Active = true

local top = Instance.new("Frame", frame)
top.Size = UDim2.new(1,0,0,30)
top.BackgroundColor3 = Color3.fromRGB(20,20,20)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(0.6,0,1,0)
title.Text = "Delta GUI"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)

local minimize = Instance.new("TextButton", top)
minimize.Size = UDim2.new(0,30,0,30)
minimize.Position = UDim2.new(1,-60,0,0)
minimize.Text = "_"

local close = Instance.new("TextButton", top)
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-30,0,0)
close.Text = "X"

local minimized = false
minimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		frame.Size = UDim2.new(0,270,0,30)
	else
		frame.Size = UDim2.new(0,270,0,260)
	end
end)

close.MouseButton1Click:Connect(function()
	frame.Visible = false
end)

-- Speed
local speedBox = Instance.new("TextBox", frame)
speedBox.Size = UDim2.new(0,220,0,35)
speedBox.Position = UDim2.new(0,25,0,45)
speedBox.PlaceholderText = "Speed"

local speedBtn = Instance.new("TextButton", frame)
speedBtn.Size = UDim2.new(0,220,0,30)
speedBtn.Position = UDim2.new(0,25,0,85)
speedBtn.Text = "Apply Speed"

speedBtn.MouseButton1Click:Connect(function()
	local speed = tonumber(speedBox.Text)
	if speed then
		hum.WalkSpeed = speed
	end
end)

-- Fly Speed
local flyBox = Instance.new("TextBox", frame)
flyBox.Size = UDim2.new(0,220,0,35)
flyBox.Position = UDim2.new(0,25,0,120)
flyBox.PlaceholderText = "Fly Speed"

local flyBtn = Instance.new("TextButton", frame)
flyBtn.Size = UDim2.new(0,105,0,35)
flyBtn.Position = UDim2.new(0,25,0,165)
flyBtn.Text = "Fly OFF"

local noclipBtn = Instance.new("TextButton", frame)
noclipBtn.Size = UDim2.new(0,105,0,35)
noclipBtn.Position = UDim2.new(0,140,0,165)
noclipBtn.Text = "Noclip OFF"

flyBtn.MouseButton1Click:Connect(function()
	local val = tonumber(flyBox.Text)
	if val then flySpeed = val end

	flying = not flying
	if flying then
		bv = Instance.new("BodyVelocity")
		bv.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
		bv.Parent = root
		flyBtn.Text = "Fly ON"
	else
		if bv then bv:Destroy() end
		flyBtn.Text = "Fly OFF"
	end
end)

noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	noclipBtn.Text = noclip and "Noclip ON" or "Noclip OFF"
end)

-- Keys
UIS.InputBegan:Connect(function(input,gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.W then keys.W = true end
	if input.KeyCode == Enum.KeyCode.A then keys.A = true end
	if input.KeyCode == Enum.KeyCode.S then keys.S = true end
	if input.KeyCode == Enum.KeyCode.D then keys.D = true end
	if input.KeyCode == Enum.KeyCode.Space then keys.Space = true end
	if input.KeyCode == Enum.KeyCode.LeftShift then keys.Shift = true end
end)

UIS.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.W then keys.W = false end
	if input.KeyCode == Enum.KeyCode.A then keys.A = false end
	if input.KeyCode == Enum.KeyCode.S then keys.S = false end
	if input.KeyCode == Enum.KeyCode.D then keys.D = false end
	if input.KeyCode == Enum.KeyCode.Space then keys.Space = false end
	if input.KeyCode == Enum.KeyCode.LeftShift then keys.Shift = false end
end)

RunService.Heartbeat:Connect(function()
	if flying and bv then
		local moveDir = Vector3.zero

		if keys.W then moveDir += camera.CFrame.LookVector end
		if keys.S then moveDir -= camera.CFrame.LookVector end
		if keys.A then moveDir -= camera.CFrame.RightVector end
		if keys.D then moveDir += camera.CFrame.RightVector end
		if keys.Space then moveDir += Vector3.new(0,1,0) end
		if keys.Shift then moveDir -= Vector3.new(0,1,0) end

		if moveDir.Magnitude > 0 then
			bv.Velocity = moveDir.Unit * flySpeed
		else
			bv.Velocity = Vector3.zero
		end
	end

	if noclip then
		for _,v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

-- Drag GUI
local dragging = false
local dragStart
local startPos

top.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)
