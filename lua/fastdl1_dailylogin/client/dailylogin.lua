net.Receive("fastdl1_dailylogin_open", function()
    if FASTDL1_DAILYLOGIN and FASTDL1_DAILYLOGIN.OpenDailyLogin then
        FASTDL1_DAILYLOGIN.OpenDailyLogin()
    end
end)

function FASTDL1_DAILYLOGIN.OpenDailyLogin()
    if IsValid(FASTDL1_DAILYLOGIN.DailyFrame) then
        FASTDL1_DAILYLOGIN.DailyFrame:Close()
    end

    local frame = vgui.Create("DFrame")
    frame:SetTitle(FASTDL1_DAILYLOGIN.Config.Title)
    frame:MakePopup()

    local padding = 20

    local subtitle = vgui.Create("DLabel", frame)
    subtitle:SetText(FASTDL1_DAILYLOGIN.Config.Subtitle)
    subtitle:SetFont("DermaLarge")
    subtitle:SizeToContents()
    subtitle:SetPos(padding, 40)

    local body = vgui.Create("DLabel", frame)
    body:SetText(FASTDL1_DAILYLOGIN.Config.BodyText)
    body:SetWrap(true)
    body:SetAutoStretchVertical(true)
    body:SetPos(padding, 90)

    local closeButton = vgui.Create("DButton", frame)
    closeButton:SetText("Schließen")
    closeButton:SetSize(120, 30)
    local function updateLayout()
        local screenW, screenH = ScrW(), ScrH()
        local frameW = math.min(math.floor(screenW * 0.5), 520)
        local frameH = math.min(math.floor(screenH * 0.4), 260)

        frame:SetSize(frameW, frameH)
        frame:Center()

        body:SetWide(frameW - (padding * 2))
        closeButton:SetPos(frameW - 140, frameH - 50)
    end

    updateLayout()

    local hookId = "fastdl1_dailylogin_resize_" .. tostring(frame)
    hook.Add("OnScreenSizeChanged", hookId, function()
        if not IsValid(frame) then
            hook.Remove("OnScreenSizeChanged", hookId)
            return
        end

        updateLayout()
    end)

    function frame:OnRemove()
        hook.Remove("OnScreenSizeChanged", hookId)
    end
    closeButton.DoClick = function()
        frame:Close()
    end

    FASTDL1_DAILYLOGIN.DailyFrame = frame
end
