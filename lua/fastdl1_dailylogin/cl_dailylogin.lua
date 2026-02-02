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
    frame:SetSize(400, 220)
    frame:Center()
    frame:MakePopup()

    local subtitle = vgui.Create("DLabel", frame)
    subtitle:SetText(FASTDL1_DAILYLOGIN.Config.Subtitle)
    subtitle:SetFont("DermaLarge")
    subtitle:SizeToContents()
    subtitle:SetPos(20, 40)

    local body = vgui.Create("DLabel", frame)
    body:SetText(FASTDL1_DAILYLOGIN.Config.BodyText)
    body:SetWrap(true)
    body:SetAutoStretchVertical(true)
    body:SetWide(frame:GetWide() - 40)
    body:SetPos(20, 90)

    local closeButton = vgui.Create("DButton", frame)
    closeButton:SetText("Schließen")
    closeButton:SetSize(120, 30)
    closeButton:SetPos(frame:GetWide() - 140, frame:GetTall() - 50)
    closeButton.DoClick = function()
        frame:Close()
    end

    FASTDL1_DAILYLOGIN.DailyFrame = frame
end
