local SLE, _, E, L = unpack(select(2, ...))
local DT = E.DataTexts

--  GLOBALS: unpack, select, format, GAME_VERSION_LABEL
local format = format
local GAME_VERSION_LABEL = GAME_VERSION_LABEL

local displayString = ''
local lastPanel

local function OnEvent(self)
	self.text:SetFormattedText(displayString, E.version, SLE.version)
	lastPanel = self
end

local function OnClick()
	E:ToggleOptions()
	E.Libs['AceConfigDialog']:SelectGroup('ElvUI', 'sle')
end

local function OnEnter(self)
	DT.tooltip:ClearLines()

	DT.tooltip:AddDoubleLine('ElvUI '..GAME_VERSION_LABEL..format(': |cff99ff33%s|r', E.version))
	DT.tooltip:AddDoubleLine('S&L '..GAME_VERSION_LABEL..format(': |cff99ff33%s|r', SLE.version))
	DT.tooltip:AddLine(' ')
	DT.tooltip:AddLine(L["SLE_CONTACTS"])

	DT.tooltip:Show()
end

local function ValueColorUpdate(hex)
	displayString = format('ElvUI v%s%s|r S&L v%s%s|r', hex, '%s', hex, '%s')

	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E['valueColorUpdateFuncs'][ValueColorUpdate] = true

DT:RegisterDatatext('Version', 'S&L', {'LOADING_SCREEN_DISABLED'}, OnEvent, nil, OnClick, OnEnter, nil, L["Version"])
