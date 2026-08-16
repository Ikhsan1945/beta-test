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
local espEnabled        = false
local autoRejoin        = false
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
pcall(function() ScreenGui.IgnoreGuiInset = true end)
ScreenGui.Parent = PlayerGui

-- ══════════════════════════════════════
--         MAIN FRAME
-- ══════════════════════════════════════
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 275, 0, 420)
-- Posisi awal: tengah kiri, hindari tombol Roblox di atas
MainFrame.Position = UDim2.new(0, 10, 0.35, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 19)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
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

-- Icon + Judul
local HeaderLabel = Instance.new("TextLabel")
HeaderLabel.Size = UDim2.new(1, -90, 1, 0)
HeaderLabel.Position = UDim2.new(0, 14, 0, 0)
HeaderLabel.BackgroundTransparency = 1
HeaderLabel.Text = "⚡ Ar Zero — Menu"
HeaderLabel.TextColor3 = Color3.fromRGB(170, 215, 255)
HeaderLabel.Font = Enum.Font.GothamBold
HeaderLabel.TextSize = 14
HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
HeaderLabel.ZIndex = 7
HeaderLabel.Parent = Header

-- Tombol Minimize (- untuk tutup, + untuk buka)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
MinimizeBtn.Position = UDim2.new(1, -68, 0.5, -14)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 80, 160)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 18
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.ZIndex = 8
MinimizeBtn.Parent = Header
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 6)

-- Tombol Close (X - dengan konfirmasi)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -36, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(175, 32, 32)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 8
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- ══════════════════════════════════════
--         CONFIRM DIALOG (untuk Close)
-- ══════════════════════════════════════
local ConfirmFrame = Instance.new("Frame")
ConfirmFrame.Size = UDim2.new(0, 260, 0, 120)
ConfirmFrame.Position = UDim2.new(0, 8, 0, 52)
ConfirmFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 28)
ConfirmFrame.BorderSizePixel = 0
ConfirmFrame.ZIndex = 20
ConfirmFrame.Visible = false
ConfirmFrame.Parent = MainFrame
Instance.new("UICorner", ConfirmFrame).CornerRadius = UDim.new(0, 12)
local cfStroke = Instance.new("UIStroke", ConfirmFrame)
cfStroke.Color = Color3.fromRGB(180, 35, 35)
cfStroke.Thickness = 1.5

local ConfirmLabel = Instance.new("TextLabel")
ConfirmLabel.Size = UDim2.new(1, 0, 0, 50)
ConfirmLabel.Position = UDim2.new(0, 0, 0, 10)
ConfirmLabel.BackgroundTransparency = 1
ConfirmLabel.Text = "Yakin ingin close cheat?"
ConfirmLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
ConfirmLabel.Font = Enum.Font.GothamBold
ConfirmLabel.TextSize = 14
ConfirmLabel.ZIndex = 21
ConfirmLabel.Parent = ConfirmFrame

local SubLabel = Instance.new("TextLabel")
SubLabel.Size = UDim2.new(1, 0, 0, 20)
SubLabel.Position = UDim2.new(0, 0, 0, 42)
SubLabel.BackgroundTransparency = 1
SubLabel.Text = "Cheat akan dinonaktifkan sepenuhnya."
SubLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
SubLabel.Font = Enum.Font.Gotham
SubLabel.TextSize = 11
SubLabel.ZIndex = 21
SubLabel.Parent = ConfirmFrame

-- Tombol YA
local YaBtn = Instance.new("TextButton")
YaBtn.Size = UDim2.new(0, 100, 0, 34)
YaBtn.Position = UDim2.new(0, 12, 1, -46)
YaBtn.BackgroundColor3 = Color3.fromRGB(175, 32, 32)
YaBtn.Text = "✓  Ya, Close"
YaBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
YaBtn.Font = Enum.Font.GothamBold
YaBtn.TextSize = 12
YaBtn.BorderSizePixel = 0
YaBtn.ZIndex = 21
YaBtn.Parent = ConfirmFrame
Instance.new("UICorner", YaBtn).CornerRadius = UDim.new(0, 8)

