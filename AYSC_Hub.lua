-- AYSC Hub Full Mobile & Minimal
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Variáveis do personagem
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
local flyEnabled, flySpeed = false, 50
local flyDirection = Vector3.new(0,0,0)
local spinEnabled, infinityJumpEnabled = false, false
local selectedPlayers = {}

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Bolinha toggle
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0,50,0,50)
toggleBtn.Position = UDim2.new(0,20,0,20)
toggleBtn.Text = "67"
toggleBtn.TextScaled = true
toggleBtn.BackgroundColor3 = Color3.fromRGB(0,150,200)
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.Parent = ScreenGui

-- Frame principal
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0,320,0,500)
Frame.Position = UDim2.new(0,20,0,80)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Visible = false
Frame.Parent = ScreenGui

toggleBtn.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)

-- Função para criar TextBox sem placeholder fixo
local function CreateBox(text,posY)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0,120,0,35)
    box.Position = UDim2.new(0,20,0,posY)
    box.PlaceholderText = text
    box.Text = ""
    box.TextScaled = true
    box.BackgroundColor3 = Color3.fromRGB(50,50,50)
    box.TextColor3 = Color3.fromRGB(255,255,255)
    box.ClearTextOnFocus = false
    box.Parent = Frame
    return box
end

-- Speed & Jump
local WalkBox = CreateBox("WalkSpeed",20)
local JumpBox = CreateBox("JumpPower",60)
local SetBtn = Instance.new("TextButton")
SetBtn.Size = UDim2.new(0,100,0,35)
SetBtn.Position = UDim2.new(0,160,0,20)
SetBtn.Text = "Setar"
SetBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
SetBtn.TextColor3 = Color3.fromRGB(255,255,255)
SetBtn.TextScaled = true
SetBtn.Parent = Frame
SetBtn.MouseButton1Click:Connect(function()
    local w = tonumber(WalkBox.Text)
    local j = tonumber(JumpBox.Text)
    if w then humanoid.WalkSpeed = w end
    if j then humanoid.JumpPower = j end
end)

-- Reset padrão
local DefaultBtn = Instance.new("TextButton")
DefaultBtn.Size = UDim2.new(0,260,0,35)
DefaultBtn.Position = UDim2.new(0,20,0,100)
DefaultBtn.Text = "Voltar para Padrão"
DefaultBtn.BackgroundColor3 = Color3.fromRGB(100,0,200)
DefaultBtn.TextColor3 = Color3.fromRGB(255,255,255)
DefaultBtn.TextScaled = true
DefaultBtn.Parent = Frame
DefaultBtn.MouseButton1Click:Connect(function()
    humanoid.WalkSpeed = defaultWalk
    humanoid.JumpPower = defaultJumpPower
end)

-- Infinity Jump
local IJBtn = Instance.new("TextButton")
IJBtn.Size = UDim2.new(0,260,0,35)
IJBtn.Position = UDim2.new(0,20,0,140)
IJBtn.Text = "Infinity Jump: OFF"
IJBtn.BackgroundColor3 = Color3.fromRGB(0,150,200)
IJBtn.TextColor3 = Color3.fromRGB(255,255,255)
IJBtn.TextScaled = true
IJBtn.Parent = Frame
IJBtn.MouseButton1Click:Connect(function()
    infinityJumpEnabled = not infinityJumpEnabled
    IJBtn.Text = "Infinity Jump: "..(infinityJumpEnabled and "ON" or "OFF")
end)

-- Spin
local SpinBtn = Instance.new("TextButton")
SpinBtn.Size = UDim2.new(0,260,0,35)
SpinBtn.Position = UDim2.new(0,20,0,180)
SpinBtn.Text = "Spin: OFF"
SpinBtn.BackgroundColor3 = Color3.fromRGB(200,100,0)
SpinBtn.TextColor3 = Color3.fromRGB(255,255,255)
SpinBtn.TextScaled = true
SpinBtn.Parent = Frame
SpinBtn.MouseButton1Click:Connect(function()
    spinEnabled = not spinEnabled
    SpinBtn.Text = "Spin: "..(spinEnabled and "ON" or "OFF")
end)

-- Fly ON/OFF
local FlyBtn = Instance.new("TextButton")
FlyBtn.Size = UDim2.new(0,260,0,35)
FlyBtn.Position = UDim2.new(0,20,0,220)
FlyBtn.Text = "Fly: OFF"
FlyBtn.BackgroundColor3 = Color3.fromRGB(0,150,0)
FlyBtn.TextColor3 = Color3.fromRGB(255,255,255)
FlyBtn.TextScaled = true
FlyBtn.Parent = Frame
FlyBtn.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    FlyBtn.Text = "Fly: "..(flyEnabled and "ON" or "OFF")
end)

