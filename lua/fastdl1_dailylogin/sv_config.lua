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
    net.WriteTable(FASTDL1_DAILYLOGIN.Config)
    if IsValid(player) then
        net.Send(player)
    else
        net.Broadcast()
    end
end)

net.Receive("fastdl1_dailylogin_config_update", function(_, player)
    if IsValid(player) and not hasConfigPermission(player) then
        return
    end

    local updated = net.ReadTable()
    if not istable(updated) then
        return
    end

    for key, value in pairs(updated) do
        if FASTDL1_DAILYLOGIN.Config[key] ~= nil then
            FASTDL1_DAILYLOGIN.Config[key] = value
        end
    end

    saveConfig()
end)
