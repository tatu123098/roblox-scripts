--AYSC_Hub2.0
--by Arthur

-- Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local HRP = LP.Character and LP.Character:WaitForChild("HumanoidRootPart")

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "AYSC_Hub2.0"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

-- Bolinha flutuante
local ball = Instance.new("TextButton")
ball.Size = UDim2.new(0,60,0,60)
ball.Position = UDim2.new(0.05,0,0.3,0)
ball.Text = "⚫"
ball.TextScaled = true
ball.BackgroundColor3 = Color3.fromRGB(0,255,0)
ball.TextColor3 = Color3.fromRGB(0,0,0)
ball.Parent = gui
ball.Active = true
ball.Draggable = true

-- Frame principal
local main = Instance.new("Frame")
main.Size = UDim2.new(0,250,0,300)
main.Position = UDim2.new(0.15,0,0.25,0)
main.BackgroundColor3 = Color3.fromRGB(0,0,0)
main.Visible = false
main.Parent = gui

local scroll = Instance.new("ScrollingFrame",main)
scroll.Size = UDim2.new(1,0,1,0)
scroll.CanvasSize = UDim2.new(0,0,2,0)
scroll.ScrollBarThickness = 6
scroll.BackgroundTransparency = 1

-- Toggle
ball.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)

-- Função criar textbox + botão
local function createBox(name,callback)
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0.6,0,0,30)
	box.PlaceholderText = name
	box.BackgroundColor3 = Color3.fromRGB(0,255,0)
	box.TextColor3 = Color3.fromRGB(0,0,0)
	box.Parent = scroll

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.35,0,0,30)
	btn.Position = UDim2.new(0.65,0,0,0)
	btn.Text = "Set"
	btn.BackgroundColor3 = Color3.fromRGB(0,255,0)
	btn.TextColor3 = Color3.fromRGB(0,0,0)
	btn.Parent = scroll

	btn.MouseButton1Click:Connect(function()
		callback(tonumber(box.Text))
	end)
end

-- Walkspeed
createBox("WalkSpeed",function(val)
	if LP.Character then
		LP.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = val
	end
end)

-- JumpPower
createBox("JumpBoost",function(val)
	if LP.Character then
		LP.Character:FindFirstChildOfClass("Humanoid").JumpPower = val
	end
end)

-- Spin
local spinBtn = Instance.new("TextButton",scroll)
spinBtn.Size = UDim2.new(1,0,0,30)
spinBtn.Text = "Spin"
spinBtn.BackgroundColor3 = Color3.fromRGB(0,255,0)
spinBtn.TextColor3 = Color3.fromRGB(0,0,0)
spinBtn.MouseButton1Click:Connect(function()
	while task.wait() do
		if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
			LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.Angles(0,math.rad(30),0)
		end
	end
end)

-- Player TP dropdown
local tpLabel = Instance.new("TextLabel",scroll)
tpLabel.Size = UDim2.new(1,0,0,30)
tpLabel.Text = "Teleport Players"
tpLabel.BackgroundColor3 = Color3.fromRGB(0,255,0)
tpLabel.TextColor3 = Color3.fromRGB(0,0,0)

for _,plr in pairs(Players:GetPlayers()) do
	if plr ~= LP then
		local tpBtn = Instance.new("TextButton",scroll)
		tpBtn.Size = UDim2.new(1,0,0,30)
		tpBtn.Text = plr.Name
		tpBtn.BackgroundColor3 = Color3.fromRGB(0,255,0)
		tpBtn.TextColor3 = Color3.fromRGB(0,0,0)
		tpBtn.MouseButton1Click:Connect(function()
			if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				HRP.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,0)
			end
		end)
	end
end

-- Infinity Jump
UIS.JumpRequest:Connect(function()
	if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
		LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
	end
end)

-- Fly básico
local flying = false
local speed = 5
local bodyVel

local flyBtn = Instance.new("TextButton",scroll)
flyBtn.Size = UDim2.new(1,0,0,30)
flyBtn.Text = "Toggle Fly"
flyBtn.BackgroundColor3 = Color3.fromRGB(0,255,0)
flyBtn.TextColor3 = Color3.fromRGB(0,0,0)

flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then
		local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
		if hum and HRP then
			bodyVel = Instance.new("BodyVelocity",HRP)
			bodyVel.Velocity = Vector3.zero
			bodyVel.MaxForce = Vector3.new(1e5,1e5,1e5)
		end
	else
		if bodyVel then bodyVel:Destroy() end
	end
end)

game:GetService("RunService").RenderStepped:Connect(function()
	if flying and HRP then
		local move = Vector3.new()
		if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + (HRP.CFrame.LookVector) end
		if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - (HRP.CFrame.LookVector) end
		if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - (HRP.CFrame.RightVector) end
		if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + (HRP.CFrame.RightVector) end
		bodyVel.Velocity = move * speed
	end
end)
