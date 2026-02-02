net.Receive("fastdl1_dailylogin_config_open", function()
    local config = {
        Title = net.ReadString(),
        Subtitle = net.ReadString(),
        BodyText = net.ReadString(),
        AutoShowOnSpawn = net.ReadBool()
    }

    FASTDL1_DAILYLOGIN.OpenConfigMenu(config)
end)

function FASTDL1_DAILYLOGIN.OpenConfigMenu(config)
    if IsValid(FASTDL1_DAILYLOGIN.ConfigFrame) then
        FASTDL1_DAILYLOGIN.ConfigFrame:Close()
    end

    local frame = vgui.Create("DFrame")
    frame:SetTitle("Daily Login - Konfiguration")
    frame:MakePopup()

    local padding = 20
    local rowHeight = 24
    local fieldWidth = 0

    local titleEntry = vgui.Create("DTextEntry", frame)
    titleEntry:SetPos(padding, 50)
    titleEntry:SetText(config.Title or "")

    local subtitleEntry = vgui.Create("DTextEntry", frame)
    subtitleEntry:SetPos(padding, 90)
    subtitleEntry:SetText(config.Subtitle or "")

    local bodyEntry = vgui.Create("DTextEntry", frame)
    bodyEntry:SetPos(padding, 130)
    bodyEntry:SetMultiline(true)
    bodyEntry:SetText(config.BodyText or "")

    local autoShow = vgui.Create("DCheckBoxLabel", frame)
    autoShow:SetText("Automatisch beim Spawn anzeigen")
    autoShow:SetValue(config.AutoShowOnSpawn and 1 or 0)
    autoShow:SizeToContents()

    local saveButton = vgui.Create("DButton", frame)
    saveButton:SetText("Speichern")
    saveButton:SetSize(120, 32)
    saveButton.DoClick = function()
        net.Start("fastdl1_dailylogin_config_update")
        net.WriteString(titleEntry:GetValue())
        net.WriteString(subtitleEntry:GetValue())
        net.WriteString(bodyEntry:GetValue())
        net.WriteBool(autoShow:GetChecked() and true or false)
        net.SendToServer()
    end

    FASTDL1_DAILYLOGIN.ConfigFrame = frame

    local function updateLayout()
        local screenW, screenH = ScrW(), ScrH()
        local frameW = math.min(math.floor(screenW * 0.6), 600)
        local frameH = math.min(math.floor(screenH * 0.6), 420)
        fieldWidth = frameW - (padding * 2)

        frame:SetSize(frameW, frameH)
        frame:Center()

        titleEntry:SetSize(fieldWidth, rowHeight)
        subtitleEntry:SetSize(fieldWidth, rowHeight)
        bodyEntry:SetSize(fieldWidth, math.max(80, frameH * 0.25))

        autoShow:SetPos(padding, math.floor(frameH * 0.65))
        saveButton:SetPos(frameW - 140, frameH - 60)
    end

    updateLayout()

    local hookId = "fastdl1_dailylogin_config_resize_" .. tostring(frame)
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
end
