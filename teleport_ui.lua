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
local antiHitEnabled    = false
local fpsBoosted        = false
local antiRagdoll       = false
local autoStealEnabled  = false
local noclipConn        = nil
local autoStealConn     = nil
local antiAfkConn       = nil
local antiHitConn       = nil

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
local BtnAntiAfk,    setAntiAfk    = createToggleBtn("Anti AFK",       "🛡️", 31)
local BtnAntiHit,    setAntiHit    = createToggleBtn("Anti Hit",       "🔰", 32)
local BtnFPS,        setFPS        = createToggleBtn("FPS Booster",    "🚀", 33)
local BtnAntiRag,    setAntiRag    = createToggleBtn("Anti Ragdoll",   "🦾", 34)

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
local SPEED_ON   = 120
local normalSpeed = 16 -- akan diupdate saat karakter load
local speedConn   = nil

-- Rekam speed normal game sebelum diubah
local function recordNormalSpeed()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid", 5)
    if hum and not speedEnabled then
        normalSpeed = hum.WalkSpeed
    end
end
task.spawn(recordNormalSpeed)

BtnSpeed.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    setSpeed(speedEnabled)
    setStatus(speedEnabled and "Speed Hack ON" or "Speed Hack OFF",
        speedEnabled and Color3.fromRGB(100, 220, 100) or Color3.fromRGB(200, 100, 100))

    if speedEnabled then
        -- Loop paksa WalkSpeed setiap Heartbeat agar tidak reset saat lompat/hit
        speedConn = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.WalkSpeed ~= SPEED_ON then
                hum.WalkSpeed = SPEED_ON
            end
        end)
    else
        -- Matikan loop
        if speedConn then speedConn:Disconnect(); speedConn = nil end
        -- Restore ke speed normal yang direkam
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = normalSpeed end
        end
    end
end)

-- Saat respawn: rekam ulang speed normal, reapply jika speed masih on
LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        task.wait(0.5)
        if not speedEnabled then
            normalSpeed = hum.WalkSpeed -- rekam speed asli game
        else
            hum.WalkSpeed = SPEED_ON
        end
    end
end)

-- ══════════════════════════════════════
--         LOGIC — AUTO STEAL
-- ══════════════════════════════════════

-- Parse rate per detik dari teks label (contoh: "$6B/s", "$1.8B/s", "$375M/s")
local function parseRate(txt)
    if not txt or txt == "" then return 0 end
    -- Pattern: $angka + suffix + /s
    local num, suf = txt:match("%$([%d%.]+)([KkMmBbTtQq]?)a?%s*/[sS]")
    if not num then return 0 end
    local v = tonumber(num) or 0
    suf = suf and suf:upper() or ""
    if suf == "K" then return v * 1e3
    elseif suf == "M" then return v * 1e6
    elseif suf == "B" then return v * 1e9
    elseif suf == "T" then return v * 1e12
    elseif suf == "Q" then return v * 1e15
    end
    return v
end

-- Format angka besar jadi teks singkat
local function fmtVal(v)
    if v >= 1e15 then return string.format("%.2fQa", v/1e15)
    elseif v >= 1e12 then return string.format("%.2fT", v/1e12)
    elseif v >= 1e9  then return string.format("%.2fB", v/1e9)
    elseif v >= 1e6  then return string.format("%.2fM", v/1e6)
    elseif v >= 1e3  then return string.format("%.2fK", v/1e3)
    else return tostring(math.floor(v)) end
end

-- Scan seluruh workspace cari brainrot dengan rate /s tertinggi
-- Strategi: cari TextLabel yang mengandung "/s", baca ratenya,
-- lalu ambil BasePart terdekat sebagai target teleport
local function findHighestRateBrainrot()
    local bestPart = nil
    local bestRate = -1
    local bestLabel = ""

    for _, obj in ipairs(workspace:GetDescendants()) do
        -- Hanya scan TextLabel dan TextButton
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            local txt = obj.Text or ""

            -- Harus mengandung "/s" pattern rate
            if txt:find("/[sS]") and txt:find("%$") then
                local rate = parseRate(txt)
                if rate > 0 and rate > bestRate then

                    -- Pastikan bukan milik player sendiri
                    local isOwn = false
                    local p = obj
                    for _ = 1, 10 do
                        p = p.Parent
                        if not p then break end
                        if p.Name == LocalPlayer.Name then
                            isOwn = true; break
                        end
                    end
                    if isOwn then continue end

                    -- Cari BasePart terdekat dari label ini
                    -- Cek: parent BillboardGui → Adornee atau parent Model → PrimaryPart
                    local targetPart = nil
                    local gui = obj
                    for _ = 1, 5 do
                        gui = gui.Parent
                        if not gui then break end
                        if gui:IsA("BillboardGui") then
                            if gui.Adornee and gui.Adornee:IsA("BasePart") then
                                targetPart = gui.Adornee
                            elseif gui.Parent and gui.Parent:IsA("BasePart") then
                                targetPart = gui.Parent
                            elseif gui.Parent and gui.Parent:IsA("Model") then
                                targetPart = gui.Parent.PrimaryPart
                                    or gui.Parent:FindFirstChildWhichIsA("BasePart")
                            end
                            break
                        elseif gui:IsA("BasePart") then
                            targetPart = gui
                            break
                        elseif gui:IsA("Model") then
                            targetPart = gui.PrimaryPart
                                or gui:FindFirstChildWhichIsA("BasePart")
                            break
                        end
                    end

                    if targetPart then
                        bestRate  = rate
                        bestPart  = targetPart
                        bestLabel = txt:gsub("%s+", " ")
                    end
                end
            end
        end
    end

    return bestPart, bestRate, bestLabel
