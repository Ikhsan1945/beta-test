-- [ Ar Zero ] Teleport UI — Steal a Brainrot
-- Compatible: KRNL / Synapse X / Fluxus

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ══════════════════════════════════════
--         DESTROY OLD UI
-- ══════════════════════════════════════
if PlayerGui:FindFirstChild("ArZeroUI") then
    PlayerGui.ArZeroUI:Destroy()
end

-- ══════════════════════════════════════
--         SAVED POSITIONS
-- ══════════════════════════════════════
local savedBasePosition = nil
local spawnPosition = nil

-- Rekam posisi spawn awal
local function recordSpawn()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart", 5)
    if root then
        task.wait(1)
        spawnPosition = root.CFrame
    end
end
task.spawn(recordSpawn)

LocalPlayer.CharacterAdded:Connect(function(char)
    local root = char:WaitForChild("HumanoidRootPart", 5)
    if root then
        task.wait(1)
        spawnPosition = root.CFrame
    end
end)

-- ══════════════════════════════════════
--         SCREEN GUI
-- ══════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ArZeroUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

-- ══════════════════════════════════════
--         TOGGLE BUTTON
-- ══════════════════════════════════════
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(0, 120, 0, 36)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 30)
ToggleBtn.TextColor3 = Color3.fromRGB(180, 220, 255)
ToggleBtn.Text = "⚡ Ar Zero  ☰"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 13
ToggleBtn.BorderSizePixel = 0
ToggleBtn.ZIndex = 10
ToggleBtn.Parent = ScreenGui

Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)
local tStroke = Instance.new("UIStroke", ToggleBtn)
tStroke.Color = Color3.fromRGB(60, 100, 200)
tStroke.Thickness = 1.2

-- ══════════════════════════════════════
--         MAIN FRAME
-- ══════════════════════════════════════
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 270, 0, 260)
MainFrame.Position = UDim2.new(0, 10, 0, 55)
MainFrame.BackgroundColor3 = Color3.fromRGB(11, 11, 20)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.ZIndex = 5
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)
local mStroke = Instance.new("UIStroke", MainFrame)
mStroke.Color = Color3.fromRGB(55, 95, 210)
mStroke.Thickness = 1.5

-- ══════════════════════════════════════
--         HEADER
-- ══════════════════════════════════════
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 46)
Header.BackgroundColor3 = Color3.fromRGB(18, 18, 48)
Header.BorderSizePixel = 0
Header.ZIndex = 6
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 14)

local HeaderLabel = Instance.new("TextLabel")
HeaderLabel.Size = UDim2.new(1, -50, 1, 0)
HeaderLabel.Position = UDim2.new(0, 14, 0, 0)
HeaderLabel.BackgroundTransparency = 1
HeaderLabel.Text = "⚡ Ar Zero — Teleport"
HeaderLabel.TextColor3 = Color3.fromRGB(180, 220, 255)
HeaderLabel.Font = Enum.Font.GothamBold
HeaderLabel.TextSize = 14
HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
HeaderLabel.ZIndex = 7
HeaderLabel.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -36, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 35, 35)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 8
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- ══════════════════════════════════════
--         CONTENT
-- ══════════════════════════════════════
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, 0, 1, -50)
Content.Position = UDim2.new(0, 0, 0, 50)
Content.BackgroundTransparency = 1
Content.ZIndex = 6
Content.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Padding = UDim.new(0, 7)
Layout.Parent = Content

local Pad = Instance.new("UIPadding")
Pad.PaddingLeft = UDim.new(0, 12)
Pad.PaddingRight = UDim.new(0, 12)
Pad.PaddingTop = UDim.new(0, 10)
Pad.Parent = Content

-- ══════════════════════════════════════
--         BUTTON FACTORY
-- ══════════════════════════════════════
local function createButton(text, icon, order, color)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 42)
    Btn.BackgroundColor3 = color or Color3.fromRGB(22, 28, 58)
    Btn.Text = icon .. "  " .. text
    Btn.TextColor3 = Color3.fromRGB(210, 230, 255)
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 13
    Btn.BorderSizePixel = 0
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.LayoutOrder = order
    Btn.ZIndex = 7
    Btn.Parent = Content

    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 9)
    local s = Instance.new("UIStroke", Btn)
    s.Color = Color3.fromRGB(50, 80, 180)
    s.Thickness = 1
    local p = Instance.new("UIPadding", Btn)
    p.PaddingLeft = UDim.new(0, 12)

    local base = color or Color3.fromRGB(22, 28, 58)
    Btn.MouseEnter:Connect(function()
        Btn.BackgroundColor3 = Color3.fromRGB(35, 45, 100)
    end)
    Btn.MouseLeave:Connect(function()
        Btn.BackgroundColor3 = base
    end)

    return Btn
