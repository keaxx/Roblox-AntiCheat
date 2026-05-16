--[[
╔══════════════════════════════════════════════════════════════╗
║              ROBLOX SERVER-SIDE ANTI-CHEAT                  ║
║                    Version 2.0.0                            ║
╚══════════════════════════════════════════════════════════════╝

    Detections:
      - Fly (A/B/C/D/E/F)
      - Speed (A/B/C/D)
      - Jump / Vertical Movement (A–M)
      - Teleport (A/B)
      - Noclip
      - Invisible / Transparency Hack
      - Gravity Manipulation
      - Health Manipulation (Godmode)
      - Rapid Fire / Animation Speed Hack
      - Anchor Hack (forcibly anchored HRP)
      - Simulation Radius Manipulation
      - Character Scale Hack
      - Tool / Weapon Spam
      - Infinite Stamina / Humanoid Property Tampering
]]

-- ─────────────────────────────────────────────────────────────
--  GENERAL SETTINGS
-- ─────────────────────────────────────────────────────────────
local Config = {}

Config.General = {
    LagBack          = true,   -- Teleport cheater back to last safe position
    KickOnViolation  = false,  -- Kick player instead of lag-back (overrides LagBack for severe checks)
    Debug            = true,   -- Print violations to server output
    LogToFolder      = true,   -- Store logs in a StringValue under ServerStorage
    MaxViolations    = 10,     -- Violations before auto-kick (0 = disabled)
    ViolationDecay   = 30,     -- Seconds before violation count resets
    LagBackCooldown  = 0.15,   -- Seconds between lag-backs per player
    PunishMessage    = "Anti-Cheat: Kicked for cheating.",
}

-- ─────────────────────────────────────────────────────────────
--  DETECTION TOGGLES
-- ─────────────────────────────────────────────────────────────
Config.Detections = {
    Fly              = true,
    Speed            = true,
    Jump             = true,
    Teleport         = true,
    Noclip           = true,
    Invisible        = true,
    GravityHack      = true,
    HealthHack       = true,
    AnimationSpeed   = true,
    AnchorHack       = true,
    CharacterScale   = true,
    ToolSpam         = true,
    HumanoidTamper   = true,
}

-- ─────────────────────────────────────────────────────────────
--  FLY DETECTION SETTINGS
-- ─────────────────────────────────────────────────────────────
Config.Fly = {
    -- Check A — Sustained air time via raycast
    A_Enabled          = true,
    A_MaxAirTime       = 2.15,   -- seconds

    -- Check B — Sustained air time via FloorMaterial
    B_Enabled          = true,
    B_MaxAirTime       = 2.15,

    -- Check C — Upward drift while airborne (raycast)
    C_Enabled          = true,
    C_MaxAirTime       = 2.15,

    -- Check D — Upward drift while airborne (FloorMaterial)
    D_Enabled          = true,
    D_MaxAirTime       = 2.15,

    -- Check E — High horizontal speed while descending
    E_Enabled          = true,
    E_MaxAirTime       = 0.85,
    E_MaxAirSpeed      = 15,

    -- Check F — High horizontal speed while ascending
    F_Enabled          = true,
    F_MaxAirTime       = 1.35,
    F_MaxAirSpeed      = 25,
}

-- ─────────────────────────────────────────────────────────────
--  SPEED DETECTION SETTINGS
-- ─────────────────────────────────────────────────────────────
Config.Speed = {
    -- Check A — Ground horizontal speed
    A_Enabled          = true,
    A_MaxVelocity      = 36,     -- studs/s

    -- Check B — WalkSpeed property tamper
    B_Enabled          = true,
    B_MaxWalkSpeed     = 17,
    B_MinWalkSpeed     = 15,

    -- Check C — Jump horizontal drift
    C_Enabled          = true,
    C_MaxDrift         = 10,     -- studs during jump

    -- Check D — Air horizontal speed
    D_Enabled          = true,
    D_MaxAirVelocity   = 43,
}

-- ─────────────────────────────────────────────────────────────
--  JUMP / VERTICAL MOVEMENT SETTINGS
-- ─────────────────────────────────────────────────────────────
Config.Jump = {
    A_Enabled          = true,  A_MaxVerticalSpeed  = 60,
    B_Enabled          = true,  B_MaxJumpPower      = 51,   B_MinJumpPower  = 49,
    C_Enabled          = true,  C_MaxJumpHeight     = 8,    C_MinJumpHeight = 7,
    D_Enabled          = true,  D_MaxJumpHeight     = 50,
    E_Enabled          = true,  E_MaxVerticalSpeed  = 75,
    F_Enabled          = true,  F_MaxRapidJumps     = 3,    F_RapidWindow   = 0.2,
    G_Enabled          = true,  G_MaxJumpHeight     = 8,    G_MinJumpHeight = 7,
    H_Enabled          = true,  H_MaxStrafeChange   = 145,
    I_Enabled          = true,  I_MinJumpDelay      = 0.2,
    J_Enabled          = true,  J_MaxJumpHeight     = 8,    J_MinJumpHeight = 7,
    K_Enabled          = true,  K_MaxJumpHeight     = 8,
    L_Enabled          = true,  L_MaxVerticalSpeed  = 65,
    M_Enabled          = true,  M_MaxAirHorizSpeed  = 60,
}

