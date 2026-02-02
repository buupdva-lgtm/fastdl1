FASTDL1_DAILYLOGIN = FASTDL1_DAILYLOGIN or {}

local basePath = "fastdl1_dailylogin/"
local sharedPath = basePath .. "shared/"
local clientPath = basePath .. "client/"
local serverPath = basePath .. "server/"

AddCSLuaFile(sharedPath .. "config.lua")
AddCSLuaFile(clientPath .. "dailylogin.lua")
AddCSLuaFile(clientPath .. "config.lua")

include(sharedPath .. "config.lua")

if SERVER then
    include(serverPath .. "dailylogin.lua")
    include(serverPath .. "config.lua")
else
    include(clientPath .. "dailylogin.lua")
    include(clientPath .. "config.lua")
end