local FlySpeedBox = CreateBox("Fly Speed",260)
local SetFlySpeedBtn = Instance.new("TextButton")
SetFlySpeedBtn.Size = UDim2.new(0,100,0,35)
SetFlySpeedBtn.Position = UDim2.new(0,160,0,260)
SetFlySpeedBtn.Text = "Setar"
SetFlySpeedBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
SetFlySpeedBtn.TextColor3 = Color3.fromRGB(255,255,255)
SetFlySpeedBtn.TextScaled = true
SetFlySpeedBtn.Parent = Frame
SetFlySpeedBtn.MouseButton1Click:Connect(function()
    local val = tonumber(FlySpeedBox.Text)
    if val then flySpeed = val end
end)

-- Fly touch buttons
local FlyUpBtn = Instance.new("TextButton")
FlyUpBtn.Size = UDim2.new(0,100,0,35)
FlyUpBtn.Position = UDim2.new(0,20,0,305)
FlyUpBtn.Text = "▲"
FlyUpBtn.TextScaled = true
FlyUpBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)
FlyUpBtn.TextColor3 = Color3.fromRGB(255,255,255)
FlyUpBtn.Parent = Frame
FlyUpBtn.MouseButton1Down:Connect(function() if flyEnabled then flyDirection=Vector3.new(0,1,0) end end)
FlyUpBtn.MouseButton1Up:Connect(function() if flyEnabled then flyDirection=Vector3.new(0,0,0) end end)

local FlyDownBtn = Instance.new("TextButton")
FlyDownBtn.Size = UDim2.new(0,100,0,35)
FlyDownBtn.Position = UDim2.new(0,140,0,305)
FlyDownBtn.Text = "▼"
FlyDownBtn.TextScaled = true
FlyDownBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
FlyDownBtn.TextColor3 = Color3.fromRGB(255,255,255)
FlyDownBtn.Parent = Frame
FlyDownBtn.MouseButton1Down:Connect(function() if flyEnabled then flyDirection=Vector3.new(0,-1,0) end end)
FlyDownBtn.MouseButton1Up:Connect(function() if flyEnabled then flyDirection=Vector3.new(0,0,0) end end)

-- Player List + Teleport
local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(0,260,0,80)
PlayerList.Position = UDim2.new(0,20,0,350)
PlayerList.BackgroundColor3 = Color3.fromRGB(50,50,50)
PlayerList.CanvasSize = UDim2.new(0,0,0,0)
PlayerList.Parent = Frame
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = PlayerList
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function refreshPlayerList()
    PlayerList:ClearAllChildren()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1,0,0,30)
            btn.Text = p.Name
            btn.TextScaled = true
            btn.BackgroundColor3 = selectedPlayers[p] and Color3.fromRGB(0,150,0) or Color3.fromRGB(80,80,80)
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.Parent = PlayerList
            btn.MouseButton1Click:Connect(function()
                if selectedPlayers[p] then
                    selectedPlayers[p] = nil
                    btn.BackgroundColor3 = Color3.fromRGB(80,80,80)
                else
                    selectedPlayers[p] = true
                    btn.BackgroundColor3 = Color3.fromRGB(0,150,0)
                end
            end)
        end
    end
    PlayerList.CanvasSize = UDim2.new(0,0,#Players:GetPlayers()*35,0)
end
refreshPlayerList()
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)

-- Teleport selecionados
local TPBtn = Instance.new("TextButton")
TPBtn.Size = UDim2.new(0,260,0,35)
TPBtn.Position = UDim2.new(0,20,0,440)
TPBtn.Text = "Teleport Selecionados"
TPBtn.BackgroundColor3 = Color3.fromRGB(0,100,200)
TPBtn.TextColor3 = Color3.fromRGB(255,255,255)
TPBtn.TextScaled = true
TPBtn.Parent = Frame
TPBtn.MouseButton1Click:Connect(function()
    for p,_ in pairs(selectedPlayers) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            root.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
        end
    end
end)

-- Loop principal
RunService.RenderStepped:Connect(function()
    if flyEnabled and root then
        root.Velocity = flyDirection * flySpeed
    end
    if spinEnabled and root then
        root.CFrame = root.CFrame * CFrame.Angles(0,math.rad(10),0)
    end
    if infinityJumpEnabled and humanoid then
        humanoid.Jump = true
    end
end)
