-- Chilli.lua
-- Advanced Dupe Brainrot | Steal a Brainrot
-- By Ar Zero | Fixed: Workspace Scanner + Clean UI

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ============ CONFIG ============
local DUPE_DELAY = 0.1

-- ============ REMOTE SCANNER ============
local function getAllRemotes()
    local remotes = {}
    local function scan(obj)
        for _, v in ipairs(obj:GetChildren()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                table.insert(remotes, v)
            end
            scan(v)
        end
    end
    scan(ReplicatedStorage)
    scan(game:GetService("Workspace"))
    return remotes
end

local function findBestRemote()
    local keywords = {
        "place", "spawn", "give", "add", "dupe",
        "brainrot", "unit", "deploy", "set", "put"
    }
    local remotes = getAllRemotes()
    for _, r in ipairs(remotes) do
        local name = r.Name:lower()
        for _, kw in ipairs(keywords) do
            if name:find(kw) then
                return r
            end
        end
    end
    -- fallback: return first remote found
    return remotes[1]
end

-- ============ WORKSPACE BRAINROT SCANNER ============
local function scanWorkspaceBrainrots()
    local found = {}
    local seen = {}
    local playerName = LocalPlayer.Name

    -- Scan seluruh workspace
    local function deepScan(parent, depth)
        if depth > 6 then return end
        for _, obj in ipairs(parent:GetChildren()) do
            -- Cek apakah object milik player (cek attribute atau nama folder)
            local isOwned = false

            -- Cek via attribute Owner/PlayerId
            local ownerAttr = obj:GetAttribute("Owner") or
                              obj:GetAttribute("owner") or
                              obj:GetAttribute("PlayerId") or
                              obj:GetAttribute("OwnerId")

            if ownerAttr then
                if tostring(ownerAttr) == tostring(LocalPlayer.UserId) or
                   tostring(ownerAttr) == playerName then
                    isOwned = true
                end
            end

            -- Cek via folder nama player
            if parent.Name == playerName or parent.Name == tostring(LocalPlayer.UserId) then
                isOwned = true
            end

            -- Cek via StringValue "Owner" di dalam object
            local ownerVal = obj:FindFirstChild("Owner") or obj:FindFirstChild("owner")
            if ownerVal and ownerVal:IsA("StringValue") then
                if ownerVal.Value == playerName or ownerVal.Value == tostring(LocalPlayer.UserId) then
                    isOwned = true
                end
            end

            if isOwned and obj:IsA("Model") and not seen[obj.Name] then
                seen[obj.Name] = true
                table.insert(found, {
                    name = obj.Name,
                    instance = obj
                })
            end

            deepScan(obj, depth + 1)
        end
    end

    deepScan(game:GetService("Workspace"), 0)

    -- Juga scan folder khusus player jika ada
    local playerFolder = game:GetService("Workspace"):FindFirstChild(playerName) or
                         game:GetService("Workspace"):FindFirstChild(tostring(LocalPlayer.UserId))

    if playerFolder then
        for _, obj in ipairs(playerFolder:GetDescendants()) do
            if obj:IsA("Model") and not seen[obj.Name] then
                seen[obj.Name] = true
                table.insert(found, {
                    name = obj.Name,
                    instance = obj
                })
            end
        end
    end

    -- Fallback: scan semua model di workspace dan tampilkan semua
    if #found == 0 then
        for _, obj in ipairs(game:GetService("Workspace"):GetDescendants()) do
            if obj:IsA("Model") and obj.Name ~= "Map" and obj.Name ~= "Baseplate"
               and obj.Name ~= "Camera" and not seen[obj.Name]
               and obj.Name ~= LocalPlayer.Name then
                seen[obj.Name] = true
                table.insert(found, {
                    name = obj.Name,
                    instance = obj
                })
            end
        end
    end

    return found
end

-- ============ DUPE ============
local function doDupe(name, amount, remote)
    for i = 1, amount do
        pcall(function()
            if remote:IsA("RemoteEvent") then
                remote:FireServer(name)
            elseif remote:IsA("RemoteFunction") then
                remote:InvokeServer(name)
            end
        end)
        task.wait(DUPE_DELAY)
    end
end

-- ============ UI ============
-- Hapus GUI lama jika ada
local oldGui = LocalPlayer.PlayerGui:FindFirstChild("ArZeroUI")
if oldGui then oldGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ArZeroUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Shadow
local Shadow = Instance.new("Frame")
Shadow.Size = UDim2.new(0, 374, 0, 494)
Shadow.Position = UDim2.new(0, 13, 0, 13)
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BackgroundTransparency = 0.7
Shadow.BorderSizePixel = 0
Shadow.Parent = ScreenGui
Instance.new("UICorner", Shadow).CornerRadius = UDim.new(0, 12)

-- Main
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 370, 0, 490)
Main.Position = UDim2.new(0, 10, 0, 10)
Main.BackgroundColor3 = Color3.fromRGB(13, 13, 18)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- Accent bar top
local Accent = Instance.new("Frame")
Accent.Size = UDim2.new(1, 0, 0, 3)
Accent.Position = UDim2.new(0, 0, 0, 0)
Accent.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
Accent.BorderSizePixel = 0
Accent.Parent = Main

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 44)
TitleBar.Position = UDim2.new(0, 0, 0, 3)
TitleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main

