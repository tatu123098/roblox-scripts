-- AYSC_Hub Simplificado (Sem Fly)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Funções para humanoid e root
local function getHumanoid()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("Humanoid")
end

local function getRoot()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local humanoid = getHumanoid()
local root = getRoot()

-- Valores padrão
local defaultWalk = 16
local defaultJumpPower = 50
local defaultJumpHeight = 7.2
local savedWalk, savedJump = nil, nil

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AYSC_Hub"
ScreenGui.Parent = game.CoreGui

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0,50,0,50)
ToggleBtn.Position = UDim2.new(0.05,0,0.5,0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
ToggleBtn.Text = "⚡"
ToggleBtn.TextScaled = true
ToggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
ToggleBtn.Parent = ScreenGui
ToggleBtn.Active = true
ToggleBtn.Draggable = true
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1,0)
UICorner.Parent = ToggleBtn

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0,300,0,400)
Frame.Position = UDim2.new(0.2,0,0.3,0)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Frame.Visible = false
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,30)
Title.Text = "AYSC Hub"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.BackgroundTransparency = 1
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

-- WalkSpeed
local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(0,120,0,35)
SpeedBox.Position = UDim2.new(0,20,0,60)
SpeedBox.PlaceholderText = "WalkSpeed"
SpeedBox.TextScaled = true
SpeedBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
SpeedBox.TextColor3 = Color3.fromRGB(255,255,255)
SpeedBox.ClearTextOnFocus = false
SpeedBox.Parent = Frame

local SetSpeedBtn = Instance.new("TextButton")
SetSpeedBtn.Size = UDim2.new(0,100,0,35)
SetSpeedBtn.Position = UDim2.new(0,160,0,60)
SetSpeedBtn.Text = "Setar"
SetSpeedBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
SetSpeedBtn.TextColor3 = Color3.fromRGB(255,255,255)
SetSpeedBtn.TextScaled = true
SetSpeedBtn.Parent = Frame

-- Jump
local JumpBox = Instance.new("TextBox")
JumpBox.Size = UDim2.new(0,120,0,35)
JumpBox.Position = UDim2.new(0,20,0,110)
JumpBox.PlaceholderText = "JumpPower"
JumpBox.TextScaled = true
JumpBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
JumpBox.TextColor3 = Color3.fromRGB(255,255,255)
JumpBox.ClearTextOnFocus = false
JumpBox.Parent = Frame

local SetJumpBtn = Instance.new("TextButton")
SetJumpBtn.Size = UDim2.new(0,100,0,35)
SetJumpBtn.Position = UDim2.new(0,160,0,110)
SetJumpBtn.Text = "Setar"
SetJumpBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
SetJumpBtn.TextColor3 = Color3.fromRGB(255,255,255)
SetJumpBtn.TextScaled = true
SetJumpBtn.Parent = Frame

-- Reset Padrão
local DefaultBtn = Instance.new("TextButton")
DefaultBtn.Size = UDim2.new(0,260,0,35)
DefaultBtn.Position = UDim2.new(0,20,0,160)
DefaultBtn.Text = "Voltar para Padrão"
DefaultBtn.BackgroundColor3 = Color3.fromRGB(100,0,200)
DefaultBtn.TextColor3 = Color3.fromRGB(255,255,255)
DefaultBtn.TextScaled = true
DefaultBtn.Parent = Frame

-- Infinity Jump
local IJBtn = Instance.new("TextButton")
IJBtn.Size = UDim2.new(0,260,0,35)
IJBtn.Position = UDim2.new(0,20,0,200)
IJBtn.Text = "Infinity Jump: OFF"
IJBtn.BackgroundColor3 = Color3.fromRGB(0,150,200)
IJBtn.TextColor3 = Color3.fromRGB(255,255,255)
IJBtn.TextScaled = true
IJBtn.Parent = Frame
local infinityJumpEnabled = false
IJBtn.MouseButton1Click:Connect(function()
    infinityJumpEnabled = not infinityJumpEnabled
    IJBtn.Text = "Infinity Jump: "..(infinityJumpEnabled and "ON" or "OFF")
end)

