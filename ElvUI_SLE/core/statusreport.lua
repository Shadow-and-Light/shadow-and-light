local SLE, T, E, L, V, P, G = unpack(select(2, ...))

local function AreOtherAddOnsEnabled()
	for i = 1, GetNumAddOns() do
        local name = GetAddOnInfo(i)

		if name ~= 'ElvUI' and name ~= 'ElvUI_OptionsUI' and name ~= "ElvUI_SLE" and name ~= "ElvUI_SLE_Dev" and E:IsAddOnEnabled(name) then --Loaded or load on demand
			return 'Yes'
		end
	end
	return 'No'
end

local function CreateStatusFrame()
    local StatusFrame = ElvUIStatusReport
    local test = StatusFrame.Section1.Content.Line1.Text:GetText();
    -- print(test)
    test = test..", |cff9482c9S&L|r"..T.format(" |cff99ff33%s|r", SLE.version)
    StatusFrame.Section1.Content.Line1.Text:SetText(test)
    -- StatusFrame.Section1.Content.Line1.Text:SetFormattedText("Versions: ElvUI |cff4beb2cv%s|r, |cff9482c9S&L|r |cff99ff33%s|r", E.version, SLE.version)
    StatusFrame.Section1.Content.Line2.Text:SetFormattedText('Other AddOns Enabled: |cff4beb2c%s|r', AreOtherAddOnsEnabled())
end

hooksecurefunc(E, "CreateStatusFrame", CreateStatusFrame)