-- Tombol TIDAK
local TidakBtn = Instance.new("TextButton")
TidakBtn.Size = UDim2.new(0, 100, 0, 34)
TidakBtn.Position = UDim2.new(1, -112, 1, -46)
TidakBtn.BackgroundColor3 = Color3.fromRGB(30, 60, 140)
TidakBtn.Text = "✗  Tidak"
TidakBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TidakBtn.Font = Enum.Font.GothamBold
TidakBtn.TextSize = 12
TidakBtn.BorderSizePixel = 0
TidakBtn.ZIndex = 21
TidakBtn.Parent = ConfirmFrame
Instance.new("UICorner", TidakBtn).CornerRadius = UDim.new(0, 8)

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
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 120, 230)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
pcall(function()
    ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
end)
ScrollFrame.ClipsDescendants = true
ScrollFrame.ZIndex = 6
ScrollFrame.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Padding = UDim.new(0, 6)
Layout.Parent = ScrollFrame

-- Update canvas size setiap konten berubah
local function updateCanvas()
    task.wait()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 80)
end
Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

local Pad = Instance.new("UIPadding")
Pad.PaddingLeft   = UDim.new(0, 12)
Pad.PaddingRight  = UDim.new(0, 14)
Pad.PaddingTop    = UDim.new(0, 10)
Pad.PaddingBottom = UDim.new(0, 60)
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

-- [ VISUAL ]
makeSection(ScrollFrame, "── VISUAL ──", 25)
local BtnESP, setESP = createToggleBtn("ESP Brainrot", "👁️", 26)

-- [ UTILITY ]
makeSection(ScrollFrame, "── UTILITY ──", 30)
local BtnAntiAfk,    setAntiAfk    = createToggleBtn("Anti AFK",       "🛡️", 31)
local BtnAntiHit,    setAntiHit    = createToggleBtn("Anti Hit",       "🔰", 32)
local BtnFPS,        setFPS        = createToggleBtn("FPS Booster",    "🚀", 33)
local BtnAntiRag,    setAntiRag    = createToggleBtn("Anti Ragdoll",   "🦾", 34)
local BtnAutoRejoin, setAutoRejoin = createToggleBtn("Auto Rejoin",    "🔄", 35)
local BtnServerHop               = createBtn("Server Hop (Player Terbanyak)", "🌐", 36)

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
-- Blacklist: part yang sudah dicuri diblacklist sementara
local stealBlacklist = {} -- { [part] = expireTime }

local function isBlacklisted(part)
    if stealBlacklist[part] then
        if tick() < stealBlacklist[part] then
            return true -- masih dalam blacklist
        else
            stealBlacklist[part] = nil -- expired, hapus
        end
    end
    return false
end

local function addBlacklist(part, duration)
    stealBlacklist[part] = tick() + (duration or 30)
end