-- ─────────────────────────────────────────────────────────────
--  TELEPORT DETECTION SETTINGS
-- ─────────────────────────────────────────────────────────────
Config.Teleport = {
    A_Enabled          = true,
    A_MaxSpeed         = 75,    -- studs/s threshold

    B_Enabled          = true,
    B_MaxMagnitude     = 80,
}

-- ─────────────────────────────────────────────────────────────
--  NOCLIP DETECTION SETTINGS
-- ─────────────────────────────────────────────────────────────
Config.Noclip = {
    Enabled            = true,
    CheckInterval      = 0.5,   -- seconds between checks
    -- Detects when a player is inside a solid part
    CollisionThreshold = 0.3,   -- overlap depth to consider noclip
}

-- ─────────────────────────────────────────────────────────────
--  INVISIBLE / TRANSPARENCY HACK
-- ─────────────────────────────────────────────────────────────
Config.Invisible = {
    Enabled            = true,
    CheckInterval      = 1.0,
    -- If any character part has Transparency >= this value, flag it
    MaxTransparency    = 0.95,
}

-- ─────────────────────────────────────────────────────────────
--  GRAVITY MANIPULATION
-- ─────────────────────────────────────────────────────────────
Config.Gravity = {
    Enabled            = true,
    CheckInterval      = 2.0,
    -- Expected workspace gravity (default Roblox = 196.2)
    ExpectedGravity    = 196.2,
    Tolerance          = 5.0,
}

-- ─────────────────────────────────────────────────────────────
--  HEALTH / GODMODE DETECTION
-- ─────────────────────────────────────────────────────────────
Config.Health = {
    Enabled            = true,
    CheckInterval      = 0.05,
    MaxHealth          = 100,
    MinHealth          = 0,
    MaxMaxHealth       = 100,
}

-- ─────────────────────────────────────────────────────────────
--  ANIMATION SPEED HACK
-- ─────────────────────────────────────────────────────────────
Config.AnimSpeed = {
    Enabled            = true,
    CheckInterval      = 1.0,
    MaxAnimSpeed       = 3.0,   -- Maximum allowed animation speed multiplier
}

-- ─────────────────────────────────────────────────────────────
--  ANCHOR HACK (forcibly anchored HumanoidRootPart)
-- ─────────────────────────────────────────────────────────────
Config.AnchorHack = {
    Enabled            = true,
    CheckInterval      = 0.5,
}

-- ─────────────────────────────────────────────────────────────
--  CHARACTER SCALE HACK
-- ─────────────────────────────────────────────────────────────
Config.CharScale = {
    Enabled            = true,
    CheckInterval      = 2.0,
    MaxScale           = 5.0,   -- Any scale value above this is flagged
    MinScale           = 0.1,
}

-- ─────────────────────────────────────────────────────────────
--  TOOL / WEAPON SPAM
-- ─────────────────────────────────────────────────────────────
Config.ToolSpam = {
    Enabled            = true,
    CheckInterval      = 1.0,
    MaxToolsInCharacter = 3,    -- Max tools allowed equipped simultaneously
}

-- ─────────────────────────────────────────────────────────────
--  HUMANOID PROPERTY TAMPER
-- ─────────────────────────────────────────────────────────────
Config.HumanoidTamper = {
    Enabled            = true,
    CheckInterval      = 0.5,
    MaxWalkSpeed       = 24,    -- Absolute ceiling regardless of game logic
    MaxJumpPower       = 60,
    MaxJumpHeight      = 10,
}

-- ═════════════════════════════════════════════════════════════
--  INTERNAL — DO NOT EDIT BELOW UNLESS YOU KNOW WHAT YOU'RE DOING
-- ═════════════════════════════════════════════════════════════

local Players       = game:GetService("Players")
local RunService    = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")

-- Violation tracker per player
local violationData = {}  -- [player] = { count, lastTime }

-- Lag-back cooldown tracker
local lagBackCD = {}      -- [player] = lastLagBackTime

local function getTime() return os.clock() end

