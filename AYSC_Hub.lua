-- AYSC Hub Final Mobile-Friendly
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Funções utilitárias
local function getHumanoid()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("Humanoid")
end
local function getRoot()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

-- Valores padrão
local defaultWalk, defaultJump = 16, 50
local flyEnabled, flySpeed = false, 50
local flyDirection = Vector3.new(0,0,0)
local spinEnabled, infinityJumpEnabled = false, false
local selectedPlayers = {}

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Bolinha toggle
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0,50,0,50)
toggleBtn.Position = UDim2.new(0,20,0,20)
toggleBtn.Text = "67"
toggleBtn.TextScaled = true
toggleBtn.BackgroundColor3 = Color3.fromRGB(0,150,200)
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.Parent = ScreenGui
toggleBtn.Active = true
toggleBtn.Draggable = true

-- ScrollFrame principal
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(0,320,0,500)
ScrollFrame.Position = UDim2.new(0,20,0,80)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
ScrollFrame.CanvasSize = UDim2.new(0,0,5,0) -- aumenta conforme o conteúdo
ScrollFrame.ScrollBarThickness = 10
ScrollFrame.Visible = false
ScrollFrame.Parent = ScreenGui

toggleBtn.MouseButton1Click:Connect(function()
    ScrollFrame.Visible = not ScrollFrame.Visible
end)

-- UIListLayout para scroll
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0,5)

-- Função criar botão
local function CreateBtn(text,color,posY,parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,260,0,35)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextScaled = true
    btn.Text = text
    btn.Parent = parent
    return btn
end

-- Função criar TextBox
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

-- WalkSpeed e JumpPower
local WalkBox = CreateBox("WalkSpeed",ScrollFrame)
local JumpBox = CreateBox("JumpPower",ScrollFrame)
local SetBtn = CreateBtn("Setar",Color3.fromRGB(80,80,80),0,ScrollFrame)
SetBtn.MouseButton1Click:Connect(function()
    local humanoid = getHumanoid()
    local w = tonumber(WalkBox.Text)
    local j = tonumber(JumpBox.Text)
    if w then humanoid.WalkSpeed = w end
    if j then humanoid.JumpPower = j end
end)

-- Reset padrão
local DefaultBtn = CreateBtn("Voltar para Padrão",Color3.fromRGB(100,0,200),0,ScrollFrame)
DefaultBtn.MouseButton1Click:Connect(function()
    local humanoid = getHumanoid()
    humanoid.WalkSpeed = defaultWalk
    humanoid.JumpPower = defaultJump
end)

-- Infinity Jump
local IJBtn = CreateBtn("Infinity Jump: OFF",Color3.fromRGB(0,150,200),0,ScrollFrame)
IJBtn.MouseButton1Click:Connect(function()
    infinityJumpEnabled = not infinityJumpEnabled
    IJBtn.Text = "Infinity Jump: "..(infinityJumpEnabled and "ON" or "OFF")
end)

-- Spin
local SpinBtn = CreateBtn("Spin: OFF",Color3.fromRGB(200,100,0),0,ScrollFrame)
SpinBtn.MouseButton1Click:Connect(function()
    spinEnabled = not spinEnabled
    SpinBtn.Text = "Spin: "..(spinEnabled and "ON" or "OFF")
end)

-- Fly
local FlyBtn = CreateBtn("Fly: OFF",Color3.fromRGB(0,150,0),0,ScrollFrame)
FlyBtn.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    FlyBtn.Text = "Fly: "..(flyEnabled and "ON" or "OFF")
end)
local FlySpeedBox = CreateBox("Fly Speed",ScrollFrame)
local SetFlySpeedBtn = CreateBtn("Setar",Color3.fromRGB(80,80,80),0,ScrollFrame)
SetFlySpeedBtn.MouseButton1Click:Connect(function()
    local val = tonumber(FlySpeedBox.Text)
    if val then flySpeed = val end
end)

-- Fly Touch
local FlyUpBtn = CreateBtn("▲",Color3.fromRGB(0,200,0),0,ScrollFrame)
FlyUpBtn.MouseButton1Down:Connect(function() if flyEnabled then flyDirection = Vector3.new(0,1,0) end end)
FlyUpBtn.MouseButton1Up:Connect(function() if flyEnabled then flyDirection = Vector3.new(0,0,0) end end)

local FlyDownBtn = CreateBtn("▼",Color3.fromRGB(200,0,0),0,ScrollFrame)
FlyDownBtn.MouseButton1Down:Connect(function() if flyEnabled then flyDirection = Vector3.new(0,-1,0) end end)
FlyDownBtn.MouseButton1Up:Connect(function() if flyEnabled then flyDirection = Vector3.new(0,0,0) end end)

-- Player list
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

-- Teleport
local TPBtn = CreateBtn("Teleport Selecionados",Color3.fromRGB(0,100,200),0,ScrollFrame)
TPBtn.MouseButton1Click:Connect(function()
    local root = getRoot()
    for p,_ in pairs(selectedPlayers) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            root.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
        end
    end
end)

-- Reconectar quando o personagem reseta
player.CharacterAdded:Connect(function(char)
    humanoid = getHumanoid()
    root = getRoot()
end)

-- Loop principal
RunService.RenderStepped:Connect(function()
    local root = getRoot()
    local humanoid = getHumanoid()
    if flyEnabled and root then
        local bv = Instance.new("BodyVelocity")
        bv.Velocity = flyDirection * flySpeed
        bv.MaxForce = Vector3.new(1e5,1e5,1e5)
        bv.Parent = root
        RunService.RenderStepped:Wait()
        bv:Destroy()
    end
    if spinEnabled and root then
        root.CFrame = root.CFrame * CFrame.Angles(0,math.rad(10),0)
    end
    if infinityJumpEnabled and humanoid then
        humanoid.Jump = true
    end
end)
