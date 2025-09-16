-- AYSC Hub Ultimate - Full working (for your flop game)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Valores padrão
local defaultWalk, defaultJump = 16, 50
local flyEnabled, flySpeed = false, 50
local spinEnabled, infinityJumpEnabled = false, false
local selectedPlayers = {}
local flyBV

-- Funções utilitárias
local function getHumanoid() return player.Character and player.Character:FindFirstChild("Humanoid") end
local function getRoot() return player.Character and player.Character:FindFirstChild("HumanoidRootPart") end

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0,50,0,50)
toggleBtn.Position = UDim2.new(0,20,0,20)
toggleBtn.Text = "AYSC"
toggleBtn.TextScaled = true
toggleBtn.BackgroundColor3 = Color3.fromRGB(0,150,200)
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.Parent = ScreenGui
toggleBtn.Active = true
toggleBtn.Draggable = true

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(0,320,0,500)
ScrollFrame.Position = UDim2.new(0,20,0,80)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
ScrollFrame.CanvasSize = UDim2.new(0,0,0,0)
ScrollFrame.ScrollBarThickness = 10
ScrollFrame.Visible = false
ScrollFrame.Parent = ScreenGui

toggleBtn.MouseButton1Click:Connect(function()
    ScrollFrame.Visible = not ScrollFrame.Visible
end)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0,5)

-- Criação de botões e caixas
local function CreateBtn(text,color,parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,260,0,35)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextScaled = true
    btn.Text = text
    btn.Parent = parent
    return btn
end
local function CreateBox(text,parent)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0,260,0,35)
    box.PlaceholderText = text
    box.Text = ""
    box.TextScaled = true
    box.BackgroundColor3 = Color3.fromRGB(50,50,50)
    box.TextColor3 = Color3.fromRGB(255,255,255)
    box.ClearTextOnFocus = false
    box.Parent = parent
    return box
end

local WalkBox = CreateBox("WalkSpeed",ScrollFrame)
local JumpBox = CreateBox("JumpPower",ScrollFrame)
local SetBtn = CreateBtn("Setar",Color3.fromRGB(80,80,80),ScrollFrame)
SetBtn.MouseButton1Click:Connect(function()
    local humanoid = getHumanoid()
    if humanoid then
        local w = tonumber(WalkBox.Text)
        local j = tonumber(JumpBox.Text)
        if w then humanoid.WalkSpeed = w end
        if j then humanoid.JumpPower = j end
    end
end)

local DefaultBtn = CreateBtn("Voltar para Padrão",Color3.fromRGB(100,0,200),ScrollFrame)
DefaultBtn.MouseButton1Click:Connect(function()
    local humanoid = getHumanoid()
    if humanoid then
        humanoid.WalkSpeed = defaultWalk
        humanoid.JumpPower = defaultJump
    end
end)

local IJBtn = CreateBtn("Infinity Jump: OFF",Color3.fromRGB(0,150,200),ScrollFrame)
IJBtn.MouseButton1Click:Connect(function()
    infinityJumpEnabled = not infinityJumpEnabled
    IJBtn.Text = "Infinity Jump: "..(infinityJumpEnabled and "ON" or "OFF")
end)

local SpinBtn = CreateBtn("Spin: OFF",Color3.fromRGB(200,100,0),ScrollFrame)
SpinBtn.MouseButton1Click:Connect(function()
    spinEnabled = not spinEnabled
    SpinBtn.Text = "Spin: "..(spinEnabled and "ON" or "OFF")
end)

local FlyBtn = CreateBtn("Fly: OFF",Color3.fromRGB(0,150,0),ScrollFrame)
FlyBtn.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    FlyBtn.Text = "Fly: "..(flyEnabled and "ON" or "OFF")
end)
local FlySpeedBox = CreateBox("Fly Speed",ScrollFrame)
local SetFlySpeedBtn = CreateBtn("Setar",Color3.fromRGB(80,80,80),ScrollFrame)
SetFlySpeedBtn.MouseButton1Click:Connect(function()
    local val = tonumber(FlySpeedBox.Text)
    if val then flySpeed = val end
end)

