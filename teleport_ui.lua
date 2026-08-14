-- [ Ar Zero ] Cheat UI — Steal a Brainrot
-- Compatible: KRNL / Synapse X / Fluxus

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ══════════════════════════════════════
--         DESTROY OLD UI
-- ══════════════════════════════════════
if PlayerGui:FindFirstChild("ArZeroUI") then
    PlayerGui.ArZeroUI:Destroy()
end

-- ══════════════════════════════════════
--         STATE
-- ══════════════════════════════════════
local savedBasePosition = nil
local spawnPosition     = nil
local noclipEnabled     = false
local speedEnabled      = false
local antiAfkEnabled    = false
local autoStealEnabled  = false
local noclipConn        = nil
local autoStealConn     = nil
local antiAfkConn       = nil

-- Rekam spawn awal
local function recordSpawn()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart", 5)
    if root then task.wait(1); spawnPosition = root.CFrame end
end
task.spawn(recordSpawn)
LocalPlayer.CharacterAdded:Connect(function(char)
    local root = char:WaitForChild("HumanoidRootPart", 5)
    if root then task.wait(1); spawnPosition = root.CFrame end
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
ToggleBtn.Size = UDim2.new(0, 126, 0, 36)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(14, 14, 26)
ToggleBtn.TextColor3 = Color3.fromRGB(160, 210, 255)
ToggleBtn.Text = "⚡ Ar Zero  ☰"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 13
ToggleBtn.BorderSizePixel = 0
ToggleBtn.ZIndex = 10
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 9)
local tStroke = Instance.new("UIStroke", ToggleBtn)
tStroke.Color = Color3.fromRGB(60, 100, 210)
tStroke.Thickness = 1.4

-- ══════════════════════════════════════
--         MAIN FRAME
-- ══════════════════════════════════════
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 275, 0, 400)
MainFrame.Position = UDim2.new(0, 10, 0, 55)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 19)
MainFrame.BorderSizePixel = 0
MainFrame.ZIndex = 5
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)
local mStroke = Instance.new("UIStroke", MainFrame)
mStroke.Color = Color3.fromRGB(50, 90, 210)
mStroke.Thickness = 1.5

-- ══════════════════════════════════════
--         HEADER
-- ══════════════════════════════════════
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 46)
Header.BackgroundColor3 = Color3.fromRGB(16, 16, 44)
Header.BorderSizePixel = 0
Header.ZIndex = 6
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 14)

local HeaderLabel = Instance.new("TextLabel")
HeaderLabel.Size = UDim2.new(1, -50, 1, 0)
HeaderLabel.Position = UDim2.new(0, 14, 0, 0)
HeaderLabel.BackgroundTransparency = 1
HeaderLabel.Text = "⚡ Ar Zero — Menu"
HeaderLabel.TextColor3 = Color3.fromRGB(170, 215, 255)
HeaderLabel.Font = Enum.Font.GothamBold
HeaderLabel.TextSize = 14
HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
HeaderLabel.ZIndex = 7
HeaderLabel.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -36, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(175, 32, 32)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 8
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- ══════════════════════════════════════
--         SECTION LABEL
-- ══════════════════════════════════════
local function makeSection(parent, text, order)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 22)
    lbl.BackgroundTransparency = 1
    lbl.Text = "  " .. text
    lbl.TextColor3 = Color3.fromRGB(100, 140, 210)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.LayoutOrder = order
    lbl.ZIndex = 7
    lbl.Parent = parent
    return lbl
end

-- ══════════════════════════════════════
--         SCROLL FRAME
-- ══════════════════════════════════════
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, -50)
ScrollFrame.Position = UDim2.new(0, 0, 0, 50)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 100, 210)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollFrame.ZIndex = 6
ScrollFrame.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Padding = UDim.new(0, 6)
Layout.Parent = ScrollFrame

local Pad = Instance.new("UIPadding")
Pad.PaddingLeft = UDim.new(0, 12)
Pad.PaddingRight = UDim.new(0, 14)
Pad.PaddingTop = UDim.new(0, 10)
Pad.PaddingBottom = UDim.new(0, 10)
Pad.Parent = ScrollFrame