end

-- ══════════════════════════════════════
--         STATUS
-- ══════════════════════════════════════
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 28)
StatusLabel.BackgroundColor3 = Color3.fromRGB(8, 8, 18)
StatusLabel.Text = "Status : Standby"
StatusLabel.TextColor3 = Color3.fromRGB(100, 200, 120)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.BorderSizePixel = 0
StatusLabel.LayoutOrder = 99
StatusLabel.ZIndex = 7
StatusLabel.Parent = Content
Instance.new("UICorner", StatusLabel).CornerRadius = UDim.new(0, 6)

local function setStatus(msg, color)
    StatusLabel.Text = "Status : " .. msg
    StatusLabel.TextColor3 = color or Color3.fromRGB(100, 200, 120)
end

-- ══════════════════════════════════════
--         BUTTONS
-- ══════════════════════════════════════
local BtnSaveBase  = createButton("Save Posisi Base", "💾", 1, Color3.fromRGB(25, 50, 25))
local BtnBase      = createButton("Teleport to Base", "🏠", 2)
local BtnSpawn     = createButton("Teleport to Spawn", "📍", 3)

-- ══════════════════════════════════════
--         LOGIC
-- ══════════════════════════════════════
BtnSaveBase.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        savedBasePosition = root.CFrame
        setStatus("Posisi base tersimpan!", Color3.fromRGB(100, 220, 100))
        BtnSaveBase.BackgroundColor3 = Color3.fromRGB(20, 80, 20)
    else
        setStatus("Character tidak ada.", Color3.fromRGB(255, 80, 80))
    end
end)

BtnBase.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then
        setStatus("Character tidak ada.", Color3.fromRGB(255, 80, 80))
        return
    end
    if savedBasePosition then
        root.CFrame = savedBasePosition
        setStatus("Teleport ke base!", Color3.fromRGB(100, 200, 120))
    else
        setStatus("Belum save posisi base.", Color3.fromRGB(255, 180, 50))
    end
end)

BtnSpawn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then
        setStatus("Character tidak ada.", Color3.fromRGB(255, 80, 80))
        return
    end
    if spawnPosition then
        root.CFrame = spawnPosition
        setStatus("Teleport ke spawn.", Color3.fromRGB(100, 200, 120))
    else
        setStatus("Posisi spawn belum ada.", Color3.fromRGB(255, 180, 50))
    end
end)

-- ══════════════════════════════════════
--         TOGGLE
-- ══════════════════════════════════════
local isOpen = true
local function setMenu(open)
    isOpen = open
    MainFrame.Visible = open
end

ToggleBtn.MouseButton1Click:Connect(function() setMenu(not isOpen) end)
CloseBtn.MouseButton1Click:Connect(function() setMenu(false) end)

-- ══════════════════════════════════════
--         DRAGGABLE — MAIN FRAME
-- ══════════════════════════════════════
local dragging = false
local dragStart, startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or
       input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

Header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or
       input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement or
        input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- ══════════════════════════════════════
--         DRAGGABLE — TOGGLE BUTTON
-- ══════════════════════════════════════
local tDragging = false
local tDragStart, tStartPos

ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or
       input.UserInputType == Enum.UserInputType.MouseButton1 then
        tDragging = true
        tDragStart = input.Position
        tStartPos = ToggleBtn.Position
    end
end)

ToggleBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or
       input.UserInputType == Enum.UserInputType.MouseButton1 then
        tDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if tDragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement or
        input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - tDragStart
        ToggleBtn.Position = UDim2.new(
            tStartPos.X.Scale, tStartPos.X.Offset + delta.X,
            tStartPos.Y.Scale, tStartPos.Y.Offset + delta.Y
        )
    end
end)

print("[ Ar Zero ] UI Loaded.")
