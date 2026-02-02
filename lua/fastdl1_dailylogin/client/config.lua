net.Receive("fastdl1_dailylogin_config_open", function()
    local config = net.ReadTable()
    if not istable(config) then
        return
    end

    FASTDL1_DAILYLOGIN.OpenConfigMenu(config)
end)

function FASTDL1_DAILYLOGIN.OpenConfigMenu(config)
    if IsValid(FASTDL1_DAILYLOGIN.ConfigFrame) then
        FASTDL1_DAILYLOGIN.ConfigFrame:Close()
    end

    local frame = vgui.Create("DFrame")
    frame:SetTitle("Daily Login - Konfiguration")
    frame:SetSize(480, 360)
    frame:Center()
    frame:MakePopup()

    local titleEntry = vgui.Create("DTextEntry", frame)
    titleEntry:SetPos(20, 50)
    titleEntry:SetSize(440, 24)
    titleEntry:SetText(config.Title or "")

    local subtitleEntry = vgui.Create("DTextEntry", frame)
    subtitleEntry:SetPos(20, 90)
    subtitleEntry:SetSize(440, 24)
    subtitleEntry:SetText(config.Subtitle or "")

    local bodyEntry = vgui.Create("DTextEntry", frame)
    bodyEntry:SetPos(20, 130)
    bodyEntry:SetSize(440, 80)
    bodyEntry:SetMultiline(true)
    bodyEntry:SetText(config.BodyText or "")

    local autoShow = vgui.Create("DCheckBoxLabel", frame)
    autoShow:SetPos(20, 220)
    autoShow:SetText("Automatisch beim Spawn anzeigen")
    autoShow:SetValue(config.AutoShowOnSpawn and 1 or 0)
    autoShow:SizeToContents()

    local saveButton = vgui.Create("DButton", frame)
    saveButton:SetText("Speichern")
    saveButton:SetSize(120, 32)
    saveButton:SetPos(frame:GetWide() - 140, frame:GetTall() - 60)
    saveButton.DoClick = function()
        local updated = {
            Title = titleEntry:GetValue(),
            Subtitle = subtitleEntry:GetValue(),
            BodyText = bodyEntry:GetValue(),
            AutoShowOnSpawn = autoShow:GetChecked() and true or false
        }

        net.Start("fastdl1_dailylogin_config_update")
        net.WriteTable(updated)
        net.SendToServer()
    end

    FASTDL1_DAILYLOGIN.ConfigFrame = frame
end