local TitleIcon = Instance.new("TextLabel")
TitleIcon.Text = "⚡"
TitleIcon.Size = UDim2.new(0, 30, 1, 0)
TitleIcon.Position = UDim2.new(0, 12, 0, 0)
TitleIcon.BackgroundTransparency = 1
TitleIcon.TextColor3 = Color3.fromRGB(88, 101, 242)
TitleIcon.Font = Enum.Font.GothamBold
TitleIcon.TextSize = 16
TitleIcon.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Text = "Ar Zero — Dupe Brainrot"
TitleText.Size = UDim2.new(1, -100, 1, 0)
TitleText.Position = UDim2.new(0, 44, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 13
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "✕"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Drag
local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or
       i.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = i.Position
        startPos = Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging then
        if i.UserInputType == Enum.UserInputType.MouseMovement or
           i.UserInputType == Enum.UserInputType.Touch then
            local d = i.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                       startPos.Y.Scale, startPos.Y.Offset + d.Y)
            Shadow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X + 3,
                                         startPos.Y.Scale, startPos.Y.Offset + d.Y + 3)
        end
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or
       i.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Content Area
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, 0, 1, -47)
Content.Position = UDim2.new(0, 0, 0, 47)
Content.BackgroundTransparency = 1
Content.Parent = Main

-- Status Bar
local StatusBG = Instance.new("Frame")
StatusBG.Size = UDim2.new(1, -24, 0, 30)
StatusBG.Position = UDim2.new(0, 12, 0, 10)
StatusBG.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
StatusBG.BorderSizePixel = 0
StatusBG.Parent = Content
Instance.new("UICorner", StatusBG).CornerRadius = UDim.new(0, 8)