-- Scan brainrot dengan rate /s tertinggi
-- Skip: milik sendiri, dekat base sendiri, sudah di-blacklist
local function findHighestRateBrainrot()
    local bestPart  = nil
    local bestRate  = -1
    local bestLabel = ""

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            local txt = obj.Text or ""

            if txt:find("/[sS]") and txt:find("%$") then
                local rate = parseRate(txt)
                if rate > 0 and rate > bestRate then

                    -- [ 1 ] Skip milik player sendiri
                    local isOwn = false
                    local p = obj
                    for _ = 1, 10 do
                        p = p.Parent
                        if not p then break end
                        if p.Name == LocalPlayer.Name then
                            isOwn = true; break
                        end
                    end

                    if not isOwn then
                        -- [ 2 ] Cari BasePart dari label
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
                                targetPart = gui; break
                            elseif gui:IsA("Model") then
                                targetPart = gui.PrimaryPart
                                    or gui:FindFirstChildWhichIsA("BasePart")
                                break
                            end
                        end

                        if targetPart and not isBlacklisted(targetPart) then
                            -- [ 3 ] Skip jika dekat base sendiri
                            local nearOwnBase = false
                            if savedBasePosition then
                                local dist = (targetPart.Position - savedBasePosition.Position).Magnitude
                                if dist <= 35 then
                                    nearOwnBase = true
                                end
                            end

                            if not nearOwnBase then
                                bestRate  = rate
                                bestPart  = targetPart
                                bestLabel = txt:gsub("%s+", " ")
                            end
                        end
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
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local function firePrompt(prompt)
        pcall(function() fireproximityprompt(prompt) end)
        pcall(function()
            game:GetService("ProximityPromptService"):TriggerPrompt(prompt)
        end)
        pcall(function() prompt.Triggered:Fire(LocalPlayer) end)
    end

    -- Kumpulkan semua ancestor dari part target
    -- untuk pastikan hanya fire prompt di model yang benar
    local targetAncestors = {}
    local p = part
    for _ = 1, 8 do
        if not p then break end
        targetAncestors[p] = true
        p = p.Parent
    end

    -- Scan ProximityPrompt HANYA dari dalam model target
    local function scanObj(obj)
        if not obj then return end
        for _, desc in ipairs(obj:GetDescendants()) do
            if desc:IsA("ProximityPrompt") then
                local action = (desc.ActionText or ""):lower()
                if action:find("mencuri") or action:find("steal") or
                   action:find("ambil") or action:find("collect") then
                    firePrompt(desc)
                end
            end
        end
        -- Juga cek di obj sendiri
        if obj:IsA("ProximityPrompt") then
            local action = (obj.ActionText or ""):lower()
            if action:find("mencuri") or action:find("steal") or
               action:find("ambil") or action:find("collect") then
                firePrompt(obj)
            end
        end
    end

    -- Scan dari part → parent model langsung
    scanObj(part)
    if part.Parent then
        scanObj(part.Parent)
        -- Jika parent model, scan juga grandparent
        if part.Parent.Parent then
            scanObj(part.Parent.Parent)
        end
    end

    -- Fallback: jika tidak ada prompt ditemukan di model,
    -- scan radius SANGAT DEKAT (3 stud) dari target agar akurat
    local found = false
    for _, desc in ipairs(workspace:GetDescendants()) do
        if desc:IsA("ProximityPrompt") then
            local action = (desc.ActionText or ""):lower()
            if action:find("mencuri") or action:find("steal") then
                -- Cek apakah prompt ini milik model target
                local promptPart = desc.Parent
                if promptPart and promptPart:IsA("BasePart") then
                    local dist = (promptPart.Position - part.Position).Magnitude
                    if dist <= 5 then -- hanya dalam 5 stud dari TARGET, bukan dari player
                        firePrompt(desc)
                        found = true
                    end
                end
            end
        end
    end
end

local function runAutoSteal()
    while autoStealEnabled do
        local ok, err = pcall(function()
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")

            if not root then
                task.wait(1)
                return
            end

            -- Step 1: scan brainrot rate tertinggi
            local part, rate, label = findHighestRateBrainrot()

            if part and rate > 0 then
                -- Step 2: teleport ke brainrot
                setStatus("Curi " .. fmtVal(rate) .. "/s — Menuju...", Color3.fromRGB(255, 210, 60))
                root.CFrame = CFrame.new(part.Position + Vector3.new(0, 2, 0))
                task.wait(0.4)

                -- Step 3: fire ProximityPrompt "Mencuri"
                triggerSteal(part)
                task.wait(0.2)
                triggerSteal(part)
                task.wait(0.4)

                -- Blacklist part ini 25 detik agar tidak di-steal ulang
                addBlacklist(part, 25)

                -- Step 4: balik ke base
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
        end)

        -- Error tidak matikan loop, cukup jeda lalu lanjut
        if not ok then
            setStatus("Retry...", Color3.fromRGB(255, 150, 50))
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
        -- task.spawn agar loop jalan di thread terpisah
        -- jika loop mati karena apapun, spawn ulang selama flag masih true
        task.spawn(function()
            while autoStealEnabled do
                local ok, err = pcall(runAutoSteal)
                if not ok then
                    task.wait(1) -- jeda sebentar lalu restart
                end
            end
        end)
    else
        setStatus("Auto Steal OFF", Color3.fromRGB(200, 100, 100))
    end
