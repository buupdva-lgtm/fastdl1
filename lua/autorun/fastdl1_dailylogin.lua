FASTDL1_DAILYLOGIN = FASTDL1_DAILYLOGIN or {}

local basePath = "fastdl1_dailylogin/"

AddCSLuaFile(basePath .. "sh_config.lua")
AddCSLuaFile(basePath .. "cl_dailylogin.lua")
AddCSLuaFile(basePath .. "cl_config.lua")

include(basePath .. "sh_config.lua")

if SERVER then
    include(basePath .. "sv_dailylogin.lua")
    include(basePath .. "sv_config.lua")
else
    include(basePath .. "cl_dailylogin.lua")
    include(basePath .. "cl_config.lua")
end