local StatusDot = Instance.new("Frame")
StatusDot.Size = UDim2.new(0, 8, 0, 8)
StatusDot.Position = UDim2.new(0, 10, 0.5, -4)
StatusDot.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
StatusDot.BorderSizePixel = 0
StatusDot.Parent = StatusBG
Instance.new("UICorner", StatusDot).CornerRadius = UDim.new(1, 0)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Text = "Idle — Klik Scan untuk mulai"
StatusLabel.Size = UDim2.new(1, -30, 1, 0)
StatusLabel.Position = UDim2.new(0, 24, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(160, 160, 180)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 11
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = StatusBG

local function setStatus(text, color)
    StatusLabel.Text = text
    StatusDot.BackgroundColor3 = color or Color3.fromRGB(128, 128, 128)
end

-- Scan Button
local ScanBtn = Instance.new("TextButton")
ScanBtn.Text = "🔍  Scan Brainrot di Base"
ScanBtn.Size = UDim2.new(1, -24, 0, 38)
ScanBtn.Position = UDim2.new(0, 12, 0, 48)
ScanBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
ScanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanBtn.Font = Enum.Font.GothamBold
ScanBtn.TextSize = 13
ScanBtn.BorderSizePixel = 0
ScanBtn.Parent = Content
Instance.new("UICorner", ScanBtn).CornerRadius = UDim.new(0, 8)

-- List Header
local ListHeader = Instance.new("TextLabel")
ListHeader.Text = "BRAINROT TERDETEKSI"
ListHeader.Size = UDim2.new(1, -24, 0, 20)
ListHeader.Position = UDim2.new(0, 12, 0, 94)
ListHeader.BackgroundTransparency = 1
ListHeader.TextColor3 = Color3.fromRGB(88, 101, 242)
ListHeader.Font = Enum.Font.GothamBold
ListHeader.TextSize = 10
ListHeader.TextXAlignment = Enum.TextXAlignment.Left
ListHeader.Parent = Content

-- List Frame
local ListBG = Instance.new("Frame")
ListBG.Size = UDim2.new(1, -24, 0, 175)
ListBG.Position = UDim2.new(0, 12, 0, 116)
ListBG.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
ListBG.BorderSizePixel = 0
ListBG.Parent = Content
Instance.new("UICorner", ListBG).CornerRadius = UDim.new(0, 8)

local ListFrame = Instance.new("ScrollingFrame")
ListFrame.Size = UDim2.new(1, -8, 1, -8)
ListFrame.Position = UDim2.new(0, 4, 0, 4)
ListFrame.BackgroundTransparency = 1
ListFrame.BorderSizePixel = 0
ListFrame.ScrollBarThickness = 3
ListFrame.ScrollBarImageColor3 = Color3.fromRGB(88, 101, 242)
ListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ListFrame.Parent = ListBG

local UIList = Instance.new("UIListLayout")
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 3)
UIList.Parent = ListFrame

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingLeft = UDim.new(0, 4)
UIPadding.PaddingRight = UDim.new(0, 4)
UIPadding.PaddingTop = UDim.new(0, 2)
UIPadding.Parent = ListFrame

-- Empty label
local EmptyLabel = Instance.new("TextLabel")
EmptyLabel.Text = "Belum ada scan — klik tombol di atas"
EmptyLabel.Size = UDim2.new(1, 0, 1, 0)
EmptyLabel.BackgroundTransparency = 1
EmptyLabel.TextColor3 = Color3.fromRGB(80, 80, 100)
EmptyLabel.Font = Enum.Font.Gotham
EmptyLabel.TextSize = 11
EmptyLabel.Parent = ListBG

-- Selected Info
local SelBG = Instance.new("Frame")
SelBG.Size = UDim2.new(1, -24, 0, 34)
SelBG.Position = UDim2.new(0, 12, 0, 298)
SelBG.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
SelBG.BorderSizePixel = 0
SelBG.Parent = Content
Instance.new("UICorner", SelBG).CornerRadius = UDim.new(0, 8)

local SelIcon = Instance.new("TextLabel")
SelIcon.Text = "▶"
SelIcon.Size = UDim2.new(0, 20, 1, 0)
SelIcon.Position = UDim2.new(0, 10, 0, 0)
SelIcon.BackgroundTransparency = 1
SelIcon.TextColor3 = Color3.fromRGB(88, 101, 242)
SelIcon.Font = Enum.Font.GothamBold
SelIcon.TextSize = 11
SelIcon.Parent = SelBG

local SelLabel = Instance.new("TextLabel")
SelLabel.Text = "Belum dipilih"
SelLabel.Size = UDim2.new(1, -35, 1, 0)
SelLabel.Position = UDim2.new(0, 30, 0, 0)
SelLabel.BackgroundTransparency = 1
SelLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
SelLabel.Font = Enum.Font.GothamBold
SelLabel.TextSize = 12
SelLabel.TextXAlignment = Enum.TextXAlignment.Left
SelLabel.TextTruncate = Enum.TextTruncate.AtEnd
SelLabel.Parent = SelBG

-- Amount Row
local AmountRow = Instance.new("Frame")
AmountRow.Size = UDim2.new(1, -24, 0, 38)
AmountRow.Position = UDim2.new(0, 12, 0, 340)
AmountRow.BackgroundTransparency = 1
AmountRow.Parent = Content