end)

-- ══════════════════════════════════════
--         LOGIC — ESP BRAINROT
-- ══════════════════════════════════════
local espConn     = nil
local espFolder   = nil
local ESP_REFRESH = 3 -- detik refresh ESP

-- Hapus semua ESP billboard yang sudah ada
local function clearESP()
    if espFolder then
        pcall(function() espFolder:Destroy() end)
        espFolder = nil
    end
end

-- Buat BillboardGui ESP di atas part target
local function createESPTag(part, brainrotName, rate)
    if not part or not part.Parent then return end

    local bill = Instance.new("BillboardGui")
    bill.Name = "ArZeroESP"
    bill.Size = UDim2.new(0, 200, 0, 70)
    bill.StudsOffset = Vector3.new(0, 4, 0)
    bill.AlwaysOnTop = true
    bill.MaxDistance = 500
    bill.Adornee = part
    bill.Parent = espFolder

    -- Box highlight
    local highlight = Instance.new("SelectionBox")
    highlight.Color3 = Color3.fromRGB(255, 80, 80)
    highlight.LineThickness = 0.06
    highlight.SurfaceTransparency = 0.7
    highlight.SurfaceColor3 = Color3.fromRGB(255, 80, 80)
    highlight.Adornee = part
    highlight.Parent = espFolder

    -- Frame container
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(8, 8, 18)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = bill
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(255, 80, 80)
    stroke.Thickness = 1.2

    -- Nama brainrot
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = "🧠 " .. brainrotName
    nameLabel.TextColor3 = Color3.fromRGB(255, 220, 100)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 13
    nameLabel.TextScaled = true
    nameLabel.Parent = frame

    -- Rate label
    local rateLabel = Instance.new("TextLabel")
    rateLabel.Size = UDim2.new(1, 0, 0.5, 0)
    rateLabel.Position = UDim2.new(0, 0, 0.5, 0)
    rateLabel.BackgroundTransparency = 1
    rateLabel.Text = "💰 " .. fmtVal(rate) .. "/s  ★ TERTINGGI"
    rateLabel.TextColor3 = Color3.fromRGB(100, 255, 140)
    rateLabel.Font = Enum.Font.GothamSemibold
    rateLabel.TextSize = 11
    rateLabel.TextScaled = true
    rateLabel.Parent = frame
end

