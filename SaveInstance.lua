-- Server Script → ServerScriptService
-- Aggressive Anti‑SaveInstance / Anti‑Decompiler / Anti‑Backdoor (Server + Client)
-- Sources: Infinity Yield, Universal SynSaveInstance, Dark Dex, open‑source executors

local Players = game:GetService("Players")
local LogService = game:GetService("LogService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ==============================================
-- 1. Pattern matching (server‑side)
-- ==============================================
local function escapePattern(str)
	return (str:gsub("([%(%)%.%%%+%-%*%?%[%^%$])", "%%%1"))
end

local rawStrings = {
	"Falling back to local copy", "LETS EDIT!", "Problem getting the value of property",
	"Error fetching json:", "Api found in folder!", "thispassed", "saving game",
	"saveinstance", "synsaveinstance", "Saved ", "MB)", "MB to workspace",
	"Copying game", "Decompiling", "Decompiled", "decompiler", "decompiling scripts",
	"scripts decompiled", "UniversalSynSaveInstance", "Saved by UniversalSynSaveInstance",
	"Join to Copy Games", "SynSaveInstance", "EasySaveInstance", "RoSaver", "SaveInstance by",
	"Save Instance", "saving instance", "instance saved", "Instance saved to workspace",
	"Saving Instance...", "Fetching assets", "Uploading assets", "Cloning instances",
	"Workspace saved", "Game saved", "Save file", "savefile", "writefile", "readfile",
	"makefolder", "delfolder", "listfiles", "rbxl", "rbxm",
	"Infinity Yield", "IY loaded", "IY: SaveInstance", "Loaded Infinity Yield",
	"iy_saveinstance", "iy_decompile", "Dark Dex", "Dex Explorer", "dex saveinstance",
	"getscriptbytecode", "dumpstring", "getscripts", "getnilinstances", "getinstances",
	"firesignal", "hookfunction", "hookmetamethod", "getgc", "getrenv", "getgenv",
	"setthreadidentity", "getthreadidentity", "setidentity", "getidentity",
	"syn_context", "setthreadcontext", "getsenv", "getmenv", "getfenv", "setfenv",
	"newcclosure", "getrawmetatable", "setrawmetatable", "getnamecallmethod",
	"setnamecallmethod", "loadstring", "getloadedmodules",
	"synapse", "krnl", "fluxus", "solara", "wave", "scriptware", "vega x",
	"arceus x", "hydrogen", "jjsploit", "nihon", "furk ultra", "codex", "electron",
	"Unluac", "luadec", "unluac_java", "decompiler by", "decompiled successfully",
	"bytecode converter", "backdoor", "remote spy", "remote executor", "server lua",
	"injected", "bypass", "fe bypass", "filteringenabled", "printidentity",
}

local escapedStrings = {}
for _, str in ipairs(rawStrings) do
	escapedStrings[#escapedStrings + 1] = escapePattern(str:lower())
end
local detectPattern = "(" .. table.concat(escapedStrings, "|") .. ")"

-- ==============================================
-- 2. Immediate server‑side kick
-- ==============================================
local function kickPlayer(player, reason)
	if player and player:IsA("Player") then
		warn("[AntiCheat] Kicking", player.Name, "→", reason)
		player:Kick("Exploiting detected - " .. reason)
	end
end

local activePlayers = {}
local function updatePlayerList()
	activePlayers = Players:GetPlayers()
end
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
updatePlayerList()

LogService.MessageOut:Connect(function(message, messageType)
	if messageType == Enum.MessageType.MessageError or
	   messageType == Enum.MessageType.MessageWarning or
	   messageType == Enum.MessageType.MessageInfo then

		local lowerMsg = string.lower(message)
		if string.find(lowerMsg, detectPattern) then
			local guiltyPlayer = nil
			for _, player in ipairs(activePlayers) do
				if string.find(message, player.Name, 1, true) or
				   string.find(message, tostring(player.UserId), 1, true) then
					guiltyPlayer = player
					break
				end
			end
			if guiltyPlayer then
				kickPlayer(guiltyPlayer, "SaveInstance / Decompiler / Backdoor detected")
			else
				warn("[AntiCheat] Malicious log without player match:", message)
			end
		end
	end
end)

-- ==============================================
-- 3. Client‑side reporting remote
-- ==============================================
local CLIENT_REPORT_REMOTE = "ClientReportEvent"
local reportRemote = Instance.new("RemoteEvent")
reportRemote.Name = CLIENT_REPORT_REMOTE
reportRemote.Parent = ReplicatedStorage

reportRemote.OnServerEvent:Connect(function(firingPlayer, message)
	if not firingPlayer:IsA("Player") then return end
	local lowerMsg = string.lower(message)
	if string.find(lowerMsg, detectPattern) then
		-- Only kick the reporting player if their name/ID appears in the message
		if string.find(message, firingPlayer.Name, 1, true) or
		   string.find(message, tostring(firingPlayer.UserId), 1, true) then
			kickPlayer(firingPlayer, "Client‑reported exploit log")
		end
	else
		-- Possibly a tampered report – kick anyway as a precaution
		kickPlayer(firingPlayer, "Suspicious client report")
	end
end)

-- ==============================================
-- 4. Undeletable client‑side detector
-- ==============================================
local CLIENT_SCRIPT_NAME = "UndeletableClientDetector"

-- Full source of the client LocalScript
local clientScriptSource = [[
-- Client‑side anti‑exploit detector
local Players = game:GetService("Players")
local LogService = game:GetService("LogService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local reportRemote = ReplicatedStorage:WaitForChild("ClientReportEvent")

-- Patterns from the server (must be kept in sync, but we use a subset for client)
local function escapePattern(str)
	return (str:gsub("([%(%)%.%%%+%-%*%?%[%^%$])", "%%%1"))
end

local clientRawStrings = {
	"saving game", "saveinstance", "synsaveinstance", "Saved ", "MB)", "MB to workspace",
	"Copying game", "Decompiling", "Decompiled", "decompiler", "decompiling scripts",
	"scripts decompiled", "UniversalSynSaveInstance", "Saved by UniversalSynSaveInstance",
	"Join to Copy Games", "SynSaveInstance", "EasySaveInstance", "RoSaver", "SaveInstance by",
	"Save Instance", "saving instance", "instance saved", "Instance saved to workspace",
	"Saving Instance...", "Fetching assets", "Uploading assets", "Cloning instances",
	"Workspace saved", "Game saved", "Save file", "savefile", "writefile", "readfile",
	"makefolder", "delfolder", "listfiles", "rbxl", "rbxm",
	"Infinity Yield", "IY loaded", "IY: SaveInstance", "Loaded Infinity Yield",
	"iy_saveinstance", "iy_decompile", "Dark Dex", "Dex Explorer", "dex saveinstance",
	"getscriptbytecode", "dumpstring", "getscripts", "getnilinstances", "getinstances",
	"firesignal", "hookfunction", "hookmetamethod", "getgc", "getrenv", "getgenv",
	"setthreadidentity", "getthreadidentity", "setidentity", "getidentity",
	"syn_context", "setthreadcontext", "getsenv", "getmenv", "getfenv", "setfenv",
	"newcclosure", "getrawmetatable", "setrawmetatable", "getnamecallmethod",
	"setnamecallmethod", "loadstring", "getloadedmodules",
	"synapse", "krnl", "fluxus", "solara", "wave", "scriptware", "vega x",
	"arceus x", "hydrogen", "jjsploit", "nihon", "furk ultra", "codex", "electron",
	"Unluac", "luadec", "unluac_java", "decompiler by", "decompiled successfully",
	"bytecode converter", "backdoor", "remote spy", "remote executor", "server lua",
	"injected", "bypass", "fe bypass", "filteringenabled",
}

local escapedClientStrings = {}
for _, str in ipairs(clientRawStrings) do
	escapedClientStrings[#escapedClientStrings + 1] = escapePattern(str:lower())
end
local clientDetectPattern = "(" .. table.concat(escapedClientStrings, "|") .. ")"

-- Known GUI names that saveinstance/decompiler tools create
local maliciousGuiNames = {
	"Dark Dex", "Dex", "Dex Explorer", "Synapse", "Synapse X", "Krnl",
	"Fluxus", "Solara", "Wave", "Infinity Yield", "IY", "SaveInstanceGUI",
	"Universal SaveInstance", "Save Instance", "Decompiler", "Script Dumper",
	"Remote Spy", "Backdoor", "Executor", "Admin",
}

-- Scan CoreGui and PlayerGui for malicious GUIs
local function scanForMaliciousGuis()
	local player = Players.LocalPlayer
	if not player then return end
	local playerGui = player:FindFirstChild("PlayerGui")
	local containers = {CoreGui, playerGui}
	for _, container in ipairs(containers) do
		if container then
			for _, child in ipairs(container:GetChildren()) do
				for _, badName in ipairs(maliciousGuiNames) do
					if string.find(string.lower(child.Name), string.lower(badName), 1, true) then
						return true, "Malicious GUI found: " .. child.Name
					end
				end
			end
		end
	end
	return false
end

-- Client log scanner
LogService.MessageOut:Connect(function(message, messageType)
	if messageType == Enum.MessageType.MessageError or
	   messageType == Enum.MessageType.MessageWarning or
	   messageType == Enum.MessageType.MessageInfo then

		local lowerMsg = string.lower(message)
		if string.find(lowerMsg, clientDetectPattern) then
			-- Report to server with the raw message
			reportRemote:FireServer(message)
		end
	end
end)

-- GUI scanning loop
task.spawn(function()
	while true do
		local found, reason = scanForMaliciousGuis()
		if found then
			reportRemote:FireServer(reason)
		end
		task.wait(5)
	end
end)

print("[Client AntiCheat] Undeletable detector active")
]]

-- Insert the client script into a player and ensure it cannot be removed
local function setupClientDetector(player)
	local playerGui = player:WaitForChild("PlayerGui", 5)
	if not playerGui then return end

	-- Remove any old copy and insert a fresh one
	local existing = playerGui:FindFirstChild(CLIENT_SCRIPT_NAME)
	if existing then existing:Destroy() end

	local detector = Instance.new("LocalScript")
	detector.Name = CLIENT_SCRIPT_NAME
	detector.Source = clientScriptSource
	detector.Parent = playerGui

	-- Continuous re‑injection loop (runs per player)
	task.spawn(function()
		while player and player.Parent do
			if not playerGui:FindFirstChild(CLIENT_SCRIPT_NAME) then
				warn("[AntiCheat] Client script missing for", player.Name, "- reinserting")
				local newDetector = Instance.new("LocalScript")
				newDetector.Name = CLIENT_SCRIPT_NAME
				newDetector.Source = clientScriptSource
				newDetector.Parent = playerGui
			end
			task.wait(3) -- check every 3 seconds
		end
	end)
end

-- Apply to all current and future players
Players.PlayerAdded:Connect(setupClientDetector)
for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(setupClientDetector, player)
end

print("[AntiCheat] Ultra‑aggressive server + client protection loaded (Infinity Yield + open‑source patterns)")
