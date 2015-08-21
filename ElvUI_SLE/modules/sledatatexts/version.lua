local E, L, V, P, G = unpack(ElvUI);
--Version datatext. Only in Russian for now.
local DT = E:GetModule('DataTexts')
local SLE = E:GetModule('SLE')
local ACD = LibStub("AceConfigDialog-3.0-ElvUI")

local displayString = '';
local lastPanel;
local self = lastPanel
local join = string.join
local AddLine = AddLine
local AddDoubleLine =AddDoubleLine
local Eversion = E.version
local format = format

local function OnEvent(self, event, ...)
	self.text:SetFormattedText(displayString, 'ElvUI v', Eversion, SLE.version);
end

local function Click()
	ElvConfigToggle:Click();
	ACD:SelectGroup("ElvUI", "sle")
end

local function OnEnter(self)
	DT:SetupTooltip(self)

	DT.tooltip:AddDoubleLine("ElvUI "..GAME_VERSION_LABEL..format(": |cff99ff33%s|r", Eversion))
	DT.tooltip:AddLine(L["SLE_AUTHOR_INFO"]..". "..GAME_VERSION_LABEL..format(": |cff99ff33%s|r", SLE.version))
	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(L['SLE_CONTACTS'])
	
	DT.tooltip:Show()
end

local function ValueColorUpdate(hex, r, g, b)
	displayString = join("", "%s", hex, "%s|r", " : Shadow & Light v", hex, "%s|r")
	
	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E['valueColorUpdateFuncs'][ValueColorUpdate] = true

DT:RegisterDatatext("Version", {'PLAYER_ENTERING_WORLD'}, OnEvent, Update, Click, OnEnter)