-- Scan semua base lain, ambil brainrot tertinggi per base, pasang ESP
local function refreshESP()
    clearESP()
    if not espEnabled then return end

    espFolder = Instance.new("Folder")
    espFolder.Name = "ArZeroESPFolder"
    espFolder.Parent = workspace

    -- Kumpulkan semua TextLabel dengan rate /s
    -- Group berdasarkan area (base) — pakai threshold jarak 60 stud
    local allTargets = {}

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            local txt = obj.Text or ""
            if txt:find("/[sS]") and txt:find("%$") then
                local rate = parseRate(txt)
                if rate > 0 then
                    -- Skip milik sendiri
                    local isOwn = false
                    local p = obj
                    for _ = 1, 10 do
                        p = p.Parent
                        if not p then break end
                        if p.Name == LocalPlayer.Name then isOwn = true; break end
                    end

                    if not isOwn then
                        -- Skip area base sendiri
                        local tooClose = false
                        if savedBasePosition then
                            local gui2 = obj
                            local tempPart = nil
                            for _ = 1, 5 do
                                gui2 = gui2.Parent
                                if not gui2 then break end
                                if gui2:IsA("BasePart") then tempPart = gui2; break
                                elseif gui2:IsA("Model") then
                                    tempPart = gui2.PrimaryPart or gui2:FindFirstChildWhichIsA("BasePart")
                                    break
                                end
                            end
                            if tempPart then
                                local dist = (tempPart.Position - savedBasePosition.Position).Magnitude
                                if dist <= 40 then tooClose = true end
                            end
                        end

                        if not tooClose then

                    -- Cari nama brainrot dari ObjectText BillboardGui atau nama Model parent
                    local brainrotName = "Brainrot"
                    local targetPart = nil
                    local gui = obj
                    for _ = 1, 6 do
                        gui = gui.Parent
                        if not gui then break end
                        if gui:IsA("BillboardGui") then
                            brainrotName = gui.Name ~= "BillboardGui" and gui.Name or brainrotName
                            if gui.Adornee and gui.Adornee:IsA("BasePart") then
                                targetPart = gui.Adornee
                            elseif gui.Parent and gui.Parent:IsA("BasePart") then
                                targetPart = gui.Parent
                            elseif gui.Parent and gui.Parent:IsA("Model") then
                                brainrotName = gui.Parent.Name ~= "" and gui.Parent.Name or brainrotName
                                targetPart = gui.Parent.PrimaryPart or gui.Parent:FindFirstChildWhichIsA("BasePart")
                            end
                            break
                        elseif gui:IsA("Model") then
                            brainrotName = gui.Name ~= "" and gui.Name or brainrotName
                            targetPart = gui.PrimaryPart or gui:FindFirstChildWhichIsA("BasePart")
                            break
                        elseif gui:IsA("BasePart") then
                            targetPart = gui
                            break
                        end
                    end

                    if targetPart then
                        table.insert(allTargets, {
                            part = targetPart,
                            rate = rate,
                            name = brainrotName,
                            pos  = targetPart.Position
                        })
                    end
                        end -- if not tooClose
                    end -- if not isOwn
                end
            end
        end
    end

    -- Group per base (radius 60 stud), ambil tertinggi per group
    local grouped = {}
    for _, t in ipairs(allTargets) do
        local found = false
        for _, g in ipairs(grouped) do
            if (t.pos - g.pos).Magnitude <= 60 then
                -- Bandingkan, simpan yang tertinggi
                if t.rate > g.rate then
                    g.part = t.part
                    g.rate = t.rate
                    g.name = t.name
                    g.pos  = t.pos
                end
                found = true
                break
            end
        end
        if not found then
            table.insert(grouped, { part = t.part, rate = t.rate, name = t.name, pos = t.pos })
        end
    end

    -- Pasang ESP hanya untuk tertinggi per base
    for _, g in ipairs(grouped) do
        pcall(function()
            createESPTag(g.part, g.name, g.rate)
        end)
    end

    setStatus("ESP: " .. #grouped .. " base terdeteksi", Color3.fromRGB(100, 200, 255))
end

BtnESP.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    setESP(espEnabled)

    if espEnabled then
        -- Refresh ESP sekarang dan loop tiap 3 detik
        refreshESP()
        espConn = task.spawn(function()
            while espEnabled do
                task.wait(ESP_REFRESH)
                if espEnabled then
                    pcall(refreshESP)
                end
            end
        end)
        setStatus("ESP ON — Scanning base...", Color3.fromRGB(100, 220, 100))
    else
        if espConn then
            pcall(function() task.cancel(espConn) end)
            espConn = nil
        end
        clearESP()
        setStatus("ESP OFF", Color3.fromRGB(200, 100, 100))
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
                pcall(function()
                    local vs = game:GetService("VirtualUser")
                    vs:Button2Down(Vector2.new(0,0), CFrame.new())
                    task.wait(0.1)
                    vs:Button2Up(Vector2.new(0,0), CFrame.new())
                end)
            end
        end)
    else
        antiAfkEnabled = false
    end