-- ══════════════════════════════════════
--         BUTTON FACTORY (Normal)
-- ══════════════════════════════════════
local function createBtn(text, icon, order, bgColor)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 42)
    Btn.BackgroundColor3 = bgColor or Color3.fromRGB(20, 26, 55)
    Btn.Text = icon .. "  " .. text
    Btn.TextColor3 = Color3.fromRGB(205, 228, 255)
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 13
    Btn.BorderSizePixel = 0
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.LayoutOrder = order
    Btn.ZIndex = 7
    Btn.Parent = ScrollFrame
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 9)
    local s = Instance.new("UIStroke", Btn)
    s.Color = Color3.fromRGB(45, 75, 180)
    s.Thickness = 1
    local p = Instance.new("UIPadding", Btn)
    p.PaddingLeft = UDim.new(0, 12)
    local base = bgColor or Color3.fromRGB(20, 26, 55)
    Btn.MouseEnter:Connect(function() Btn.BackgroundColor3 = Color3.fromRGB(32, 42, 100) end)
    Btn.MouseLeave:Connect(function() Btn.BackgroundColor3 = base end)
    return Btn
end

-- ══════════════════════════════════════
--         TOGGLE BUTTON FACTORY
-- ══════════════════════════════════════
local COLOR_OFF = Color3.fromRGB(20, 26, 55)
local COLOR_ON  = Color3.fromRGB(18, 70, 30)

local function createToggleBtn(text, icon, order)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 42)
    Btn.BackgroundColor3 = COLOR_OFF
    Btn.Text = icon .. "  " .. text .. "  —  OFF"
    Btn.TextColor3 = Color3.fromRGB(205, 228, 255)
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 13
    Btn.BorderSizePixel = 0
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.LayoutOrder = order
    Btn.ZIndex = 7
    Btn.Parent = ScrollFrame
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 9)
    local s = Instance.new("UIStroke", Btn)
    s.Color = Color3.fromRGB(45, 75, 180)
    s.Thickness = 1
    local p = Instance.new("UIPadding", Btn)
    p.PaddingLeft = UDim.new(0, 12)

    local function setVisual(on)
        if on then
            Btn.BackgroundColor3 = COLOR_ON
            Btn.Text = icon .. "  " .. text .. "  —  ON"
            s.Color = Color3.fromRGB(40, 180, 80)
        else
            Btn.BackgroundColor3 = COLOR_OFF
            Btn.Text = icon .. "  " .. text .. "  —  OFF"
            s.Color = Color3.fromRGB(45, 75, 180)
        end
    end

    return Btn, setVisual
end

-- ══════════════════════════════════════
--         STATUS BAR
-- ══════════════════════════════════════
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 26)
StatusLabel.BackgroundColor3 = Color3.fromRGB(8, 8, 18)
StatusLabel.Text = "Status : Standby"
StatusLabel.TextColor3 = Color3.fromRGB(100, 200, 120)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 11
StatusLabel.BorderSizePixel = 0
StatusLabel.LayoutOrder = 999
StatusLabel.ZIndex = 7
StatusLabel.Parent = ScrollFrame
Instance.new("UICorner", StatusLabel).CornerRadius = UDim.new(0, 6)

local function setStatus(msg, color)
    StatusLabel.Text = "Status : " .. msg
    StatusLabel.TextColor3 = color or Color3.fromRGB(100, 200, 120)
end

-- ══════════════════════════════════════
--         BUILD MENU
-- ══════════════════════════════════════

-- [ TELEPORT ]
makeSection(ScrollFrame, "── TELEPORT ──", 1)
local BtnSaveBase = createBtn("Save Posisi Base", "💾", 2, Color3.fromRGB(18, 45, 20))
local BtnBase     = createBtn("Teleport to Base", "🏠", 3)
local BtnSpawn    = createBtn("Teleport to Spawn", "📍", 4)

-- [ MOVEMENT ]
makeSection(ScrollFrame, "── MOVEMENT ──", 10)
local BtnNoclip, setNoclip   = createToggleBtn("Noclip", "👻", 11)
local BtnSpeed,  setSpeed    = createToggleBtn("Speed Hack", "⚡", 12)

-- [ FARM ]
makeSection(ScrollFrame, "── FARM ──", 20)
local BtnAutoSteal, setAutoSteal = createToggleBtn("Auto Steal", "🤖", 21)

