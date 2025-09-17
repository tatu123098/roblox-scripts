-- AYSC_Hub2.1
-- by Arthur (buffed)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local LP = Players.LocalPlayer
local HRP = LP.Character and LP.Character:WaitForChild("HumanoidRootPart")

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "AYSC_Hub2.1"
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
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 6
scroll.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout",scroll)
layout.Padding = UDim.new(0,5)

local function updateScroll()
	scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+10)
end
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateScroll)

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

-- Spin toggle
local spinning = false
local spinBtn = Instance.new("TextButton",scroll)
spinBtn.Size = UDim2.new(1,0,0,30)
spinBtn.Text = "Spin: OFF"
spinBtn.BackgroundColor3 = Color3.fromRGB(0,255,0)
spinBtn.TextColor3 = Color3.fromRGB(0,0,0)
spinBtn.MouseButton1Click:Connect(function()
	spinning = not spinning
	spinBtn.Text = "Spin: "..(spinning and "ON" or "OFF")
end)

-- Player TP
local tpLabel = Instance.new("TextLabel",scroll)
tpLabel.Size = UDim2.new(1,0,0,30)
tpLabel.Text = "Teleport Players"
tpLabel.BackgroundColor3 = Color3.fromRGB(0,255,0)
tpLabel.TextColor3 = Color3.fromRGB(0,0,0)

local function refreshPlayers()
	for _,child in pairs(scroll:GetChildren()) do
		if child:IsA("TextButton") and child.Name == "TPBtn" then
			child:Destroy()
		end
	end
	for _,plr in pairs(Players:GetPlayers()) do
		if plr ~= LP then
			local tpBtn = Instance.new("TextButton",scroll)
			tpBtn.Name = "TPBtn"
			tpBtn.Size = UDim2.new(1,0,0,30)
			tpBtn.Text = plr.Name
			tpBtn.BackgroundColor3 = Color3.fromRGB(0,255,0)
			tpBtn.TextColor3 = Color3.fromRGB(0,0,0)
			tpBtn.MouseButton1Click:Connect(function()
				if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
					LP.Character:WaitForChild("HumanoidRootPart").CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,0)
				end
			end)
		end
	end
end
refreshPlayers()
Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)

-- Infinity Jump toggle
local infJump = false
local ijBtn = Instance.new("TextButton",scroll)
ijBtn.Size = UDim2.new(1,0,0,30)
ijBtn.Text = "Infinity Jump: OFF"
ijBtn.BackgroundColor3 = Color3.fromRGB(0,255,0)
ijBtn.TextColor3 = Color3.fromRGB(0,0,0)

ijBtn.MouseButton1Click:Connect(function()
	infJump = not infJump
	ijBtn.Text = "Infinity Jump: "..(infJump and "ON" or "OFF")
end)

UIS.JumpRequest:Connect(function()
	if infJump and LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
		LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
	end
end)

-- Fly toggle
local flying = false
local speed = 5
local bodyVel
local flyBtn = Instance.new("TextButton",scroll)
flyBtn.Size = UDim2.new(1,0,0,30)
flyBtn.Text = "Fly: OFF"
flyBtn.BackgroundColor3 = Color3.fromRGB(0,255,0)
flyBtn.TextColor3 = Color3.fromRGB(0,0,0)

flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	flyBtn.Text = "Fly: "..(flying and "ON" or "OFF")
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

RS.RenderStepped:Connect(function()
	if spinning and LP.Character and HRP then
		HRP.CFrame = HRP.CFrame * CFrame.Angles(0,math.rad(15),0)
	end
	if flying and HRP and bodyVel then
		local move = Vector3.new()
		if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + HRP.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - HRP.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - HRP.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + HRP.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0,1,0) end
		bodyVel.Velocity = move * speed
	end
end)