local AmountLabel = Instance.new("TextLabel")
AmountLabel.Text = "Jumlah Dupe"
AmountLabel.Size = UDim2.new(0, 110, 1, 0)
AmountLabel.BackgroundTransparency = 1
AmountLabel.TextColor3 = Color3.fromRGB(160, 160, 180)
AmountLabel.Font = Enum.Font.Gotham
AmountLabel.TextSize = 12
AmountLabel.TextXAlignment = Enum.TextXAlignment.Left
AmountLabel.Parent = AmountRow

-- Minus button
local MinusBtn = Instance.new("TextButton")
MinusBtn.Text = "−"
MinusBtn.Size = UDim2.new(0, 34, 0, 34)
MinusBtn.Position = UDim2.new(0, 112, 0.5, -17)
MinusBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
MinusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinusBtn.Font = Enum.Font.GothamBold
MinusBtn.TextSize = 18
MinusBtn.BorderSizePixel = 0
MinusBtn.Parent = AmountRow
Instance.new("UICorner", MinusBtn).CornerRadius = UDim.new(0, 8)

local AmountBox = Instance.new("TextBox")
AmountBox.Text = "10"
AmountBox.Size = UDim2.new(0, 70, 0, 34)
AmountBox.Position = UDim2.new(0, 150, 0.5, -17)
AmountBox.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
AmountBox.TextColor3 = Color3.fromRGB(255, 255, 255)
AmountBox.Font = Enum.Font.GothamBold
AmountBox.TextSize = 14
AmountBox.TextXAlignment = Enum.TextXAlignment.Center
AmountBox.BorderSizePixel = 0
AmountBox.Parent = AmountRow
Instance.new("UICorner", AmountBox).CornerRadius = UDim.new(0, 8)

local PlusBtn = Instance.new("TextButton")
PlusBtn.Text = "+"
PlusBtn.Size = UDim2.new(0, 34, 0, 34)
PlusBtn.Position = UDim2.new(0, 224, 0.5, -17)
PlusBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
PlusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PlusBtn.Font = Enum.Font.GothamBold
PlusBtn.TextSize = 18
PlusBtn.BorderSizePixel = 0
PlusBtn.Parent = AmountRow
Instance.new("UICorner", PlusBtn).CornerRadius = UDim.new(0, 8)

MinusBtn.MouseButton1Click:Connect(function()
    local v = tonumber(AmountBox.Text) or 10
    AmountBox.Text = tostring(math.max(1, v - 10))
end)
PlusBtn.MouseButton1Click:Connect(function()
    local v = tonumber(AmountBox.Text) or 10
    AmountBox.Text = tostring(v + 10)
end)

-- Dupe Button
local DupeBtn = Instance.new("TextButton")
DupeBtn.Text = "⚡  DUPE SEKARANG"
DupeBtn.Size = UDim2.new(1, -24, 0, 44)
DupeBtn.Position = UDim2.new(0, 12, 0, 386)
DupeBtn.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
DupeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DupeBtn.Font = Enum.Font.GothamBold
DupeBtn.TextSize = 14
DupeBtn.BorderSizePixel = 0
DupeBtn.Parent = Content
Instance.new("UICorner", DupeBtn).CornerRadius = UDim.new(0, 8)

-- Remote label
local RemoteLabel = Instance.new("TextLabel")
RemoteLabel.Text = "Remote: Scanning..."
RemoteLabel.Size = UDim2.new(1, -24, 0, 18)
RemoteLabel.Position = UDim2.new(0, 12, 0, 436)
RemoteLabel.BackgroundTransparency = 1
RemoteLabel.TextColor3 = Color3.fromRGB(80, 80, 100)
RemoteLabel.Font = Enum.Font.Gotham
RemoteLabel.TextSize = 10
RemoteLabel.TextXAlignment = Enum.TextXAlignment.Left
RemoteLabel.Parent = Content

-- ============ LOGIC ============
local scannedList = {}
local selectedBrainrot = nil
local detectedRemote = nil