-- [ UTILITY ]
makeSection(ScrollFrame, "── UTILITY ──", 30)
local BtnAntiAfk, setAntiAfk = createToggleBtn("Anti AFK", "🛡️", 31)

-- ══════════════════════════════════════
--         LOGIC — TELEPORT
-- ══════════════════════════════════════
BtnSaveBase.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        savedBasePosition = root.CFrame
        setStatus("Posisi base tersimpan!", Color3.fromRGB(100, 220, 100))
        BtnSaveBase.BackgroundColor3 = Color3.fromRGB(20, 80, 22)
    else
        setStatus("Character tidak ada.", Color3.fromRGB(255, 80, 80))
    end
end)

BtnBase.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then setStatus("Character tidak ada.", Color3.fromRGB(255, 80, 80)); return end
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
    if not root then setStatus("Character tidak ada.", Color3.fromRGB(255, 80, 80)); return end
    if spawnPosition then
        root.CFrame = spawnPosition
        setStatus("Teleport ke spawn.", Color3.fromRGB(100, 200, 120))
    else
        setStatus("Posisi spawn belum ada.", Color3.fromRGB(255, 180, 50))
    end
end)

-- ══════════════════════════════════════
--         LOGIC — NOCLIP
-- ══════════════════════════════════════
BtnNoclip.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    setNoclip(noclipEnabled)
    setStatus(noclipEnabled and "Noclip ON" or "Noclip OFF",
        noclipEnabled and Color3.fromRGB(100, 220, 100) or Color3.fromRGB(200, 100, 100))

    if noclipEnabled then
        noclipConn = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)

-- ══════════════════════════════════════
--         LOGIC — SPEED HACK
-- ══════════════════════════════════════
local SPEED_ON  = 120
local SPEED_OFF = 16

local function applySpeed(on)
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = on and SPEED_ON or SPEED_OFF end
    end
end

BtnSpeed.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    setSpeed(speedEnabled)
    applySpeed(speedEnabled)
    setStatus(speedEnabled and "Speed Hack ON" or "Speed Hack OFF",
        speedEnabled and Color3.fromRGB(100, 220, 100) or Color3.fromRGB(200, 100, 100))
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if speedEnabled then applySpeed(true) end
end)

-- ══════════════════════════════════════
--         LOGIC — AUTO STEAL
-- ══════════════════════════════════════

-- Ekstrak angka dari string (untuk baca value/rate di nama objek atau BillboardGui)
local function extractValue(obj)
    local score = 0

    -- Cek BillboardGui / TextLabel di dalam objek untuk angka rate/value
    for _, desc in ipairs(obj:GetDescendants()) do
        if desc:IsA("TextLabel") or desc:IsA("TextButton") then
            local txt = desc.Text or ""
            -- Cari pola angka (termasuk K, M, B, Qa, dst)
            local num = txt:match("([%d%.]+)%s*[KkMmBbQq]?a?")
            if num then
                local val = tonumber(num) or 0
                -- Konversi suffix
                if txt:find("[Kk]") then val = val * 1e3
                elseif txt:find("[Mm]") then val = val * 1e6
                elseif txt:find("[Bb]") then val = val * 1e9
                elseif txt:find("[Qq]a") or txt:find("Qa") then val = val * 1e15
                elseif txt:find("[Tt]") then val = val * 1e12
                end
                if val > score then score = val end
            end
        end
    end

    -- Fallback: cek nama objek mengandung angka
    if score == 0 then
        local num = obj.Name:match("([%d%.]+)")
        score = tonumber(num) or 0
    end

    return score
end

-- Cari brainrot dengan value/rate tertinggi di seluruh workspace
local function findHighestValueBrainrot()
    local best, bestScore = nil, -1

    for _, obj in ipairs(workspace:GetDescendants()) do
        -- Skip milik player sendiri
        if obj:IsA("Model") or obj:IsA("BasePart") then
            local name = obj.Name:lower()
            local isOwned = false
            -- Skip jika ada nama player sendiri di parent chain
            local p = obj
            for _ = 1, 5 do
                p = p.Parent
                if not p then break end
                if p.Name == LocalPlayer.Name then isOwned = true; break end
            end

            if not isOwned and (
                name:find("brainrot") or
                name:find("creature") or
                name:find("pet") or
                name:find("unit")
            ) then
                local val = extractValue(obj)
                if val > bestScore then
                    bestScore = val
                    best = obj
                end
            end
        end
    end

    return best, bestScore
