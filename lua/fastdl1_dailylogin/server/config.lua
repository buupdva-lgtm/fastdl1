util.AddNetworkString("fastdl1_dailylogin_config_open")
util.AddNetworkString("fastdl1_dailylogin_config_update")

local configPath = "fastdl1_dailylogin/config.json"

local function loadConfig()
    if not file.Exists(configPath, "DATA") then
        return
    end

    local raw = file.Read(configPath, "DATA")
    if not raw or raw == "" then
        return
    end

    local decoded = util.JSONToTable(raw)
    if not istable(decoded) then
        return
    end

    for key, value in pairs(decoded) do
        FASTDL1_DAILYLOGIN.Config[key] = value
    end
end

local function saveConfig()
    file.CreateDir("fastdl1_dailylogin")
    file.Write(configPath, util.TableToJSON(FASTDL1_DAILYLOGIN.Config, true))
end

local updateCooldown = {}
local updateDelay = 1
local maxTextLength = 300

local function sanitizeText(value)
    if value == nil then
        return ""
    end

    local text = tostring(value)
    if #text > maxTextLength then
        text = string.sub(text, 1, maxTextLength)
    end

    return text
end

local function sanitizeBool(value)
    return value == true
end

local function hasConfigPermission(player)
    if not IsValid(player) then
        return true
    end

    if ULib and ULib.ucl and ULib.ucl.query then
        return ULib.ucl.query(player, FASTDL1_DAILYLOGIN.Config.Permission)
    end

    return player:IsSuperAdmin()
end

if ULib and ULib.ucl and ULib.ucl.registerAccess then
    ULib.ucl.registerAccess(
        FASTDL1_DAILYLOGIN.Config.Permission,
        {"superadmin"},
        "Kann das Daily-Login Config-Menü öffnen.",
        "FastDL1 Daily Login"
    )
end

loadConfig()

concommand.Add(FASTDL1_DAILYLOGIN.Config.AdminCommand, function(player)
    if IsValid(player) and not hasConfigPermission(player) then
        player:ChatPrint("Du hast keine Berechtigung, dieses Menü zu öffnen.")
        return
    end

    net.Start("fastdl1_dailylogin_config_open")
    net.WriteString(tostring(FASTDL1_DAILYLOGIN.Config.Title or ""))
    net.WriteString(tostring(FASTDL1_DAILYLOGIN.Config.Subtitle or ""))
    net.WriteString(tostring(FASTDL1_DAILYLOGIN.Config.BodyText or ""))
    net.WriteBool(FASTDL1_DAILYLOGIN.Config.AutoShowOnSpawn == true)
    if IsValid(player) then
        net.Send(player)
    else
        net.Broadcast()
    end
end)

net.Receive("fastdl1_dailylogin_config_update", function(_, player)
    if not IsValid(player) then
        return
    end

    if not hasConfigPermission(player) then
        return
    end

    local now = CurTime()
    local nextAllowed = updateCooldown[player] or 0
    if nextAllowed > now then
        return
    end

    updateCooldown[player] = now + updateDelay

    local title = sanitizeText(net.ReadString())
    local subtitle = sanitizeText(net.ReadString())
    local body = sanitizeText(net.ReadString())
    local autoShow = sanitizeBool(net.ReadBool())

    FASTDL1_DAILYLOGIN.Config.Title = title
    FASTDL1_DAILYLOGIN.Config.Subtitle = subtitle
    FASTDL1_DAILYLOGIN.Config.BodyText = body
    FASTDL1_DAILYLOGIN.Config.AutoShowOnSpawn = autoShow

    saveConfig()
end)

hook.Add("PlayerDisconnected", "fastdl1_dailylogin_config_cleanup", function(player)
    updateCooldown[player] = nil
end)
