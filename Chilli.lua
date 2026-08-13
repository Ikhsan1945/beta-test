-- teleport_savebase.lua
-- Save Base Position + Auto Teleport Cycle | Anti Detect & Anti Kick

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- =====================
-- KONFIGURASI KEYBIND
-- =====================
local CONFIG = {
    SaveKey      = Enum.KeyCode.B,   -- Tekan B → simpan posisi base
    TeleportKey  = Enum.KeyCode.T,   -- Tekan T → teleport ke base tersimpan
    StepCount    = 8,                -- Jumlah step smooth teleport
    StepDelay    = 0.06,             -- Delay per step
    AntiKickJitter = 0.05,           -- Random jitter anti kick
}

-- =====================
-- STATE
-- =====================
local savedBase = nil
local isTeleporting = false

-- =====================
-- ANTI KICK — Reset Velocity
-- =====================
local function resetVelocity()
    pcall(function()
        RootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    end)
end

-- =====================
-- ANTI DETECT — Network Ownership
-- =====================
local function claimOwnership()
    pcall(function()
        RootPart:SetNetworkOwner(LocalPlayer)
    end)
end

-- =====================
-- SMOOTH TELEPORT
-- =====================
local function smoothTeleport(targetPos)
    local origin = RootPart.Position
    local direction = targetPos - origin

    for i = 1, CONFIG.StepCount do
        local alpha = i / CONFIG.StepCount
        RootPart.CFrame = CFrame.new(origin + direction * alpha)
        task.wait(CONFIG.StepDelay + math.random() * CONFIG.AntiKickJitter)
    end

    RootPart.CFrame = CFrame.new(targetPos)
end

-- =====================
-- SAVE BASE POSITION
-- =====================
local function saveBase()
    savedBase = RootPart.Position + Vector3.new(0, 2, 0)
    print("[Ar Zero] ✅ Posisi base tersimpan → " .. tostring(savedBase))
end

-- =====================
-- TELEPORT KE BASE
-- =====================
local function teleportToBase()
    if isTeleporting then return end
    if not savedBase then
        warn("[Ar Zero] ⚠ Base belum disimpan! Tekan [" .. CONFIG.SaveKey.Name .. "] dulu.")
        return
    end

    isTeleporting = true
    print("[Ar Zero] Teleport ke base...")

    claimOwnership()
    resetVelocity()
    smoothTeleport(savedBase)
    resetVelocity()

    task.wait(0.4)
    isTeleporting = false

    print("[Ar Zero] ✅ Sampai di base.")
end

-- =====================
-- KEYBIND HANDLER
-- =====================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == CONFIG.SaveKey then
        saveBase()

    elseif input.KeyCode == CONFIG.TeleportKey then
        teleportToBase()
    end
end)

-- =====================
-- CHARACTER REFRESH
-- =====================
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    RootPart = newChar:WaitForChild("HumanoidRootPart")
    print("[Ar Zero] Character respawn — base tetap tersimpan: " .. tostring(savedBase))
end)

-- =====================
-- INIT
-- =====================
print("[Ar Zero] Script aktif.")
print("  [" .. CONFIG.SaveKey.Name .. "] → Simpan posisi base")
print("  [" .. CONFIG.TeleportKey.Name .. "] → Teleport ke base")