end

-- Loop utama auto steal
local function runAutoSteal()
    while autoStealEnabled do
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")

        if root then
            -- Step 1: cari target tertinggi
            local target, score = findHighestValueBrainrot()

            if target then
                local targetPart = nil
                if target:IsA("BasePart") then
                    targetPart = target
                elseif target:IsA("Model") then
                    targetPart = target.PrimaryPart or target:FindFirstChildWhichIsA("BasePart")
                end

                if targetPart then
                    -- Step 2: teleport ke target
                    setStatus("Stealing — Value: " .. tostring(math.floor(score)), Color3.fromRGB(255, 200, 50))
                    root.CFrame = CFrame.new(targetPart.Position + Vector3.new(0, 3, 0))
                    task.wait(0.6) -- tunggu pickup

                    -- Step 3: teleport balik ke base
                    if savedBasePosition then
                        root.CFrame = savedBasePosition
                        setStatus("Kembali ke base!", Color3.fromRGB(100, 220, 100))
                        task.wait(0.8)
                    else
                        setStatus("Base belum di-save!", Color3.fromRGB(255, 180, 50))
                        task.wait(1)
                    end
                else
                    task.wait(0.5)
                end
            else
                setStatus("Tidak ada brainrot terdeteksi.", Color3.fromRGB(180, 180, 100))
                task.wait(2)
            end
        else
            task.wait(1)
        end
    end
end

BtnAutoSteal.MouseButton1Click:Connect(function()
    autoStealEnabled = not autoStealEnabled
    setAutoSteal(autoStealEnabled)

    if autoStealEnabled then
        if not savedBasePosition then
            setStatus("Save base dulu sebelum Auto Steal!", Color3.fromRGB(255, 80, 80))
            autoStealEnabled = false
            setAutoSteal(false)
            return
        end
        setStatus("Auto Steal ON — Scanning...", Color3.fromRGB(100, 220, 100))
        task.spawn(runAutoSteal)
    else
        setStatus("Auto Steal OFF", Color3.fromRGB(200, 100, 100))
    end
end)

-- ══════════════════════════════════════
--         LOGIC — ANTI AFK
-- ══════════════════════════════════════
BtnAntiAfk.MouseButton1Click:Connect(function()
    antiAfkEnabled = not antiAfkEnabled
    setAntiAfk(antiAfkEnabled)
    setStatus(antiAfkEnabled and "Anti AFK ON" or "Anti AFK OFF",
        antiAfkEnabled and Color3.fromRGB(100, 220, 100) or Color3.fromRGB(200, 100, 100))

    if antiAfkEnabled then
        antiAfkConn = task.spawn(function()
            while antiAfkEnabled do
                task.wait(60)
                if not antiAfkEnabled then break end
                local vs = game:GetService("VirtualUser")
                vs:Button2Down(Vector2.new(0,0), CFrame.new())
                task.wait(0.1)
                vs:Button2Up(Vector2.new(0,0), CFrame.new())
            end
        end)
    else
        antiAfkEnabled = false
    end
end)

-- ══════════════════════════════════════
--         TOGGLE MENU
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
local dragging, dragStart, startPos = false, nil, nil

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
        local d = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y
        )
    end
end)

-- ══════════════════════════════════════
--         DRAGGABLE — TOGGLE BTN
-- ══════════════════════════════════════
local tDrag, tDragStart, tStartPos = false, nil, nil

ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or
       input.UserInputType == Enum.UserInputType.MouseButton1 then
        tDrag = true
        tDragStart = input.Position
        tStartPos = ToggleBtn.Position
    end
end)
ToggleBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or
       input.UserInputType == Enum.UserInputType.MouseButton1 then
        tDrag = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if tDrag and (
        input.UserInputType == Enum.UserInputType.MouseMovement or
        input.UserInputType == Enum.UserInputType.Touch
    ) then
        local d = input.Position - tDragStart
        ToggleBtn.Position = UDim2.new(
            tStartPos.X.Scale, tStartPos.X.Offset + d.X,
            tStartPos.Y.Scale, tStartPos.Y.Offset + d.Y
        )
    end
end)

print("[ Ar Zero ] UI Loaded.")