end

-- Loop utama Auto Steal
-- Trigger ProximityPrompt "Mencuri" di sekitar part target
local function triggerSteal(part)
    local ProximityPromptService = game:GetService("ProximityPromptService")

    local function tryFire(prompt)
        -- Method 1: TriggerPrompt via service
        pcall(function()
            ProximityPromptService:TriggerPrompt(prompt)
        end)
        -- Method 2: Fire signal langsung
        pcall(function()
            prompt.Triggered:Fire(LocalPlayer)
        end)
        -- Method 3: PromptButtonHoldBegan → PromptButtonHoldEnded
        pcall(function()
            prompt.PromptButtonHoldBegan:Fire(LocalPlayer)
            task.wait(0.05)
            prompt.PromptButtonHoldEnded:Fire(LocalPlayer)
        end)
    end

    -- Scan dari part → parent model → seluruh descendants
    local targets = { part }
    if part.Parent then table.insert(targets, part.Parent) end

    for _, obj in ipairs(targets) do
        if obj and obj:IsDescendantOf(workspace) then
            for _, desc in ipairs(obj:GetDescendants()) do
                if desc:IsA("ProximityPrompt") then
                    local action = (desc.ActionText or ""):lower()
                    local objText = (desc.ObjectText or ""):lower()
                    -- Prioritas: "mencuri" / "steal" / "collect" / "kumpulkan"
                    if action:find("mencuri") or action:find("steal") or
                       action:find("collect") or action:find("kumpulkan") or
                       objText:find("mencuri") or objText:find("steal") then
                        tryFire(desc)
                    end
                end
            end
        end
    end

    -- Fallback: scan radius 20 studs dari posisi player
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                local action = (obj.ActionText or ""):lower()
                local ok, partPos = pcall(function()
                    return obj.Parent and obj.Parent:IsA("BasePart") and obj.Parent.Position
                end)
                if ok and partPos then
                    local dist = (partPos - root.Position).Magnitude
                    if dist <= 15 and (action:find("mencuri") or action:find("steal") or action:find("collect")) then
                        tryFire(obj)
                    end
                end
            end
        end
    end
end

local function runAutoSteal()
    while autoStealEnabled do
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")

        if root then
            -- Step 1: cari brainrot rate tertinggi
            local part, rate, label = findHighestRateBrainrot()

            if part and rate > 0 then
                -- Step 2: teleport tepat ke posisi brainrot
                setStatus("Curi " .. fmtVal(rate) .. "/s — Menuju...", Color3.fromRGB(255, 210, 60))
                root.CFrame = CFrame.new(part.Position + Vector3.new(0, 2, 0))
                task.wait(0.4) -- tunggu ProximityPrompt muncul

                -- Step 3: fire ProximityPrompt "Mencuri"
                triggerSteal(part)
                task.wait(0.2)
                triggerSteal(part) -- fire ulang untuk pastikan
                task.wait(0.4)

                -- Step 5: balik ke base
                if savedBasePosition then
                    root.CFrame = savedBasePosition
                    setStatus("✓ Stolen " .. fmtVal(rate) .. "/s!", Color3.fromRGB(80, 220, 100))
                    task.wait(0.8)
                else
                    setStatus("Base belum di-save!", Color3.fromRGB(255, 180, 50))
                    task.wait(1)
                end
            else
                setStatus("Scanning brainrot...", Color3.fromRGB(160, 160, 80))
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
--         LOGIC — ANTI HIT
-- ══════════════════════════════════════
local function applyAntiHit(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    -- Pasang ForceField agar tidak bisa di-damage
    local ff = char:FindFirstChildOfClass("ForceField")
    if not ff then
        ff = Instance.new("ForceField")
        ff.Visible = false
        ff.Parent = char
    end

    -- Jaga health tetap penuh setiap frame
    hum.MaxHealth = math.huge
    hum.Health = math.huge
end

local function removeAntiHit(char)
    if not char then return end
    local ff = char:FindFirstChildOfClass("ForceField")
    if ff then ff:Destroy() end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.MaxHealth = 100
        hum.Health = 100
    end
end

BtnAntiHit.MouseButton1Click:Connect(function()
    antiHitEnabled = not antiHitEnabled
    setAntiHit(antiHitEnabled)
    setStatus(antiHitEnabled and "Anti Hit ON" or "Anti Hit OFF",
        antiHitEnabled and Color3.fromRGB(100, 220, 100) or Color3.fromRGB(200, 100, 100))

    if antiHitEnabled then
        -- Apply ke karakter sekarang
        applyAntiHit(LocalPlayer.Character)

        -- Loop jaga health + reapply jika health turun
        antiHitConn = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.MaxHealth = math.huge
                if hum.Health < hum.MaxHealth then
                    hum.Health = math.huge
                end
            end
            -- Pastikan ForceField tetap ada
            if not char:FindFirstChildOfClass("ForceField") then
                local ff = Instance.new("ForceField")
                ff.Visible = false
                ff.Parent = char
            end
        end)

        -- Reapply setelah respawn
        LocalPlayer.CharacterAdded:Connect(function(char)
            if antiHitEnabled then
                task.wait(0.5)
                applyAntiHit(char)
            end
        end)
    else
        if antiHitConn then antiHitConn:Disconnect(); antiHitConn = nil end
        removeAntiHit(LocalPlayer.Character)
    end
end)