end)

-- ══════════════════════════════════════
--         LOGIC — ANTI HIT (UPGRADED)
-- ══════════════════════════════════════
local function applyAntiHit(char)
    if not char then return end
    local hum  = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    -- [ 1 ] ForceField — blok damage
    if not char:FindFirstChildOfClass("ForceField") then
        local ff = Instance.new("ForceField")
        ff.Visible = false
        ff.Parent = char
    end

    -- [ 2 ] Health tak terbatas
    hum.MaxHealth = math.huge
    hum.Health    = math.huge

    -- [ 3 ] Disable PlatformStand (mencegah stun/ragdoll dari hit)
    hum.PlatformStand = false

    -- [ 4 ] Hapus semua BodyVelocity/BodyForce/BodyGyro di root
    -- yang dipasang dari luar untuk fling/knockback
    for _, obj in ipairs(root:GetChildren()) do
        if obj:IsA("BodyVelocity") or
           obj:IsA("BodyForce") or
           obj:IsA("BodyPosition") or
           obj:IsA("BodyAngularVelocity") or
           obj:IsA("LinearVelocity") or
           obj:IsA("AngularVelocity") or
           obj:IsA("VectorForce") then
            obj:Destroy()
        end
    end
end

local function removeAntiHit(char)
    if not char then return end
    local ff = char:FindFirstChildOfClass("ForceField")
    if ff then ff:Destroy() end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.MaxHealth     = 100
        hum.Health        = 100
        hum.PlatformStand = false
    end
end

