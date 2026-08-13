-- Chilli.lua
-- Advanced Dupe Brainrot | Steal a Brainrot
-- By Ar Zero

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- ============ CONFIG ============
local DUPE_DELAY = 0.08
local SCAN_PATHS = {
    LocalPlayer,
    LocalPlayer:WaitForChild("Backpack", 5),
}

-- ============ UTILITY ============
local function findRemote(names)
    for _, name in ipairs(names) do
        local r = ReplicatedStorage:FindFirstChild(name, true)
        if r then return r end
    end
    return nil
end

local function scanBrainrots()
    local found = {}
    local scanned = {}

    for _, path in ipairs(SCAN_PATHS) do
        if path then
            for _, item in ipairs(path:GetChildren()) do
                if not scanned[item.Name] then
                    scanned[item.Name] = true
                    table.insert(found, {
                        name = item.Name,
                        instance = item
                    })
                end
            end
        end
    end

    local ls = LocalPlayer:FindFirstChild("leaderstats")
    if ls then
        for _, v in ipairs(ls:GetChildren()) do
            if not scanned[v.Name] then
                scanned[v.Name] = true
                table.insert(found, {
                    name = v.Name .. " [stat]",
                    instance = v
                })
            end
        end
    end

    return found
end

local function dupeBrainrot(name, amount, remote)
    print("[Ar Zero] Memulai dupe: " .. name .. " x" .. amount)
    for i = 1, amount do
        pcall(function()
            remote:FireServer(name)
        end)
        task.wait(DUPE_DELAY)
        if i % 10 == 0 then
            print("[Ar Zero] Progress: " .. i .. "/" .. amount)
        end
    end
    print("[Ar Zero] Dupe selesai: " .. name .. " x" .. amount)
end

-- ============ UI ============
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ArZeroDupe"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 360, 0, 480)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 10)
UICorner2.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "⚡ Ar Zero — Dupe Brainrot"
TitleLabel.Size = UDim2.new(1, -10, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
TitleBar.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)
TitleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Text = "Status: Idle"
StatusLabel.Size = UDim2.new(1, -20, 0, 25)
StatusLabel.Position = UDim2.new(0, 10, 0, 48)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainFrame

local ScanBtn = Instance.new("TextButton")
ScanBtn.Text = "🔍 Scan Brainrot"
ScanBtn.Size = UDim2.new(1, -20, 0, 36)
ScanBtn.Position = UDim2.new(0, 10, 0, 78)
ScanBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 220)
ScanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanBtn.Font = Enum.Font.GothamBold
ScanBtn.TextSize = 13
ScanBtn.BorderSizePixel = 0
ScanBtn.Parent = MainFrame

local UICorner3 = Instance.new("UICorner")
UICorner3.CornerRadius = UDim.new(0, 8)
UICorner3.Parent = ScanBtn

local ListFrame = Instance.new("ScrollingFrame")
ListFrame.Size = UDim2.new(1, -20, 0, 180)
ListFrame.Position = UDim2.new(0, 10, 0, 124)
ListFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
ListFrame.BorderSizePixel = 0
ListFrame.ScrollBarThickness = 4
ListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ListFrame.Parent = MainFrame

local UICorner4 = Instance.new("UICorner")
UICorner4.CornerRadius = UDim.new(0, 8)
UICorner4.Parent = ListFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)
UIListLayout.Parent = ListFrame

local SelectedLabel = Instance.new("TextLabel")
SelectedLabel.Text = "Dipilih: —"
SelectedLabel.Size = UDim2.new(1, -20, 0, 22)
SelectedLabel.Position = UDim2.new(0, 10, 0, 314)
SelectedLabel.BackgroundTransparency = 1
SelectedLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
SelectedLabel.Font = Enum.Font.GothamBold
SelectedLabel.TextSize = 12
SelectedLabel.TextXAlignment = Enum.TextXAlignment.Left
SelectedLabel.Parent = MainFrame

local AmountLabel = Instance.new("TextLabel")
AmountLabel.Text = "Jumlah Dupe:"
AmountLabel.Size = UDim2.new(0, 100, 0, 30)
AmountLabel.Position = UDim2.new(0, 10, 0, 342)
AmountLabel.BackgroundTransparency = 1
AmountLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
AmountLabel.Font = Enum.Font.Gotham
AmountLabel.TextSize = 12
AmountLabel.TextXAlignment = Enum.TextXAlignment.Left
AmountLabel.Parent = MainFrame

