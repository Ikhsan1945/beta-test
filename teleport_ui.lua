-- [ Ar Zero ] Teleport to Base UI — Steal a Brainrot
-- Compatible: KRNL / Synapse X / Fluxus

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ══════════════════════════════════════
--         DESTROY OLD UI
-- ══════════════════════════════════════
if PlayerGui:FindFirstChild("ArZeroUI") then
    PlayerGui.ArZeroUI:Destroy()
end

-- ══════════════════════════════════════
--         SCREEN GUI
-- ══════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ArZeroUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- ══════════════════════════════════════
--         TOGGLE BUTTON
-- ══════════════════════════════════════
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(0, 110, 0, 35)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
ToggleBtn.TextColor3 = Color3.fromRGB(180, 220, 255)
ToggleBtn.Text = "[ Ar Zero ] ☰"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 13
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Parent = ScreenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = ToggleBtn

-- ══════════════════════════════════════
--         MAIN FRAME
-- ══════════════════════════════════════
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 280, 0, 320)
MainFrame.Position = UDim2.new(0, 10, 0, 55)
MainFrame.BackgroundColor3 = Color3.fromRGB(13, 13, 22)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = MainFrame

-- STROKE BORDER
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(60, 100, 200)
mainStroke.Thickness = 1.5
mainStroke.Parent = MainFrame

-- ══════════════════════════════════════
--         HEADER BAR
-- ══════════════════════════════════════
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = Header

local HeaderLabel = Instance.new("TextLabel")
HeaderLabel.Size = UDim2.new(1, -50, 1, 0)
HeaderLabel.Position = UDim2.new(0, 15, 0, 0)
HeaderLabel.BackgroundTransparency = 1
HeaderLabel.Text = "⚡ Ar Zero — Teleport"
HeaderLabel.TextColor3 = Color3.fromRGB(180, 220, 255)
HeaderLabel.Font = Enum.Font.GothamBold
HeaderLabel.TextSize = 14
HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
HeaderLabel.Parent = Header

-- CLOSE BUTTON
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0, 7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = Header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = CloseBtn

-- ══════════════════════════════════════
--         CONTENT AREA
-- ══════════════════════════════════════
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, 0, 1, -50)
Content.Position = UDim2.new(0, 0, 0, 50)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Padding = UDim.new(0, 8)
Layout.Parent = Content

local Padding = Instance.new("UIPadding")
Padding.PaddingLeft = UDim.new(0, 12)
Padding.PaddingRight = UDim.new(0, 12)
Padding.PaddingTop = UDim.new(0, 10)
Padding.Parent = Content

-- ══════════════════════════════════════
--         BUTTON FACTORY
-- ══════════════════════════════════════
local function createButton(labelText, icon, order)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 42)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 30, 60)
    Btn.Text = icon .. "  " .. labelText
    Btn.TextColor3 = Color3.fromRGB(210, 230, 255)
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 13
    Btn.BorderSizePixel = 0
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.LayoutOrder = order
    Btn.Parent = Content

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = Btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(50, 80, 180)
    btnStroke.Thickness = 1
    btnStroke.Parent = Btn

    local btnPad = Instance.new("UIPadding")
    btnPad.PaddingLeft = UDim.new(0, 12)
    btnPad.Parent = Btn

    -- Hover Effect
    Btn.MouseEnter:Connect(function()
        Btn.BackgroundColor3 = Color3.fromRGB(35, 45, 100)
    end)
    Btn.MouseLeave:Connect(function()
        Btn.BackgroundColor3 = Color3.fromRGB(25, 30, 60)
    end)

    return Btn
end

-- ══════════════════════════════════════
--         STATUS LABEL
-- ══════════════════════════════════════
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 28)
StatusLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
StatusLabel.Text = "Status : Standby"
StatusLabel.TextColor3 = Color3.fromRGB(100, 200, 120)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.BorderSizePixel = 0
StatusLabel.LayoutOrder = 99
StatusLabel.Parent = Content

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 6)
statusCorner.Parent = StatusLabel

local function setStatus(msg, color)
    StatusLabel.Text = "Status : " .. msg
    StatusLabel.TextColor3 = color or Color3.fromRGB(100, 200, 120)
end

-- ══════════════════════════════════════
--         TELEPORT LOGIC
-- ══════════════════════════════════════
local function getBase()
    -- Cari semua instance (Model, Part, dll) dengan nama pangkalan / santet
    for _, obj in ipairs(workspace:GetDescendants()) do
        local name = obj.Name:lower()
        if name:find("pangkalan") or name:find("santet") then
            -- Jika Model, ambil PrimaryPart atau Part pertama
            if obj:IsA("Model") then
                if obj.PrimaryPart then
                    return obj.PrimaryPart
                else
                    local part = obj:FindFirstChildWhichIsA("BasePart")
                    if part then return part end
                end
            elseif obj:IsA("BasePart") then
                return obj
            end
        end
    end

    -- Fallback: cari SpawnLocation milik player
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("SpawnLocation") then
            return obj
        end
    end

    return nil
end

local function teleportToBase()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then
        setStatus("Character tidak ditemukan.", Color3.fromRGB(255, 80, 80))
        return
    end

    local base = getBase()
    if base then
        root.CFrame = base.CFrame + Vector3.new(0, 5, 0)
        setStatus("Teleport berhasil!", Color3.fromRGB(100, 200, 120))
    else
        setStatus("Base tidak ditemukan.", Color3.fromRGB(255, 180, 50))
    end
end

local function teleportToCoord(x, y, z)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    root.CFrame = CFrame.new(x, y, z)
    setStatus("Teleport ke koordinat.", Color3.fromRGB(100, 200, 120))
end

-- ══════════════════════════════════════
--         BUTTONS
-- ══════════════════════════════════════
local BtnBase   = createButton("Teleport to Base", "🏠", 1)
local BtnSpawn  = createButton("Teleport to Spawn", "📍", 2)
local BtnCenter = createButton("Teleport to Center Map", "🗺️", 3)
local BtnCustom = createButton("Teleport to (0, 50, 0)", "🎯", 4)

BtnBase.MouseButton1Click:Connect(function()
    teleportToBase()
end)

BtnSpawn.MouseButton1Click:Connect(function()
    local spawnLoc = workspace:FindFirstChild("SpawnLocation")
    if spawnLoc then
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = spawnLoc.CFrame + Vector3.new(0, 5, 0)
            setStatus("Teleport ke Spawn.", Color3.fromRGB(100, 200, 120))
        end
    else
        setStatus("SpawnLocation tidak ada.", Color3.fromRGB(255, 80, 80))
    end
end)

BtnCenter.MouseButton1Click:Connect(function()
    teleportToCoord(0, 50, 0)
end)

BtnCustom.MouseButton1Click:Connect(function()
    teleportToCoord(0, 50, 0)
end)

-- ══════════════════════════════════════
--         TOGGLE LOGIC
-- ══════════════════════════════════════
local isOpen = true

local function setMenu(open)
    isOpen = open
    MainFrame.Visible = open
end

ToggleBtn.MouseButton1Click:Connect(function()
    setMenu(not isOpen)
end)

CloseBtn.MouseButton1Click:Connect(function()
    setMenu(false)
end)

-- ══════════════════════════════════════
--         DRAGGABLE FRAME
-- ══════════════════════════════════════
local dragging, dragInput, dragStart, startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

print("[ Ar Zero ] UI Loaded.")