-- Auto detect remote on start
task.spawn(function()
    task.wait(2)
    detectedRemote = findBestRemote()
    if detectedRemote then
        RemoteLabel.Text = "Remote: " .. detectedRemote.Name
        RemoteLabel.TextColor3 = Color3.fromRGB(87, 242, 135)
    else
        RemoteLabel.Text = "Remote: Tidak ditemukan"
        RemoteLabel.TextColor3 = Color3.fromRGB(237, 66, 69)
    end
end)

ScanBtn.MouseButton1Click:Connect(function()
    ScanBtn.Text = "⏳  Scanning..."
    ScanBtn.BackgroundColor3 = Color3.fromRGB(60, 70, 160)
    setStatus("Scanning workspace...", Color3.fromRGB(255, 200, 50))
    EmptyLabel.Visible = false

    for _, c in ipairs(ListFrame:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    scannedList = {}
    selectedBrainrot = nil
    SelLabel.Text = "Belum dipilih"

    task.wait(0.5)
    scannedList = scanWorkspaceBrainrots()

    if #scannedList == 0 then
        EmptyLabel.Visible = true
        EmptyLabel.Text = "Tidak ada brainrot ditemukan\nCoba masuk ke base dulu"
        setStatus("Tidak ada brainrot", Color3.fromRGB(237, 66, 69))
        ScanBtn.Text = "🔍  Scan Brainrot di Base"
        ScanBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        return
    end

    for i, item in ipairs(scannedList) do
        local Btn = Instance.new("TextButton")
        Btn.Text = "  " .. item.name
        Btn.Size = UDim2.new(1, 0, 0, 32)
        Btn.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
        Btn.TextColor3 = Color3.fromRGB(210, 210, 230)
        Btn.Font = Enum.Font.Gotham
        Btn.TextSize = 12
        Btn.TextXAlignment = Enum.TextXAlignment.Left
        Btn.BorderSizePixel = 0
        Btn.LayoutOrder = i
        Btn.Parent = ListFrame
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

        Btn.MouseButton1Click:Connect(function()
            selectedBrainrot = item.name
            SelLabel.Text = item.name
            for _, c in ipairs(ListFrame:GetChildren()) do
                if c:IsA("TextButton") then
                    c.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
                    c.TextColor3 = Color3.fromRGB(210, 210, 230)
                end
            end
            Btn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            setStatus("Dipilih: " .. item.name, Color3.fromRGB(87, 242, 135))
        end)
    end

    ListFrame.CanvasSize = UDim2.new(0, 0, 0, #scannedList * 35)
    setStatus("Scan selesai — " .. #scannedList .. " brainrot", Color3.fromRGB(87, 242, 135))
    ScanBtn.Text = "🔄  Scan Ulang"
    ScanBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
end)

DupeBtn.MouseButton1Click:Connect(function()
    if not selectedBrainrot then
        setStatus("Pilih brainrot dulu!", Color3.fromRGB(237, 66, 69))
        return
    end
    local amount = tonumber(AmountBox.Text)
    if not amount or amount <= 0 then
        setStatus("Jumlah tidak valid!", Color3.fromRGB(237, 66, 69))
        return
    end
    if not detectedRemote then
        detectedRemote = findBestRemote()
    end
    if not detectedRemote then
        setStatus("Remote tidak ditemukan!", Color3.fromRGB(237, 66, 69))
        return
    end

    DupeBtn.Text = "⏳  Duping..."
    DupeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
    setStatus("Duping " .. selectedBrainrot .. " x" .. amount .. "...", Color3.fromRGB(255, 200, 50))

    task.spawn(function()
        doDupe(selectedBrainrot, amount, detectedRemote)
        DupeBtn.Text = "⚡  DUPE SEKARANG"
        DupeBtn.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
        setStatus("Selesai! " .. selectedBrainrot .. " x" .. amount .. " ✓", Color3.fromRGB(87, 242, 135))
    end)
end)

print("[Ar Zero] Loaded — Steal a Brainrot | Fixed Workspace Scanner")