-- Lista de players
local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(0,260,0,150)
PlayerList.BackgroundColor3 = Color3.fromRGB(50,50,50)
PlayerList.CanvasSize = UDim2.new(0,0,0,0)
PlayerList.Parent = ScrollFrame
local UIListLayout2 = Instance.new("UIListLayout")
UIListLayout2.Parent = PlayerList
UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder

local function refreshPlayerList()
    PlayerList:ClearAllChildren()
    local y = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1,0,0,30)
            btn.Position = UDim2.new(0,0,0,y)
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
            y = y + 35
        end
    end
    PlayerList.CanvasSize = UDim2.new(0,0,y)
end
refreshPlayerList()
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)

local TPBtn = CreateBtn("Teleport Selecionados",Color3.fromRGB(0,100,200),ScrollFrame)
TPBtn.MouseButton1Click:Connect(function()
    local root = getRoot()
    for p,_ in pairs(selectedPlayers) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            root.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
        end
    end
end)

-- Reconectar personagem
player.CharacterAdded:Connect(function(char)
    flyBV = nil
end)

-- Fly input
local flyKeys = {W=false,S=false,A=false,D=false,Up=false,Down=false}
UIS.InputBegan:Connect(function(input,gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.W then flyKeys.W=true end
    if input.KeyCode == Enum.KeyCode.S then flyKeys.S=true end
    if input.KeyCode == Enum.KeyCode.A then flyKeys.A=true end
    if input.KeyCode == Enum.KeyCode.D then flyKeys.D=true end
    if input.KeyCode == Enum.KeyCode.Space then flyKeys.Up=true end
    if input.KeyCode == Enum.KeyCode.LeftControl then flyKeys.Down=true end
end)
UIS.InputEnded:Connect(function(input,gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.W then flyKeys.W=false end
    if input.KeyCode == Enum.KeyCode.S then flyKeys.S=false end
    if input.KeyCode == Enum.KeyCode.A then flyKeys.A=false end
    if input.KeyCode == Enum.KeyCode.D then flyKeys.D=false end
    if input.KeyCode == Enum.KeyCode.Space then flyKeys.Up=false end
    if input.KeyCode == Enum.KeyCode.LeftControl then flyKeys.Down=false end
end)

-- Loop principal
RunService.RenderStepped:Connect(function()
    local humanoid = getHumanoid()
    local root = getRoot()
    if infinityJumpEnabled and humanoid and humanoid.FloorMaterial ~= Enum.Material.Air then
        humanoid.Jump = true
    end
    if spinEnabled and root then
        root.CFrame = root.CFrame * CFrame.Angles(0,math.rad(10),0)
    end
    if flyEnabled and root then
        local cam = workspace.CurrentCamera
        local dir = Vector3.new(0,0,0)
        if flyKeys.W then dir = dir + cam.CFrame.LookVector end
        if flyKeys.S then dir = dir - cam.CFrame.LookVector end
        if flyKeys.A then dir = dir - cam.CFrame.RightVector end
        if flyKeys.D then dir = dir + cam.CFrame.RightVector end
        if flyKeys.Up then dir = dir + Vector3.new(0,1,0) end
        if flyKeys.Down then dir = dir - Vector3.new(0,1,0) end
        if dir.Magnitude > 0 then
            dir = dir.Unit * flySpeed
            if not flyBV then
                flyBV = Instance.new("BodyVelocity")
                flyBV.MaxForce = Vector3.new(1e5,1e5,1e5)
                flyBV.Parent = root
            end
            flyBV.Velocity = dir
        elseif flyBV then
            flyBV.Velocity = Vector3.new(0,0,0)
        end
    elseif flyBV then
        flyBV:Destroy()
        flyBV = nil
    end
end)
