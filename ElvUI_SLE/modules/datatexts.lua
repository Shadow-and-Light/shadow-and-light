local SLE, T, E, L, V, P, G = unpack(ElvUI_SLE)
local DTP = SLE.Datatexts
local DT = E.DataTexts

--GLOBALS: ElvDB, hooksecurefunc
local format = format

--Table to remember where default Gold DT is
DTP.GoldCache = {}

--* Table of datatext panels format for S&L Guild & Friends dt
DTP.PanelStyles = {
	DEFAULT			= '%s: %s%s|r',
	DEFAULTTOTALS	= '%s: %s%s/%s|r',
	ICON			= '%s: %s%s|r',
	ICONTOTALS		= '%s: %s%s/%s|r',
	NOTEXT			= '%s%s|r',
	NOTEXTTOTALS	= '%s%s/%s|r',
}

--The hook to core DT:LoadDataTexts function
local OnLoadThrottle = true

function DTP:LoadDTHook(...)
	--Is S&L's currency dt set anywhere
	local IsCurrencyDTSelected = false
	--Wipe the table. We assume after last settings change there is no default gold DTs
	wipe(DTP.GoldCache)
	--Going through all registered datapanels
	for panelName, panel in pairs(DT.RegisteredPanels) do
		for i=1, panel.numPoints do
			--Searching for gold
			for panelName, panelSettings in pairs(DT.db.panels) do
				if panelSettings and type(panelSettings) == 'table' then --if options for panel exist and it is 2+ slot panel (2 cause DTBars exists)
					if panelName == panelName and DT.db.panels[panelName][i] and DT.db.panels[panelName][i] == 'Gold' then
						--if it is current panel and options for it exist and it is gold dt, put the location in da cache
						DTP.GoldCache[panelName] = panel.dataPanels[i]
					elseif panelName == panelName and DT.db.panels[panelName][i] and DT.db.panels[panelName][i] == 'S&L Currency' then
						--if it is current panel and options for it exist and it is s&l currency dt, set the flag to true
						IsCurrencyDTSelected = true
					end
				elseif panelSettings and type(panelSettings) == 'string' and panelSettings == 'Gold' then --if options for panel exist and it is 1 slot panel with gold dt
					if DT.db.panels[panelName] == 'Gold' and panelName == panelName then
						DTP.GoldCache[panelName] = panel.dataPanels[i]
					end
				elseif panelSettings and type(panelSettings) == 'string' and panelSettings == 'S&L Currency' then --if options for panel exist and it is 1 slot panel with s&l currency
					if DT.db.panels[panelName] == 'Gold' and panelName == panelName then
						IsCurrencyDTSelected = true
					end
				end
			end
		end
		--This should help with icons not following data panels
		-- if DTP.Names[panelName] then  E:Delay(0.1, function() Bar_OnLeave(panel, true) end) end
	end
	--Throttle for the amount of times this message is called. This func is called for every single change in DT options, so having it flood the chat is bad
	if OnLoadThrottle then
		OnLoadThrottle = false
		if IsCurrencyDTSelected then
			for panelName, datatext in pairs(DTP.GoldCache) do
				--Message about this particular panel having gold dt
				local message = format(L["SLE_DT_CURRENCY_WARNING_GOLD"], '|cff1784d1'..L[panelName]..'|r')
				SLE:Print(message, 'warning')
				--Unregister all events for this gold dt to prevent weird shit on currency
				if datatext then datatext:UnregisterAllEvents() end
			end
		end
		--1 second reset time should be enough to suppress all excessive automatic calls
		E:Delay(1, function() OnLoadThrottle = true end)
	end
end

--This deletes gold data for selected character. Called from config.
function DTP:DeleteCurrencyEntry(data)
	if ElvDB['gold'][data.realm] and ElvDB['gold'][data.realm][data.name] then
		ElvDB['gold'][data.realm][data.name] = nil
	end
	if ElvDB['class'] and ElvDB['class'][data.realm] then
		if ElvDB['class'][data.realm][data.name] then
			ElvDB['class'][data.realm][data.name] = nil
		end
	end
	if ElvDB['faction'] and ElvDB['faction'][data.realm] then
		if ElvDB['faction'][data.realm]['Alliance'][data.name] then
			ElvDB['faction'][data.realm]['Alliance'][data.name] = nil
		end
		if ElvDB['faction'][data.realm]['Horde'][data.name] then
			ElvDB['faction'][data.realm]['Horde'][data.name] = nil
		end
	end
	E.Libs['AceConfigDialog']:ConfigTableChanged(nil, 'ElvUI')
end

function DTP:PLAYER_ENTERING_WORLD(event, message)
	if event == 'PLAYER_ENTERING_WORLD' then
		if message or not ElvDB.SLEMinimize then
			ElvDB.SLEMinimize = {}  -- * Temp table friends and guild dt can use to track temp visibility states
		end
	end
end

function DTP:Initialize()
	if not SLE.initialized then return end

	DTP:RegisterEvent('PLAYER_ENTERING_WORLD')
	--Hooking to default DTs for additional features
	DTP:HookTimeDT()

	--Finishing setup for delete character gold data popup
	local popup = E.PopupDialogs['SLE_CONFIRM_DELETE_CURRENCY_CHARACTER']
	popup.OnAccept = DTP.DeleteCurrencyEntry

	--Hooking to default functions to remove gold conflicts
	hooksecurefunc(DT, 'LoadDataTexts', DTP.LoadDTHook)
end

SLE:RegisterModule(DTP:GetName())
