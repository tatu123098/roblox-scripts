-- AYSC_Hub2.1 Mobile Ready
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local LP = Players.LocalPlayer

-- Função pra pegar HumanoidRootPart
local function getHRP()
    return LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "AYSC_Hub2.1"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

-- Bolinha flutuante
local ball = Instance.new("TextButton")
ball.Size = UDim2.new(0,60,0,60)
ball.Position = UDim2.new(0.05,0,0.3,0)
ball.Text = "🥭"
ball.TextScaled = true
ball.BackgroundColor3 = Color3.fromRGB(0,255,0)
ball.TextColor3 = Color3.fromRGB(0,0,0)
ball.Parent = gui
ball.Active = true
ball.Draggable = true

-- Frame principal
local main = Instance.new("Frame")
main.Size = UDim2.new(0,260,0,400)
main.Position = UDim2.new(0.15,0,0.25,0)
main.BackgroundColor3 = Color3.fromRGB(0,0,0)
main.Visible = false
main.Parent = gui

-- ScrollingFrame pra mobile
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,0,1,0)
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 8
scroll.BackgroundTransparency = 1
scroll.Parent = main

local layout = Instance.new("UIListLayout")
layout.Parent = scroll
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0,5)

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
end)

ball.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)

-- Função pra criar TextBox + Botão
local function createBox(name,callback)
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0.6,0,0,35)
	box.PlaceholderText = name
	box.Text = ""
	box.BackgroundColor3 = Color3.fromRGB(0,255,0)
	box.TextColor3 = Color3.fromRGB(0,0,0)
	box.Parent = scroll

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.35,0,0,35)
	btn.Text = "Set"
	btn.BackgroundColor3 = Color3.fromRGB(0,255,0)
	btn.TextColor3 = Color3.fromRGB(0,0,0)
	btn.Parent = scroll

	btn.MouseButton1Click:Connect(function()
		local val = tonumber(box.Text)
		if val then callback(val) end
	end)
end

-- WalkSpeed
createBox("WalkSpeed", function(val)
	if LP.Character then
		LP.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = val
	end
end)

-- JumpPower
createBox("JumpBoost", function(val)
	if LP.Character then
		LP.Character:FindFirstChildOfClass("Humanoid").JumpPower = val
	end
end)

-- Spin toggle
local spinning = false
local spinBtn = Instance.new("TextButton",scroll)
spinBtn.Size = UDim2.new(1,0,0,35)
spinBtn.Text = "Spin: OFF"
spinBtn.BackgroundColor3 = Color3.fromRGB(0,255,0)
spinBtn.TextColor3 = Color3.fromRGB(0,0,0)
spinBtn.MouseButton1Click:Connect(function()
	spinning = not spinning
	spinBtn.Text = "Spin: "..(spinning and "ON" or "OFF")
end)

-- Infinity Jump toggle
local infJump = false
local ijBtn = Instance.new("TextButton",scroll)
ijBtn.Size = UDim2.new(1,0,0,35)
ijBtn.Text = "Infinity Jump: OFF"
ijBtn.BackgroundColor3 = Color3.fromRGB(0,255,0)
ijBtn.TextColor3 = Color3.fromRGB(0,0,0)
ijBtn.MouseButton1Click:Connect(function()
	infJump = not infJump
	ijBtn.Text = "Infinity Jump: "..(infJump and "ON" or "OFF")
end)

UIS.JumpRequest:Connect(function()
	if infJump and LP.Character then
		local hum = LP.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end)

-- Player teleport
local tpLabel = Instance.new("TextLabel",scroll)
tpLabel.Size = UDim2.new(1,0,0,35)
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
			local btn = Instance.new("TextButton",scroll)
			btn.Name = "TPBtn"
			btn.Size = UDim2.new(1,0,0,35)
			btn.Text = plr.Name
			btn.BackgroundColor3 = Color3.fromRGB(0,255,0)
			btn.TextColor3 = Color3.fromRGB(0,0,0)
			btn.MouseButton1Click:Connect(function()
				local HRP = getHRP()
				if plr.Character and HRP and plr.Character:FindFirstChild("HumanoidRootPart") then
					HRP.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,0)
				end
			end)
			btn.Parent = scroll
		end
	end
end
refreshPlayers()
Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)

-- Fly toggle
local flying = false
local flySpeed = 25
local bodyVel
local flyBtn = Instance.new("TextButton",scroll)
flyBtn.Size = UDim2.new(1,0,0,35)
flyBtn.Text = "Fly: OFF"
flyBtn.BackgroundColor3 = Color3.fromRGB(0,255,0)
flyBtn.TextColor3 = Color3.fromRGB(0,0,0)

flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	flyBtn.Text = "Fly: "..(flying and "ON" or "OFF")
	if flying and getHRP() then
		bodyVel = Instance.new("BodyVelocity", getHRP())
		bodyVel.MaxForce = Vector3.new(1e5,1e5,1e5)
	else
		if bodyVel then bodyVel:Destroy() end
	end
end)

-- Fly loop
RS.RenderStepped:Connect(function()
	local HRP = getHRP()
	if flying and HRP and bodyVel then
		local move = Vector3.new()
		if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + HRP.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - HRP.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - HRP.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + HRP.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0,1,0) end
		bodyVel.Velocity = move * flySpeed
	end
	if spinning and HRP then
		HRP.CFrame = HRP.CFrame * CFrame.Angles(0,math.rad(15),0)
	end
end)