-- Spin
local SpinBtn = Instance.new("TextButton")
SpinBtn.Size = UDim2.new(0,260,0,35)
SpinBtn.Position = UDim2.new(0,20,0,240)
SpinBtn.Text = "Spin: OFF"
SpinBtn.BackgroundColor3 = Color3.fromRGB(200,100,0)
SpinBtn.TextColor3 = Color3.fromRGB(255,255,255)
SpinBtn.TextScaled = true
SpinBtn.Parent = Frame
local spinEnabled = false
SpinBtn.MouseButton1Click:Connect(function()
    spinEnabled = not spinEnabled
    SpinBtn.Text = "Spin: "..(spinEnabled and "ON" or "OFF")
end)

-- Players List
local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(0,260,0,80)
PlayerList.Position = UDim2.new(0,20,0,280)
PlayerList.BackgroundColor3 = Color3.fromRGB(50,50,50)
PlayerList.CanvasSize = UDim2.new(0,0,0,0)
PlayerList.Parent = Frame
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = PlayerList
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local selectedPlayers = {}
local function refreshPlayerList()
    PlayerList:ClearAllChildren()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1,0,0,20)
            btn.Text = p.Name
            btn.BackgroundColor3 = Color3.fromRGB(100,100,100)
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.TextScaled = true
            btn.Parent = PlayerList
            btn.MouseButton1Click:Connect(function()
                if selectedPlayers[p] then
                    selectedPlayers[p] = nil
                    btn.BackgroundColor3 = Color3.fromRGB(100,100,100)
                else
                    selectedPlayers[p] = true
                    btn.BackgroundColor3 = Color3.fromRGB(0,200,0)
                end
            end)
        end
    end
end
refreshPlayerList()
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)

-- Teleport Button
local TPBtn = Instance.new("TextButton")
TPBtn.Size = UDim2.new(0,260,0,35)
TPBtn.Position = UDim2.new(0,20,0,370)
TPBtn.Text = "Teleportar para selecionados"
TPBtn.BackgroundColor3 = Color3.fromRGB(0,100,200)
TPBtn.TextColor3 = Color3.fromRGB(255,255,255)
TPBtn.TextScaled = true
TPBtn.Parent = Frame
TPBtn.MouseButton1Click:Connect(function()
    for p,_ in pairs(selectedPlayers) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and root then
            root.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
        end
    end
end)

-- Toggle Hub
ToggleBtn.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)

-- Speed / Jump / Reset
SetSpeedBtn.MouseButton1Click:Connect(function()
    local val = tonumber(SpeedBox.Text)
    if val then
        savedWalk = val
        humanoid.WalkSpeed = val
    end
end)
SetJumpBtn.MouseButton1Click:Connect(function()
    local val = tonumber(JumpBox.Text)
    if val then
        savedJump = val
        if humanoid.UseJumpPower then
            humanoid.JumpPower = val
        else
            humanoid.JumpHeight = val
        end
    end
end)
DefaultBtn.MouseButton1Click:Connect(function()
    humanoid.WalkSpeed = defaultWalk
    if humanoid.UseJumpPower then
        humanoid.JumpPower = defaultJumpPower
    else
        humanoid.JumpHeight = defaultJumpHeight
    end
    savedWalk = defaultWalk
    savedJump = humanoid.UseJumpPower and defaultJumpPower or defaultJumpHeight
    SpeedBox.Text = tostring(savedWalk)
    JumpBox.Text = tostring(savedJump)
end)

-- Reaplicar ao resetar
player.CharacterAdded:Connect(function()
    humanoid = getHumanoid()
    root = getRoot()
    if savedWalk then humanoid.WalkSpeed = savedWalk end
    if savedJump then
        if humanoid.UseJumpPower then
            humanoid.JumpPower = savedJump
        else
            humanoid.JumpHeight = savedJump
        end
    end
end)

-- Infinity Jump
UIS.InputBegan:Connect(function(input, processed)
    if infinityJumpEnabled and input.KeyCode == Enum.KeyCode.Space and not processed then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Spin Loop
RunService.Heartbeat:Connect(function()
    if spinEnabled then
        if root then
            root.CFrame = root.CFrame * CFrame.Angles(0,math.rad(15),0)
        end
    end
end)
