util.AddNetworkString("fastdl1_dailylogin_open")

local dataPath = "fastdl1_dailylogin/players.json"

local function loadPlayerData()
    if not file.Exists(dataPath, "DATA") then
        return {}
    end

    local raw = file.Read(dataPath, "DATA")
    if not raw or raw == "" then
        return {}
    end

    local decoded = util.JSONToTable(raw)
    if not istable(decoded) then
        return {}
    end

    return decoded
end

local function savePlayerData(data)
    if not istable(data) then
        return
    end

    file.CreateDir("fastdl1_dailylogin")
    file.Write(dataPath, util.TableToJSON(data, true))
end

local function getToday()
    return os.date("%Y-%m-%d")
end

local function shouldShowDaily(player, data)
    if not IsValid(player) then
        return false
    end

    if not FASTDL1_DAILYLOGIN.Config.AutoShowOnSpawn then
        return false
    end

    local steamId = player:SteamID64()
    local today = getToday()
    local lastLogin = data[steamId]

    return lastLogin ~= today
end

local function markDaily(player, data)
    local steamId = player:SteamID64()
    data[steamId] = getToday()
    savePlayerData(data)
end

local playerData = loadPlayerData()

hook.Add("PlayerSpawn", "fastdl1_dailylogin_spawn", function(player)
    if not IsValid(player) or not player:IsPlayer() then
        return
    end

    if not shouldShowDaily(player, playerData) then
        return
    end

    markDaily(player, playerData)

    net.Start("fastdl1_dailylogin_open")
    net.Send(player)
end)

hook.Add("PlayerDisconnected", "fastdl1_dailylogin_cleanup", function(player)
    if not IsValid(player) then
        return
    end

    playerData[player:SteamID64()] = getToday()
end)