BtnAntiHit.MouseButton1Click:Connect(function()
    antiHitEnabled = not antiHitEnabled
    setAntiHit(antiHitEnabled)
    setStatus(antiHitEnabled and "Anti Hit ON" or "Anti Hit OFF",
        antiHitEnabled and Color3.fromRGB(100, 220, 100) or Color3.fromRGB(200, 100, 100))

    if antiHitEnabled then
        applyAntiHit(LocalPlayer.Character)

        antiHitConn = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hum  = char:FindFirstChildOfClass("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")

            if hum then
                -- Jaga health
                hum.MaxHealth     = math.huge
                hum.Health        = math.huge
                -- Cegah stun
                hum.PlatformStand = false
                -- Cegah ragdoll state
                if hum:GetState() == Enum.HumanoidStateType.Ragdoll or
                   hum:GetState() == Enum.HumanoidStateType.FallingDown then
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                end
            end

            -- Jaga ForceField
            if char and not char:FindFirstChildOfClass("ForceField") then
                local ff = Instance.new("ForceField")
                ff.Visible = false
                ff.Parent  = char
            end

            -- Hapus semua force/velocity yang dipasang dari luar (anti knockback/fling)
            if root then
                for _, obj in ipairs(root:GetChildren()) do
                    if obj:IsA("BodyVelocity") or
                       obj:IsA("BodyForce") or
                       obj:IsA("BodyPosition") or
                       obj:IsA("BodyAngularVelocity") or
                       obj:IsA("LinearVelocity") or
                       obj:IsA("AngularVelocity") or
                       obj:IsA("VectorForce") then
                        obj:Destroy()
                    end
                end

                -- Lock velocity jika tiba-tiba melonjak (kena fling)
                pcall(function()
                    local vel = root.AssemblyLinearVelocity
                    if vel.Magnitude > 80 then
                        root.AssemblyLinearVelocity  = Vector3.new(0, 0, 0)
                        root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    end
                end)
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
local gSettings = nil
pcall(function() gSettings = settings() end)

local origValues = {
    GlobalShadows = Lighting.GlobalShadows,
    FogEnd        = Lighting.FogEnd,
    Brightness    = Lighting.Brightness,
    QualityLevel  = gSettings and gSettings.Rendering and gSettings.Rendering.QualityLevel or nil,
}

local function applyFPSBoost()
    Lighting.GlobalShadows = false
    Lighting.FogEnd        = 9e9
    Lighting.Brightness    = 0
    pcall(function()
        if gSettings then
            gSettings.Rendering.QualityLevel = Enum.QualityLevel.Level01
        end
    end)

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
    pcall(function()
        if gSettings and origValues.QualityLevel then
            gSettings.Rendering.QualityLevel = origValues.QualityLevel
        end
    end)

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

-- ══════════════════════════════════════
--         LOGIC — AUTO REJOIN
-- ══════════════════════════════════════
local TeleportService = game:GetService("TeleportService")
local rejoinConn      = nil

local function doRejoin()
    task.wait(3) -- tunggu 3 detik sebelum rejoin
    pcall(function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)
end

BtnAutoRejoin.MouseButton1Click:Connect(function()
    autoRejoin = not autoRejoin
    setAutoRejoin(autoRejoin)
    setStatus(autoRejoin and "Auto Rejoin ON" or "Auto Rejoin OFF",
        autoRejoin and Color3.fromRGB(100, 220, 100) or Color3.fromRGB(200, 100, 100))

    if autoRejoin then
        -- [ 1 ] Monitor jika player kena kick / disconnect dari server
        rejoinConn = game:GetService("Players").PlayerRemoving:Connect(function(player)
            if player == LocalPlayer and autoRejoin then
                doRejoin()
            end
        end)

        -- [ 2 ] Monitor network status via heartbeat
        -- Jika server tidak merespons / player tidak bisa bergerak
        local lastPing = tick()
        task.spawn(function()
            while autoRejoin do
                task.wait(5)
                if not autoRejoin then break end

                -- Cek apakah character masih exist
                local char = LocalPlayer.Character
                if not char then
                    -- Character hilang terlalu lama = kemungkinan kena kick
                    task.wait(5)
                    if not LocalPlayer.Character and autoRejoin then
                        setStatus("Terdeteksi kick — Rejoining...", Color3.fromRGB(255, 180, 50))
                        doRejoin()
                    end
                end

                -- Cek network ownership / ping via RunService
                local ok = pcall(function()
                    local _ = workspace:FindFirstChild("Baseplate")
                end)
                if not ok and autoRejoin then
                    setStatus("Koneksi terputus — Rejoining...", Color3.fromRGB(255, 80, 80))
                    doRejoin()
                end
            end
        end)

        -- [ 3 ] Monitor TeleportService untuk kick event
        pcall(function()
            game:GetService("TeleportService").TeleportInitFailed:Connect(function()
                if autoRejoin then
                    task.wait(2)
                    doRejoin()
                end
            end)
        end)

        setStatus("Auto Rejoin ON — Monitoring...", Color3.fromRGB(100, 220, 100))
    else
        if rejoinConn then rejoinConn:Disconnect(); rejoinConn = nil end
        setStatus("Auto Rejoin OFF", Color3.fromRGB(200, 100, 100))
    end
end)

-- ══════════════════════════════════════
--         LOGIC — SERVER HOP
-- ══════════════════════════════════════
BtnServerHop.MouseButton1Click:Connect(function()
    setStatus("Scanning server...", Color3.fromRGB(255, 210, 60))
    BtnServerHop.BackgroundColor3 = Color3.fromRGB(30, 50, 100)

    task.spawn(function()
        local HttpService     = game:GetService("HttpService")
        local TeleportService = game:GetService("TeleportService")
        local placeId         = game.PlaceId

        -- Ambil daftar server via Roblox API
        local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Desc&limit=100"

        local ok, result = pcall(function()
            return game:HttpGet(url)
        end)

        if not ok or not result then
            setStatus("Gagal fetch server list.", Color3.fromRGB(255, 80, 80))
            BtnServerHop.BackgroundColor3 = Color3.fromRGB(20, 26, 55)
            return
        end

        local data = nil
        pcall(function()
            data = HttpService:JSONDecode(result)
        end)

        if not data or not data.data then
            setStatus("Data server tidak valid.", Color3.fromRGB(255, 80, 80))
            BtnServerHop.BackgroundColor3 = Color3.fromRGB(20, 26, 55)
            return
        end

        -- Cari server dengan player terbanyak
        local bestServer    = nil
        local bestPlayers   = 0
        local currentJobId  = game.JobId

        for _, server in ipairs(data.data) do
            if server.id ~= currentJobId then
                if server.playing and server.playing > bestPlayers then
                    bestPlayers  = server.playing
                    bestServer   = server
                end
            end
        end

        if not bestServer then
            setStatus("Tidak ada server lain ditemukan.", Color3.fromRGB(255, 180, 50))
            BtnServerHop.BackgroundColor3 = Color3.fromRGB(20, 26, 55)
            return
        end

        setStatus("Hop ke server " .. bestPlayers .. " player...", Color3.fromRGB(100, 220, 100))
        task.wait(1.5)

        -- Teleport ke server dengan player terbanyak
        pcall(function()
            TeleportService:TeleportToPlaceInstance(placeId, bestServer.id, LocalPlayer)
        end)

        -- Fallback jika TeleportToPlaceInstance gagal
        task.wait(3)
        pcall(function()
            TeleportService:Teleport(placeId, LocalPlayer)
        end)

        BtnServerHop.BackgroundColor3 = Color3.fromRGB(20, 26, 55)
    end)
end)

local isOpen = true
local isMinimized = false

local function setMinimize(mini)
    isMinimized = mini
    ScrollFrame.Visible = not mini
    if mini then
        MainFrame.Size = UDim2.new(0, 275, 0, 46)
        MinimizeBtn.Text = "+"
    else
        MainFrame.Size = UDim2.new(0, 275, 0, 420)
        MinimizeBtn.Text = "-"
        -- Update canvas saat expand
        task.spawn(function()
            task.wait(0.1)
            ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 80)
        end)
    end
