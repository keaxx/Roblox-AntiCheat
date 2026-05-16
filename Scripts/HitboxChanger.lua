-- ServerScriptService > HitboxAntiCheat
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Configuration
local CHECK_INTERVAL = 0.5          -- seconds
local MAX_SIZE_MULTIPLIER = 1.15    -- Allow slight variations (e.g. animations)
local MIN_SIZE_MULTIPLIER = 0.85
local KICK_ON_DETECT = true
local BAN_ON_DETECT = false         -- Set to true if you have a ban system
local LOG_TO_CONSOLE = true

-- Default Roblox character part sizes (approximate)
local DEFAULT_SIZES = {
    Head = Vector3.new(1.2, 1.2, 1.2),
    UpperTorso = Vector3.new(1.2, 1.4, 0.7),  -- R15
    LowerTorso = Vector3.new(1.2, 0.6, 0.7),
    LeftUpperArm = Vector3.new(0.5, 1.2, 0.5),
    -- Add more parts as needed and make sure the stars are correct!!
}

local suspiciousPlayers = {}

local function log(msg)
    if LOG_TO_CONSOLE then
        print("[HitboxAntiCheat] " .. msg)
    end
end

local function isPartSuspicious(part)
    if not part or not part:IsA("BasePart") then return false end
    
    local defaultSize = DEFAULT_SIZES[part.Name]
    if not defaultSize then return false end
    
    local sizeMultX = part.Size.X / defaultSize.X
    local sizeMultY = part.Size.Y / defaultSize.Y
    local sizeMultZ = part.Size.Z / defaultSize.Z
    
    if sizeMultX > MAX_SIZE_MULTIPLIER or sizeMultY > MAX_SIZE_MULTIPLIER or sizeMultZ > MAX_SIZE_MULTIPLIER or
       sizeMultX < MIN_SIZE_MULTIPLIER or sizeMultY < MIN_SIZE_MULTIPLIER or sizeMultZ < MIN_SIZE_MULTIPLIER then
        return true, (sizeMultX + sizeMultY + sizeMultZ) / 3
    end
    
    -- Transparency / visibility tricks
    if part.Transparency > 0.8 and part.CanCollide then
        return true, "High transparency with collision"
    end
    
    -- CanCollide abuse (some exploits make hitboxes non-collidable)
    if not part.CanCollide and part.Name ~= "HumanoidRootPart" then
        return true, "Disabled collision"
    end
    
    return false
end

local function checkCharacter(character)
    if not character or not character:FindFirstChild("Humanoid") then return end
    
    local humanoid = character.Humanoid
    local root = character:FindFirstChild("HumanoidRootPart")
    
    if not root then return end
    
    -- Check scale (BodyScale / custom scaling)
    if humanoid:FindFirstChild("BodyWidthScale") or humanoid:FindFirstChild("BodyHeightScale") then
        for _, scale in pairs(humanoid:GetChildren()) do
            if scale:IsA("NumberValue") and scale.Name:find("Scale") then
                if scale.Value > 1.3 or scale.Value < 0.7 then
                    return true, "Scale value: " .. scale.Name .. " = " .. scale.Value
                end
            end
        end
    end
    
    -- Check all parts
    for _, part in ipairs(character:GetChildren()) do
        local suspicious, reason = isPartSuspicious(part)
        if suspicious then
            return true, part.Name .. " - " .. tostring(reason)
        end
    end
    
    -- Root part velocity / position sanity (optional extra layer)
    if root.Velocity.Magnitude > 300 then
        return true, "Extreme velocity"
    end
    
    return false
end

local function punishPlayer(player, reason)
    if suspiciousPlayers[player] then return end
    suspiciousPlayers[player] = true
    
    log("DETECTED " .. player.Name .. " | Reason: " .. reason)
    
    if KICK_ON_DETECT then
        player:Kick("Anti-Cheat: Hitbox manipulation detected.")
    end
    
    if BAN_ON_DETECT then
        -- Implement your ban system here (DataStore, etc.)
        -- game:GetService("BanService"):BanAsync(...) or your own method
    end
end

-- Main check loop
task.spawn(function()
    while true do
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character then
                local detected, reason = checkCharacter(player.Character)
                if detected then
                    punishPlayer(player, reason)
                end
            end
        end
        task.wait(CHECK_INTERVAL)
    end
end)

-- Handle new characters
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        task.wait(1) -- Give time to load
        local detected, reason = checkCharacter(character)
        if detected then
            punishPlayer(player, reason)
        end
    end)
end)

log("Hitbox Anti-Cheat initialized.")