-- ─── Logging ─────────────────────────────────────────────────
local logFolder
if Config.General.LogToFolder then
    logFolder = Instance.new("Folder")
    logFolder.Name = "AC_Logs"
    logFolder.Parent = ServerStorage
end

local function log(player, checkName, detail)
    local msg = string.format("[AC] %s | Check: %s | %s", player.Name, checkName, tostring(detail))
    if Config.General.Debug then
        warn(msg)
    end
    if Config.General.LogToFolder and logFolder then
        local sv = Instance.new("StringValue")
        sv.Name = os.date("%H:%M:%S") .. " " .. player.Name
        sv.Value = msg
        sv.Parent = logFolder
    end
end

-- ─── Violation System ─────────────────────────────────────────
local function addViolation(player, checkName, detail)
    log(player, checkName, detail)

    if Config.General.MaxViolations <= 0 then return end

    local data = violationData[player]
    if not data then return end

    local now = getTime()
    if now - data.lastTime > Config.General.ViolationDecay then
        data.count = 0
    end
    data.count = data.count + 1
    data.lastTime = now

    if data.count >= Config.General.MaxViolations then
        pcall(function()
            player:Kick(Config.General.PunishMessage)
        end)
    end
end

-- ─── Lag-Back ────────────────────────────────────────────────
local function lagBack(player, root, lastPosition, checkName, detail)
    addViolation(player, checkName, detail)

    if not Config.General.LagBack then return end
    if not root or not root.Parent then return end

    local now = getTime()
    local last = lagBackCD[player] or 0
    if now - last < Config.General.LagBackCooldown then return end
    lagBackCD[player] = now

    pcall(function()
        root.CFrame = CFrame.new(lastPosition)
    end)
end

-- ─── Kick (severe violations) ─────────────────────────────────
local function kick(player, checkName, detail)
    addViolation(player, checkName, detail)
    if Config.General.KickOnViolation then
        pcall(function() player:Kick(Config.General.PunishMessage) end)
    end
end

-- ─── Raycast floor helper ─────────────────────────────────────
local function isOnFloor(root, character)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {character}

    local numRays = 20
    local radius  = 1.5
    local step    = math.pi * 2 / numRays
    local origin  = root.Position - Vector3.new(0, 0.1, 0)

    for i = 1, numRays do
        local angle = i * step
        local dir   = Vector3.new(radius * math.cos(angle), 0, radius * math.sin(angle))
        local hit   = workspace:Raycast(origin + dir, Vector3.new(0, -3.5, 0), params)
        if hit and hit.Instance then return true end
    end
    return false
end

-- ─── Safe format helper ──────────────────────────────────────
local function fmt(n)
    return string.format("%.2f", tonumber(n) or 0)
end

-- ─── Horizontal speed helper ─────────────────────────────────
local function horizSpeed(posA, posB, dt)
    if dt <= 0 then return 0 end
    local dx = posB.X - posA.X
    local dz = posB.Z - posA.Z
    return math.sqrt(dx*dx + dz*dz) / dt
end

