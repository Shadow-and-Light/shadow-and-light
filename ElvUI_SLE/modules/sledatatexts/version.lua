local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule('DataTexts')
local GAME_VERSION_LABEL = GAME_VERSION_LABEL
local displayString = '';
local lastPanel;
local self = lastPanel

local function OnEvent(self, event, ...)
	self.text:SetFormattedText(displayString, 'ElvUI v', E.version, SLE.version);
end

local function Click()
	ElvConfigToggle:Click();
	SLE.ACD:SelectGroup("ElvUI", "sle")
end

local function OnEnter(self)
	DT:SetupTooltip(self)

	DT.tooltip:AddDoubleLine("ElvUI "..GAME_VERSION_LABEL..T.format(": |cff99ff33%s|r", E.version))
	DT.tooltip:AddLine(L["SLE_AUTHOR_INFO"]..". "..GAME_VERSION_LABEL..T.format(": |cff99ff33%s|r", SLE.version))
	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(L["SLE_CONTACTS"])

	DT.tooltip:Show()
end

local function ValueColorUpdate(hex, r, g, b)
	displayString = T.join("", "%s", hex, "%s|r", " : Shadow & Light v", hex, "%s|r")
	
	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E["valueColorUpdateFuncs"][ValueColorUpdate] = true

DT:RegisterDatatext("Version", {'PLAYER_ENTERING_WORLD'}, OnEvent, Update, Click, OnEnter)