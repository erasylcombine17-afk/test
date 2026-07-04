local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

local speed = 16

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,220,0,180)
frame.Position = UDim2.new(0.1,0,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)

local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size = UDim2.new(0,200,0,30)
speedLabel.Position = UDim2.new(0,10,0,10)
speedLabel.Text = "Speed: "..speed
speedLabel.BackgroundColor3 = Color3.fromRGB(50,50,50)
speedLabel.TextColor3 = Color3.new(1,1,1)

local plus = Instance.new("TextButton", frame)
plus.Size = UDim2.new(0,95,0,40)
plus.Position = UDim2.new(0,10,0,50)
plus.Text = "+ Speed"

local minus = Instance.new("TextButton", frame)
minus.Size = UDim2.new(0,95,0,40)
minus.Position = UDim2.new(0,115,0,50)
minus.Text = "- Speed"

local fly = Instance.new("TextButton", frame)
fly.Size = UDim2.new(0,200,0,40)
fly.Position = UDim2.new(0,10,0,110)
fly.Text = "Fly"

local flying = false
local bv

plus.MouseButton1Click:Connect(function()
	speed = speed + 5
	hum.WalkSpeed = speed
	speedLabel.Text = "Speed: "..speed
end)

minus.MouseButton1Click:Connect(function()
	speed = math.max(16, speed - 5)
	hum.WalkSpeed = speed
	speedLabel.Text = "Speed: "..speed
end)

fly.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then
		bv = Instance.new("BodyVelocity")
		bv.MaxForce = Vector3.new(999999,999999,999999)
		bv.Velocity = Vector3.new(0,50,0)
		bv.Parent = char.HumanoidRootPart
		fly.Text = "Fly ON"
	else
		if bv then bv:Destroy() end
		fly.Text = "Fly OFF"
	end
end)