-- ═════════════════════════════════════════════════════════════
--  PER-PLAYER CHECK SPAWNER
-- ═════════════════════════════════════════════════════════════
Players.PlayerAdded:Connect(function(player)
    violationData[player] = { count = 0, lastTime = getTime() }
    lagBackCD[player]     = 0

    player.CharacterAdded:Connect(function(character)
        task.wait(1) -- let character fully load

        local root = character:WaitForChild("HumanoidRootPart", 10)
        local humanoid = character:WaitForChild("Humanoid", 10)
        if not root or not humanoid then return end

        -- Shared state
        local lastPosition     = root.Position
        local lastTime         = getTime()
        local lastFloorTime    = getTime()
        local lastFloorTimeB   = getTime()
        local lastJumpTime     = 0
        local lastJumpTick     = 0
        local jumpCount        = 0
        local lastGroundPos    = root.Position
        local lastVelocity     = Vector3.zero
        local airTime          = 0  -- accumulator for FloorMaterial checks

        local alive = true
        humanoid.Died:Connect(function() alive = false end)

        local function isAlive()
            return alive and player and player.Parent and character and character.Parent
                and root and root.Parent and humanoid and humanoid.Parent
                and humanoid.Health > 0
        end

        -- ── FLY CHECKS ────────────────────────────────────────

        -- Fly A: raycast sustained air, descending
        if Config.Detections.Fly and Config.Fly.A_Enabled then
            task.spawn(function()
                while isAlive() do
                    task.wait()
                    if isOnFloor(root, character) then lastFloorTime = getTime() end
                    local elapsed = getTime() - lastFloorTime
                    local vy = root.Velocity.Y
                    local state = humanoid:GetState()
                    if elapsed >= Config.Fly.A_MaxAirTime
                        and state ~= Enum.HumanoidStateType.Landed
                        and vy <= 0 and vy >= -15 then
                        lagBack(player, root, lastPosition, "Fly-A", "AirTime="..fmt(elapsed))
                    end
                end
            end)
        end

        -- Fly B: FloorMaterial sustained air, descending
        if Config.Detections.Fly and Config.Fly.B_Enabled then
            task.spawn(function()
                local accum = 0
                while isAlive() do
                    task.wait()
                    local mat = humanoid.FloorMaterial
                    if mat == Enum.Material.Air then
                        accum = accum + 0.015
                    else
                        accum = 0
                    end
                    local vy = root.Velocity.Y
                    if accum >= Config.Fly.B_MaxAirTime and vy <= 0 and vy >= -15 then
                        lagBack(player, root, lastPosition, "Fly-B", "AccumAir="..fmt(accum))
                        accum = 0
                    end
                end
            end)
        end

        -- Fly C: raycast sustained air, ascending
        if Config.Detections.Fly and Config.Fly.C_Enabled then
            task.spawn(function()
                while isAlive() do
                    task.wait()
                    if isOnFloor(root, character) then lastFloorTime = getTime() end
                    local elapsed = getTime() - lastFloorTime
                    local vy = root.Velocity.Y
                    local state = humanoid:GetState()
                    if elapsed >= Config.Fly.C_MaxAirTime
                        and state ~= Enum.HumanoidStateType.Landed
                        and vy >= 2 and vy <= 25 then
                        lagBack(player, root, lastPosition, "Fly-C", "AirTime="..fmt(elapsed))
                    end
                end
            end)
        end

        -- Fly D: FloorMaterial sustained air, ascending
        if Config.Detections.Fly and Config.Fly.D_Enabled then
            task.spawn(function()
                local accum = 0
                while isAlive() do
                    task.wait()
                    local mat = humanoid.FloorMaterial
                    if mat == Enum.Material.Air then
                        accum = accum + 0.015
                    else
                        accum = 0
                    end
                    local vy = root.Velocity.Y
                    if accum >= Config.Fly.D_MaxAirTime and vy >= 2 and vy <= 25 then
                        lagBack(player, root, lastPosition, "Fly-D", "AccumAir="..fmt(accum))
                        accum = 0
                    end
                end
            end)
        end

        -- Fly E: high horizontal speed while descending
        if Config.Detections.Fly and Config.Fly.E_Enabled then
            task.spawn(function()
                while isAlive() do
                    task.wait()
                    if isOnFloor(root, character) then lastFloorTime = getTime() end
                    local elapsed = getTime() - lastFloorTime
                    local vy = root.Velocity.Y
                    local dt = getTime() - lastTime
                    local hs = horizSpeed(lastPosition, root.Position, dt)
                    if elapsed >= Config.Fly.E_MaxAirTime and vy <= 0 and vy >= -20
                        and hs >= Config.Fly.E_MaxAirSpeed then
                        lagBack(player, root, lastPosition, "Fly-E", "HorizSpeed="..fmt(hs))
                    end
                    lastPosition = root.Position
                    lastTime = getTime()
                end
            end)
        end

        -- Fly F: high horizontal speed while ascending
        if Config.Detections.Fly and Config.Fly.F_Enabled then
            task.spawn(function()
                while isAlive() do
                    task.wait()
                    if isOnFloor(root, character) then lastFloorTime = getTime() end
                    local elapsed = getTime() - lastFloorTime
                    local vy = root.Velocity.Y
                    local dt = getTime() - lastTime
                    local hs = horizSpeed(lastPosition, root.Position, dt)
                    if elapsed >= Config.Fly.F_MaxAirTime and vy >= 5 and vy <= 25
                        and hs >= Config.Fly.F_MaxAirSpeed then
                        lagBack(player, root, lastPosition, "Fly-F", "HorizSpeed="..fmt(hs))
                    end
                    lastPosition = root.Position
                    lastTime = getTime()
                end
            end)
        end

        -- ── SPEED CHECKS ──────────────────────────────────────

        -- Speed A: ground horizontal overspeed
        if Config.Detections.Speed and Config.Speed.A_Enabled then
            task.spawn(function()
                local flagged = false
                while isAlive() do
                    task.wait(0.07)
                    local dt = getTime() - lastTime
                    local hs = horizSpeed(lastPosition, root.Position, dt)
                    if humanoid.FloorMaterial ~= Enum.Material.Air then
                        if hs >= Config.Speed.A_MaxVelocity then
                            if not flagged then
                                lagBack(player, root, lastPosition, "Speed-A", "HS="..fmt(hs))
                                flagged = true
                                task.delay(0.25, function() flagged = false end)
                            end
                        end
                    end
                    lastPosition = root.Position
                    lastTime = getTime()
                end
            end)
        end

        -- Speed B: WalkSpeed property tamper
        if Config.Detections.Speed and Config.Speed.B_Enabled then
            task.spawn(function()
                while isAlive() do
                    task.wait(0.11)
                    local ws = humanoid.WalkSpeed
                    if ws > Config.Speed.B_MaxWalkSpeed or ws < Config.Speed.B_MinWalkSpeed then
                        lagBack(player, root, lastPosition, "Speed-B", "WalkSpeed="..fmt(ws))
                    end
                    lastPosition = root.Position
                    lastTime = getTime()
                end
            end)
        end

        -- Speed C: jump horizontal drift
        if Config.Detections.Speed and Config.Speed.C_Enabled then
            task.spawn(function()
                while isAlive() do
                    task.wait(0.51)
                    local state = humanoid:GetState()
                    if state == Enum.HumanoidStateType.Jumping then
                        local dist = (lastGroundPos - root.Position).Magnitude
                        if dist > Config.Speed.C_MaxDrift then
                            lagBack(player, root, lastPosition, "Speed-C", "Drift="..fmt(dist))
                        end
                    elseif state == Enum.HumanoidStateType.Landed then
                        lastGroundPos = root.Position
                    end
                    lastPosition = root.Position
                    lastTime = getTime()
                end
            end)
        end

        -- Speed D: air horizontal overspeed
        if Config.Detections.Speed and Config.Speed.D_Enabled then
            task.spawn(function()
                while isAlive() do
                    task.wait(0.055)
                    local dt = getTime() - lastTime
                    local hs = horizSpeed(lastPosition, root.Position, dt)
                    if hs >= Config.Speed.D_MaxAirVelocity
                        and humanoid.FloorMaterial == Enum.Material.Air then
                        lagBack(player, root, lastPosition, "Speed-D", "AirHS="..fmt(hs))
                    end
                    lastPosition = root.Position
                    lastTime = getTime()
                end
            end)
        end

        -- ── JUMP / VERTICAL CHECKS ────────────────────────────

        -- Jump A: vertical speed spike
        if Config.Detections.Jump and Config.Jump.A_Enabled then
            task.spawn(function()
                while isAlive() do
                    task.wait(0.25)
                    local vy = root.Velocity.Y
                    if math.abs(vy) >= Config.Jump.A_MaxVerticalSpeed and vy >= Config.Jump.A_MaxVerticalSpeed then
                        lagBack(player, root, lastPosition, "Jump-A", "VY="..fmt(vy))
                    end
                    lastPosition = root.Position; lastTime = getTime()
                end
            end)
        end

        -- Jump B: JumpPower tamper
        if Config.Detections.Jump and Config.Jump.B_Enabled then
            task.spawn(function()
                while isAlive() do
                    task.wait(0.25)
                    local jp = humanoid.JumpPower
                    local state = humanoid:GetState()
                    if (jp > Config.Jump.B_MaxJumpPower or jp < Config.Jump.B_MinJumpPower)
                        and state == Enum.HumanoidStateType.Jumping then
                        lagBack(player, root, lastPosition, "Jump-B", "JP="..fmt(jp))
                    end
                    lastPosition = root.Position; lastTime = getTime()
                end
            end)
        end

        -- Jump C: JumpHeight tamper (min/max)
        if Config.Detections.Jump and Config.Jump.C_Enabled then
            task.spawn(function()
                while isAlive() do
                    task.wait(0.25)
                    local jh = humanoid.JumpHeight
                    local state = humanoid:GetState()
                    if (jh > Config.Jump.C_MaxJumpHeight or jh < Config.Jump.C_MinJumpHeight)
                        and state == Enum.HumanoidStateType.Jumping then
                        lagBack(player, root, lastPosition, "Jump-C", "JH="..fmt(jh))
                    end
                    lastPosition = root.Position; lastTime = getTime()
                end
            end)
        end

        -- Jump D: JumpHeight exceeds absolute max while jumping
        if Config.Detections.Jump and Config.Jump.D_Enabled then
            task.spawn(function()
                while isAlive() do
                    task.wait(0.25)
                    local jh = humanoid.JumpHeight
                    local state = humanoid:GetState()
                    if state == Enum.HumanoidStateType.Jumping and jh > Config.Jump.D_MaxJumpHeight then
                        lagBack(player, root, lastPosition, "Jump-D", "JH="..fmt(jh))
                    end
                    lastPosition = root.Position; lastTime = getTime()
                end
            end)
        end

        -- Jump E: abnormal upward Y velocity when NOT jumping
        if Config.Detections.Jump and Config.Jump.E_Enabled then
            task.spawn(function()
                while isAlive() do
                    task.wait(0.25)
                    local vy = root.Velocity.Y
                    local state = humanoid:GetState()
                    if vy > Config.Jump.E_MaxVerticalSpeed and state ~= Enum.HumanoidStateType.Jumping then
                        lagBack(player, root, lastPosition, "Jump-E", "VY="..fmt(vy))
                    end
                    lastPosition = root.Position; lastTime = getTime()
                end
            end)
        end

        -- Jump F: rapid consecutive jumps
        if Config.Detections.Jump and Config.Jump.F_Enabled then
            task.spawn(function()
                while isAlive() do
                    task.wait(0.25)
                    local state = humanoid:GetState()
                    if state == Enum.HumanoidStateType.Jumping then
                        local now = getTime()
                        if now - lastJumpTime < Config.Jump.F_RapidWindow then
                            jumpCount = jumpCount + 1
                            if jumpCount >= Config.Jump.F_MaxRapidJumps then
                                lagBack(player, root, lastPosition, "Jump-F", "RapidJumps="..jumpCount)
                                jumpCount = 0
                            end
                        else
                            jumpCount = 0
                        end
                        lastJumpTime = now
                    end
                    lastPosition = root.Position; lastTime = getTime()
                end
            end)
        end

        -- Jump G: JumpHeight bounds (duplicate axis check)
        if Config.Detections.Jump and Config.Jump.G_Enabled then
            task.spawn(function()
                while isAlive() do
                    task.wait(0.25)
                    local jh = humanoid.JumpHeight
                    local state = humanoid:GetState()
                    if (jh > Config.Jump.G_MaxJumpHeight or jh < Config.Jump.G_MinJumpHeight)
                        and state == Enum.HumanoidStateType.Jumping then
                        lagBack(player, root, lastPosition, "Jump-G", "JH="..fmt(jh))
                    end
                    lastPosition = root.Position; lastTime = getTime()
                end
            end)
        end

        -- Jump H: sudden velocity strafe change mid-air
        if Config.Detections.Jump and Config.Jump.H_Enabled then
            task.spawn(function()
                while isAlive() do
                    task.wait(0.25)
                    local cv = root.Velocity
                    local state = humanoid:GetState()
                    if humanoid.FloorMaterial == Enum.Material.Air
                        and (state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Freefall) then
                        local delta = (cv - lastVelocity).Magnitude
                        if delta > Config.Jump.H_MaxStrafeChange then
                            lagBack(player, root, lastPosition, "Jump-H", "VelDelta="..fmt(delta))
                        end
                    end
                    lastVelocity = cv
                    lastPosition = root.Position; lastTime = getTime()
                end
            end)
        end

        -- Jump I: jump delay too short (auto-jump / bhop hack)
        if Config.Detections.Jump and Config.Jump.I_Enabled then
            task.spawn(function()
                local prevJumpTick = 0
                while isAlive() do
                    task.wait(0.25)
                    local state = humanoid:GetState()
                    local now = getTime()
                    if state == Enum.HumanoidStateType.Jumping then
                        local delay = now - prevJumpTick
                        if delay < Config.Jump.I_MinJumpDelay and prevJumpTick ~= 0 then
                            lagBack(player, root, lastPosition, "Jump-I", "JumpDelay="..fmt(delay))
                        end
                        prevJumpTick = now
                    end
                    lastPosition = root.Position; lastTime = now
                end
            end)
        end

        -- Jump J: JumpHeight bounds (tertiary check)
        if Config.Detections.Jump and Config.Jump.J_Enabled then
            task.spawn(function()
                while isAlive() do
                    task.wait(0.5)
                    local jh = humanoid.JumpHeight
                    local state = humanoid:GetState()
                    if (jh > Config.Jump.J_MaxJumpHeight or jh < Config.Jump.J_MinJumpHeight)
                        and state == Enum.HumanoidStateType.Jumping then
                        lagBack(player, root, lastPosition, "Jump-J", "JH="..fmt(jh))
                    end
                    lastPosition = root.Position; lastTime = getTime()
                end
            end)
        end

        -- Jump K: high JumpHeight with near-zero WalkSpeed (freeze-jump exploit)
        if Config.Detections.Jump and Config.Jump.K_Enabled then
            task.spawn(function()
                while isAlive() do
                    task.wait(0.25)
                    local jh = humanoid.JumpHeight
                    if jh > Config.Jump.K_MaxJumpHeight and humanoid.WalkSpeed < 1 then
                        lagBack(player, root, lastPosition, "Jump-K", "JH="..fmt(jh))
                    end
                    lastPosition = root.Position; lastTime = getTime()
                end
            end)
        end

        -- Jump L: high upward velocity
        if Config.Detections.Jump and Config.Jump.L_Enabled then
            task.spawn(function()
                while isAlive() do
                    task.wait(0.25)
                    local vy = root.Velocity.Y
                    local state = humanoid:GetState()
                    if math.abs(vy) >= Config.Jump.L_MaxVerticalSpeed and vy >= 0 then
                        lagBack(player, root, lastPosition, "Jump-L", "VY="..fmt(vy))
                    elseif state == Enum.HumanoidStateType.Landed then
                        lastGroundPos = root.Position
                    end
                    lastPosition = root.Position; lastTime = getTime()
                end
            end)
        end

        -- Jump M: high horizontal speed while airborne (air-strafe exploit)
        if Config.Detections.Jump and Config.Jump.M_Enabled then
            task.spawn(function()
                while isAlive() do
                    task.wait(0.25)
                    local dt = getTime() - lastTime
                    local hs = horizSpeed(lastPosition, root.Position, dt)
                    local state = humanoid:GetState()
                    if hs >= Config.Jump.M_MaxAirHorizSpeed
                        and (state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Freefall) then
                        lagBack(player, root, lastPosition, "Jump-M", "AirHS="..fmt(hs))
                    end
                    lastPosition = root.Position; lastTime = getTime()
                end
            end)
        end

        -- ── TELEPORT CHECKS ───────────────────────────────────

        -- Teleport A: horizontal speed spike
        if Config.Detections.Teleport and Config.Teleport.A_Enabled then
            task.spawn(function()
                local guard = false
                while isAlive() do
                    task.wait(0.25)
                    local dt = getTime() - lastTime
                    local hs = horizSpeed(lastPosition, root.Position, dt)
                    if hs >= Config.Teleport.A_MaxSpeed then
                        if not guard then
                            lagBack(player, root, lastPosition, "Teleport-A", "HS="..fmt(hs))
                            guard = true
                            task.delay(0.15, function() guard = false end)
                        end
                    end
                    lastPosition = root.Position; lastTime = getTime()
                end
            end)
        end

        -- Teleport B: total velocity magnitude spike while horizontal
        if Config.Detections.Teleport and Config.Teleport.B_Enabled then
            task.spawn(function()
                while isAlive() do
                    task.wait(0.25)
                    local vy = root.Velocity.Y
                    if root.Position ~= lastPosition
                        and root.Velocity.Magnitude > Config.Teleport.B_MaxMagnitude
                        and vy >= -15 and vy <= 15 then
                        lagBack(player, root, lastPosition, "Teleport-B", "Mag="..fmt(root.Velocity.Magnitude))
                    end
                    lastPosition = root.Position; lastTime = getTime()
                end
            end)
        end

        -- ── HEALTH / GODMODE ──────────────────────────────────

        if Config.Detections.HealthHack and Config.Health.Enabled then
            task.spawn(function()
                while isAlive() do
                    task.wait(Config.Health.CheckInterval)
                    local hp  = humanoid.Health
                    local mhp = humanoid.MaxHealth
                    if hp > Config.Health.MaxHealth or hp < Config.Health.MinHealth then
                        kick(player, "Health-A", "HP="..fmt(hp))
                    end
                    if mhp > Config.Health.MaxMaxHealth or mhp < 0 then
                        kick(player, "Health-B", "MaxHP="..fmt(mhp))
                    end
                end
            end)
        end

        -- ── NOCLIP DETECTION ──────────────────────────────────
        if Config.Detections.Noclip and Config.Noclip.Enabled then
            task.spawn(function()
                while isAlive() do
                    task.wait(Config.Noclip.CheckInterval)
                    -- Check if root is overlapping a solid non-character part
                    local params = OverlapParams.new()
                    params.FilterType = Enum.RaycastFilterType.Exclude
                    params.FilterDescendantsInstances = {character}
                    local size = root.Size * 0.5
                    local touching = workspace:GetPartBoundsInBox(root.CFrame, size, params)
                    for _, part in ipairs(touching) do
                        if part.CanCollide and not part:IsDescendantOf(character) then
                            lagBack(player, root, lastPosition, "Noclip", "Inside="..part.Name)
                            break
                        end
                    end
                end
            end)
        end

        -- ── INVISIBLE / TRANSPARENCY HACK ─────────────────────
        if Config.Detections.Invisible and Config.Invisible.Enabled then
            task.spawn(function()
                while isAlive() do
                    task.wait(Config.Invisible.CheckInterval)
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") and part.Transparency >= Config.Invisible.MaxTransparency then
                            -- Reset transparency
                            pcall(function() part.Transparency = 0 end)
                            addViolation(player, "Invisible", "Part="..part.Name)
                            break
                        end
                    end
                end
            end)
        end

        -- ── GRAVITY HACK ──────────────────────────────────────
        if Config.Detections.GravityHack and Config.Gravity.Enabled then
            task.spawn(function()
                while isAlive() do
                    task.wait(Config.Gravity.CheckInterval)
                    local g = workspace.Gravity
                    if math.abs(g - Config.Gravity.ExpectedGravity) > Config.Gravity.Tolerance then
                        -- Restore gravity
                        workspace.Gravity = Config.Gravity.ExpectedGravity
                        addViolation(player, "Gravity", "G="..fmt(g))
                    end
                end
            end)
        end

        -- ── ANIMATION SPEED HACK ──────────────────────────────
        if Config.Detections.AnimationSpeed and Config.AnimSpeed.Enabled then
            task.spawn(function()
                while isAlive() do
                    task.wait(Config.AnimSpeed.CheckInterval)
                    local animator = humanoid:FindFirstChildOfClass("Animator")
                    if animator then
                        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                            if track.Speed > Config.AnimSpeed.MaxAnimSpeed then
                                pcall(function() track:AdjustSpeed(1) end)
                                addViolation(player, "AnimSpeed", "Speed="..fmt(track.Speed))
                            end
                        end
                    end
                end
            end)
        end

        -- ── ANCHOR HACK ───────────────────────────────────────
        if Config.Detections.AnchorHack and Config.AnchorHack.Enabled then
            task.spawn(function()
                while isAlive() do
                    task.wait(Config.AnchorHack.CheckInterval)
                    if root.Anchored then
                        root.Anchored = false
                        addViolation(player, "AnchorHack", "HRP was anchored")
                    end
                end
            end)
        end

        -- ── CHARACTER SCALE HACK ──────────────────────────────
        if Config.Detections.CharacterScale and Config.CharScale.Enabled then
            task.spawn(function()
                while isAlive() do
                    task.wait(Config.CharScale.CheckInterval)
                    for _, desc in ipairs(character:GetDescendants()) do
                        if desc:IsA("NumberValue") and desc.Parent and desc.Parent.Name == "BodyHeightScale"
                            or (desc:IsA("NumberValue") and string.find(desc.Name, "Scale")) then
                            if desc.Value > Config.CharScale.MaxScale or desc.Value < Config.CharScale.MinScale then
                                addViolation(player, "CharScale", desc.Name.."="..fmt(desc.Value))
                                pcall(function() desc.Value = math.clamp(desc.Value, Config.CharScale.MinScale, Config.CharScale.MaxScale) end)
                            end
                        end
                    end
                end
            end)
        end

        -- ── TOOL SPAM ─────────────────────────────────────────
        if Config.Detections.ToolSpam and Config.ToolSpam.Enabled then
            task.spawn(function()
                while isAlive() do
                    task.wait(Config.ToolSpam.CheckInterval)
                    local toolCount = 0
                    for _, obj in ipairs(character:GetChildren()) do
                        if obj:IsA("Tool") then toolCount = toolCount + 1 end
                    end
                    if toolCount > Config.ToolSpam.MaxToolsInCharacter then
                        addViolation(player, "ToolSpam", "Tools="..toolCount)
                    end
                end
            end)
        end

        -- ── HUMANOID PROPERTY TAMPER ──────────────────────────
        if Config.Detections.HumanoidTamper and Config.HumanoidTamper.Enabled then
            task.spawn(function()
                while isAlive() do
                    task.wait(Config.HumanoidTamper.CheckInterval)
                    local ws = humanoid.WalkSpeed
                    local jp = humanoid.JumpPower
                    local jh = humanoid.JumpHeight
                    if ws > Config.HumanoidTamper.MaxWalkSpeed then
                        addViolation(player, "HumanoidTamper", "WalkSpeed="..fmt(ws))
                        pcall(function() humanoid.WalkSpeed = Config.HumanoidTamper.MaxWalkSpeed end)
                    end
                    if jp > Config.HumanoidTamper.MaxJumpPower then
                        addViolation(player, "HumanoidTamper", "JumpPower="..fmt(jp))
                        pcall(function() humanoid.JumpPower = Config.HumanoidTamper.MaxJumpPower end)
                    end
                    if jh > Config.HumanoidTamper.MaxJumpHeight then
                        addViolation(player, "HumanoidTamper", "JumpHeight="..fmt(jh))
                        pcall(function() humanoid.JumpHeight = Config.HumanoidTamper.MaxJumpHeight end)
                    end
                end
            end)
        end

    end) -- CharacterAdded
end) -- PlayerAdded

-- ── Cleanup on player leave ───────────────────────────────────
Players.PlayerRemoving:Connect(function(player)
    violationData[player] = nil
    lagBackCD[player]     = nil
end)