local AmountBox = Instance.new("TextBox")
AmountBox.PlaceholderText = "Contoh: 50"
AmountBox.Text = "10"
AmountBox.Size = UDim2.new(0, 100, 0, 30)
AmountBox.Position = UDim2.new(0, 115, 0, 342)
AmountBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
AmountBox.TextColor3 = Color3.fromRGB(255, 255, 255)
AmountBox.Font = Enum.Font.Gotham
AmountBox.TextSize = 13
AmountBox.BorderSizePixel = 0
AmountBox.Parent = MainFrame

local UICorner5 = Instance.new("UICorner")
UICorner5.CornerRadius = UDim.new(0, 6)
UICorner5.Parent = AmountBox

local DupeBtn = Instance.new("TextButton")
DupeBtn.Text = "⚡ DUPE SEKARANG"
DupeBtn.Size = UDim2.new(1, -20, 0, 40)
DupeBtn.Position = UDim2.new(0, 10, 0, 386)
DupeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
DupeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DupeBtn.Font = Enum.Font.GothamBold
DupeBtn.TextSize = 14
DupeBtn.BorderSizePixel = 0
DupeBtn.Parent = MainFrame

local UICorner6 = Instance.new("UICorner")
UICorner6.CornerRadius = UDim.new(0, 8)
UICorner6.Parent = DupeBtn

-- ============ LOGIC ============
local scannedList = {}
local selectedBrainrot = nil

local REMOTE_NAMES = {
    "PlaceBrainrot", "AddBrainrot", "SpawnBrainrot",
    "GiveBrainrot", "DupeBrainrot", "RequestBrainrot"
}

ScanBtn.MouseButton1Click:Connect(function()
    StatusLabel.Text = "Status: Scanning..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)

    for _, c in ipairs(ListFrame:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    scannedList = {}
    selectedBrainrot = nil
    SelectedLabel.Text = "Dipilih: —"

    task.wait(0.3)
    scannedList = scanBrainrots()

    if #scannedList == 0 then
        StatusLabel.Text = "Status: Tidak ada item ditemukan"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end

    for i, item in ipairs(scannedList) do
        local btn = Instance.new("TextButton")
        btn.Text = "  " .. item.name
        btn.Size = UDim2.new(1, -8, 0, 30)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
        btn.TextColor3 = Color3.fromRGB(220, 220, 220)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.BorderSizePixel = 0
        btn.LayoutOrder = i
        btn.Parent = ListFrame

        local bc = Instance.new("UICorner")
        bc.CornerRadius = UDim.new(0, 6)
        bc.Parent = btn

        btn.MouseButton1Click:Connect(function()
            selectedBrainrot = item.name
            SelectedLabel.Text = "Dipilih: " .. item.name
            for _, c in ipairs(ListFrame:GetChildren()) do
                if c:IsA("TextButton") then
                    c.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
                end
            end
            btn.BackgroundColor3 = Color3.fromRGB(50, 120, 220)
        end)
    end

    ListFrame.CanvasSize = UDim2.new(0, 0, 0, #scannedList * 34)
    StatusLabel.Text = "Status: Scan selesai — " .. #scannedList .. " item"
    StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
end)

DupeBtn.MouseButton1Click:Connect(function()
    if not selectedBrainrot then
        StatusLabel.Text = "Status: Pilih brainrot dulu!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end

    local amount = tonumber(AmountBox.Text)
    if not amount or amount <= 0 then
        StatusLabel.Text = "Status: Jumlah tidak valid!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end

    local remote = findRemote(REMOTE_NAMES)
    if not remote then
        StatusLabel.Text = "Status: Remote tidak ditemukan!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end

    DupeBtn.Text = "⏳ Duping..."
    DupeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    StatusLabel.Text = "Status: Duping " .. selectedBrainrot .. " x" .. amount
    StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)

    task.spawn(function()
        dupeBrainrot(selectedBrainrot, amount, remote)
        DupeBtn.Text = "⚡ DUPE SEKARANG"
        DupeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        StatusLabel.Text = "Status: Done ✓"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
    end)
end)

print("[Ar Zero] UI Loaded — Steal a Brainrot Dupe Ready")