-- ══════════════════════════════════════
--         LOGIC — FPS BOOSTER
-- ══════════════════════════════════════
local Lighting  = game:GetService("Lighting")
local gSettings = settings()

local origValues = {
    GlobalShadows = Lighting.GlobalShadows,
    FogEnd        = Lighting.FogEnd,
    Brightness    = Lighting.Brightness,
    QualityLevel  = gSettings.Rendering.QualityLevel,
}

local function applyFPSBoost()
    Lighting.GlobalShadows = false
    Lighting.FogEnd        = 9e9
    Lighting.Brightness    = 0
    gSettings.Rendering.QualityLevel = Enum.QualityLevel.Level01

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or
           obj:IsA("Beam") or obj:IsA("Smoke") or
           obj:IsA("Fire") or obj:IsA("Sparkles") then
            obj.Enabled = false
        end
        if obj:IsA("Texture") or obj:IsA("Decal") then
            obj.Transparency = 1
        end
    end
end

local function removeFPSBoost()
    Lighting.GlobalShadows = origValues.GlobalShadows
    Lighting.FogEnd        = origValues.FogEnd
    Lighting.Brightness    = origValues.Brightness
    gSettings.Rendering.QualityLevel = origValues.QualityLevel

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or
           obj:IsA("Beam") or obj:IsA("Smoke") or
           obj:IsA("Fire") or obj:IsA("Sparkles") then
            obj.Enabled = true
        end
        if obj:IsA("Texture") or obj:IsA("Decal") then
            obj.Transparency = 0
        end
    end
end

BtnFPS.MouseButton1Click:Connect(function()
    fpsBoosted = not fpsBoosted
    setFPS(fpsBoosted)
    if fpsBoosted then
        applyFPSBoost()
        setStatus("FPS Booster ON!", Color3.fromRGB(100, 220, 100))
    else
        removeFPSBoost()
        setStatus("FPS Booster OFF.", Color3.fromRGB(200, 100, 100))
    end
end)

-- ══════════════════════════════════════
--         LOGIC — ANTI RAGDOLL
-- ══════════════════════════════════════
local antiRagConn = nil

local function applyAntiRagdoll(char)
    if not char then return end
    -- Hapus semua BallSocketConstraint & Bone yang menyebabkan ragdoll
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("BallSocketConstraint") or
           obj:IsA("HingeConstraint") or
           obj:IsA("UniversalConstraint") or
           obj:IsA("RopeConstraint") or
           obj:IsA("NoCollisionConstraint") then
            obj.Enabled = false
        end
    end

    -- Pastikan semua part karakter tidak CanCollide off satu sama lain
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end

BtnAntiRag.MouseButton1Click:Connect(function()
    antiRagdoll = not antiRagdoll
    setAntiRag(antiRagdoll)
    setStatus(antiRagdoll and "Anti Ragdoll ON" or "Anti Ragdoll OFF",
        antiRagdoll and Color3.fromRGB(100, 220, 100) or Color3.fromRGB(200, 100, 100))

    if antiRagdoll then
        -- Apply sekarang
        applyAntiRagdoll(LocalPlayer.Character)

        -- Loop cegah state ragdoll
        antiRagConn = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                local state = hum:GetState()
                if state == Enum.HumanoidStateType.Ragdoll or
                   state == Enum.HumanoidStateType.FallingDown then
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                end
            end
        end)

        -- Reapply setelah respawn
        LocalPlayer.CharacterAdded:Connect(function(char)
            if antiRagdoll then
                task.wait(0.3)
                applyAntiRagdoll(char)
            end
        end)
    else
        if antiRagConn then antiRagConn:Disconnect(); antiRagConn = nil end
        -- Restore constraints
        local char = LocalPlayer.Character
        if char then
            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("BallSocketConstraint") or
                   obj:IsA("HingeConstraint") or
                   obj:IsA("UniversalConstraint") then
                    obj.Enabled = true
                end
            end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            end
        end
    end
end)

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