end

MinimizeBtn.MouseButton1Click:Connect(function()
    ConfirmFrame.Visible = false
    setMinimize(not isMinimized)
end)

-- Tombol X — tampilkan konfirmasi dulu
CloseBtn.MouseButton1Click:Connect(function()
    if isMinimized then setMinimize(false) end
    ConfirmFrame.Visible = not ConfirmFrame.Visible
end)

-- Konfirmasi: YA → destroy semua
YaBtn.MouseButton1Click:Connect(function()
    -- Matikan semua fitur aktif
    noclipEnabled    = false
    speedEnabled     = false
    autoStealEnabled = false
    antiAfkEnabled   = false
    antiHitEnabled   = false
    fpsBoosted       = false
    antiRagdoll      = false
    espEnabled       = false

    -- Bersihkan koneksi
    if noclipConn   then noclipConn:Disconnect()   end
    if speedConn    then speedConn:Disconnect()     end
    if antiHitConn  then antiHitConn:Disconnect()  end
    if antiRagConn  then antiRagConn:Disconnect()  end
    if espConn      then pcall(function() task.cancel(espConn) end) end

    -- Bersihkan ESP
    clearESP()

    -- Restore FPS jika aktif
    if fpsBoosted then pcall(removeFPSBoost) end

    -- Destroy seluruh UI
    pcall(function() ScreenGui:Destroy() end)
end)

-- Konfirmasi: TIDAK → tutup dialog
TidakBtn.MouseButton1Click:Connect(function()
    ConfirmFrame.Visible = false
end)

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

-- Force update canvas setelah semua UI selesai dibuat
task.spawn(function()
    task.wait(0.5)
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 80)
end)

print("[ Ar Zero ] UI Loaded.")
